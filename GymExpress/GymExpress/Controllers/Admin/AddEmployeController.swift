//
//  AddEmployeController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-28.
//

import Foundation
import SwiftUI


class AddEmployeController: ObservableObject {
    var dbManager: DatabaseManager = DatabaseManager.shared
    @ObservedObject var employeController = EmployesController.shared
    @Published var name: String = ""
    @Published var last_name: String = ""
    @Published var salary: String = ""
    @Published var error: String = ""
    @Published var selectedEmployeType: EmployesType = .trainer /// Type d'employé sélectionné
    
    func isFormValidation() -> Bool{
        if name.isEmpty || last_name.isEmpty || salary.isEmpty {
            error = "Veuillez remplir tous les champs"
            return false
        } else {
            error = ""
            return true
        }
    }
    
    func addEmploye(){
        let uuid = UUID().uuidString
        let userType = getUserTypeFromEmployesType(selectedEmployeType)
        let newEmploye = UserModel(name: name, lastName: last_name, email: uuid, password: "nil", type: userType, membership: nil, salary: Double(salary))
        _ = dbManager.insertData(request: Request.createUser, params: newEmploye)
        employeController.allEmploye.append(newEmploye)
    }
}

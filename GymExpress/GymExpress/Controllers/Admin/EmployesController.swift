//
//  EmployesController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-03-12.
//

import SwiftUI

class EmployesController: ObservableObject {
    @Published var allEmploye: [UserModel] = []
    static let shared = EmployesController()
    var dbManager: DatabaseManager = DatabaseManager.shared
    
    private init() {
        loadEmployes()
    }
    
    func loadEmployes() {
        if let employes: [UserModel] = dbManager.fetchDatas(request: Request.selectAllEmploye, params: []) {
            allEmploye = employes
            print("Employés chargés: \(allEmploye.count)")
        } else {
            print("Erreur: Employés non trouvés")
        }
    }
    
    func updateEmployee(_ employee: UserModel) {
        if let index = allEmploye.firstIndex(where: { $0.id == employee.id }) {
            let salaryValue = employee.salary ?? 0.0
            let success = dbManager.updateData(
                request: Request.update(
                    table: .users,
                    columns: ["name", "last_name", "salary"],
                    condition: "WHERE id = '\(employee.id)'"
                ),
                params: [employee.name, employee.lastName, salaryValue]
            )
            
            if success {
                allEmploye[index] = employee
            }
        }
    }
    
    func deleteUser(_ user: UserModel) {
        allEmploye.remove(at: allEmploye.firstIndex(where: { $0.id == user.id })!)

        let success = dbManager.updateData(request: Request.update(table: .users, columns: ["is_deleted"], condition: "WHERE id = '\(user.id)'"), params: [true])
        if success {
            print("Delete success")
        }
    }
}

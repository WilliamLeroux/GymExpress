//
//  EmployesView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct EmployesView: View {
    @ObservedObject var controller = EmployesController.shared
    
    @State private var selectedEmployeType: EmployesType = .trainer ///< Type d'employé à afficher
    @State private var isShowEditSheet: Bool = false ///< Bool pour afficher la sheet modifier employé
    @State private var isShowAddSheet: Bool = false ///< Bool pour afficher la sheet ajouter employé
    @State private var selectedEmploye: UserModel? = nil ///< Employé selectionné dans la liste
    
    var body: some View {
        VStack {
            HStack{
                Button("Ajouter un employé") {
                }
                .buttonStyle(RoundedButtonStyle(width: 150, action: {
                    isShowAddSheet.toggle()
                }))
                Picker("", selection: $selectedEmployeType) {
                    ForEach(EmployesType.allCases, id: \.self) { employeType in
                        Text(employeType.rawValue)
                    }
                }
                .frame(width: 200)
            }
            Table(of: UserModel.self){
                TableColumn("Prénom", value: \.name)
                TableColumn("Nom", value: \.lastName)
                TableColumn("Salaire") { employe in
                    if let salary = employe.salary {
                        Text("\(salary, specifier: "%.2f") $")
                    } else {
                        Text("N/A")
                    }
                }
            } rows: {
                ForEach(controller.allEmploye.filter { $0.type == getUserTypeFromEmployesType(selectedEmployeType)}) { employe in
                    TableRow(employe)
                    .contextMenu {
                        Button("Modifier") {
                            print("DEBUG: Selected employee: \(employe.name) \(employe.lastName)")
                            selectedEmploye = employe
                            isShowEditSheet.toggle()
                        }
                        Divider()
                        Button("Supprimer", role: .destructive) {
                            selectedEmploye = employe
                            controller.deleteUser(employe)
                        }
                    }
                }
            }
 
            .sheet(isPresented: $isShowAddSheet) {
                AddEmployeSheet()
            }
            .sheet(item: $selectedEmploye) { user in
                EditEmployeSheet(
                    controller: controller,
                    user: user
                )
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
            }
        }
    }
}

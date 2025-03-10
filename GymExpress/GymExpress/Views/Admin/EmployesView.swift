//
//  EmployesView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct EmployesView: View {
    
    @State private var search: String = "" ///< Texte recherché dans la barre de recherche
    @FocusState private var isTypingSearch: Bool ///< Bool si l'utilisateur est dans le textfield recherché
    @State private var selections : Set<Employes.ID> = [] ///< Temporaire
    @State private var selectedEmployeType: EmployesType = .trainer ///< Temporaire
    
    @State private var isShowEditSheet: Bool = false ///< Bool pour afficher la sheet modifier employé
    @State private var isShowAddSheet: Bool = false ///< Bool pour afficher la sheet ajouter employé
    @State private var selectedEmploye: Employes? = nil ///< Employé selectionné dans la liste
    
    ///< Données temporaires
    @State var allEmployes = [ Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Martel", lastName: "Pascal", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
                               Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: "58000"),
    ]
    
    var body: some View {
        VStack {
            HStack{
                Button("Ajouter un employé") {
                }
                .buttonStyle(RoundedButtonStyle(width: 150, action: {
                    isShowAddSheet.toggle()
                }))
                TextFieldStyle(title: "Rechercher un employé", text: $search, isTyping: $isTypingSearch)
                    .padding(.vertical, 25)
                Picker("", selection: $selectedEmployeType) {
                    ForEach(EmployesType.allCases, id: \.self) { employeType in
                        Text(employeType.rawValue)
                    }
                }
                .frame(width: 200)
            }
            Table(of: Employes.self){
                TableColumn("Prénom", value: \.name)
                TableColumn("Nom", value: \.lastName)
                TableColumn("Salaire") { employe in
                    Text("\(employe.salary)")
                }
            } rows: {
                ForEach(allEmployes) { employe in
                    TableRow(employe)
                        .contextMenu {
                            Button("Modifier") {
                                selectedEmploye = employe
                                isShowEditSheet.toggle()
                            }
                            Divider()
                            Button("Supprimer", role: .destructive) {
                                // TODO ouvrir sheet supprimer
                            }
                        }
                }
            }
            .cornerRadius(8)
        }
        .sheet(item: $selectedEmploye) { employe in
            EditEmployeSheet(
                employe: employe,
                onSave: { updatedEmploye in
                    if let index = allEmployes.firstIndex(where: { $0.id == updatedEmploye.id }) {
                        allEmployes[index] = updatedEmploye
                    }
                })
        }
        .sheet(isPresented: $isShowAddSheet) {
            AddEmployeSheet()
        }
    }
}

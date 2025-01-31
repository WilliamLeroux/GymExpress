//
//  EmployesView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct EmployesView: View {
    
    @State private var search: String = ""
    @FocusState private var isTypingSearch: Bool
    
    var allEmployes = [ Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000),
                        Employes(id: UUID(), name: "Morin", lastName: "Nicolas", salary: 58000)
    ]
    
    var body: some View {
        VStack {
            TextFieldStyle(title: "Rechercher", text: $search, isTyping: $isTypingSearch)
            Table(allEmployes){
                TableColumn("Prénom", value: \.name)
                TableColumn("Nom", value: \.lastName)
                TableColumn("Salaire") { employe in
                    Text("\(employe.salary, specifier: "%.2f")")
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    EmployesView()
}

struct Employes: Identifiable {
    let id: UUID
    let name: String
    let lastName: String
    var salary: CGFloat
}

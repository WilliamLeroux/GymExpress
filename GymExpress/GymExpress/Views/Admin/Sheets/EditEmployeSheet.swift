//
//  EditEmployeSheet.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-03.
//

import SwiftUI

struct EditEmployeSheet: View {
    @Environment(\.dismiss) var dismiss ///< Pour revenir à la vue parente
    @State var employe: Employes ///< L'employé à modifier
    var onSave: (Employes) -> Void ///< Méthode à exécuter lors de la sauvegarde
    
    @FocusState private var isTypingSalary : Bool
    
    var body: some View {
        VStack {
            Text("Modifier un employé")
                .font(.title2)
            Text("ID : \(employe.id)")
            Text("Nom: \(employe.lastName)")
            Text("Prénom: \(employe.name)")
            
            TextFieldStyle(
                title: "Salaire",
                text: Binding(
                    get: { employe.salary },
                    set: { newValue in
                        employe.salary = newValue
                    }
                ),
                isTyping: $isTypingSalary
            )
            Button("Enregistrer") {
            }
            .buttonStyle(RoundedButtonStyle(width: 85, action: {
                onSave(employe)
                dismiss()
            }))
        }
        .padding()
    }
}

/// Strucuture temporaire 
struct Employes: Identifiable {
    let id: UUID
    var name: String
    var lastName: String
    var salary: String
}


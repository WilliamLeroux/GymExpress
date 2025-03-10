//
//  AddEmployeSheet.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-03.
//

import SwiftUI

struct AddEmployeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss /// Pour revenir en arrière
    @StateObject private var controller = AddEmployeController() /// Contrôleur de la sheet
    
    @FocusState private var isTypingName: Bool /// Vérifie si l'utilisateur est dans le textfield prénom
    @FocusState private var isTypingLastName: Bool /// Vérifie si l'utilisateur est dans le textfield nom
    @FocusState private var isTypingSalary: Bool /// Vérifie si l'utilisateur est dans le textfield salaire
    
    var body: some View {
        VStack {
            Text("Ajouter un employé")
                .fontWeight(.semibold)
                .font(.system(size: 30))
                .padding(5)
            TextFieldStyle(title: "Prénom", text: $controller.name, isTyping: $isTypingName)
                .padding(10)
            TextFieldStyle(title: "Nom", text: $controller.last_name, isTyping: $isTypingLastName)
                .padding(10)
            TextFieldStyle(title: "Salaire", text: $controller.salary, isTyping: $isTypingSalary)
                .padding(10)
            
            if !controller.error.isEmpty {
                Text(controller.error)
                    .foregroundStyle(.red)
            }
            
            Picker("", selection: $controller.selectedEmployeType) {
                ForEach(EmployesType.allCases, id: \.self) { employeType in
                    Text(employeType.rawValue)
                }
            }
            
            .frame(width: 200)
            .padding(15)
            
            HStack {
                Button("Enregistrer") {}
                    .buttonStyle(RoundedButtonStyle(width: 100, height: 50, action: {
                        if controller.isFormValidation() {
                            controller.addEmploye()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }))
                
                Button("Annuler") {
                }
                .buttonStyle(RoundedButtonStyle(width: 100, action: {
                    dismiss()
                }))
            }
        }
    }
}

#Preview {
    AddEmployeSheet()
}

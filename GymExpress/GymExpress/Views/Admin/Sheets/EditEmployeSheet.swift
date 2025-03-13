//
//  EditEmployeSheet.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-03.
//

import SwiftUI
struct EditEmployeSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var lastName: String
    @State private var salary: String
    @FocusState private var isTypingName: Bool
    @FocusState private var isTypingLastName: Bool
    @FocusState private var isTypingSalary: Bool
    @ObservedObject var controller: EmployesController
    var user: UserModel
    
    init(controller: EmployesController, user: UserModel) {
        self.controller = controller
        self.user = user
        _name = State(initialValue: user.name)
        _lastName = State(initialValue: user.lastName)
        _salary = State(initialValue: user.salary != nil ? String(format: "%.2f", user.salary!) : "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Modification de l'employé").font(.title.bold())) {
                
                HStack {
                    Text("Prénom : ")
                    TextFieldStyle(title: "", text: $name, isTyping: $isTypingName)
                }
                .padding(.leading, 20)
                .padding()
                
                HStack {
                    Text("Nom : ")
                    TextFieldStyle(title: "", text: $lastName, isTyping: $isTypingLastName)
                }
                .padding(.leading, 20)
                .padding()
                HStack {
                    Text("Salaire : ")
                    TextFieldStyle(title: "", text: $salary, isTyping: $isTypingSalary)
                }
                .padding(.leading, 20)
                .padding()
            }
            .frame(alignment: .center)
        }
        
        HStack {
            Spacer()
            
            Button("Sauvegarder") {}.buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                var updatedUser = user
                updatedUser.name = name
                updatedUser.lastName = lastName
                updatedUser.salary = Double(salary)
                controller.updateEmployee(updatedUser)
                dismiss()
            }))
            Spacer()
            Button("Annuler") {}
                .buttonStyle(RoundedButtonStyle(width: 150, height: 50, color: .red.opacity(0.8), hoveringColor: .red ,action: { dismiss() }))
            Spacer()
        }
        .padding(.top, 40)
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

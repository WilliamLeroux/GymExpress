//
//  EditClientSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct EditClientSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var controller: ClientConsultationController
    var user: UserModel
    
    @State private var name: String
    @State private var lastName: String
    @State private var email: String
    @State private var selectedMembershipGrade: MembershipGrade
    
    init(controller: ClientConsultationController, user: UserModel) {
        self.controller = controller
        self.user = user
        _name = State(initialValue: user.name)
        _lastName = State(initialValue: user.lastName)
        _email = State(initialValue: user.email)
        _selectedMembershipGrade = State(initialValue: user.membership?.grade ?? .bronze)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Informations générales")) {
                TextField("Prénom", text: $name)
                TextField("Nom", text: $lastName)
                TextField("Email", text: $email)
                
                Picker("Abonnement", selection: $selectedMembershipGrade) {
                    ForEach(MembershipGrade.allCases, id: \.self) { grade in
                        Text(grade.rawValue).tag(grade)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        
        Button("Sauvegarder") {}.buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
            var updatedUser = user
            updatedUser.name = name
            updatedUser.lastName = lastName
            updatedUser.email = email
            updatedUser.membership = MembershipData(
                grade: selectedMembershipGrade,
                count: user.membership?.count ?? 0
            )
            
            controller.updateUser(updatedUser)
            dismiss()
        }))
    }
}

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
    @State private var showErrorAlert: Bool = false
    @FocusState private var isTypingName: Bool
    @FocusState private var isTypingLastName: Bool
    @FocusState private var isTypingEmail: Bool
    
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
            Section(header: Text("Informations générales").font(.title.bold())) {
                
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
                    Text("Email : ")
                    TextFieldStyle(title: "", text: $email, isTyping: $isTypingEmail)
                }
                .padding(.leading, 20)
                .padding()
                
                HStack {
                    Text("Abonnement : ")
                    CustomPickerStyle( title: "", selection: $selectedMembershipGrade, options: MembershipGrade.allCases, defaultSelection: user.membership?.grade )
                }
                .padding(.leading, 20)
                .padding()
                
            }
            .frame(alignment: .center)
        }
        
        HStack {
            Spacer()
            
            Button("Sauvegarder") {}
                .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                    if !controller.validateFields(name: name, lastName: lastName, email: email, password: "PASSWORDBYPASS") {
                        showErrorAlert = true
                        return
                    }
                    
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
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Erreur"),
                        message: Text("Une erreur est survenue lors de la validation des champs."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            
            Spacer()
            
            Button("Annuler") {}
                .buttonStyle(RoundedButtonStyle(width: 150, height: 50, color: .red.opacity(0.8), hoveringColor: .red ,action: { dismiss() }))
            
            Spacer()
        }
        .padding(.top, 40)
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

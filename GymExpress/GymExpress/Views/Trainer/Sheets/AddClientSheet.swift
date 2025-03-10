//
//  AddClientSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddClientSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var controller: ClientConsultationController
    @State var selectedMembershipGrade: MembershipGrade
    var dbManager: DatabaseManager = DatabaseManager.shared
    @FocusState private var isTypingPrenom: Bool
    @FocusState private var isTypingNom: Bool
    @FocusState private var isTypingEmail: Bool
    @FocusState private var isTypingPwd: Bool
    
    @State private var showErrorAlert: Bool = false
    
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Page d'ajouts de clients")
                .font(.title.bold())
                .padding()
            
            TextFieldStyle(title: "Prénom", text: $name, width: 500, isTyping: $isTypingPrenom)
            
            TextFieldStyle(title: "Nom", text: $lastName, width: 500, isTyping: $isTypingNom)
            
            TextFieldStyle(title: "Email", text: $email, width: 500, isTyping: $isTypingEmail)
            
            SecureFieldStyle(title: "Mot de passe", text: $password, width: 500, isTyping: $isTypingPwd)
            
            CustomPickerStyle( title: "Abonnement", selection: $selectedMembershipGrade, options: MembershipGrade.allCases, width: 500)
            
            HStack {
                Button("Enregistrer") {}
                    .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                        if !controller.validateFields(name: name, lastName: lastName, email: email, password: password) {
                            showErrorAlert = true
                            return
                        }
                        
                        let membership = MembershipData(grade: selectedMembershipGrade)
                        let user = UserModel(name: name, lastName: lastName, email: email, password: password, type: UserType.client, membership: membership)
                        let result = controller.addUser(user)
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }))
                    .alert(isPresented: $showErrorAlert) {
                        Alert(
                            title: Text("Erreur"),
                            message: Text("Une erreur est survenue lors de la validation des champs."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
                Button("Annuler") {}
                    .buttonStyle(RoundedButtonStyle(width: 150, height: 50, color: .red.opacity(0.8), hoveringColor: .red, borderWidth: 1, action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
            }
            .padding(.top, 30)
        }
        .padding()
    }
}

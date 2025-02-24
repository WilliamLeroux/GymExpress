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
    
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("ID sélectionné : \(Utils.shared.getMembershipGradeId(membership: selectedMembershipGrade))")
                .font(.headline)
                .padding()

            TextField("Prénom", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Nom", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Mot de passe", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Picker("Abonnement", selection: $selectedMembershipGrade) {
                ForEach(MembershipGrade.allCases, id: \.self) { grade in
                    Text(grade.rawValue).tag(grade)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            // TODO: Faire les vérifications du formulaire
            
            Button("Enregistrer") {}
                .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                    let membership = MembershipData(grade: selectedMembershipGrade)
                    let user = UserModel(name: name, lastName: lastName, email: email, password: password, type: UserType.client, membership: membership)
                    let result = controller.addUser(user)
                    if result {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
        }
        .padding()
    }
}

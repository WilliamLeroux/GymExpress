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
    
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var membership: MembershipData? = nil
    
    var body: some View {
        VStack {
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
            
            Button("Enregistrer") {}
            .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                let newUser = UserModel(
                    id: Int.random(in: 1...1000),
                    name: name,
                    lastName: lastName,
                    email: email,
                    password: password,
                    type: .client,
                    membership: MembershipData(
                        grade: selectedMembershipGrade,
                        count: 0
                    ),
                    salary: nil
                )
                controller.addUser(newUser)
                presentationMode.wrappedValue.dismiss()
            }))
            .padding()
        }
        .padding()
    }
}

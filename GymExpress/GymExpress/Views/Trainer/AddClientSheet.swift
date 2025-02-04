//
//  AddClientSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddClientSheet: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var subscription: String = "Bronze"
    @State private var paymentMethod: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var allClients: [Client]
    
    var body: some View {
        VStack {
            Form {
                TextField("Prénom", text: $firstName)
                TextField("Nom", text: $lastName)
                TextField("Email", text: $email)

                Picker("Abonnement", selection: $subscription) {
                    Text("Platine").tag("Platine")
                    Text("Or").tag("Or")
                    Text("Argent").tag("Argent")
                    Text("Bronze").tag("Bronze")
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField("Méthode de paiement", text: $paymentMethod)
            }
            
            Button(action: {}) {
                Text("Ajouter")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoundedButtonStyle(width: 150, height: 40, action: {
                let newClient = Client(id: UUID(), firstName: firstName, lastName: lastName, email: email, subscription: subscription, paymentMethod: paymentMethod)
                allClients.append(newClient)
                dismiss()  
            }))
            .padding()
        }
    }
}

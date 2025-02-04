//
//  EditClientSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct EditClientSheet: View {
    var client: Client
    var onSave: (Client) -> Void
    
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var subscription: String
    @State private var paymentMethod: String
    
    @Environment(\.dismiss) var dismiss  // <-- Pour fermer la feuille
    
    init(client: Client, onSave: @escaping (Client) -> Void) {
        _firstName = State(initialValue: client.firstName)
        _lastName = State(initialValue: client.lastName)
        _email = State(initialValue: client.email)
        _subscription = State(initialValue: client.subscription)
        _paymentMethod = State(initialValue: client.paymentMethod)
        self.client = client
        self.onSave = onSave
    }
    
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
                Text("Sauvegarder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RoundedButtonStyle(width: 150, height: 40, action: {
                let updatedClient = Client(id: client.id, firstName: firstName, lastName: lastName, email: email, subscription: subscription, paymentMethod: paymentMethod)
                onSave(updatedClient)
                dismiss()
            }))
            .padding()
        }
    }
}

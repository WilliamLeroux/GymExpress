//
//  EditClientSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct EditClientSheet: View {
    
    var client: Client /// Client à éditer
    var onSave: (Client) -> Void /// Action à exécuter lors de la sauvegarde des modifications
    
    @State private var firstName: String /// Prénom du client
    @State private var lastName: String /// Nom du client
    @State private var email: String /// Email du client
    @State private var subscription: String /// Type d'abonnement du client
    @State private var paymentMethod: String /// Méthode de paiement du client
    
    @Environment(\.dismiss) var dismiss /// Environnement pour fermer la vue
    
    /// Initialise la vue avec les informations du client
    /// - Parameters:
    ///   - client: Le client à éditer
    ///   - onSave: Action à exécuter lors de la sauvegarde des modifications
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
                let updatedClient = Client(id: client.id, firstName: firstName, lastName: lastName, email: email, subscription: subscription, paymentMethod: paymentMethod, appointments: [])
                onSave(updatedClient)
                dismiss()
            }))
            .padding()
        }
    }
}

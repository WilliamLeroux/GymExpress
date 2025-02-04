//
//  ClientConsultation.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.
//

import SwiftUI

struct Client: Identifiable, Hashable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var subscription: String
    var paymentMethod: String
}

struct ClientConsultation: View {
    
    @State private var search: String = ""
    @FocusState private var isTypingSearch: Bool
    @State private var selections : Set<Client.ID> = []
    
    @State private var isShowEditSheet: Bool = false
    @State private var isShowAddSheet: Bool = false
    @State private var selectedClient: Client? = nil
    
    @State var allClients = [
        Client(id: UUID(), firstName: "Samuel", lastName: "Oliveira", email: "samuel@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire"),
        Client(id: UUID(), firstName: "Marie", lastName: "Dubois", email: "marie@example.com", subscription: "Bronze", paymentMethod: "PayPal"),
        Client(id: UUID(), firstName: "Paul", lastName: "Martin", email: "paul@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire"),
        Client(id: UUID(), firstName: "Sophie", lastName: "Lemoine", email: "sophie@example.com", subscription: "Bronze", paymentMethod: "Chèque"),
        Client(id: UUID(), firstName: "Nicolas", lastName: "Leclerc", email: "nicolas@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button("Ajouter un client") {}
                .buttonStyle(RoundedButtonStyle(width: 150, action: {
                    isShowAddSheet.toggle()
                }))
                
                TextFieldStyle(title: "Rechercher un client", text: $search, isTyping: $isTypingSearch)
                    .padding(.vertical, 25)
            }
            
            Table(of: Client.self) {
                TableColumn("Prénom", value: \.firstName)
                TableColumn("Nom", value: \.lastName)
                TableColumn("Email", value: \.email)
                TableColumn("Abonnement", value: \.subscription)
                TableColumn("Methode de paiement", value: \.paymentMethod)
            } rows: {
                ForEach(allClients) { client in
                    TableRow(client)
                        .contextMenu {
                            Button("Modifier") {
                                selectedClient = client
                                isShowEditSheet.toggle()
                            }
                            Divider()
                            Button("Supprimer", role: .destructive) {
                                // TODO: Implémenter la logique pour supprimer un client
                            }
                        }
                }
            }
            .cornerRadius(8)
        }
        .sheet(item: $selectedClient) { client in
            EditClientSheet(
                client: client,
                onSave: { updatedClient in
                    if let index = allClients.firstIndex(where: { $0.id == updatedClient.id }) {
                        allClients[index] = updatedClient
                    }
                })
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
        }
        .sheet(isPresented: $isShowAddSheet) {
            AddClientSheet(allClients: $allClients)
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
        }
    }
}

struct ClientConsultation_Previews: PreviewProvider {
    static var previews: some View {
        ClientConsultation()
    }
}

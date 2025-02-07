//
//  ClientConsultation.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.
//

import SwiftUI

struct Client: Equatable, Identifiable, Hashable {
    
    var id: UUID /// Identifiant unique du client
    var firstName: String /// Prénom du client
    var lastName: String /// Nom de famille du client
    var email: String /// Adresse email du client
    var subscription: String /// Type d'abonnement du client
    var paymentMethod: String /// Méthode de paiement du client
    var appointments: [Appointment] /// Liste des rendez-vous du client
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Appointment: Identifiable {
    var id: UUID /// Identifiant unique du rendez-vous
    var date: Date /// Date du rendez-vous
    var reason: String /// Raison du rendez-vous
}

struct ClientConsultation: View {
    
    @State private var search: String = "" /// Texte de recherche
    @FocusState private var isTypingSearch: Bool /// État du focus de la barre de recherche
    
    @State private var selectedTimeSlot: String = "" /// Créneau horaire sélectionné
    @State private var appointmentComment: String = "" /// Commentaire du rendez-vous
    
    @State private var isShowAddSheet: Bool = false /// État d'affichage de la feuille d'ajout
    @State private var selectedClientForEditing: Client? = nil /// Client sélectionné pour modification
    @State private var selectedClientForAppointment: Client? = nil /// Client sélectionné pour un rendez-vous
    @State private var selectedClientForAppointments: Client? = nil /// Client sélectionné pour voir ses rendez-vous
    @State private var appointmentDate: Date = Date() /// Date du rendez-vous
    @State private var appointmentReason: String = "" /// Raison du rendez-vous
    @State private var isShowAppointmentsSheet: Bool = false /// État d'affichage de la feuille des rendez-vous
    
    @State var allClients = [
        Client(id: UUID(), firstName: "Samuel", lastName: "Oliveira", email: "samuel@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire", appointments: []),
        Client(id: UUID(), firstName: "Marie", lastName: "Dubois", email: "marie@example.com", subscription: "Bronze", paymentMethod: "PayPal", appointments: []),
        Client(id: UUID(), firstName: "Paul", lastName: "Martin", email: "paul@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire", appointments: [])
    ] /// Liste de tous les clients
    
    var filteredClients: [Client] {
        if search.isEmpty {
            return allClients
        } else {
            return allClients.filter { client in
                client.firstName.localizedCaseInsensitiveContains(search) ||
                client.lastName.localizedCaseInsensitiveContains(search) ||
                client.email.localizedCaseInsensitiveContains(search)
            }
        }
    } /// Liste des clients filtrés selon la recherche
    
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
            HStack{
                Table(of: Client.self) {
                    TableColumn("Prénom", value: \.firstName)
                    TableColumn("Nom", value: \.lastName)
                    TableColumn("Email", value: \.email)
                    TableColumn("Abonnement", value: \.subscription)
                } rows: {
                    ForEach(filteredClients) { client in
                        TableRow(client)
                            .contextMenu {
                                Button("Créer un rendez-vous") {
                                    selectedClientForAppointment = client
                                }
                                Button("Voir les rendez-vous") {
                                    selectedClientForAppointments = client
                                }
                                Divider()
                                Button("Modifier") {
                                    selectedClientForEditing = client
                                }
                                Button("Supprimer", role: .destructive) {
                                    deleteClient(client)
                                }
                            }
                    }
                }
                .cornerRadius(8)
            }.padding(.bottom, 50)
        }
        .sheet(item: $selectedClientForEditing) { client in
            EditClientSheet(
                client: client,
                onSave: { updatedClient in
                    if let index = allClients.firstIndex(where: { $0.id == updatedClient.id }) {
                        allClients[index] = updatedClient
                    }
                    selectedClientForEditing = nil
                })
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
        }
        .sheet(item: $selectedClientForAppointment) { client in
            CreateAppointmentSheet(
                client: client,
                appointmentDate: $appointmentDate,
                selectedTimeSlot: $selectedTimeSlot,
                appointmentComment: $appointmentComment,
                availableTimeSlots: ["08:00 - 09:00", "09:30 - 10:30", "11:00 - 12:00"],
                onCreate: {
                    let newAppointment = Appointment(id: UUID(), date: appointmentDate, reason: selectedTimeSlot)
                    if let index = allClients.firstIndex(where: { $0.id == client.id }) {
                        allClients[index].appointments.append(newAppointment)
                    }
                    selectedClientForAppointment = nil
                    isShowAppointmentsSheet = false
                },
                isPresented: $isShowAppointmentsSheet
            )
        }
        .sheet(isPresented: $isShowAddSheet) {
            AddClientSheet(allClients: $allClients)
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
        }
        .sheet(item: $selectedClientForAppointments) { client in
            AppointmentsSheet(client: client, selectedClientForAppointments: $selectedClientForAppointments)
        }
    }
    
    /// Supprime un client de la liste
    private func deleteClient(_ client: Client) {
        allClients.removeAll { $0.id == client.id }
    }
}

extension Client {
    var appointmentsCount: String {
        return "\(appointments.count)"
    } /// Nombre de rendez-vous du client formaté en texte
}

struct ClientConsultation_Previews: PreviewProvider {
    static var previews: some View {
        ClientConsultation()
    }
}

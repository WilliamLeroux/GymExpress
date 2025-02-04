//
//  ClientConsultation.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.
//

import SwiftUI

struct Client: Equatable, Identifiable, Hashable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var subscription: String
    var paymentMethod: String
    var appointments: [Appointment]
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Appointment: Identifiable {
    var id: UUID
    var date: Date
    var reason: String
}

struct ClientConsultation: View {
    
    @State private var search: String = ""
    @FocusState private var isTypingSearch: Bool
    
    @State private var selectedTimeSlot: String = ""
    @State private var appointmentComment: String = ""
    
    @State private var isShowAddSheet: Bool = false
    @State private var selectedClientForEditing: Client? = nil
    @State private var selectedClientForAppointment: Client? = nil
    @State private var selectedClientForAppointments: Client? = nil
    @State private var appointmentDate: Date = Date()
    @State private var appointmentReason: String = ""
    @State private var isShowAppointmentsSheet: Bool = false
    
    @State var allClients = [
        Client(id: UUID(), firstName: "Samuel", lastName: "Oliveira", email: "samuel@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire", appointments: []),
        Client(id: UUID(), firstName: "Marie", lastName: "Dubois", email: "marie@example.com", subscription: "Bronze", paymentMethod: "PayPal", appointments: []),
        Client(id: UUID(), firstName: "Paul", lastName: "Martin", email: "paul@example.com", subscription: "Bronze", paymentMethod: "Carte bancaire", appointments: [])
    ]
    
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
    }
    
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
    }
}

struct ClientConsultation_Previews: PreviewProvider {
    static var previews: some View {
        ClientConsultation()
    }
}

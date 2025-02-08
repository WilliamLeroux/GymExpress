//
//  ClientConsultation.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.
//

import SwiftUI

struct ClientConsultation: View {
    @ObservedObject var controller = ClientConsultationController.shared
    
    @State private var search: String = "" /// Texte de recherche
    @FocusState private var isTypingSearch: Bool /// État du focus de la barre de recherche
    
    @State private var selectedTimeSlot: String = "" /// Créneau horaire sélectionné
    @State private var appointmentComment: String = "" /// Commentaire du rendez-vous
    
    @State private var isShowAddSheet: Bool = false /// État d'affichage de la feuille d'ajout
    @State private var selectedUserForEditing: UserModel? = nil /// Utilisateur sélectionné pour modification
    @State private var selectedUserForAppointment: UserModel? = nil /// Utilisateur sélectionné pour un rendez-vous
    @State private var selectedUserForAppointments: UserModel? = nil /// Utilisateur sélectionné pour voir ses rendez-vous
    @State private var appointmentDate: Date = Date() /// Date du rendez-vous
    @State private var appointmentReason: String = "" /// Raison du rendez-vous
    @State private var isShowAppointmentSheet: Bool = false /// État d'affichage de la feuille des rendez-vous
    
    var body: some View {
        VStack {
            HStack {
                Button("Ajouter un client") {}
                    .buttonStyle(RoundedButtonStyle(width: 150, action: {
                        isShowAddSheet.toggle()
                    }))
                
                TextFieldStyle(title: "Rechercher un client", text: $controller.search, isTyping: $isTypingSearch)
                    .padding(.vertical, 25)
            }
            HStack {
                Table(of: UserModel.self) {
                    TableColumn("Prénom", value: \.name)
                    TableColumn("Nom", value: \.lastName)
                    TableColumn("Email", value: \.email)
                    TableColumn("Abonnement") { user in
                        Text(user.membership?.grade.rawValue ?? "Aucun")
                    }
                } rows: {
                    ForEach(controller.filteredUsers) { user in
                        TableRow(user)
                            .contextMenu {
                                Button("Créer un rendez-vous") {
                                    selectedUserForAppointment = user
                                }
                                Button("Voir les rendez-vous") {
                                    selectedUserForAppointments = user
                                }
                                Divider()
                                Button("Modifier") {
                                    selectedUserForEditing = user
                                }
                                Button("Supprimer", role: .destructive) {
                                    controller.deleteUser(user)
                                }
                            }
                    }
                }
                .cornerRadius(8)
            }.padding(.bottom, 50)
        }
        .sheet(item: $selectedUserForEditing) { user in
            EditClientSheet(
                controller: controller,
                user: user
            )
            .frame(minWidth: 500, minHeight: 300)
            .padding(.all, 20)
        }
        .sheet(item: $selectedUserForAppointment) { user in
            CreateAppointmentSheet(
                controller: controller,
                client: user,
                appointmentDate: $appointmentDate,
                selectedTimeSlot: $selectedTimeSlot,
                appointmentComment: $appointmentComment
            )
        }
        .sheet(isPresented: $isShowAddSheet) {
            AddClientSheet(controller: controller, selectedMembershipGrade: MembershipGrade.bronze)
                .frame(minWidth: 500, minHeight: 300)
                .padding(.all, 20)
        }
        .sheet(item: $selectedUserForAppointments) { user in
            AppointmentsSheet(
                controller: controller,
                user: user
            )
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

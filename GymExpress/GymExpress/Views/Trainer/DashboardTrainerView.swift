//
//  DashboardTrainerView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct DashboardTrainerView: View {
    
    @ObservedObject private var navController = NavigationController.shared /// Controlleur de navigation
    @ObservedObject private var dashboardController = DashBoardTrainerController.shared /// Controlleur du Dashboard pour le Trainer
    
    var body: some View {
        NavigationStack {
            Grid {
                GridRow() {
                    VStack{
                        HStack{
                            smallBox(title: "Planning Edit", view:
                                        Image(.planning)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemTrainer.planTrainingPlan.rawValue
                            } // CRUD du plan d'entraînement du client
                            )
                            smallBox(title: "Espace client", view:
                                        Image(.client)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemTrainer.clientConsultation.rawValue
                            } // Consulter les informations du client, Listes des clients
                            )
                        }
                        .frame(width: 400)
                        
                        
                        HStack(){
                            smallBox(title: "Horraire", view:
                                        Image(.appointment)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemTrainer.scheduleTrainer.rawValue
                            } // Modifier sa plage horaire
                            )
                        }
                        .frame(width: 410, alignment: .leading)
                    }
                    mediumBox(
                        title: "Liste client du jour",
                        view: ScrollView {
                            VStack(alignment: .leading, spacing: 2) {
                                if dashboardController.appointmentsWithClientInfo.isEmpty {
                                    Text("Aucun rendez-vous aujourd'hui")
                                        .foregroundColor(.gray)
                                        .italic()
                                        .padding()
                                } else {
                                    ForEach(dashboardController.appointmentsWithClientInfo, id: \.appointment.id) { appointmentInfo in
                                        VStack(alignment: .leading) {
                                            Text("\(appointmentInfo.nom) \(appointmentInfo.prenom)")
                                                .font(.headline)
                                            
                                            if let appointmentDate = appointmentInfo.appointment.date {
                                                Text("Date: \(DateUtils.shared.formatterSimpleDate.string(from: appointmentDate))")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("Date inconnue")
                                                    .font(.subheadline)
                                                    .foregroundColor(.red)
                                            }
                                            
                                            Text("Description: \(appointmentInfo.appointment.description)")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            if let description = appointmentInfo.description, !description.isEmpty {
                                                Text("Notes: \(description)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            Divider()
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10))
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 2, trailing: 20))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                            .frame(height: 350)
                    )
                }
                .onAppear {
                    dashboardController.fetchAllAppointments()
                }
            }
        }
    }
}

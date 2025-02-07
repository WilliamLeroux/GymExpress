//
//  DashboardTrainerView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct DashboardTrainerView: View {
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
                            } // CRUD du plan d'entraînement du client
                            )
                            smallBox(title: "Espace client", view:
                                        Image(.client)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60)
                            )
                        }
                        .frame(width: 400)
                        // Consulter les informations du client, Listes des clients
                        
                        HStack(){
                            smallBox(title: "Horraire", view:
                                        Image(.appointment)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60)
                            ) // Modifier sa plage horaire
                            
                            smallBox(title: "CRUD Appointement", view:
                                        Image(.clientAppointment)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60)
                            ) // CRUD Appointment Client
                        }
                        .frame(width: 410, alignment: .leading)
                    }
                    mediumBox(title: "Liste client du jour", view: Text("Liste client du jour, liste a point avec heure de depart"))
                }
                GridRow {
                    longBox(title: "Horraire de la semaine", view: Text("Jour par jours, bloc d'heure."))
                }
                .gridCellColumns(3)
            }
        }
    }
}
#Preview {
    RootNavigation()
}

//
//  DashboardTrainerView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct DashboardTrainerView: View {
    
    private var navController = NavigationController.shared /// Controlleur de navigation

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

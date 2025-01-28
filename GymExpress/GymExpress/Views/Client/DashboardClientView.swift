//
//  DashboardClientView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct DashboardClientView: View {
    var body: some View {
        Grid(horizontalSpacing: 5, verticalSpacing: 5) {
            GridRow() {
                VStack(spacing: 5){
                    HStack(spacing: 5){
                        smallBox(title: "Progrès", view:
                                    Image(.progress)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.60)
                        )
                        smallBox(title: "Gérer mon abonnement", view:
                                    Image(.subscription)
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(0.60)
                        )
                    }
                    .frame(width: 200)
                    
                    HStack(){
                        smallBox(title: "Rendez-vous", view:
                                    Image(.appointment)
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(0.60)
                        )
                    }
                    .frame(width: 205, alignment: .leading)
                    
                    
                }
                mediumBox(title: "Plan d'entraînement", view: Text("Allo"))
            }
            GridRow {
                longBox(title: "Fréquence d'entraînement", view: Text("allo"))
            }
            .gridCellColumns(3)
        }
        
    }
}
#Preview {
    RootNavigation()
}

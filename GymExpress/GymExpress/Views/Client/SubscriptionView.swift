//
//  SubscriptionView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        GroupBox {
            Grid(verticalSpacing: 10) {
                GridRow {
                    mediumBox(title: "abonnement", view:
                                Text("")
                    )
                    
                    mediumBox(title: "abonnement", view:
                                Text("")
                    )
                    
                    Button(action: {}) {
                        Text("Ripple")
                    }
                    .buttonStyle(RoundedButtonStyle(
                        width: 50,
                        height: 50,
                        action: {
                            
                        }
                    ))
                }
                
                GridRow {
                    mediumBox(title: "abonnement", view:
                                Text("")
                    )
                   
                    mediumBox(title: "abonnement", view:
                                Text("")
                    )
                    
                }
            }
        }
        .frame(width: 500)
        .groupBoxStyle(WorkoutBoxStyle())
        //.background(Color.white)
        .cornerRadius(15)
        .padding()
    }
}

#Preview {
    RootNavigation()
}

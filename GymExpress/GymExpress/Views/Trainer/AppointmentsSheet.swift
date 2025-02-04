//
//  AppointmentsSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AppointmentsSheet: View {
    var client: Client
    @Binding var selectedClientForAppointments: Client?
    
    var body: some View {
        VStack {
            Text("Rendez-vous de \(client.firstName) \(client.lastName)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            if client.appointments.isEmpty {
                Text("Aucun rendez-vous trouvé")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(client.appointments) { appointment in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(appointment.date, style: .date)
                            .font(.headline)
                        Text("Raison : \(appointment.reason)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Fermer")
                    .font(.headline)
            }
            .buttonStyle(RoundedButtonStyle(width: 100, height: 40, action: {
                selectedClientForAppointments = nil
            }))
            .padding(.bottom, 20)

            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 400, minHeight: 300)
    }
}

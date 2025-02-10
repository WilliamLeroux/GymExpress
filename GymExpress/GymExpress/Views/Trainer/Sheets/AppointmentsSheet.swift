//
//  AppointmentsSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AppointmentsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var controller: ClientConsultationController
    var user: UserModel
    
    var body: some View {
        VStack {
            Text("Rendez-vous de \(user.name) \(user.lastName)")
                .font(.headline)
                .padding()
            
            ScrollView {
                VStack {
                    ForEach(controller.getAppointments(for: user.id)) { appointment in
                        VStack(alignment: .leading) {
                            Text("Date: \(formattedDate(appointment.date ?? Date()))")
                            Text("Description: \(appointment.description)")
                        }
                        .frame(minWidth: 250)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }

            Button("Fermer") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

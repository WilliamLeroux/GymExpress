//
//  CreateAppointmentSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct CreateAppointmentSheet: View {
    
    var client: Client /// Client pour lequel le rendez-vous est créé
    @Binding var appointmentDate: Date /// Date sélectionnée pour le rendez-vous
    @Binding var selectedTimeSlot: String /// Plage horaire sélectionnée
    @Binding var appointmentComment: String /// Commentaire du rendez-vous
    var availableTimeSlots: [String] /// Liste des plages horaires disponibles
    var onCreate: () -> Void /// Action à exécuter lors de la création du rendez-vous
    @Binding var isPresented: Bool /// État de présentation de la vue

    var body: some View {
        VStack {
            Spacer()

            Form {
                VStack(alignment: .center) {
                    DatePicker("Date du rendez-vous", selection: $appointmentDate, displayedComponents: .date)
                        .frame(maxWidth: .infinity)
                
                    Picker("Plage horaire", selection: $selectedTimeSlot) {
                        ForEach(availableTimeSlots, id: \.self) { slot in
                            Text(slot)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                
                    TextField("Commentaire", text: $appointmentComment, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 60)
                        .frame(maxWidth: .infinity)
                }
            }
            
            Button("Créer Rendez-vous") {}
            .buttonStyle(RoundedButtonStyle(width: 180, height: 45, action: {
                onCreate()
                isPresented = false
            }))
            .padding()
            
            Spacer()
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
    }
}

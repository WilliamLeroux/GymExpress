//
//  CreateAppointmentSheet.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct CreateAppointmentSheet: View {
    @ObservedObject var controller: ClientConsultationController
    var client: UserModel
    @Binding var appointmentDate: Date
    @Binding var selectedTimeSlot: String
    @Binding var appointmentComment: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Spacer()

            Form {
                VStack(alignment: .center) {
                    DatePicker("Date du rendez-vous", selection: $appointmentDate, displayedComponents: .date)
                        .frame(maxWidth: .infinity)
                
                    Picker("Plage horaire", selection: $selectedTimeSlot) {
                        ForEach(controller.getAvailableTimeSlots(for: appointmentDate), id: \.self) { slot in
                            Text(slot).tag(slot)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        let availableSlots = controller.getAvailableTimeSlots(for: appointmentDate)
                        if selectedTimeSlot.isEmpty, let firstSlot = availableSlots.first {
                            selectedTimeSlot = firstSlot
                        }
                    }
                
                    TextField("Commentaire", text: $appointmentComment, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 60)
                        .frame(maxWidth: .infinity)
                }
            }
            
            Button("Créer Rendez-vous") {}
                .buttonStyle(RoundedButtonStyle(width: 180, height: 45, action: {
                    controller.createAppointment(
                        clientId: client.id,
                        trainerId: 1,
                        name: selectedTimeSlot,
                        description: appointmentComment,
                        date: appointmentDate
                    )
                    
                    appointmentDate = Date()
                    appointmentComment = ""
                    
                    let availableSlots = controller.getAvailableTimeSlots(for: appointmentDate)
                    if let firstSlot = availableSlots.first {
                        selectedTimeSlot = firstSlot
                    } else {
                        selectedTimeSlot = ""
                    }

                    dismiss()
                }))
                .padding()
            
            Spacer()
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
    }
}

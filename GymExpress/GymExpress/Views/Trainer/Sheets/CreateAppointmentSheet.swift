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
    @FocusState private var isTypingComment: Bool

    var body: some View {
        VStack {
            Spacer()

            Form {
                VStack(alignment: .center) {
                    DatePicker("Date du rendez-vous", selection: $appointmentDate, displayedComponents: .date)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height: 20)

                    Section(header: Text("Plage horaire").font(.title3.bold()).frame(maxWidth: .infinity, alignment: .center)) {
                        CustomPickerStyle(
                            title: "",
                            selection: $selectedTimeSlot,
                            options: controller.getAvailableTimeSlots(for: appointmentDate),
                            width: 350,
                            colorStroke: Color.main
                        )
                        .onAppear {
                            let availableSlots = controller.getAvailableTimeSlots(for: appointmentDate)
                            if selectedTimeSlot.isEmpty, let firstSlot = availableSlots.first {
                                selectedTimeSlot = firstSlot
                            }
                        }
                    }

                    Spacer().frame(height: 20)
                
                    Section(header: Text("Commentaire").font(.title3.bold()).frame(maxWidth: .infinity, alignment: .center)) {
                        TextFieldStyle(title: "", text: $appointmentComment, isTyping: $isTypingComment)
                            .frame(minHeight: 60)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            
            HStack {
                Spacer()
                
                Button("Créer Rendez-vous") {}
                    .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
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
                
                Button("Annuler") {}
                    .buttonStyle(RoundedButtonStyle(width: 150, height: 50, color: .red.opacity(0.8), hoveringColor: .red ,action: { dismiss() }))
                
                Spacer()
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
    }
}

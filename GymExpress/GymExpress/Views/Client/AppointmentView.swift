//
//  AppointmentView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct AppointmentView: View {
    @ObservedObject var controller = AppointmentController.shared
    @State private var deleteAlert: Bool = false /// Booléen signifiant si l'alerte est affichée
    @State private var editAlert: Bool = false /// Booléen signifiant si l'alerte de modification est affichée
    @State private var selectedDate: Date = Date() /// Nouvelle date pour le rendez-vous sélectionné
    @State private var selectedTime: Date = Date() /// Nouvelle heure pour le rendez-vous sélectionné
    
    var body: some View {
        GroupBox {
            // TODO: Bouton rafraichir la page
            Button(action: {}) {
                Label("Rafraîchir", systemImage: "refresh")
            }
            
            List {
                ForEach(0..<controller.appointments.count, id: \.self) { appointment in
                    GroupBox(label: Text(controller.appointments[appointment].name)) {
                        HStack {
                            VStack {
                                Text(controller.appointments[appointment].description)
                                Text("\(controller.getTrainerName(trainerId: controller.appointments[appointment].trainerId))")
                                    .font(.caption2)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                Button(action: {}) {
                                    Image(systemName: "pencil")
                                }
                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, action: {
                                    controller.selectedEditIndex = appointment
                                }))
                                
                                Button(action: {}) {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: Color.red, hoveringColor: Color.red.opacity(0.8), action: {
                                    controller.selectedIndex = appointment
                                }))
                                
                            }
                        }
                        
                    }
                    .groupBoxStyle(WorkoutBoxStyle())
                }
            }
            .onChange(of: controller.selectedIndex) {
                if controller.selectedIndex != -1 {
                    deleteAlert = true
                }
            }
            .onChange(of: controller.selectedEditIndex){
                if controller.selectedEditIndex != -1 {
                    editAlert.toggle()
                }
            }
            .sheet(isPresented: $deleteAlert) { // Sheet confirmation pour annuler un rendez-vous
                ConfirmationSheet(
                    title: "Annulation",
                    message: "Voulez-vous vraiment annuler \(controller.appointments[controller.selectedIndex].name) ?",
                    cancelAction: {
                        controller.selectedIndex = -1
                        deleteAlert = false}
                    ,
                    confirmAction: {
                        controller.deleteAppointment()
                        controller.selectedIndex = -1
                        deleteAlert = false
                    }
                )
            }
            .sheet(isPresented: $editAlert) { // Sheet pour la modification de rendez-vous
                VStack {
                    Text("Modification du rendez-vous: ")
                        .font(.title)
                    Text("\(controller.appointments[controller.selectedEditIndex].name)")
                        .font(.title2)
                    
                    Text("Modification de la date:")
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        in: DateUtils.shared.getDateRange(),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    
                    DatePicker(
                        "",
                        selection: $selectedTime,
                        in: DateUtils.shared.getTimeRange(),
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.stepperField)
                    Text("Date: \(selectedDate.description.split(separator: " ")[0]) - Heure: \(selectedTime.description.split(separator: " ")[1])")
                    HStack {
                        Button(action: {}) {
                            Text("Retour")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 85,
                            height: 40,
                            action: {
                                controller.selectedEditIndex = -1
                                editAlert.toggle()
                            }
                        ))
                        
                        Button(action: {}) {
                            Text("Sauvegarder")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 85,
                            height: 40,
                            action: {
                                controller.selectedEditIndex = -1
                                editAlert.toggle()
                                // Ajouter la sauvegarde
                            }
                        ))
                    }
                }
                .padding(20)
            }
        }
    }
}


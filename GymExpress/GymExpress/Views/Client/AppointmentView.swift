//
//  AppointmentView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct AppointmentView: View {
    @ObservedObject var controller = AppointmentController.shared
    @State private var appointmentList: [String] = ["1", "2", "3", "4", "5"] // Changer pour le model
    @State private var descList: [String] = ["allo", "allo", "allo", "allo", "allo"] // Changer pour le model
    @State private var trainerList: [String] = ["trainer1", "trainer2", "trainer3", "trainer4", "trainer5"] // Changer pour le model
    @State private var deleteAlert: Bool = false /// Booléen signifiant si l'alerte est affichée
    @State private var editAlert: Bool = false /// Booléen signifiant si l'alerte de modification est affichée
    @State private var selectedIndex: Int = -1 /// Rendez-vous sélectionné pour la suppression
    @State private var selectedEditIndex: Int = -1 /// Rendez-vous sélectionné pour la modification
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
                                    selectedEditIndex = appointment
                                }))
                                
                                Button(action: {}) {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: Color.red, hoveringColor: Color.red.opacity(0.8), action: {
                                    selectedIndex = appointment
                                }))
                                
                            }
                        }
                        
                    }
                    .groupBoxStyle(WorkoutBoxStyle())
                }
            }
            .onChange(of: selectedIndex) {
                if selectedIndex != -1 {
                    deleteAlert = true
                }
            }
            .onChange(of: selectedEditIndex){
                if selectedEditIndex != -1 {
                    editAlert.toggle()
                }
            }
            .sheet(isPresented: $deleteAlert) { // Sheet confirmation pour annuler un rendez-vous
                ConfirmationSheet(
                    title: "Annulation",
                    message: "Voulez-vous vraiment annuler \(appointmentList[selectedIndex]) ?",
                    cancelAction: {
                        selectedIndex = -1
                        deleteAlert = false}
                    ,
                    confirmAction: {
                        selectedIndex = -1
                        deleteAlert = false
                        // Ajouter suppresion
                    }
                )
            }
            .sheet(isPresented: $editAlert) { // Sheet pour la modification de rendez-vous
                VStack {
                    Text("Modification du rendez-vous: ")
                        .font(.title)
                    Text("\(appointmentList[selectedEditIndex])")
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
                                selectedEditIndex = -1
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
                                selectedEditIndex = -1
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


//
//  AppointmentView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct AppointmentView: View {
    @State private var appointmentList: [String] = ["1", "2", "3", "4", "5"]
    @State private var descList: [String] = ["allo", "allo", "allo", "allo", "allo"]
    @State private var deleteAlert: Bool = false
    @State private var editAlert: Bool = false
    @State private var selectedIndex: Int = -1
    @State private var selectedEditIndex: Int = -1
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        GroupBox {
            List {
                ForEach(0..<appointmentList.count, id: \.self) { appointment in
                    GroupBox(label: Text(appointmentList[appointment])) {
                        HStack {
                            Text(descList[appointment])
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
                VStack {
                    Text("Annulation")
                        .font(.title)
                    
                    Text("Voulez-vous vraiment annuler \(appointmentList[selectedIndex]) ?")
                    HStack {
                        Button(action: {}){
                            Text("Annuler")
                        }
                        .buttonStyle(RoundedButtonStyle(width: 75, height: 40, color: Color.main, hoveringColor: Color.green, action: {
                            selectedIndex = -1
                            deleteAlert = false
                        }))
                        
                        Button(action: {}){
                            Text("Confirmer")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 75,
                            height: 40,
                            color: Color.red,
                            hoveringColor: Color.red.opacity(0.8),
                            action: {
                                selectedIndex = -1
                                deleteAlert = false
                                // Ajouter la suppression
                            })
                        )
                    }
                }
                .padding(20)
            }
            .sheet(isPresented: $editAlert) { // Sheet pour la modification de rendez-vous
                VStack {
                    Text("Modification du rendez-vous: ")
                        .font(.title)
                    Text("\(appointmentList[selectedEditIndex])")
                        .font(.title2)
                    
                    Text("Modification de la date:")
                    DatePicker(
                        "Rendez-vous",
                        selection: $selectedDate,
                        in: DateUtils.shared.getDateRange(),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.automatic)
                    HStack {
                        Button(action: {}) {
                            Text("Annuler")
                        }
                        .buttonStyle(RoundedButtonStyle(
                            width: 80,
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
                            width: 80,
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

#Preview {
    RootNavigation()
}

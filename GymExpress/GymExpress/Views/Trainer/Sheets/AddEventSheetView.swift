//
//  AddEventSheetView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddEventSheetView: View {
    @Binding var isPresented: Bool /// État de présentation de la vue
    var dateDay: Date /// Jour de début
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
    @State private var isRecurring = false /// Indique si l'événement est récurrent
    @State private var recurrenceType = "Toutes les semaines" /// Type de récurrence de l'événement
    @State private var eventTitle = "" /// Titre de l'événement
    
    let minTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
    let maxTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
    
    var minTimeEnd: Date {
        return Calendar.current.date(byAdding: .minute, value: 30, to: startTime) ?? startTime
    }
    let recurrenceOptions = ["Tous les jours", "Toutes les semaines", "Tous les mois"] /// Options de récurrence disponibles
    
    let recurrenceMapping: [String: RecurrenceType] = [
        "Tous les jours": .daily,
        "Toutes les semaines": .weekly,
        "Tous les mois": .monthly
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack {
                        Section(header: Text("Titre de l'événement").frame(maxWidth: .infinity, alignment: .center)) {
                            TextField("", text: $eventTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 2)
                        }
                        
                        Section(header: Text("Heure de l'événement").frame(maxWidth: .infinity, alignment: .center)) {
                            DatePicker("Début", selection: $startTime, in: minTime...maxTime, displayedComponents: .hourAndMinute)
                                .onChange(of: startTime) { oldStartTime, newStartTime in
                                    if endTime < newStartTime {
                                        endTime = Calendar.current.date(byAdding: .minute, value: 30, to: newStartTime)!
                                    }
                                }
                            DatePicker("Fin", selection: $endTime, in: minTimeEnd...maxTime, displayedComponents: .hourAndMinute)
                        }
                        
                        Section(header: Text("Récurrence").frame(maxWidth: .infinity, alignment: .center)) {
                            Toggle("Récurrent", isOn: $isRecurring)
                            if isRecurring {
                                Picker("", selection: $recurrenceType) {
                                    ForEach(recurrenceOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button("Annuler") {}
                                .buttonStyle(RoundedButtonStyle(width: 100, height: 40, action: {
                                    isPresented = false
                                }))
                            
                            Spacer()
                            
                            Button("Ajouter") {}
                                .buttonStyle(RoundedButtonStyle(width: 100, height: 40, action: {
                                    let recurrenceEnum = isRecurring ? (recurrenceMapping[recurrenceType] ?? .none) : .none
                                    let newEvent = CalendarEvent(
                                        id: UUID().hashValue,
                                        title: eventTitle,
                                        startDate: startTime,
                                        endDate: endTime,
                                        recurrenceType: recurrenceEnum
                                    )
                                    ScheduleTrainerController.shared.addEvent(event: newEvent, startDate: dateDay)
                                    isPresented = false
                                }))
                            
                            Spacer()
                        }
                        .frame(alignment: .center)
                        .padding(.top, 75)
                        .padding()
                        .background(Color.clear)
                    }
                    .frame(alignment: .center)
                    .background(Color.clear)
                }
                .navigationTitle("Nouvel événement")
                .frame(height: 350)
                .background(Color.white)
            }
            .padding(.all, 20)
            .frame(height: 400)
            .presentationDetents([.height(400)])
            .interactiveDismissDisabled(true)
            .background(Color.white)
        }
        .onAppear {
            startTime = dateDay
            print(startTime.debugDescription)
        }
    }
}

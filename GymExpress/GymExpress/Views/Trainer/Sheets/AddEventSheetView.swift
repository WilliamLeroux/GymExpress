//
//  AddEventSheetView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddEventSheetView: View {
    @Binding var isPresented: Bool /// État de présentation de la vue
    @State private var startTime = Date() /// Heure de début de l'événement
    @State private var endTime = Date() /// Heure de fin de l'événement
    @State private var isRecurring = false /// Indique si l'événement est récurrent
    @State private var recurrenceType = "Toutes les semaines" /// Type de récurrence de l'événement
    @State private var eventTitle = "" /// Titre de l'événement
    
    let minTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
    let maxTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
    
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
                            DatePicker("Fin", selection: $endTime, in: minTime...maxTime, displayedComponents: .hourAndMinute)
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
                                    ScheduleTrainerController.shared.addEvent(event: newEvent)
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
    }
}

struct AddEventSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventSheetView(isPresented: Binding.constant(true))
    }
}

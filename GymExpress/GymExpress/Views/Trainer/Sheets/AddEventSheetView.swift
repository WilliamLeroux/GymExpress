//
//  AddEventSheetView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-04.
//

import SwiftUI

struct AddEventSheetView: View {
    @Binding var isPresented: Bool /// État de présentation de la vue (détermine si la feuille modale est affichée)
    var dateDay: Date /// Jour sélectionné pour l'événement
    
    @State private var startTime = Date() /// Heure de début de l'événement (initialisée à l'heure actuelle)
    @State private var endTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date())! /// Heure de fin de l'événement (par défaut, 30 minutes après le début)
    
    @State private var isRecurring = false /// Indique si l'événement est récurrent
    @State private var recurrenceType = RecurrenceType.none /// Type de récurrence de l'événement (aucune, quotidienne, hebdomadaire, etc.)
    
    @State private var eventTitle = "" /// Titre de l'événement saisi par l'utilisateur
    @FocusState private var isTypingEventTitle: Bool
    @State private var showAlert = false
    
    let minTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())! /// Heure minimale autorisée pour le début de l'événement (06:00)
    let maxTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())! /// Heure maximale autorisée pour la fin de l'événement (22:00)
    
    let maxTimeOfStart = Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: Date())! /// Dernière heure possible pour commencer un événement (21:00)
    
    /// Heure minimale de fin d'événement (au moins 60 minutes après l'heure de début)
    var minTimeEnd: Date {
        return Calendar.current.date(byAdding: .minute, value: 60, to: startTime) ?? startTime
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack {
                        Spacer()
                        
                        Section(header: Text("Titre de l'événement").font(.title2.bold()).frame(maxWidth: .infinity, alignment: .center)) {
                            TextFieldStyle(title: "", text: $eventTitle, width: 250, isTyping: $isTypingEventTitle)
                                .padding(.top, 2)
                        }
                        
                        Section(header: Text("Heure de l'événement").font(.title2.bold()).frame(maxWidth: .infinity, alignment: .center)) {
                            DatePicker("Début", selection: $startTime, in: minTime...maxTimeOfStart, displayedComponents: .hourAndMinute)
                                .onChange(of: startTime) { _, newStartTime in
                                    let roundedStartTime = roundToNearestHalfHour(date: newStartTime)
                                    startTime = roundedStartTime
                                    
                                    if endTime < minTimeEnd {
                                        endTime = minTimeEnd
                                    } else {
                                        endTime = roundToNearestHalfHour(date: endTime)
                                    }
                                }
                            
                            DatePicker("Fin", selection: $endTime, in: minTimeEnd...maxTime, displayedComponents: .hourAndMinute)
                                .onChange(of: endTime) { _, newEndTime in
                                    endTime = roundToNearestHalfHour(date: newEndTime)
                                }
                        }
                        
                        Section(header: Text("Récurrence").frame(maxWidth: .infinity, alignment: .center)) {
                            Toggle("Récurrent", isOn: $isRecurring)
                            if isRecurring {CustomSegmentedPickerStyle(title: "", selection: $recurrenceType, options: RecurrenceType.allCases, colorStroke: Color.main )
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button("Ajouter") {}
                                .buttonStyle(RoundedButtonStyle(width: 150, height: 50, action: {
                                    guard !eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                        showAlert = true
                                        return
                                    }
                                    
                                    let calendar = Calendar.current
                                    
                                    let components = calendar.dateComponents([.year, .month, .day], from: dateDay)
                                    
                                    var startComponents = components
                                    startComponents.hour = calendar.component(.hour, from: startTime)
                                    startComponents.minute = calendar.component(.minute, from: startTime)
                                    
                                    var endComponents = components
                                    endComponents.hour = calendar.component(.hour, from: endTime)
                                    endComponents.minute = calendar.component(.minute, from: endTime)
                                    
                                    guard let startDate = calendar.date(from: startComponents),
                                          let endDate = calendar.date(from: endComponents) else {
                                        return
                                    }
                                    
                                    let newEvent = CalendarEvent(
                                        startDate: startDate,
                                        endDate: endDate,
                                        title: eventTitle,
                                        recurrenceType: recurrenceType
                                    )
                                    ScheduleTrainerController.shared.addEvent(event: newEvent, startDate: startDate)
                                    isPresented = false
                                }))
                                .alert("Erreur", isPresented: $showAlert) {
                                    Button("OK", role: .cancel) {}
                                } message: {
                                    Text("Veuillez remplir tous les champs.")
                                }
                            
                            Spacer()
                            
                            Button("Annuler") {}
                                .buttonStyle(RoundedButtonStyle(width: 150, height: 50,color: .red.opacity(0.8), hoveringColor: .red, action: {
                                    isPresented = false
                                }))
                            
                            Spacer()
                        }
                        .frame(alignment: .center)
                        .padding()
                        .background(Color.clear)
                    }
                    .padding(.top, 20)
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
    
    func roundToNearestHalfHour(date: Date) -> Date {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let remainder = minutes % 30
        let adjustment = remainder < 15 ? -remainder : (30 - remainder)
        return calendar.date(byAdding: .minute, value: adjustment, to: date) ?? date
    }
}

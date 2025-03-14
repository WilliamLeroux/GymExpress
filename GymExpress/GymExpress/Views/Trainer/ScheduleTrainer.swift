//
//  ScheduleTrainer.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.

import SwiftUI
import Combine

/// Wrapper to make CalendarEvent conform to Identifiable
struct IdentifiableCalendarEvent: Identifiable {
    let id: Int
    let event: CalendarEvent
    
    init(_ event: CalendarEvent) {
        self.id = event.id
        self.event = event
    }
}

struct ScheduleTrainer: View {
    @StateObject private var controller = ScheduleTrainerController.shared
    @State private var showAddEventSheet = false
    @State private var hoveredDay: Date? = nil
    @State private var keyboardMonitor: Any?
    @State private var selectedDay: Date? = nil
    @State private var selectedEvent: CalendarEvent? = nil
    @State private var showEventDetailSheet = false
    
    let hourHeight = 50.0
    let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, action: {
                controller.changeWeek(by: -1)
            }))
            
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<7) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: controller.startOfWeek)!
                        VStack {
                            VStack {
                                VStack {
                                    Text(day.formatted(.dateTime.year()))
                                    Text(day.formatted(.dateTime.day().month(.wide).locale(.init(identifier: "fr-CA"))))
                                        .bold()
                                }
                                .font(.title)
                                Text(weekDays[Calendar.current.component(.weekday, from: day) - 1])
                            }
                            .frame(minWidth: 110, minHeight: 110)
                            .foregroundStyle(Calendar.current.isDate(day, inSameDayAs: Date()) ? .red : .black)
                            .background(
                                ZStack {
                                    if Calendar.current.isDate(day, inSameDayAs: Date()) {
                                        Color.red.opacity(hoveredDay == day ? 0.3 : 0.1)
                                    } else {
                                        hoveredDay == day ? Color.gray.opacity(0.2) : Color.clear
                                    }
                                }
                            )
                            .cornerRadius(16)
                            .onTapGesture {
                                selectedDay = day
                            }
                            .onHover { hovering in
                                hoveredDay = hovering ? day : nil
                            }
                            .onChange(of: selectedDay) {
                                if selectedDay != nil {
                                    showAddEventSheet = true
                                }
                            }
                            .sheet(isPresented: $showAddEventSheet) {
                                AddEventSheetView(isPresented: $showAddEventSheet, dateDay: selectedDay!)
                                    .frame(height: 400)
                                    .presentationDetents([.height(600)])
                                    .interactiveDismissDisabled(true)
                                    .onDisappear {
                                        selectedDay = nil
                                    }
                            }
                            
                            ZStack(alignment: .topLeading) {
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(6..<23) { hour in
                                        HStack {
                                            Text("\(hour)").frame(width: 20, alignment: .trailing)
                                            Color.gray.frame(height: 1).padding(.trailing, 10)
                                        }
                                        .frame(height: hourHeight)
                                    }
                                }
                                
                                ForEach(controller.eventsForDay(day), id: \.self) { event in
                                    AnyView(eventCell(event))
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        
                        if index != 6 {
                            Divider()
                        }
                    }
                }
            }
            .padding(.vertical, 16)
            .onAppear { controller.addKeyboardListener() }
            .onDisappear { controller.removeKeyboardListener() }
            .sheet(isPresented: $showEventDetailSheet) {
                if let selectedEvent = selectedEvent {
                    EventDetailView(isPresented: $showEventDetailSheet, event: selectedEvent)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled(true)
                }
            }
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, action: {
                controller.changeWeek(by: 1)
            }))
        }
    }
    
    /// Gère l'affichage d'un événement dans le calendrier
    func eventCell(_ event: CalendarEvent) -> any View {
        guard let endDate = event.endDate, let startDate = event.startDate else {
            return EmptyView()
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        let height = duration / 60 / 60 * hourHeight
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startDate)
        let minute = calendar.component(.minute, from: startDate)
        let offset = Double(hour - 7) * hourHeight
        let recurrenceText = event.recurrenceType.rawValue
        
        return VStack(alignment: .leading) {
            Text("\(hour):\(String(format: "%02d", minute))")
            Text(event.title).bold()
            Text(recurrenceText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(height: height, alignment: .top)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.main.opacity(0.5)))
        .padding(.trailing, 40)
        .offset(x: 30, y: offset + 74)
        .onTapGesture {
            selectedEvent = event
        }
        .onChange(of: selectedEvent) {
            if (selectedEvent != nil){
                showEventDetailSheet = true
            }
        }
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}

struct EventDetailView: View {
    @Binding var isPresented: Bool
    var event: CalendarEvent
    @StateObject private var controller = ScheduleTrainerController.shared
    @State private var showDeletionError = false
    @State private var deletionSucceeded = false
    
    var body: some View {
        VStack {
            Text(event.title)
                .font(.title)
                .bold()
            
            Spacer(minLength: 50)
            
            Text("Début : \(event.startDate?.formatted(.dateTime.locale(Locale(identifier: "fr_CA")).day().month(.wide).year().hour().minute()) ?? "N/A")")
                .font(.title2)
                .bold()
            Text("Fin : \(event.endDate?.formatted(.dateTime.locale(Locale(identifier: "fr_CA")).day().month(.wide).year().hour().minute()) ?? "N/A")")
                .font(.title2)
                .bold()
            
            Spacer(minLength: 100)
            
            HStack {
                Button("Supprimer l'événement", role: .destructive) {}
                    .buttonStyle(RoundedButtonStyle(width: 175, height: 50,color: .red.opacity(0.8), hoveringColor: .red, action: {
                        controller.deleteEvent(event: event,
                                               onFailure: { DispatchQueue.main.async { showDeletionError = true } },
                                               onSuccess: { DispatchQueue.main.async { deletionSucceeded = true } }
                        )
                    }))
                    .alert("Suppression impossible", isPresented: $showDeletionError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Cet événement n'est pas l'événement d'origine de la récurrence et ne peut pas être supprimé individuellement.")
                    }
                
                Button("Fermer") {}
                    .buttonStyle(RoundedButtonStyle(width: 100, height: 50, action: {
                        isPresented = false
                    }))
            }
            .padding(.top, 20)
        }
        .frame(minWidth: 350, maxHeight: 350)
        .padding()
        .onChange(of: deletionSucceeded, initial: deletionSucceeded) { oldValue, newValue in
            if newValue {
                isPresented = false
            }
        }
        
        .onDisappear {
            controller.fetchEvents()
        }
    }
}

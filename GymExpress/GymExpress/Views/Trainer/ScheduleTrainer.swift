//
//  ScheduleTrainer.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-03.

import SwiftUI

/// Wrapper to make CalendarEvent conform to Identifiable
struct IdentifiableCalendarEvent: Identifiable {
    let id: Int
    let event: CalendarEvent
    
    init(_ event: CalendarEvent) {
        self.id = event.getId()
        self.event = event
    }
}

struct ScheduleTrainer: View {
    
    @State private var startOfWeek: Date = Date() /// Date représentant le début de la semaine affichée
    @State private var keyboardMonitor: Any? /// Stocke le moniteur d'événements clavier
    @State private var showAddEventSheet = false /// Indique si la feuille d'ajout d'événement est affichée
    
    /// Liste d'exemples d'événements affichés dans l'horaire
    let events: [IdentifiableCalendarEvent] = [
        IdentifiableCalendarEvent(CalendarEvent(id: 1, startDate: dateFrom(3, 2, 2025, 9, 0), endDate: dateFrom(3, 2, 2025, 11, 0), title: "Entraînement", recurrenceType: .none)),
        IdentifiableCalendarEvent(CalendarEvent(id: 2, startDate: dateFrom(5, 2, 2025, 14, 0), endDate: dateFrom(5, 2, 2025, 15, 0), title: "Réunion", recurrenceType: .none))
    ]
    
    let hourHeight = 50.0 /// Hauteur d'une heure affichée dans la grille horaire
    let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"] /// Jours de la semaine
    let monthNames = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"] /// Noms des mois
 
    var body: some View {
        
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, hoveringColor: Color.green, padding: 2, action: {
                changeWeek(by: -1)
            }))
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<7) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!
                        VStack(alignment: .center) {
                            VStack {
                                VStack {
                                    Text(day.formatted(
                                        .dateTime
                                            .year()
                                    ))
                                    
                                    Text(day.formatted(
                                        .dateTime
                                            .day(.twoDigits)
                                            .month(.wide)
                                            .locale(.init(identifier: "fr-CA"))
                                    ))
                                    .bold()
                                }
                                .font(.title)
                                
                                Text(weekDays[calendarWeekday(from: day) - 1])
                                
                            }
                            .frame(minWidth: 110, minHeight: 110)
                            .foregroundStyle(Calendar.current.isDate(day, inSameDayAs: Date()) ? .red : .black)
                            .background(Calendar.current.isDate(day, inSameDayAs: Date()) ? .red.opacity(0.1) : .clear)
                            .cornerRadius(16)
                            .onTapGesture {
                                showAddEventSheet = true
                            }
                            
                            .sheet(isPresented: $showAddEventSheet) {
                                AddEventSheetView(isPresented: $showAddEventSheet)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            
                            ZStack(alignment: .topLeading) {
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(6..<23) { hour in
                                        HStack {
                                            Text("\(hour)")
                                                .font(.caption)
                                                .frame(width: 20, alignment: .trailing)
                                            Color.gray
                                                .frame(height: 1)
                                                .padding(.trailing, 10)
                                        }
                                        .frame(height: hourHeight)
                                    }
                                }
                                
                                ForEach(events.filter { isEventOnDay($0.event, day) }) { identifiableEvent in
                                    AnyView(eventCell(identifiableEvent.event))
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
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(RoundedButtonStyle(width: 50, height: 50, color: Color.main, hoveringColor: Color.green, padding: 2, action: {
                changeWeek(by: 1)
            }))
        }
        .onAppear {
            addKeyboardListener()
        }
        .onDisappear {
            removeKeyboardListener()
        }
    }
    
    /// Modifie la semaine affichée
    func changeWeek(by value: Int) {
        if startOfWeek < DateUtils.shared.getDateRange().upperBound && startOfWeek > DateUtils.shared.getDateRange().lowerBound {
            startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: startOfWeek) ?? startOfWeek
        }
    }
    
    func calendarDate(for index: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: index, to: startOfWeek) ?? Date()
    }
    
    /// Vérifie si un événement est programmé pour un jour donné
    func isEventOnDay(_ event: CalendarEvent, _ day: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(event.startDate!, inSameDayAs: day)
    }
    
    /// Affiche un événement sous forme de carte dans l'horaire
    func eventCell(_ event: CalendarEvent) -> any View {
        
        guard let endDate = event.endDate, let startDate = event.startDate else {
            return EmptyView()
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        let height = duration / 60 / 60 * hourHeight
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startDate)
        let minute = calendar.component(.minute, from: startDate)
        let offset = Double(hour - 7) * (hourHeight)
        
        return VStack(alignment: .leading) {
            Text("\(hour):\(minute < 10 ? "0\(minute)" : "\(minute)")")
            Text(event.title).bold()
            Text(event.recurrenceType.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .frame(height: height, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.main).opacity(0.5)
        )
        .padding(.trailing, 40)
        .offset(x: 30, y: offset + 24)
        .onTapGesture {
            print("Event ID: \(event.getId())")
        }
    }

    func calendarWeekday(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
    
    /// Ajoute un moniteur pour écouter les touches fléchées
    func addKeyboardListener() {
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            switch event.keyCode {
            case 123: // Flèche gauche
                changeWeek(by: -1)
            case 124: // Flèche droite
                changeWeek(by: 1)
            default:
                break
            }
            return event
        }
    }
    
    /// Supprime le moniteur clavier
    func removeKeyboardListener() {
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
        }
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}

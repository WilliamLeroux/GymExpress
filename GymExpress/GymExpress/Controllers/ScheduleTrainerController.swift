//
//  ScheduleTrainerController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-09.
//

import SwiftUI
import Combine

class ScheduleTrainerController: ObservableObject {
    static let shared = ScheduleTrainerController()
    private var keyboardMonitor: Any?
    
    @Published var startOfWeek: Date = Date()
    @Published var events: [CalendarEvent] = [
        CalendarEvent(id: 1, title: "Entraînement", startDate: dateFrom(3, 2, 2025, 9, 0), endDate: dateFrom(3, 2, 2025, 11, 0), recurrenceType: .none),
        CalendarEvent(id: 2, title: "Réunion", startDate: dateFrom(5, 2, 2025, 14, 0), endDate: dateFrom(5, 2, 2025, 15, 0), recurrenceType: .weekly)
    ]
    
    private init() {}
    
    func addEvent(event: CalendarEvent) {
        var newEvents = events
        newEvents.append(event)
        
        let occurrences = event.generateOccurrences()
        newEvents.append(contentsOf: occurrences)
        
        DispatchQueue.main.async {
            self.events = newEvents.sorted { $0.startDate < $1.startDate }
        }
    }
    
    func changeWeek(by value: Int) {
        DispatchQueue.main.async {
            self.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: self.startOfWeek) ?? self.startOfWeek
        }
    }
    
    func eventsForDay(_ day: Date) -> [CalendarEvent] {
        return events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: day) }
    }
    
    func addKeyboardListener() {
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            switch event.keyCode {
            case 123: // Flèche gauche
                self.changeWeek(by: -1)
            case 124: // Flèche droite
                self.changeWeek(by: 1)
            default:
                break
            }
            return event
        }
    }

    func removeKeyboardListener() {
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
        }
    }
}

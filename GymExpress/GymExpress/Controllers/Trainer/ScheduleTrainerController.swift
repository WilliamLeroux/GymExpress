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
    var dbManager: DatabaseManager = DatabaseManager.shared
    private var keyboardMonitor: Any? = nil
        
    @Published var startOfWeek: Date = Date()
    @Published var events: [CalendarEvent] = []
    
    private init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        guard let userId = LoginController.shared.currentUser?.id else {
            return
        }
        // TODO - FIXER LE DECALAGE DANS LA BD        
        if let fetchedEvents: [CalendarEvent] = dbManager.fetchDatas(request: Request.select(table: DbTable.events, columns: ["*"], condition: "WHERE start_date = ? AND is_deleted = ?"), params: [userId, false]) {
            var newEvents: [CalendarEvent] = []
                                    
            for event in fetchedEvents {
                newEvents.append(event)
                let occurrences = event.generateOccurrences()
                newEvents.append(contentsOf: occurrences)
            }
            
            DispatchQueue.main.async {
                self.events = newEvents.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
            }
        } else {
            DispatchQueue.main.async {
                self.events = []
            }
        }
    }
    
    func deleteEvent(event: CalendarEvent, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void) {
        if event.id < Int32.min || event.id > Int32.max {
            DispatchQueue.main.async {
                onFailure()
            }
            return
        }

        let success = dbManager.updateData(request: Request.update(table: DbTable.events, columns: ["is_deleted"], condition: "WHERE id = ?"), params: [true, event.id])

        if success {
            DispatchQueue.main.async {
                self.fetchEvents()
                onSuccess()
            }
        } else {
            DispatchQueue.main.async {
                onFailure()
            }
        }
    }

    func addEvent(event: CalendarEvent, startDate: Date) {
        var newEvents = events
        var tempEvent = event
                
        tempEvent.userId = LoginController.shared.currentUser?.id ?? -1
        newEvents.append(tempEvent)
        
        var bool = dbManager.insertData(request: Request.createEvent, params: tempEvent)
        
        DispatchQueue.main.async {
            self.fetchEvents()
        }
    }
    
    func changeWeek(by value: Int) {
        DispatchQueue.main.async {
            self.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: self.startOfWeek) ?? self.startOfWeek
        }
    }
    
    func eventsForDay(_ day: Date) -> [CalendarEvent] {
        return events.filter { Calendar.current.isDate($0.startDate!, inSameDayAs: day) }
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

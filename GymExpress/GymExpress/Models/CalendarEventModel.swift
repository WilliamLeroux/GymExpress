//
//  CalendarEventModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation

enum RecurrenceType: String, Codable {
    case none, daily, weekly, monthly
}

struct CalendarEvent: Identifiable, Codable {
    var id: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var recurrenceType: RecurrenceType = .none
    var recurrenceEndDate: Date?
    
    func generateOccurrences() -> [CalendarEvent] {
        guard recurrenceType != .none else {
            return []
        }
        
        let calendar = Calendar.current
        let timeInterval = endDate.timeIntervalSince(startDate)
        var occurrences: [CalendarEvent] = []
        
        let endRecurrenceDate = recurrenceEndDate ?? calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        var currentDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        while currentDate <= endRecurrenceDate {
            let newEvent = CalendarEvent(
                id: UUID().hashValue,
                title: title,
                startDate: currentDate,
                endDate: currentDate.addingTimeInterval(timeInterval),
                recurrenceType: .none
            )
            occurrences.append(newEvent)
            
            switch recurrenceType {
            case .daily:
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            case .weekly:
                currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
            case .monthly:
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
            case .none:
                break
            }
        }
        
        return occurrences
    }
}

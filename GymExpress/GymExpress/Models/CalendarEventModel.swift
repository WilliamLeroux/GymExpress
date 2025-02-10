//
//  CalendarEventModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation
import SQLite3

// Structure d'un événement dans le calendrier d'un entraîneur.
struct CalendarEvent: SQLConvertable, InitializableFromSQLITE {
    private var id: Int = -1 /// Identifiant unique (privé)
    var startDate: Date? = nil /// Date de début de l'événement
    var endDate: Date? = nil /// Date de fin de l'événement
    var title: String = "" /// Titre de l'événement
    var recurrenceType: RecurrenceType = .none /// Type de récurrence (ex: "quotidien", "hebdomadaire")
    var recurrenceEndDate: Date? = nil /// Date de fin de récurrence
    
    // Initialisateur
    init(id: Int, startDate: Date, endDate: Date, title: String, recurrenceType: RecurrenceType) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.recurrenceType = recurrenceType
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[7].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, i))
            case 3:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                   
                    self.startDate = DateUtils.shared.formatter.date(from: dateStr)!
                } else {
                    self.startDate = nil
                }
            case 4:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                   
                    self.endDate = DateUtils.shared.formatter.date(from: dateStr)!
                } else {
                    self.endDate = nil
                }
            case 5:
                self.title = String(cString: sqlite3_column_text(pointer, i)!)
            case 6:
                self.recurrenceType = Utils.shared.getRecurrenceTypeById(id: Int(sqlite3_column_int(pointer, i)))
            default:
                #if DEBUG
                print("Unknown column, \(columnIndex)")
                #endif
            }
        }
    }
    
    var params: [Any] {
        return [id, startDate as Any, endDate as Any, title, recurrenceType, recurrenceEndDate as Any]
    }
    
    // Obtenir l'ID d'un CalendarEvent
    func getId() -> Int {
        return id
    }

    func generateOccurrences() -> [CalendarEvent] {
        guard recurrenceType != .none else {
            return []
        }
        
        let calendar = Calendar.current
        let timeInterval = endDate.timeIntervalSince(startDate)
        var occurrences: [CalendarEvent] = []
        
        let endRecurrenceDate = recurrenceEndDate ?? calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        var currentDate: Date
        
        switch recurrenceType {
        case .daily:
            currentDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        case .weekly:
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate) ?? startDate
        case .monthly:
            currentDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
        case .none:
            return []
        }
        
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

//
//  CalendarEventModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation
import SQLite3

// Structure d'un événement dans le calendrier d'un entraîneur.
struct CalendarEvent: SQLConvertable, InitializableFromSQLITE, Hashable{
    var id: Int = -1 /// Identifiant unique (privé)
    var userId: Int = -1 /// Identifiant unique (user)
    var startDate: Date? = nil /// Date de début de l'événement
    var endDate: Date? = nil /// Date de fin de l'événement
    var title: String = "" /// Titre de l'événement
    var recurrenceType: RecurrenceType = .none /// Type de récurrence (ex: "quotidien", "hebdomadaire")
    var recurrenceEndDate: Date? = nil /// Date de fin de récurrence
    
    // Initialisateur
    init(id: Int = -1, startDate: Date, endDate: Date, title: String, recurrenceType: RecurrenceType) {
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
                self.userId = Int(sqlite3_column_int(pointer, i))
            case 4:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                    
                    self.startDate = DateUtils.shared.formatter.date(from: dateStr)!
                } else {
                    self.startDate = nil
                }
            case 5:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                    
                    self.endDate = DateUtils.shared.formatter.date(from: dateStr)!
                } else {
                    self.endDate = nil
                }
            case 6:
                self.title = String(cString: sqlite3_column_text(pointer, i)!)
            case 7:
                self.recurrenceType = Utils.shared.getRecurrenceTypeById(id: Int(sqlite3_column_int(pointer, i)))
            case 8:
                if let dateString = sqlite3_column_text(pointer, i) {
                    _ = String(cString: dateString)
                    let calendar = Calendar.current
                    
                    switch self.recurrenceType {
                    case .daily:
                        self.recurrenceEndDate = calendar.date(byAdding: .month, value: 1, to: self.startDate!) ?? self.startDate
                    case .weekly:
                        self.recurrenceEndDate = calendar.date(byAdding: .month, value: 3, to: self.startDate!) ?? self.startDate
                    case .monthly:
                        self.recurrenceEndDate = calendar.date(byAdding: .month, value: 6, to: self.startDate!) ?? self.startDate
                    case .none:
                        self.recurrenceEndDate = nil
                    }
                }
            default:
#if DEBUG
                print("Unknown column, \(columnIndex)")
#endif
            }
        }
    }
    
    var params: [Any] {
        return [id, userId, startDate as Any, endDate as Any, title, recurrenceType, recurrenceEndDate as Any]
    }
    
    func generateOccurrences() -> [CalendarEvent] {
        guard recurrenceType != .none else {
            return []
        }
        
        let calendar = Calendar.current
        let timeInterval = (endDate?.timeIntervalSince(startDate ?? Date()))!
        var occurrences: [CalendarEvent] = []
        
        let endRecurrenceDate = recurrenceEndDate ?? calendar.date(byAdding: .month, value: 1, to: startDate ?? Date())!
        
        var currentDate: Date
        
        switch recurrenceType {
        case .daily:
            currentDate = calendar.date(byAdding: .day, value: 1, to: startDate ?? Date()) ?? startDate ?? Date()
        case .weekly:
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate ?? Date()) ?? startDate ?? Date()
        case .monthly:
            currentDate = calendar.date(byAdding: .month, value: 1, to: startDate ?? Date()) ?? startDate ?? Date()
        case .none:
            return []
        }
        
        while currentDate <= endRecurrenceDate {
            let newEvent = CalendarEvent(
                id: UUID().hashValue,
                startDate: currentDate,
                endDate: currentDate.addingTimeInterval(timeInterval),
                title: title,
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

//
//  AppointmentModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure pour un rendez-vous
struct AppointmentModel: Identifiable, SQLConvertable, InitializableFromSQLITE {
    var id: Int = -1 /// Identifiant
    var trainerId: Int = -1 /// Identifiant de l'entraineur
    var clientId: Int = -1 /// Identifiant du client
    var name: String = "" /// Nom du rendez-vous
    var description: String = "" ///  Description
    var date: Date? = nil /// Date du rendez-vous
    
    init(trainerId: Int, clientId: Int, name: String, description: String, date: Date) {
        self.trainerId = trainerId
        self.clientId = clientId
        self.name = name
        self.description = description
        self.date = date
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            self.trainerId = -1
            self.clientId = -1
            self.name = ""
            self.description = ""
            self.date = nil
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0

        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[6].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, i))
            case 2:
                self.clientId = Int(sqlite3_column_int(pointer, i))
            case 3:
                self.trainerId = Int(sqlite3_column_int(pointer, i))
            case 4:
                self.name = String(cString: sqlite3_column_text(pointer, i)!)
            case 5:
                self.description = String(cString: sqlite3_column_text(pointer, i)!)
            case 6:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                    if dateStr.count(where: {$0 == "-"}) != 2 {
                        self.date = DateUtils.shared.formatter.date(from: dateStr)!
                    } else {
                        self.date = DateUtils.shared.formatterSimpleDate.date(from: dateStr)!
                    }
                    
                } else {
                    self.date = nil
                }
            default:
                #if DEBUG
                    print("Unknown column, \(columnIndex)")
                #endif
            }
        }
    }
    
    var params: [Any] {
        return [clientId, trainerId, name, description, date as Any]
    }
}

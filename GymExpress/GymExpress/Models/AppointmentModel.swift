//
//  AppointmentModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure pour un rendez-vous
struct AppointmentModel: Identifiable, InitializableFromSQLITE {
    let id: Int /// Identifiant
    let trainerId: Int /// Identifiant de l'entraineur
    let clientId: Int /// Identifiant du client
    var name: String /// Nom du rendez-vous
    var descritption: String ///  Description
    var date: Date? /// Date du rendez-vous
    
    init(id: Int, trainerId: Int, clientId: Int, name: String, descritption: String, date: Date) {
        self.id = id
        self.trainerId = trainerId
        self.clientId = clientId
        self.name = name
        self.descritption = descritption
        self.date = date
    }
    
    init(from pointer: OpaquePointer?) {
        self.id = Int(sqlite3_column_int(pointer, 0))
        self.trainerId = Int(sqlite3_column_int(pointer, 1))
        self.clientId = Int(sqlite3_column_int(pointer, 2))
        self.name = String(cString: sqlite3_column_text(pointer, 3))
        self.descritption = String(cString: sqlite3_column_text(pointer, 4))
        if let dateString = sqlite3_column_text(pointer, 5) {
            
            let dateStr = String(cString: dateString)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
           
            self.date = formatter.date(from: dateStr)!
        } else {
            self.date = nil
        }
    }
}

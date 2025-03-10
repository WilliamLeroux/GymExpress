//
//  ObjectiveDataModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure des données pour un objectif
struct ObjectiveData: Identifiable, Equatable, Hashable, InitializableFromSQLITE, SQLConvertable {
    var id: Int = 0 /// Identifiant
    var objId: Int = 0
    var value: Int = -1 /// Valeur
    var date: Date? = nil /// Date d'ajour
    
    init(objId: Int, value: Int, year: Int, month: Int, day: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.objId = objId
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.value = value
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[3].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int64(pointer, i))
            case 3:
                self.value = Int(sqlite3_column_int64(pointer, i))
            case 4:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                   
                    self.date = DateUtils.shared.formatter.date(from: dateStr)!
                } else {
                    self.date = nil
                }
            default:
                break
            }
        }
    }
    
    var params: [Any] {
        return [objId, value, date as Any]
    }
}

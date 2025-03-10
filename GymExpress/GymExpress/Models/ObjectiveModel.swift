//
//  ObjectiveModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure des objectifs
struct Objective: Identifiable, Equatable, Hashable, InitializableFromSQLITE, SQLConvertable {
    var dbId: Int = 0
    var userId = -1 /// Id du user
    var objective: String = "" /// Nom de l'objectif
    var initValue: Int = 0 /// Valeur initial
    var valueList: [ObjectiveData] = [] /// Liste des données
    var maxValue: Int = 0 /// Valeur maximum
    var startDate: Date = Date() /// Date de début
    var endDate: Date = Date() /// Date de fin
    
    init(objective: String, initValue: Int, valueList: [ObjectiveData], maxValue: Int, yearStart: Int, monthStart: Int, dayStart: Int, yearEnd: Int, monthEnd: Int, dayEnd: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.startDate = calendar.date(from: DateComponents(year: yearStart, month: monthStart, day: dayStart))!
        self.endDate = calendar.date(from: DateComponents(year: yearEnd, month: monthEnd, day: dayEnd))!
        self.objective = objective
        self.initValue = initValue
        self.valueList = valueList
        self.maxValue = maxValue
    }
    
    init (from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[2].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.dbId = Int(sqlite3_column_int(pointer, Int32(i)))
            case 3:
                self.initValue = Int(sqlite3_column_int(pointer, Int32(i)))
            case 4:
                self.maxValue = Int(sqlite3_column_int(pointer, Int32(i)))
            case 5:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                    if dateStr.count(where: {$0 == "-"}) != 2 {
                        self.startDate = DateUtils.shared.formatter.date(from: dateStr)!
                    } else {
                        self.startDate = DateUtils.shared.formatterSimpleDate.date(from: dateStr)!
                    }
                } else {
                    self.startDate = Date()
                }
            case 6:
                if let dateString = sqlite3_column_text(pointer, i) {
                    
                    let dateStr = String(cString: dateString)
                    if dateStr.count(where: {$0 == "-"}) != 2 {
                        self.endDate = DateUtils.shared.formatter.date(from: dateStr)!
                    } else {
                        self.endDate = DateUtils.shared.formatterSimpleDate.date(from: dateStr)!
                    }
                } else {
                    self.endDate = Date()
                }
            case 7:
                self.objective = String(cString: sqlite3_column_text(pointer, i)!)
            default :
                break
            }
        }
    }
    
    var params: [Any] {
        return [userId, initValue, maxValue, startDate as Any, endDate as Any, objective]
    }
    
    var id: String { return objective }
}

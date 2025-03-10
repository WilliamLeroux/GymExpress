//
//  FrequenceModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import Foundation
import SQLite3

struct FrequenceModel: Identifiable, SQLConvertable, InitializableFromSQLITE {
    var id: Int = -1
    var userId: Int = -1
    var date: Date? = nil
    var presence: Bool = false
    
    init(userId: Int, date: Date? = nil, presence: Bool = false) {
        self.userId = userId
        self.date = date
        self.presence = presence
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[1].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, Int32(i)))
            case 2:
                self.userId = Int(sqlite3_column_int(pointer, Int32(i)))
            case 3:
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
            case 4:
                self.presence = sqlite3_column_int(pointer, Int32(i)) == 1
            default:
                break
            }
        }
    }
    
    var params: [Any] {
        return [userId, date as Any, presence]
    }
}

//
//  WorkoutModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure d'un entrainement
struct WorkoutModel: Identifiable, SQLConvertable, InitializableFromSQLITE{
    var id: Int = -1/// Identifiant du programme
    var name: String = "" /// Nom de l'entrainement
    var exerciseList: [ExerciseModel] = [] /// Liste d'exercises
    var day: Int = 0 /// Jour de la semaine en Int
    
    init(name: String, exerciceList: [ExerciseModel], day: Int) {
        self.name = name
        self.exerciseList = exerciceList
        self.day = day
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[4].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, Int32(i)))
            case 2:
                self.name = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 3:
                self.day = Int(sqlite3_column_int(pointer, Int32(i)))
            default:
                break
            }
        }
    }
    
    var params: [Any] {
        return [name, day]
    }
}

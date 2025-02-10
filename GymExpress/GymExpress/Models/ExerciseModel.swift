//
//  ExerciseModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation
import SQLite3

/// Structure d'un exercise
struct ExerciseModel: Identifiable, InitializableFromSQLITE, SQLConvertable {
    var id: Int = -1 /// Identifiant
    var name : String = "" /// Nom
    var imageId: Int = -1 /// Image représentant l'exercise
    var description: String = "" /// Description
    var bodyParts: Int = -1 /// Partie du corps
    var exerciseType: Int = -1 /// Type d'exercise
    var sets: Int = -1 /// Nombre de séries
    var reps: Int = -1 /// Nombre de répétitions
    var charge: Int = -1 /// Charge à lever
    
    init(imageId: Int, description: String, bodyParts: Int, exerciseType: Int, sets: Int, reps: Int, charge: Int) {
        self.imageId = imageId
        self.description = description
        self.bodyParts = bodyParts
        self.exerciseType = exerciseType
        self.sets = sets
        self.reps = reps
        self.charge = charge
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[5].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, Int32(i)))
            case 3:
                self.name = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 4:
                self.imageId = Int(sqlite3_column_int(pointer, Int32(i)))
            case 5:
                self.description = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 6:
                self.bodyParts = Int(sqlite3_column_int(pointer, Int32(i)))
            case 7:
                self.exerciseType = Int(sqlite3_column_int(pointer, Int32(i)))
            case 8:
                self.sets = Int(sqlite3_column_int(pointer, Int32(i)))
            case 9:
                self.reps = Int(sqlite3_column_int(pointer, Int32(i)))
            case 10:
                self.charge = Int(sqlite3_column_int(pointer, Int32(i)))
            default:
                break
            }
        }
    }
    
    var params: [Any] {
        return [name, imageId, description, bodyParts, exerciseType, sets, reps, charge]
    }
}

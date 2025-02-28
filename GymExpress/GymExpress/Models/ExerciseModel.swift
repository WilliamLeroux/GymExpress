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
    var exerciceId: String = "" /// id de l'exercice dans l'api
    var name : String = "" /// Nom
    var imageId: String = "" /// URL représentant l'image de l'exercice
    var description: String = "" /// Description
    var bodyParts: BodyParts = .core /// Partie du corps
    var exerciseType: Int = -1 /// Type d'exercise
    var sets: Int = -1 /// Nombre de séries
    var reps: Int = -1 /// Nombre de répétitions
    var charge: Int = -1 /// Charge à lever
    
    init(exerciceId: String, name: String, imageId: String, description: String, bodyParts: BodyParts, exerciseType: Int = -1, sets: Int, reps: Int, charge: Int) {
        self.exerciceId = exerciceId
        self.name = name
        self.imageId = imageId
        self.description = description
        self.bodyParts = bodyParts
        self.exerciseType = exerciseType
        self.sets = sets
        self.reps = reps
        self.charge = charge
    }
    
    init(from exercise: Exercises, bodyParts: BodyParts) {
        self.exerciceId = exercise.exerciseId
        self.name = exercise.name
        self.imageId = exercise.gifUrl
        self.bodyParts = bodyParts
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
                self.exerciceId = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 4:
                self.name = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 5:
                self.imageId = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 6:
                self.description = String(cString: sqlite3_column_text(pointer, Int32(i))!)
            case 7:
                self.bodyParts = Utils.shared.getBodyPartsById(Int(sqlite3_column_int(pointer, Int32(i))))
            case 8:
                self.exerciseType = Int(sqlite3_column_int(pointer, Int32(i)))
            case 9:
                self.sets = Int(sqlite3_column_int(pointer, Int32(i)))
            case 10:
                self.reps = Int(sqlite3_column_int(pointer, Int32(i)))
            case 11:
                self.charge = Int(sqlite3_column_int(pointer, Int32(i)))
            default:
                break
            }
        }
    }
    
    var params: [Any] {
        return [exerciceId, name, imageId, description, bodyParts, exerciseType, sets, reps, charge]
    }
}

//
//  ExerciseModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation

/// Structure d'un exercise
struct ExerciseModel: Identifiable {
    let id: Int /// Identifiant
    var imageId: Int /// Image représentant l'exercise
    var description: String /// Description
    var bodyParts: Int /// Partie du corps
    var exerciseType: Int /// Type d'exercise
    var sets: Int /// Nombre de séries
    var reps: Int /// Nombre de répétitions
    var charge: Int /// Charge à lever
}

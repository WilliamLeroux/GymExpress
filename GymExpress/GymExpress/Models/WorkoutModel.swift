//
//  WorkoutModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation

/// Structure d'un entrainement
struct WorkoutModel: Identifiable{
    let id: Int /// Identifiant du programme
    var name: String /// Nom de l'entrainement
    var exerciseList: [ExerciseModel] /// Liste d'exercises
}

//
//  WorkoutPlanController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-13.
//

import Foundation

class WorkoutPlanController: ObservableObject {
    @Published var workouts: [WorkoutModel] = []
    
    func addWorkout(clientId: Int, name: String, exercises: [ExerciseModel], day: Int) {
        let newWorkout = WorkoutModel(clientId: clientId, name: name, exerciceList: exercises, day: day)
        workouts.append(newWorkout)
    }
    
    func removeWorkout(_ workout: WorkoutModel) {
        workouts.removeAll { $0.id == workout.id }
    }
}

//
//  ExercisePlanController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-13.
//

import Foundation

class ExercisePlanController: ObservableObject {
    static let shared = ExercisePlanController()
    @Published var selectedType: BodyParts = BodyParts.cardio
    @Published var selectedExercise: String = "" {
        didSet {
            selectedExerciseModel = addedExercises.first(where: { $0.name == selectedExercise })
        }
    }
    @Published var series: String = ""
    @Published var reps: String = ""
    @Published var charge: String = ""
    @Published var repos: String = ""
    @Published var addedExercises: [ExerciseModel] = []
    var selectedExerciseModel: ExerciseModel? = nil
    
    let exerciseLegends = [BodyParts.cardio, BodyParts.upperBody, BodyParts.lowerBody, BodyParts.core]
    
    var exercisesByType: [String: [ExerciseModel]] = [:]
    
    init() {
        
        var tempExercises: [Exercises] = []
        BodyParts.allCases.forEach {bodyPart in
            let waiter = DispatchSemaphore(value: 0)
            Task{
                Utils.shared.getMuscle(bodyPart: bodyPart).forEach { muscle in
                    let muscleWaiter = DispatchSemaphore(value: 0)
                    Task{
                        if tempExercises.isEmpty {
                            tempExercises = await ExerciceFetch().getExercice(muscle)
                        } else {
                            tempExercises.append(contentsOf: await ExerciceFetch().getExercice(muscle))
                        }
                        muscleWaiter.signal()
                    }
                    muscleWaiter.wait()
                }
                waiter.signal()
            }
           
            waiter.wait()
            tempExercises.forEach {
                if exercisesByType[bodyPart.rawValue] == nil {
                    exercisesByType[bodyPart.rawValue] = [ExerciseModel(from: $0, bodyParts: bodyPart)]
                } else {
                    exercisesByType[bodyPart.rawValue]!.append(ExerciseModel(from: $0, bodyParts: bodyPart))
                }
            }
            tempExercises.removeAll()
        }
    }

    // Convertit les exercices temporaires en ExerciseModel
    func getExerciseModels() -> [ExerciseModel] {
        print("📌 Récupération des exercices : \(addedExercises.count) trouvés")
        
        return addedExercises.map { exercise in
            ExerciseModel(
                exerciceId: "",
                name: "",
                imageId: "",
                description: exercise.name,
                bodyParts: .cardio,
                sets: Int(exercise.sets),
                reps: Int(exercise.reps),
                charge: Int(exercise.charge)
            )
        }
    }
    
    private func getExerciseTypeInt(_ type: String) -> Int {
        switch type {
            case "Musculation": return 1
            case "Cardio": return 2
            case "Étirement": return 3
            case "Corps-poids": return 4
            default: return 1
        }
    }
    
    func addExercise() {
        guard selectedExercise != "", !series.isEmpty, !reps.isEmpty, !charge.isEmpty, !repos.isEmpty else {
            return
        }
        
        //let newExercise = ExerciseModel(exerciseId: "102", name: exerciseName, sets: series, reps: reps, charge: charge, repos: repos)
        //exerciceId: String, name: String, imageId: String, description: String, bodyParts: BodyParts, exerciseType: Int, sets: Int, reps: Int, charge: Int
        var tempExercise = selectedExerciseModel
        tempExercise?.charge = Int(charge) ?? 0
        tempExercise?.reps = Int(reps) ?? 0
        tempExercise?.charge = Int(repos) ?? 0
        addedExercises.append(tempExercise!)
        
        resetFields()
    }
    
    func removeExercise(_ exercise: ExerciseModel) {
        addedExercises.removeAll { $0.id == exercise.id }
    }
    
    func resetFields() {
        selectedExercise = ""
        series = ""
        reps = ""
        charge = ""
        repos = ""
    }
    
    func clearExercises() {
        addedExercises.removeAll()
    }
}

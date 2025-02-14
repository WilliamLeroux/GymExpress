//
//  ExercisePlanController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-13.
//

import Foundation

class ExercisePlanController: ObservableObject {
    @Published var selectedType: String = "Musculation"
    @Published var selectedExercise: String? = nil
    @Published var series: String = ""
    @Published var reps: String = ""
    @Published var charge: String = ""
    @Published var repos: String = ""
    @Published var addedExercises: [Exercise] = []
    
    let exerciseLegends = ["Musculation", "Cardio", "Étirement", "Corps-poids"]
    
    let exercisesByType: [String: [String]] = [
        "Musculation": ["Développé couché", "Squat", "Soulevé de terre", "Tirage vertical", "Développé militaire", "Curl biceps", "Extension triceps", "Fentes", "Rowing barre"],
        "Cardio": ["Course à pied", "Vélo", "Rameur", "Natation", "Corde à sauter", "Sprints", "Montées de genoux", "Escalier", "Marche rapide"],
        "Étirement": ["Étirement des ischio-jambiers", "Étirement du quadriceps", "Étirement des mollets", "Étirement des pectoraux", "Étirement du dos", "Rotation du tronc", "Étirement des épaules", "Étirement du cou", "Étirement des hanches"],
        "Corps-poids": ["Pompes", "Squats sautés", "Planche", "Burpees", "Dips entre bancs", "Mountain climbers", "Lunges", "Gainage latéral", "Crunchs"]
    ]
    
    // Convertit les exercices temporaires en ExerciseModel
    func getExerciseModels() -> [ExerciseModel] {
        print("📌 Récupération des exercices : \(addedExercises.count) trouvés")
        
        return addedExercises.map { exercise in
            ExerciseModel(
                imageId: 1,
                description: exercise.name,
                bodyParts: 1,
                exerciseType: getExerciseTypeInt(selectedType),
                sets: Int(exercise.series) ?? 0,
                reps: Int(exercise.reps) ?? 0,
                charge: Int(exercise.charge) ?? 0
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
        guard let exerciseName = selectedExercise, !series.isEmpty, !reps.isEmpty, !charge.isEmpty, !repos.isEmpty else {
            print("❌ Impossible d'ajouter l'exercice : champ(s) vide(s)")
            return
        }
        
        let newExercise = Exercise(name: exerciseName, series: series, reps: reps, charge: charge, repos: repos)
        addedExercises.append(newExercise)
        
        print("✅ Exercice ajouté : \(exerciseName)")
        print("📌 Liste actuelle des exercices :")
        for ex in addedExercises {
            print("- \(ex.name) | Sets: \(ex.series), Reps: \(ex.reps), Charge: \(ex.charge)")
        }

        resetFields()
    }
    
    func removeExercise(_ exercise: Exercise) {
        addedExercises.removeAll { $0.id == exercise.id }
    }
    
    func resetFields() {
        selectedExercise = nil
        series = ""
        reps = ""
        charge = ""
        repos = ""
    }
    
    func clearExercises() {
        addedExercises.removeAll()
    }
}

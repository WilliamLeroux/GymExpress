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
        "Musculation": [
            "Développé couché", "Squat", "Soulevé de terre", "Tirage vertical", "Développé militaire",
            "Curl biceps", "Extension triceps", "Fentes avec haltères", "Rowing barre", "Presse à jambes",
            "Élévations latérales", "Élévations frontales", "Pull-over", "Rowing haltères", "Hip thrust",
            "Leg curl allongé", "Leg extension", "Mollets debout à la machine", "Mollets assis", "Développé Arnold",
            "Pec deck (Butterfly)", "Poulie vis-à-vis", "Extension triceps à la poulie", "Biceps curl à la poulie",
            "Rowing assis à la poulie", "Hack squat", "Leg press inclinée", "Machine à adducteurs", "Machine à abducteurs"
        ],
        "Cardio": [
            "Course sur tapis", "Vélo stationnaire", "Rameur", "Escalier mécanique", "Stepper",
            "Corde à sauter", "HIIT sur vélo", "Elliptique", "Sprint sur tapis", "SkiErg",
            "Tapis incliné", "Air Bike", "Tapis de course auto-alimenté", "Course en fractionné sur tapis"
        ],
        "Étirement": [
            "Étirement des ischio-jambiers sur banc", "Étirement du quadriceps debout avec appui",
            "Étirement des mollets sur step", "Étirement des pectoraux sur un cadre de porte",
            "Étirement du dos sur Swiss ball", "Rotation du tronc avec bâton", "Étirement des épaules avec élastique",
            "Étirement du cou assis", "Étirement des hanches sur tapis", "Étirement du piriforme sur banc",
            "Étirement du psoas avec appui", "Étirement des adducteurs assis", "Étirement du bas du dos sur tapis",
            "Étirement du grand dorsal en suspension", "Étirement du triceps derrière la tête",
            "Étirement des fléchisseurs de hanche avec banc", "Étirement en papillon sur tapis",
            "Étirement du fessier sur banc", "Étirement du biceps avec barre"
        ],
        "Corps-poids": [
            "Pompes sur banc", "Squats sautés", "Planche sur Swiss ball", "Burpees avec slam ball",
            "Dips sur barres parallèles", "Mountain climbers sur tapis", "Fentes sautées avec step",
            "Gainage latéral avec disque", "Crunchs sur banc incliné", "Superman au sol",
            "Pont fessier lesté", "Jump squats avec kettlebell", "Chaise contre le mur avec poids",
            "Pistol squat sur banc", "Pompes diamant sur step", "Russian twists avec medecine ball",
            "V-ups sur tapis", "Plank jacks avec sliders", "Crunchs lestés", "Planche avec TRX"
        ]
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
            return
        }
        
        let newExercise = Exercise(name: exerciseName, series: series, reps: reps, charge: charge, repos: repos)
        addedExercises.append(newExercise)
        
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

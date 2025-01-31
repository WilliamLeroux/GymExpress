//
//  ExercisePlanCreationView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-29.
//

import SwiftUI

struct ExercisePlanCreationView: View {
    @State private var selectedType: String = "Musculation"
    @State private var selectedExercise: String? = nil
    @State private var series: String = ""
    @State private var reps: String = ""
    @State private var charge: String = ""
    @State private var repos: String = ""
    @State private var addedExercises: [Exercise] = []
    
    let day: String
    let exerciseTypes = ["Musculation", "Cardio", "Étirement", "Corps-poids"]
    
    let exercisesByType: [String: [String]] = [
        "Musculation": [
            "Développé couché",
            "Squat",
            "Soulevé de terre",
            "Tirage vertical",
            "Développé militaire",
            "Curl biceps",
            "Extension triceps",
            "Fentes",
            "Rowing barre"
        ],
        "Cardio": [
            "Course à pied",
            "Vélo",
            "Rameur",
            "Natation",
            "Corde à sauter",
            "Sprints",
            "Montées de genoux",
            "Escalier",
            "Marche rapide"
        ],
        "Étirement": [
            "Étirement des ischio-jambiers",
            "Étirement du quadriceps",
            "Étirement des mollets",
            "Étirement des pectoraux",
            "Étirement du dos",
            "Rotation du tronc",
            "Étirement des épaules",
            "Étirement du cou",
            "Étirement des hanches"
        ],
        "Corps-poids": [
            "Pompes",
            "Squats sautés",
            "Planche",
            "Burpees",
            "Dips entre bancs",
            "Mountain climbers",
            "Lunges",
            "Gainage latéral",
            "Crunchs"
        ]
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Plan d'exercice pour \(day)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                HStack(spacing: 20) {
                    GroupBox {
                        HStack {
                            VStack(alignment: .leading) {
                                Picker("", selection: $selectedType) {
                                    ForEach(exerciseTypes, id: \.self) { type in
                                        Text(type).tag(type as String?)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: .infinity)

                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(exercisesByType[selectedType] ?? [], id: \.self) { exercise in
                                            Button(action: {
                                                selectedExercise = exercise
                                            }) {
                                                HStack {
                                                    Image(systemName: selectedExercise == exercise ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(selectedExercise == exercise ? .main : .gray)
                                                    Text(exercise)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                    }
                                }.frame(maxHeight: 500)
                            }
                            .frame(minWidth: 300, maxWidth: 300)
                            .padding()

                            Divider()

                            VStack(alignment: .leading, spacing: 30) {
                                ParameterField(title: "Nombre de séries", text: $series)
                                ParameterField(title: "Nombre de répétitions", text: $reps)
                                ParameterField(title: "Charge", text: $charge)
                                ParameterField(title: "Temps de repos", text: $repos)
                                
                                Button(action: {}) {
                                    Text("Ajouter")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                .buttonStyle(RoundedButtonStyle(width: 125, height: 50, color: Color.main, hoveringColor: Color.green, padding: 2, action: { addExercise()
                                }))
                            }
                            .padding()
                            .frame(minWidth: 150, maxWidth: 150)
                        }
                        
                    }

                    // Deuxième groupe (exercices ajoutés)
                    GroupBox {
                        ScrollView{
                            VStack {
                                Text("Exercices ajoutés :")
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                
                                if addedExercises.isEmpty {
                                    Text("Aucun exercice ajouté")
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(addedExercises) { exercise in
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(exercise.name)
                                                        .font(.headline)
                                                    Text("Séries: \(exercise.series), Répétitions: \(exercise.reps)")
                                                        .foregroundColor(.black)
                                                    Text("Charge: \(exercise.charge), Repos: \(exercise.repos)")
                                                        .foregroundColor(.black)
                                                }
                                                Spacer()
                                                Button(action: {}) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.black)
                                                }
                                                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: .red.opacity(0.8), hoveringColor: .red, action: { removeExercise(exercise) }))
                                            }
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                        }
                                        .background(Color.main)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }

    
    private func addExercise() {
        guard let exerciseName = selectedExercise, !series.isEmpty, !reps.isEmpty, !charge.isEmpty, !repos.isEmpty else {
            return
        }
        
        let newExercise = Exercise(
            name: exerciseName,
            series: series,
            reps: reps,
            charge: charge,
            repos: repos
        )
        
        addedExercises.append(newExercise)
        resetFields()
    }
    
    private func removeExercise(_ exercise: Exercise) {
        addedExercises.removeAll { $0.id == exercise.id }
    }
    
    private func resetFields() {
        selectedExercise = nil
        series = ""
        reps = ""
        charge = ""
        repos = ""
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let series: String
    let reps: String
    let charge: String
    let repos: String
}

struct ParameterField: View {
    var title: String
    @Binding var text: String
    @FocusState private var isTyping: Bool
    
    let exerciseTypes = ["5", "12", "25 lbs", "120 (s)"]
    let index: Int
    
    init(title: String, text: Binding<String>, index: Int = 0) {
        self.title = title
        self._text = text
        self.index = index
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            TextFieldStyle(
                title: index < exerciseTypes.count ? exerciseTypes[index] : "",
                text: $text,
                isTyping: $isTyping
            )
        }
    }
}

struct ExercisePlanCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePlanCreationView(day: "Lundi")
    }
}

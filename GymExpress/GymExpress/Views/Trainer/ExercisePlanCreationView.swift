//
//  ExercisePlanCreationView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-29.
//

import SwiftUI

struct ExercisePlanCreationView: View {
    @ObservedObject var exercisePlanController = ExercisePlanController.shared
    let day: String
    
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
                                
                                Picker("Type d'exercice", selection: $exercisePlanController.selectedType) {
                                    ForEach(exercisePlanController.exerciseLegends, id: \.self) { type in
                                        Text(type.rawValue).tag(type.rawValue)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: .infinity)
                                 
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        let exercises = exercisePlanController.exercisesByType[exercisePlanController.selectedType.rawValue] ?? []
                                        
                                        ForEach(exercises, id: \.exerciceId) { exercise in
                                            Button(action: {
                                                exercisePlanController.selectedExercise = exercise.exerciceId
                                            }) {
                                                HStack {
                                                    Image(systemName: exercisePlanController.selectedExercise == exercise.exerciceId ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(exercisePlanController.selectedExercise == exercise.exerciceId ? .main : .gray)
                                                    Text(exercise.name)
                                                        .font(.title2)
                                                }
                                                .frame(minWidth: 30, maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                    }
                                }.frame(minHeight: 500 ,maxHeight: 500, alignment: .leading)
                            }
                            .frame(minWidth: 300, maxWidth: 300)
                            .padding()

                            Divider()

                            VStack(alignment: .leading, spacing: 30) {
                                
                                ParameterField(title: "Nombre de séries", exerciseLegends: "3", text: $exercisePlanController.series)
                                    .padding(.leading, 5)
                                ParameterField(title: "Nombre de répétitions", exerciseLegends: "12", text: $exercisePlanController.reps)
                                    .padding(.leading, 5)
                                ParameterField(title: "Charge", exerciseLegends: "45 lbs", text: $exercisePlanController.charge)
                                    .padding(.leading, 5)
                                ParameterField(title: "Temps de repos", exerciseLegends: "120 (sec)", text: $exercisePlanController.repos)
                                    .padding(.leading, 5)
                                
                                Button(action: {}) {
                                    Text("Ajouter")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                .buttonStyle(RoundedButtonStyle(width: 125 ,action: {
                                    exercisePlanController.addExercise()
                                }))
                            }
                            .padding()
                            .frame(minWidth: 150, maxWidth: 150)
                        }
                    }

                    GroupBox {
                        ScrollView{
                            VStack {
                                Text("Exercices ajoutés :")
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                
                                if exercisePlanController.addedExercises.isEmpty {
                                    Text("Aucun exercice ajouté")
                                        .foregroundColor(.gray)
                                 
                                } else {
                                    ForEach(exercisePlanController.addedExercises) { exercise in
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(exercise.name)
                                                        .font(.headline)
                                                    Text("Séries: \(exercise.sets), Répétitions: \(exercise.reps)")
                                                    Text("Charge: \(exercise.charge)")
                                                }
                                                Spacer()
                                                Button(action: {}) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.black)
                                                }.buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: .red.opacity(0.8), hoveringColor: .red, padding: 0, action: {
                                                    exercisePlanController.removeExercise(exercise)
                                                }))
                                            }
                                            .padding()
                                        }
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(16)
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
}

struct ParameterField: View {
    var title: String
    var exerciseLegends : String
    @Binding var text: String
    @FocusState private var isTyping: Bool
        
    init(title: String, exerciseLegends: String ,text: Binding<String>) {
        self.title = title
        self.exerciseLegends = exerciseLegends
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.headline)
            
            TextFieldNumberStyle(
                title: exerciseLegends,
                text: $text,
                isTyping: $isTyping
            )
            .frame(width: 125)
        }
    }
}

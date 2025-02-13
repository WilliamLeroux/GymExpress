//
//  ExercisePlanCreationView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-29.
//

import SwiftUI

struct ExercisePlanCreationView: View {
    @StateObject private var controller = ExercisePlanController()
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
                                Picker("", selection: $controller.selectedType) {
                                    ForEach(controller.exerciseLegends, id: \.self) { type in
                                        Text(type).tag(type as String?)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: .infinity)

                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(controller.exercisesByType[controller.selectedType] ?? [], id: \.self) { exercise in
                                            Button(action: {
                                                controller.selectedExercise = exercise
                                            }) {
                                                HStack {
                                                    Image(systemName: controller.selectedExercise == exercise ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(controller.selectedExercise == exercise ? .blue : .gray)
                                                    Text(exercise)
                                                        .font(.title2)
                                                }
                                                .frame(minWidth: 30, maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                    }
                                }.frame(maxHeight: 500)
                            }
                            .frame(minWidth: 300, maxWidth: 300)
                            .padding()

                            Divider()

                            VStack(alignment: .leading, spacing: 30) {
                                ParameterField(title: "Nombre de séries", exerciseLegends: "3", text: $controller.series)
                                    .padding(.leading, 5)
                                ParameterField(title: "Nombre de répétitions", exerciseLegends: "12", text: $controller.reps)
                                    .padding(.leading, 5)
                                ParameterField(title: "Charge", exerciseLegends: "45 lbs", text: $controller.charge)
                                    .padding(.leading, 5)
                                ParameterField(title: "Temps de repos", exerciseLegends: "120 (sec)", text: $controller.repos)
                                    .padding(.leading, 5)
                                
                                Button(action: {}) {
                                    Text("Ajouter")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                .buttonStyle(RoundedButtonStyle(width: 125 ,action: {
                                    controller.addExercise()
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
                                
                                if controller.addedExercises.isEmpty {
                                    Text("Aucun exercice ajouté")
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(controller.addedExercises) { exercise in
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(exercise.name)
                                                        .font(.headline)
                                                    Text("Séries: \(exercise.series), Répétitions: \(exercise.reps)")
                                                    Text("Charge: \(exercise.charge), Repos: \(exercise.repos)")
                                                }
                                                Spacer()
                                                Button(action: {}) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.black)
                                                }.buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: .red.opacity(0.8), hoveringColor: .red, padding: 0, action: {
                                                    controller.removeExercise(exercise)
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

struct ExercisePlanCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePlanCreationView(day: "Lundi")
    }
}

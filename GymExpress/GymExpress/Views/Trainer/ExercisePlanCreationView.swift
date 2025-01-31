//
//  ExercisePlanCreationView.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-29.
//

import SwiftUI
struct ExercisePlanCreationView: View {
    @State private var selectedType: String = ""
    @State private var selectedExercise: String? = nil
    @State private var series: String = ""
    @State private var reps: String = ""
    @State private var charge: String = ""
    @State private var repos: String = ""
    @State private var addedExercises: Set<String> = []
    
    let day: String
    
    let exerciseTypes = ["Musculation", "Cardio", "Étirement", "Corps-poids"]
    
    let exercisesByType: [String: [String]] = [
        "Musculation": [
            "Développé couché", "Squat", "Soulevé de terre", "Tirage vertical",
            "Extension des triceps", "Curl biceps", "Crunch", "Extension lombaire",
            "Élévation latérale", "Développé épaules", "Rowing buste penché",
            "Extension des mollets", "Presse à cuisses", "Hip thrust", "Dips", "Traction"
        ],
        "Cardio": [
            "Course à pied", "Vélo", "Rameur", "Natation", "Saut à la corde"
        ],
        "Étirement": [
            "Étirement des ischio-jambiers", "Étirement du quadriceps", "Étirement des mollets",
            "Étirement des épaules", "Étirement du dos"
        ],
        "Corps-poids": [
            "Pompes", "Squats sautés", "Planche", "Burpees", "Mountain climbers"
        ]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    Text("Plan d'exercice pour \(day)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            GroupBox {
                                VStack(alignment: .leading, spacing: 15) {
                                    Picker("Type d'exercice", selection: $selectedType) {
                                        ForEach(exerciseTypes, id: \.self) { type in
                                            Text(type).tag(type as String?)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(exercisesByType[selectedType] ?? [], id: \.self) { exercise in
                                                HStack {
                                                    Button(action: {
                                                        selectedExercise = exercise
                                                    }) {
                                                        HStack {
                                                            Image(systemName: selectedExercise == exercise ? "checkmark.circle.fill" : "circle")
                                                                .foregroundColor(selectedExercise == exercise ? Color.main : .gray)
                                                            Text(exercise)
                                                                .foregroundColor(.primary)
                                                        }
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.vertical, 4)
                                            }
                                        }
                                    }
                                    .frame(minHeight: 100, maxHeight: geometry.size.height / 2)
                                }
                            }
                            
                            GroupBox(label: Text("Paramètres")) {
                                VStack(spacing: 15) {
                                    ParameterField(title: "Nombre de séries", text: $series)
                                    ParameterField(title: "Nombre de répétitions", text: $reps)
                                    ParameterField(title: "Charge", text: $charge)
                                    ParameterField(title: "Temps de repos", text: $repos)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button(action: {
                                addExercise()
                            }) {
                                Text("Ajouter")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            .buttonStyle(RoundedButtonStyle(width: 350, height: 75, color: Color.main, hoveringColor: Color.green, padding: 2, action: {}))
                            .padding()

                        }
                        
                        GroupBox() {
                            ScrollView {
                                VStack {
                                    Text("Exercices ajoutés :")
                                        .font(.headline)
                                        .padding(.bottom, 10)
                                    
                                    ForEach(addedExercises.sorted(), id: \.self) { exercise in
                                        VStack {
                                            Text(exercise)
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            
                                            VStack {
                                                Text("Séries: \(series)")
                                                Text("Répétitions: \(reps)")
                                                Text("Charge: \(charge)")
                                                Text("Repos: \(repos)")
                                            }
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        .padding()
                                        .background(Color.main)
                                        .cornerRadius(8)
                                        .padding(10)
                                        .frame(maxWidth: .infinity)
                                        .onTapGesture {
                                            () //Vas devoir supprimer de la list
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                    }
                    .frame(maxHeight: .infinity)
                    .padding(10)
                }
            }
        }
    }
    
    private func addExercise() {
        if let exercise = selectedExercise {
            addedExercises.insert(exercise)
            selectedExercise = nil
        }
    }
}

struct ParameterField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            TextField(title, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.main.opacity(0.5), lineWidth: 2))
        }
    }
}

struct ExercisePlanCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePlanCreationView(day: "Lundi")
    }
}

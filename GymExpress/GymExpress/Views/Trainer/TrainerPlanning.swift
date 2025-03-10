//
//  TrainerPlanning.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct TrainingPlaningView: View {
    @ObservedObject var controller = TrainerPlanningController.shared
    @ObservedObject var exercisePlanController = ExercisePlanController.shared
    
    @State private var lastName: String = "" /// Nom de famille saisi pour la recherche
    @State private var firstName: String = "" /// Prénom saisi pour la recherche
    @FocusState private var isTypingLastName: Bool /// Indique si l'utilisateur est en train de taper le nom de famille
    @FocusState private var isTypingFirstName: Bool /// Indique si l'utilisateur est en train de taper le prénom
    
    @State private var selectedExercises: [ExerciseModel] = []
    
    let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"] /// Jours de la semaine pour la planification
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section de recherche
                GroupBox {
                    VStack(alignment: .leading, spacing: 15) {
                        Spacer()
                        HStack(spacing: 16) {
                            VStack(alignment: .center, spacing: 8) {
                                TextFieldStyle(title: "Entrez le nom", text: $lastName, isTyping: $isTypingLastName)
                            }
                            
                            VStack(alignment: .center, spacing: 8) {
                                TextFieldStyle(title: "Entrez le prénom", text: $firstName, isTyping: $isTypingFirstName)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {}) {
                            Text("Recherche")
                                .font(.headline)
                        }
                        .buttonStyle(RoundedButtonStyle(width: 200, height: 50,action: {
                            controller.searchClients(firstName: firstName, lastName: lastName)
                        }))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            if controller.selectedClients.isEmpty {
                                Text("Aucun client trouvé")
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, minHeight: 400)
                                    .border(Color.gray.opacity(0.2))
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 8) {
                                        ForEach(controller.selectedClients, id: \.id) { client in
                                            Text("\(client.name) \(client.lastName)")
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .background(controller.selectedClient?.id == client.id ? Color.main.opacity(0.4) : Color.clear)
                                                .cornerRadius(8)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    controller.selectedClient = client
                                                }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 400, alignment: .top)
                                }
                                .frame(maxHeight: controller.selectedClient == nil ? 400 : 100)
                                .border(Color.gray.opacity(0.2))
                            }
                        }
                    }
                    .padding()
                }
                
                // Section des jours
                if let client = controller.selectedClient {
                    GroupBox {
                        VStack {
                            Text("Planification pour \(client.name) \(client.lastName)")
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            let days = weekDays
                            
                            HStack(alignment: .top, spacing: 10) {
                                ForEach(days, id: \.self) { day in
                                    DayColumn(day: day)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct DayColumn: View {
    @ObservedObject var controller = TrainerPlanningController.shared
    @StateObject private var exercisePlanController = ExercisePlanController.shared
    
    let day: String
    @State private var isDeleteMode: Bool = false
    @State private var showExercisePlan: Bool = false
    
    private var hasWorkout: Bool {
        let dayIndex = getDayIndex(day)
        return controller.workouts.contains { $0.day == dayIndex }
    }
    
    private func getDayIndex(_ day: String) -> Int {
        let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
        return weekDays.firstIndex(of: day) ?? 0
    }
    
    var body: some View {
        VStack {
            Text(day)
                .font(.system(size: 14, weight: .medium))
                .padding(.bottom, 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hasWorkout ? Color.green : Color.red, lineWidth: 4)
                    .frame(width: 105, height: 170)
                    .animation(.easeInOut, value: hasWorkout)
                
                Image(systemName: "dumbbell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(hasWorkout ? Color.green : Color.red)
            }
            
            HStack(spacing: 15) {
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, padding: 0, action: {
                    showExercisePlan.toggle()
                }))
                .sheet(isPresented: $showExercisePlan) {
                    VStack {
                        ExercisePlanCreationView(exercisePlanController: exercisePlanController, day: day)
                        
                        HStack {
                            Button(action: {}) {
                                Text("Sauvegarder")
                                    .font(.headline)
                            }
                            .buttonStyle(RoundedButtonStyle(width: 125, height: 50, padding: 2, action: saveWorkout))
                            .padding()
                            
                            Button(action: {}) {
                                Text("Annuler")
                                    .font(.headline)
                            }
                            .buttonStyle(RoundedButtonStyle(width: 125, height: 50, color: .red.opacity(0.8), hoveringColor: .red, padding: 2, action: {
                                exercisePlanController.clearExercises()
                                showExercisePlan.toggle()
                            }))
                            .padding()
                        }
                    }
                    .frame(minWidth: 900, minHeight: 750)
                }
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: .red.opacity(0.8), hoveringColor: .red, padding: 0, action: {
                    isDeleteMode.toggle()
                    deleteWorkout()
                }))
            }
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
    }
    
    func saveWorkout() {
        guard let selectedClient = controller.selectedClient else {
            return
        }
        
        let exercises = exercisePlanController.getExerciseModels()
        
        if exercises.isEmpty {
            return
        }
        
        let dayIndex = getDayIndex(day)
        
        controller.addWorkout(
            for: selectedClient,
            exercises: exercises,
            day: dayIndex
        )
        
        showExercisePlan.toggle()
    }
    
    func deleteWorkout() {
        let dayIndex = getDayIndex(day)
        
        if let workoutToDelete = controller.workouts.first(where: { $0.day == dayIndex }) {
            controller.deleteWorkout(workoutToDelete)
        } else {}
    }
}


// Preview
struct TrainingPlanView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPlanView()
    }
}

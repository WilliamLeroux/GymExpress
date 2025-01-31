//
//  TrainerPlanning.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct TrainingPlaningView: View {
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var selectedClients: [String] = []
    @State private var selectedClient: String? = nil
    @FocusState private var isTypingLastName: Bool
    @FocusState private var isTypingFirstName: Bool
    
    let allClients = [
        "John Doe",
        "Jane Smith",
        "Alice Johnson",
        "Bob Brown",
        "Samuel Oliveira Martel",
        "William Leroux",
        "Nicolas Morin"
    ]
    
    let weekDays = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section de recherche
                GroupBox {
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nom :")
                            TextFieldStyle(title: "Entrez le nom", text: $lastName, isTyping: $isTypingLastName)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prénom :")
                            TextFieldStyle(title: "Entrez le prénom", text: $firstName, isTyping: $isTypingFirstName)
                        }
                        
                        Button(action: {
                            searchClients()
                        }) {
                            Text("Recherche")
                                .font(.headline)
                        }
                        .buttonStyle(RoundedButtonStyle(width: 350, height: 75, action: {
                            searchClients()
                        }))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)


                        
                        VStack(alignment: .leading, spacing: 8) {
                            if selectedClients.isEmpty {
                                Text("Aucun client trouvé")
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .border(Color.gray.opacity(0.2))
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 8) {
                                        ForEach(selectedClients, id: \.self) { client in
                                            Text(client)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .background(selectedClient == client ? Color.main.opacity(0.4) : Color.clear)
                                                .cornerRadius(8)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    selectedClient = client
                                                }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: 200)
                                .border(Color.gray.opacity(0.2))
                            }
                        }
                    }
                    .padding()
                }
                
                // Section des jours
                if let client = selectedClient {
                    GroupBox {
                        VStack {
                            Text("Planification pour \(client)")
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 10) {
                                    ForEach(weekDays, id: \.self) { day in
                                        DayColumn(day: day)
                                    }
                                }
                                .frame(alignment: .center)
                                .padding()
                            }
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func searchClients() {
        let lowercasedFirstName = firstName.lowercased()
        let lowercasedLastName = lastName.lowercased()
        
        selectedClients = allClients.filter { client in
            let fullName = client.lowercased()
            return (lowercasedFirstName.isEmpty || fullName.contains(lowercasedFirstName)) &&
            (lowercasedLastName.isEmpty || fullName.contains(lowercasedLastName))
        }
        
        // Réinitialise le client sélectionné si aucun ne correspond
        if !selectedClients.contains(selectedClient ?? "") {
            selectedClient = nil
        }
    }
}

struct DayColumn: View {
    let day: String
    @State private var isDeleteMode: Bool = false
    @State private var showExercisePlan: Bool = false
    
    var body: some View {
        VStack {
            Text(day)
                .font(.system(size: 14, weight: .medium))
                .padding(.bottom, 5)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(isDeleteMode ? Color.red : Color.green, lineWidth: 4)
                .frame(height: 120)
                .overlay(
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(0..<0) { _ in
                                Text("")
                            }
                        }
                        .padding(4)
                    }
                )
                .animation(.easeInOut, value: isDeleteMode)
            
            HStack(spacing: 15) {
                Button(action: {
                    showExercisePlan.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, padding: 0, action: {
                    showExercisePlan.toggle()
                }))
                .sheet(isPresented: $showExercisePlan) {
                    VStack {
                        ExercisePlanCreationView(day: day)

                        HStack{
                            Button(action: {}) {
                                Text("Sauvegarder")
                                    .font(.headline)
                            }
                            .buttonStyle(RoundedButtonStyle(width: 125, height: 50, padding: 2 , action: {showExercisePlan.toggle()}))
                            .padding()
                            
                            Button(action: {}) {
                                Text("Annuler")
                                    .font(.headline)
                            }
                            .buttonStyle(RoundedButtonStyle(width: 125, height: 50,color: .red.opacity(0.8), hoveringColor: .red ,padding: 2 , action: {showExercisePlan.toggle()}))
                            .padding()
                        }
                    }
                    .frame(minWidth: 900, minHeight: 700)
                }

                Button(action: {
                    isDeleteMode.toggle()
                    if isDeleteMode {
                        deleteDay()
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
                .buttonStyle(RoundedButtonStyle(width: 30, height: 30, color: .red.opacity(0.8), hoveringColor: .red, padding: 0, action: {
                    isDeleteMode.toggle()
                    if isDeleteMode {
                        deleteDay()
                    }
                }))
            }
            .padding(.top, 5)
        }
    }
    
    private func editDay() {
        // Implémenter la logique d'édition
    }
    
    private func deleteDay() {
        // Implémenter la logique de suppression
    }
}

// Preview
struct TrainingPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigation()
        TrainingPlanView()
    }
}

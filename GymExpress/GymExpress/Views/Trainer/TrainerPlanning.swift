//
//  TrainerPlanning.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//

import SwiftUI

struct TrainingPlanView: View {
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var selectedClients: [String] = []
    @State private var selectedClient: String? = nil
    
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
                                .foregroundColor(.secondary)
                            TextField("Entrez le nom", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prénom :")
                                .foregroundColor(.secondary)
                            TextField("Entrez le prénom", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(action: {
                            searchClients()
                        }) {
                            Text("Recherche")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.main)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        
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
                                            .frame(width: 80)
                                    }
                                }
                                .padding()
                            }
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
                    editDay()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    isDeleteMode.toggle()
                    if isDeleteMode {
                        deleteDay()
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(isDeleteMode ? .red : .blue)
                }
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

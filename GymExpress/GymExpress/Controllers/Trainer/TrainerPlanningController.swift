//
//  TrainerPlanningController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-09.
//

import SwiftUI

class TrainerPlanningController: ObservableObject {
    static let shared = TrainerPlanningController()

    @Published var appointments: [AppointmentModel] = []
    @Published var workouts: [WorkoutModel] = []
    @Published var selectedClients: [UserModel] = []
    @Published var selectedClient: UserModel?
    @Published private var allUsers: [UserModel] = []

    var dbManager: DatabaseManager = DatabaseManager.shared
    var trainer: UserModel = LoginController.shared.currentUser!
    
    private init() {
        loadInitialData()
    }
    
    private func loadInitialData() {
        if let users: [UserModel] = dbManager.fetchDatas(request: Request.selectAllCLient, params: []){
            allUsers = users
        } else {
            print("Utilisateur non trouvé")
        }
    }

    /// Fonction de recherche des clients en fonction du prénom et du nom saisis
    func searchClients(firstName: String, lastName: String) {
        let lowercasedFirstName = firstName.lowercased()
        let lowercasedLastName = lastName.lowercased()

        selectedClients = allUsers.filter { client in
            let fullName = "\(client.name.lowercased()) \(client.lastName.lowercased())"
            return (lowercasedFirstName.isEmpty || fullName.contains(lowercasedFirstName)) &&
                   (lowercasedLastName.isEmpty || fullName.contains(lowercasedLastName))
        }

        // Réinitialise le client sélectionné si aucun ne correspond
        if let selectedClient = selectedClient, !selectedClients.contains(where: { $0.id == selectedClient.id }) {
            self.selectedClient = nil
        }
    }

    /// Supprimer un rendez-vous
    func deleteAppointment(_ appointment: AppointmentModel) {
        appointments.removeAll { $0.id == appointment.id }
    }

    /// Ajouter un entraînement pour un client
    func addWorkout(for client: UserModel, exercises: [ExerciseModel], day: Int) {
        let newWorkout = WorkoutModel(
            clientId: client.id,
            name: "\(client.id)-\(day)",
            exerciceList: exercises,
            day: day
        )
        print(newWorkout)
        workouts.append(newWorkout)
    }
    
    /// Supprimer un entraînement
    func deleteWorkout(_ workout: WorkoutModel) {
        workouts.removeAll { $0.id == workout.id }
    }
}

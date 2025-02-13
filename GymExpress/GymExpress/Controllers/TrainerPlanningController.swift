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

    var trainer = UserModel(
        name: "Entraîneur",
        lastName: "Exemple",
        email: "coach@example.com",
        password: "password",
        type: .trainer,
        membership: MembershipData(grade: .platinum, count: 100),
        salary: 50000
    )

    var allUsers: [UserModel] = [
        UserModel(name: "Samuel", lastName: "Oliveira", email: "samuel@example.com", password: "", type: .client, membership: MembershipData(grade: .platinum, count: 100), salary: nil),
        UserModel(name: "Alice", lastName: "Dupont", email: "alice@example.com", password: "", type: .client, membership: MembershipData(grade: .gold, count: 50), salary: nil),
        UserModel(name: "Bob", lastName: "Martin", email: "bob@example.com", password: "", type: .client, membership: MembershipData(grade: .silver, count: 30), salary: nil)
    ]

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

    /// Ajouter un rendez-vous pour un client
    func addAppointment(for client: UserModel, date: Date) {
        let appointment = AppointmentModel(
            trainerId: trainer.id,
            clientId: client.id,
            name: "Séance d'entraînement",
            description: "Séance personnalisée avec \(trainer.name)",
            date: date
        )
        appointments.append(appointment)
    }

    /// Supprimer un rendez-vous
    func deleteAppointment(_ appointment: AppointmentModel) {
        appointments.removeAll { $0.id == appointment.id }
    }

    /// Ajouter un entraînement pour un client
    func addWorkout(for client: UserModel, exercises: [ExerciseModel], day: Int) {
        let newWorkout = WorkoutModel(
            name: "Full Body",
            exerciceList: exercises,
            day: day
        )
        workouts.append(newWorkout)
    }

    /// Supprimer un entraînement
    func deleteWorkout(_ workout: WorkoutModel) {
        workouts.removeAll { $0.id == workout.id }
    }
}

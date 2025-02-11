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
    
    var trainer: UserModel = UserModel(
        name: "Entraîneur",
        lastName: "Exemple",
        email: "coach@example.com",
        password: "password",
        type: .trainer,
        membership: MembershipData(grade: .platinum, count: 100),
        salary: 50000
    )

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

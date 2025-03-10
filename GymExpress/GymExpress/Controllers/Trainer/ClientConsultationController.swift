//
//  ClientConsultationController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import SwiftUI

class ClientConsultationController: ObservableObject {
    static let shared = ClientConsultationController()
    
    // MARK: - Published Properties
    var dbManager: DatabaseManager = DatabaseManager.shared
    var scheduleTrainerController: ScheduleTrainerController = ScheduleTrainerController.shared
    @Published var errorMessage: String?
    @Published private var allUsers: [UserModel] = []
    @Published private(set) var filteredUsers: [UserModel] = []
    @Published var appointments: [AppointmentModel] = []
    @Published var search: String = "" {
        didSet {
            filterUsers()
        }
    }
    
    // MARK: - Initialization
    private init() {
        loadInitialData()
    }
    
    // MARK: - User Management
    private func loadInitialData() {
        if let users: [UserModel] = dbManager.fetchDatas(request: Request.selectAllCLient, params: []){
            allUsers = users
            filterUsers()
        } else {
            print("Utilisateur non trouvé")
        }
        if let appointments: [AppointmentModel] = dbManager.fetchDatas(request: Request.selectAllAppointment, params: []) {
            self.appointments =  appointments
        } else {
            print ("Aucun rendez-vous trouvé")
        }
    }
    
    // Rafraîchir la liste d'utilisateur
    private func filterUsers() {
        if search.isEmpty {
            filteredUsers = allUsers.filter { $0.type == .client }
        } else {
            filteredUsers = allUsers.filter { user in
                user.type == .client &&
                (user.name.localizedCaseInsensitiveContains(search) ||
                 user.lastName.localizedCaseInsensitiveContains(search) ||
                 user.email.localizedCaseInsensitiveContains(search))
            }
        }
    }
    
    // Ajouter un utilisateur
    func addUser(_ user: UserModel) -> Bool {
        let success = dbManager.insertData(request: Request.createUser, params: user)
        if success {
            allUsers.append(user)
            filterUsers()
            return true
        }
        return false
    }
    
    // Supprimer un utilisateur
    func deleteUser(_ user: UserModel) {
        allUsers.remove(at: allUsers.firstIndex(where: { $0.id == user.id })!)
        appointments.removeAll { $0.clientId == user.id }
        
        let success = dbManager.updateData(request: Request.update(table: .users, columns: ["is_deleted"], condition: "WHERE id = '\(user.id)'"), params: [true])
        if success {
            print("Delete success")
        }
        filterUsers()
    }
    
    // Mettre à jour un utilisateur
    func updateUser(_ user: UserModel) {
        if let index = allUsers.firstIndex(where: { $0.id == user.id }) {
            let success = dbManager.updateData(request: Request.update(table: .users, columns: ["name", "last_name", "email", "membership"], condition: "WHERE id = '\(user.id)'"), params: [user.name, user.lastName, user.email, user.membership!])
            if success {
                allUsers[index] = user
                filterUsers()
            }
        }
    }
    
    // Appointment Management
    func createAppointment(clientId: Int, trainerId: Int, name: String, description: String, date: Date, selectedTimeSlot: String, nameUser: String) {
            guard let startHour = extractStartHour(from: selectedTimeSlot) else {
                errorMessage = "Erreur : Timeslot invalide."
                return
            }

            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: date)
            components.hour = startHour
            components.minute = 0

            guard let appointmentDate = calendar.date(from: components) else {
                errorMessage = "Erreur : Impossible de créer la date du rendez-vous."
                return
            }

            let existingAppointment = appointments.first { $0.clientId == clientId && Calendar.current.isDate($0.date!, inSameDayAs: appointmentDate) }
            guard existingAppointment == nil else {
                errorMessage = "Le client a déjà un rendez-vous à cette date."
                return
            }

            let newAppointment = AppointmentModel(
                trainerId: trainerId,
                clientId: clientId,
                name: name,
                description: description,
                date: appointmentDate
            )

            let newEvent = CalendarEvent(
                startDate: appointmentDate,
                endDate: appointmentDate.addingTimeInterval(3600),
                title: "\(name)-Rendez-vous",
                recurrenceType: .none
            )

            let success = dbManager.insertData(request: Request.createAppointment, params: newAppointment)

            if success {
                scheduleTrainerController.addEvent(event: newEvent, startDate: appointmentDate)
                appointments.append(newAppointment)
                errorMessage = nil
            } else {
                errorMessage = "Erreur lors de l'ajout du rendez-vous."
            }
        }

    // Fonction pour extraire l'heure de début à partir du timeslot
    func extractStartHour(from timeSlot: String) -> Int? {
        let components = timeSlot.split(separator: "-").first?.trimmingCharacters(in: .whitespaces)
        return components?.split(separator: ":").first.flatMap { Int($0) }
    }

    
    func validateFields(name: String, lastName: String, email: String, password: String) -> Bool {
        guard !name.isEmpty else { return false }
        guard !lastName.isEmpty else { return false }
        guard !email.isEmpty, isValidEmail(email) else { return false }
        guard !password.isEmpty, password.count >= 6 else { return false }
        
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func getAppointments(for userId: Int) -> [AppointmentModel] {
        let result = appointments.filter { $0.clientId == userId }
        return result
    }

    func getAvailableTimeSlots(for date: Date) -> [String] {
        return [
            "06:00 - 07:00",
            "07:00 - 08:00",
            "08:00 - 09:00",
            "09:00 - 10:00",
            "10:00 - 11:00",
            "11:00 - 12:00",
            "12:00 - 13:00",
            "13:00 - 14:00",
            "14:00 - 15:00",
            "15:00 - 16:00",
            "16:00 - 17:00",
            "17:00 - 18:00",
            "18:00 - 19:00",
            "19:00 - 20:00",
            "20:00 - 21:00",
            "21:00 - 22:00"
        ]
    }
    
    // MARK: - Helper Methods
    private func getNextAppointmentId() -> Int {
        return appointments.map { $0.id }.max().map { $0 + 1 } ?? 1
    }
}

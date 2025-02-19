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
        print("Exécution de la requête:")
        if let users: [UserModel] = dbManager.fetchDatas(request: Request.selectAllCLient, params: []){
            print("Utilisateur trouvé: ", users)
            allUsers = users
            filterUsers()
        } else {
            print("Utilisateur non trouvé")
        }
    }
    
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
    
    func addUser(_ user: UserModel) {
        allUsers.append(user)
        filterUsers()
    }
    
    func deleteUser(_ user: UserModel) {
        allUsers.removeAll { $0.id == user.id }
        // Également supprimer les rendez-vous associés
        appointments.removeAll { $0.clientId == user.id }
        filterUsers()
    }
    
    func updateUser(_ updatedUser: UserModel) {
        if let index = allUsers.firstIndex(where: { $0.id == updatedUser.id }) {
            allUsers[index] = updatedUser
            filterUsers()
        }
    }
    
    // MARK: - Appointment Management
    func createAppointment(clientId: Int, trainerId: Int, name: String, description: String, date: Date) {
        let newAppointment = AppointmentModel(
            trainerId: 1,
            clientId: clientId,
            name: name,
            description: description,
            date: date
        )
        
        DispatchQueue.main.async {
            self.appointments.append(newAppointment)
        }
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

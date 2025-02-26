//
//  ClientConsultationController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

//********** TODO : validation des données dans le formulaire.

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
    
    // MARK: - Appointment Management
    func createAppointment(clientId: Int, trainerId: Int, name: String, description: String, date: Date) {
        let newAppointment = AppointmentModel(
            trainerId: 1,
            clientId: clientId,
            name: name,
            description: description,
            date: date
        )
        
        let success = dbManager.insertData(request: Request.createAppointment, params: newAppointment)
        
        if success {
            appointments.append(newAppointment)
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

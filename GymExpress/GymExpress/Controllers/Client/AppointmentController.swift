//
//  AppointmentC.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import SwiftUI

class AppointmentController: ObservableObject {
    static let shared = AppointmentController() /// Singleton
    private let dbManager = DatabaseManager.shared /// Database
    
    @Published var appointments: [AppointmentModel] = [] /// Tableau des rendez-vous
    @Published var selectedIndex: Int = -1 /// Rendez-vous sélectionné
    @Published var selectedEditIndex: Int = -1 /// Rendez-vous à modifié sélectionné
    
    private init(){
        loadInitialData()
    }
    
    /// Charge les données initales
    private func loadInitialData() {
        if let tempAppointments: [AppointmentModel] = dbManager.fetchDatas(request: Request.select(table: DbTable.appointments, columns: ["*"], condition: "WHERE user_id = ? AND is_deleted = ?"), params: [LoginController.shared.currentUser!.id, false]) {
            appointments = tempAppointments
        }
    }
    
    /// Trouve le nom de l'entraîneur
    /// - Parameter trainerId: Id de l'entraîneur
    /// - Returns: Une string avec le nom de l'entraîneur
    func getTrainerName(trainerId: Int) -> String {
        if let trainer: [String] = dbManager.fetchDatas(request: Request.select(table: DbTable.users, columns: ["name", "last_name"], condition: "WHERE id = \(trainerId)"), params: []) {
            return "\(trainer[0]) \(trainer[1])"
        }
        return "Inconnu"
    }
    
    /// Supprime le rendez-vous sélectionné
    func deleteAppointment() {
        if selectedIndex >= 0 {
            let success = dbManager.updateData(request: Request.update(table: DbTable.appointments, columns: ["is_deleted"]), params: [true])
            if success {
                appointments.remove(at: selectedIndex)
            }
        }
    }
    
    /// Met à jour le rendez-vous sélectionné
    /// - Parameters:
    ///   - date: Nouvelle date
    ///   - time: Nouvelle heure
    func updateAppointment(date: Date, time: Date) {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var dateComp = components
        dateComp.hour = calendar.component(.hour, from: time)
        dateComp.minute = calendar.component(.minute, from: time)
        
        let startDate = calendar.date(from: dateComp)!
        
        let success = dbManager.updateData(request: Request.update(table: DbTable.appointments, columns: ["date"]), params: [startDate])
        if success {
            appointments[selectedEditIndex].date = startDate
        }
    }
    
    func refresh() {
        loadInitialData()
    }
    
}

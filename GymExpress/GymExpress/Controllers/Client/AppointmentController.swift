//
//  AppointmentC.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import SwiftUI

class AppointmentController: ObservableObject {
    static let shared = AppointmentController()
    private let dbManager = DatabaseManager.shared
    
    @Published var appointments: [AppointmentModel] = []
    @Published var selectedIndex: Int = -1
    @Published var selectedEditIndex: Int = -1
    
    private init(){
        loadInitialData()
    }
    
    private func loadInitialData() {
        if let tempAppointments: [AppointmentModel] = dbManager.fetchDatas(request: Request.select(table: DbTable.appointments, columns: ["*"], condition: "WHERE user_id = ? AND is_deleted = ?"), params: [LoginController.shared.currentUser!.id, false]) {
            appointments = tempAppointments
        }
    }
    
    func getTrainerName(trainerId: Int) -> String {
        if let trainer: [String] = dbManager.fetchDatas(request: Request.select(table: DbTable.users, columns: ["name", "last_name"], condition: "WHERE id = \(trainerId)"), params: []) {
            return "\(trainer[0]) \(trainer[1])"
        }
        return "Inconnu"
    }
    
    func deleteAppointment() {
        if selectedIndex >= 0 {
            let success = dbManager.updateData(request: Request.update(table: DbTable.appointments, columns: ["is_deleted"]), params: [true])
            if success {
                appointments.remove(at: selectedIndex)
            }
        }
    }
    
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
    
}

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
    
    private init(){
        loadInitialData()
    }
    
    private func loadInitialData() {
        if let tempAppointments: [AppointmentModel] = dbManager.fetchDatas(request: Request.select(table: DbTable.appointments, columns: ["*"], condition: "WHERE user_id = \(LoginController.shared.currentUser?.id ?? 0)"), params: []) {
            appointments = tempAppointments
        }
    }
    
    func getTrainerName(trainerId: Int) -> String {
        if let trainer: [String] = dbManager.fetchDatas(request: Request.select(table: DbTable.users, columns: ["name", "last_name"], condition: "WHERE id = \(trainerId)"), params: []) {
            return "\(trainer[0]) \(trainer[1])"
        }
        return "Inconnu"
    }
    
}

//
//  DashBoardTrainerController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-26.
//

import SwiftUI
import Combine

class DashBoardTrainerController: ObservableObject {
    static let shared = DashBoardTrainerController()
    var dbManager: DatabaseManager = DatabaseManager.shared
    
    private init() {
        fetchAllAppointments()
    }
    
    func fetchAllAppointments() {
        guard let userId = LoginController.shared.currentUser?.id else {
            return
        }
        
        print("DANS FETCH ALL APPOINTMENTS")
        
        if let fetchAppointment: [AppointmentModel] = dbManager.fetchDatas(request: Request.select(table: DbTable.appointments, columns: ["*"], condition: "WHERE trainer_id = ?"), params: [userId]) {
            print(fetchAppointment)
        }
        else {
            print("FETCH ALL APPOINTMENTS ERROR")
        }
    }
}


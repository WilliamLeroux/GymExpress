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
    
    @Published var clientNames: [String: String] = [:]
    
    private init() {
        fetchAllAppointments()
    }
    
    func fetchAllAppointments() {
        guard let userId = LoginController.shared.currentUser?.id else {
            return
        }
        
        if let fetchAppointment: [AppointmentModel] = dbManager.fetchDatas(
            request: Request.select(
                table: DbTable.appointments,
                columns: ["*"],
                condition: "WHERE trainer_id = ?"
            ),
            params: [userId]
        ) {
            print(fetchAppointment)
            
            let clientIds = Set(fetchAppointment.map { $0.clientId })
            
            print(clientIds)
            
            fetchClientNames(clientIds: clientIds)
        } else {
            print("FETCH ALL APPOINTMENTS ERROR")
        }
    }
    
    private func fetchClientNames(clientIds: Set<Int>) {
        let idList = clientIds.map { String($0) }.joined(separator: ",")
        print(idList)
        if let clients: [String] = dbManager.fetchDatas(
            request: Request.select(
                table: DbTable.users,
                columns: ["id", "name", "last_name"],
                condition: "WHERE id IN (\(idList))"
            ),
            params: []
        ) {
            // TODO: CREER LA MAP SELON LE TABLEAU clients ET ASSIGNER DANS clientNames
            //DispatchQueue.main.async {
            //   self.clientNames = Dictionary(uniqueKeysWithValues: clients.map { ($0[0], "\($0[1]) \($0[2])") })
                print(clients)
            //}
        }
        else {
            print("ERREUR: Pas de clients trouvés")
        }
    }
}

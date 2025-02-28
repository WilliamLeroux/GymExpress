//
//  DashBoardTrainerController.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-26.
//

import SwiftUI
import Combine

struct AppointmentWithClientInfo {
    let appointment: AppointmentModel
    let clientId: Int
    let nom: String
    let prenom: String
    let fullName: String
    let description: String?
    
    init(appointment: AppointmentModel, clientInfo: (prenom: String, nom: String, description: String?)) {
        self.appointment = appointment
        self.clientId = appointment.clientId
        self.prenom = clientInfo.prenom
        self.nom = clientInfo.nom
        self.fullName = "\(clientInfo.prenom) \(clientInfo.nom)"
        self.description = clientInfo.description
    }
}

class DashBoardTrainerController: ObservableObject {
    static let shared = DashBoardTrainerController()
    var dbManager: DatabaseManager = DatabaseManager.shared
    
    @Published var appointments: [AppointmentModel] = []
    @Published var clientNames: [Int: String] = [:]
    @Published var appointmentsWithClientInfo: [AppointmentWithClientInfo] = []
    
    private init() {
        fetchAllAppointments()
    }
    
    func fetchAllAppointments() {
        guard let userId = LoginController.shared.currentUser?.id else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        if let fetchAppointment: [AppointmentModel] = dbManager.fetchDatas(
            request: Request.select(
                table: DbTable.appointments,
                columns: ["*"],
                condition: "WHERE trainer_id = ? AND date = ?"
            ),
            params: [userId, dateString]
        ) {
            DispatchQueue.main.async {
                self.appointments = fetchAppointment
            }
            
            let clientIds = Set(fetchAppointment.map { $0.clientId })
            fetchClientNames(clientIds: clientIds)
        } else {
            print("FETCH ALL APPOINTMENTS ERROR")
        }
    }
    
    
    private func fetchClientNames(clientIds: Set<Int>) {
        guard !clientIds.isEmpty else { return }
        
        let idList = clientIds.map { String($0) }.joined(separator: ",")
        
        if let clients: [String] = dbManager.fetchDatas(
            request: Request.select(
                table: DbTable.users,
                columns: ["id", "name", "last_name"],
                condition: "WHERE id IN (\(idList))"
            ),
            params: []
        ) {
            DispatchQueue.main.async {
                let clientArray = clients.chunked(into: 3)
                self.clientNames = Dictionary(uniqueKeysWithValues: clientArray.compactMap { client in
                    guard client.count == 3, let id = Int(client[0]) else { return nil }
                    return (id, "\(client[2]) \(client[1])")
                })
                
                self.createAppointmentsWithClientInfo()
            }
        } else {
            print("ERREUR: Pas de clients trouvés")
        }
    }
    
    func getAppointmentsWithClientInfo() -> [AppointmentWithClientInfo] {
        var result: [AppointmentWithClientInfo] = []
        
        for appointment in appointments {
            if let clients: [String] = dbManager.fetchDatas(
                request: Request.select(
                    table: DbTable.users,
                    columns: ["name", "last_name", "description"],
                    condition: "WHERE id = ?"
                ),
                params: [appointment.clientId]
            ) {
                if clients.count >= 2 {
                    let prenom = clients[0]
                    let nom = clients[1]
                    let description = clients.count > 2 ? clients[2] : nil
                    
                    let appointmentWithInfo = AppointmentWithClientInfo(
                        appointment: appointment,
                        clientInfo: (prenom: prenom, nom: nom, description: description)
                    )
                    result.append(appointmentWithInfo)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.appointmentsWithClientInfo = result
        }
        
        return result
    }
    
    func createAppointmentsWithClientInfo() -> [AppointmentWithClientInfo] {
        var result: [AppointmentWithClientInfo] = []
        
        for appointment in appointments {
            if let fullName = clientNames[appointment.clientId], fullName.contains(" ") {
                let components = fullName.components(separatedBy: " ")
                let nom = components.first ?? ""
                let prenom = components.dropFirst().joined(separator: " ")
                
                let appointmentWithInfo = AppointmentWithClientInfo(
                    appointment: appointment,
                    clientInfo: (prenom: prenom, nom: nom, description: nil)
                )
                result.append(appointmentWithInfo)
            }
        }
        
        DispatchQueue.main.async {
            self.appointmentsWithClientInfo = result
        }
        
        return result
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

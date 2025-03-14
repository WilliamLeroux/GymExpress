//
//  ClientProgressController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-03-02.
//

import SwiftUI

class ClientProgressController: ObservableObject {
    static let shared = ClientProgressController()
    private let db = DatabaseManager.shared
    private let calendar = Calendar.current
    
    @Published var objectives: [Objective] = []
    @Published var selectedObjective: Int = -1
    @Published var selectedObjectiveEdit: Int = -1
    
    private init() {
        loadInitalData()
    }
    
    private func loadInitalData() {
        objectives = db.fetchDatas(request: Request.select(table: DbTable.objectives, columns: ["id", "init_value", "max_value", "start_date", "end_date", "objective"], condition: "WHERE user_id = ? AND is_deleted = 0"), params: [LoginController.shared.currentUser?.id ?? 0]) ?? []
        
        if objectives != [] {
            for i in 0..<objectives.count {
                let objData : [ObjectiveData] = db.fetchDatas(request: Request.select(table: DbTable.objectives_data, columns: ["id", "data", "date"], condition: "WHERE objective_id = ?"), params: [objectives[i].dbId]) ?? []
                objectives[i].valueList = objData
                if objectives[i].valueList != [] {
                    sortData(index: i)
                }
            }
        }
    }
    
    private func sortData(index: Int) {
        objectives[index].valueList.sort { (data1, data2) -> Bool in
            if data1.date! < data2.date! {
                return true
            }
            return false
        }
        
        objectives[index].valueList.sort { (data1, data2) -> Bool in
            if data1.date! == data2.date! {
                if data1.value < data2.value {
                    return true
                }
            }
            return false
        }
    }
    
    /// Crée un nouvel objectif
    func addObjective(_ newObjective: String, _ selectedStartDate: Date, _ selectedEndDate: Date, _ initialValue: String, _ maxValue: String) {
        var tempObj = Objective(objective: newObjective, initValue: Int(initialValue)!, valueList: [], maxValue: Int(maxValue)!, yearStart: calendar.component(.year, from: selectedStartDate), monthStart: calendar.component(.month, from: selectedStartDate), dayStart: calendar.component(.day, from: selectedStartDate), yearEnd: calendar.component(.year, from: selectedEndDate), monthEnd: calendar.component(.month, from: selectedEndDate), dayEnd: calendar.component(.day, from: selectedEndDate))
        tempObj.userId = LoginController.shared.currentUser?.id ?? 0
        
        let success = db.insertData(request: Request.createObjective, params: tempObj)
        if success {
            objectives.append(tempObj)
        }
    }
    
    func deleteObjective(_ id: Int) {
        let success = db.updateData(request: Request.update(table: DbTable.objectives, columns: ["is_deleted"], condition: "WHERE id = ?"), params: [true, id])
        if success {
            objectives.remove(at: objectives.firstIndex(of: objectives.first(where: { $0.dbId == id })!)!)
        }
    }
    
    func addData(objectiveId: Int, value: Int, date: Date) -> Bool{
        if date > objectives[objectives.firstIndex(of: objectives.first(where: { $0.dbId == objectiveId })!)!].endDate || date < objectives[objectives.firstIndex(of: objectives.first(where: { $0.dbId == objectiveId })!)!].startDate{
            return false
        }
        
        if value > objectives[objectives.firstIndex(of: objectives.first(where: { $0.dbId == objectiveId })!)!].maxValue {
            return false
        }
        
        let tempData = ObjectiveData(objId: objectiveId, value: value, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date))
        if db.insertData(request: Request.createObjectiveData, params: tempData) {
            objectives[objectives.firstIndex(of: objectives.first(where: { $0.dbId == objectiveId })!)!].valueList.append(tempData)
            sortData(index: objectives.firstIndex(of: objectives.first(where: { $0.dbId == objectiveId })!)!)
        }
        
        return true
    }
    
}

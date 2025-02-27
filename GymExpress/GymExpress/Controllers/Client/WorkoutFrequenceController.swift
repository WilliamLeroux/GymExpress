//
//  WorkoutFrequenceController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import SwiftUI

class WorkoutFrequenceController: ObservableObject {
    static let shared = WorkoutFrequenceController()
    private let dbManager = DatabaseManager.shared
    private var frequences: [FrequenceModel] = []
    
    @Published var week: [Day] = []
    
    private init() {}
    
    private func loadInitialData() {
        //frequences = dbManager.fetchDatas(request: Request.select(table: DbTable.frequence, columns: ["id", "user_id", "date"], condition: <#T##String#>), params: [])
    }
    
    func addPresence(date: Date) {
        
    }
}

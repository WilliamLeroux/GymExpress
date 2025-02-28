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
    private let calendar = Calendar.current
    private var frequences: [FrequenceModel] = []
    private var currentMonth: Int
    private var currentYear: Int
    @Published var currentDate: Date = Date()
    @Published var month: [Day] = []
    
    private init() {
        currentMonth = calendar.component(.month, from: Date(timeIntervalSinceNow: 0))
        currentYear = calendar.component(.year, from: Date(timeIntervalSinceNow: 0))
        loadInitialData()
        month = [Day(name: "Dimanche", count: 0), Day(name: "Lundi", count: 0), Day(name: "Mardi", count: 0), Day(name: "Mercredi", count: 0), Day(name: "Jeudi", count: 0), Day(name: "Vendredi", count: 0), Day(name: "Samedi", count: 0)]
        loadData()
    }
    
    private func loadInitialData() {
        frequences = dbManager.fetchDatas(request: Request.select(table: DbTable.frequence, columns: ["id", "user_id", "date"], condition: "WHERE user_id = ?"), params: [LoginController.shared.currentUser?.id ?? -1]) ?? []
    }
    
    private func loadData() {
        for i in 0..<month.count {
            month[i].count = 0
        }
        frequences.forEach { (freq) in
            if freq.date != nil {
                if calendar.component(.month, from: freq.date!) == currentMonth && calendar.component(.year, from: freq.date!) == currentYear {
                    month[calendar.component(.weekday, from: freq.date!) - 1].count += 1
                }
            }
        }
    }
    
    func addPresence(date: Date) {
        let freq = FrequenceModel(userId: LoginController.shared.currentUser?.id ?? -1, date: date, presence: true)
        let success = dbManager.insertData(request: Request.createFrequence, params: freq)
        if success {
            frequences.append(freq)
            loadData()
        }
    }
    
    func increaseMonth() {
        if currentMonth == 12 {
            currentMonth = 1
            currentYear += 1
        } else {
            currentMonth += 1
        }
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        loadData()
    }
    
    func decreaseMonth() {
        if currentMonth == 1 {
            currentMonth = 12
            currentYear -= 1
        } else {
            currentMonth -= 1
        }
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        loadData()
    }
}

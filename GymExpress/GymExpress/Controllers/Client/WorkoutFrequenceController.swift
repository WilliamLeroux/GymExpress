//
//  WorkoutFrequenceController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import SwiftUI

class WorkoutFrequenceController: ObservableObject {
    static let shared = WorkoutFrequenceController() /// Singleton
    private let dbManager = DatabaseManager.shared /// Database
    private let calendar = Calendar.current /// Calendrier
    private var frequences: [FrequenceModel] = [] /// Tableau de toute les fréquences
    private var currentMonth: Int /// Mois actuel
    private var currentYear: Int /// Année actuel
    private let notificationCenter = NotificationCenter.default /// Notification
    @Published var currentDate: Date = Date() /// Date actuelle
    @Published var month: [Day] = [] /// Tableau représentant un mois
    @Published var highestCount: Int = 4 /// Plus haut count
    
    private init() {
        currentMonth = calendar.component(.month, from: Date(timeIntervalSinceNow: 0))
        currentYear = calendar.component(.year, from: Date(timeIntervalSinceNow: 0))
        loadInitialData()
        month = [Day(name: "Dimanche", count: 0), Day(name: "Lundi", count: 0), Day(name: "Mardi", count: 0), Day(name: "Mercredi", count: 0), Day(name: "Jeudi", count: 0), Day(name: "Vendredi", count: 0), Day(name: "Samedi", count: 0)]
        loadData()
    }
    
    /// Charge les données initiales
    private func loadInitialData() {
        frequences = dbManager.fetchDatas(request: Request.select(table: DbTable.frequence, columns: ["id", "user_id", "date"], condition: "WHERE user_id = ?"), params: [LoginController.shared.currentUser?.id ?? -1]) ?? []
        notificationCenter.post(name: NSNotification.Name("newFrequence"), object: frequences)
    }
    
    /// Charge les données selon un mois
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
        setHighestCount()
    }
    
    /// Met à jour le plus haut count
    private func setHighestCount() {
        highestCount = 4
        month.forEach { (day) in
            if day.count > highestCount {
                highestCount = day.count
            }
        }
    }
    
    /// Ajoute une présence
    /// - Parameter date: Date de la présence
    func addPresence(date: Date) {
        let freq = FrequenceModel(userId: LoginController.shared.currentUser?.id ?? -1, date: date, presence: true)
        let success = dbManager.insertData(request: Request.createFrequence, params: freq)
        if success {
            frequences.append(freq)
            loadData()
            setHighestCount()
            notificationCenter.post(name: NSNotification.Name("newFrequence"), object: frequences)
        }
    }
    
    /// Mois suivant
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
    
    /// Mois précédent
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
    
    /// Retourne la présence pour une semaine
    /// - Parameter weekNumber: Numéro de la semaine dans une année
    /// - Returns: Tableau de bool représentant la présence
    func getWeek(weekNumber: Int) -> [Bool]{
        var tempFreq : [Bool] = []
        for _ in 0..<7 {
            tempFreq.append(false)
        }
        frequences.forEach { (freq) in
            if freq.date != nil {
                if calendar.component(.weekOfYear, from: freq.date!) == weekNumber {
                    tempFreq[calendar.component(.weekday, from: freq.date!) - 1] = true
                }
            }
        }
        return tempFreq
    }
}

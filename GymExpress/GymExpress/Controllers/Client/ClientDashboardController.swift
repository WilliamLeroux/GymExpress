//
//  ClientDashboardController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-28.
//

import SwiftUI

class ClientDashboardController: ObservableObject, FrequenceDelegate {
    static let shared = ClientDashboardController()
    private let frequenceController = WorkoutFrequenceController.shared
    var calendar : Calendar
    private let currentDate = Date()
    @Published var frequence: [Bool] = []
    
    private init() {
        calendar = Calendar.current
        calendar.locale = .autoupdatingCurrent
        calendar.locale = Locale(identifier: "fr_CA")
        loadInitialFrequence()
    }
    
    private func loadInitialFrequence() {
        frequence = frequenceController.getWeek(weekNumber: calendar.component(.weekOfYear, from: currentDate))
    }
    
    func reload() {
        loadInitialFrequence()
    }
}

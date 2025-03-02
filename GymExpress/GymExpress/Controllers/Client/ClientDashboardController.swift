//
//  ClientDashboardController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-28.
//

import SwiftUI

class ClientDashboardController: ObservableObject {
    static let shared = ClientDashboardController()
    private let frequenceController = WorkoutFrequenceController.shared
    var calendar : Calendar
    private let currentDate = Date()
    private let notificationCenter = NotificationCenter.default
    @Published var frequence: [Bool] = []
    
    private init() {
        calendar = Calendar.current
        calendar.locale = .autoupdatingCurrent
        calendar.locale = Locale(identifier: "fr_CA")
        loadInitialFrequence()
        notificationCenter.addObserver(forName: Notification.Name("newFrequence"), object: nil, queue: nil, using: reload(_:))
    }
    
    private func loadInitialFrequence() {
        frequence = frequenceController.getWeek(weekNumber: calendar.component(.weekOfYear, from: currentDate))
    }
    
    @objc func reload(_ notification: Notification) {
        let frequences = notification.object as! [FrequenceModel]
        frequence.removeAll(keepingCapacity: false)
        for _ in 0..<7 {
            frequence.append(false)
        }
        frequences.forEach { (freq) in
            if freq.date != nil {
                if calendar.component(.weekOfYear, from: freq.date!) == calendar.component(.weekOfYear, from: currentDate) {
                    frequence[calendar.component(.weekday, from: freq.date!) - 1] = true
                }
            }
        }
    }
}

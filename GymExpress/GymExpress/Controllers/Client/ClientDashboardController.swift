//
//  ClientDashboardController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-28.
//

import SwiftUI

class ClientDashboardController: ObservableObject {
    static let shared = ClientDashboardController() /// Singleton
    private let frequenceController = WorkoutFrequenceController.shared /// Frequence controller
    var calendar : Calendar /// Calendrier
    private let currentDate = Date() /// Date actuelle
    private let notificationCenter = NotificationCenter.default /// Notification
    @Published var frequence: [Bool] = [] /// Tableau de fréquence
    @Published var currentMembership: MembershipData? = nil
    
    private init() {
        calendar = Calendar.current
        calendar.locale = .autoupdatingCurrent
        calendar.locale = Locale(identifier: "fr_CA")
        loadInitialFrequence()
        notificationCenter.addObserver(forName: Notification.Name("newFrequence"), object: nil, queue: nil, using: reload(_:))
        notificationCenter.addObserver(forName: Notification.Name("UserMembershipUpdated"), object: nil, queue: nil, using: reloadMembership(_:))
    }
    
    /// Charge les données intiales
    private func loadInitialFrequence() {
        frequence = frequenceController.getWeek(weekNumber: calendar.component(.weekOfYear, from: currentDate))
        currentMembership = LoginController.shared.currentUser?.membership
    }
    
    /// Recharge les données après qu'une notification soit reçu
    /// - Parameter notification: Notification reçu
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
    
    @objc func reloadMembership(_ notification: Notification) {
        let membershipData = notification.object as! MembershipData
        currentMembership = membershipData
    }
}

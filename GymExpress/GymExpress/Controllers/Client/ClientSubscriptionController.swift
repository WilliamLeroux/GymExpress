//
//  ClientSubscriptionController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-03-10.
//

import SwiftUI

class ClientSubscriptionController: ObservableObject {
    static let shared = ClientSubscriptionController()
    
    private let db = DatabaseManager.shared
    private let notifier = NotificationCenter.default
    
    @Published var memberships: [MembershipData] = []
    @Published var currentMembership: Int?
    @Published var selectedMembership: Int?
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        memberships.append(MembershipData(grade: MembershipGrade.bronze, description: "Accès zone standard", price: Utils.shared.getMembershipPrice(membership: .bronze)))
        memberships.append(MembershipData(grade: MembershipGrade.silver, description: "Accès zone standard,accès sauna", price: Utils.shared.getMembershipPrice(membership: .silver)))
        memberships.append(MembershipData(grade: MembershipGrade.gold, description: "Accès zone standard,accès sauna,zone VIP,accès 24/7", price: Utils.shared.getMembershipPrice(membership: .gold)))
        memberships.append(MembershipData(grade: MembershipGrade.platinum, description: "Accès zone standard,accès sauna,zone VIP,accès 24/7,invitations VIP", price: Utils.shared.getMembershipPrice(membership: .platinum)))
        if LoginController.shared.currentUser?.membership != nil {
            currentMembership = memberships.firstIndex(where: (({ $0.grade == LoginController.shared.currentUser!.membership!.grade })))
        }
    }
    
    func setSelectedMembership(_ index: Int) {
        selectedMembership = index
    }
    
    func updateUserMembership(_ index: Int) {
        if currentMembership != index {
            let success = db.updateData(request: Request.update(table: DbTable.users, columns: ["membership"], condition: "WHERE id = ?"), params: [Utils.shared.getMembershipGradeId(membership: memberships[index].grade), LoginController.shared.currentUser!.id])
            if success {
                currentMembership = index
                notifier.post(name: NSNotification.Name("UserMembershipUpdated"), object: memberships[index])
            }
        }
    }
}

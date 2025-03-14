//
//  SubscriptionController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-03-13.
//

import SwiftUI

class SubscriptionController {
    @Published var memberships: [MembershipData] = []
    
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
}

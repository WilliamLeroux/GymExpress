//
//  MembershipDataModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SwiftUI

/// Structure d'un abonnement
struct MembershipData: Identifiable, Equatable, Codable{
    var grade: MembershipGrade /// Grade
    var count: Int? = nil/// Nombre d'abonné
    var description: String? = nil /// Description de l'abonnement
    var id: MembershipGrade { grade } /// Identifiant
    var price: Double? = nil
    
    init(grade: MembershipGrade, count: Int? = nil, description: String? = nil, price: Double? = nil) {
        self.grade = grade
        self.count = count
        self.description = description
        self.price = price
    }
}

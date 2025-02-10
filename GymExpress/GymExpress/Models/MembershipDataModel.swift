//
//  MembershipDataModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SwiftUI

/// Structure d'un abonnement
struct MembershipData: Identifiable, Equatable {
    var grade: MembershipGrade /// Grade
    var count: Int? = nil/// Nombre d'abonné
    let descritpion: String? = nil /// Description de l'abonnement
    var id: MembershipGrade { grade } /// Identifiant
    
    init(grade: MembershipGrade, count: Int? = nil) {
        self.grade = grade
        self.count = count
    }
}

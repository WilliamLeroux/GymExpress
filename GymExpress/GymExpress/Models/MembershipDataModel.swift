//
//  MembershipDataModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SwiftUI

/// Structure d'un abonnement
struct MembershipData: Identifiable, Equatable {
    let grade: MembershipGrade /// Grade
    let count: Int? /// Nombre d'abonné
    let descritpion: String? = nil /// Description de l'abonnement
    var id: MembershipGrade { grade } /// Identifiant
}

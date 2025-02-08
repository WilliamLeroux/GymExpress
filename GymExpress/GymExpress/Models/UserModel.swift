//
//  UserModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation

/// Strucutre d'un utilisateur
struct UserModel: Identifiable {
    let id: Int /// Identifiant
    var name: String /// Prénom
    var lastName: String /// Nom
    var email: String /// Adresse courriel
    var password: String /// Mot de passe
    let type: UserType /// Type d'utilisateur
    var membership: MembershipData? /// Abonnement
    var salary: Double? /// Salaire
}

//
//  UserModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation

/// Strucutre d'un utilisateur
struct UserModel: SQLConvertable {
    let id: Int = -1 /// Identifiant
    var name: String /// Prénom
    var lastName: String /// Nom
    var email: String /// Adresse courriel
    var password: String /// Mot de passe
    let type: UserType /// Type d'utilisateur
    var membership: MembershipData? /// Abonnement
    var salary: Double? /// Salaire
    
    init(name: String, lastName: String, email: String, password: String, type: UserType, membership: MembershipData? = nil, salary: Double? = nil) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.type = type
        self.membership = membership
        self.salary = salary
    }
    
    var params: [Any] {
        return [name, lastName, email, password, type, membership as Any, salary as Any]
    }
}

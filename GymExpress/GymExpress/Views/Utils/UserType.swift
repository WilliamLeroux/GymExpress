//
//  UserType.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

enum UserType: Int {
    case client = 0
    case trainer = 1
    case admin = 2
}

enum MembershipGrade: String, CaseIterable{
    case platinum = "Platine"
    case gold = "Or"
    case silver = "Argent"
    case bronze = "Bronze"
}

enum EmployesType: String, CaseIterable {
    case receptionist = "Réceptionniste"
    case trainer = "Entraîneur"
    case janitor = "Concierge"
    case machineRepairer = "Réparateur de machine"
    case cuisinier = "Cuisinier"
}

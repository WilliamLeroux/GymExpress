//
//  UserType.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

enum UserType: Int, Codable {
    case client = 0
    case trainer = 1
    case admin = 2
    case receptionist = 3
    case janitor = 4
    case machineRepairer = 5
    case cook = 6
}

enum MembershipGrade: String, CaseIterable, Identifiable, Codable{
    case platinum = "Platine"
    case gold = "Or"
    case silver = "Argent"
    case bronze = "Bronze"
    var id: String { self.rawValue }
}

enum EmployesType: String, CaseIterable {
    case receptionist = "Réceptionniste"
    case trainer = "Entraîneur"
    case janitor = "Concierge"
    case machineRepairer = "Réparateur de machine"
    case cook = "Cuisinier"
}

func getUserTypeFromEmployesType(_ type: EmployesType) -> UserType {
    switch type {
    case .receptionist:
        return .receptionist
    case .trainer:
        return .trainer
    case .janitor:
        return .janitor
    case .machineRepairer:
        return .machineRepairer
    case .cook:
        return .cook
    }
}

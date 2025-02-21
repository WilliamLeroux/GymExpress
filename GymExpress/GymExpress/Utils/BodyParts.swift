//
//  BodyParts.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-21.
//

enum BodyParts: String, CaseIterable, Identifiable {
    case upperBody = "Upper-body"
    case lowerBody = "Lower-body"
    case core = "Core"
    case cardio = "Cardio"
    var id: String { self.rawValue }
}

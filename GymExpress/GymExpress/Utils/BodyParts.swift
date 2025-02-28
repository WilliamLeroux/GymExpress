//
//  BodyParts.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-21.
//

enum BodyParts: String, CaseIterable, Identifiable {
    case upperBody = "upper-body"
    case lowerBody = "lower-body"
    case core = "core"
    case cardio = "cardio"
    var id: String { self.rawValue }
}

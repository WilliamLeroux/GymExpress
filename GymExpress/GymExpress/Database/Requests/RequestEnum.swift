//
//  RequestEnum.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-09.
//

enum DbTable: String, CaseIterable {
    case users = "users"
    case frequence = "frequence"
    case objectives = "objectives"
    case objectives_data = "objectives_data"
    case workouts = "workouts"
    case exercices = "exercices"
    case appointments = "appointments"
    case events = "events"
}

//
//  WeekModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation

// Structure d'une semaine
struct Week: Identifiable, Equatable {
    let day: String /// Jour
    let count: Int /// Nombre de présence
    
    var id: String { return day } /// Identifiant
}

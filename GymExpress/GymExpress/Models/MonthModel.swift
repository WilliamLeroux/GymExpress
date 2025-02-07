//
//  MonthModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation

// Structure d'un mois
struct Month {
    var name: String /// Nom du mois (ex: "Janvier", "Février")
    var year: Int /// Année du mois (ex: 2024)
    var dayList: [Day] /// Liste des jours qui composent ce mois
}

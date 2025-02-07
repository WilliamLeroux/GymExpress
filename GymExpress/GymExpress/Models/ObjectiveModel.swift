//
//  ObjectiveModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import Foundation

/// Structure des objectifs
struct Objective: Identifiable, Equatable, Hashable {
    let objective: String /// Nom de l'objectif
    let initValue: Int /// Valeur initial
    let valueList: [ObjectiveData] /// Liste des données
    let maxValue: Int /// Valeur maximum
    let startDate: Date /// Date de début
    let endDate: Date /// Date de fin

    init(objective: String, initValue: Int, valueList: [ObjectiveData], maxValue: Int, yearStart: Int, monthStart: Int, dayStart: Int, yearEnd: Int, monthEnd: Int, dayEnd: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.startDate = calendar.date(from: DateComponents(year: yearStart, month: monthStart, day: dayStart))!
        self.endDate = calendar.date(from: DateComponents(year: yearEnd, month: monthEnd, day: dayEnd))!
        self.objective = objective
        self.initValue = initValue
        self.valueList = valueList
        self.maxValue = maxValue
    }
    
    var id: String { return objective }
}

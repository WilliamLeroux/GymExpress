//
//  ObjectiveDataModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import Foundation

/// Structure des données pour un objectif
struct ObjectiveData: Identifiable, Equatable, Hashable {
    var id: Int = 0 /// Identifiant
    var value: Int /// Valeur
    var date: Date /// Date d'ajour
    
    init(value: Int, year: Int, month: Int, day: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        self.value = value
    }
}

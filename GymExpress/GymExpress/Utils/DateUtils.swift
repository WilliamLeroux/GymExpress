//
//  DateUtils.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-30.
//

import Foundation

/// Classe utils pour la gestion des dates
class DateUtils {
    static let shared = DateUtils() /// Singleton
    let calendar = Calendar.current /// Calendrier actuel
    let currentYear = Calendar.current.component(.year, from: Date()) /// Année actuelle
    
    private init() {}
    
    /// Retourne la range de date pour les calendriers (en ce moment +5 ans)
    /// - Returns: Range fermé de date
    func getDateRange() -> ClosedRange<Date> {
        let startComponents = DateComponents(year: 2025, month: 1, day: 1)
        let endComponents = DateComponents(year: currentYear + 5, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from: startComponents)! ... calendar.date(from: endComponents)!
    }
    
     
    /// Retourne une range d'heure entre 6h am et 10h pm
    /// - Returns: Range fermé de date
    func getTimeRange() -> ClosedRange<Date> {
        let startComponents = DateComponents(hour: 6, minute: 0)
        let endComponents = DateComponents(hour: 22, minute: 0)
        return calendar.date(from: startComponents)! ... calendar.date(from: endComponents)!
    }
}

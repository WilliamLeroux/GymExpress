//
//  CalendarEventModel.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-02-07.
//

import Foundation

// Structure d'un événement dans le calendrier d'un entraîneur.
struct CalendarEvent {
    private var id: Int /// Identifiant unique (privé)
    var startDate: Date /// Date de début de l'événement
    var endDate: Date /// Date de fin de l'événement
    var title: String /// Titre de l'événement
    var recurrenceType: String /// Type de récurrence (ex: "quotidien", "hebdomadaire")
    
    // Initialisateur
    init(id: Int, startDate: Date, endDate: Date, title: String, recurrenceType: String) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.recurrenceType = recurrenceType
    }
    
    // Obtenir l'ID d'un CalendarEvent
    func getId() -> Int {
        return id
    }
}

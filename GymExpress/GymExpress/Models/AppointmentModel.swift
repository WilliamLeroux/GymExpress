//
//  AppointmentModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation

/// Structure pour un rendez-vous
struct AppointmentModel: Identifiable {
    let id: Int /// Identifiant
    let trainerId: Int /// Identifiant de l'entraineur
    let clientId: Int /// Identifiant du client
    var name: String /// Nom du rendez-vous
    var descritption: String ///  Description
    var date: Date /// Date du rendez-vous
}

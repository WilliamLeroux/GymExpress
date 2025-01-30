//
//  NavigationItem.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

enum NavigationItemAdmin: String, CaseIterable {
    case dashboard = "Accueil"
    case finances = "Finances"
    case employes = "Employés"
}

enum NavigationItemTrainer: String, CaseIterable {
    case dashboard = "Accueil"
    case planTrainingPlan = "Créer un entraînement"
}

enum NavigationItemClient: String, CaseIterable {
    case dashboard = "Accueil"
    case appointment = "Rendez-vous"
    case progress = "Progrès"
    case subscription = "Abonnement"
    case training = "Plan d'entraînement"
    case frequence = "Fréquence"
}

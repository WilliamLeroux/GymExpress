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
    case clients = "Clients"
    case employes = "Employés"
}

enum NavigationItemClient: String, CaseIterable {
    case dashboard = "Accueil"
    case finances = "Finances"
    case employes = "Employés"
}

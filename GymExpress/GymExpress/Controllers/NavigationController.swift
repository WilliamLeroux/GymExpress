//
//  NavigationController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-04.
//

import SwiftUI

/// Controlleur de la navigation
class NavigationController: ObservableObject {
    static let shared = NavigationController() /// Singleton
    @Published var selectedIndex: String? = "Accueil" /// Index sélectionné
    
    private init(){}
}

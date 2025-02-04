//
//  NavigationController.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-04.
//

import SwiftUI

class NavigationController: ObservableObject {
    static let shared = NavigationController()
    @Published var selectedIndex: String? = "Accueil"
    
    private init(){}
}

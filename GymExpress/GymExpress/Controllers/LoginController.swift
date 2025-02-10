//
//  LoginController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-10.
//

import SwiftUI

/// Classe pour gérer la connexion d'un utilisateur.
class LoginController: ObservableObject {
    @Published var email: String = "" /// Email de l'utilisateur
    @Published var password: String = "" /// Mot de passe de l'utilisateur
    @Published var showErrorMessage: Bool = false /// Message d'erreur à afficher
    
    
}

//
//  LoginController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-10.
//

import SwiftUI

/// Classe pour gérer la connexion d'un utilisateur.
class LoginController: ObservableObject {
    
    var dbManager: DatabaseManager = DatabaseManager.shared
    
    @Published var email: String = "" /// Email de l'utilisateur
    @Published var password: String = "" /// Mot de passe de l'utilisateur
    @Published var showErrorMessage: Bool = false /// Message d'erreur à afficher

    
    func isValidInformation() -> Bool {
        let user: UserModel? = dbManager.fetchData(request: Request.select(table: .users, columns: ["email, password"], condition: "WHERE email = '\(email)'"), params: [])
        
        if user?.email == email && user?.password == password {
            return true
        }
        return false
        
    }
}

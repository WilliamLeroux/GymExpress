//
//  LoginController.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-10.
//

import SwiftUI

/// Classe pour gérer la connexion d'un utilisateur.
class LoginController: ObservableObject {
    static let shared = LoginController() 
    var dbManager: DatabaseManager = DatabaseManager.shared
    
    @Published var email: String = "" /// Email de l'utilisateur entré
    @Published var password: String = "" /// Mot de passe de l'utilisateur entré
    @Published var showErrorMessage: Bool = false /// Message d'erreur à afficher
    @Published var currentUser: UserModel? = nil /// Utilisateur actuel

    private init() {}
    
    func authenticateUser() -> UserModel? {
        let user: UserModel? = dbManager.fetchData(request: Request.select(table: .users, columns: ["*"], condition: "WHERE email = '\(email)'"), params: [])
        
        if user?.email == email && user?.password == password {
            self.currentUser = user
            return user
        }
        return nil
    }
}

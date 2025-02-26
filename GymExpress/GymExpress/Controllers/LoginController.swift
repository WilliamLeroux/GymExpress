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
    @Published var isRememberMe: Bool = false /// Pour se souvenir de moi
    
    private init() {
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            return
        };do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserModel.self, from: data)
            self.currentUser = user
            self.isRememberMe = true
            print("Utilisateur connecté : \(currentUser!)")
        } catch {
            // Fallback
        }
    }
    
    /// Vérifier dans la base de donnée si un utilisateur existe.
    func authenticateUser() -> Bool {
        let user: UserModel? = dbManager.fetchData(request: Request.select(table: .users, columns: ["*"], condition: "WHERE email = '\(email)'"), params: [])
        
        if user?.email == email && user?.password == password {
            self.currentUser = user
            return true
        }
        return false
    }
    
    /// Sauvegarder les informations de connexion d'un utilisateur.
    func saveLoginInfos() {
        do {
            let encoder = JSONEncoder()
            let user = try encoder.encode(currentUser)
            UserDefaults.standard.set(user, forKey: "user")
            print("Succès")
        } catch {

        }
    }
    func deleteLoginInfos() {
        UserDefaults.standard.removeObject(forKey: "user")
        print("Delete success")
    }
}

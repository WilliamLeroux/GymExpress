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
    let rememberMe = UserDefaults.standard
    
    private let notificationCenter = NotificationCenter.default
    
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
        } catch {
        }
        notificationCenter.addObserver(forName: Notification.Name("UserMembershipUpdated"), object: nil, queue: nil, using: refreshUser(_:))
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
    
    @objc func refreshUser(_ notification: Notification) {
        if currentUser != nil {
            if currentUser!.membership != nil {
                let tempMembership = notification.object as? MembershipData
                if tempMembership != nil {
                    currentUser!.membership!.grade = tempMembership!.grade
                    saveLoginInfos()
                }
            }
        }
    }
    
    /// Sauvegarder les informations de connexion d'un utilisateur.
    func saveLoginInfos() {
        do {
            let encoder = JSONEncoder()
            let user = try encoder.encode(currentUser)
            UserDefaults.standard.set(user, forKey: "user")
        } catch {
            
        }
    }
    
    /// Supprimer les informations dans UserDefault
    func deleteLoginInfos() {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    /// Déconnecter l'utilisateur actuel
    func logout() {
        self.deleteLoginInfos()
        self.currentUser = nil
        self.email = ""
        self.password = ""
    }
}

//
//  Request.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-09.
//

struct Request {
    
    // MARK: SELECT
    /// Retourne tout les utilisateurs
    static let selectAllUsers: String = "SELECT id, name, last_name, email, user_type, membership, salary FROM users WHERE is_deleted IS FALSE;"
    
    /// Retourne tout les employées
    static let selectAllEmploye: String = "SELECT id, name, last_name, email, user_type, salary FROM users WHERE salary IS NOT NULL and is_deleted IS FALSE;"
    
    /// Retourne tout les clients
    static let selectAllCLient: String = "SELECT id, name, last_name, email, user_type, membership, salary FROM users WHERE user_type = 0 AND is_deleted IS FALSE;"
    
    // MARK: INSERT
    
    /// Crée un utilisateur 
    static let createUser: String = "INSERT INTO users (name, last_name, email, password, user_type, membership, salary) VALUES (?, ?, ?, ?, ?, ?, ?);"
    
    /// Crée une présence
    static let createFrequence: String = "INSERT INTO frequence (user_id, date, present) VALUES (?, ?, ?);"
    
    /// Crée un objectif
    static let createObjective: String = "INSERT INTO objectives (user_id, init_value, max_value, start_value, end_value) VALUES (?, ?, ?, ?, ?);"
    
    /// Crée une donnée pour un objectif
    static let createObjectiveData: String = "INSERT INTO objectives_data (objective_id, data, date) VALUES (?, ?, ?);"
    
    /// Crée un entraînement
    static let createWorkout: String = "INSERT INTO workouts (user_id, name, day) VALUES (?, ?, ?);"
    
    /// Crée un exercice
    static let createExercice: String = "INSERT INTO exercices (workout_id, name, image, description, body_part, exercice_type, sets, reps, load) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);"
    
    /// Crée un rendez-vous
    static let createAppointment: String = "INSERT INTO appointments (user_id, trainer_id, name, description, date) VALUES (?, ?, ?, ?, ?);"
    
    /// Crée un évènement
    static let createEvent: String = "INSERT INTO events (user_id, start_date, end_date, title, recurrence) VALUES(?, ?, ?, ?, ?);"
    
    /// Retourne une requête SQL Update
    /// - Parameters:
    ///   - table: Table cible
    ///   - columns: Colonnes à mettre à jour
    ///   - condition: Condition WHERE SQL, vide par défaut
    /// - Returns: La requête SQL
    static func update(table: DbTable, columns: [String], condition: String = "") -> String {
        var req = "UPDATE \(table.rawValue) SET "
        for i in 0..<columns.count {
            if i != columns.count - 1 {
                req += "\(columns[i]) = ?,"
            } else {
                req += "\(columns[i]) = ?"
            }
        }
        req += condition + ";"
        return req
    }
    
    /// Crée une requête SQL Select
    /// - Parameters:
    ///   - table: Table cible
    ///   - columns: Colonnes à prendre
    ///   - condition: Condition WHERE SQL, vide par défaut
    /// - Returns: String comprennant la requête SQL
    static func select(table: DbTable, columns: [String], condition: String = "") -> String {
        var req = "SELECT "
        for column in columns {
            if column != columns.last! {
                req += "\(column), "
            } else {
                req += "\(column)"
            }
        }
        return req + " FROM \(table.rawValue) \(condition);"
    }
    
    /// Crée une requête SQL Select pour avoir le id du dernier enregistrement créer
    /// - Parameter table: Table cible
    /// - Returns: String comprennant la chaîne
    static func getNewId(table: DbTable) -> String {
        return "SELECT id FROM \(table.rawValue) ORDER BY id DESC LIMIT 1;"
    }
}

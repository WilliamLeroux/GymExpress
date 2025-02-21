//
//  SetupRequests.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

/// Requête SQL pour la création de la base de données
struct SetupRequests {
    /// Table user
    private static let USERS = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, last_name TEXT NOT NULL, email TEXT NOT NULL UNIQUE, password TEXT NOT NULL, user_type INTEGER NOT NULL DEFAULT 0, membership INTEGER DEFAULT NULL, salary DOUBLE DEFAULT NULL, is_deleted BOOLEAN NOT NULL DEFAULT FALSE);"
    
    /// Table frequence
    private static let FREQUENCE = "CREATE TABLE IF NOT EXISTS frequence (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, date DATE NOT NULL, present BOOLEAN NOT NULL DEFAULT FALSE, FOREIGN KEY (user_id) REFERENCES users(id));"
    
    /// Table objectives
    private static let OBJECTIVES = "CREATE TABLE IF NOT EXISTS objectives (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, init_value INTEGER NOT NULL, max_value INTEGER NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL, is_deleted BOOLEAN NOT NULL DEFAULT FALSE, FOREIGN KEY (user_id) REFERENCES users(id));"
    
    /// Table objective data
    private static let OBJECTIVES_DATA = "CREATE TABLE IF NOT EXISTS objectives_data (id INTEGER PRIMARY KEY AUTOINCREMENT, objective_id INTEGER NOT NULL, data INTEGER NOT NULL, date DATE NOT NULL, FOREIGN KEY (objective_id) REFERENCES objectives(id));"
    
    /// Table workout
    private static let WORKOUTS = "CREATE TABLE IF NOT EXISTS workouts (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, name TEXT NOT NULL, day INTEGER NOT NULL, is_deleted BOOLEAN NOT NULL DEFAULT FALSE, FOREIGN KEY (user_id) REFERENCES users(id));"
    
    /// Table exercice
    private static let EXERCICES = "CREATE TABLE IF NOT EXISTS exercices (id INTEGER PRIMARY KEY AUTOINCREMENT, workout_id INTEGER NOT NULL, exercice_id TEXT NOT NULL, name TEXT NOT NULL, image TEXT NOT NULL, description TEXT NOT NULL, body_part INTEGER NOT NULL, exercice_type INTEGER NOT NULL, sets INTEGER NOT NULL, reps INTEGER NOT NULL, load INTEGER NOT NULL, FOREIGN KEY (workout_id) REFERENCES workouts(id));"
    
    /// Table appointment
    private static let APPOINTMENTS = "CREATE TABLE IF NOT EXISTS appointments (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, trainer_id INTEGER NOT NULL, name TEXT NOT NULL, description TEXT NOT NULL, date DATE NOT NULL, is_deleted BOOLEAN NOT NULL DEFAULT FALSE, FOREIGN KEY (user_id) REFERENCES users(id), FOREIGN KEY (trainer_id) REFERENCES users(id));"
    
    /// Table events
    private static let EVENTS = "CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL, title TEXT NOT NULL, recurrence INTEGER NOT NULL, recurrence_end_date DATE DEFAULT NULL, is_deleted BOOLEAN NOT NULL DEFAULT FALSE, FOREIGN KEY (user_id) REFERENCES users(id));"
    
    static let setupRequest : [String] = [USERS, FREQUENCE, OBJECTIVES, OBJECTIVES_DATA, WORKOUTS, EXERCICES, APPOINTMENTS, EVENTS] /// Tableau comprennant toute les requêtes
}

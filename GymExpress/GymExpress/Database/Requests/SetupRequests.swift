//
//  SetupRequests.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

struct SetupRequests {
    static let USERS = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, last_name TEXT NOT NULL, email TEXT NOT NULL UNIQUE, password TEXT NOT NULL, user_type INTEGER NOT NULL DEFAULT 0, membership INTEGER NOT NULL DEFAULT NULL, salary DOUBLE NOT NULL DEFAULT NULL);"
    
}

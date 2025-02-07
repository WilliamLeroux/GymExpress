//
//  DatabaseManager.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        
    }
    
    private func databaseSetup() {
        let dbURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("gymexpress.sqlite")
        
        if sqlite3_open(dbURL.path(), &db) == SQLITE_OK {
            
        }
    }
}

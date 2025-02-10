//
//  DatabaseManager.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SQLite3
import Foundation

class DatabaseManager : ObservableObject{
    static let shared = DatabaseManager() /// Singleton
    var tableMaps: [[String]] = [] /// Map
    
    private var db: OpaquePointer? /// Pointeur de la base de données
    
    private init() {
        databaseSetup()
        mapDatabase()
    }
    
    /// Initialisation de la base de donnée
    private func databaseSetup() {
        let request = SetupRequests.setupRequest
        let dbURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("gymexpress.sqlite")
        
        if sqlite3_open(dbURL.path(), &db) == SQLITE_OK {
            for req in request {
                guard sqlite3_exec(db, req.description, nil, nil, nil) == SQLITE_OK else {
                    print("Error setting up database: \(String(describing: String(cString: sqlite3_errmsg(db)!)))")
                    return
                }
            }
        }
    }
    
    /// Map la base de donnée
    private func mapDatabase() {
        var currentTable = ""
        var req = ""
        var pointer : OpaquePointer?
        var currentColumns : [String] = []
        
        for table in DbTable.allCases {
            
            currentTable = table.rawValue
            req = "PRAGMA table_info(\(currentTable));"
            
            guard sqlite3_prepare_v2(db, req.description, -1, &pointer, nil) == SQLITE_OK else {
                if let errorMessage = sqlite3_errmsg(pointer) {
                    print("Error while mapping \(currentTable): \(String(cString: errorMessage))")
                }
                return
            }
            while sqlite3_step(pointer) == SQLITE_ROW {
                if let columnName = sqlite3_column_text(pointer, 1) {
                    currentColumns.append(String(cString: columnName))
                }
            }
            tableMaps.append([currentTable] + currentColumns)
            currentColumns.removeAll()
            sqlite3_finalize(pointer)
        }
        print(tableMaps)
    }
    
    /// Exécute les requête SELECT
    /// - Parameters:
    ///   - request: Chaine comprennant la requête
    ///   - params: Paramètre pour la requête, vide si aucun paramètre est nécessaire
    /// - Returns: Retourne le résultat selon le type donnée
    func fetchData<T> (request: String, params: [Any]) -> T? {
        var pointer: OpaquePointer?
        var result: Any? = nil
        
        if sqlite3_prepare_v2(db, request, -1, &pointer, nil) == SQLITE_OK {
            for i in 0..<params.count {
                switch params[i] {
                case let param as Int:
                    sqlite3_bind_int(pointer, Int32(i), Int32(param))
                case let param as String:
                    let tempString = param as NSString
                    sqlite3_bind_text(pointer, Int32(i), tempString.utf8String, -1, nil)
                case let param as Double:
                    sqlite3_bind_double(pointer, Int32(i), Double(param))
                case let param as Bool:
                    sqlite3_bind_int(pointer, Int32(i), Int32(param ? 1 : 0))
                default:
                    break
                }
            }
        }
        if sqlite3_step(pointer) == SQLITE_ROW {
            if let objectType = T.self as? InitializableFromSQLITE.Type {
                result = objectType.init(from: pointer!)
            } else if T.self is Int.Type{
                result = sqlite3_column_int(pointer, 1)
            } else if T.self is String.Type {
                result = String(cString: sqlite3_column_text(pointer, 1)!)
            } else if T.self is Double.Type {
                result = sqlite3_column_double(pointer, 1)
            }
        }
        sqlite3_finalize(pointer)
        return result as? T
    }
    
    /// Exécute les requête INSERT et UPDATE
    /// - Parameters:
    ///   - request: Chaine comprennant la requête
    ///   - params: Paramètre pour la requête, vide si aucun paramètre est nécessaire
    /// - Returns: Retourne true si la requête a fonctionné, false si elle n'a pas fonctionné
    func insertData<T: SQLConvertable>(request: String, params: T) -> Bool {
        var pointer: OpaquePointer?
        
        if sqlite3_prepare_v2(db, request, -1, &pointer, nil) == SQLITE_OK {
            var i = 1
            for param in params.params {
                DatabaseUtils.shared.bindParam(pointer: pointer, param: param, i: i)
                i+=1
            }
            
            if sqlite3_step(pointer) != SQLITE_DONE {
                if let errorMessage = sqlite3_errmsg(db) {
                    print("Error inserting: \(String(cString: errorMessage))")
                }
                return false
            }
        }
        sqlite3_finalize(pointer)
        return true
    }
}

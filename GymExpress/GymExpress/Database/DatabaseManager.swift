//
//  DatabaseManager.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-07.
//

import SQLite3
import Foundation

class DatabaseManager : ObservableObject{
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        databaseSetup()
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
    /*
    func fetchData<T> (request: String, params: [Any]) -> T{
        var pointer: OpaquePointer?
        
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
        
    }*/
    
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

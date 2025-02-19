//
//  UserModel.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-07.
//

import Foundation
import SQLite3

/// Strucutre d'un utilisateur
struct UserModel: SQLConvertable, InitializableFromSQLITE, Identifiable {
    var id: Int = -1 /// Identifiant
    var name: String = "" /// Prénom
    var lastName: String = "" /// Nom
    var email: String = "" /// Adresse courriel
    var password: String = "" /// Mot de passe
    var type: UserType? = nil /// Type d'utilisateur
    var membership: MembershipData? = nil/// Abonnement
    var salary: Double? = nil/// Salaire
    
    init(name: String, lastName: String, email: String, password: String, type: UserType, membership: MembershipData? = nil, salary: Double? = nil) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.type = type
        self.membership = membership
        self.salary = salary
    }
    
    init(from pointer: OpaquePointer?) {
        guard let pointer = pointer else {
            self.name = ""
            self.lastName = ""
            self.email = ""
            self.password = ""
            self.type = .client
            self.membership = nil
            self.salary = nil
            return
        }
        
        let columnCount = sqlite3_column_count(pointer)
        var columnIndex: Int32 = 0
        for i in 0..<columnCount {
            columnIndex = Int32(DatabaseManager.shared.tableMaps[0].firstIndex(of: String(cString: sqlite3_column_name(pointer, i)!)) ?? 0)
            
            switch columnIndex {
            case 1:
                self.id = Int(sqlite3_column_int(pointer, i))
            case 2:
                self.name = String(cString: sqlite3_column_text(pointer, i)!)
            case 3:
                self.lastName = String(cString: sqlite3_column_text(pointer, i)!)
            case 4:
                self.email = String(cString: sqlite3_column_text(pointer, i)!)
            case 5:
                self.password = String(cString: sqlite3_column_text(pointer, i)!)
            case 6:
                self.type = UserType(rawValue: Int(sqlite3_column_int(pointer, i)))!
            case 7:
                self.membership = MembershipData(grade: Utils.shared.getMembershipById(id: Int(sqlite3_column_int(pointer, i))))
            case 8:
                self.salary = Double(sqlite3_column_double(pointer, i))
            default:
                #if DEBUG
                    print("Unknown column, \(columnIndex)")
                #endif
            }
        }
        
    }
    
    var params: [Any] {
        return [name, lastName, email, password, type as Any, membership as Any, salary as Any]
    }
}

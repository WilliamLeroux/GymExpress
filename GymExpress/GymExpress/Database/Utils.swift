//
//  Utils.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-09.
//

import SQLite3
import Foundation

class DatabaseUtils {
    static let shared = DatabaseUtils()
    private init() {}
    
    func bindParam(pointer: OpaquePointer?, param: Any, i: Int) {
        switch param {
        case let param as Int: // Int
            sqlite3_bind_int(pointer, Int32(i), Int32(param))
        case let param as String: // String
            let tempString = param as NSString
            sqlite3_bind_text(pointer, Int32(i), tempString.utf8String, -1, nil)
        case let param as Double: // Double
            sqlite3_bind_double(pointer, Int32(i), Double(param))
        case let param as Bool: // Bool
            sqlite3_bind_int(pointer, Int32(i), Int32(param ? 1 : 0))
        case let param as UserType: // UserType
            sqlite3_bind_int(pointer, Int32(i), Int32(param.rawValue))
        case let param as Optional<Double>: // Double?
            if let param = param {
                sqlite3_bind_double(pointer, Int32(i), Double(param))
            } else {
                sqlite3_bind_null(pointer, Int32(i))
            }
        case let param as Optional<Int>: // Int?
            if param != nil {
                sqlite3_bind_int(pointer, Int32(i), Int32(param!))
            } else {
                sqlite3_bind_null(pointer, Int32(i))
            }
        case let param as Optional<MembershipData>: // MembershipData?
            if param != nil {
                sqlite3_bind_int(pointer, Int32(i), Int32(Utils.shared.getMembershipGradeId(membership: param!.grade)))
            } else {
                sqlite3_bind_null(pointer, Int32(i))
            }
        default:
            break
        }
    }
}

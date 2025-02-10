//
//  InitializableFromSQLITE.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-09.
//

/// Protocol pour rendre un objet initialisable par SQLite
protocol InitializableFromSQLITE {
    init(from pointer: OpaquePointer?)
}

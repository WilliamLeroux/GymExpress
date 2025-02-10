//
//  SQLConvertable.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-09.
//

/// Protocol pour pouvoir passé un objet dans en SQL
protocol SQLConvertable {
    var params: [Any] { get }
}

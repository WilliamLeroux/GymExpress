//
//  Exercice.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-21.
//
struct ExerciceResponse: Decodable, Encodable {
    var data: Data
}
struct Data: Decodable, Encodable{
    var exercises: [Exercises]
}

struct Exercises: Decodable, Encodable {
    var exerciseId: String
    var name: String
    var gifUrl: String
    
}

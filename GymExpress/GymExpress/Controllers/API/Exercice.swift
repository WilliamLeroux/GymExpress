//
//  Exercice.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-21.
//

struct Data: Decodable, Encodable{
    var exercices: [Exercice]
}

struct Exercice: Decodable, Encodable {
    var exerciceId: String
    var name: String
    var gifUrl: String
    
}

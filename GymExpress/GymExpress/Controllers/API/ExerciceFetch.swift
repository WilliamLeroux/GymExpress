//
//  ExerciceFetch.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-21.
//

import Foundation

class ExerciceFetch {
    func getExercice(_ bodyPart: String) async -> [Exercises] {
        var exercices: [Exercises] = []
        do {
            exercices = try await fetchExercices(bodyPart)!.data.exercises
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return exercices
    }
    
    func fetchExercices(_ bodyPart: String) async throws -> ExerciceResponse? {
        let endpoint: String = "https://exercisedb-api.vercel.app/api/v1/bodyparts/\(bodyPart)/exercises"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(ExerciceResponse.self, from: data)
    }
}

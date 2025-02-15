//
//  Validation.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-15.
//

import Foundation

struct ValidationUtils {
    
    /// Vérifie si l'adresse courriel est valide.
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9]{6,}@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    /// Vérifie si la chaîne contient au moins un chiffre et un caractère spécial.
    static func hasAtLeastOneDigitAndSpecialCharacter(_ input: String) -> Bool {
        let digitRange = input.rangeOfCharacter(from: .decimalDigits)
        
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-+=<>?/\\|{}[]~`")
        let specialRange = input.rangeOfCharacter(from: specialCharacters)
        
        return (digitRange != nil) && (specialRange != nil)
    }
}

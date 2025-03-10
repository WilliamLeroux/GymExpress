//
//  PaletteSelectionEffect.swift
//  GymExpress
//
//  Created by Samuel Oliveira Martel on 2025-01-28.
//


import SwiftUI

struct PaletteSelectionEffect: ViewModifier {
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .background(isSelected ? Color.main : Color.white)
            .foregroundStyle(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func paletteSelectionEffect(_ isSelected: Bool) -> some View {
        self.modifier(PaletteSelectionEffect(isSelected: isSelected))
    }
}

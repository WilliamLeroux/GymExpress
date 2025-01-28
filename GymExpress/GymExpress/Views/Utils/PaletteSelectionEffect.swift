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
            .foregroundStyle(isSelected ? Color.white : Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: isSelected ? .green.opacity(0.5) : .clear, radius: 5, x: 0, y: 2)
    }
}

extension View {
    func paletteSelectionEffect(_ isSelected: Bool) -> some View {
        self.modifier(PaletteSelectionEffect(isSelected: isSelected))
    }
}

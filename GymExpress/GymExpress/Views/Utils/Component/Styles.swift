//
//  Styles.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-29.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var width: CGFloat /// Width du bouton
    var height: CGFloat /// Height du bouton
    var color: Color /// Couleur de fond du bouton
    var action: () -> Void /// Action lors d'un clique
    @State var isPressed: Bool = false /// Booléen siginfiant que le bouton est cliqué
    @State private var isHovered: Bool = false /// Booléen signifiant que le bouton est survolé
    
    init(width: CGFloat = 50, height: CGFloat = 50, color: Color = .main, action: @escaping () -> Void = {}) {
        self.action = action
        self.width = width
        self.height = height
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
        }
        .frame(width: width, height: height)
        .background(isHovered ? Color.green : color)
        .cornerRadius(15)
        .padding()
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            isPressed.toggle()
            action()
        }
    }
}

struct WorkoutBoxStyle: GroupBoxStyle {
    var color: Color = .gray.opacity(0.1)
    func makeBody(configuration: Configuration) -> some View {
        Spacer()
        VStack(alignment: .leading) {
            configuration.label
                .padding(.top, 5)
                .padding(.leading, 10)
                .font(.system(size: 15, weight: .bold))
            configuration.content
                .background(.clear)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
            Spacer()
        }
        .background(color)
        Spacer()
    }
}

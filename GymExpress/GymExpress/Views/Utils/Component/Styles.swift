//
//  Styles.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-29.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var action: () -> Void
    @State var isPressed: Bool = false
    @State private var isHovered: Bool = false
    
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

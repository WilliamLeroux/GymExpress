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
    var hoveringColor: Color /// Couleur de fond du bouton lorsqu'il est survolé
    var action: () -> Void /// Action lors d'un clique
    var padding: CGFloat /// Padding du bouton
    @State var isPressed: Bool = false /// Booléen siginfiant que le bouton est cliqué
    @State private var isHovered: Bool = false /// Booléen signifiant que le bouton est survolé
    
    init(width: CGFloat = 50, height: CGFloat = 50, color: Color = .main, hoveringColor: Color = .green , padding: CGFloat = 5, action: @escaping () -> Void = {}) {
        self.action = action
        self.width = width
        self.height = height
        self.color = color
        self.hoveringColor = hoveringColor
        self.padding = padding
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
        }
        .frame(width: width, height: height)
        .background(isHovered ? hoveringColor : color)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
            if (hovering){
                NSCursor.pointingHand.push()
            }
            else {
                NSCursor.pop()
            }
        }
        .cornerRadius(15)
        .padding(padding)
        
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

struct TextFieldStyle: View {
    var title: String
    var text: Binding<String>
    var width: CGFloat
    var colorBackground: Color
    var colorStroke: Color
    var isTyping: FocusState<Bool>.Binding
    
    init(title: String, text: Binding<String>, width: CGFloat = 350, colorBackground: Color = Color.white, colorStroke: Color = Color.main, isTyping: FocusState<Bool>.Binding) {
        self.title = title
        self.text = text
        self.width = width
        self.colorBackground = colorBackground
        self.colorStroke = colorStroke
        self.isTyping = isTyping
    }
    
    var body: some View {
        TextField("\(title)", text: text)
            .padding()
            .frame(maxWidth: width)
            .background(colorBackground)
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorStroke, lineWidth: isTyping.wrappedValue ? 4 : 1)
            )
            .focused(isTyping)
    }
    
}

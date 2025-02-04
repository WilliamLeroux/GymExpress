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
    var borderColor: Color /// Couleur de la bordure
    var borderWidth: CGFloat /// Largeur de la bordure
    @State var isPressed: Bool = false /// Booléen siginfiant que le bouton est cliqué
    @State private var isHovered: Bool = false /// Booléen signifiant que le bouton est survolé
    
    init(width: CGFloat = 50, height: CGFloat = 50, color: Color = .main, hoveringColor: Color = .green , padding: CGFloat = 5, borderColor: Color = .clear, borderWidth: CGFloat = 0, action: @escaping () -> Void = {}) {
        self.action = action
        self.width = width
        self.height = height
        self.color = color
        self.hoveringColor = hoveringColor
        self.padding = padding
        self.borderColor = borderColor
        self.borderWidth = borderWidth
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
        .overlay(RoundedRectangle(cornerSize: .init(width: 15, height: 15)).stroke(borderColor, lineWidth: borderWidth))
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
            .cornerRadius(12)
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorStroke, lineWidth: isTyping.wrappedValue ? 4 : 1)
            )
            .focused(isTyping)
    }
    
}

struct TextFieldNumberStyle: View {
    var title: String /// Le texte affiché en tant que placeholder du champ de texte.
    @Binding var text: String /// Texte lié au champ de saisie.
    var width: CGFloat /// Largeur maximale du champ de texte.
    var colorBackground: Color /// Couleur de fond du champ de texte.
    var colorStroke: Color /// Couleur de la bordure du champ de texte.
    var isTyping: FocusState<Bool>.Binding /// Indique si le champ est actuellement en édition.

    init(title: String, text: Binding<String>, width: CGFloat = 350, colorBackground: Color = Color.white, colorStroke: Color = Color.main, isTyping: FocusState<Bool>.Binding) {
        self.title = title
        self._text = text
        self.width = width
        self.colorBackground = colorBackground
        self.colorStroke = colorStroke
        self.isTyping = isTyping
    }
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .frame(maxWidth: width)
            .background(colorBackground)
            .cornerRadius(12)
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorStroke, lineWidth: isTyping.wrappedValue ? 4 : 1)
            )
            .focused(isTyping)
            .onChange(of: text) {
                text = text.filter { $0.isNumber }
            }
    }
}

struct ConfirmationSheet: View {
    var title: String /// Titre de la sheet
    var message: String /// Message
    var cancelAction: Action /// Action lors du retour en arrière
    var confirmAction: Action /// Action lors de la confirmation
    
    /// - Parameters:
    ///   - title: Titre de la sheet
    ///   - message: Message
    ///   - cancelAction: Action lors du retour en arrière
    ///   - confirmAction: Action lors de la confirmation
    init(title: String, message: String, cancelAction: @escaping Action, confirmAction: @escaping Action) {
        self.title = title
        self.message = message
        self.cancelAction = cancelAction
        self.confirmAction = confirmAction
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            
            Text(message)
            HStack {
                Button(action: {}){
                    Text("Retour")
                }
                .buttonStyle(RoundedButtonStyle(width: 75, height: 40, color: Color.main, hoveringColor: Color.green, action: {
                    cancelAction()
                }))
                
                Button(action: {}){
                    Text("Confirmer")
                }
                .buttonStyle(RoundedButtonStyle(
                    width: 75,
                    height: 40,
                    color: Color.red,
                    hoveringColor: Color.red.opacity(0.8),
                    action: {
                        confirmAction()
                    })
                )
            }
        }
        .padding(20)
    }
}

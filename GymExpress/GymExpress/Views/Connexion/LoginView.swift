//
//  LoginView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-28.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var isTypingEmail: Bool
    @FocusState private var isTypingPassword: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
            Spacer()
            HStack {
                Image(.logo512T)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding(45)
                VStack(spacing: 16) { // Espacement entre les champs
                    // Email TextField
                    TextField("Email", text: $email)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white) // Couleur de fond
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.main, lineWidth: isTypingEmail ? 4 : 2) // Bordure
                        )
                        .focused($isTypingEmail)
                    
                    // Password SecureField
                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.main, lineWidth: isTypingPassword ? 4 : 2)
                        )
                        .focused($isTypingPassword)
                }
            }
            .padding(45)
            .background(Color.white)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    LoginView()
}


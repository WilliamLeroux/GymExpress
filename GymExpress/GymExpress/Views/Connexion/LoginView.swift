//
//  LoginView.swift : Contient la vue de la page de connexion
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-28.
//

import SwiftUI
import AppKit

struct LoginView: View {
    @StateObject var viewModel: LoginController = LoginController.shared
    @State private var isRememberMe: Bool = false /// Se souvenir des informations de connexion
    @State private var isHover = false /// Vérifie si la souris survol le bouton de connexion
    @State private var isNavigating = false /// Active la navigation si les champs sont valides
    @State private var errorMessage = "" /// Message d'erreur à afficher
    
    @FocusState private var isTypingEmail: Bool /// Vérifie si l'utilisateur est dans le textfield email
    @FocusState private var isTypingPassword: Bool /// Vérifie si l'utilisateur est dans le textfield password
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.backgroundLogin)
                    .resizable()
                VStack(spacing: 0) {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(radius: 12)
                        VStack {
                            Text("La forme en mode express")
                                .fontWeight(.semibold)
                                .font(.system(size:42))
                                .padding(.top, 50)
                            HStack {
                                Image(.logo512T)
                                    .resizable()
                                    .frame(width: 225, height: 225)
                                    .padding(.horizontal, 50)
                                    .shadow(radius: 5)
                                Divider()
                                VStack(alignment: .center, spacing: 20) {
                                    TextFieldStyle(title: "Adresse courriel", text: $viewModel.email, isTyping: $isTypingEmail)
                                        
                                    SecureField("Mot de passe", text: $viewModel.password)
                                        .padding()
                                        .frame(maxWidth: 350)
                                        .background(Color.white)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.main, lineWidth: isTypingPassword ? 4 : 1)
                                        )
                                        .focused($isTypingPassword)
     
                                    Text(errorMessage)
                                        .foregroundStyle(Color.red)
                                    
                                    NavigationLink(
                                        destination: RootNavigation(),
                                        isActive: $isNavigating
                                    ) {
                                        Button(action: {
                                            if viewModel.authenticateUser() {
                                                errorMessage = ""
                                                isNavigating = true
                                                if self.isRememberMe {
                                                    viewModel.saveLoginInfos()
                                                }
                                            }else {
                                                errorMessage = "Informations invalides"
                                            }
                                        }) {
                                            Text("Se connecter")
                                                .padding(.horizontal, 30)
                                                .padding(.vertical, 15)
                                                .foregroundColor(.white)
                                                .background(isHover ? Color.green : Color.main)
                                                .cornerRadius(8)
                                                .frame(width: 250, height: 50)
                                        }
                                    }
                                    .buttonStyle(RoundedButtonStyle(width: 250))
                                    .navigationBarBackButtonHidden(true)
                                    .onHover { hovering in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isHover = hovering
                                        }
                                        if hovering {
                                            NSCursor.pointingHand.push()
                                        } else {
                                            NSCursor.pop()
                                        }
                                    }
                                    
                                    Toggle(isOn: $isRememberMe) {
                                        Text("Se souvenir de moi")
                                    }
                                    .toggleStyle(.checkbox)
                                    .onHover { hovering in
                                        if (hovering){
                                            NSCursor.pointingHand.push()
                                        }
                                        else {
                                            NSCursor.pop()
                                        }
                                    }
                                } // VStack forms
                                .padding()
                                
                            } // HStack
                            .padding(.bottom, 60)
                        } // VStack logo + forms
                    } // ZStack
                    .frame(width: 800, height: 400)
                    .cornerRadius(6)
                    
                    Spacer()
                    Footer(isLoginPage: true)
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}



//
//  LoginView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-28.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        Header()
        HStack {
            Image(.logo512T)
            VStack {
                Form {
                    TextField(text: "Nom d'utilisateur", prompt: Text("Required")) {
                        Text("Username")
                    }
                    SecureField(text: "Mot de passe", prompt: Text("Required")) {
                        Text("Password")
                    }
                }
            }
        }
        .background(Color.white)
    }
}

#Preview {
    LoginView()
}

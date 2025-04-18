//
//  Footer.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-29.
//

import SwiftUI

struct Footer: View {
    @Environment(\.dismiss) var dismiss
    @State var isLoginPage : Bool
    @ObservedObject var loginController = LoginController.shared
    
    init(isLoginPage: Bool) {
        self.isLoginPage = isLoginPage
    }
    
    var body: some View {
        if(!isLoginPage) {
            Button{
                loginController.email = ""
                loginController.password = ""
                dismiss()
            } label: {
                Text("Se déconnecter")
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(10)
            .foregroundStyle(Color.red)
            .onHover { hovering in
                if (hovering){
                    NSCursor.pointingHand.push()
                }
                else {
                    NSCursor.pop()
                }
            }
        }
        
        Text("© 2025 GymExpress - Tous droits réservés")
            .font(.footnote)
            .foregroundColor(isLoginPage ? Color.main : Color.gray)
            .padding(.bottom, 25)
    }
}

#Preview {
    Footer(isLoginPage: true)
}

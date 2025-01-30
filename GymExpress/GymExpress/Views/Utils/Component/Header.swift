//
//  Header.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct Header: View {
    let title: String = "GymExpress"
    
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.main)
                    .frame(maxWidth: .infinity, maxHeight: 75)
                    .shadow(color: Color.black.opacity(0.3), radius: 10)
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
    }
}

#Preview {
    Header()
}

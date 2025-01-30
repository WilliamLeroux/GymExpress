//
//  WorkoutFrequenceView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct WorkoutFrequenceView: View {
    var body: some View {
        GroupBox {
            GroupBox(label:
                        HStack{
                Text("Semaine")
                Button(action: {}) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundStyle(.main)
                }
                
                Button(action: {}) {
                    Image(systemName: "arrow.forward.circle.fill")
                        .foregroundStyle(.main)
                }
                
                Spacer()
                Button(action: {}) {
                    Text("Ajout")
                }
            }) {
                
            }
            .groupBoxStyle(WorkoutBoxStyle())
            .padding()
            .cornerRadius(15)
        }
        .groupBoxStyle(WorkoutBoxStyle(color: Color.white))
        .frame(width: 400, height: 250)
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    RootNavigation()
}

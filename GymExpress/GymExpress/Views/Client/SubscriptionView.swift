//
//  SubscriptionView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        GroupBox {
            HStack {
                Button(action: { }) {
                    HStack {
                        Text("Bronze")
                        Label("arrow", systemImage: "chevron.right.circle")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        //.groupBoxStyle(WorkoutBoxStyle())
        //.background(Color.white)
        .cornerRadius(15)
        .padding()
    }
}

#Preview {
    RootNavigation()
}

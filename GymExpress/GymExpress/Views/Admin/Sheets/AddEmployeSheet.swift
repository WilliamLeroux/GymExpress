//
//  AddEmployeSheet.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-03.
//

import SwiftUI

struct AddEmployeSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Annuler") {
        }
        .buttonStyle(RoundedButtonStyle(width: 85, action: {
            dismiss()
        }))
    }
}

#Preview {
    AddEmployeSheet()
}

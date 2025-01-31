//
//  EmployesView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct EmployesView: View {
    var body: some View {
        Text("Employés")
    }
}

#Preview {
    EmployesView()
}

struct Employes {
    var name: String
    var lastName: String
    var salary: CGFloat
}

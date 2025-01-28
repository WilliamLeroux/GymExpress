//
//  AdminNavigationView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct AdminNavigationView: View {
    @State private var selectedItem: NavigationItemAdmin? = .dashboard ///< Contient la liste de navigation (Accueil est sélectionné par défaut)
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
            Divider()
            NavigationSplitView {
                // Sidebar
                VStack {
                    Spacer()
                    Text("Menu")
                        .font(.system(size: 36))
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
                    List(NavigationItemAdmin.allCases, id: \.self, selection: $selectedItem) { item in
                        Text(item.rawValue)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 30)
                            //.listRowBackground(item == selectedItem ? Color.main : Color.white)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
                .toolbar(removing: .sidebarToggle)
                .background(Color(.white))
            }
            detail: {
                if let selectedItem = selectedItem {
                    switch selectedItem {
                    case .finances:
                        FinanceView()
                    case .dashboard:
                        DashboardView()
                    case .employes:
                        EmployesView()
                    }
                } else {
                    Text("Sélectionnez un élément")
                }
            }
            .navigationSplitViewColumnWidth(400)
            .navigationSplitViewStyle(.balanced)

        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    AdminNavigationView()
}

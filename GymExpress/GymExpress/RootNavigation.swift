//
//  AdminNavigationView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI

struct RootNavigation: View {
    @State private var selectedItem : String? = "Dashboard" // item sélectionné
    
    private var userType: UserType = .admin // Type d'utilisateur
    private var navOption: [String] = [] // Liste des options
    
    init (userType: UserType = .admin) {
        self.userType = userType
        self.navOption = Utils.shared.getNavOptions(userType: userType)
    }
    
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
                    
                    List {
                        ForEach(navOption, id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 30)
                                .paletteSelectionEffect(item == selectedItem)
                                .onTapGesture {
                                    selectedItem = item
                                }
                                .listRowBackground(Color.clear)
                        }
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
                    case "Finances":
                        FinanceView()
                    case "Dashboard":
                        DashboardAdminView()
                    case "Employés":
                        EmployesView()
                    default:
                        DashboardAdminView()
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
    RootNavigation()
}

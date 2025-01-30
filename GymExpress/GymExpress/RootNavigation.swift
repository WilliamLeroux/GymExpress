//
//  AdminNavigationView.swift
//  GymExpress
//
//  Created by Nicolas Morin, William Leroux on 2025-01-27.
//

import SwiftUI

struct RootNavigation: View {
    @State private var selectedItem : String? = "Accueil" // item sélectionné
    
    private var userType: UserType // Type d'utilisateur
    private var navOption: [String] = [] // Liste des options
    
    init (userType: UserType = .client) {
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
                    .background(Color.white)
                    Spacer()
                    Footer(isLoginPage: false)
                }
                .toolbar(removing: .sidebarToggle)
                .background(Color(.white))
            
            }
            detail: {
                if let selectedItem = selectedItem {
                    switch selectedItem {
                    case "Finances":
                        FinanceView()
                    case "Accueil":
                        if userType == .client {
                            DashboardClientView()
                        } else {
                            DashboardAdminView()
                        }
                        
                    case "Employés":
                        EmployesView()
                    default:
                        DashboardClientView()
                    }
                } else {
                    Text("Sélectionnez un élément")
                }
            }
            .navigationSplitViewStyle(.balanced)

        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    RootNavigation()
}

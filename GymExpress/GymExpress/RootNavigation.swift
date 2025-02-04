//
//  AdminNavigationView.swift
//  GymExpress
//
//  Created by Nicolas Morin, William Leroux on 2025-01-27.
//

import SwiftUI

struct RootNavigation: View {
    @State private var hoveredItem: String? = nil /// Item survolé
    @ObservedObject private var controller = NavigationController.shared /// Controlleur de navigation
    
    private var userType: UserType /// Type d'utilisateur
    private var navOption: [String] = [] /// Liste des options
    
    /// - Parameter userType: Type d'utilisateur
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
                                .background(hoveredItem == item ? Color.gray.opacity(0.3) : Color.clear)
                                .onTapGesture {
                                    controller.selectedIndex = item
                                }
                                .onHover { hovering in
                                    hoveredItem = hovering ? item : nil
                                }
                                .paletteSelectionEffect(item == controller.selectedIndex)
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
                if let selectedItem = controller.selectedIndex {
                    switch selectedItem {
                    case "Finances":
                        FinanceView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Accueil":
                        if userType == .client {
                            DashboardClientView()
                                .frame(minWidth: 800, maxWidth: 900)
                        } else {
                            DashboardAdminView()
                                .frame(minWidth: 800, maxWidth: 900)
                        }
                        
                    case "Employés":
                        EmployesView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Rendez-vous":
                        AppointmentView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Progrès":
                        ProgressView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Abonnement":
                        SubscriptionView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Plan d'entraînement":
                        TrainingPlanView()
                            .frame(minWidth: 800, maxWidth: 900)
                    case "Fréquence":
                        WorkoutFrequenceView()
                            .frame(minWidth: 800, maxWidth: 900)
                    default:
                        DashboardClientView()
                            .frame(minWidth: 800, maxWidth: 900)
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

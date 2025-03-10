//
//  DashboardClientView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct DashboardClientView: View {
    private var navController = NavigationController.shared /// Controlleur de navigation
    @State var freqList: [Bool] = [false, true, true, false, false, true, false] /// À changer, liste de fréquence
    @State var hasWorkout: Bool = true /// À changer, booléen signifiant qu'il a un entraînement aujourd'hui
    @State var workout: [String] = ["a", "b", "c", "d", "e", "f", "g"] /// À changer, entraînement
    @ObservedObject var controller = ClientDashboardController.shared
    
    var body: some View {
        NavigationStack {
            Grid {
                GridRow() {
                    VStack{
                        HStack{
                            smallBox(title: "Progrès", view:
                                        Image(.progress)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemClient.progress.rawValue
                            }
                            )
                            smallBox(title: "Gérer mon abonnement", view:
                                        Image(.subscription)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemClient.subscription.rawValue
                            }
                            )
                        }
                        .frame(width: 400)
                        
                        HStack(){
                            smallBox(title: "Rendez-vous", view:
                                        Image(.appointment)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.60),
                                     action: {
                                self.navController.selectedIndex = NavigationItemClient.appointment.rawValue
                            }
                            )
                        }
                        .frame(width: 410, alignment: .leading)
                        
                        
                    }
                    mediumBox(
                        title: "Plan d'entraînement",
                        view: workoutPreview(),
                        action: {
                            self.navController.selectedIndex = NavigationItemClient.training.rawValue
                        }
                    )
                }
                GridRow {
                    longBox(
                        title: "Fréquence d'entraînement",
                        view: sevenDaysCalendar(),
                        action: {
                            self.navController.selectedIndex = NavigationItemClient.frequence.rawValue
                        }
                    )
                }
                .gridCellColumns(3)
            }
        }
    }
}
extension DashboardClientView {
    func sevenDaysCalendar() -> some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<7) { day in
                    HStack {
                        GroupBox(label:
                                    Text("\(controller.calendar.weekdaySymbols[day])")
                            .fontWeight(.semibold)
                            .font(.system(size: 9))
                        ) {
                            HStack(spacing: 0) {
                                if controller.frequence[day] {
                                    Label("", systemImage: "checkmark")
                                        .labelStyle(.iconOnly)
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundStyle(Color.green)
                                }
                                
                            }
                            .frame(width: geometry.frame(in: .local).width / 9, height: geometry.frame(in: .local).height / 2, alignment: .center)
                            .cornerRadius(15)
                        }
                        .groupBoxStyle(DashboardCalendarBoxStyle())
                        .padding(.top, 15)
                        
                        if day != 6 {
                            Divider()
                        }
                    }
                    
                }
            }
            .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height)
        }
    }
    
    func workoutPreview() -> some View {
        GeometryReader { geometry in
            VStack {
                if !hasWorkout {
                    Label("Aucun entraînment aujourd'hui", systemImage: "checkmark")
                        .labelStyle(.titleOnly)
                } else {
                    ForEach(0..<workout.count, id: \.self) { index in
                        HStack {
                            Label(workout[index], systemImage: "")
                                .labelStyle(.titleOnly)
                                .font(.caption)
                                .fontWeight(.semibold)
                            Spacer()
                                .frame(width: geometry.frame(in: .local).width * 0.5)
                            Label("45 kg", systemImage: "")
                                .labelStyle(.titleOnly)
                                .font(.caption)
                        }
                        
                        if index != workout.count - 1 {
                            Divider()
                                .frame(width: geometry.frame(in: .local).width * 0.7)
                        }
                    }
                }
                
            }
            .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height, alignment: .center)
        }
    }
}

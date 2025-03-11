//
//  SubscriptionView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct SubscriptionView: View {
    @ObservedObject var controller = ClientSubscriptionController.shared
    @State private var membership: [MembershipGrade] = MembershipGrade.allCases.reversed() /// Liste des abonnements
    @State private var membershipDesc: [String] = ["allo1,allo2", "allo1,allo2,allo3", "allo1,allo2,allo3,allo4", "allo1,allo2,allo3,allo4,allo5"] /// À changer, description des abonnements
    @State private var currentMembership: Int? = 2 /// À changer, abonnement actuel
    @State private var selectedMembership: Int? /// Abonnement sélectionné
    @State private var deleteAlert: Bool = false
    
    var body: some View {
        GroupBox {
            HStack {
                ForEach(0..<controller.memberships.count, id: \.self) {index in
                    Button(action: { }) {
                        VStack {
                            VStack {
                                HStack {
                                    Text(controller.memberships[index].grade.rawValue)
                                        .font(.system(size: 15, weight: .bold))
                                    Label("arrow", systemImage: "chevron.right.circle")
                                        .labelStyle(.iconOnly)
                                        .font(.system(size: 15, weight: .bold))
                                        .rotationEffect(controller.selectedMembership == index || controller.currentMembership == index ? .degrees(90) : .degrees(0))
                                        .animation(.easeInOut(duration: 0.2), value: controller.selectedMembership == index)
                                }
                                .padding(.top, 10)
                                
                                if controller.currentMembership == index {
                                    Text("Votre abonnement")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                            }
                            
                            
                            Spacer()
                            
                            
                            if (controller.selectedMembership == index || controller.currentMembership == index) {
                                VStack {
                                    ForEach(0..<controller.memberships.last!.description!.split(separator: ",").count, id: \.self) { description in
                                        Text("- \(controller.memberships.last!.description!.split(separator: ",")[description])")
                                            .strikethrough(description > controller.memberships[index].description!.split(separator: ",").count - 1, color: .black)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(description > controller.memberships[index].description!.split(separator: ",").count - 1 ? .gray : .black)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        VStack {
                                            Text("Changer de plan")
                                                .font(.system(size: 13, weight: .semibold))
                                            Text("\(Utils.shared.getMembershipPrice(membership: controller.memberships[index].grade).formatted(.number.precision(.fractionLength(2))))$")
                                                .font(.system(size: 10, weight: .regular))
                                        }
                                        
                                    }
                                    .buttonStyle(RoundedButtonStyle(
                                        width: 150,
                                        height: 30,
                                        color: controller.currentMembership == index ? .gray.opacity(0.8) : .main,
                                        action: {
                                            deleteAlert.toggle()
                                        }
                                    ))
                                    .disabled(controller.currentMembership == index)
                                    .sheet(isPresented: $deleteAlert) {
                                        ConfirmationSheet(title: "Voulez-vous changer de plan ?", message: "Voulez-vous vraiment changer de plan pour le plan \(controller.memberships[controller.selectedMembership!].grade.rawValue)", cancelAction: {deleteAlert.toggle()}, confirmAction: {
                                            controller.updateUserMembership(controller.selectedMembership!)
                                            deleteAlert.toggle()
                                        })
                                    }
                                }
                                .padding(.top, 50)
                            }
                            Spacer()
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .buttonStyle(RoundedButtonStyle(
                        width: controller.selectedMembership == index || controller.currentMembership == index ? withAnimation(.easeInOut(duration: 0.5)) {
                            200} : withAnimation(.easeInOut(duration: 0.5)) {
                                100},
                        height: controller.selectedMembership == index || controller.currentMembership == index ? 300 : 40,
                        color: Color.white,
                        hoveringColor: getMemberShipColor(membershipGrade: controller.memberships[index].grade).opacity(0.2),
                        borderColor: getMemberShipColor(membershipGrade: controller.memberships[index].grade),
                        borderWidth: 5,
                        action: {
                            controller.setSelectedMembership(index)
                        }
                    ))
                }
            }
        }
        .cornerRadius(15)
        .padding()
    }
}

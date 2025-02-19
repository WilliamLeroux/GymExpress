//
//  SubscriptionView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct SubscriptionView: View {
    @State private var membership: [MembershipGrade] = MembershipGrade.allCases.reversed() /// Liste des abonnements
    @State private var membershipDesc: [String] = ["allo1,allo2", "allo1,allo2,allo3", "allo1,allo2,allo3,allo4", "allo1,allo2,allo3,allo4,allo5"] /// À changer, description des abonnements
    @State private var currentMembership: Int? = 2 /// À changer, abonnement actuel
    @State private var selectedMembership: Int? /// Abonnement sélectionné
    
    var body: some View {
        GroupBox {
            HStack {
                ForEach(0..<membership.count, id: \.self) {index in
                    Button(action: { }) {
                        VStack {
                            VStack {
                                HStack {
                                    Text(membership[index].rawValue)
                                        .font(.system(size: 15, weight: .bold))
                                    Label("arrow", systemImage: "chevron.right.circle")
                                        .labelStyle(.iconOnly)
                                        .font(.system(size: 15, weight: .bold))
                                        .rotationEffect(selectedMembership == index || currentMembership == index ? .degrees(90) : .degrees(0))
                                        .animation(.easeInOut(duration: 0.2), value: selectedMembership == index)
                                }
                                .padding(.top, 10)
                                
                                if currentMembership == index {
                                    Text("Votre abonnement")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                            }
                            
                            
                            Spacer()
                            
                            
                            if (selectedMembership == index || currentMembership == index) {
                                VStack {
                                    ForEach(0..<membershipDesc[3].split(separator: ",").count, id: \.self) { description in
                                        Text("- \(membershipDesc[3].split(separator: ",")[description])")
                                            .strikethrough(description > membershipDesc[index].split(separator: ",").count - 1, color: .black)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(description > membershipDesc[index].split(separator: ",").count - 1 ? .gray : .black)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        VStack {
                                            Text("Changer de plan")
                                                .font(.system(size: 13, weight: .semibold))
                                            Text("\(Utils.shared.getMembershipPrice(membership: membership[index]).formatted(.number.precision(.fractionLength(2))))$")
                                                .font(.system(size: 10, weight: .regular))
                                        }
                                        
                                    }
                                    .buttonStyle(RoundedButtonStyle(
                                        width: 150,
                                        height: 30,
                                        color: currentMembership == index ? .gray.opacity(0.8) : .main
                                    ))
                                    .disabled(currentMembership == index)
                                }
                                .padding(.top, 50)
                            }
                            Spacer()
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .buttonStyle(RoundedButtonStyle(
                        width: selectedMembership == index || currentMembership == index ? withAnimation(.easeInOut(duration: 0.5)) {
                            200} : withAnimation(.easeInOut(duration: 0.5)) {
                                100},
                        height: selectedMembership == index || currentMembership == index ? 300 : 40,
                        color: Color.white,
                        hoveringColor: getMemberShipColor(membershipGrade: membership[index]).opacity(0.2),
                        borderColor: getMemberShipColor(membershipGrade: membership[index]),
                        borderWidth: 5,
                        action: {
                            selectedMembership = index
                        }
                    ))
                }
            }
        }
        .cornerRadius(15)
        .padding()
    }
}

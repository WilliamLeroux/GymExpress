//
//  SubscriptionView.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

import SwiftUI

struct SubscriptionView: View {
    @State private var membership: [MembershipGrade] = MembershipGrade.allCases.reversed()
    @State private var membershipDesc: [String] = ["allo1,allo2", "allo1,allo2,allo3", "allo1,allo2,allo3,allo4", "allo1,allo2,allo3,allo4,allo5"]
    @State private var currentMembership: Int? = 2
    @State private var selectedMembership: Int?
    
    var body: some View {
        GroupBox {
            HStack {
                ForEach(0..<membership.count, id: \.self) {index in
                    Button(action: { }) {
                        VStack {
                            HStack {
                                Text(membership[index].rawValue)
                                Label("arrow", systemImage: "chevron.right.circle")
                                    .labelStyle(.iconOnly)
                                    .rotationEffect(selectedMembership == index || currentMembership == index ? .degrees(90) : .degrees(0))
                                    .animation(.easeInOut(duration: 0.2), value: selectedMembership == index)
                            }
                            .padding(.top, 10)
                            
                            Spacer()
                            
                            if (selectedMembership == index || currentMembership == index) {
                                VStack {
                                    ForEach(0..<membershipDesc[3].split(separator: ",").count, id: \.self) { description in
                                        Text("- \(membershipDesc[3].split(separator: ",")[description])")
                                            .strikethrough(description > membershipDesc[index].split(separator: ",").count - 1, color: .gray)
                                            
                                    }
                                }
                                //.padding(.top, 50)
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
                        hoveringColor: Color.white.opacity(0.8),
                        action: {
                            selectedMembership = index
                        }
                    ))
                    .border(getMemberShipColor(membershipGrade: membership[index]), width: 2)
                    .cornerRadius(15)
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

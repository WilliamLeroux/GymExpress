//
//  SubsricptionEditView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-04.
//

import SwiftUI

struct SubscriptionEditView: View {
    @State private var selectedMembership: MembershipGrade?
    
    var body: some View {
        HStack {
            ForEach(MembershipGrade.allCases) { membership in
                VStack {
                    HStack {
                        Text("\(membership.rawValue)")
                            .font(.system(size: 15, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            selectedMembership = membership
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(getMemberShipColor(membershipGrade: membership))
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Prix : 10.99")
                        .font(.system(size: 15, weight: .bold))
                        .padding(25)
                    
                    Text("Description : ")
                        .font(.system(size: 15, weight: .bold))
                        .padding(25)
                }
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(getMemberShipColor(membershipGrade: membership), lineWidth: 5)
                        )
                )
                .padding(30)
            }
        }
        .sheet(item: $selectedMembership) { membership in
            MembershipEditView(membership: membership)
        }
    }
}

struct MembershipEditView: View {
    @Environment(\.dismiss) var dismiss
    let membership: MembershipGrade
    
    var body: some View {
        VStack {
            Text("Modifier l'abonnement : \(membership.rawValue)")
                .font(.title)
                .padding()
            
            Button("Fermer") {
                dismiss()
            }
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    SubscriptionEditView()
}
#Preview {
    SubscriptionEditView()
}

//
//  SubsricptionEditView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-02-04.
//

import SwiftUI

struct SubscriptionEditView: View {
    var body: some View {
        HStack {
            ForEach(MembershipGrade.allCases) { membership in
                VStack {
                    HStack {
                        Text("\(membership.rawValue)")
                            .font(.system(size: 15, weight: .bold))
                        
                        Spacer()
                        
                        Image(systemName: "pencil")
                            .foregroundColor(getMemberShipColor(membershipGrade: membership))
                            .font(.system(size: 24, weight: .bold)) 
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
    }
}

#Preview {
    SubscriptionEditView()
}

//
//  FinanceView.swift
//  GymExpress
//
//  Created by Nicolas Morin on 2025-01-27.
//

import SwiftUI
import Charts

struct FinanceView: View {
    
    @State private var isShowingPopover = false ///< Bool pour afficher ou non la sheet
    
    /// Données temporaires
    let membershipData: [MembershipDataManager] = [
        MembershipDataManager(grade: .bronze, count: 50),
        MembershipDataManager(grade: .silver, count: 90),
        MembershipDataManager(grade: .gold, count: 122),
        MembershipDataManager(grade: .platinum, count: 45),
    ]
    
    /// Données temporaires
    var totalAbonnements: Int {
        membershipData.map { $0.count }.reduce(0, +)
    }
    
    var body: some View {
        VStack {
            Text("Répartition des abonnements")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            HStack {
                VStack {
                    Text("Total d'abonné : \(totalAbonnements)")
                    ForEach(membershipData) { data in
                        HStack {
                            Circle()
                                .frame(width:15, height: 15)
                                .foregroundStyle(getMemberShipColor(membershipGrade: data.grade))
                            Text("\(data.count)")
                        }
                        
                    }
                }
                Chart(membershipData) { membership in
                    SectorMark(
                        angle: .value("Abonnements", membership.count),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(getMemberShipColor(membershipGrade: membership.grade))
                    .annotation(position: .overlay) {
                        Text("\(membership.grade.rawValue)\n\(Int((Double(membership.count) / Double(totalAbonnements)) * 100))%")
                            .font(.caption)
                            .foregroundColor(.black)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 400, height: 300)
                .padding()
            }
        }
    }
}

/// Données temporaires
struct MembershipDataManager: Identifiable, Equatable {
    let grade: MembershipGrade
    let count: Int
    var id: MembershipGrade { grade }
}

/// Données temporaires
func getMemberShipColor(membershipGrade: MembershipGrade) -> Color{
    switch membershipGrade {
    case .bronze:
        return Color.brown
    case .silver:
        return Color.gray
    case .gold:
        return Color.yellow
    case .platinum:
        return Color.main
    }
}

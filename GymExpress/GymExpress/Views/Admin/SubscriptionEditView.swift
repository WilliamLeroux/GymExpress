import SwiftUI

struct SubscriptionEditView: View {
    @ObservedObject var controller = SubscriptionController()
    @State private var selectedMembership: MembershipGrade?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(controller.memberships) { membershipData in
                    MembershipCardView(membershipData: membershipData)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MembershipCardView: View {
    let membershipData: MembershipData
    
    var body: some View {
        VStack {
            HStack {
                Text("\(membershipData.grade.rawValue)")
                    .font(.system(size: 15, weight: .bold))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            Text("Prix : \(String(format: "%.2f", membershipData.price!))$")
                .font(.system(size: 15, weight: .bold))
                .padding(25)
            descriptionSection
        }
        .padding(.vertical)
        .background(cardBackground)
        .frame(width: 175, height: 400) // Taille fixe pour tous les éléments
        .padding(15)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading) {
            Text("Description : ")
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(formattedDescription, id: \.self) { line in
                    Text("- \(line)")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 25)
        }
    }
    
    private var formattedDescription: [String] {
        let description = membershipData.description ?? ""
        return description.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(getMemberShipColor(membershipGrade: membershipData.grade), lineWidth: 5)
            )
    }
}

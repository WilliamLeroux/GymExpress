//
//  utils.swift
//  GymExpress
//
//  Created by William Leroux on 2025-01-28.
//

class Utils {
    static let shared = Utils() // Singleton
    
    private init() {
    }
    
    func getNavOptions(userType: UserType) -> [String] {
        var tempList: [String] = []
        switch userType {
            case .trainer:
            for item in NavigationItemTrainer.allCases {
                tempList.append(item.rawValue)
            }
            return tempList
        case .admin:
            for item in NavigationItemAdmin.allCases {
                tempList.append(item.rawValue)
            }
            return tempList
        case .client:
            for item in NavigationItemClient.allCases {
                tempList.append(item.rawValue)
            }
            return tempList
        }
    }
    
    func getMembershipGradeId(membership: MembershipGrade) -> Int {
        switch membership {
        case .bronze:
            return 1
        case .silver:
            return 2
        case .gold:
            return 3
        case .platinum:
            return 4
        }
    }
    
    func getMembershipById(id: Int) -> MembershipGrade {
        switch id {
        case 1:
            return .bronze
        case 2:
            return .silver
        case 3:
            return .gold
        case 4:
            return .platinum
        default:
            fatalError("Invalid membership id")
        }
    }
    
    func getMembershipPrice(membership: MembershipGrade) -> Double {
        switch membership {
        case .bronze:
            return 11.0
        case .silver:
            return 16.0
        case .gold:
            return 21.0
        case .platinum:
            return 26.0
        }
    }
}

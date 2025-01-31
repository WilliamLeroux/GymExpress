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

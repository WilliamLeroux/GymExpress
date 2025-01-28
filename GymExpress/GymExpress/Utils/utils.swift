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
}

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
        case .receptionist:
            return []
        case .janitor:
            return []
        case .machineRepairer:
            return []
        case .cook:
            return []
        }
    }
    
    func getRecurrenceTypeId(recurrence: RecurrenceType) -> Int {
        switch recurrence {
        case .none:
            return 0
        case .daily:
            return 1
        case .weekly:
            return 2
        case .monthly:
            return 3
        }
    }
    
    func getRecurrenceTypeById(id: Int) -> RecurrenceType {
        switch id {
        case 0:
            return .none
        case 1:
            return .daily
        case 2:
            return .weekly
        case 3:
            return .monthly
        default:
            fatalError("Invalid recurrence id")
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
    
    func getMuscle(bodyPart: BodyParts) -> [String] {
        switch bodyPart {
        case .cardio:
            return ["cardio"]
        case .upperBody:
            return ["chest", "back", "upper arms", "lower arms", "shoulders"]
        case .lowerBody:
            return ["lower legs", "upper legs"]
        case .core:
            return ["waist"];
        }
    }
    
    func getBodyPartsById(_ id: Int) -> BodyParts {
        switch id {
        case 0:
            return .cardio
        case 1:
            return .upperBody
        case 2:
            return .lowerBody
        case 3:
            return .core
        default:
            fatalError("Invalid body part id")
        }
    }
    
    func getBodyPartsId(_ bodyPart: BodyParts) -> Int {
        switch bodyPart {
        case .cardio:
            return 0
        case .upperBody:
            return 1
        case .lowerBody:
            return 2
        case .core:
            return 3
        }
    }
    
    
}

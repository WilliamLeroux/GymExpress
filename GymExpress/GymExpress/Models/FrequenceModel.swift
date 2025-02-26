//
//  FrequenceModel.swift
//  GymExpress
//
//  Created by William Leroux on 2025-02-26.
//

import Foundation

struct FrequenceModel: Identifiable, SQLConvertable {
    var id: Int = -1
    var userId: Int = -1
    var date: Date? = nil
    
    init(userId: Int, date: Date? = nil) {
        self.userId = userId
        self.date = date
    }
    
    
    
    var params: [Any] {
        return [userId, date as Any]
    }
}

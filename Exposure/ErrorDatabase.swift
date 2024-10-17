//
//  ErrorDatabase.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/16/24.
//

import Foundation

struct ErrorDatabase: Identifiable {
    
    let id: UUID
    let error: Error
    let code: String
    var criticalLevel: criticalLevel
    
    init (id: UUID = UUID(), error: Error, code: String, criticalLevel: criticalLevel) {
        self.id = id
        self.error = error
        self.code = code
        self.criticalLevel = criticalLevel
    }
    
    enum criticalLevel: String {
        
        case none = "Warning"
        case small = "Non Critical"
        case critical = "Critical"
        case fatal = "Fatal"
        
    }
}

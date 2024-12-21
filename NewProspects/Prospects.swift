//
//  Prospects.swift
//  NewProspects
//
//  Created by Adrino Rosario on 21/12/24.
//

import Foundation
import SwiftData

@Model
class Prospects {
    var name: String
    var mobile: String
    var emailAddress: String
    var dateCreated: Date
    var isContacted: Bool
    
    init(name: String, mobile: String, emailAddress: String, dateCreated: Date, isContacted: Bool) {
        self.name = name
        self.mobile = mobile
        self.emailAddress = emailAddress
        self.dateCreated = dateCreated
        self.isContacted = isContacted
    }
}

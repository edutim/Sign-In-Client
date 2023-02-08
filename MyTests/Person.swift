//
//  Person.swift
//  MyTests
//
//  Created by Timothy Hart on 2/7/23.
//

import Foundation

struct Person: Codable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var email: String
    var role: String
    var reasonForVisit: String
    var date: Date
}

struct ReturnedPerson: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var role: String
    var reasonForVisit: String
}

//
//  Person.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import CoreData

//Четверг 11, просп науки 56
@objc protocol PersonProtocol {
    var name: String {get set}
    var userID: String {get set}
    var isActive: Bool {get set}
    var age: Int32 {get set}
    var gender: Bool {get set}
    var email: String? {get set}
    var phone: String? {get set}
    var address: String? {get set}
    var about: String? {get set}
    var registered: NSDate {get set}
    var favoriteFruit: String? {get set}
    var picture: String? {get set}
    var company: String? {get set}
    var yearColor: String? {get set}
    var balance: String {get set}
    
    var tags: [String]? {get set}
    var friends: NSDictionary? {get set}
}
 
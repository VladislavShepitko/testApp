//
//  Person+CoreDataProperties.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData



extension Person : PersonProtocol{

    @NSManaged var name: String
    @NSManaged var userID: String
    @NSManaged var isActive: Bool
    @NSManaged var age: Int32
    @NSManaged var gender: Bool
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var address: String?
    @NSManaged var about: String?
    @NSManaged var registered: NSDate
    @NSManaged var favoriteFruit: String?
    @NSManaged var picture: String?
    @NSManaged var company: String?
    @NSManaged var yearColor: String?
    @NSManaged var balance: String
    
    @NSManaged var tags: [String]?
    @NSManaged var friends: NSDictionary?

}

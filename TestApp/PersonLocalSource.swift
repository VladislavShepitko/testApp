//
//  PersonStore.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class PersonLocalSource: NSObject, DataSource {
    
    weak var delegate:DataSourceDelegate?
    
    private var persons:[Person] = []
    
    private let dataStore:CoreDataHelper
    private let remoteSource:RemotePersonSource?
    
    override init(){
        dataStore = CoreDataHelper(modelName: "TestApp", dataStoreName: "TestApp.sqlite")
        remoteSource = RemotePersonSource()
        super.init()
    }
    
    
    func fetchData() {
        if self.ifPersonsAxist() {
            self.fetchDataFromLocalSource()
        }else {
            remoteSource?.fetchData({ result in
                switch result {
                case .Success(data: let json):
                    //print(json)
                    self.processJSON(json)
                    
                    if self.ifPersonsAxist() {
                        self.fetchDataFromLocalSource()
                    }else {
                        if let _delegate = self.delegate {
                            _delegate.didFetchData(self, data:nil)
                        }
                    }
                case .Failure(let error):
                    if let _delegate = self.delegate {
                        _delegate.didFetchData(self, data:nil)
                        print(error)
                    }
                }
            })
        }
    }
    
    func fetchData(withID:String) -> PersonProtocol?{
        return self.person(withID)
    }
    
    func fetchDataFromLocalSource(){
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.dataStore.managedObjectContext!)
        fetchRequest.entity = entity
        do {
            self.persons.removeAll()
            self.persons = try dataStore.managedObjectContext?.executeFetchRequest(fetchRequest) as! [Person]
            if let _delegate = delegate {
                _delegate.didFetchData(self, data: self.persons)
            }
        }catch {
            if let _delegate = delegate {
                _delegate.didFetchData(self, data: nil)
            }
        }
    }
    
    private func processJSON(json:JSON){
        for index in 0..<json.count {
            addPersonFromJSON(json[index])
        }
        print(persons.count)
    }
    
    private func addPersonFromJSON(json:JSON) -> Person?{
        if let id = json["id"].string, let name = json["name"].string {
            let isActive = json["isActive"].bool
            let balance = json["balance"].string
            let picture = json["picture"].string
            let age = json["age"].int
            let eyeColor = json["eyeColor"].string
            let gender = json["gender"].string
            let company = json["company"].string
            
            let email = json["email"].string
            let phone = json["phone"].string
            let address = json["address"].string
            let about = json["about"].string
            let dateString = json["registered"].string
            let registered = dateFrom(dateString!)
            
            let friendsJSON = json["friends"]
            let friends = NSMutableDictionary()
            for i in 0..<friendsJSON.count{
                let fJSON = friendsJSON[i]
                let id = fJSON["id"].string
                let name = fJSON["name"].string
                friends.setValue("\(id)", forKey: name!)
            }
            
            let tagsJSON = json["tags"]
            var tags = [String]()
            for i in 0..<tagsJSON.count{
                tags.append(tagsJSON[i].stringValue)
            }
            
            let favoriteFruit = json["favoriteFruit"].string
            
            let person = self.dataStore.newEntity("Person") as? Person
            if let _person = person {
                _person.name = name
                _person.userID = id
                _person.isActive = isActive!
                _person.balance = balance!
                _person.picture = picture
                _person.age = Int32(age!)
                _person.yearColor = eyeColor
                _person.gender = gender == "female" ? false : true
                _person.company = company
                _person.email = email
                _person.phone = phone
                _person.address = address
                _person.about = about
                _person.registered = registered ?? NSDate()
                
                _person.friends = friends
                _person.tags = tags
                
                _person.favoriteFruit = favoriteFruit
                
                self.dataStore.saveContext()
            }
        }
        
        return nil
    }
    
    private func ifPersonsAxist() -> Bool {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.dataStore.managedObjectContext!)
        fetchRequest.entity = entity
        
        do {
            if let result = try dataStore.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Person]{
                return result.count > 0
            }else {
                return false
            }
        }catch {
            return false
        }
    }
     
    
    func person(withID:String) -> PersonProtocol?{
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.dataStore.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "userID == %@", withID)
        
        var personToReturn:Person?
        do {
            if let result = try dataStore.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Person]{
                personToReturn = result.first
            }
            return personToReturn
        }catch {
            return nil
        }
    }
    
    func removeAll(){
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.dataStore.managedObjectContext!)
        fetchRequest.entity = entity
        do {
            let entitiesToremove = try dataStore.managedObjectContext?.executeFetchRequest(fetchRequest) as! [Person]
            for objToDelete in entitiesToremove {
                self.dataStore.managedObjectContext?.deleteObject(objToDelete)
            }
            self.dataStore.saveContext()
        }catch {
            
        }
    }
    
}
 
//
//  DetailedPersonViewModel.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import UIKit

class DetailedPersonViewModel: NSObject {
    private typealias Item = (key:DetailedFields, value:String)
    var name:String?
    var isActiveColor: UIColor?
    var pictureURL: NSURL?
    var about: String?
    var friends = String()
    var tags = String()
    
    private var items:[Item] = []
    
    
    init(personData: PersonProtocol?) {
        if let _data = personData{
            self.name = personData?.name ?? "no name"
            self.isActiveColor = _data.isActive ? UIColor.greenColor() : UIColor.redColor()
            self.about = _data.about
            self.pictureURL = NSURL(string: _data.picture!)
            self.items.append(Item(.Registered, dateToString(_data.registered)))
            
            if let email = _data.email{
                self.items.append(Item(.Email,email))
            }
            if let phone = _data.phone {
                self.items.append(Item(.Phone, phone))
            }
            if let address = _data.address {
                self.items.append(Item(.Address, address))
            }
            if let company = _data.company {
                self.items.append(Item(.Company, company))
            }

            self.items.append(Item(.Age, "\(_data.age)"))
            self.items.append(Item(.Gender, _data.gender ? "Male" : "Female"))
            
            
            if let yearColor = _data.yearColor {
                self.items.append(Item(.YearColor, yearColor))
            }
            self.items.append(Item(.Balance, "\(_data.balance)"))

            if let favoriteFruit = _data.favoriteFruit {
                self.items.append(Item(.FavoriteFruit, favoriteFruit))
            }
            
            if let _tags = _data.tags {
                for t in _tags{
                    self.tags += "#"+t
                }
            }
            
            if let friends = _data.friends where friends.count > 0 {
                for (value, _) in friends {
                    self.friends += "\(value) "
                }
                self.items.append(Item(.Friends, self.friends))
            }            
            
        }
        super.init()
    }
    
    private enum DetailedFields : String {
        case Email
        case Age
        case Gender
        case Phope
        case Address
        case Balance
        case FavoriteFruit
        case YearColor
        case Registered
        case Company
        case Phone
        case Friends
    }
    
}

extension DetailedPersonViewModel {
    func numberOfItems() -> Int{
        return items.count
    }
    
    func titleForItemAtIndexPath(path:NSIndexPath) -> String? {
        let value = items[path.item].key.rawValue
        return value.uppercaseString + ":"
    }
    
    func descriptionForItemAtIndexPath(path:NSIndexPath) -> String? {
        return items[path.item].value
    }
}
//
//  PersonViewModelProtocol.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

class PersonListViewModel : NSObject {
    var personList:[PersonViewModel] = []
    
    init(with data:[PersonProtocol]){
        super.init()
        personList.removeAll()
        for person in data {
            personList.append(PersonViewModel(name: person.name, id: person.userID))
        }
    }
}

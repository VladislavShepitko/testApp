//
//  PersonViewModel.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

class PersonViewModel : NSObject {
    let name:String
    let id:String
    
    init(name:String, id: String) {
        self.name = name
        self.id = id
        super.init()
    }
}
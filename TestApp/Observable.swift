//
//  Observable.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

class Observable<T> {
    typealias Observer = (T? -> Void)?
    private var observer:Observer
    
    var value:T? {
        didSet{
            if let action = observer {
                action(value)
            }
        }
    }
    
    init(value:T){
        self.value = value
    }
    
    func subscribe(observer:Observer){
        self.observer = observer
    }
    
}
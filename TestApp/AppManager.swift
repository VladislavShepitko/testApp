//
//  AppManager.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc protocol DataSourceDelegate:class{
    func didFetchData(dataStore:DataSource, data:[PersonProtocol]?)
}

@objc protocol DataSource:class {
    var delegate:DataSourceDelegate? {get set}
    func fetchData()
    func fetchData(withID:String)
}

class AppManager: NSObject {
    class var sharedInstance:AppManager {
        struct Wrapper {
            static let instance = AppManager()
        }
        return Wrapper.instance
    }
    /// list of all persons
    private (set) var personListViewModel:Observable<PersonListViewModel?>
    
    //just one selected person selected now
    private (set) var personViewModel:Observable<DetailedPersonViewModel?>
    
    
    var dataStore:DataSource?
    
    
    private override init() {
        personListViewModel = Observable<PersonListViewModel?>(value: nil)
        personViewModel = Observable<DetailedPersonViewModel?>(value: nil)
        super.init()
    }
    
    func fetchPersonList(){
        dataStore?.fetchData()
    }
    
    ///fetch detailed information about person with ID
    func fetchPerson(withID id: String){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [weak self] _ in
            self?.dataStore?.fetchData(id)
        }        
    }
    
}

extension AppManager : DataSourceDelegate {
    func didFetchData(dataStore:DataSource, data:[PersonProtocol]?){
        //update view model from local store
        if let _data = data {
            if _data.count > 1{
                personListViewModel.value = PersonListViewModel(with: _data)
            }else if _data.count > 0 {
                personViewModel.value = DetailedPersonViewModel(personData: _data.first)
            }
        }else {
            personListViewModel.value = nil
        }
    }
}

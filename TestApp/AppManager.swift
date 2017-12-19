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
    func fetchData(withID:String) -> PersonProtocol?
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
        if let result = dataStore?.fetchData(id){
                //and notify that view mode did change
                personViewModel.value = DetailedPersonViewModel(personData: result)
            }else {
                personViewModel.value = nil
        }        
    }
    
}

extension AppManager : DataSourceDelegate {
    func didFetchData(dataStore:DataSource, data:[PersonProtocol]?){
        /*if dataStore is RemoteDataStore {
            //inset data to local store
            if let _data = data where _data.count > 0 {
                for newPerson in _data {
                    self.dataStore?.addPerson(newPerson)
                }
                //fetch this data from loal store
                self.dataStore?.fetchData()
                return
            }
        }else if dataStore is AppDataStore {
            if data == nil || data?.count == 0 {
                //this is mark that we don't have any data, 
                //update view model with nil and start download data
                personListViewModel.value = nil
                //self.remoteDataStore?.fetchData()
            }
        }*/
        //update view model from local store
        if let _data = data {
            personListViewModel.value = PersonListViewModel(with: _data)
        }else {
            personListViewModel.value = nil
        }
    }
}

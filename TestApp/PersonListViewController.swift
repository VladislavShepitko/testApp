//
//  ViewController.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class PersonListViewController: UITableViewController {
    private var appManager = AppManager.sharedInstance
    private var viewModel:PersonListViewModel?
    private var selectedModelIndex:Int = -1
    private let SEGUE_ID = "DetailedPersonSegueID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
        appManager.personListViewModel.subscribe { [unowned self] model in
            if let _model = model {
                self.viewModel = _model!
                self.tableView.reloadData()
                
                let app = UIApplication.sharedApplication()
                app.networkActivityIndicatorVisible = false
            } 
        }
        appManager.fetchPersonList()
    }
}

extension  PersonListViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCellID", forIndexPath: indexPath)
        
        cell.textLabel?.text = viewModel?.personList[indexPath.item].name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.personList.count ?? 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedModelIndex = indexPath.item
        performSegueWithIdentifier(SEGUE_ID, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_ID {
            let destVC = segue.destinationViewController as! DetailedPersonViewController
            let person =  (self.viewModel?.personList[selectedModelIndex])!
            
            destVC.setSelectedID(person.id)
        }
    }
}


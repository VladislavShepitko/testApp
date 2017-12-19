//
//  DetailedPersonViewController.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//
import UIKit

class DetailedPersonViewController: UIViewController {

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var tagsView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsView: UITableView!
    @IBOutlet weak var isActiveView: UIView!    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private (set) var selectedPersonID:String?
    private (set) var viewModel:DetailedPersonViewModel?
    private var appManager = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appManager.personViewModel.subscribe({ [weak self] viewModel in
            dispatch_async(dispatch_get_main_queue(), { [weak self] _ in
                self?.viewModel = viewModel!
                self?.setupView()
            })
        })
        
        if let id = self.selectedPersonID {
            appManager.fetchPerson(withID: id)
        }
        self.isActiveView.layer.cornerRadius = 10
        self.isActiveView.layer.shadowOffset = CGSize(width: 2, height: -2)
        self.isActiveView.layer.shadowRadius = 2
        self.isActiveView.layer.shadowColor = UIColor.redColor().CGColor
        
        
        detailsView.delegate = self
        detailsView.dataSource = self         
        
        self.activityIndicatorView.startAnimating()
    }
    
    func setSelectedID(id:String){
        self.selectedPersonID = id
    }
    
    private func setupView(){
        self.nameView.text = viewModel?.name
        self.isActiveView.backgroundColor = viewModel?.isActiveColor
        self.descriptionView.text = self.viewModel!.about
        print(self.viewModel!.pictureURL)
        self.imageView.sd_setImageWithURL(self.viewModel!.pictureURL, placeholderImage: nil) { (image, error, cType, _) -> Void in
            dispatch_async(dispatch_get_main_queue(), { _ in
                //self.imageView.image = image
                self.activityIndicatorView.stopAnimating()
                self.imageView.layer.cornerRadius = 50
                self.imageView.contentMode = .ScaleAspectFit
            })
        }
        self.tagsView.text = viewModel?.tags
    }
    
}
extension DetailedPersonViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonDetailCellID", forIndexPath: indexPath)
        cell.textLabel?.text = viewModel?.titleForItemAtIndexPath(indexPath)
        cell.detailTextLabel?.text = viewModel?.descriptionForItemAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
}
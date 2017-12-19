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
    @IBOutlet weak var tagsView: UICollectionView!
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
        
        appManager.personViewModel.subscribe({ [unowned self] viewModel in
            self.viewModel = viewModel!
            self.setupView()
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
        
        tagsView.delegate = self
        tagsView.dataSource = self
        
        
        self.activityIndicatorView.startAnimating()
    }
    
    func setSelectedID(id:String){
        self.selectedPersonID = id
    }
    
    private func setupView(){
        self.nameView.text = viewModel?.name
        self.isActiveView.backgroundColor = viewModel?.isActiveColor
        self.descriptionView.text = self.viewModel!.about
        
        self.imageView.sd_setImageWithURL(self.viewModel!.pictureURL, placeholderImage: UIImage(named: "no-user-photo")) { (image, error, cType, _) -> Void in
            dispatch_async(dispatch_get_main_queue(), { _ in
                self.activityIndicatorView.stopAnimating()
                self.imageView.layer.cornerRadius = 50
            })
        }
        
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
extension DetailedPersonViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCellID", forIndexPath: indexPath) as! TagCell
        cell.tagView.text = viewModel?.tagForItemAtIndexPath(indexPath)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfTags() ?? 0
    }
}
extension DetailedPersonViewController :UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tag = Int((viewModel!.tagForItemAtIndexPath(indexPath)?.characters.count)!)
        print(tag)
        return CGSize(width: tag * 10, height: 15)
    }
}
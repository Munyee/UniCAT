//
//  InterestViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/10/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
import ParseUI

class InterestViewController: PFQueryCollectionViewController {
    
    @IBOutlet var collectionview: UICollectionView!
    
    var selected = Set<PFObject>()
    var intObject: [PFObject] = []
    var eventObject: PFObject?
    var type: Int?
    var editorRole = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editInterest:")
        
        self.navigationItem.title = "Interest"
        self.navigationController?.setToolbarHidden(true, animated: true)
        if type != 0 || editorRole {
            self.navigationItem.rightBarButtonItem = editButton
        }
        
    }
    
    func editInterest(sender:UIButton) {
        if type == 0 {
            self.performSegueWithIdentifier("interestToEditor", sender: self)
        } else {
            self.performSegueWithIdentifier("interestToUserEditor", sender: self)
        }
    }
    
    /*override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
    }*/
    
    required init?(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        
        self.parseClassName = "Interest"
        
    }
    
    override func objectsWillLoad() {
        
    }
    
    override func queryForCollection() -> PFQuery {
        if type == 0 {
            let query = PFQuery(className: "EventInterest")
            query.whereKey("eventId", equalTo: eventObject!)
            query.includeKey("interestId")
            
            return query
        } else {
            let currentUser = PFUser.currentUser()
            let query = PFQuery(className: "UserInterest")
            query.whereKey("userId", equalTo: currentUser!)
            query.whereKey("level", greaterThan: 0)
            query.includeKey("interestId")
            
            return query
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        let cell: InterestViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell", forIndexPath: indexPath) as! InterestViewCell
        
        cell.interestFrame.layer.cornerRadius = 35
        cell.interestFrame.layer.borderWidth = 1
        cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
        
        // Setting Placeholders
        let initialThumbnail = UIImage(named: "Interest")
        cell.interestImage.image = initialThumbnail
        cell.interestName.text = "LOADING"
        
        let interest = object?["interestId"] as? PFObject
        cell.interestName.text = (interest?["name"] as? String)?.uppercaseString
        self.selected.insert(interest!)
        
        cell.interestImage.file = interest?["image"] as? PFFile
        cell.interestImage.loadInBackground()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "interestToEditor" {
            let editorScene = segue.destinationViewController as! ChooseInterestViewController
            
            editorScene.selected = selected
            editorScene.eventObject = eventObject
            editorScene.type = type
        } else if segue.identifier == "interestToUserEditor" {
            let editorScene = segue.destinationViewController as! ChooseInterestViewController
            
            editorScene.selected = selected
            editorScene.type = type
        }
    }
}

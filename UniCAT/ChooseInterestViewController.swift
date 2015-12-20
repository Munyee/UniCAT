//
//  ChooseInterestViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/10/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit



class ChooseInterestViewController: PFQueryCollectionViewController {

    @IBOutlet var collectionview: UICollectionView!
    
    
    
    var selected = Set<PFObject>()
    var intObject: [PFObject] = []
    var favEvent = Set<PFObject>()
    var eventObject: PFObject?
    
    var type: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Choose Interest"
        self.navigationController?.setToolbarHidden(true, animated: true)
        if type != 2 { // When user isn't registering
            let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveInterest:")
            
            self.navigationItem.rightBarButtonItem = saveButton
        } else { // User registration
            let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "completeSignup:")
            
            self.navigationItem.rightBarButtonItem = doneButton
        }
        
        if type != 0 && type != 2 { // When user isn't registering or choosing Event Interest
            let favouriteQuery = PFQuery(className: "EventAttendance")
            let currentUser = PFUser.currentUser()
            
            favouriteQuery.whereKey("userId", equalTo: currentUser!)
            favouriteQuery.includeKey("eventId")
            
            favouriteQuery.findObjectsInBackgroundWithBlock {
                (fObjects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let fObjects = fObjects {
                        for fObject in fObjects {
                            self.favEvent.insert(fObject["eventId"] as! PFObject)
                        }
                    }
                }
            }
        }
        
        print(selected)
    }
    
    func completeSignup(sender:UIButton) {
        let currentUser = PFUser.currentUser()
        
        if self.selected.count != 0 {
            for object in self.selected {
                let newInt = PFObject(className: "UserInterest")
                
                newInt["userId"] = currentUser
                newInt["interestId"] = object
                newInt["level"] = 5
                newInt.saveEventually()
            }
            
            // Event Suggestion
            let today = NSDate()
            let eventQuery = PFQuery(className: "Event")
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: today)
            
            eventQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if let objects = objects {
                        for object in objects {
                            for interest in self.selected {
                                if (object["interest"] as! String).contains((interest["name"] as! String)) {
                                    print(object["name"])
                                    let newSuggestion = PFObject(className: "EventAttendance")
                                    
                                    newSuggestion["eventId"] = object
                                    newSuggestion["userId"] = currentUser
                                    newSuggestion["type"] = "suggest"
                                    newSuggestion.saveEventually()
                                    
                                    print("Suggested Event to User")
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.performSegueWithIdentifier("InterestToFood", sender: self)
        
//        dismissDelegate?.dismissView()
    }
    
    func saveInterest(sender:UIButton) {
        if type == 0 {
            let query = PFQuery(className: "EventInterest")
            query.whereKey("eventId", equalTo: eventObject!)
            query.includeKey("interestId")
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let interestObj = object["interestId"] as! PFObject
                            
                            if !(self.selected.contains(interestObj)) {
                                object.deleteInBackground()
                            }
                            
                            // Remove existing interest
                            self.selected.remove(interestObj)
                        }
                    }
                    if self.selected.count != 0 {
                        for object in self.selected {
                            let newEventInt = PFObject(className: "EventInterest")
                            
                            newEventInt["eventId"] = self.eventObject
                            newEventInt["interestId"] = object
                            newEventInt.saveEventually()
                        }
                    }
                }
            }
            
            var interestList = ""
            for object in selected {
                interestList += object["name"] as! String
                interestList += " "
            }
            
            eventObject?["interest"] = interestList
            eventObject?.saveEventually()
            
        } else {
            let currentUser = PFUser.currentUser()
            let selectedInt = selected
            let query = PFQuery(className: "UserInterest")
            query.whereKey("userId", equalTo: currentUser!)
            query.includeKey("interestId")
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let interestObj = object["interestId"] as! PFObject
                            
                            if !(self.selected.contains(interestObj)) {
                                object["level"] = 0
                            } else {
                                object["level"] = 5
                            }
                            object.saveEventually()
                            
                            // Remove existing interest from Set
                            if object["level"] as? NSNumber != 0 {
                                self.selected.remove(interestObj)
                            }
                        }
                    }
                    if self.selected.count != 0 {
                        for object in self.selected {
                            let newInt = PFObject(className: "UserInterest")
                            
                            newInt["userId"] = currentUser
                            newInt["interestId"] = object
                            newInt["level"] = 5
                            newInt.saveEventually()
                        }
                    }
                }
            }
            
            // Event Suggestion
            let today = NSDate()
            let eventQuery = PFQuery(className: "Event")
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: today)
            
            eventQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if let objects = objects {
                        for object in objects {
                            for interest in selectedInt {
                                if (object["interest"] as! String).contains((interest["name"] as! String)) {
                                    print(object["name"])
                                    if self.favEvent.contains(object) {
                                        print("Event already exist in Favourite list")
                                    } else {
                                        let newSuggestion = PFObject(className: "EventAttendance")
                                        
                                        newSuggestion["eventId"] = object
                                        newSuggestion["userId"] = currentUser
                                        newSuggestion["type"] = "suggest"
                                        newSuggestion.saveEventually()
                                        
                                        print("Suggested Event to User")
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers 
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);

    }
    
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
        let query = PFQuery(className: "Interest")
        query.orderByAscending("name")
        
        return query
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        collectionview.allowsMultipleSelection = true
        
        let cell: InterestViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell", forIndexPath: indexPath) as! InterestViewCell
        
        cell.interestFrame.layer.cornerRadius = 35
        cell.interestFrame.layer.borderWidth = 1
        cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
        
        cell.interestName.text = (object?["name"] as? String)?.uppercaseString
        intObject.append(object!)
        
        let initialThumbnail = UIImage(named: "Interest")
        cell.interestImage.image = initialThumbnail
        
        if let interestObj = object {
            cell.interestImage.file = interestObj["image"] as? PFFile
            cell.interestImage.loadInBackground()
            
            if selected.contains(interestObj) {
                cell.selected = true
                collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            }
        }
        
        if cell.selected {
            cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.interestImage.tintColor = UIColor.whiteColor()
            cell.interestFrame.layer.borderColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0).CGColor
            cell.interestFrame.backgroundColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0)
        } else {
            cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.interestImage.tintColor = UIColor.blackColor()
            cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
            cell.interestFrame.backgroundColor = UIColor.clearColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: InterestViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestViewCell
        
        if !(selected.contains(intObject[indexPath.row])) {
            selected.insert(intObject[indexPath.row])
            
            // Change cell appearance to Selected
            cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.interestImage.tintColor = UIColor.whiteColor()
            cell.interestFrame.layer.borderColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0).CGColor
            cell.interestFrame.backgroundColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: InterestViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestViewCell
        
        if selected.contains(intObject[indexPath.row]) {
            selected.remove(intObject[indexPath.row])
            
            // Change cell appearance to Deselected
            cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.interestImage.tintColor = UIColor.blackColor()
            cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
            cell.interestFrame.backgroundColor = UIColor.clearColor()
            
            print(selected)
        }
    }
}

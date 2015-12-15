//
//  UserMenuViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/10/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class UserMenuViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var interest = Set<PFObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.registerNib(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        
        var currentUser = PFUser.currentUser()
        if currentUser?["approve"] as? String == "yes" {
            print("Success")
            var interestQuery = PFQuery(className: "Interest")
            
            interestQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects as? [PFObject]! {
                        for object in objects {
                            self.interest.insert(object)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var currentUser = PFUser.currentUser()
        
        if currentUser?["approve"] as? String == "yes" {
            return 5
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentUser = PFUser.currentUser()
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "UserM")
            if (currentUser?["gender"] as? String) == "F" {
                cell.icon.image = UIImage(named: "UserF")
            }
            cell.titleLabel.text = "User Details"
            cell.countFrame.hidden = true
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "Love")
            cell.titleLabel.text = "Interests"
            cell.countFrame.hidden = true
            
            if let user = currentUser {
                let query = PFQuery(className: "UserInterest")
                query.whereKey("userId", equalTo: user)
                query.whereKey("level", greaterThan: 0)
                query.findObjectsInBackgroundWithBlock{
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let objects = objects {
                            cell.count.text = "\(objects.count)"
                            if cell.count.text != "0" {
                                cell.countFrame.hidden = false
                            }
                        }
                    }
                }
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            if currentUser?["approve"] as? String == "yes" {
                var cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
                
                cell.icon.image = UIImage(named: "event")
                cell.titleLabel.text = "Calculate Interest"
                cell.countFrame.hidden = true
                cell.arrow.hidden = true
                
                return cell
            } else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "blank")
            cell.titleLabel.text = ""
            cell.countFrame.hidden = true
            cell.arrow.hidden = true
                
                return cell
            }
            
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "direction")
            cell.titleLabel.text = "Sort Interest"
            cell.countFrame.hidden = true
            cell.arrow.hidden = true
            
            return cell
            
        case 4:
            var cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "blank")
            cell.titleLabel.text = ""
            cell.countFrame.hidden = true
            cell.arrow.hidden = true
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserMenuCell
            
            cell.menuLabel.text = ""
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var currentUser = PFUser.currentUser()
        
        
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("menuToDetail", sender: self)
        case 1:
            self.performSegueWithIdentifier("menuToInterest", sender: self)
        case 2:
            if currentUser?["approve"] as? String == "yes" {
                var userIntQuery = PFQuery(className: "UserInterest")
                userIntQuery.includeKey("interestId")
                userIntQuery.limit = 1000
                
                var intLevelQuery = PFQuery(className: "InterestLevel")
                intLevelQuery.includeKey("interestId")
                intLevelQuery.limit = 1000
                
                for object in interest {
                    
                    object["Level"] = 0
                }
                
                userIntQuery.findObjectsInBackgroundWithBlock {
                    (iObjects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        print("Updating Interest Levels")
                        if let iObjects = iObjects as? [PFObject]! {
                            for iObject in iObjects {
                                var intObj = iObject["interestId"] as! PFObject
                                for interestObj in self.interest {
                                    if interestObj == intObj {
                                        interestObj["Level"] = (interestObj["Level"] as! Int) + (iObject["level"] as! Int)
                                    }
                                }
                            }
                            
                            intLevelQuery.findObjectsInBackgroundWithBlock {
                                (lvlObjects: [PFObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    if let lvlObjects = lvlObjects as? [PFObject]! {
                                        for lvlObject in lvlObjects {
                                            var lvlObj = lvlObject["interestId"] as! PFObject
                                            
                                            for interestObj in self.interest {
                                                if interestObj == lvlObj {
                                                    interestObj.incrementKey("Level", byAmount: (lvlObject["level"] as! NSNumber))
                                                    
                                                }
                                            }
                                        }
                                        
                                        for interestObj in self.interest {
                                            print(interestObj["Level"])
                                            interestObj.saveEventually()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("Invalid selection")
            }
        case 3:
            if currentUser?["approve"] as? String == "yes" {
                var interestQuery = PFQuery(className: "Interest")
                interestQuery.orderByDescending("Level")
                
                var reportQuery = PFQuery(className: "InterestReport")
                reportQuery.findObjectsInBackgroundWithBlock {
                    (rObjects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let rObjects = rObjects as? [PFObject]! {
                            for rObject in rObjects {
                                rObject.deleteEventually()
                            }
                            
                            interestQuery.findObjectsInBackgroundWithBlock {
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    if let objects = objects as? [PFObject]! {
                                        var count = 0
                                        var total = 0
                                        for object in objects {
                                            
                                            var interestLevel = object["Level"] as! Int
                                            
                                            if count >= 8 {
                                                total += interestLevel
                                                
                                            } else {
                                                
                                                let reportData = PFObject(className: "InterestReport")
                                                reportData["Level"] = count
                                                reportData["InterestName"] = object["name"]
                                                reportData["Weightage"] = interestLevel
                                                reportData.saveEventually()
                                                print(count)
                                                print(reportData["InterestName"])
                                                print(reportData["Weightage"])
                                                
                                            }
                                            
                                            count++
                                        }
                                        
                                        let othersData = PFObject(className: "InterestReport")
                                        othersData["Level"] = count
                                        othersData["InterestName"] = "Others"
                                        othersData["Weightage"] = total
                                        othersData.saveEventually()
                                        
                                        print(count)
                                        print(othersData["InterestName"])
                                        print(othersData["Weightage"])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        default:
            print("Invalid selection", terminator: "")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "interestToEditor" {
            let interestScene = segue.destinationViewController as! InterestViewController
            
            interestScene.type = 1
        }
    }
}
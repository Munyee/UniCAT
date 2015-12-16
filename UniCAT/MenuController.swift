//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 24/6/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class MenuController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //var eventList = 1
    var eventList = NSUserDefaults.standardUserDefaults().boolForKey("eventToggle")
    var interestNo = NSUserDefaults.standardUserDefaults().integerForKey("interestNo")
    var eventInterestNo = NSUserDefaults.standardUserDefaults().integerForKey("eventInterestNo")
    var favouriteNo = NSUserDefaults.standardUserDefaults().integerForKey("favouriteNo")
    
    var mapList = NSUserDefaults.standardUserDefaults().boolForKey("eventToggleMap")
    
    var currentObject: PFObject?
    var selection = 0
    
    @IBAction func eventToggleMap(sender: AnyObject) {
        if !mapList {
            mapList = true
            //cell.toggleImage.image = UIImage(named:"Collapse") //Change to rotate animation
        } else {
            mapList = false
            //cell.toggleImage.image = UIImage(named:"Expand") //Change to rotate animation
        }
        
        NSUserDefaults.standardUserDefaults().setBool(mapList, forKey: "eventToggleMap")
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func eventToggle(sender: AnyObject) {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Main") as! MainTableViewCell

        if !eventList {
            eventList = true
            //cell.toggleImage.image = UIImage(named:"Collapse") //Change to rotate animation
        } else {
            eventList = false
            //cell.toggleImage.image = UIImage(named:"Expand") //Change to rotate animation
        }
        
        NSUserDefaults.standardUserDefaults().setBool(eventList, forKey: "eventToggle")
        NSUserDefaults.standardUserDefaults().synchronize()

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        interestNo = NSUserDefaults.standardUserDefaults().integerForKey("interestNo")
        eventInterestNo = NSUserDefaults.standardUserDefaults().integerForKey("eventInterestNo")
        favouriteNo = NSUserDefaults.standardUserDefaults().integerForKey("favouriteNo")
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let currentUser = PFUser.currentUser()
        
        if indexPath.row == 7 || indexPath.row == 4 {
            if currentUser == nil {
                return 0.0
            }
        }
        
        if !eventList && !mapList{
            switch indexPath.row {
            case 0:
                return 100.0
            case 2, 4, 5, 6, 7:
                return 0.0
            default:
                return 50.0
            }
            
        } else if !eventList && mapList{
            switch indexPath.row {
            case 0:
                return 100.0
            case 4, 5, 6, 7:
                return 0.0
            default:
                return 50.0
            }
        } else if eventList && !mapList{
            switch indexPath.row {
            case 0:
                return 100.0
            case 2:
                return 0.0
            default:
                return 50.0
            }
        }
            
            
        else{
            switch indexPath.row {
            case 0:
                return 100.0
            case 2, 4, 5, 6, 7:
                return 50.0
            default:
                return 50.0
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            let currentUser = PFUser.currentUser()
            
            if currentUser != nil {
                self.performSegueWithIdentifier("menuToProfile", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") 
                self.presentViewController(vc, animated: true, completion: nil)
            }
        case 1:
            self.performSegueWithIdentifier("menuToMap", sender: self)
        case 2:
            break
        case 3: // Event
            selection = 0
            self.performSegueWithIdentifier("menuToEvent", sender: self)
        case 4: // Favourite
            selection = 1
            self.performSegueWithIdentifier("menuToEvent", sender: self)
        case 5: // All Event
            selection = 2
            self.performSegueWithIdentifier("menuToEvent", sender: self)
        case 6: // Past Event
            selection = 3
            self.performSegueWithIdentifier("menuToEvent", sender: self)
        case 7: // Add Event
            selection = 4
            self.performSegueWithIdentifier("menuToEvent", sender: self)
        case 8: //Food
            self.performSegueWithIdentifier("menuToFood", sender: self)
        case 9: // Give Feedback
            let currentUser = PFUser.currentUser()
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            if currentUser != nil {
                let userId = currentUser?["username"] as? String
                picker.setSubject("Feedback for UniCAT (" + userId! + ")")
            } else {
                picker.setSubject("Feedback for UniCAT")
            }
            picker.setMessageBody("This is a feedback email for UniCAT:", isHTML: true)
            picker.setToRecipients(["gxlye@me.com"])
            
            presentViewController(picker, animated: true, completion: nil)
        default:
            print("Invalid selection")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") 
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentUser = PFUser.currentUser()
        
        
        switch indexPath.row {
        case 0:
            let profile = tableView.dequeueReusableCellWithIdentifier("Profile", forIndexPath: indexPath) as! ProfileTableViewCell
            
            profile.interestCount.text = "-"
            profile.contCount.text = "-"
            
            profile.commentFrame.hidden = true
            profile.contCount.hidden = true
            
            if currentUser != nil {
                if let user = currentUser {
                    
                    profile.profilePic.file = user["image"] as? PFFile
                    profile.profilePic.loadInBackground()
                    profile.userName.text = user["email"] as? String
                    
                    if interestNo != 0 {
                        profile.interestCount.text = "Interests: \(interestNo)"
                    }
                    
                    if eventInterestNo != 0 {
                        profile.contCount.text = "\(eventInterestNo)"
                    }
                    
                    let query = PFQuery(className: "UserInterest")
                    query.whereKey("userId", equalTo: user)
                    query.whereKey("level", greaterThan: 0)
                    query.findObjectsInBackgroundWithBlock{
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            if let objects = objects {
                                profile.interestCount.text = "Interests: \(objects.count)"
                                NSUserDefaults.standardUserDefaults().setInteger(objects.count, forKey: "interestNo")
                                NSUserDefaults.standardUserDefaults().synchronize()
                            }
                        }
                    }
                    
                    let query2 = PFQuery(className: "InterestLevel")
                    query2.whereKey("userId", equalTo: user)
                    query2.whereKey("level", notEqualTo: -1)
                    query2.findObjectsInBackgroundWithBlock{
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            if let objects = objects {
                                profile.contCount.text = "\(objects.count)"
                                NSUserDefaults.standardUserDefaults().setInteger(objects.count, forKey: "eventInterestNo")
                                NSUserDefaults.standardUserDefaults().synchronize()
                            }
                        }
                    }
                }
            } else {
                profile.userName.text = "Welcome to UTAR"
            }
            
            return profile
        case 1:
            let main = tableView.dequeueReusableCellWithIdentifier("Main1", forIndexPath: indexPath) as! MainTableViewCell
            main.mainLabel.text = "MAP"
            return main
        case 2:
            let sub = tableView.dequeueReusableCellWithIdentifier("Sub", forIndexPath: indexPath) as! SubTableViewCell
            sub.subLabel.text = "QR SCANNER"
            sub.countFrame.hidden = true
            
            return sub
        case 3:
            let main = tableView.dequeueReusableCellWithIdentifier("Main", forIndexPath: indexPath) as! MainTableViewCell
            main.mainLabel.text = "EVENT"
            
            return main
        case 4:
            let sub = tableView.dequeueReusableCellWithIdentifier("Sub", forIndexPath: indexPath) as! SubTableViewCell
            sub.subLabel.text = "FAVOURITE"
            if let user = currentUser {
                if favouriteNo != 0 {
                    sub.countFrame.hidden = false
                    sub.countNo.text = "\(favouriteNo)"
                } else {
                    sub.countFrame.hidden = true
                }
                
                let query = PFQuery(className: "EventAttendance")
                query.whereKey("userId", equalTo: user)
                query.whereKey("type", notEqualTo: "no")
                query.findObjectsInBackgroundWithBlock{
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let objects = objects {
                            sub.countFrame.hidden = false
                            sub.countNo.text = "\(objects.count)"
                            NSUserDefaults.standardUserDefaults().setInteger(objects.count, forKey: "favouriteNo")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                    }
                }
            }
            
            return sub
        case 5:
            let sub = tableView.dequeueReusableCellWithIdentifier("Sub", forIndexPath: indexPath) as! SubTableViewCell
            sub.subLabel.text = "ALL EVENT"
            sub.countFrame.hidden = true
            
            return sub
        case 6:
            let sub = tableView.dequeueReusableCellWithIdentifier("Sub", forIndexPath: indexPath) as! SubTableViewCell
            sub.subLabel.text = "PAST EVENT"
            sub.countFrame.hidden = true
            
            return sub
        case 7:
            let sub = tableView.dequeueReusableCellWithIdentifier("Sub", forIndexPath: indexPath) as! SubTableViewCell
            sub.subLabel.text = "ADD EVENT"
            sub.countFrame.hidden = true
            
            return sub
        case 8:
            let normal = tableView.dequeueReusableCellWithIdentifier("Normal", forIndexPath: indexPath) as! MenuTableViewCell
            normal.menuLabel.text = "FOOD"
            return normal
        case 9:
            let normal = tableView.dequeueReusableCellWithIdentifier("Normal", forIndexPath: indexPath) as! MenuTableViewCell
            normal.menuLabel.text = "FEEDBACK"
            return normal
        case 10:
            let login = tableView.dequeueReusableCellWithIdentifier("Login", forIndexPath: indexPath) as! MenuTableViewCell
            
            if currentUser == nil {
                login.menuLabel.text = "LOGIN/REGISTER"
            } else {
                login.menuLabel.text = "LOG OUT"
            }
            
            return login
        default:
            let normal = tableView.dequeueReusableCellWithIdentifier("Normal", forIndexPath: indexPath) as! MenuTableViewCell
            
            normal.menuLabel.text = "UNICAT"
            return normal
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "menuToEvent" {
            let nav = segue.destinationViewController as! UINavigationController
            let detailScene = nav.topViewController as! EventsTableViewController
            
            detailScene.selection = selection
        }
    }

}

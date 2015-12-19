//
//  DetailTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/28/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    let building = Building()
    var currentObject: PFObject?
    var currentUser = PFUser.currentUser()
    var subevent = 0
    var buildingInitial = ""
    var venue = ""
    var attendance = ""
    var attendPath: NSIndexPath?
    var interest = Set<PFObject>()
    
    var editorRole = false
    var going = 0
    var maybe = 0
    var notInterested = 0
    
    @IBOutlet weak var coverPhoto: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Self-sizing Cells
        tableView.estimatedRowHeight = 50.0;
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        if let object = currentObject {
            let initialThumbnail = UIImage(named: "placeholder")
            coverPhoto.image = initialThumbnail
            
            if let thumbnail = object["cover"] as? PFFile {
                coverPhoto.file = thumbnail
                coverPhoto.loadInBackground()
            }
            
            if object["hasSubevent"] as? String == "Yes" {
                subevent = 1
            } else {
                subevent = 0
            }
            
            if currentUser != nil {
                // Track user - Event accessed
                updateEventView("visit")
                
                // Check if user is EventPlanner
                if currentUser?["approve"] as? String == "yes" {
                    editorRole = true
                    
                    // Query Attendance Data
                    let attendQuery = PFQuery(className: "EventAttendance")
                    attendQuery.whereKey("eventId", equalTo: currentObject!)
                    attendQuery.findObjectsInBackgroundWithBlock{
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            if let objects = objects {
                                print(objects.count)
                                for object in objects {
                                    if object["type"] as? String == "yes" {
                                        self.going++
                                    } else if object["type"] as? String == "no" {
                                        self.notInterested++
                                    } else if object["type"] as? String == "maybe" {
                                        self.maybe++
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Check Attendance
                let attendQuery = PFQuery(className: "EventAttendance")
                attendQuery.whereKey("userId", equalTo: currentUser!)
                attendQuery.whereKey("eventId", equalTo: currentObject!)
                attendQuery.getFirstObjectInBackgroundWithBlock{
                    (object: PFObject?, error: NSError?) -> Void in
                    
                    if let obj = object {
                        self.attendance = obj["type"] as! String
                    }
                }
            }
        }
        
        // Get Event Interests
        let eventQuery = PFQuery(className: "EventInterest")
        eventQuery.whereKey("eventId", equalTo: currentObject!)
        eventQuery.includeKey("interestId")
        
        eventQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let intObj = object["interestId"] as! PFObject
                        self.interest.insert(intObj)
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let object = currentObject {
            switch indexPath.row {
            case 0:
                let info = tableView.dequeueReusableCellWithIdentifier("info", forIndexPath: indexPath) as! InfoTableViewCell
                
                info.eventName.text = object["name"] as? String
                info.eventSubtitle.text = object["subtitle"] as? String
                
                if let startDate = object["startDate"] as? NSDate {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd/MM"
                    
                    let timeFormatter = NSDateFormatter()
                    timeFormatter.dateFormat = "h:mm a"
                    
                    let endDate = object["endDate"] as? NSDate
                    
                    let strDate = dateFormatter.stringFromDate(startDate)
                    let enDate = dateFormatter.stringFromDate(endDate!)
                    let strTime = timeFormatter.stringFromDate(startDate)
                    var enTime = timeFormatter.stringFromDate(endDate!)
                    
                    if strDate == enDate {
                        info.eventDate.text = strDate + " (\(strTime))"
                    } else {
                        info.eventDate.text = strDate + " - " + enDate
                    }
                }
                
                if let eventVenue = object["venue"] as? String {
                    venue = eventVenue
                    info.eventVenue.text = building.buildingName(room: venue) + " (\(venue))"
                }
                
                return info
            case 1:
                let text = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as! TextTableViewCell
                
                text.detail.text = object["description"] as? String
                
                return text
            case 2:
                if let phone = object["tel"] as? String {
                    
                    let tel = tableView.dequeueReusableCellWithIdentifier("tel", forIndexPath: indexPath) as! TelTableViewCell
                    
                    tel.telNo.text = object["telName"] as? String
                    tel.telephone = phone
                    
                    return tel
                }
                
            case 3:
                if let link = object["fb"] as? String {
                    
                    let fb = tableView.dequeueReusableCellWithIdentifier("fb", forIndexPath: indexPath) as! FbTableViewCell
                    
                    if link == "http://facebook.com/" {
                        fb.facebook.text = "Not Available"
                        fb.link = ""
                    } else {
                        fb.link = link
                    }
                    
                    return fb
                }
                
            case 4:
                if currentUser != nil {
                    let attend = tableView.dequeueReusableCellWithIdentifier("attendance", forIndexPath: indexPath) as! AttendTableViewCell
                    
                    attend.goingButton.addTarget(self, action: "goingButton:", forControlEvents: UIControlEvents.TouchUpInside)
                    attend.maybeButton.addTarget(self, action: "maybeButton:", forControlEvents: UIControlEvents.TouchUpInside)
                    attend.notInterestedButton.addTarget(self, action: "notInterestedButton:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    if attendance == "yes" {
                        attend.maybeButton.backgroundColor = UIColor.grayColor()
                        attend.notInterestedButton.backgroundColor = UIColor.grayColor()
                    } else if attendance == "maybe" {
                        attend.goingButton.backgroundColor = UIColor.grayColor()
                        attend.notInterestedButton.backgroundColor = UIColor.grayColor()
                    } else if attendance == "no" {
                        attend.maybeButton.backgroundColor = UIColor.grayColor()
                        attend.goingButton.backgroundColor = UIColor.grayColor()
                    }
                    
                    if editorRole {
                        if going != 0 {attend.goingButton.setTitle("\(going)", forState: .Normal)}
                        if maybe != 0 {attend.maybeButton.setTitle("\(maybe)", forState: .Normal)}
                        if notInterested != 0 {attend.notInterestedButton.setTitle("\(notInterested)", forState: .Normal)}
                    }
                    
                    attendPath = indexPath
                    
                    return attend
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("tel", forIndexPath: indexPath) as! TelTableViewCell
                    
                    cell.telNo.text = ""
                    cell.telThumb.image = UIImage(named: "blank")
                    
                    return cell
                }
                
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("tel", forIndexPath: indexPath) as! TelTableViewCell
                
                cell.telNo.text = ""
                cell.telThumb.image = UIImage(named: "blank")
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tel", forIndexPath: indexPath) as! TelTableViewCell
        
        cell.telNo.text = ""
        cell.telThumb.image = UIImage(named: "blank")
        
        return cell
    }
    
    func updateEventView(type:String) {
        if currentUser != nil {
            let eventView = PFObject(className: "EventView")
            
            eventView["type"] = type
            eventView.setObject(currentUser!, forKey: "userId")
            eventView.setObject(currentObject!, forKey: "eventId")
            eventView.saveEventually()
            
        }
    }
    
    func updateAttendButton(type:String) {
        let attend: AttendTableViewCell = tableView.cellForRowAtIndexPath(attendPath!) as! AttendTableViewCell
        
        attend.goingButton.backgroundColor = UIColor.grayColor()
        attend.maybeButton.backgroundColor = UIColor.grayColor()
        attend.notInterestedButton.backgroundColor = UIColor.grayColor()
        
        switch type {
        case "yes":
            attend.goingButton.backgroundColor = UIColor(red: 34/255.0, green: 192/255.0, blue: 100/255.0, alpha: 1.0)
        case "no":
            attend.notInterestedButton.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 1.0)
        case "maybe":
            attend.maybeButton.backgroundColor = UIColor(red: 55/255.0, green: 128/255.0, blue: 186/255.0, alpha: 1.0)
        default:
            print("Invalid selection")
        }
    }
    
    func updateInterestLevel(amount:Int) {
        let today = NSDate()
        
        if currentUser != nil && interest.count > 0 {
            for object in interest {
                let interestLevel = PFObject(className: "InterestLevel")
                
                interestLevel["level"] = amount
                interestLevel["date"] = today
                interestLevel.setObject(currentUser!, forKey: "userId")
                interestLevel.setObject(object, forKey: "interestId")
                interestLevel.saveEventually()
            }
        }
    }
    
    func goingButton(sender:UIButton) {
        let query = PFQuery(className: "EventAttendance")
        query.whereKey("eventId", equalTo: currentObject!)
        query.whereKey("userId", equalTo: currentUser!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    if(objects.count == 0)
                    {
                        let newAttend = PFObject(className: "EventAttendance")
                        newAttend["eventId"] = self.currentObject
                        newAttend["userId"] = self.currentUser
                        newAttend["type"] = "yes"
                        newAttend.saveEventually()
                    }
                    for object in objects {
                        let idquery = PFQuery(className:"EventAttendance")
                        idquery.getObjectInBackgroundWithId(object.objectId!) {
                            (objectid: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                print(error)
                            } else if let newAttend = objectid {
                                newAttend["eventId"] = self.currentObject
                                newAttend["userId"] = self.currentUser
                                newAttend["type"] = "yes"
                                newAttend.saveEventually()
                            }
                        }
                        
//                        object.deleteInBackground()
//                        let newAttend = PFObject(className: "EventAttendance")
//                        
//                        newAttend["eventId"] = self.currentObject
//                        newAttend["userId"] = self.currentUser
//                        newAttend["type"] = "yes"
//                        newAttend.saveEventually()
//                        
                    }
                }
                
            }
        }
        
        updateAttendButton("yes")
        updateEventView("rate")
        updateInterestLevel(2)
    }
    
    func maybeButton(sender:UIButton) {
        let query = PFQuery(className: "EventAttendance")
        query.whereKey("eventId", equalTo: currentObject!)
        query.whereKey("userId", equalTo: currentUser!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    if(objects.count == 0)
                    {
                        let newAttend = PFObject(className: "EventAttendance")
                        newAttend["eventId"] = self.currentObject
                        newAttend["userId"] = self.currentUser
                        newAttend["type"] = "maybe"
                        newAttend.saveEventually()
                    }
                    for object in objects {
                        let idquery = PFQuery(className:"EventAttendance")
                        idquery.getObjectInBackgroundWithId(object.objectId!) {
                            (objectid: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                print(error)
                            } else if let newAttend = objectid {
                                newAttend["eventId"] = self.currentObject
                                newAttend["userId"] = self.currentUser
                                newAttend["type"] = "maybe"
                                newAttend.saveEventually()
                            }
                        }

//                        object.deleteInBackground()
//                        let newAttend = PFObject(className: "EventAttendance")
//                        
//                        newAttend["eventId"] = self.currentObject
//                        newAttend["userId"] = self.currentUser
//                        newAttend["type"] = "maybe"
//                        newAttend.saveEventually()
                    }
                }
                
            }
        }
        
        updateAttendButton("maybe")
        updateEventView("rate")
        updateInterestLevel(1)
    }
    
    func notInterestedButton(sender:UIButton) {
        let query = PFQuery(className: "EventAttendance")
        query.whereKey("eventId", equalTo: currentObject!)
        query.whereKey("userId", equalTo: currentUser!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    if(objects.count == 0)
                    {
                        let newAttend = PFObject(className: "EventAttendance")
                        newAttend["eventId"] = self.currentObject
                        newAttend["userId"] = self.currentUser
                        newAttend["type"] = "no"
                        newAttend.saveEventually()
                    }
                    for object in objects {
                        let idquery = PFQuery(className:"EventAttendance")
                        idquery.getObjectInBackgroundWithId(object.objectId!) {
                            (objectid: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                print(error)
                            } else if let newAttend = objectid {
                                newAttend["eventId"] = self.currentObject
                                newAttend["userId"] = self.currentUser
                                newAttend["type"] = "no"
                                newAttend.saveEventually()
                            }
                        }
//
//                        let newAttend = PFObject(className: "EventAttendance")
//                        
//                        newAttend["eventId"] = self.currentObject
//                        newAttend["userId"] = self.currentUser
//                        newAttend["type"] = "no"
//                        newAttend.saveEventually()
                    }
                }
                
                
            }
        }
        
        updateAttendButton("no")
        updateEventView("rate")
        updateInterestLevel(-1)
    }

    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let editAction = UIAlertAction(title: "Edit Event", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Edit Event")
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("eventDetailToEventEditor", sender: self)
            }
        })
        
        let subeventAction = UIAlertAction(title: "Show Subevents", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Show subevents")
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("eventDetailToSubevent", sender: self)
            }
        })
        
        let shareAction = UIAlertAction(title: "Share Event", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Launch Share")
            
            let link = self.currentObject?["fb"] as? String
            let name = self.currentObject?["name"] as? String
            let subtitle = self.currentObject?["subtitle"] as? String
            
            let textToShare = "\(name!) - \(subtitle!)"
            
            if let myWebsite = NSURL(string: "\(link!)")
            {
                let objectsToShare = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
                
                self.updateEventView("share")
            }
            
        })
        
        let reportAction = UIAlertAction(title: "Report Event", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Record fraud report")
            var reportNo = self.currentObject?["report"] as! Int
            reportNo++
            self.currentObject?["report"] = reportNo
            self.currentObject?.saveEventually()
            
            let alertView = UIAlertController(title: "Report Event", message: "Report Received.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
            print("Cancelled")
        })
        
        if currentUser != nil && editorRole {
            optionMenu.addAction(editAction)
        }
        
        if subevent != 0 {
            optionMenu.addAction(subeventAction)
        }
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }

    @IBAction func venueButton(sender: AnyObject) {
        buildingInitial = building.buildingInitial(venue)
        
        self.performSegueWithIdentifier("eventToMap", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "eventDetailToSubevent" {
            let subeventScene = segue.destinationViewController as! SubEventsTableViewController
            
            subeventScene.currentObject = currentObject
        } else if segue.identifier == "eventToMap" {
            let buildingScene = segue.destinationViewController as! BuildingViewController
            
            buildingScene.currentAlphabet = buildingInitial
            buildingScene.currentBuilding = building.buildingName(room: buildingInitial)
            buildingScene.eventCount = "o"
        } else if segue.identifier == "eventToInterest" {
            let interestScene = segue.destinationViewController as! InterestViewController
            
            interestScene.eventObject = currentObject
            interestScene.type = 0
            interestScene.editorRole = editorRole
        } else {
            let nav = segue.destinationViewController as! UINavigationController
            let editorScene = nav.topViewController as! EditorTableViewController
            
            editorScene.currentObject = currentObject
        }
    }
    
}

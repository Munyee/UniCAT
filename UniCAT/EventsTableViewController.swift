//
//  EventsTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/15/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class EventsTableViewController: PFQueryTableViewController,RefreshViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var typeButton: UIButton!
    
    let building = Building()
    var typeName = ["Events", "Past Events", "Favourite"]
    var selectedBuilding = ""
    var selection = 0
    var attendObj: [PFObject] = []
    var recommendObj: [PFObject] = []
    var editableObjects: NSMutableArray = NSMutableArray()
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "Event"
        self.textKey = "name"
        
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Event")
        let today = NSDate()
        
        /*var currentUser = PFUser.currentUser()
        var role = "" // 1- Staff/Student; 2- Visitor/Parents; 3- Event Planner
        
        if currentUser != nil {
            role = currentUser?["role"] as! String
        }*/
        
        switch selection {
        case 0, 4:
            query.whereKey("endDate", greaterThanOrEqualTo: today)
            query.orderByAscending("startDate")
        case 2: // Favourite - Events Attending/Maybe
            let currentUser = PFUser.currentUser()
            let query2 = PFQuery(className:"EventAttendance")
            
            query2.whereKey("userId", equalTo: currentUser!)
            query2.whereKey("type", notEqualTo: "no")
            query2.includeKey("eventId")
            query2.orderByDescending("updatedAt")
            
            return query2
            /*query.whereKey("objectId", matchesKey:"eventId", inQuery:query2)
            query.whereKey("endDate", greaterThanOrEqualTo: today)
            query.orderByAscending("startDate")*/
//        case 2: // All Event
//            query.whereKey("endDate", greaterThanOrEqualTo: today)
//            query.orderByAscending("startDate")
        case 1: // Past Event
            query.whereKey("endDate", lessThan: today)
            query.orderByDescending("startDate")
        case 5: // From Map
            let predicate = NSPredicate(format: "venue BEGINSWITH %@ OR venue BEGINSWITH 'U'", selectedBuilding)
            let query2 = PFQuery(className: "Event", predicate: predicate)
            query2.whereKey("endDate", greaterThanOrEqualTo: today)
            query2.orderByAscending("startDate")
            
            return query2
        case 6: // From Map (Past Event)
            let predicate = NSPredicate(format: "venue BEGINSWITH %@ OR venue BEGINSWITH 'U'", selectedBuilding)
            let query2 = PFQuery(className: "Event", predicate: predicate)
            query2.whereKey("startDate", lessThan: today)
            query2.orderByDescending("startDate")
            
            return query2
        default:
            query.whereKey("endDate", greaterThanOrEqualTo: today)
            query.orderByAscending("startDate")
        }
        
        return query
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if selection == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func objectsDidLoad(error: NSError!) {
        
        if(PFUser.currentUser() == nil){
            typeName = ["Events", "Past Events"]
        }
        else{
            typeName = ["Events", "Past Events", "Favourite"]
        }
        self.loadObjects()
        super.objectsDidLoad(error)
        editableObjects = NSMutableArray(array: self.objects!)
        self.tableView?.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject? {
        let object = self.editableObjects.objectAtIndex(indexPath.row) as! PFObject
        return object
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.editableObjects.count == 0 {
            let count = self.objects?.count
            return count!
        }
        
        let numberOfRows = self.editableObjects.count
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if selection == 1 {
            if (editingStyle == UITableViewCellEditingStyle.Delete) {
                let deleteObj = objects?[indexPath.row] as! PFObject
                self.editableObjects.removeObjectAtIndex(indexPath.row)
                
                // Adjust Interest level if Suggested events is removed
                if (deleteObj["type"] as? String) == "suggest" {
                    let today = NSDate()
                    let currentUser = PFUser.currentUser()
                    var interest = Set<PFObject>()
                    
                    // Get Event Interests
                    let eventQuery = PFQuery(className: "EventInterest")
                    eventQuery.whereKey("eventId", equalTo: deleteObj["eventId"]!)
                    eventQuery.includeKey("interestId")
                    
                    eventQuery.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            if let objects = objects {
                                for object in objects {
                                    let intObj = object["interestId"] as! PFObject
                                    interest.insert(intObj)
                                }
                            }
                            
                            if interest.count > 0 {
                                for object in interest {
                                    let interestLevel = PFObject(className: "InterestLevel")
                                    
                                    interestLevel["level"] = -1
                                    interestLevel["date"] = today
                                    interestLevel.setObject(currentUser!, forKey: "userId")
                                    interestLevel.setObject(object, forKey: "interestId")
                                    interestLevel.saveEventually()
                                }
                            }
                        }
                    }
                    
                    
                }
                
                deleteObj["type"] = "no"
                deleteObj.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.loadObjects()
                        
                        //tableView.reloadData()
                        //tableView.beginUpdates()
                        //tableView.endUpdates()
                    }
                }
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier:String = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EventsTableViewCell
        
        // Favourite tab
        if selection == 2 {
            if let pfObject = object {
                let eventObj = pfObject["eventId"] as? PFObject
                
                if let event = eventObj {
                    cell.titleLabel?.text = event["name"] as? String
                    cell.subtitleLabel?.text = event["subtitle"] as? String
                    cell.venueLabel?.text = building.buildingName(room: event["venue"] as! String)
                    
                    if let startDate = event["startDate"] as? NSDate {
                        let dateFormatter = NSDateFormatter()
                        let today = NSDate()
                        dateFormatter.dateFormat = "EEE, dd/MM"
                        
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.dateFormat = "h:mm a"
                        
                        let endDate = event["endDate"] as? NSDate
                        
                        if startDate.compare(today) == NSComparisonResult.OrderedAscending && endDate?.compare(today) == NSComparisonResult.OrderedDescending {
                            cell.dateLabel.text = "Now"
                        } else {
                            let strDate = dateFormatter.stringFromDate(startDate)
                            
                            cell.dateLabel.text = strDate
                        }
                        
                        let strTime = timeFormatter.stringFromDate(startDate)
                        cell.timeLabel.text = strTime
                        
                        // Set Attendance Tag
                        switch pfObject["type"] as! String {
                        case "suggest":
                            cell.attendTag.image = UIImage(named:"Suggestion")
                        case "yes":
                            if endDate?.compare(today) == NSComparisonResult.OrderedAscending {
                                cell.attendTag.image = UIImage(named: "Went")
                            } else {
                                cell.attendTag.image = UIImage(named: "Going")
                            }
                        case "no":
                            cell.attendTag.image = UIImage(named: "Nope")
                        case "maybe":
                            cell.attendTag.image = UIImage(named: "Maybe")
                        default:
                            cell.attendTag.hidden = true
                        }
                    }
                    
                    // Display cover image
                    let initialThumbnail = UIImage(named: "placeholder")
                    cell.coverImage.image = initialThumbnail
                    
                    if let thumbnail = event["cover"] as? PFFile {
                        cell.coverImage.file = thumbnail
                        cell.coverImage.loadInBackground()
                    }
                    
                    return cell
                }
            }
        }
        
        if let pfObject = object {
            cell.titleLabel?.text = pfObject["name"] as? String
        }
        
        if let description = object?["subtitle"] as? String {
            cell.subtitleLabel?.text = description
        }
        
        if let venue = object?["venue"] as? String {
            cell.venueLabel?.text = building.buildingName(room: venue)
        }
        
        if let startDate = object?["startDate"] as? NSDate {
            let dateFormatter = NSDateFormatter()
            let today = NSDate()
            dateFormatter.dateFormat = "EEE, dd/MM"
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let endDate = object?["endDate"] as? NSDate
            
            if startDate.compare(today) == NSComparisonResult.OrderedAscending && endDate?.compare(today) == NSComparisonResult.OrderedDescending {
                cell.dateLabel.text = "Now"
            } else {
                let strDate = dateFormatter.stringFromDate(startDate)
            
                cell.dateLabel.text = strDate
            }
            
            let strTime = timeFormatter.stringFromDate(startDate)
            cell.timeLabel.text = strTime
        }
        
        // Display cover image
        let initialThumbnail = UIImage(named: "placeholder")
        cell.coverImage.image = initialThumbnail
        
        if let thumbnail = object?["cover"] as? PFFile {
            cell.coverImage.file = thumbnail
            cell.coverImage.loadInBackground()
        }
        
        cell.attendTag.hidden = true
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        if selection != 5 && selection != 6 {
            if self.revealViewController() != nil {
                menuButton.target = self.revealViewController()
                menuButton.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        switch selection {
        case 0:
            self.navigationItem.title = "Event"
        case 1:
            self.navigationItem.title = "Favourite"
        case 2:
            self.navigationItem.title = "All Event"
        case 3:
            self.navigationItem.title = "Past Event"
        case 5:
            if selectedBuilding == "U" {
                self.navigationItem.title = "Campus-wide Event"
            } else {
                self.navigationItem.title = "Event in Block \(selectedBuilding)"
            }
        case 6:
            if selectedBuilding == "U" {
                self.navigationItem.title = "Past Campus-wide Event"
            } else {
                self.navigationItem.title = "Past Event in Block \(selectedBuilding)"
            }
        default:
            self.navigationItem.title = "Event"
        }
        
        if selection == 4 {
            selection = 0
            performSegueWithIdentifier("eventListToEventEditor", sender: self)
        }
    }
    
    func backButton(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    @IBAction func backToMap(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
        println("Back to Building detail")
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        tableView.reloadData()
    }
    
    
    @IBAction func backToMap(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func chooseType(sender: AnyObject) {
        self.performSegueWithIdentifier("pickerView", sender: self)
    }
    
    @IBAction func add(sender: AnyObject) {
        /*var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            performSegueWithIdentifier("eventListToEventEditor", sender: self)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }*/
        
        print("Launch QR Scanner")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "eventListToEventDetail" {
            let detailScene = segue.destinationViewController as! DetailTableViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                if selection == 2 {
                    let favObj = (objects?[row] as! PFObject)
                    let eventObj = favObj["eventId"] as? PFObject
                    detailScene.currentObject = eventObj
                } else {
                    detailScene.currentObject = (objects?[row] as! PFObject)
                }
            }
        }
        else if segue.identifier == "pickerView" {
            let pickerScene = segue.destinationViewController as! PickerViewController

            pickerScene.type = selection
            pickerScene.refreshDelegate = self
        }
    }
    
    func updateClass(classType: Int) {
        selection = classType
        
        typeButton.setTitle(typeName[selection], forState: UIControlState.Normal)
        
        self.clear()
        self.loadObjects()
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

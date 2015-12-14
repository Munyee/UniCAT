//
//  SubEventsTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/2/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation


import UIKit

class SubEventsTableViewController: PFQueryTableViewController {
    
    let building = Building()
    var currentObject: PFObject?
    var currentUser = PFUser.currentUser()
    
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
        
        query.whereKey("mainEvent", equalTo: currentObject!)
        query.orderByAscending("startDate")
        
        return query
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier:String = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SubEventsTableViewCell
        
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
            dateFormatter.dateFormat = "EEE, dd/MM"
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let endDate = object?["endDate"] as? NSDate
            
            let strDate = dateFormatter.stringFromDate(startDate)
            var enDate = dateFormatter.stringFromDate(endDate!)
            let strTime = timeFormatter.stringFromDate(startDate)
            
            cell.dateLabel.text = strDate
            cell.timeLabel.text = strTime
        }
        
        // Display cover image
        let initialThumbnail = UIImage(named: "placeholder")
        cell.coverImage.image = initialThumbnail
        
        if let thumbnail = object?["cover"] as? PFFile {
            cell.coverImage.file = thumbnail
            cell.coverImage.loadInBackground()
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Subevents"
        
        if let object = currentObject {
            //Track user - Subevent accessed
            
            if currentUser != nil {
                let eventView = PFObject(className: "EventView")
                
                eventView["type"] = "subevent"
                eventView.setObject(currentUser!, forKey: "userId")
                eventView.setObject(object, forKey: "eventId")
                eventView.saveEventually()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "eventListToEventDetail" {
            let detailScene = segue.destinationViewController as! DetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects?[row] as! PFObject)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
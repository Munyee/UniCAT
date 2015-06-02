//
//  EventsTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/15/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventsTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    let building = Building()
    
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
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    }
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "Event"
        self.textKey = "name"
        
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Event")
        var today = NSDate()
        
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        query.orderByAscending("startDate")
        //query.cachePolicy = .CacheThenNetwork
        
        return query
        
        /*
        var query:PFQuery = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0)
        {
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByAscending("name")
        
        return query
        */
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier:String = "cell"
        
        //var cell:PFTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EventsTableViewCell
        
        /*
        if(cell == nil) {
        cell = PFTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }*/
        
        if let pfObject = object {
            //cell?.textLabel?.text = pfObject["name"] as? String
            cell.titleLabel?.text = pfObject["name"] as? String
        }
        
        if let description = object?["subtitle"] as? String {
            //cell?.detailTextLabel?.text = description
            cell.subtitleLabel?.text = description
        }
        
        if let venue = object?["venue"] as? String {
            cell.venueLabel?.text = building.buildingName(room: venue)
        }
        
        if let startDate = object?["startDate"] as? NSDate {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE, dd/MM"
            
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let endDate = object?["endDate"] as? NSDate
            
            var strDate = dateFormatter.stringFromDate(startDate)
            var enDate = dateFormatter.stringFromDate(endDate!)
            var strTime = timeFormatter.stringFromDate(startDate)
            
            cell.dateLabel.text = strDate
            cell.timeLabel.text = strTime
        }
        
        // Display cover image
        var initialThumbnail = UIImage(named: "placeholder")
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
        
        var startup = NSUserDefaults.standardUserDefaults().boolForKey("firstStartup")
        
        if !startup {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func add(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("eventListToEventEditor", sender: self)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if segue.identifier == "eventListToEventDetail" {
            var detailScene = segue.destinationViewController as! DetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
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

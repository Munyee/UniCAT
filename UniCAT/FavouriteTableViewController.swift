//
//  FavouriteTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/11/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class FavouriteTableViewController: PFQueryTableViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var option = "attending"
    var attendObj: [PFObject] = []
    var recommendObj: [PFObject] = []
    
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
        self.textKey = "eventName"
        
    }
    
    override func queryForTable() -> PFQuery {
        let currentUser = PFUser.currentUser()
        let query = PFQuery(className: "Event")
        let query2 = PFQuery(className: "EventAttendance")
        let today = NSDate()
        
        if option == "attending" {
            query2.whereKey("userId", equalTo: currentUser!)
            query2.whereKey("type", notEqualTo: "no")
            query2.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            self.attendObj.append(object["eventId"] as! PFObject)
                        }
                        query.whereKey("objectId", containedIn: self.attendObj)
                        query.whereKey("endDate", greaterThanOrEqualTo: today)
                        query.orderByAscending("startDate")
                        
                    }
                }
            }
            
        } else if option == "recommended" {
            query.whereKey("ReleaseDate", greaterThan: today)
            query.orderByAscending("ReleaseDate")
        }
        
        return query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favourite"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            option = "attending"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            option = "recommended"
        }
        
        self.clear()
        self.loadObjects()
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

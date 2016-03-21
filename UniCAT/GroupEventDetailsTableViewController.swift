//
//  GroupEventDetailsTableViewController.swift
//  UniCAT
//
//  Created by Munyee on 20/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GroupEventDetailsTableViewController: UITableViewController {

    var eventObject = Set<PFObject>()
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var group: UITextField!
    @IBOutlet weak var venue: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)

        
        for item in eventObject{
            if let file = item["cover"] as? PFFile{
                image.file = file
                image.loadInBackground()
                
                name.text = item["name"] as? String
                name.enabled = false
                
                let groupObject = item["group"] as? PFObject
                group.text = groupObject!["name"] as? String
                group.enabled = false
                
                venue.text = item["venue"] as? String
                venue.enabled = false
                
                details.text = item["details"] as? String
                details.editable = false
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "d MMMM yyyy, h:mm a"
                let tmptime = item["date"] as! NSDate
                date.text = formatter.stringFromDate(tmptime)
                
                
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "discussion"){
            let detailScene = segue.destinationViewController as! DiscussViewController
            detailScene.object = self.eventObject

        }
        
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

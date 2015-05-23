//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

var favCount = 20

class MenuController: UITableViewController {
    
    var favouriteList = 1
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countContainer.layer.cornerRadius = 15
        profilePicture.layer.cornerRadius = 25

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        favouriteCount.text = "\(favCount)"
        println("Menu updated")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var countContainer: UIView!
    @IBOutlet weak var profilePicture: UIView!
    @IBOutlet weak var favouriteToggleImage: UIImageView!
    
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var favouriteCount: UILabel!
    
    @IBAction func favouriteToggle(sender: AnyObject) {
        
        if favouriteList == 1 {
            favouriteList = 0
            favouriteToggleImage.image = UIImage(named:"Collapse")
        } else {
            favouriteList = 1
            favouriteToggleImage.image = UIImage(named:"Expand")
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if favouriteList == 0 {
            
            photoLabel.fadeOut()
            videoLabel.fadeOut()
            textLabel.fadeOut()
            
            switch indexPath.row {
            case 0:
                return 100.0
            case 3, 4, 5:
                return 0.0
            default:
                return 50.0
            }
            
        } else {
            
            photoLabel.fadeIn()
            videoLabel.fadeIn()
            textLabel.fadeIn()
            
        switch indexPath.row {
        case 0:
            return 100.0
        default:
            return 50.0
        }
        }
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

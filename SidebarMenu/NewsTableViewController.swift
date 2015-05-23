//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//
/*
import UIKit

let DetailSegueIdentifier = "detailSegue"
var event = 1
var favCount1 = 20
var favCount2 = 16

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!

    var events = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        println("Data reloaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 10
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell

        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.postImageView.image = UIImage(named: "japanvillage")
            cell.postTitleLabel.text = "S.O.U.L. 2015"
            cell.authorLabel.text = "Photography Exhibition"
            cell.favCount.text = "\(favCount1)"
            cell.dateLabel.text = "In 2 days"
        case 1:
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "IT Fair 2015"
            cell.authorLabel.text = "IT Products & Services"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "In 4 days"
        case 2:
            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
            cell.postTitleLabel.text = "iOS Workshop"
            cell.authorLabel.text = "Mobile App Development"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "In 5 days"
        case 3:
            cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.postTitleLabel.text = "Fun Tech Carnival"
            cell.authorLabel.text = "Mini Games & Foods"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "In 9 days"
        case 4:
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "Lumina De Neon"
            cell.authorLabel.text = "Charity Night"
            cell.favCount.text = "\(favCount1)"
            cell.dateLabel.text = "In 15 days"
        case 5:
            cell.postImageView.image = UIImage(named: "japanvillage")
            cell.postTitleLabel.text = "Healthy Lifestyle"
            cell.authorLabel.text = "Health Campaign"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "In 21 days"
        case 6:
            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
            cell.postTitleLabel.text = "Photoshop Workshop"
            cell.authorLabel.text = "Graphics Design"
            cell.favCount.text = "\(favCount1)"
            cell.dateLabel.text = "A month+"
        case 7:
            cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.postTitleLabel.text = "Talk on Wearables"
            cell.authorLabel.text = "Informative Talk"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "A month+"
        case 8:
            cell.postImageView.image = UIImage(named: "japanvillage")
            cell.postTitleLabel.text = "Study Trip to Japan"
            cell.authorLabel.text = "Exchange Programme"
            cell.favCount.text = "\(favCount1)"
            cell.dateLabel.text = "A month +"
        case 9:
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "IT Fair May 2015"
            cell.authorLabel.text = "IT Products & Services"
            cell.favCount.text = "\(favCount1)"
            cell.dateLabel.text = "A month +"
        default:
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "NO DATA"
            cell.authorLabel.text = "NO DATA"
            cell.favCount.text = "\(favCount2)"
            cell.dateLabel.text = "In n days"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier(DetailSegueIdentifier, sender: nil)
        
        if indexPath.row == 0 {
            event = 0
        }
        
        if indexPath.row == 1 {
            event = 1
        }
        println(event)
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

*/
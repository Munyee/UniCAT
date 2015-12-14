//
//  DetailViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/15/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventSubtitle: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventCover: PFImageView!
    @IBOutlet weak var eventVenue: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    let building = Building()
    
    var currentObject: PFObject?
    var currentUser = PFUser.currentUser()
    var subevent = 0
    var buildingInitial = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let object = currentObject {
            
            //Show event details
            eventName.text = object["name"] as? String
            eventSubtitle.text = object["subtitle"] as? String
            eventDescription.text = object["description"] as? String
            
            eventVenue.text = object["venue"] as? String
            
            let initialThumbnail = UIImage(named: "placeholder")
            eventCover.image = initialThumbnail
            
            if let thumbnail = object["cover"] as? PFFile {
                eventCover.file = thumbnail
                eventCover.loadInBackground()
            }
            
            if let startDate = object["startDate"] as? NSDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                
                let timeFormatter = NSDateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                
                let endDate = object["endDate"] as? NSDate
                
                let strDate = dateFormatter.stringFromDate(startDate)
                let enDate = dateFormatter.stringFromDate(endDate!)
                var strTime = timeFormatter.stringFromDate(startDate)
                var enTime = timeFormatter.stringFromDate(endDate!)
                
                if strDate == enDate {
                    eventDate.text = strDate
                    //eventDate.text = strDate + " (" + strTime + " - " + enTime + ")"
                } else {
                    eventDate.text = strDate + " - " + enDate
                    //eventDate.text = strDate + " - " + enDate + " (" + strTime + ")"
                }
            }
            
            if object["hasSubevent"] as? String == "Yes" {
                subevent = 1
            } else {
                subevent = 0
            }
            
            //Track user - Event accessed
            
            if currentUser != nil {
                let eventView = PFObject(className: "EventView")
                
                eventView["type"] = "visit"
                eventView.setObject(currentUser!, forKey: "userId")
                eventView.setObject(object, forKey: "eventId")
                eventView.saveEventually()
            }
            
            /*var query = PFQuery(className: "Event")
            query.whereKey("mainEvent", equalTo: object)
            println(query)
            if query == nil {
                subevent = 0
            } else {
                subevent = 1
            }
            */
            //query.countObjectsInBackground()
            //subevent = query.countObjects()
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        view.reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editEvent(sender: AnyObject) {
        
        if currentUser != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("eventDetailToEventEditor", sender: self)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") 
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
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
            print("Launch Facebook Share")
            
        })
        
        let reportAction = UIAlertAction(title: "Report Fake", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Record fraud report")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
            print("Cancelled")
        })
        
        if currentUser != nil {
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
        
        buildingInitial = building.buildingInitial(eventVenue.text!)
        
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
        } else {
            let nav = segue.destinationViewController as! UINavigationController
            let editorScene = nav.topViewController as! EditorTableViewController
            
            editorScene.currentObject = currentObject
        }
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

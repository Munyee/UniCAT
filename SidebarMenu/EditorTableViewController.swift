//
//  EditorTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/28/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditorTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventSubtitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventCover: PFImageView!
    @IBOutlet weak var eventVenue: UITextField!
    
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var mainEvent: UILabel!
    @IBOutlet weak var eventPicker: UIPickerView!
    
    let picker = UIImagePickerController()
    var id : String = ""
    var currentObject: PFObject?
    var selectedObject: PFObject?
    var newCover = false
    var startPickerHidden = true
    var endPickerHidden = true
    var eventPickerHidden = true
    
    var pickerString = NSArray() as AnyObject as! [String]
    
    var pickerID = NSArray() as AnyObject as! [String]
    var pickerEvent = Array<PFObject>()
    var pickermain = NSArray() as AnyObject as! [String]
    var today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        eventPicker.delegate = self
        
        eventDescription.text = ""
        
        if let object = currentObject {
            eventTitle.text = object["name"] as? String
            eventSubtitle.text = object["subtitle"] as? String
            eventDescription.text = object["description"] as? String
            eventVenue.text = object["venue"] as? String
            id = object.objectId!
            if let startDate = object["startDate"] as? NSDate {
                startDatePicker.date = startDate
            }
            
            if let endDate = object["endDate"] as? NSDate {
                endDatePicker.date = endDate
            }
            
            //var initialThumbnail = UIImage(named: "placeholder")
            //eventCover.image = initialThumbnail
            
            if let thumbnail = object["cover"] as? PFFile {
                eventCover.file = thumbnail
                eventCover.loadInBackground()
            }
            
        }
        
        var query = PFQuery(className: "Event")
        var query2 = PFQuery(className: "Event")
        
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        //query.whereKey("objectId", doesNotMatchQuery: PFQuery)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println("Successfully retrieved \(objects!.count) Events")
                var counter: Int = 0
                for object in objects! {
                    var storeString = ""
                    let retrievedLanguages = object["name"] as! String
                    println("\(retrievedLanguages)")
                    storeString = ("\(retrievedLanguages)")
                    self.pickerString.append(storeString)
                    self.pickerEvent.append(object as! PFObject)
                    let retrievedId = object.objectId!
                    self.pickerID.append(retrievedId!)
                    println(self.pickerID)
                    
                    counter = counter + 1
                }
                self.eventPicker.reloadAllComponents()
            }
        }
        
        
        datePickerChanged()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerString.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.pickerString[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainEvent.text = pickerString[row]
        
        selectedObject = pickerEvent[row]
        
        if id == pickerID[row] {
            mainEvent.text = "NONE"
        }
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
        return 10
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            toggleStartDatepicker()
        }
        
        if indexPath.section == 0 && indexPath.row == 5 {
            toggleEndDatepicker()
        }
        
        if indexPath.section == 0 && indexPath.row == 7 {
            toggleEventpicker()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if startPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        } else if endPickerHidden && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        } else if eventPickerHidden && indexPath.section == 0 && indexPath.row == 8 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func datePickerChanged() {
        
        if endDatePicker.date.compare(startDatePicker.date) == NSComparisonResult.OrderedAscending {
            endDatePicker.date = startDatePicker.date
        }
        
        eventStartDate.text = NSDateFormatter.localizedStringFromDate(startDatePicker.date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        eventEndDate.text = NSDateFormatter.localizedStringFromDate(endDatePicker.date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
    }
    
    func toggleEventpicker() {
        
        eventPickerHidden = !eventPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !eventPickerHidden {
            let indexPath = NSIndexPath(forRow: 8, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
    }
    
    func toggleStartDatepicker() {
        
        startPickerHidden = !startPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !startPickerHidden {
            let indexPath = NSIndexPath(forRow: 4, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
    }
    
    func toggleEndDatepicker() {
        
        endPickerHidden = !endPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !endPickerHidden {
            let indexPath = NSIndexPath(forRow: 6, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventCover.image = chosenImage
        newCover = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Launch Camera")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let libraryAction = UIAlertAction(title: "Choose Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Open Photos Library")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func datePickerValue(sender: AnyObject) {
        datePickerChanged()
    }
    
    @IBAction func save(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        
        if let updateObject = currentObject as PFObject? {
            updateObject["name"] = eventTitle.text
            updateObject["subtitle"] = eventSubtitle.text
            updateObject["description"] = eventDescription.text
            updateObject["venue"] = eventVenue.text
            
            updateObject["startDate"] = startDatePicker.date
            updateObject["endDate"] = endDatePicker.date
            
            if eventVenue.text == "" {
                updateObject["venue"] = "Heritage Hall"
            }
            
            if mainEvent.text != "NONE" {
                updateObject.setObject(selectedObject!, forKey: "mainEvent")
            }
            
            updateObject.saveEventually()
            
            if newCover {
                var chosenImage = eventCover.image
                let imageData = UIImageJPEGRepresentation(chosenImage, 0.8)
                //let imageData = UIImagePNGRepresentation(chosenImage)
                let imageFile = PFFile(name: "cover.jpg", data: imageData)
                
                imageFile.saveInBackgroundWithBlock({
                    (succeeded: Bool, error: NSError?) -> Void in
                    // Handle success or failure here ...
                    if succeeded {
                        println("Success")
                        updateObject["cover"] = imageFile
                        updateObject.saveEventually()
                    }
                    }, progressBlock: {
                        (percentDone: Int32) -> Void in
                        println(percentDone)
                })
            }
            
            //Track user - Event updated
            
            if currentUser != nil {
                let eventView = PFObject(className: "EventView")
                
                eventView["type"] = "update"
                eventView.setObject(currentUser!, forKey: "userId")
                eventView.setObject(updateObject, forKey: "eventId")
                eventView.saveEventually()
            }
            
        } else {
            
            var updateObject = PFObject(className: "Event")
            
            updateObject["name"] = eventTitle.text
            updateObject["subtitle"] = eventSubtitle.text
            updateObject["description"] = eventDescription.text
            updateObject["venue"] = eventVenue.text
            
            updateObject["startDate"] = startDatePicker.date
            updateObject["endDate"] = endDatePicker.date
            
            if eventVenue.text == "" {
                updateObject["venue"] = "A001"
            }
            
            if mainEvent.text != "NONE" {
                updateObject.setObject(selectedObject!, forKey: "mainEvent")
            }
            
            if newCover {
                var chosenImage = eventCover.image
                let imageData = UIImageJPEGRepresentation(chosenImage, 0.8)
                //let imageData = UIImagePNGRepresentation(chosenImage)
                let imageFile = PFFile(name: "cover.jpg", data: imageData)
                
                imageFile.saveInBackgroundWithBlock({
                    (succeeded: Bool, error: NSError?) -> Void in
                    // Handle success or failure here ...
                    if succeeded {
                        println("Success")
                        updateObject["cover"] = imageFile
                        updateObject.saveEventually()
                    }
                    }, progressBlock: {
                        (percentDone: Int32) -> Void in
                        println(percentDone)
                })
            } else {
                updateObject.saveEventually()
            }
            
            //Track user - Event created
            
            if currentUser != nil {
                let eventView = PFObject(className: "EventView")
                
                eventView["type"] = "create"
                eventView.setObject(currentUser!, forKey: "userId")
                eventView.setObject(updateObject, forKey: "eventId")
                eventView.saveEventually()
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
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

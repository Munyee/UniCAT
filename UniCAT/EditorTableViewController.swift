//
//  EditorTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/28/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class EditorTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {

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
    
    @IBOutlet weak var eventTelName: UITextField!
    @IBOutlet weak var eventTel: UITextField!
    @IBOutlet weak var eventFB: UITextField!
    
    let picker = UIImagePickerController()
    
    var eventId: String = ""
    var currentObject: PFObject?
    var selectedObject: PFObject?
    var newCover = false
    var removedCover = false
    var oriMainEvent = ""
    var startPickerHidden = true
    var endPickerHidden = true
    var eventPickerHidden = true
    
    var pickerString = NSArray() as AnyObject as! [String]
    var pickerEvent = Array<PFObject>()
    var today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        eventPicker.delegate = self
        
        // Setting up Text Fields
        eventTitle.resignFirstResponder()
        eventTitle.delegate = self
        
        eventSubtitle.resignFirstResponder()
        eventSubtitle.delegate = self
        
        eventDescription.resignFirstResponder()
        eventDescription.delegate = self
        
        eventVenue.resignFirstResponder()
        eventVenue.delegate = self
        
        eventTelName.resignFirstResponder()
        eventTelName.delegate = self
        
        eventTel.resignFirstResponder()
        eventTel.delegate = self
        
        eventFB.resignFirstResponder()
        eventFB.delegate = self
        
        // Fill in existing data
        eventDescription.text = ""
        
        if let object = currentObject {
            if let name = object["name"] as? String {
                eventTitle.text = name
            } else {
                eventTitle.text = ""
            }
            
            if let subtitle = object["subtitle"] as? String {
                eventSubtitle.text = subtitle
            } else {
                eventSubtitle.text = ""
            }
            
            eventDescription.text = object["description"] as? String
            eventVenue.text = object["venue"] as? String
            eventFB.text = object["fb"] as? String
            eventTel.text = object["tel"] as? String
            eventTelName.text = object["telName"] as? String
            eventId = object.objectId!
            
            if let startDate = object["startDate"] as? NSDate {
                startDatePicker.date = startDate
            }
            
            if let endDate = object["endDate"] as? NSDate {
                endDatePicker.date = endDate
            }
            
            if let mainObject = object["mainEvent"] as? PFObject {
                oriMainEvent = mainObject["name"] as! String
                mainEvent.text = oriMainEvent
            }
            
            //var initialThumbnail = UIImage(named: "placeholder")
            //eventCover.image = initialThumbnail
            
            if let thumbnail = object["cover"] as? PFFile {
                eventCover.file = thumbnail
                eventCover.loadInBackground()
            }
            
        }
        
        let query = PFQuery(className: "Event")
        var query2 = PFQuery(className: "Event")
        
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        //query.whereKey("objectId", doesNotMatchQuery: PFQuery)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Successfully retrieved \(objects!.count) Events")
                var counter: Int = 0
                for object in objects! {
                    var storeString = ""
                    let retrievedLanguages = object["name"] as! String
                    //println("\(retrievedLanguages)")
                    storeString = ("\(retrievedLanguages)")
                    
                    if let object = self.currentObject {
                        if storeString == object["name"] as? String {
                            storeString = "NONE"
                        }
                    }
                    
                    self.pickerString.insert(storeString, atIndex:counter)
                    self.pickerEvent.insert(object as! PFObject, atIndex: counter)
                    counter = counter + 1
                }
                self.eventPicker.reloadAllComponents()
            }
        }
        
        datePickerChanged()
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenCover = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImage = chosenCover.drawInRectAspectFill(CGRect(x: 0, y: 0, width: 860, height: 324))
        
        eventCover.image = chosenImage
        newCover = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case eventTitle:
            eventSubtitle.becomeFirstResponder()
        case eventSubtitle:
            eventDescription.becomeFirstResponder()
            let indexPath = NSIndexPath(forRow: 1, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        case eventVenue:
            toggleStartDatepicker()
        case eventTelName:
            eventTel.becomeFirstResponder()
        case eventTel:
            eventFB.becomeFirstResponder()
        default:
            print("Invalid selection")
        }
        
        return true
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let removeAction = UIAlertAction(title: "Remove Cover", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.newCover = false
            self.removedCover = true
            self.eventCover.image = UIImage(named: "blank")
            
        })
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Launch Camera")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let libraryAction = UIAlertAction(title: "Choose Photo", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Open Photos Library")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
            print("Cancelled")
        })
        
        if newCover {
            optionMenu.addAction(removeAction)
        } else if let object = currentObject {
            if let thumbnail = object["cover"] as? PFFile {
                if !removedCover {
                    optionMenu.addAction(removeAction)
                }
            }
        }
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
        
        // Form validation
        if eventTitle.text == "" || eventDescription.text == "" {
            let alertController = UIAlertController(title: "Warning", message:
                "Mandatory Fields are not filled.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction) in
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
                
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            if eventTitle.text == "" {
                eventTitle.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            
            if eventDescription.text == "" {
                eventDescription.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            
        } else {
            
            if let updateObject = currentObject as PFObject? {
                updateObject["name"] = eventTitle.text
                updateObject["subtitle"] = eventSubtitle.text
                updateObject["description"] = eventDescription.text
                updateObject["venue"] = eventVenue.text
                
                updateObject["startDate"] = startDatePicker.date
                updateObject["endDate"] = endDatePicker.date
                
                updateObject["telName"] = eventTelName.text
                updateObject["tel"] = eventTel.text
                updateObject["fb"] = eventFB.text
                
                if eventVenue.text == "" {
                    updateObject["venue"] = "UTAR"
                }
                
                if eventTel.text == "" {
                    updateObject["tel"] = "None"
                    updateObject["fb"] = "0"
                }
                
                if mainEvent.text != "NONE" && mainEvent.text != oriMainEvent {
                    updateObject.setObject(selectedObject!, forKey: "mainEvent")
                    
                    var mainObject = updateObject["mainEvent"] as? PFObject
                    if let object = mainObject {
                        object["hasSubevent"] = "Yes"
                        object.saveEventually()
                    }
                    
                }
                
                updateObject.saveEventually()
                
                if newCover {
                    var chosenImage = eventCover.image
                    
                    if removedCover {
                        chosenImage = UIImage(named: "placeholder")
                    }
                    
                    let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
                    let imageFile = PFFile(name: "cover.jpg", data: imageData!)
                    
                    imageFile!.saveInBackgroundWithBlock({
                        (succeeded: Bool, error: NSError?) -> Void in
                        // Handle success or failure here ...
                        if succeeded {
                            print("Success")
                            updateObject["cover"] = imageFile
                            updateObject.saveEventually()
                        }
                        }, progressBlock: {
                            (percentDone: Int32) -> Void in
                            print(percentDone)
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
                
                updateObject["telName"] = eventTelName.text
                updateObject["tel"] = eventTel.text
                updateObject["fb"] = eventFB.text
                updateObject["report"] = 0
                
                if eventVenue.text == "" {
                    updateObject["venue"] = "UTAR"
                }
                
                if mainEvent.text != "NONE" {
                    updateObject.setObject(selectedObject!, forKey: "mainEvent")
                    
                    var mainObject = updateObject["mainEvent"] as? PFObject
                    if let object = mainObject {
                        object["hasSubevent"] = "Yes"
                        object.saveEventually()
                    }
                    
                }
                
                if newCover {
                    var chosenImage = eventCover.image
                    if removedCover {
                        chosenImage = UIImage(named: "placeholder")
                    }
                    
                    let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
                    let imageFile = PFFile(name: "cover.jpg", data: imageData!)
                    
                    imageFile!.saveInBackgroundWithBlock({
                        (succeeded: Bool, error: NSError?) -> Void in
                        // Handle success or failure here ...
                        if succeeded {
                            print("Success")
                            updateObject["cover"] = imageFile
                            updateObject.saveEventually()
                        }
                        }, progressBlock: {
                            (percentDone: Int32) -> Void in
                            print(percentDone)
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
            
            let alertController = UIAlertController(title: "Success", message:
                "Changes saved successfully. Pull-to-Refresh in Event list to see the changes.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

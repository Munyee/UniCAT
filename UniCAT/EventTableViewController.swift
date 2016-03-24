//
//  EventTableViewController.swift
//  UniCAT
//
//  Created by Munyee on 17/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,MapRefreshViewDelegate{

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var group: UITextField!
    @IBOutlet weak var venue: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var buildingName: UITextField!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var groupbtn: UIButton!
    @IBOutlet weak var buildingButton: UIButton!
   
    
    var today = NSDate()
    var datePickerHidden = true
    
    var pointSelected = CLLocationCoordinate2D()
    var newCover = false
    var removedCover = false
    let picker = UIImagePickerController()
    var creategroup = [String()]
    var groupobject = NSMutableArray()
    var users = NSMutableArray()
    var selection = 0
    var buildingselection = 0
    var scale = CGFloat()
    
    var pointx = Double()
    var pointy = Double()
    
    let latmin = 4.332435;
    let latmax = 4.345159;
    let longmin = 101.133013;
    let longmax = 101.145641;
    
    var buildings = ["Heritage Hall","Learning Complex I","Student Pavilion I","Faculty of Science","FEGT","Administration Block","Library","FBF","Lecture Complex I","Engineering Workshop","Student Pavilion II","Lecture Complex II","Grand Hall","FICT & IPSR Lab","FAS & ICS","Sports Complex"]
    
    var point = PFGeoPoint()
    var groupCheck = true
   
    override func viewDidAppear(animated: Bool) {
        creategroup.removeAll()
        groupobject.removeAllObjects()
        let query = PFQuery(className:"Group")
        let currentUser = PFUser.currentUser()
        query.whereKey("creator",equalTo:currentUser!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) groups.")
                
                var x = 0
                // Do something with the found objects
                for object in objects!{
                    
                    let item = object["name"] as? String
                    self.creategroup.insert(item!, atIndex: x)
                    self.groupobject.insertObject(object, atIndex: x++)
                    
                }
                
                self.group.hidden = false
                self.groupbtn.enabled = true
                self.activity.hidden = true
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    
    }

    override func viewDidLoad() {
        saveActivity.hidden = true
        
        super.viewDidLoad()
        groupbtn.enabled = false
        group.hidden = true
        activity.startAnimating()

        picker.delegate = self
        details.text = ""
        
//        pointx = ((Double(pointSelected.latitude)/Double(scale))/100) * latmin
//        pointy = ((Double(pointSelected.longitude)/Double(scale))/100) * longmin

        pointy = latmax - ((latmax - latmin) * (Double(pointSelected.latitude)/(1000*Double(scale))))
        pointx = longmin + ((longmax - longmin) * (Double(pointSelected.longitude)/(1000*Double(scale))))
        print(pointy ,pointx)
        
        point = PFGeoPoint(latitude : pointy, longitude : pointx)
        
        datePickerChanged()

        
    }
    
    func datePickerChanged() {
        
        if datePicker.date.compare(today) == NSComparisonResult.OrderedAscending {
            datePicker.date = today
        }
        
        
        date.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
    }
    
    func toggleStartDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !datePickerHidden {
            let indexPath = NSIndexPath(forRow: 5, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 4 {
            toggleStartDatepicker()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 5 {
            return 0
        }else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    @IBAction func datePickerValue(sender: AnyObject) {
        datePickerChanged()
    }

    
    
    @IBAction func saveEvent(sender: AnyObject) {
    
        let updateObject = PFObject(className:"GroupEvent")
        
        if name.text == "" || venue.text == "" || details.text == "" || groupbtn.currentTitle == nil {
            let alertController = UIAlertController(title: "Warning", message:
                "Mandatory Fields are not filled.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction) in
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
                
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            if name.text == "" {
                name.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            else {
                name.backgroundColor = UIColor.whiteColor()
            }
            
            if venue.text == "" {
                venue.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            else {
                venue.backgroundColor = UIColor.whiteColor()
            }
            
            if details.text == "" {
                details.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            else{
                details.backgroundColor = UIColor.whiteColor()
            }
            
            if groupbtn.currentTitle == nil {
                group.backgroundColor = UIColor(red: 223/255.0, green: 72/255.0, blue: 61/255.0, alpha: 0.1)
            }
            else {
                group.backgroundColor = UIColor.whiteColor()
            }
        }
        else{
            saveLabel.hidden = true
            saveActivity.hidden = false
            saveActivity.startAnimating()
            
            var chosenImage = cover.image
            
            if removedCover || !newCover {
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
                    updateObject["group"] = self.groupobject[self.selection]
                    updateObject["date"] = self.datePicker.date
                    updateObject["name"] = self.name.text
                    updateObject["venue"] = self.venue.text
                    updateObject["details"] = self.details.text
                    updateObject["location"] = self.point
                    updateObject["block"] = self.buildings[buildingselection]
                    updateObject.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            
                            let query = PFQuery(className:"JoinGroup")
                            query.whereKey("group",equalTo:self.groupobject[self.selection])
                            query.findObjectsInBackgroundWithBlock {
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    // The find succeeded.
                                    print("Successfully retrieved \(objects!.count) scores.")
                                    // Do something with the found objects
                                    if let objects = objects {
                                        for object in objects {
                                            let item = object["user"] as? PFObject
                                            self.users.addObject(item!)
                                        }
                                    }
                                    
                                    for user in self.users{
                                        let pushQuery = PFInstallation.query()
                                        pushQuery!.whereKey("user", equalTo: user)
                                        
                                        // Send push notification to query
                                        let push = PFPush()
                                        push.setQuery(pushQuery) // Set our Installation query
                                        push.setMessage(self.creategroup[self.selection] + " created an event: " + self.name.text!)
                                        push.sendPushInBackground()

                                    }
                                    
                                } else {
                                    // Log details of the failure
                                    print("Error: \(error!) \(error!.userInfo)")
                                }
                            }

                            
                            self.navigationController?.popViewControllerAnimated(true)
                            
                            
                            
                        } else {
                            // There was a problem, check error.description
                        }
                    }
                }
                }, progressBlock: {
                    (percentDone: Int32) -> Void in
                    print(percentDone)
            })
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectGroup(sender: AnyObject) {
        self.groupCheck = true
        self.performSegueWithIdentifier("pickerView", sender: self)
        
    }
    
    @IBAction func selectBuilding(sender: AnyObject) {
        self.groupCheck = false
        self.performSegueWithIdentifier("pickerView", sender: self)
        
    }
    
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let removeAction = UIAlertAction(title: "Remove Cover", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.newCover = false
            self.removedCover = true
            self.cover.image = UIImage(named: "blank")
            
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
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenCover = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImage = chosenCover.drawInRectAspectFill(CGRect(x: 0, y: 0, width: 860, height: 324))
        
        cover.image = chosenImage
        newCover = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickerView" && groupCheck == true {
            let pickerScene = segue.destinationViewController as! MapPickerViewController
            
            pickerScene.type = selection
            pickerScene.typeName = self.creategroup
            pickerScene.refreshDelegate = self
        }else  if segue.identifier == "pickerView" && groupCheck == false {
            let pickerScene = segue.destinationViewController as! MapPickerViewController
            
            pickerScene.type = buildingselection
            pickerScene.typeName = self.buildings
            pickerScene.refreshDelegate = self
        }
    }
    
    func updateClass(classType: Int) {
        
        if groupCheck{
            group.placeholder = nil
            selection = classType
            groupbtn.setTitle(self.creategroup[selection], forState: UIControlState.Normal)
        }else if !groupCheck{
            buildingName.placeholder = nil
            buildingselection = classType
            buildingButton.setTitle(self.buildings[buildingselection], forState: UIControlState.Normal)
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

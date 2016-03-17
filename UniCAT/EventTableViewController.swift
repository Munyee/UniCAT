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
    
    @IBOutlet weak var groupbtn: UIButton!
    var pointSelected = CLLocationCoordinate2D()
    var newCover = false
    var removedCover = false
    let picker = UIImagePickerController()
    var creategroup = [String()]
    var selection = 0
    var scale = CGFloat()
    
    var pointx = Double()
    var pointy = Double()
    
    let latmin = 4.332435;
    let latmax = 4.345159;
    let longmin = 101.133013;
    let longmax = 101.145641;
    
    override func viewDidAppear(animated: Bool) {
        creategroup.removeAll()
        
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
                    self.creategroup.insert(item!, atIndex: x++)
                    
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
        
        
    }

    @IBAction func coverChange(sender: AnyObject) {
    }
    
    
    @IBAction func saveEvent(sender: AnyObject) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectGroup(sender: AnyObject) {
        self.performSegueWithIdentifier("pickerView", sender: self)
    }
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let removeAction = UIAlertAction(title: "Remove Cover", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.newCover = false
            self.removedCover = true
            self.cover.image = UIImage(named: "Add Cover")
            
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
        if segue.identifier == "pickerView" {
            let pickerScene = segue.destinationViewController as! MapPickerViewController
            
            pickerScene.type = selection
            pickerScene.typeName = self.creategroup
            pickerScene.refreshDelegate = self
        }
        
    }
    
    func updateClass(classType: Int) {
        group.placeholder = nil
        selection = classType
        groupbtn.setTitle(self.creategroup[selection], forState: UIControlState.Normal)
        
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

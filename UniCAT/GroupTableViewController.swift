//
//  GroupTableViewController.swift
//  UniCAT
//
//  Created by Munyee on 16/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {

    @IBOutlet weak var addGroupButton: UIBarButtonItem!
    var allGroup : NSMutableArray = NSMutableArray()
    var joinGroup : NSMutableArray = NSMutableArray()
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    var nameTextField: UITextField?
    var passwordTextField: UITextField?
    var secondTextField: UITextField?
    
    
    
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(true)

        
        if(PFUser.currentUser() == nil){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
        }else{
        
        joinGroup.removeAllObjects()
        allGroup.removeAllObjects()
        let currentUser = PFUser.currentUser()
        
        
        if currentUser?["approve"] as? String == "yes" {
            
            addGroupButton.enabled = true
            
        }
        else{
            addGroupButton.enabled = false
        }
        
        let joinquery = PFQuery(className:"JoinGroup")
        joinquery.whereKey("user",equalTo:currentUser!)
        print(currentUser!.objectId!)
        joinquery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) join.")
                
                for object in objects!{
                    let item = object["group"] as! PFObject
                    
                    self.joinGroup.addObject(item)
                }
                // Do something with the found objects
                
                let query = PFQuery(className:"Group")
                query.whereKey("creator",equalTo:currentUser!)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) groups.")
                        
                        // Do something with the found objects
                        for object in objects!{
                            
                            
                            self.joinGroup.addObject(object)
                        }

                        
                        let query = PFQuery(className:"Group")
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("Successfully retrieved \(objects!.count) groups.")
                                
                                // Do something with the found objects
                                self.allGroup = NSMutableArray(array: objects!)
                                
                                self.tableView.reloadData()
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0){
            if(joinGroup.count == 0){
                return 0
            }else{
                return joinGroup.count
            }
        }else if (section == 1){
            if(allGroup.count == 0){
                return 0
            }else{
                return allGroup.count
            }
        }
        else{
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Joined Groups"
        }else{
            return "Available Groups"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var check = true
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupcell", forIndexPath: indexPath) as! GroupTableViewCell

        if (indexPath.section == 0 && joinGroup.count > 0){
            
            let object = joinGroup.objectAtIndex(indexPath.row) as! PFObject
            cell.groupName.text = object.valueForKey("name") as? String
            let type = object.valueForKey("passphrase") as? String
            if (type == "" || type == nil){
                cell.type.text = "Public"
            }
            else{
                cell.type.text = "Private"
            }
        }
        else if(indexPath.section == 1 && allGroup.count > 0){
            
            let groupObject = allGroup.objectAtIndex(indexPath.row) as! PFObject
            let groupName = groupObject.valueForKey("name") as? String
            for(var x = 0 ; x < self.joinGroup.count ; x++){
                let object = joinGroup.objectAtIndex(x) as! PFObject
                let  name = object.valueForKey("name") as? String
                                if(name == groupName){
                    check = false
                    allGroup.removeObjectAtIndex(indexPath.row)
                    tableView.reloadData()
                                    break
                }
            }
            if(check){
            let object = allGroup.objectAtIndex(indexPath.row) as! PFObject
            cell.groupName.text = object.valueForKey("name") as? String
                let type = object.valueForKey("passphrase") as? String
                if (type == "" || type == nil){
                    cell.type.text = "Public"
                }
                else{
                    cell.type.text = "Private"
                }

            }
        }
        // Configure the cell...
        
        cell.activity.hidden = true
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath( indexPath) as! GroupTableViewCell
        let currentUser = PFUser.currentUser()


        
        
        
        
        if(indexPath.section == 0 && joinGroup.count > 0){
            let object = joinGroup.objectAtIndex(indexPath.row) as! PFObject
            let user = object.valueForKey("creator") as! PFObject
            if ( user.objectId == currentUser!.objectId!){
                let title = cell.groupName.text
                let alert = UIAlertController(title: title , message: "Removing group and group members\nAre you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let delete = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                    cell.activity.hidden = false
                    cell.activity.startAnimating()
                    
                    let query = PFQuery(className:"JoinGroup")
                    query.whereKey("group",equalTo : self.joinGroup[indexPath.row])
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            // The find succeeded.
                            
                            for object in objects!{
                                object.deleteInBackground()
                            }
                            
                            // Do something with the found objects
                            let object = self.joinGroup[indexPath.row] as? PFObject
                            let query = PFQuery(className:"Group")
                            query.whereKey("objectId",equalTo : object!.objectId!)
                            query.findObjectsInBackgroundWithBlock {
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    // The find succeeded.
                                    
                                    for object in objects!{
                                        object.deleteInBackground()
                                    }
                                    
                                    // Do something with the found objects
                                    self.viewDidAppear(true)
                                } else {
                                    // Log details of the failure
                                    print("Error: \(error!) \(error!.userInfo)")
                                }
                            }
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                    }
            }
        
        
            alert.addAction(delete)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
            }
            else{
                dispatch_async(dispatch_get_main_queue()) {
                    let title = cell.groupName.text
                    let alert = UIAlertController(title: title , message: "Removing from this group.\nAre you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let delete = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                        cell.activity.hidden = false
                        cell.activity.startAnimating()
                        let query = PFQuery(className:"JoinGroup")
                        query.whereKey("group",equalTo : self.joinGroup[indexPath.row])
                        query.whereKey("user",equalTo :PFUser.currentUser()!)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                
                                for object in objects!{
                                    object.deleteInBackground()
                                }
                                
                                // Do something with the found objects
                                self.viewDidAppear(true)
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }
                    }
                    
                    alert.addAction(delete)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }

            }
        }
        
        else if(indexPath.section == 1 && allGroup.count > 0){
             dispatch_async(dispatch_get_main_queue())
                {
                    let password = self.allGroup[indexPath.row].valueForKey("passphrase") as? String
                    if(password == "" || password == nil){
                        let title = cell.groupName.text
                        
                        let alert = UIAlertController(title: title , message: "Adding this group.\nAre you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let add = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                            
                            
                            cell.activity.hidden = false
                            cell.activity.startAnimating()
                            let jgroup = PFObject(className:"JoinGroup")
                            jgroup["user"] = PFUser.currentUser()!
                            jgroup["group"] = self.allGroup[indexPath.row]
                            jgroup.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    self.viewDidAppear(true)
                                } else {
                                    // There was a problem, check error.description
                                }
                            }
                            
                        }
                        
                        alert.addAction(add)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }

                    else{
                        let title = cell.groupName.text
                        var passwrodTextField: UITextField?
                        let alert = UIAlertController(title: title , message: "Adding this group.\nAre you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addTextFieldWithConfigurationHandler { (textField) in
                            textField.placeholder = "Passphrase"
                            textField.secureTextEntry = true
                            passwrodTextField = textField
                        }
                        
                        let add = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                            
                            if(password == passwrodTextField!.text){
                                cell.activity.hidden = false
                                cell.activity.startAnimating()
                                let jgroup = PFObject(className:"JoinGroup")
                                jgroup["user"] = PFUser.currentUser()!
                                jgroup["group"] = self.allGroup[indexPath.row]
                                jgroup.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        self.viewDidAppear(true)
                                    } else {
                                        // There was a problem, check error.description
                                    }
                                }
                            }
                            else{
                                let alertView = UIAlertView();
                                alertView.addButtonWithTitle("OK");
                                alertView.title = "Error";
                                alertView.message = "Wrong Passphrase";
                                alertView.show();
                            }
                            
                            
                        }
                        
                        alert.addAction(add)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
            }

        }
    }

    @IBAction func newGroup(sender: AnyObject) {
        alert()
    }
    
    func alert(){
        let alertController = UIAlertController(title: "New Group", message: nil, preferredStyle: .Alert)
        
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Group Name"
            textField.keyboardType = .Default
            textField.text = self.nameTextField?.text
            self.nameTextField = textField
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Passphrase"
            textField.secureTextEntry = true
            textField.text = self.passwordTextField?.text
            self.passwordTextField = textField
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Passphrase Confirmation"
            textField.secureTextEntry = true
            textField.text = self.secondTextField?.text
            self.secondTextField = textField
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            if(self.nameTextField!.text?.length < 4){
                let alertView = UIAlertController(title: "Error", message: "Group name too short", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    self.alert()
                }
                
                alertView.addAction(ok)
                 self.presentViewController(alertView, animated: true, completion: nil)
                
            }
            else if (self.passwordTextField?.text != self.secondTextField?.text){
                let alertView = UIAlertController(title: "Error", message: "Passphase not match", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    self.alert()
                }
                
                alertView.addAction(ok)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            else{
                let jgroup = PFObject(className:"Group")
                jgroup["creator"] = PFUser.currentUser()!
                jgroup["name"] = self.nameTextField?.text
                jgroup["passphrase"] = self.passwordTextField?.text
                jgroup.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.passwordTextField?.text = ""
                        self.secondTextField?.text = ""
                        self.nameTextField?.text = ""
                        self.viewDidAppear(true)
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
            
            
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
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

//
//  DiscussViewController.swift
//  UniCAT
//
//  Created by Munyee on 21/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DiscussViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    var object = Set<PFObject>()
    @IBOutlet weak var userProfile: PFImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var noCommentImage: UIImageView!
    @IBOutlet weak var noCommentLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    let currentUser = PFUser.currentUser()
    var keyboardHeight = CGFloat()
    
    var arrComment = NSMutableArray()
    override func viewWillAppear(animated: Bool) {
    
        self.sendButton.enabled = false
        
        self.activity.hidden = true
        self.arrComment.removeAllObjects()
        
        super.viewWillAppear(true)

        self.tableView.hidden = true
        self.noCommentImage.hidden = true
        self.noCommentLabel.hidden = true
        
        keyboardHeight = 0.0
        
        comment.text = "Write Here"
        comment.textColor = UIColor.lightGrayColor()
        comment.delegate = self
        if (PFUser.currentUser() != nil){
            userProfile.file = currentUser!["image"] as? PFFile
            userProfile.loadInBackground()
        }
        
        tableView.delegate = self
        tableView.dataSource  = self
        
        tableView.tableFooterView = UIView()
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Fetching data"
        
        for item in self.object{
            let query = PFQuery(className:"Discussion")
            query.whereKey("event", equalTo:item)
            query.includeKey("user")
            query.orderByDescending("date")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            self.arrComment.addObject(object)
                        }
                    }
                    
                    if(self.arrComment.count > 0){
                        self.noCommentLabel.hidden = true
                        self.noCommentImage.hidden = true
                        self.tableView.hidden = false
                        self.tableView.reloadData()
                    }
                    else{
                        self.noCommentLabel.hidden = false
                        self.noCommentImage.hidden = false
                    }
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        tableView.estimatedRowHeight = 90
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
         tableView.reloadData()
    

    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        
        for item in self.object{
            let query = PFQuery(className:"Discussion")
            query.whereKey("event", equalTo:item)
            query.orderByDescending("date")
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    self.arrComment.removeAllObjects()

                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            self.arrComment.addObject(object)
                        }
                    }
                    
                    if(self.arrComment.count > 0){
                        self.tableView.hidden = false
                        self.tableView.reloadData()
                    }
                    else{
                        self.noCommentLabel.hidden = false
                        self.noCommentImage.hidden = false
                    }
                    
                    refreshControl.endRefreshing()

                    
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
    

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return 1
    }
        
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discussCell", forIndexPath: indexPath) as! DiscussionTableViewCell
        let user = self.arrComment[indexPath.row].valueForKey("user") as? PFObject
        
        cell.userProfile.file = user!["image"] as? PFFile
        cell.userProfile.loadInBackground()
        
        cell.userName.text = user!["name"] as? String
        
        cell.userComment.text = self.arrComment[indexPath.row].valueForKey("comment") as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d MMMM yyyy, h:mm a"
        let tmptime = self.arrComment[indexPath.row].valueForKey("date") as? NSDate
        
        cell.date.text = formatter.stringFromDate(tmptime!)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    @IBAction func upload(sender: AnyObject) {
        
        
        
        if (PFUser.currentUser() == nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        }else if (comment.textColor != UIColor.lightGrayColor()){
            
            sendButton.hidden = true
            activity.hidden = false
            activity.startAnimating()
            
            
            for item in object{
                let today = NSDate()
                let comment = PFObject(className:"Discussion")
                comment["user"] = PFUser.currentUser()
                comment["event"] = item
                comment["comment"] = self.comment.text
                comment["date"] = today
                comment.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.view.endEditing(true)
                        self.arrComment.removeAllObjects()
                        self.comment.text = "Write Here"
                        self.comment.textColor = UIColor.lightGrayColor()
                        self.activity.stopAnimating()
                        self.activity.hidden = true
                        self.sendButton.hidden = false
                        
                        var x = 0
                        for item in self.object{
                            let query = PFQuery(className:"Discussion")
                            query.whereKey("event", equalTo:item)
                            query.orderByDescending("date")
                            query.includeKey("user")
                            query.findObjectsInBackgroundWithBlock {
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    // The find succeeded.
                                    print("Successfully retrieved \(objects!.count) scores.")
                                    // Do something with the found objects
                                    if let objects = objects {
                                        for object in objects {
                                            self.arrComment.addObject(object)
                                            x++
                                        }
                                    }
                                    
                                    if(self.arrComment.count > 0 && self.arrComment.count == x){
                                        self.tableView.hidden = false
                                        self.tableView.reloadData()
                                    }
                                    else{
                                        self.noCommentLabel.hidden = false
                                        self.noCommentImage.hidden = false
                                    }
                                    
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    
                                } else {
                                    // Log details of the failure
                                    print("Error: \(error!) \(error!.userInfo)")
                                }
                            }
                        }
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
        }
        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if comment.textColor == UIColor.lightGrayColor() {
            comment.text = nil
            comment.textColor = UIColor.blackColor()
        }
        
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        if comment.textColor != "" {
            sendButton.enabled = true
        }else{
            sendButton.enabled = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if comment.text.isEmpty {
            comment.text = "Write Here"
            comment.textColor = UIColor.lightGrayColor()
            sendButton.enabled = false
        }

    }
    
   
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height - 40
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.layoutIfNeeded()

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()

        })
        
        view.endEditing(true)
        
        
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

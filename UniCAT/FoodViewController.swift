//
//  FoodViewController.swift
//  UniCAT
//
//  Created by Munyee on 12/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class FoodViewController: PFQueryCollectionViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var pfCollection: UICollectionView!
    var rightItem:UIBarButtonItem = UIBarButtonItem()
    let locationManager = CLLocationManager()
    var id:String = ""
    var choice : [String] = []
    var userobject : [PFObject] = []
    var user : [String] = []
    var count : Int = 1
    var reload = true;
    var arrFile : [PFFile] = []
    var name : [String] = []
    var gender : [String] = []
    var userLocation : [PFGeoPoint] = []
    var userPoint : [String] = []
    var num : Int32 = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pfCollection.backgroundColor = UIColor.blackColor()

    }
    
    override func viewDidDisappear(animated: Bool) {
        if(PFUser.currentUser() != nil){
            self.objectsWillLoad()
            self.navigationController?.navigationBarHidden = false
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "rect"), forState: .Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.targetForAction("check:", withSender: self)
            button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
            rightItem.customView = button
            
            self.navigationItem.rightBarButtonItem = rightItem
            
            
            
            let query = PFQuery(className:"UserLocation")
            query.whereKey("userId", equalTo: PFUser.currentUser()!)
            query.findObjectsInBackgroundWithBlock({(objects: [PFObject]?, error:NSError?) -> Void in
                // Looping through the objects to get the names of the workers in each object
                
                if(objects!.count == 0){
                    
                    PFGeoPoint.geoPointForCurrentLocationInBackground ({
                        (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                        if error == nil {
                            let point = PFGeoPoint(latitude:self.locationManager.location!.coordinate.latitude, longitude:self.locationManager.location!.coordinate.longitude)
                            
                            var saveLocation = PFObject(className:"UserLocation")
                            saveLocation["userId"] = PFUser.currentUser()
                            saveLocation["coordination"] = point
                            
                            saveLocation.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                } else {
                                    // There was a problem, check error.description
                                }
                            }
                            
                        }
                    })
                }
                
                for object in objects! {
                    self.id = object.objectId!
                    
                    PFGeoPoint.geoPointForCurrentLocationInBackground ({
                        (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                        if error == nil {
                            let point = PFGeoPoint(latitude:self.locationManager.location!.coordinate.latitude, longitude:self.locationManager.location!.coordinate.longitude)
                            
                            let query = PFQuery(className:"UserLocation")
                            query.whereKey("userId", equalTo: PFUser.currentUser()!)
                            query.getObjectInBackgroundWithId(self.id) {
                                (coordination: PFObject?, error: NSError?) -> Void in
                                if coordination == nil {
                                    let object = PFObject(className: "UserLocation")
                                    object["coordination"] = point
                                    object.setObject(PFUser.currentUser()!, forKey: "userId")
                                    object.saveInBackground()
                                } else if let gameScore = coordination {
                                    gameScore["coordination"] = point
                                    gameScore.saveInBackground()
                                }
                                
                            }
                            
                        }
                        else
                        {
                            print("error")
                        }
                        
                    })
                    
                    
                }
                
                
            })

        }
    }
    
    override func objectsWillLoad() {
        if(PFUser.currentUser() != nil){
            self.pfCollection.hidden = true
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
            
            
            
            choice = []
            choice.append(PFUser.currentUser()!.objectId!)
            userobject = []
            user = []
            userPoint = []
            gender = []
            num = 0
            self.pfCollection.hidden = true
            count = 1
            reset()
        }
        
    }
    
    func check (sender: UIBarButtonItem){
        if(NSUserDefaults.standardUserDefaults().boolForKey("rect")){
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rect")
            NSUserDefaults.standardUserDefaults().synchronize()
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "square"), forState: .Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.targetForAction("check:", withSender: self)
            button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
            rightItem.customView = button
            
            self.navigationItem.rightBarButtonItem = rightItem
            self.pfCollection.reloadData()
        }
        else{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "rect")
            NSUserDefaults.standardUserDefaults().synchronize()
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "rect"), forState: .Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.targetForAction("check:", withSender: self)
            button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
            rightItem.customView = button
            
            self.navigationItem.rightBarButtonItem = rightItem
            self.pfCollection.reloadData()
        }
       
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func queryForCollection() -> PFQuery {
        
        
        let point = PFGeoPoint(latitude: 0, longitude: 0)
        
        let query = PFQuery(className: "UserLocation")
//        query.whereKey("role", equalTo: "join")
        query.whereKey("coordination", notEqualTo: point)
        query.includeKey("userId")
        if(PFUser.currentUser() == nil){
            query.whereKey("nodata", equalTo: "nodata")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        }
//        query.whereKey("coordination", nearGeoPoint: userSelectViewController.userlocation, withinKilometers: 1)
        
        return query
       
    }
    
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("rect")){
            if(UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait){
                return CGSizeMake(((UIScreen.mainScreen().bounds.size.width/3)-3), (UIScreen.mainScreen().bounds.size.width/3)+35)
            }
            else{
                return CGSizeMake(((UIScreen.mainScreen().bounds.size.height/3)-3), (UIScreen.mainScreen().bounds.size.height/3)+35)
            }
        }
        else if(!NSUserDefaults.standardUserDefaults().boolForKey("rect")){
            if(UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait){
                return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 100)
            }
            else{
                return CGSizeMake(UIScreen.mainScreen().bounds.size.height, 100)
            }
        }
        return CGSizeMake(0, 0);
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("square", forIndexPath: indexPath) as! FoodViewCell
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("rect")){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("rect", forIndexPath: indexPath) as! FoodViewCell
        }
        
        
        cell.userImage.image = UIImage(named: "Logo")
        self.userobject.append((object?["userId"] as! PFObject))
        self.userLocation.append(object?["coordination"] as! PFGeoPoint)
        
        
        let users = object?["userId"] as? PFObject
            cell.userImage.file = users?["image"] as? PFFile
            cell.userImage.loadInBackground()
            cell.userName.text = users?["name"] as? String
            cell.distance.text = ""
            if (users?["gender"] as? String == "M"){
                cell.gender.text = "Male"
            } else {
                cell.gender.text = "Female"
            }
        
        self.choice.append("")
        self.user.append("")
        
        
        if (indexPath.row == self.pfCollection.numberOfItemsInSection(0)-1) {

            self.pfCollection.hidden = false
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
            
            if (cell.selected || choice[indexPath.row+1] != "" ) {
                cell.backgroundColor = UIColor.greenColor()
            }
            else
            {
                cell.backgroundColor = UIColor.whiteColor()
            }

            
//        }
        
        self.pfCollection.allowsMultipleSelection = true
        
        return cell
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell : FoodViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FoodViewCell
        
        if (choice[indexPath.row+1] == "" ) {
            choice[indexPath.row+1] = userobject[indexPath.row].objectId!
            cell.backgroundColor = UIColor.greenColor()
            count++
            
            if (count > 1){
                let button: UIButton = UIButton()
                button.setImage(UIImage(named: "next"), forState: .Normal)
                button.frame = CGRectMake(0, 0, 25, 25)
                button.targetForAction("next:", withSender: self)
                button .addTarget(self, action: "next:", forControlEvents: UIControlEvents.TouchUpInside)
                
                rightItem.customView = button
                
                self.navigationItem.rightBarButtonItem = rightItem
            }
        }
        else
        {
            choice[indexPath.row+1] = ""
            cell.backgroundColor = UIColor.whiteColor()
            count--
            if(count < 2){
                if(!NSUserDefaults.standardUserDefaults().boolForKey("rect")){
                    
                    let button: UIButton = UIButton()
                    button.setImage(UIImage(named: "square"), forState: .Normal)
                    button.frame = CGRectMake(0, 0, 25, 25)
                    button.targetForAction("check:", withSender: self)
                    button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    rightItem.customView = button
                    
                    self.navigationItem.rightBarButtonItem = rightItem
                    self.pfCollection.reloadData()
                }
                else{

                    let button: UIButton = UIButton()
                    button.setImage(UIImage(named: "rect"), forState: .Normal)
                    button.frame = CGRectMake(0, 0, 25, 25)
                    button.targetForAction("check:", withSender: self)
                    button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    rightItem.customView = button
                    
                    self.navigationItem.rightBarButtonItem = rightItem
                    self.pfCollection.reloadData()
                }
                
            }

        }
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell : FoodViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FoodViewCell
        
        if (choice[indexPath.row+1] == "" ) {
            choice[indexPath.row+1] = userobject[indexPath.row].objectId!
            cell.backgroundColor = UIColor.greenColor()
            count++
            if (count > 1){
                let button: UIButton = UIButton()
                button.setImage(UIImage(named: "next"), forState: .Normal)
                button.frame = CGRectMake(0, 0, 25, 25)
                button.targetForAction("next:", withSender: self)
                button .addTarget(self, action: "next:", forControlEvents: UIControlEvents.TouchUpInside)
                
                rightItem.customView = button
                
                self.navigationItem.rightBarButtonItem = rightItem
            }

        }
        else
        {
            choice[indexPath.row+1] = ""
            cell.backgroundColor = UIColor.whiteColor()
            count--
            if(count < 2){
                if(!NSUserDefaults.standardUserDefaults().boolForKey("rect")){
                   
                    let button: UIButton = UIButton()
                    button.setImage(UIImage(named: "square"), forState: .Normal)
                    button.frame = CGRectMake(0, 0, 25, 25)
                    button.targetForAction("check:", withSender: self)
                    button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    rightItem.customView = button
                    
                    self.navigationItem.rightBarButtonItem = rightItem
                    self.pfCollection.reloadData()
                }
                else{
                   
                    let button: UIButton = UIButton()
                    button.setImage(UIImage(named: "rect"), forState: .Normal)
                    button.frame = CGRectMake(0, 0, 25, 25)
                    button.targetForAction("check:", withSender: self)
                    button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    rightItem.customView = button
                    
                    self.navigationItem.rightBarButtonItem = rightItem
                    self.pfCollection.reloadData()
                }

            }
        }
        
        
    }
    
    func next(sender: UIBarButtonItem){
        
    }
    
    func reset(){
        if(NSUserDefaults.standardUserDefaults().boolForKey("rect")){
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "rect"), forState: .Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.targetForAction("check:", withSender: self)
            button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
            rightItem.customView = button
            
            self.navigationItem.rightBarButtonItem = rightItem
            self.pfCollection.reloadData()
        }
        else{
            let button: UIButton = UIButton()
            button.setImage(UIImage(named: "square"), forState: .Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.targetForAction("check:", withSender: self)
            button .addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
            rightItem.customView = button
            
            self.navigationItem.rightBarButtonItem = rightItem
            self.pfCollection.reloadData()
        }
    }

    
    
}

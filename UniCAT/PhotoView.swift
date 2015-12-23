//
//  PhotoView.swift
//  SidebarMenu
//
//  Created by Munyee on 6/1/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Parse
import ParseUI

let reuseIdentifier = "photocell"

class PhotoView: PFQueryCollectionViewController{
    struct data{
        static var num : Int = 0
    }
    
    var selectedBuilding = ""
    
    @IBOutlet weak var nomedia: UILabel!
    var saveimage : UIImage!
    var num : Int = 0
    var pfFile  = [PFFile]()
    var text : [String] = []
    var objectid : [String] = []
    @IBOutlet var collection: UICollectionView!
    
    var refreshControl:UIRefreshControl!
    var scrollview : UIScrollView!
    var thisimage : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
    var label : UITextView = UITextView()
    var closeview : UIImageView = UIImageView(frame: CGRect(x: UIScreen.mainScreen().bounds.size.width-50, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80))
    var imagev :UIImageView = UIImageView(frame: CGRect(x: 0, y: 30, width: 20, height: 20))
    var reportview : UIImageView = UIImageView(frame: CGRect(x: UIScreen.mainScreen().bounds.size.width-100, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80))
    var imager :UIImageView = UIImageView(frame: CGRect(x: 0, y: 30, width: 20, height: 20))
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "Gallery"
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //If portrait
        if(UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
        {
            let image = UIImage(named: "close.png")
            let image1 = UIImage(named: "report.png")
            imagev.image = image
            imager.image = image1
            
            thisimage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-80)
            label.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width-100, height: 80)
            label.userInteractionEnabled = true
            label.editable = false
            label.font = UIFont(name: "Avenir Next", size: 14)
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.blackColor()
            reportview.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width-100, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80)
            reportview.backgroundColor = UIColor.blackColor()
            imagev.frame = CGRect(x: 0, y: 30, width: 20, height: 20)
            imager.frame = CGRect(x: 0, y: 30, width: 20, height: 20)
            closeview.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width-50, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80)
            closeview.backgroundColor = UIColor.blackColor()
            
            
        }
        //If landscape
        if(UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
        {
            
            thisimage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
            label.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width-100, height: 0)
            
            
        }
    }
    
   
    
    override func queryForCollection() -> PFQuery {
        print(selectedBuilding)
        let query = PFQuery(className: "Gallery")
        query.whereKey("venue", equalTo: selectedBuilding)
        query.whereKey("report", notEqualTo: "archived")
        return query
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func objectsWillLoad() {
        pfFile = [PFFile]()
        text = []
        objectid = []
        if(queryForCollection().countObjects(nil) != 0){
            nomedia.hidden = true
        }
        else
        {
            nomedia.hidden = false
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewControllerCell
        
        
        if let thumbnail = object?["image"] as? PFFile {
            cell.a.file = thumbnail
            pfFile.append(thumbnail)
            
            cell.a.loadInBackground()
        }
        
        if let textlabel = object?["description"] as? String{
            text.append(textlabel)
            
        }
        
        if let id = object?.objectId{
            objectid.append(id)
        }
        
        return cell
    }
    
    
    func close(sender: UISwipeGestureRecognizerDirection){
        thisimage.hidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.hidden = false
        self.collection.scrollEnabled = true
        label.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width-100, height: 0)
        imagev.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
        imager.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
        closeview.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
        reportview.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
        
    }
    
    func left(sender: UISwipeGestureRecognizer){
        print("swipe left")
        
        if(num == pfFile.count-1){
            num = 0
        }
        else if(num < pfFile.count-1){
            num++
        }
        
        
        
        print(num)
        let userImageFile = pfFile[num]
        label.text = text[num]
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.thisimage.image = image
                    
                }
            }
        }
        
        
    }
    
    func right(sender: UISwipeGestureRecognizer){
        print("swipe left")
        if(num == 0){
            num = pfFile.count-1
        }
        else if(num > 0){
            num--
        }
        
        
        
        print(num)
        let userImageFile = pfFile[num]
        label.text = text[num]
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.thisimage.image = image
                }
            }
        }
        
        
    }
    
    func alert(sender:UIView){
        let alertController = UIAlertController(title: "Report", message: "Reporting this image\nAre you sure?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
            //send reporting details
            let reportobject = PFQuery(className:"Gallery")
            reportobject.getObjectInBackgroundWithId(self.objectid[self.num]){
                (report: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let report = report {
                    report["report"] = "reported"
                    report.saveInBackground()
                }
            }
            
            let alert = UIAlertView(title: "Reported", message: "Thank you for your reporting.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print(pfFile[indexPath.row])
        let userImageFile = pfFile[indexPath.row]
        num = indexPath.row
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.thisimage.image = image
                }
            }
        }
        thisimage.hidden = false
        
        let image = UIImage(named: "close.png")
        let image1 = UIImage(named: "report.png")
        imagev.image = image
        imager.image = image1
        
        
        imagev.frame = CGRect(x: 0, y: 30, width: 20, height: 20)
        imager.frame = CGRect(x: 0, y: 30, width: 20, height: 20)
        
        
        closeview.addSubview(imagev)
        reportview.addSubview(imager)
        reportview.userInteractionEnabled = true
        closeview.userInteractionEnabled = true
        
        
        if(UIInterfaceOrientation.LandscapeLeft == UIApplication.sharedApplication().statusBarOrientation){
            
            
            thisimage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
            //Set label
            label.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width-100, height: 0)
            imagev.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
            imager.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
            closeview.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
            reportview.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width, height: 0)
        }
        else{
            
            thisimage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-80)
            
            label.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height-80, width: UIScreen.mainScreen().bounds.size.width-100, height: 80)
            reportview.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width-100, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80)
            reportview.backgroundColor = UIColor.blackColor()
            closeview.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width-50, y: UIScreen.mainScreen().bounds.size.height-80 , width: 50, height: 80)
            closeview.backgroundColor = UIColor.blackColor()
        }
        
        
        print(thisimage.frame)
        label.text = text[indexPath.row]
        label.userInteractionEnabled = true
        label.editable = false
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blackColor()
        print(text)
        //Set image gesture
        
        closeview.addSubview(imagev)
        reportview.addSubview(imager)
        
        thisimage.userInteractionEnabled = true
        let closeup = UISwipeGestureRecognizer(target: self, action: "close:")
        closeup.direction = UISwipeGestureRecognizerDirection.Up
        thisimage.addGestureRecognizer(closeup)
        
        let closedown = UISwipeGestureRecognizer(target: self, action: "close:")
        closedown.direction = UISwipeGestureRecognizerDirection.Down
        thisimage.addGestureRecognizer(closedown)
        
        
        let scrollLeft = UISwipeGestureRecognizer(target: self, action: "left:")
        scrollLeft.direction = UISwipeGestureRecognizerDirection.Left
        thisimage.addGestureRecognizer(scrollLeft)
        
        let scrollRight = UISwipeGestureRecognizer(target: self, action: "right:")
        scrollRight.direction = UISwipeGestureRecognizerDirection.Right
        thisimage.addGestureRecognizer(scrollRight)
        
        let tapclose = UITapGestureRecognizer(target: self, action: "close:")
        tapclose.numberOfTapsRequired = 1
        closeview.addGestureRecognizer(tapclose)
        
        
        let report = UITapGestureRecognizer(target: self, action: "alert:")
        report.numberOfTapsRequired = 1
        reportview.addGestureRecognizer(report)
        
        thisimage.contentMode = UIViewContentMode.ScaleAspectFit
        thisimage.backgroundColor = UIColor.blackColor()
        self.view.addSubview(thisimage)
        self.view.addSubview(label)
        self.view.addSubview(closeview)
        self.view.addSubview(reportview)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.hidden = true
        
        self.collection.scrollEnabled = false
        
        
    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width/3), (UIScreen.mainScreen().bounds.size.width/3))
    }
    
    @IBAction func addImage(sender: AnyObject) {
        self.performSegueWithIdentifier("addImage", sender: self)
    }
    
    
}
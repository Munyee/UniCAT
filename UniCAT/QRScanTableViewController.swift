//
//  BuildingDetails.swift
//  SidebarMenu
//
//  Created by Munyee on 5/22/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class QRScanTableViewController: PFQueryTableViewController  {
    
    var count = 0
    @IBOutlet var refresh: UIBarButtonItem!
    @IBOutlet var NameTableView: UITableView!
    var floor : [String] = ["Room Details","TimeTable"]
    
    //Array of Wroker Names
    var workerNames: [String] = ["",""]
    var check : [String] = ["",""]
    var height : [CGFloat] = [0,0,0]
    var buildingname = QRCodeViewController.QRname.name
    
    var empty = true
   

    
    struct data{
        static var num : Int = 0
    }
    
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "QRCode"
        
    }
    
    override func queryForTable() -> PFQuery {
        
        var query = PFQuery(className: "QRCode")
        query.whereKey("name", equalTo: QRCodeViewController.QRname.name)
       // query.fromLocalDatastore()
    
        return query
        
        
    }

    override func objectsDidLoad(error: NSError?) {
        if(queryForTable().countObjectsInBackground() == 0){
            
            var label = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
            label.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2-50)
            label.textAlignment = NSTextAlignment.Center
            label.text = "No Result Found"
            label.font = UIFont(name: "Avenir Next", size: 15)
            
            self.view.addSubview(label)
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var y : Int = 0
        var numb : Int = 0
        var count : Int = 0
        var screenWidth = UIScreen.mainScreen().bounds.width
        var screenHeight = UIScreen.mainScreen().bounds.height
        for(y = 0 ; y < check.count; y++){
            var query = PFQuery(className:"QRCode")
            query.whereKey("name", equalTo:buildingname)
            query.whereKey("room", equalTo: floor[count])
            //query.fromLocalDatastore()
        
            count++
            
            query.findObjectsInBackgroundWithBlock({(objects:[PFObject]?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    
                    
                    // Looping through the objects to get the names of the workers in each object
                    for object in objects! {
                        
                        
                        //Stringifying the name of the woker
                        var name_of_worker = object["details"] as! String
                        var name = object["room"] as! String
                        //Adding it to the array of Worker Names
                        self.workerNames[numb] = name_of_worker
                        self.check[numb] = name
                        
                        self.empty = false
                        numb++
                        self.tableView.reloadData()
                        
                        
                        
                        
                    }
                    super.objectsDidLoad(nil)
                   
                    
                }
                
                
            })
            
        }
        
        

        NameTableView.allowsMultipleSelectionDuringEditing = false
        NameTableView.tableFooterView = UIView(frame: CGRectZero)


    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(check[indexPath.row] == ""){
            return 0.0
        }
        else{
            return height[indexPath.section]
    
        }
    }
    
   

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

       
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(check[section] == ""){
            return nil
        }
        else{
            return floor[section]
    
        }
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var x : Int = 0
        var detailLabel : UITextView = UITextView(frame: CGRect(x: 8, y: 0, width: UIScreen.mainScreen().bounds.width, height: 60))
        
        var cell = self.NameTableView.dequeueReusableCellWithIdentifier("QRcell")
        
       
        
        for(x = 0 ; x < floor.count; x++){
            if(floor[x] == check[indexPath.section])
            {
                detailLabel.text = self.workerNames[x]
            }
        }
        detailLabel.font = UIFont(name: "Avenir Next", size: 14)
        detailLabel.sizeToFit()
        detailLabel.frame.size.width = UIScreen.mainScreen().bounds.width
        height[indexPath.section] = detailLabel.frame.size.height
        detailLabel.editable = false
        detailLabel.scrollEnabled = false
        cell!.addSubview(detailLabel)
        
        
        return cell!
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
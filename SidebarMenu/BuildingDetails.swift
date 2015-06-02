//
//  BuildingDetails.swift
//  SidebarMenu
//
//  Created by Munyee on 5/22/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import Parse
import UIKit

class BuildingDetails: UITableViewController  {
    
    
    @IBOutlet var refresh: UIBarButtonItem!
    @IBOutlet var NameTableView: UITableView!
    var floor : [String] = ["Ground Floor","First Floor","Second Floor","Third Floor","Fourth Floor"]
    
    //Array of Wroker Names
    var workerNames: [String] = ["","","","",""]
    var check : [String] = ["","","","",""]
    var height : [CGFloat] = [0,0,0,0,0]
    var buildingname = MapViewController.Name.nameof
    var postcode : Int = 31900
    var country : String = "Malaysia"
    
    struct data{
        static var num : Int = 0
    }
    
    
    func checkconnection(){
        var y : Int = 0
        var numb : Int = 0
        var count : Int = 0
        for(y = 0 ; y < check.count; y++){
            var query = PFQuery(className:"BuildingDetails")
            println(count)
            query.whereKey("name", equalTo:buildingname)
            query.whereKey("floor", equalTo: floor[count])
            query.whereKey("postcode", equalTo: postcode)
            query.whereKey("country", equalTo: country)
            count++
            query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    
                    // Looping through the objects to get the names of the workers in each object
                    for object in objects! {
                        
                        //Stringifying the name of the woker
                        var name_of_worker = object["details"] as! String
                        var name = object["floor"] as! String
                        //Adding it to the array of Worker Names
                        self.workerNames[numb] = name_of_worker
                        self.check[numb] = name
                        println(self.check)
                        println(numb)
                        numb++
                        self.tableView.reloadData()
                        
                        
                        
                        
                    }
                    NSLog("Done Load Data")
                }
                
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            println("Internet connection ok")
            checkconnection()
        }
        else
        {
            println("No internet connection")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
       
        
        
        
    
        NameTableView.allowsMultipleSelectionDuringEditing = false
        NameTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return height[indexPath.section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return MapViewController.Name.floor
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return floor[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var x : Int = 0
        var detailLabel : UITextView = UITextView(frame: CGRect(x: 8, y: 0, width: 320, height: 60))
        
        var cell = self.NameTableView.dequeueReusableCellWithIdentifier("TransportCell") as! UITableViewCell
        
        
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
        cell.addSubview(detailLabel)
        
        
        return cell
    }
    @IBAction func refresh(sender: AnyObject) {
        if(MapViewController.Name.floor == 0)
        {
            viewDidLoad()
        }
    }
   
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
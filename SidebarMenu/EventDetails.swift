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

class EventDetails: UITableViewController  {
    
    
    @IBOutlet var NameTableView: UITableView!
    
    //Array of Wroker Names
    var workerNames: [String] = []
    var buildingname = MapViewController.Name.nameof
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.workerNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        var cell = self.NameTableView.dequeueReusableCellWithIdentifier("TransportCell") as! UITableViewCell
        
        
        cell.textLabel!.text = self.workerNames[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var query = PFQuery(className:"Event")
        query.whereKey("venue", equalTo:buildingname)
        query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                
                
                // Looping through the objects to get the names of the workers in each object
                for object in objects! {
                    
                    //Stringifying the name of the woker
                    var name_of_worker = object["name"] as! String
                    //Adding it to the array of Worker Names
                    self.workerNames.append(name_of_worker)
                    println(self.workerNames)
                    
                    //reload the data
                    self.tableView.reloadData()
                    
                    
                }
                NSLog("Done Load Data")
            }
            
            
        })
    }
}
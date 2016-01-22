//
//  BuildingViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/24/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
import Foundation

class BuildingViewController: JPBFloatingTextViewController {
    
    var currentBuilding = ""
    var currentAlphabet = ""
    var eventCount = ""
    var type = 0
    var archive = 0
    var location:CLLocation = CLLocation(latitude: 0, longitude: 0)
    var colorArt = SLColorArt()
    
    let building = Building()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let image = UIImage(named: currentAlphabet)
        colorArt = (image?.colorArt())!
        
        self.setHeaderImage(image)
        
        tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        tableView.registerNib(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        
        
        self.setTitleText(currentBuilding)
        
        if currentBuilding == "Grand Hall" {
            self.setSubtitleText("Dewan Tun Ling Liong Sik")
        } else if currentAlphabet == "U" {
            self.setSubtitleText("Kampar, Perak")
        } else {
            self.setSubtitleText("Block " + currentAlphabet)
        }
        
        
        
        switch(currentAlphabet){
        case "A":
            location = CLLocation(latitude: 4.335357, longitude: 101.141050)
        case "B":
            location = CLLocation(latitude: 4.336641, longitude: 101.141069)
        case "C":
            location = CLLocation(latitude: 4.337290, longitude: 101.142339)
        case "D":
            location = CLLocation(latitude: 4.338071, longitude: 101.143580)
        case "E":
            location = CLLocation(latitude: 4.338780, longitude: 101.143479)
        case "F":
            location = CLLocation(latitude: 4.339766, longitude: 101.143608)
        case "G":
            location = CLLocation(latitude: 4.339929, longitude: 101.143061)
        case "H":
            location = CLLocation(latitude: 4.341391, longitude: 101.142968)
        case "I":
            location = CLLocation(latitude: 4.340802, longitude: 101.142486)
        case "J":
            location = CLLocation(latitude: 4.341213, longitude: 101.144216)
        case "K":
            location = CLLocation(latitude: 4.342081, longitude: 101.141268)
        case "L":
            location = CLLocation(latitude: 4.341819, longitude: 101.140305)
        case "M":
            location = CLLocation(latitude: 4.340561, longitude: 101.137677)
        case "N":
            location = CLLocation(latitude: 4.338680, longitude: 101.136600)
        case "P":
            location = CLLocation(latitude: 4.338530, longitude: 101.137182)
        case "O":
            location = CLLocation(latitude: 4.337456, longitude: 101.134147)
        default:
            break
            
        }
        
        
        
        //Self-sizing Cells
        tableView.estimatedRowHeight = 50.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        /*
        var button = UIButton()
        button.setTitle("BACK", forState: UIControlState.Normal)
        //button.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 20)
        button.frame = CGRectMake(5, 5, 100, 80)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: "dismissBuilding:", forControlEvents: .TouchUpInside)
        
        self.addHeaderOverlayView(button)
        */
        
        
        
        //countContainer.layer.cornerRadius = 15
        //profilePicture.layer.cornerRadius = 25
        
        //countContainer.hidden = true
        
    }
    /*
    func dismissBuilding(sender: UIButton!) {
    dismissViewControllerAnimated(true, completion: nil)
    println("Back to Map")
    }
    override func viewDidAppear(animated: Bool) {
    
    //self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.setToolbarHidden(true, animated: true)
    }
    */
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
//        return 6
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1:
            if eventCount != "0" {
                self.performSegueWithIdentifier("buildingToEvent", sender: nil)
            }
        case 2: // Direction to Here
            self.performSegueWithIdentifier("buildingtoNavigation", sender: nil)
            
        case 3: // Show on Map (TOFIX: Event to Building to Map)
            self.navigationController?.popViewControllerAnimated(true)
            
        case 4: //Photo Gallery
            archive = 0
            self.performSegueWithIdentifier("buildingToPhoto", sender: nil)
        case 5:
            archive = 1
            self.performSegueWithIdentifier("buildingToPhoto", sender: nil)
        case 6: //Past Events
            type = 1
            self.performSegueWithIdentifier("buildingToEvent", sender: nil)
        default:
            print("Selection Invalid")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell
            
            cell.selectionStyle = .None
            cell.detailText.text = building.buildingDetail(room: currentAlphabet)
            
            return cell
            
        case 1:
            if eventCount == "0" || eventCount == "o"{
                let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell
                
                cell.selectionStyle = .None
                cell.detailText.text = ""
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
                
                //cell.selectionStyle = .None
                cell.icon.image = UIImage(named: "event")
                cell.titleLabel.text = "Events"
                cell.count.text = eventCount
                
                if eventCount == "o" {
                    cell.countFrame.hidden = true
                }
                return cell
            }
            
            
            
            //        case 3:
            //            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            //
            //            //cell.selectionStyle = .None
            //            cell.icon.image = UIImage(named: "timetable")
            //            cell.titleLabel.text = "Timetable"
            //            cell.countFrame.hidden = true
            //
            //            return cell
            
        case 2:
            if(!Reachability.isConnectedToNetwork()){
                let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell
                
                cell.selectionStyle = .None
                cell.detailText.text = ""
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
                
                //cell.selectionStyle = .None
                cell.icon.image = UIImage(named: "direction")
                cell.titleLabel.text = "Direction to Here"
                cell.countFrame.hidden = true
                
                return cell
            }
            
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "where")
            cell.titleLabel.text = "Show on Map"
            cell.countFrame.hidden = true
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "gallery")
            cell.titleLabel.text = "Photo Gallery"
            cell.countFrame.hidden = true
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "gallery")
            cell.titleLabel.text = "Reported Image"
            cell.countFrame.hidden = true
            
            return cell
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell", forIndexPath: indexPath) as! SelectionTableViewCell
            
            cell.icon.image = UIImage(named: "timetable")
            cell.titleLabel.text = "Past Events"
            cell.countFrame.hidden = true
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell
            
            cell.selectionStyle = .None
            cell.detailText.text = ""
            
            return cell
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1 && (eventCount == "o" || eventCount == "0")) {
            return 0
        } else if (indexPath.row == 2 && !Reachability.isConnectedToNetwork()){
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "buildingToEvent" {
            let detailScene = segue.destinationViewController as! EventsTableViewController
            
            detailScene.selectedBuilding = currentAlphabet
            
            if type == 1 {
                detailScene.selection = 6
            } else {
                detailScene.selection = 5
            }
        }
        else if segue.identifier == "buildingToPhoto" {
            let photoScene = segue.destinationViewController as! PhotoView
            photoScene.selectedBuilding = currentBuilding
            
            if archive == 1{
                photoScene.archive = true
            }
            else{
                photoScene.archive = false
            }
            
            
        }
        else if segue.identifier == "buildingtoNavigation"{
            var navigationScene = segue.destinationViewController as! TCMapViewController
            navigationScene.staticimage = UIImage(named: currentAlphabet)
            navigationScene.location = location
            
        }
    }
}

//
//  QRDetailViewController.swift
//  UniCAT
//
//  Created by Munyee on 23/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class QRDetailViewController:JPBFloatingTextViewController {

    var timetable = ""
    var timetableArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "TimeTableTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeTableTableViewCell")
        tableView.registerNib(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayTableViewCell")
        tableView.registerNib(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        
        let image = UIImage(named: "placeholder")
        self.setHeaderImage(image)
        
        self.setTitleText(QRCodeViewController.QRname.name)
        
        let query = PFQuery(className:"QRCode")
        query.whereKey("name", equalTo: QRCodeViewController.QRname.name)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        if(object["Timetable"] != nil){
                            self.timetable = object["Timetable"] as! String
                        }
                        
                        
                        self.setTitleText(object["roomName"] as! String)
                        
                      
                        self.timetableArr = self.timetable.characters.split{$0 == "\n"}.map(String.init)
                        
                        self.setSubtitleText(object["details"] as! String)
                        let image = object["image"] as! PFFile
                        image.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    
                                    let image = UIImage(data:imageData)
                                    self.setHeaderImage(image)
                                   
                                     self.tableView.reloadData()
                                    
                                }
                            }
                        }
                       
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        tableView.estimatedRowHeight = 40.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Do any additional setup after loading the view.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(timetableArr.count == 0){
            return 1
        }
        else{
            return timetableArr.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            return UITableViewAutomaticDimension
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(timetableArr.count == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("NoDataTableViewCell", forIndexPath: indexPath) as! NoDataTableViewCell
            
            cell.selectionStyle = .None
            return cell
            
        }
        else if(timetableArr[indexPath.row] == "Monday:" || timetableArr[indexPath.row] == "Tuesday:" || timetableArr[indexPath.row] == "Wednesday:" || timetableArr[indexPath.row] == "Thursday:" || timetableArr[indexPath.row] == "Friday:" || timetableArr[indexPath.row] == "Saturday:" || timetableArr[indexPath.row] == "Sunday: " ){
            let cell = tableView.dequeueReusableCellWithIdentifier("DayTableViewCell", forIndexPath: indexPath) as! DayTableViewCell
            
            cell.selectionStyle = .None
            let day = timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.day.text = day[0]
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeTableTableViewCell", forIndexPath: indexPath) as! TimeTableTableViewCell
            
            let tempData = timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.selectionStyle = .None
            cell.time.text = tempData[0]
            cell.subject.text = tempData[1]
            return cell
        }
        
        
        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCellWithIdentifier("DayTableViewCell", forIndexPath: indexPath) as! DayTableViewCell
//            
//            cell.selectionStyle = .None
////            cell.detailText.text = timetable
//            
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimeTableTableViewCell", forIndexPath: indexPath) as! TimeTableTableViewCell
//            
//            cell.selectionStyle = .None
//            
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimeTableTableViewCell", forIndexPath: indexPath) as! TimeTableTableViewCell
//            
//            cell.selectionStyle = .None
//            
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimeTableTableViewCell", forIndexPath: indexPath) as! TimeTableTableViewCell
//            
//            cell.selectionStyle = .None
////            cell.detailText.text = ""
//            
//            return cell
//        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

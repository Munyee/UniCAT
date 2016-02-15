//
//  QRDetailViewController.swift
//  UniCAT
//
//  Created by Munyee on 23/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class TimeTableViewController:JPBFloatingTextViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
//        tableView.estimatedRowHeight = 40.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        
        
        self.tableView.registerNib(UINib(nibName: "BusTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "BusTimeTableViewCell")
        self.tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceTableViewCell")
        
        let tempImage = UIImage(named: "placeholder")
        self.setHeaderImage(tempImage)
        
        
        self.setHeaderImage(BuildingViewController.timeTable.image)
        self.setTitleText(BuildingViewController.timeTable.name)
        self.setSubtitleText(BuildingViewController.timeTable.cap)
        
        
        
        view.bringSubviewToFront(tableView)
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(BuildingViewController.timeTable.timetableArr.count == 0){
            return 1
        }
        else{
            return BuildingViewController.timeTable.timetableArr.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(BuildingViewController.timeTable.timetableArr[indexPath.row] == "Eastlake:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Westlake Homes:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Harvard & Cambridge:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "CK Optical Shop:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Taman Mahsuri Impian:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Standford:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Kampar Bus Station:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Kampar Railway Station:" ){
            return 65
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(BuildingViewController.timeTable.timetableArr[indexPath.row] == "Eastlake:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Westlake Homes:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Harvard & Cambridge:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "CK Optical Shop:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Taman Mahsuri Impian:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Standford:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Kampar Bus Station:" || BuildingViewController.timeTable.timetableArr[indexPath.row] == "Kampar Railway Station:" ){
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceTableViewCell", forIndexPath: indexPath) as! PlaceTableViewCell
            
            cell.selectionStyle = .None
            let day = BuildingViewController.timeTable.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.place.text = day[0]
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("BusTimeTableViewCell", forIndexPath: indexPath) as! BusTimeTableViewCell
            
            let tempData = BuildingViewController.timeTable.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.selectionStyle = .None
            cell.leaving.text = tempData[0]
            cell.departure.text = tempData[1]
            cell.arriving.text = tempData[2]
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

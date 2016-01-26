//
//  QRDetailViewController.swift
//  UniCAT
//
//  Created by Munyee on 23/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class QRDetailViewController:JPBFloatingTextViewController {

    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        tableView.estimatedRowHeight = 70.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        
        
        self.tableView.registerNib(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TimeTableTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeTableTableViewCell")
        self.tableView.registerNib(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayTableViewCell")
        
        let tempImage = UIImage(named: "placeholder")
        self.setHeaderImage(tempImage)
        
        
        self.setHeaderImage(QRCodeViewController.QRname.image)
        self.setTitleText(QRCodeViewController.QRname.name)
        self.setSubtitleText(QRCodeViewController.QRname.cap)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        view.bringSubviewToFront(tableView)
        
        // Do any additional setup after loading the view.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(QRCodeViewController.QRname.timetableArr.count == 0){
            return 1
        }
        else{
            return QRCodeViewController.QRname.timetableArr.count
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(QRCodeViewController.QRname.timetableArr.count == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("NoDataTableViewCell", forIndexPath: indexPath) as! NoDataTableViewCell
            
            cell.selectionStyle = .None
            return cell
            
        }
        else if(QRCodeViewController.QRname.timetableArr[indexPath.row] == "Monday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Tuesday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Wednesday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Thursday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Friday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Saturday:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Sunday: " ){
            let cell = tableView.dequeueReusableCellWithIdentifier("DayTableViewCell", forIndexPath: indexPath) as! DayTableViewCell
            
            cell.selectionStyle = .None
            let day = QRCodeViewController.QRname.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.day.text = day[0]
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeTableTableViewCell", forIndexPath: indexPath) as! TimeTableTableViewCell
            
            let tempData = QRCodeViewController.QRname.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
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
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

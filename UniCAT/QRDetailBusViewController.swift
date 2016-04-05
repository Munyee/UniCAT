//
//  QRDetailBusViewController.swift
//  UniCAT
//
//  Created by Munyee on 05/04/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class QRDetailBusViewController: JPBFloatingTextViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.registerNib(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        self.tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceTableViewCell")
        self.tableView.registerNib(UINib(nibName: "BusTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "BusTimeTableViewCell")
        self.tableView.estimatedRowHeight = 41.7;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        
        
        
        
        let tempImage = UIImage(named: "placeholder")
        self.setHeaderImage(tempImage)
        
        
        self.setHeaderImage(QRCodeViewController.QRname.image)
        self.setTitleText(QRCodeViewController.QRname.name)
        self.setSubtitleText(QRCodeViewController.QRname.cap)
        
        
        
        
        
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
        else if(QRCodeViewController.QRname.timetableArr[indexPath.row] == "Eastlake:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Kampar Bus Station:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Kampar Railway Station:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Standford:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "CK Optical Shop:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Taman Mahsuri Impian:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Harvard & Cambridge:" || QRCodeViewController.QRname.timetableArr[indexPath.row] == "Westlake Homes:"){
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceTableViewCell", forIndexPath: indexPath) as! PlaceTableViewCell
            
            cell.selectionStyle = .None
            let day = QRCodeViewController.QRname.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.place.text = day[0]
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("BusTimeTableViewCell", forIndexPath: indexPath) as! BusTimeTableViewCell
            
            let tempData = QRCodeViewController.QRname.timetableArr[indexPath.row].characters.split{$0 == ":"}.map(String.init)
            cell.selectionStyle = .None
            cell.leaving.text = tempData[0]
            cell.departure.text = tempData[1]
            cell.arriving.text = tempData[2]
            return cell
        }
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

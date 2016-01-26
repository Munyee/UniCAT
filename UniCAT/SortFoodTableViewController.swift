//
//  UserFavFoodTableView.swift
//  UniCAT
//
//  Created by Academy_P8 on 21/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit

class SortFoodTableViewController: PFQueryTableViewController {
    var color : [SLColorArt] = []
    var arrCommon = Set<PFObject>()
    var arrUncommon = Set<PFObject>()
    
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.loadingViewEnabled = false
        self.loading = false
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "FoodCaterogy"
        
    }
    
    override func objectsDidLoad(error: NSError?) {
        
        for var index = 0; index < tableView.numberOfRowsInSection(0); index++ {
            
        }
        
        if(queryForTable().countObjects(nil) != 0){
            for object in objects!{
                arrCommon.insert(object as! PFObject)
                color.append(SLColorArt())
            }
            tableView.reloadData()
        }
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
        headerCell.backgroundColor = UIColor.lightGrayColor()
        headerCell.headerLabel.textColor = UIColor.whiteColor()
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Common Food";
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Uncommon Food";
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other";
        }
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    override func queryForTable() -> PFQuery {
        //        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editFood:")
        //
        //        self.navigationItem.title = "Food Category"
        //        self.navigationController?.setToolbarHidden(true, animated: true)
        //        self.navigationItem.rightBarButtonItem = editButton
        //
        //
        let query = PFQuery(className: "FoodCaterogy")
        
        return query
    }
    
    func editFood(sender:UIButton) {
        
        self.performSegueWithIdentifier("editFood", sender: self)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return arrCommon.count
        }
        else{
            return arrUncommon.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("food",forIndexPath:  indexPath) as! UserFavFoodTableViewCell
        
        
        
        let image = object?["image"] as? PFFile
        let name = object?["Category"] as? String
        
        cell.category.text = name
        cell.userImage.file = image
        cell.userImage.loadInBackground { (UIImage image, NSError error) -> Void in
            if (error == nil){
                let color = self.color[indexPath.row]
                if(color.backgroundColor != nil){
                    cell.setup(color)
                    cell.category.textColor = color.primaryColor
                }
                else{
                    let color = (image?.colorArt())!
                    self.color[indexPath.row] = color
                    cell.setup(color)
                    cell.category.textColor = color.primaryColor
                }
            }
        }
        
        return cell
    }
    
    
    
    
}
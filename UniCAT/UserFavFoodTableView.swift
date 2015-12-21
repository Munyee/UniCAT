//
//  UserFavFoodTableView.swift
//  UniCAT
//
//  Created by Academy_P8 on 21/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit

class UserFavFoodTableView: PFQueryTableViewController {
    var color : [SLColorArt] = []
    
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.loadingViewEnabled = false
        self.loading = false
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "UserFavouriteFood"
        
    }
    
    override func objectsDidLoad(error: NSError?) {
        for var index = 0; index < tableView.numberOfRowsInSection(0); index++ {
            color.append(SLColorArt())
        }
    }
    
    
    override func queryForTable() -> PFQuery {
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editFood:")
        
        self.navigationItem.title = "Food Category"
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationItem.rightBarButtonItem = editButton
        

        let query = PFQuery(className: "UserFavouriteFood")
        query.whereKey("UserId", equalTo: PFUser.currentUser()!)
        query.includeKey("Food")
        
        return query
    }
    
    func editFood(sender:UIButton) {
      
            self.performSegueWithIdentifier("editFood", sender: self)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("food",forIndexPath:  indexPath) as! UserFavFoodTableViewCell
        
        let food = object?["Food"] as? PFObject
        
        let image = food?["image"] as? PFFile
        let name = food?["Category"] as? String
        
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
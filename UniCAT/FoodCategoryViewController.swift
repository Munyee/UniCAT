//
//  FoodCategoryViewController.swift
//  UniCAT
//
//  Created by Munyee on 19/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit


class FoodCategoryViewController: PFQueryCollectionViewController{
    
//    var dismissDelegate: DismissViewDelegate?
    
    var count = 0
    var color : [SLColorArt] = []
    var choice : [String] = []
    var choose : [String] = []
    var foodCategory : [PFObject] = []
    
    
   
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.loadingViewEnabled = true
        self.loading = true
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "FoodCaterogy"
        
    }
    
    override func objectsWillLoad() {
        for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
            color.append(SLColorArt())
            choice.append("")
            choose.append("")
        }
    }
    
    override func objectsDidLoad(error: NSError?) {
        let skipButton : UIBarButtonItem = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.Plain, target: self, action: "skip:")
        self.navigationItem.rightBarButtonItem = skipButton
        color.removeAll()
        choice.removeAll()
        choose.removeAll()
        for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
            color.append(SLColorArt())
            choice.append("")
            choose.append("")
        }
        self.collectionView?.reloadData()
    }
    
    
    
    override func queryForCollection() -> PFQuery {
        
        let query = PFQuery(className: "FoodCaterogy")
        query.orderByAscending("Category")
        //        query.whereKey("role", equalTo: "join")
        return query
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("foodCategory", forIndexPath: indexPath) as! FoodCategoryViewCell
        
        
        let image = object?["image"] as? PFFile
        let label = object?["Category"] as? String
        cell.category.text = label
        cell.userImage.file = image
        cell.cellWidth.constant = self.view.frame.size.width-4
        cell.userImage.loadInBackground { (UIImage image, NSError error) -> Void in
            if ((error == nil))
            {
                let color = self.color[indexPath.row];
                if(color.backgroundColor != nil){
                    cell.setup(color)
                    cell.category.textColor = color.primaryColor
                }
                else{
                    let color = (image?.colorArt())!
                    self.color[indexPath.row] = color
                    self.foodCategory.append(object!)
                    self.choose[indexPath.row] = (object?.objectId)!
                    cell.setup(color)
                    cell.category.textColor = color.primaryColor
                }
            }
        };
        
        self.collectionView?.allowsMultipleSelection = true
        
        if(cell.selected){
            cell.backgroundColor = UIColor.greenColor()
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FoodCategoryViewCell
        
        if(choice[indexPath.row] == ""){
            choice[indexPath.row] = choose[indexPath.row]
            cell.backgroundColor = UIColor.greenColor()
            count++
            let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save:")
            self.navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width), 136)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FoodCategoryViewCell
        
        if(choice[indexPath.row] != ""){
            choice[indexPath.row] = ""
            cell.backgroundColor = UIColor.whiteColor()
            count--
        }
        
        if(count == 0){
            let skipButton : UIBarButtonItem = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.Plain, target: self, action: "skip:")
            self.navigationItem.rightBarButtonItem = skipButton
        }
        
        
        
    }
    
    func skip(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func save(sender:UIButton){
        let currentuser = PFUser.currentUser()
        let query = PFQuery(className: "UserFavouriteFood")
        query.whereKey("UserId", equalTo:currentuser!)
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                if(objects!.count == 0){
                    for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
                        if(self.choice[index] != ""){
                            let favourite = PFObject(className:"UserFavouriteFood")
                            favourite["UserId"] = PFUser.currentUser()
                            favourite["Food"] = self.foodCategory[index]
                            favourite.saveEventually()
                        }
                        
                        if( index == (self.collectionView?.numberOfItemsInSection(0))!-1){
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                    }
                }
                
                
                if let objects = objects{
                    for object in objects{
                        object.deleteInBackgroundWithBlock({ (Bool success, NSError error) -> Void in
                            
                        })
                        
                        if (object.objectId == objects[objects.count-1].objectId){
                            for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
                                if(self.choice[index] != ""){
                                    let favourite = PFObject(className:"UserFavouriteFood")
                                    favourite["UserId"] = PFUser.currentUser()
                                    favourite["Food"] = self.foodCategory[index]
                                    favourite.saveEventually()
                                }
                                
                                if( index == (self.collectionView?.numberOfItemsInSection(0))!-1){
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
    }

}
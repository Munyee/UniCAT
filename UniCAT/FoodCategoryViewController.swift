//
//  FoodCategoryViewController.swift
//  UniCAT
//
//  Created by Munyee on 19/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation

class FoodCategoryViewController: PFQueryCollectionViewController{
    
    var count : [Int32] = [];
    var color : [SLColorArt] = []
    
    
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
        }
    }
    
    override func objectsDidLoad(error: NSError?) {
        color.removeAll()
        for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
            color.append(SLColorArt())
        }
        self.collectionView?.reloadData()
    }
    
    
    
    override func queryForCollection() -> PFQuery {
        
        let query = PFQuery(className: "FoodCaterogy")
        query.orderByAscending("Category")
        //        query.whereKey("role", equalTo: "join")
        if(PFUser.currentUser() == nil){
            query.whereKey("nodata", equalTo: "nodata")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        //        query.whereKey("coordination", nearGeoPoint: userSelectViewController.userlocation, withinKilometers: 1)
        
        return query
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("foodCategory", forIndexPath: indexPath) as! FoodCategoryViewCell
        
        
        let image = object?["image"] as? PFFile
        let label = object?["Category"] as? String
        cell.category.text = label
        cell.userImage.file = image
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
                    cell.setup(color)
                    cell.category.textColor = color.primaryColor
                }
//                    if(self.count[indexPath.row] == 0){
//                    cell.setup()
//                    self.count[indexPath.row] = 1
//                }
            }
        };
        
//        if(cell.count < 2){
//            cell.setup()
//        }
        
//        if (indexPath.row == self.pfCollection.numberOfItemsInSection(0)-1) {
//            
//            self.pfCollection.hidden = false
//            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//        }
//        
//        
//        if (cell.selected || choice[indexPath.row+1] != "" ) {
//            cell.backgroundColor = UIColor.greenColor()
//        }
//        else
//        {
//            cell.backgroundColor = UIColor.whiteColor()
//        }
//        
//        
//        //        }
//        
//        self.pfCollection.allowsMultipleSelection = true
        
        return cell
    }

}
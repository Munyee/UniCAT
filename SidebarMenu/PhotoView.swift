//
//  PhotoView.swift
//  SidebarMenu
//
//  Created by Munyee on 6/1/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Parse
import ParseUI

let reuseIdentifier = "photocell"

class PhotoView: PFQueryCollectionViewController{
    struct data{
        static var num : Int = 0
    }
    
    var saveimage : UIImage!
    var num : Int = 0
    var pfFile  = [PFFile]()
    
    @IBOutlet var collection: UICollectionView!
    
    var refreshControl:UIRefreshControl!
    var scrollview : UIScrollView!
    
    
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        //self.objectsPerPage = 25
        
        self.parseClassName = "Gallery"
        
    }
    
    
    func checkconnection(){
            }

    
    override func viewDidLoad() {
        checkconnection()
        super.viewDidLoad()
    }
    
    override func queryForCollection() -> PFQuery {
        var query = PFQuery(className: "Gallery")
        query.whereKey("venue", equalTo: MapViewController.Name.nameof)
        return query
    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        

        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewControllerCell
        
        
        if let thumbnail = object?["image"] as? PFFile {
            cell.a.file = thumbnail
            cell.a.loadInBackground()
        }
        
        return cell
    }
    

    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width/3), (UIScreen.mainScreen().bounds.size.width/3))
    }
    
    @IBAction func addImage(sender: AnyObject) {
        self.performSegueWithIdentifier("addImage", sender: self)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
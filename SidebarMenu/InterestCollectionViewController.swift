//
//  InterestCollectionViewController.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/10/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//
/*
import Foundation
import UIKit
import Realm

class InterestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "cell"
    
    var primaryInterest = 0
    var interest = InterestList()
    var interests = RLMArray(objectClassName: Interest.className())
    var selectedInterest: Interest!
    var selectedInterests = Set<Interest>()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    func populateDefaultInterests() {
        interests.removeAllObjects()
        interests.addObjects(Interest.allObjects())
        
        if interests.count == 0 {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            for (interestName, interestID) in interest.interestArray {
                let newInterest = Interest()
                newInterest.name = interestName
                newInterest.id = interestID
                realm.addObject(newInterest)
            }
            
            realm.commitWriteTransaction()
            
            interests.removeAllObjects()
            interests.addObjects(Interest.allObjects())
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        
        populateDefaultInterests()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.collectionView
        println("Data reloaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapDetected(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            var p = sender.locationInView(collectionView)
            var indexPath = collectionView?.indexPathForItemAtPoint(p)
            
            let animation = CATransition()
            
            animation.duration = 0.2
            animation.type = kCATransitionFade
            animation.delegate = self
            
            if (indexPath != nil) {
                let cell = collectionView?.cellForItemAtIndexPath(indexPath!) as! InterestCollectionViewCell
                cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                cell.interestFrame.layer.addAnimation(animation, forKey: nil)
                cell.interestImage.layer.addAnimation(animation, forKey: nil)
                
                if sender.numberOfTapsRequired == 2 {
                    if primaryInterest == 0 {
                        cell.interestImage.tintColor = UIColor.whiteColor()
                        cell.interestFrame.layer.borderColor = UIColor(red: 20/255, green: 82/255, blue: 227/255, alpha: 1.0).CGColor
                        cell.interestFrame.backgroundColor = UIColor(red: 20/255, green: 82/255, blue: 227/255, alpha: 1.0)
                        primaryInterest = 1
                        
                        println("Primary Interest: \((cell.interestName.text?.capitalizedString)!)")
                        
                        selectedInterest = interests[UInt(indexPath!.item)] as! Interest
                        if selectedInterests.contains(interests[UInt(indexPath!.item)] as! Interest) {
                            selectedInterests.remove(interests[UInt(indexPath!.item)] as! Interest)
                        }
                        
                        println(selectedInterest.name)
                    }
                } else {
                    if cell.interestImage.tintColor == UIColor.whiteColor() {
                        if cell.interestFrame.backgroundColor == UIColor(red: 20/255, green: 82/255, blue: 227/255, alpha: 1.0) {
                            primaryInterest = 0
                        }
                        
                        cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
                        cell.interestImage.tintColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
                        cell.interestFrame.backgroundColor = UIColor.clearColor()
                        
                        println("Deselected \((cell.interestName.text?.capitalizedString)!)")
                        
                        if selectedInterests.contains(interests[UInt(indexPath!.item)] as! Interest) {
                            selectedInterests.remove(interests[UInt(indexPath!.item)] as! Interest)
                        }
                        
                    } else {
                        cell.interestImage.tintColor = UIColor.whiteColor()
                        cell.interestFrame.layer.borderColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0).CGColor
                        cell.interestFrame.backgroundColor = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1.0)
                        
                        println("Selected \((cell.interestName.text?.capitalizedString)!)")
                        
                        selectedInterests.insert(interests[UInt(indexPath!.item)] as! Interest)
                        println(selectedInterests)
                    }
                }
            }
        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interest.totalInterest()
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        let interestObj = interests.objectAtIndex(UInt(indexPath.row)) as! Interest
        
        //2
        cell.interestFrame.layer.cornerRadius = 35
        cell.interestFrame.layer.borderWidth = 1
        cell.interestFrame.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1.0).CGColor
        cell.interestImage.image = cell.interestImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        //var interestText = interest.interestArray[indexPath.item].uppercaseString
        //cell.interestName.text = interestText
        
        cell.interestName.text = interestObj.name.uppercaseString
        cell.interestImage.image = UIImage(named: interest.imageArray[indexPath.item])
        
        return cell
    }
    

}

*/
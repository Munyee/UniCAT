//
//  DetailViewController.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 3/27/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//
/*
import UIKit

var event1 = 0
var event2 = 0

class DetailViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var addDetailButton: UIBarButtonItem!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!

    
    var favourite = 0
    var events = Event()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if event == 1 {
            if event2 == 1 {
                favourite = 1
                favouriteButton.image = UIImage(named: "Favourite Selected")
            }
        } else {
            if event1 == 1 {
                favourite = 1
                favouriteButton.image = UIImage(named: "Favourite Selected")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if event == 1 {
            if indexPath.row == 0 {
                let cover = tableView.dequeueReusableCellWithIdentifier("Cover", forIndexPath: indexPath) as! DetailViewCell
                
                cover.coverPhoto.image = UIImage(named: "Cover")
                cover.eventTitle.text = "IT Fair 2015"
                cover.eventSubtitle.text = "IT Products and Services"
                cover.countDown.text = "In 4 days"
                
                return cover
            }
        } else {
        
        if indexPath.row == 0 {
            let cover = tableView.dequeueReusableCellWithIdentifier("Cover", forIndexPath: indexPath) as! DetailViewCell
            
            cover.coverPhoto.image = UIImage(named: "Cover")
            cover.eventTitle.text = "S.O.U.L. 2015"
            cover.eventSubtitle.text = "Photography Exhibition"
            cover.countDown.text = "In 8 days"
            
            return cover
        }
        }
        
        if indexPath.row == 1 {
            let text = tableView.dequeueReusableCellWithIdentifier("Text", forIndexPath: indexPath) as! DetailViewCell
            text.textContent.text = "Hello all awesome UTARians"
            return text
        } else if indexPath.row == 2 {
            let text = tableView.dequeueReusableCellWithIdentifier("Text", forIndexPath: indexPath) as! DetailViewCell
            text.textContent.text = "UTAR Photography Society will be organizing the annual photography exhibition which to show the Stories of UTARians' Lens (S.O.U.L)."
            return text
        } else if indexPath.row == 3 {
            let photo = tableView.dequeueReusableCellWithIdentifier("Photo", forIndexPath: indexPath) as! DetailViewCell
            return photo
        }
        
        let detail = tableView.dequeueReusableCellWithIdentifier("Detail", forIndexPath: indexPath) as! DetailViewCell
        return detail
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 300
        }
        
        if indexPath.row == 2 {
            return 150
        }
        
        if indexPath.row == 3 {
            return 320
        }
        
        if indexPath.row == 4 {
            return 243
        }
        
        return 50
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func favouriteToggle(sender: AnyObject) {
        if favourite == 0 {
            favourite = 1
            favouriteButton.image = UIImage(named: "Favourite Selected")
            if event == 0 {
                favCount1++
                event1 = 1
            } else {
                favCount2++
                event2 = 1
            }
            favCount++
        } else {
            favourite = 0
            favouriteButton.image = UIImage(named: "Favourite")
            if event == 0 {
                favCount1--
                event1 = 0
            } else {
                favCount2--
                event2 = 0
            }
            favCount--
        }
        
    }
    
    @IBAction func addDetailPressed(sender: AnyObject) {
        
    }
    
    @IBAction func moreButton(sender: AnyObject) {
        
    }
}
*/
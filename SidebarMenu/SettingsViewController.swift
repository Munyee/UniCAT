//
//  SettingsViewController.swift
//  SidebarMenu
//
//  Created by Munyee on 5/24/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit


let annotationkey = "anno"

class SettingsViewController : UITableViewController {
    
    @IBOutlet var white: UITableViewCell!
    @IBOutlet var black: UITableViewCell!
    
    @IBOutlet var NameTableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    var isShowingList : Bool = Bool()
    var selectedValueIndex : Int = 0
    var annotation : Int = 2
    
    var annotationchoice : NSString = ""
    
    
    func loadGameData() {
        // getting path to GameData.plist
        
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("userinfo.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("userinfo", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("GameData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        var dict = NSDictionary(contentsOfFile: path)
        MapViewController.Name.imageview = dict?.objectForKey(annotationkey) as! NSString
        
    }
    
    override func viewDidLoad() {
    
        loadGameData()
        var path : NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        white.textLabel!.text = "White"
        black.textLabel!.text = "Black"
        white.selectionStyle = UITableViewCellSelectionStyle.None
        black.selectionStyle = UITableViewCellSelectionStyle.None
        if(MapViewController.Name.imageview == "White"){
            white.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            black.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var row:Int = indexPath.row
        var x:Int = 0
        for(x = 0; x < 2; x++){
            if(x != indexPath.row)
            {
                var path : NSIndexPath = NSIndexPath(forRow: x, inSection: 0)
                if(indexPath.row == 0){
                    MapViewController.Name.imageview = "White"
                    white.accessoryType = UITableViewCellAccessoryType.Checkmark
                    black.accessoryType = UITableViewCellAccessoryType.None
                }
                else
                {
                    MapViewController.Name.imageview = "Black"
                    black.accessoryType = UITableViewCellAccessoryType.Checkmark
                    white.accessoryType = UITableViewCellAccessoryType.None
                }
                saveGameData()
                tableView.deselectRowAtIndexPath(path, animated: true)
                NSLog("%d",indexPath.row)
            }
            
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        let cell: UITableViewCell = NameTableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.None {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func saveGameData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("userinfo.plist")
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject(MapViewController.Name.imageview, forKey: annotationkey)
        //...
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Saved GameData.plist file is --> \(resultDictionary?.description)")
    }
    
}


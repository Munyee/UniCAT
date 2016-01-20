//
//  EditorTableViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/28/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit
class AddPhotoViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var photo: PFImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageCell: UITableViewCell!
    @IBOutlet weak var save: UIButton!
    
    let imagePicker = UIImagePickerController()
    var newImage = false
    var num : Int = 0
 
    func checkconnection(){
        if(Reachability.isConnectedToNetwork() == false){
            save.userInteractionEnabled = false
            save.backgroundColor = UIColor.lightGrayColor()
        }
        else{
            save.userInteractionEnabled = true
            save.backgroundColor = UIColor(red: 77/255, green: 185/255, blue: 82/255, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkconnection()
        
        
        let width = UIScreen.mainScreen().bounds.width
        imageCell.frame = CGRect(x: 0, y: 0, width: width, height: width)
        button.frame = CGRect(x: 0, y: 0, width: width, height: width)
        photo.frame = CGRect(x: 0, y: 0, width: width, height: width)
        imagePicker.delegate = self
        textField.text = MapViewController.Name.nameof
        textField.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
    }
    
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        textField.resignFirstResponder()
            textview.resignFirstResponder()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkconnection()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        photo.image = chosenImage
        newImage = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidEndEditing(textfield: UITextField){
        var query = PFQuery(className:"Gallery")
        query.whereKey("venue", equalTo:textField.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.num = objects!.count
            
            }
        }
       print(num)
    }
    
    @IBAction func addPhoto(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Launch Camera")
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker.cameraCaptureMode = .Photo
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
           
            
        })
        
        let libraryAction = UIAlertAction(title: "Choose Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Open Photos Library")
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func savePhoto(sender: AnyObject) {
        if (newImage && textField.text != ""){
            print("Save")
            let chosenImage = photo.image
            let imageData = UIImageJPEGRepresentation(chosenImage!,0.4)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            
            var imageobject = PFObject(className: "Gallery")
            
            imageobject["venue"] = textField.text
            imageobject["description"] = textview.text
            imageobject["image"] = imageFile
            imageobject["num"] = num+1
            if(Reachability.isConnectedToNetwork())
            {
                imageobject.saveInBackground()
                
            }else
            {
                imageobject.saveEventually()
            }
            
            
        }
        else
        {
            var alert :UIAlertView = UIAlertView()
            alert.title = "Alert!"
            alert.message = "Empty data"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
   
    @IBAction func cancel(sender: AnyObject) {
      
            
            dismissViewControllerAnimated(true, completion: nil)
       
            
    }
        
    
    
}

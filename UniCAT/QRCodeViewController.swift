//
//  QRCodeViewController.swift
//  SidebarMenu
//
//  Created by Munyee on 6/16/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var table = ""
    var object = Set<PFObject>()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel:UILabel!
    
    struct QRname{
        static var name = "";
        static var timetableArr = [String]()
        static var image = UIImage()
        static var cap = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        object.removeAll()
        qrCodeFrameView?.removeFromSuperview()
        captureSession?.startRunning()
        table = ""
        QRCodeViewController.QRname.name = ""
        QRCodeViewController.QRname.timetableArr.removeAll()
        QRCodeViewController.QRname.image = UIImage()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    
    override func viewDidLoad() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AVCaptureInput!
        do {
            input = try AVCaptureDeviceInput.init(device: captureDevice)
        }catch{
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
//         Set the input device on the capture session.
        captureSession?.addInput(input)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
       
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                //send to parse
                QRname.name = metadataObj.stringValue
                //perform segue
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewControllerWithIdentifier("QRdetails") 
//                self.presentViewController(vc, animated: true, completion: nil)

                captureSession?.stopRunning()
                
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.Indeterminate
                loadingNotification.labelText = "Fetching data"
                
                
                let code = QRCodeViewController.QRname.name
                
                //split html link
                let temptype = code.characters.split{$0 == "/"}.map(String.init)
                let type = temptype[2].characters.split{$0 == "="}.map(String.init)
                
                
                if(type[0] == "room?"){
                    let query = PFQuery(className:"QRCode")
                    query.whereKey("name", equalTo: type[1])
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                            
                            
                            
                            // The find succeeded.
                            print("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            if let objects = objects {
                                for object in objects {
                                    
                                    if(object["Timetable"] != nil){
                                        
                                    
                                        self.table = object["Timetable"] as! String
                                    }
                                    
                                    
                                    QRCodeViewController.QRname.name = object["roomName"] as! String
                                    
                                    QRCodeViewController.QRname.timetableArr = self.table.characters.split{$0 == "\n"}.map(String.init)
                                    
                                    
                                    QRCodeViewController.QRname.cap = object["details"] as! String
                                    
                                    let image = object["image"] as! PFFile
                                    image.getDataInBackgroundWithBlock {
                                        (imageData: NSData?, error: NSError?) -> Void in
                                        if error == nil {
                                            if let imageData = imageData {
                                                
                                      QRCodeViewController.QRname.image = UIImage(data:imageData)!
                                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                                                self.performSegueWithIdentifier("qrToDetails", sender: nil)
                                                
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                                if(objects.count == 0){
                                    let alert = UIAlertController(title: "Error", message: "No data found", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                                        switch action.style{
                                        case .Default:
                                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                            self.captureSession?.startRunning()
                                            
                                        case .Cancel:
                                            print("cancel")
                                            
                                        case .Destructive:
                                            print("destructive")
                                        }
                                    }))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                            }
                            
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                        
                    }
                }
                else if type[0] == "event?"{
                    let newString = type[1].stringByReplacingOccurrencesOfString("&", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    let query = PFQuery(className:"Event")
                    query.whereKey("name", equalTo: newString)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            if let objects = objects {
                                for item in objects {
                                    self.object.insert(item)
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    self.performSegueWithIdentifier("eventListToEventDetail", sender: nil)
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "eventListToEventDetail" {
            let detailScene = segue.destinationViewController as! DetailTableViewController
            for item in object{
                detailScene.currentObject = item
            }
            
            
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}
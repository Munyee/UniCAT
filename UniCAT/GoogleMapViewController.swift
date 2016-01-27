//
//  GoogleMapViewController.swift
//  UniCAT
//
//  Created by Munyee on 27/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GoogleMapViewController: UIViewController,JCTiledScrollViewDelegate,JCTileSource {

    
    struct Name{
        static var nameof = ""
        static var imageview : NSString = ""
        static var floor : Int = 0
        static var gallery : Int = 0
    }
    
    var first = Bool()
    var thelastone = CGFloat()
    var lastscale = CGFloat()
    var scale:CGFloat = 1
    
    let building = Building()
    var a = [SpringImageView()]
    let icon = UIImage(named: "overlay_park.png")
    let latmin = 4.332435;
    let latmax = 4.345159;
    let longmin = 101.133013;
    let longmax = 101.145641;
    var scrollView: JCTiledScrollView!
    var textlabel = UILabel()
    var tag:Int = 0
    var buildingObject = Set<PFObject>()
    var button = [UIButton()]
    
    var selectedBuilding = ""
    var selectedAlphabet = ""
    var selectedEventCount = ""
    var names:[String] = ["Heritage Hall","Learning Complex I","Student Pavilion I","Faculty of Science","FEGT","Administration Block","Library","FBF","Lecture Complex I","Engineering Workshop","Student Pavilion II","Lecture Complex II","Grand Hall","FICT & IPSR Lab","Sports Complex","FAS & ICS"]
    var alphabet:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P"]
    var eventcount: [String] = ["o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o"]
    var eventname : [String] = []
    
    func tiledScrollViewDidZoom(scrollView: JCTiledScrollView!) {
        scale = CGFloat(scrollView.zoomScale)
        
        for (var x = 0 ; x < names.count; x++){
            let object = self.buildingObject
            
                for item in object{
                    let building = item["name"] as! String
                    
                    if (building == self.names[x]){
                        let layer = item["layer"] as! String
                        if(Float(layer) > scrollView.zoomScale) {
                            self.a[x].hidden = true
                            self.button[x+1].hidden = true
                            
                        }
                        else {
                            self.a[x].hidden = false
                            self.button[x+1].hidden = false
                        }
                        break
                    }
                    
                
            }
            getButton(a[x])
            setButtonLocation(button[x+1])
        }
        first = false
        thelastone = scale

    }
    
    
    func tiledScrollView(scrollView: JCTiledScrollView!, didReceiveSingleTap gestureRecognizer: UIGestureRecognizer!) {
    let tapPoint:CGPoint = gestureRecognizer.locationInView(scrollView.tiledView)
    
    }
    
    func tiledScrollView(scrollView: JCTiledScrollView!, viewForAnnotation annotation: JCAnnotation!) -> JCAnnotationView! {
        
        let view:AnnotationView? = scrollView.dequeueReusableAnnotationViewWithReuseIdentifier(nil) as? AnnotationView;
        let view1:AnnotationView? = scrollView.dequeueReusableAnnotationViewWithReuseIdentifier(annotationReuseIdentifier) as? AnnotationView;
        
        
        if ( (view) == nil )
        {
            
        }
        
        return view;
    }
    
    
    
    func tiledScrollView(scrollView: JCTiledScrollView!, imageForRow row: Int, column: Int, scale: Int) -> UIImage! {
        
        let fileName:String = "Map_\(scale)x_\(row)_\(column).png";
        print(fileName);
        return UIImage(named: fileName)
        
    }
    
    
    override func viewDidLoad() {
        a = []
        first = true
        tag = 0
        super.viewDidLoad()
        
        

        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "gps"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 45, 45)
        button.targetForAction("actioncall", withSender: nil)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        
        let button1: UIButton = UIButton()
        
        button1.setImage(UIImage(named: "poi"), forState: .Normal)
        button1.frame = CGRectMake(0, 0, 45, 45)
        button1.targetForAction("actioncall", withSender: nil)
        button1.addTarget(self, action: "downloadSheet:", forControlEvents: .TouchUpInside)
        
        let rightItem1:UIBarButtonItem = UIBarButtonItem()
        rightItem1.customView = button1
        
        let array : Array = [rightItem1,rightItem];
        self.navigationItem.rightBarButtonItems = array
        
        
        let qrbutton: UIButton = UIButton()
        qrbutton.setImage(UIImage(named: "QR"), forState: .Normal)
        qrbutton.frame = CGRectMake(0, 0, 45, 45)
        qrbutton.targetForAction("actioncall", withSender: nil)
        qrbutton.addTarget(self, action: "activeQR:", forControlEvents: .TouchUpInside)
        
        let qrItem:UIBarButtonItem = UIBarButtonItem()
        qrItem.customView = qrbutton
        
        self.navigationItem.leftBarButtonItem = qrItem
        
        
        //get data
        let query = PFQuery(className:"Annotations")
        query.whereKey("type", equalTo:"building")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let image = SpringImageView()
                        self.a.append(image)
                        self.buildingObject.insert(object)
                        if self.buildingObject.count == objects.count{
                            self.checkconnection()
                        }
                    }
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
       
        
        
        
        scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf"))
        
        scrollView.tiledScrollViewDelegate = self
        scrollView.zoomScale = 1.0
        
        scrollView.dataSource = self
        scrollView.tiledScrollViewDelegate = self
        scrollView.tiledView.shouldAnnotateRect = true
        scrollView.levelsOfZoom = 1;
        scrollView.levelsOfDetail = 1;
        view.addSubview(scrollView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkconnection(){
        
        
        
        var temp : [String] = []
        var counter:Int = 0
        var check : Int = 0
        
        let query = PFQuery(className:"Event")
        let today = NSDate()
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        query.findObjectsInBackgroundWithBlock({(objects: [PFObject]?, error:NSError?) -> Void in
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Fetching data"
            
            // Looping through the objects to get the names of the workers in each object
            
            for object in objects! {
                
                //here to increase count if event++
                temp.append(object["venue"] as! String)
                
            }
            
            print(temp)
            
            NSLog("Done Load Data")
            self.eventname = temp
            counter++
            check++
            
            for(var y = 0 ; y < self.names.count; y++){
                
                var eventcounter:Int = 0
                for(var z = 0 ; z < self.eventname.count; z++){
                    let c : String = self.building.buildingName(room: self.eventname[z])
                    if(self.eventname[z] == self.names[y] || c == self.names[y]){
                        
                        eventcounter++
                        
                    }
                    self.eventcount[y] = String(eventcounter)
                    
                }
                if(y == self.names.count-1){
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    let object = self.buildingObject
                        
                        for (var y = 0 ; y < self.names.count ; y++){
                            for item in object{
                                let building = item["name"] as! String
                                let coor = item["coordinate"] as! PFGeoPoint
                                
                                if (building == self.names[y]){
                                    
                                    let layer = item["layer"] as! String

                                    self.button.append(self.setButton(self.a[y], label: self.names[y], eventnum: self.eventcount[y], size: CGRect(x: ((coor.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - coor.latitude)/(self.latmax - self.latmin)) * 1000, width: 150, height: 50)))
                                
                                    if(Float(layer) > self.scrollView.zoomScale) {
                                        self.a[y].hidden = true
                                        self.button[y+1].hidden = true
                                        
                                    }
                                    else {
                                        self.a[y].hidden = false
                                        self.button[y+1].hidden = false
                                    }
                                    break
                                
                                }
                        
                        
                        }
                        
                       
                        
                    }
//                    var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addAnnotations"), userInfo: nil, repeats: false)
                }
            }
            
            
        })
    }

    
    func setButton( imageview : SpringImageView,label:String,eventnum:String,size:CGRect)->UIButton{
        
        
        tag++
        textlabel.text = label
        let button:UIButton = UIButton()
        button.frame = CGRect(x: size.origin.x-75 , y: size.origin.y-50 , width: 170, height: 50)
        button.tag = tag
        var annot:UIImageView = UIImageView()
        annot.frame = CGRectMake(0,0,150,50)
        var image:UIImage = UIImage()
        var image1:SpringImageView = SpringImageView()
        let label1 : UILabel = UILabel()
        if eventnum == "0" || eventnum == "o" {
            label1.frame = CGRect(x: 0, y: -2, width: 150, height: 50)
            label1.text = label
            label1.textAlignment = NSTextAlignment.Center
            label1.font = UIFont(name: "Avenir Next", size: 12)
            image = UIImage(named: "MapPinBlack")!
        } else {
            label1.frame = CGRect(x: 17, y: -2, width: 150, height: 50)
            label1.text = label
            label1.textAlignment = NSTextAlignment.Center
            label1.font = UIFont(name: "Avenir Next", size: 12)
            image = UIImage(named: "MapPinBlack-e")!
        }
        
    
        let event :UILabel = UILabel()
        image1 = imageview
        image1.alpha = 0.8
        annot = UIImageView(image:image)
        //image1.userInteractionEnabled = true
        //annot.userInteractionEnabled = true
        image1.frame = size
        image1.animation = "fadeIn"
        image1.curve = "easeIn"
        image1.duration = 2.5
        image1.animate()
        event.frame = CGRect(x: 1, y: -2, width: 30, height: 50)
        event.text = eventnum
        event.textAlignment = NSTextAlignment.Center
        event.font = UIFont(name: "Avenir Next", size: 12)
        
       
        label1.textColor = UIColor.whiteColor()
        event.textColor = UIColor.whiteColor()
        
        button.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        annot.addSubview(label1)
        
        if eventnum != "0" && eventnum != "o" {
            annot.addSubview(event)
        }
        
        image1.bounds = CGRect(x: 85, y: 50, width: 150, height: 50)
        image1.addSubview(annot)
        scrollView.scrollView.addSubview(image1)
        scrollView.scrollView.addSubview(button)
        return button
    }

    
    func pressed(sender: UIButton!) {
        
        //perform segue
        var x:Int = 0
        for(x = 0 ; x < names.count ; x++){
            if(sender.tag%names.count == 0){
                Name.nameof = names[names.count-1]
                selectedBuilding = names[names.count-1]
                selectedAlphabet = alphabet[names.count-1]
                selectedEventCount = eventcount[names.count-1]
                self.performSegueWithIdentifier("mapToBuilding", sender: nil)
                break
            }
            if(sender.tag%names.count == x+1){
                
                Name.nameof = names[x]
                
                /*
                var query = PFQuery(className:"Building")
                query.whereKey("name", equalTo:Name.nameof)
                query.findObjectsInBackgroundWithBlock({(objects:[PFQuery]?, error:NSError?) -> Void in
                
                if error == nil {
                
                
                // Looping through the objects to get the names of the workers in each object
                for object in objects! {
                
                Name.floor = object["floor"] as! Int
                
                
                }
                NSLog("Done Load Data")
                }
                
                
                })
                
                var gallery = PFQuery(className:"Gallery")
                gallery.whereKey("venue", equalTo:Name.nameof)
                gallery.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                // The find succeeded.
                Name.gallery = objects!.count
                
                }
                
                }
                */
                
                selectedBuilding = names[x]
                selectedAlphabet = alphabet[x]
                selectedEventCount = eventcount[x]
                self.performSegueWithIdentifier("mapToBuilding", sender: nil)
                break
            }
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapToBuilding" {
            let detailScene = segue.destinationViewController as! BuildingViewController
            
            detailScene.currentBuilding = selectedBuilding
            detailScene.currentAlphabet = selectedAlphabet
            detailScene.eventCount = selectedEventCount
        }
    }
    
    //Set the Annotation location
    func getButton(image:SpringImageView)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        print(scale)
        
        
//        if(image == useranno){
//            if(first == true){
//                
//                image.frame = CGRect(x:(image.frame.origin.x+13.5)/lastscale, y: (image.frame.origin.y+50)/lastscale,width: 27, height: 50)
//                image.frame = CGRect(x:(image.frame.origin.x*scale)-13.5, y: (image.frame.origin.y*scale)-50,width: 27, height: 50)
//                
//            }
//            else if(first == false)
//            {
//                image.frame = CGRect(x:(image.frame.origin.x+13.5)/thelastone, y: (image.frame.origin.y+50)/thelastone,width: 27, height: 50)
//                image.frame = CGRect(x:(image.frame.origin.x*scale)-13.5, y: (image.frame.origin.y*scale)-50,width: 27, height: 50)
//                
//                
//            }
//        }
//        else
//        {
            if(first == true){
                
                image.frame = CGRect(x:image.frame.origin.x/lastscale, y: image.frame.origin.y/lastscale,width: 150, height: 50)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
                
            }
            else if(first == false)
            {
                image.frame = CGRect(x:image.frame.origin.x/thelastone, y: image.frame.origin.y/thelastone,width: 150, height: 50)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
                
                
            }
//        }
        
    
        
        
        return image.frame
    }

    
    //Set Building's Button annotation when zoon
    func setButtonLocation(image:UIButton)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        
        if(first == true){
            image.frame = CGRect(x:(image.frame.origin.x+75)/lastscale, y: (image.frame.origin.y+50)/lastscale,width: 170, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-75, y: (image.frame.origin.y*scale)-50,width: 170, height: 50)
            
        }
        if(first == false)
        {
            image.frame = CGRect(x:(image.frame.origin.x+75)/thelastone, y: (image.frame.origin.y+50)/thelastone,width: 170, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-75, y: (image.frame.origin.y*scale)-50,width: 170, height: 50)
            
            
        }
        
        
        
        return image.frame
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

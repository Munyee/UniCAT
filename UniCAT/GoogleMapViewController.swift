//
//  GoogleMapViewController.swift
//  UniCAT
//
//  Created by Munyee on 27/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GoogleMapViewController: UIViewController,JCTiledScrollViewDelegate,JCTileSource,UIActionSheetDelegate {

    
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
    var lon = Double()
    var lat = Double()
    
    let building = Building()
    
    var buildingImage = [SpringImageView()]
    var atmImage = [SpringImageView()]
    
    var button = [UIButton()]
    var atmButton = [UIButton()]
    var arrButton = [[UIButton()]]
    var arrObject = [Set<PFObject>()]
    var arrImage = [[SpringImageView()]]
    
    var numtype = 0
    
    let icon = UIImage(named: "overlay_park.png")
    let latmin = 4.332435;
    let latmax = 4.345159;
    let longmin = 101.133013;
    let longmax = 101.145641;
    var scrollView: JCTiledScrollView!
    var textlabel = UILabel()
    var tag:Int = 0
    var busTag :Int = 0
    var atmTag :Int = 0
    var foodTag :Int = 0
    var clinicTag :Int = 0
    var washTag :Int = 0
    
    var initView = true
    var buildingObject = Set<PFObject>()
    var atmObject = Set<PFObject>()
    
    var count = [Int]()
    let allPOI = ["building", "bus", "atm", "food", "clinic","washroom"]
    var selectedBuilding = ""
    var selectedAlphabet = ""
    var selectedEventCount = ""
    var names:[String] = []
    var alphabet:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P"]
    var eventcount: [String] = []
    var eventname : [String] = []
    
    func tiledScrollViewDidZoom(scrollView: JCTiledScrollView!) {
        scale = CGFloat(scrollView.zoomScale)
        
        if (numtype == 0){
            for (var x = 0 ; x < names.count; x++){
                let object = self.buildingObject
                
                for item in object{
                    let building = item["name"] as! String
                    
                    if (building == self.names[x]){
                        let layer = item["layer"] as! String
                        if(Float(layer) > scrollView.zoomScale) {
                            self.buildingImage[x].hidden = true
                            self.button[x+1].hidden = true
                            
                        }
                        else {
                            self.buildingImage[x].hidden = false
                            self.button[x+1].hidden = false
                            self.buildingImage[x].animation = "fadeIn"
                            self.buildingImage[x].curve = "easeIn"
                            self.buildingImage[x].duration = 2.5
                            self.buildingImage[x].animate()
                        }
                        break
                    }
                    
                    
                }
                getButton(buildingImage[x])
                setButtonLocation(button[x+1])
            }
        }
        else{
            
                    for (var y = 0 ; y < arrImage[numtype].count-1 ; y++){
                            getButton(arrImage[numtype][y])
                            setButtonLocation(arrButton[numtype][y+1])
                        
                        
                    }
                    
            
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
    
    override func viewWillAppear(animated: Bool) {
        if(initView){
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Fetching data"
            initView = false
        }
        

    }
    
    override func viewDidLoad() {
       
        buildingImage = []
        first = true
        tag = 0
        super.viewDidLoad()
        
        for (var x = 0 ; x < 6 ; x++){
            let tempButton = [UIButton()]
            let tempObject = Set<PFObject>()
            let tempImage = [SpringImageView()]
            arrButton.insert(tempButton, atIndex: x)
            arrObject.insert(tempObject, atIndex: x)
            arrImage.insert(tempImage, atIndex: x)
            count.insert(0, atIndex: x)
        }
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "gps"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 45, 45)
        button.targetForAction("actioncall", withSender: nil)
//        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
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
        
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.lon = geoPoint!.longitude as Double
                self.lat = geoPoint!.latitude as Double
                print(self.lat)
                print(self.lon)
            }
        }
        
        //get data
        for (var a = 0 ; a < allPOI.count ; a++){
            let query = PFQuery(className:"Annotations")
            query.whereKey("type", equalTo:self.allPOI[a])
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    
                    // Do something with the found objects
                    if let objects = objects {
                        
                        for object in objects {
                            let type = object["type"] as! String
                            
                            
                            switch(type){
                            case "building":
                                let image = SpringImageView()
                                self.buildingImage.append(image)
                                self.eventcount.append("o")
                                let building = object["name"] as! String
                                self.names.append(building)
                                self.buildingObject.insert(object)
                                if self.buildingObject.count == objects.count{
                                    self.checkconnection()
                                }
                            case "bus":
                                let index = 1
                                let tempButton = [UIButton()]
                                self.arrButton.insert(tempButton, atIndex: index)
                                let image = SpringImageView()
                                self.arrImage[index].append(image)
                                self.arrObject[index].insert(object)
                                
                            case "atm":
                                let index = 2
                                let tempButton = [UIButton()]
                                self.arrButton.insert(tempButton, atIndex: index)
                                let image = SpringImageView()
                                self.arrImage[index].append(image)
                                self.arrObject[index].insert(object)
                                

                            case "food":
                                let index = 3
                                let tempButton = [UIButton()]
                                self.arrButton.insert(tempButton, atIndex: index)
                                let image = SpringImageView()
                                self.arrImage[index].append(image)
                                self.arrObject[index].insert(object)
                               

                            case "clinic":
                                let index = 4
                                let tempButton = [UIButton()]
                                self.arrButton.insert(tempButton, atIndex: index)
                                let image = SpringImageView()
                                self.arrImage[index].append(image)
                                self.arrObject[index].insert(object)
                                
                            case "washroom":
                                let index = 5
                                let tempButton = [UIButton()]
                                self.arrButton.insert(tempButton, atIndex: index)
                                let image = SpringImageView()
                                self.arrImage[index].append(image)
                                self.arrObject[index].insert(object)
                               
                            default:
                                break
                            }
                            
                        }
                        
                    }
                    
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
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
    

    func setpoi(imageview :SpringImageView,size:CGRect,item:String,tag:Int) -> UIButton{
        
        let button :UIButton = UIButton()
        button.frame = CGRect(x: size.origin.x-size.width/2, y: size.origin.y-size.height, width: size.width, height: size.height)
        button.tag = tag
//        button.backgroundColor = UIColor.blackColor()
        var annot : UIImageView = UIImageView()
        annot.frame = CGRectMake(0, 0, size.width, size.height)
        var image : UIImage = UIImage()
        var image1 : UIImageView = UIImageView()
        image1 = imageview
        image1.frame = size
        
        switch(item){
        case "bus":
            image = UIImage(named: "Bus")!
        case "atm":
            image = UIImage(named: "atm")!
        case "food":
            image = UIImage(named: "Food")!
        case "clinic":
            image = UIImage(named: "Clinic")!
        case "washroom":
            image = UIImage(named: "washroom")!
        default:
            break
        }
        
        image1.bounds = CGRect(x: size.width/2, y: size.height, width: size.width, height: size.height)
        annot = UIImageView(image:image)
        
        image1.addSubview(annot)
        scrollView.scrollView.addSubview(image1)
        scrollView.scrollView.addSubview(button)
        
        
        return button
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
                
                image.frame = CGRect(x:image.frame.origin.x/lastscale, y: image.frame.origin.y/lastscale,width: image.frame.width, height: image.frame.height)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: image.frame.width, height: image.frame.height)
                
            }
            else if(first == false)
            {
                image.frame = CGRect(x:image.frame.origin.x/thelastone, y: image.frame.origin.y/thelastone,width: image.frame.width, height: image.frame.height)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: image.frame.width, height: image.frame.height)
                
                
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
            image.frame = CGRect(x:(image.frame.origin.x+image.frame.width/2)/lastscale, y: (image.frame.origin.y+image.frame.height)/lastscale,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-image.frame.width/2, y: (image.frame.origin.y*scale)-image.frame.height,width: image.frame.width, height: image.frame.height)
            
        }
        if(first == false)
        {
            image.frame = CGRect(x:(image.frame.origin.x+image.frame.width/2)/thelastone, y: (image.frame.origin.y+image.frame.height)/thelastone,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-image.frame.width/2, y: (image.frame.origin.y*scale)-image.frame.height,width: image.frame.width, height: image.frame.height)
            
            
        }
        
        
        
        return image.frame
    }
    
    
    func setpoiLocation(image:UIButton)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        
        if(first == true){
            NSLog("First is true")
            image.frame = CGRect(x:(image.frame.origin.x+image.frame.width/2)/lastscale, y: (image.frame.origin.y+image.frame.height/2)/lastscale,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-image.frame.width/2, y: (image.frame.origin.y*scale)-image.frame.height,width: image.frame.width, height: image.frame.height)
            
            NSLog("LastScale:%f",thelastone)
        }
        if(first == false)
        {
            NSLog("First is false")
            image.frame = CGRect(x:(image.frame.origin.x+image.frame.width/2)/thelastone, y: (image.frame.origin.y+image.frame.height/2)/thelastone,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-image.frame.width/2, y: (image.frame.origin.y*scale)-image.frame.height,width: image.frame.width, height: image.frame.height)
            NSLog("LastScale:%f",thelastone)
        }
        
        
        
        return image.frame
    }
    
    
    func downloadSheet(sender: AnyObject)
    {
        scrollView.setZoomScale(1, animated: true)
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil , destructiveButtonTitle: nil, otherButtonTitles: "Building Details", "Bus Stop", "ATM", "Food", "Clinic","Wash Room")
        
        actionSheet.showInView(self.view)
    }
    
    
    func activeQR(sender:UIButton!){
        
        self.performSegueWithIdentifier("MapToQR", sender: nil)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
    
        numtype = buttonIndex
        
        if (buttonIndex == 0){
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                let object = self.buildingObject
                
                for item in object{
                    let building = item["name"] as! String
                    
                    if (building == self.names[actionx]){
                        let layer = item["layer"] as! String
                        if(Float(layer) > scrollView.zoomScale) {
                            self.buildingImage[actionx].hidden = true
                            self.button[actionx+1].hidden = true
                            
                        }
                        else {
                            self.buildingImage[actionx].hidden = false
                            self.button[actionx+1].hidden = false
                            self.buildingImage[actionx].animation = "fadeIn"
                            self.buildingImage[actionx].curve = "easeIn"
                            self.buildingImage[actionx].duration = 2.5
                            self.buildingImage[actionx].animate()
                        }
                        break
                    }
                    
                    
                }
                getButton(buildingImage[actionx])
                setButtonLocation(button[actionx+1])
            }
        }
        else{
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                buildingImage[actionx].hidden = true
                button[actionx].hidden = true
            }
        }
        
        
        
        if(count[buttonIndex] == 0){
            for item in self.arrObject[buttonIndex]{
                let type = item["type"] as! String
                let coor = item["coordinate"] as! PFGeoPoint
                
                
                self.arrButton[buttonIndex].append(self.setpoi(self.arrImage[buttonIndex][self.count[buttonIndex]], size: CGRect(x: ((coor.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - coor.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: type, tag: self.count[buttonIndex]))
                self.count[buttonIndex]++
            }
        }
        
        var check = 0
        var short = 0.0
        var point = PFGeoPoint()
        
        for (var c = 0 ; c < allPOI.count ; c++){
            
            if (c == buttonIndex){
                print(arrObject[c])
                
                for item in arrObject[c]{
                    
                    let coor = item["coordinate"] as! PFGeoPoint
                    let userpoint = PFGeoPoint(latitude: self.lat, longitude: self.lon)
                    let distance = coor.distanceInKilometersTo(userpoint)
                    print(distance)
                    
                    
                    if(short == 0){
                        short = distance
                        point = coor
                        check++
                    }
                    else{
                        if(distance < short){
                            short = distance
                            point = coor
                            check++

                        }
                        else{
                            check++
                        }
                    }
                    
                    
                    
                    if(check == arrObject[c].count){
                        let long = (CGFloat)((point.longitude - longmin) / (longmax - longmin) * 1000)
                        let lat = (CGFloat)((latmax - point.latitude) / (latmax - latmin) * 1000)
                        
                        scrollView.scrollView.setContentOffset(CGPoint(x: long - UIScreen.mainScreen().bounds.width/2, y: lat - UIScreen.mainScreen().bounds.height/2), animated: true)
                    }
                    
                    
                    
                    
                }
                
                
                
               
                
            }
            for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                
                if( c == buttonIndex){
                    
                    arrImage[c][y].hidden = false
                    arrButton[c][y+1].hidden = false
                    getButton(arrImage[c][y])
                    setButtonLocation(arrButton[c][y+1])
                    
                }
                
                else if(arrButton[c].count > 1){
                    arrImage[c][y].hidden = true
                    arrButton[c][y+1].hidden = true
                }
                
                
            }

            
        }
        
        
        
    }
    
    
    
    func checkconnection(){
        
        var temp : [String] = []
        var counter:Int = 0
        var check : Int = 0
        
        let query = PFQuery(className:"Event")
        let today = NSDate()
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        query.findObjectsInBackgroundWithBlock({(objects: [PFObject]?, error:NSError?) -> Void in
            
            
            
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
                                
                                self.button.append(self.setButton(self.buildingImage[y], label: self.names[y], eventnum: self.eventcount[y], size: CGRect(x: ((coor.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - coor.latitude)/(self.latmax - self.latmin)) * 1000, width: 150, height: 50)))
                                
                                if(Float(layer) > self.scrollView.zoomScale) {
                                    self.buildingImage[y].hidden = true
                                    self.button[y+1].hidden = true
                                    
                                }
                                else {
                                    self.buildingImage[y].hidden = false
                                    self.button[y+1].hidden = false
                                }
                                break
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                }
            }
            
            
        })
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

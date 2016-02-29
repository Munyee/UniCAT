//
//  MapViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/24/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

let annotationReuseIdentifier = "JCAnnotationReuseIdentifier";

class MapViewController: UIViewController, JCTiledScrollViewDelegate, JCTileSource, UIActionSheetDelegate {
    
    //UIGestureRecognizerDelegate,
    
    struct Name{
        static var nameof = ""
        static var imageview : NSString = ""
        static var floor : Int = 0
        static var gallery : Int = 0
    }
    
    let building = Building()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var button1: UIButton = UIButton()
    
    var scrollView: JCTiledScrollView!
    var buta = UIButton()
    var butb = UIButton()
    var butc = UIButton()
    var butd = UIButton()
    var bute = UIButton()
    var butf = UIButton()
    var butg = UIButton()
    var buth = UIButton()
    var buti = UIButton()
    var butj = UIButton()
    var butk = UIButton()
    var butl = UIButton()
    var butm = UIButton()
    var butn = UIButton()
    var buto = UIButton()
    var butp = UIButton()
    
    var a   = SpringImageView()
    var b = SpringImageView()
    var c = SpringImageView()
    var d = SpringImageView()
    var e = SpringImageView()
    var f = SpringImageView()
    var g = SpringImageView()
    var h = SpringImageView()
    var i = SpringImageView()
    var j = SpringImageView()
    var k = SpringImageView()
    var l = SpringImageView()
    var m = SpringImageView()
    var n = SpringImageView()
    var o = SpringImageView()
    var p = SpringImageView()
    
    //---Poi variable-----------------------------------------
    var butWifiA = UIButton()
    var butWifiB = UIButton()
    var butWifiC = UIButton()
    var butFoodC = UIButton()
    var butATMC = UIButton()
    var butClinicC = UIButton()
    var butBusD = UIButton()
    var butFoodE = UIButton()
    var butWifiG = UIButton()
    var butATMG = UIButton()
    var butBusG = UIButton()
    var butWifiH = UIButton()
    var butFoodH = UIButton()
    var butFoodK = UIButton()
    var butWifiK = UIButton()
    var butWifiN = UIButton()
    var butBusN = UIButton()
    var butATMN = UIButton()
    var butSport = UIButton()
    
    var wifiA = UIImageView()
    var wifiB = UIImageView()
    var wifiC = UIImageView()
    var foodC = UIImageView()
    var aTMC = UIImageView()
    var clinicC = UIImageView()
    var busD = UIImageView()
    var foodE = UIImageView()
    var wifiG = UIImageView()
    var aTMG = UIImageView()
    var busG = UIImageView()
    var wifiH = UIImageView()
    var foodH = UIImageView()
    var foodK = UIImageView()
    var wifiK = UIImageView()
    var wifiN = UIImageView()
    var busN = UIImageView()
    var aTMN = UIImageView()
    var sport = UIImageView()
    
    
    
    var lastscale = CGFloat()
    var textlabel = UILabel()
    var first = Bool()
    var thelastone = CGFloat()
    
    var poibool = false;
    var buspoi = false;
    var atmpoi = false;
    var foodpoi = false;
    var clinicpoi = false;
    var wifipoi = false;
    var sportpoi = false;
    var selectedBuilding = ""
    var selectedAlphabet = ""
    var selectedEventCount = ""
    
    var useranno = UIImageView()
    var currentloc = String();
    
    var tag:Int = 0
    var poitag : Int = 0
    var y:Int = 0
    var z:Int = 0
    
    //Scale
    var scale:CGFloat = 1;
    
    
    
    
    var names:[String] = ["Heritage Hall","Learning Complex I","Student Pavilion I","Faculty of Science","FEGT","Administration Block","Library","FBF","Lecture Complex I","Engineering Workshop","Student Pavilion II","Lecture Complex II","Grand Hall","FICT & IPSR Lab","Sports Complex","FAS & ICS"]
    var alphabet:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P"]
    var eventcount: [String] = ["o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o"]
    var eventname : [String] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initializationƒ
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
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
            
            for(self.y = 0 ; self.y < self.names.count; self.y++){
                var eventcounter:Int = 0
                for(self.z = 0 ; self.z < self.eventname.count; self.z++){
                    let c : String = self.building.buildingName(room: self.eventname[self.z])
                    if(self.eventname[self.z] == self.names[self.y] || c == self.names[self.y]){
                        
                        eventcounter++
                        
                    }
                    self.eventcount[self.y] = String(eventcounter)
                    
                }
                if(self.y == self.names.count-1){
                    var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addAnnotations"), userInfo: nil, repeats: false)
                    self.showpoi()
                    self.poihidden()
                }
            }
            
            
        })
    }
    /*
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if(navigationController!.viewControllers.count > 1){
    return true
    }
    return false
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        //        if(PFUser.currentUser() == nil){
        //            if let tabBarController = self.tabBarController {
        //                let indexToRemove = 2
        //                if indexToRemove < tabBarController.viewControllers?.count {
        //                    var viewControllers = tabBarController.viewControllers
        //                    viewControllers?.removeAtIndex(indexToRemove)
        //                    tabBarController.viewControllers = viewControllers
        //                }
        //            }
        //
        //        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        if(PFUser.currentUser() == nil && !NSUserDefaults.standardUserDefaults().boolForKey("firstStartup")){
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
        //            self.presentViewController(vc, animated: true, completion: nil)
        //        }
        
        
        
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("location"), userInfo: nil, repeats: true)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "gps"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 45, 45)
        button.targetForAction("actioncall", withSender: nil)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        
        
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
        
        
        
        Name.floor = 0
        Name.gallery = 0
        
        if Reachability.isConnectedToNetwork(){
            print("Internet connection ok")
            checkconnection()
        }
        else
        {
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showpoi"), userInfo: nil, repeats: false)
            poihidden()
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addAnnotations"), userInfo: nil, repeats: false)
        }
        
        
        
        first = true
        
        scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf"))
        
        scrollView.tiledScrollViewDelegate = self
        scrollView.zoomScale = 1.0
        
        scrollView.dataSource = self
        scrollView.tiledScrollViewDelegate = self
        scrollView.tiledView.shouldAnnotateRect = true
        scrollView.levelsOfZoom = 1;
        scrollView.levelsOfDetail = 1;
        scrollView.scrollView.setContentOffset(CGPoint(x: 470, y: 520), animated: true)
        
        view.addSubview(scrollView)
        
        
        
    }
    
    
    func buttonPressed(sender:UIButton!){
        
        if(useranno.frame.origin.x != 0 && useranno.frame.origin.y != 0 && DefineLocation.updated == true){
            scrollView.scrollView.setContentOffset(CGPoint(x: useranno.frame.origin.x - (UIScreen.mainScreen().bounds.width/2), y: useranno.frame.origin.y - (UIScreen.mainScreen().bounds.height/2)), animated: true)
        }
        else{
            let alert = UIAlertView(title: "Outside of UTAR Campus", message: "", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func activeQR(sender:UIButton!){
        
        self.performSegueWithIdentifier("MapToQR", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set all the building annotations
    func addAnnotations() {
        
        
        
        buta = setButton( a, label: names[0], eventnum: eventcount[0], size: CGRect(x: 638, y: 772, width: 150, height: 50))
        butb = setButton( b, label: names[1], eventnum: eventcount[1], size: CGRect(x: 635, y: 670, width: 150, height: 50))
        butc = setButton( c, label: names[2], eventnum: eventcount[2], size: CGRect(x: 735, y: 618, width: 150, height: 50))
        butd = setButton( d, label: names[3], eventnum: eventcount[3], size: CGRect(x: 835, y: 550, width: 150, height: 50))
        bute = setButton( e, label: names[4], eventnum: eventcount[4], size: CGRect(x: 820, y: 495, width: 150, height: 50))
        butf = setButton( f, label: names[5], eventnum: eventcount[5], size: CGRect(x: 830, y: 418, width: 150, height: 50))
        butg = setButton( g, label: names[6], eventnum: eventcount[6], size: CGRect(x: 785, y: 390, width: 150, height: 50))
        buth = setButton( h, label: names[7], eventnum: eventcount[7], size: CGRect(x: 780, y: 300, width: 150, height: 50))
        buti = setButton( i, label: names[8], eventnum: eventcount[8], size: CGRect(x: 750, y: 338, width: 150, height: 50))
        butj = setButton( j, label: names[9], eventnum: eventcount[9], size: CGRect(x: 880, y: 312, width: 150, height: 50))
        butk = setButton( k, label: names[10], eventnum: eventcount[10], size: CGRect(x: 652, y: 243, width: 150, height: 50))
        butl = setButton( l, label: names[11], eventnum: eventcount[11], size: CGRect(x: 565, y: 270, width: 150, height: 50))
        butm = setButton( m, label: names[12], eventnum: eventcount[12], size: CGRect(x: 367, y: 360, width: 150, height: 50))
        butn = setButton( n, label: names[13], eventnum: eventcount[13], size: CGRect(x: 310, y: 490, width: 150, height: 50))
        buto = setButton( o, label: names[14], eventnum: eventcount[14], size: CGRect(x: 95, y: 610, width: 150, height: 50))
        butp = setButton( p, label: names[15], eventnum: eventcount[15], size: CGRect(x: 308, y: 520, width: 150, height: 50))
        
        scrollView.setZoomScale(1.5, animated: true)
        b.hidden = true
        d.hidden = true
        e.hidden = true
        f.hidden = true
        h.hidden = true
        i.hidden = true
        l.hidden = true
        p.hidden = true
        butb.hidden = true
        butd.hidden = true
        bute.hidden = true
        butf.hidden = true
        buth.hidden = true
        buti.hidden = true
        butl.hidden = true
        butp.hidden = true
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
    }
    
    func setButton( imageview : SpringImageView,label:String,eventnum:String,size:CGRect)->UIButton{
        
        //User settings for White/Black
        Name.imageview = "Black"
        
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
            if(Name.imageview == "White"){
                
            }
            else{
                image = UIImage(named: "MapPinBlack")!
            }
        } else {
            label1.frame = CGRect(x: 17, y: -2, width: 150, height: 50)
            label1.text = label
            label1.textAlignment = NSTextAlignment.Center
            label1.font = UIFont(name: "Avenir Next", size: 12)
            if(Name.imageview == "White"){
                image = UIImage(named: "MapPinWhite-e")!
            }
            else{
                image = UIImage(named: "MapPinBlack-e")!
            }
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
        
        if(Name.imageview == "White"){
            label1.textColor = UIColor.blackColor()
            event.textColor = UIColor.blackColor()
        }
        else{
            label1.textColor = UIColor.whiteColor()
            event.textColor = UIColor.whiteColor()
        }
        
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
    
    
    //------Call the function when scrollView Zoom!!-------
    //!!IMPORTANT!!!!!!!!!!
    func tiledScrollViewDidZoom(scrollView: JCTiledScrollView!) {
        
        NSLog("%f",scale)
        scale = CGFloat(scrollView.zoomScale)
        showbuildinganno()
        showbus()
        showATM()
        showfood()
        showclinic()
        showwifi()
        showsport()
        getButton(useranno)
        first = false
        thelastone = scale
        
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
    
    //Set the Annotation location
    func getButton(image:UIImageView)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        print(scale)
        
        if(image == useranno){
            if(first == true){
                
                image.frame = CGRect(x:(image.frame.origin.x+13.5)/lastscale, y: (image.frame.origin.y+50)/lastscale,width: 27, height: 50)
                image.frame = CGRect(x:(image.frame.origin.x*scale)-13.5, y: (image.frame.origin.y*scale)-50,width: 27, height: 50)
                
            }
            else if(first == false)
            {
                image.frame = CGRect(x:(image.frame.origin.x+13.5)/thelastone, y: (image.frame.origin.y+50)/thelastone,width: 27, height: 50)
                image.frame = CGRect(x:(image.frame.origin.x*scale)-13.5, y: (image.frame.origin.y*scale)-50,width: 27, height: 50)
                
                
            }
        }
        else
        {
            if(first == true){
                
                image.frame = CGRect(x:image.frame.origin.x/lastscale, y: image.frame.origin.y/lastscale,width: 150, height: 50)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
                
            }
            else if(first == false)
            {
                image.frame = CGRect(x:image.frame.origin.x/thelastone, y: image.frame.origin.y/thelastone,width: 150, height: 50)
                image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
                
                
            }
        }
        
        
        
        
        return image.frame
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
    
    func pressed(sender: UIButton!) {
        
        //perform segue
        var x:Int = 0
        for(x = 0 ; x < names.count ; x++){
            if(sender.tag == x+1){
                
                Name.nameof = names[x]
                selectedBuilding = names[x]
                selectedAlphabet = alphabet[x]
                selectedEventCount = eventcount[x]
                
                self.performSegueWithIdentifier("mapToBuilding", sender: nil)
                
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
    
    func hidden(){
        let items : [SpringImageView] = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]
        
        for item in items{
            item.hidden = true
        }
        
        let buttons : [UIButton] = [buta,butb,butc,butd,bute,butf,butg,buth,buti,butj,butk,butl,butm,butn,buto,butp]
        for but in buttons{
            but.hidden = true
        }
    }
    
    
    
    func showbuildinganno(){
        if(scale > 1 && scale <= 1.95 && poibool == false){
            
            let items : [SpringImageView] = [b,d,e,f,h,i,l,p];
            
            for item in items{
                item.hidden = true
                item.animation = "fadeIn"
                item.curve = "easeIn"
                item.duration = 2.5
                item.animate()
                
            }
            
            butb.hidden = true
            butd.hidden = true
            bute.hidden = true
            butf.hidden = true
            buth.hidden = true
            buti.hidden = true
            butl.hidden = true
            butp.hidden = true
            
        }
        else if(scale < 1 && poibool == false){
            
            let items : [SpringImageView] = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]
            
            for item in items{
                item.hidden = true
            }
        }
        else if(scale == 1 && poibool == false){
            let items : [SpringImageView] = [b,d,e,f,h,i,l,p];
            
            for item in items{
                item.hidden = true
                
            }
            butb.hidden = true
            butd.hidden = true
            bute.hidden = true
            butf.hidden = true
            buth.hidden = true
            buti.hidden = true
            butl.hidden = true
            butp.hidden = true
            
            let itemsVisible : [SpringImageView] = [a,c,g,j,k,m,n,o];
            
            for item in itemsVisible{
                item.hidden = false
                item.animation = "fadeIn"
                item.curve = "easeIn"
                item.duration = 2.5
                item.animate()
            }
            
            let buttonVisible : [UIButton] = [buta,butc,butg,butj,butk,butm,butn,buto]
            
            for item in buttonVisible{
                item.hidden = false
            }
            
        }else if(poibool == false && scale == 2)
        {
            let items : [SpringImageView] = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]
            
            for item in items{
                item.hidden = false
                item.animation = "fadeIn"
                item.curve = "easeIn"
                item.duration = 2.5
                item.animate()
                
            }
            buta.hidden = false
            butb.hidden = false
            butc.hidden = false
            butd.hidden = false
            bute.hidden = false
            butf.hidden = false
            butg.hidden = false
            buth.hidden = false
            buti.hidden = false
            butj.hidden = false
            butk.hidden = false
            butl.hidden = false
            butm.hidden = false
            butn.hidden = false
            buto.hidden = false
            butp.hidden = false
        }
        getButton(a)
        setButtonLocation(buta)
        getButton(b)
        setButtonLocation(butb)
        getButton(c)
        butc.frame = setButtonLocation(butc)
        getButton(d)
        setButtonLocation(butd)
        getButton(e)
        setButtonLocation(bute)
        getButton(f)
        setButtonLocation(butf)
        getButton(g)
        setButtonLocation(butg)
        getButton(h)
        setButtonLocation(buth)
        getButton(i)
        setButtonLocation(buti)
        getButton(j)
        setButtonLocation(butj)
        getButton(k)
        setButtonLocation(butk)
        getButton(l)
        setButtonLocation(butl)
        getButton(m)
        setButtonLocation(butm)
        getButton(n)
        setButtonLocation(butn)
        getButton(o)
        setButtonLocation(buto)
        getButton(p)
        setButtonLocation(butp)
        
        
        //first = false
        //thelastone = scale
        
    }
    
    
    
    //-----SET POI--------------------------------------------
    func showpoi(){
        butWifiA = setpoi(wifiA, size: CGRect(x: 638 , y: 772, width: 50, height: 50), item: "Wifi")
        butWifiB = setpoi(wifiB, size: CGRect(x: 635, y: 670, width: 50, height: 50), item: "Wifi")
        butWifiC = setpoi(wifiC, size: CGRect(x: 748, y: 611, width: 50, height: 50), item: "Wifi")
        butATMC = setpoi(aTMC, size: CGRect(x: 720, y: 627, width: 50, height: 50), item: "ATM")
        butClinicC = setpoi(clinicC, size: CGRect(x: 745, y: 645, width: 50, height: 50), item: "Clinic")
        butFoodC = setpoi(foodC, size: CGRect(x: 734, y: 618, width: 50, height: 50), item: "Food")
        butBusD = setpoi(busD, size: CGRect(x: 835, y: 550, width: 50, height: 50), item: "Bus")
        butFoodE = setpoi(foodE, size: CGRect(x: 820, y: 495, width: 50, height: 50), item: "Food")
        butWifiG = setpoi(wifiG, size: CGRect(x: 785, y: 390, width: 50, height: 50), item: "Wifi")
        butATMG = setpoi(aTMG, size: CGRect(x: 777, y: 450, width: 50, height: 50), item: "ATM")
        butBusG = setpoi(busG, size: CGRect(x: 878, y: 430, width: 50, height: 50), item: "Bus")
        butWifiH = setpoi(wifiH, size: CGRect(x: 770, y: 290, width: 50, height: 50), item: "Wifi")
        butFoodH = setpoi(foodH, size: CGRect(x: 790, y: 310, width: 50, height: 50), item: "Food")
        butWifiK = setpoi(wifiK, size: CGRect(x: 666, y: 236, width: 50, height: 50), item: "Wifi")
        butFoodK = setpoi(foodK, size: CGRect(x: 637, y: 253, width: 50, height: 50), item: "Food")
        butBusN = setpoi(busN, size: CGRect(x: 310, y: 488, width: 50, height: 50), item: "Bus")
        butATMN = setpoi(aTMN, size: CGRect(x: 265, y: 512, width: 50, height: 50), item: "ATM")
        butWifiN = setpoi(wifiN, size: CGRect(x: 288, y: 512, width: 50, height: 50), item: "Wifi")
        butSport = setpoi(sport, size: CGRect(x: 95, y: 610, width: 50, height: 50), item: "Sport")
    }
    
    
    func setpoi(imageview : UIImageView,size:CGRect,item: String)->UIButton{
        
        
        poitag++
        let button:UIButton = UIButton()
        button.frame = CGRect(x: size.origin.x-25 , y: size.origin.y-50 , width: 50, height: 50)
        
        button.tag = poitag
        var annot:UIImageView = UIImageView()
        annot.frame = CGRectMake(0,0,50,50)
        var image:UIImage = UIImage()
        var image1:UIImageView = UIImageView()
        image1 = imageview
        image1.frame = size
        
        
        if(item == "Clinic"){
            image = UIImage(named: "Clinic")!
            image1.bounds = CGRect(x: 19, y: 51, width: 50, height: 50)
        }else if(item == "Bus"){
            image = UIImage(named: "Bus")!
            image1.bounds = CGRect(x: 40, y: 50, width: 50, height: 50)
        }else if(item == "Food"){
            image = UIImage(named: "Food")!
            image1.bounds = CGRect(x: 19, y: 52, width: 50, height: 50)
        }else if(item == "Sport"){
            image = UIImage(named: "Sport")!
            image1.bounds = CGRect(x: 19, y: 52, width: 50, height: 50)
        }else if(item == "Wifi"){
            image = UIImage(named: "Wifi")!
            image1.bounds = CGRect(x: 19, y: 52, width: 50, height: 50)
        }
        else if(item == "ATM"){
            image = UIImage(named: "ATM")!
            image1.bounds = CGRect(x: 15, y: 52, width: 50, height: 50)
        }
        
        annot = UIImageView(image:image)
        
        // button.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        
        
        
        image1.addSubview(annot)
        scrollView.scrollView.addSubview(image1)
        scrollView.scrollView.addSubview(button)
        return button
    }
    
    
    
    func setpoiLocation(image:UIButton)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        
        if(first == true){
            NSLog("First is true")
            image.frame = CGRect(x:(image.frame.origin.x+25)/lastscale, y: (image.frame.origin.y+50)/lastscale,width: 50, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-25, y: (image.frame.origin.y*scale)-50,width: 50, height: 50)
            
            NSLog("LastScale:%f",thelastone)
        }
        if(first == false)
        {
            NSLog("First is false")
            image.frame = CGRect(x:(image.frame.origin.x+25)/thelastone, y: (image.frame.origin.y+50)/thelastone,width: 50, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-25, y: (image.frame.origin.y*scale)-50,width: 50, height: 50)
            
            NSLog("LastScale:%f",thelastone)
        }
        
        
        
        return image.frame
    }
    
    
    func poihidden(){
        butWifiA.hidden = true
        butWifiB.hidden = true
        butWifiC.hidden = true
        butFoodC.hidden = true
        butATMC.hidden = true
        butClinicC.hidden = true
        butBusD.hidden = true
        butFoodE.hidden = true
        butWifiG.hidden = true
        butATMG.hidden = true
        butBusG.hidden = true
        butWifiH.hidden = true
        butFoodH.hidden = true
        butFoodK.hidden = true
        butWifiK.hidden = true
        butWifiN.hidden = true
        butBusN.hidden = true
        butATMN.hidden = true
        butSport.hidden = true
        wifiA.hidden = true
        wifiB.hidden = true
        wifiC.hidden = true
        foodC.hidden = true
        aTMC.hidden = true
        clinicC.hidden = true
        busD.hidden = true
        foodE.hidden = true
        wifiG.hidden = true
        aTMG.hidden = true
        busG.hidden = true
        wifiH.hidden = true
        foodH.hidden = true
        foodK.hidden = true
        wifiK.hidden = true
        wifiN.hidden = true
        busN.hidden = true
        aTMN.hidden = true
        sport.hidden = true
    }
    
    //Location---------------------------------------
    
    func location(){
        DefineLocation.userlocation(useranno)
        
        useranno.frame = CGRect(x: (useranno.frame.origin.x*scale)-13.5, y: (useranno.frame.origin.y*scale)-50, width: 27, height: 50)
        scrollView.scrollView.addSubview(useranno)
        
    }
    
    
    //--Types of Annotionation-------------------
    func showbus(){
        
        if(scale > 1 && scale <= 1.95 && buspoi == true){
            butBusD.hidden = false
            butBusG.hidden = false
            butBusN.hidden = false
            busD.hidden = false
            busG.hidden = false
            busN.hidden = false
            
            
        }
        else if(scale < 1 && buspoi == true){
            busD.hidden = true
            busG.hidden = true
            busN.hidden = true
            
        }
        else if(scale == 1 && buspoi == true) {
            butBusD.hidden = false
            butBusG.hidden = false
            butBusN.hidden = false
            busD.hidden = false
            busG.hidden = false
            busN.hidden = false
            
        }else if(buspoi == true)
        {
            butBusD.hidden = false
            butBusG.hidden = false
            butBusN.hidden = false
            busD.hidden = false
            busG.hidden = false
            busN.hidden = false
        }
        
        getButton(busD)
        getButton(busG)
        getButton(busN)
        setpoiLocation(butBusD)
        setpoiLocation(butBusG)
        setpoiLocation(butBusN)
        
    }
    
    func showATM(){
        
        if(scale > 1 && scale <= 1.95 && atmpoi == true){
            butATMC.hidden = false
            butATMG.hidden = false
            butATMN.hidden = false
            aTMC.hidden = false
            aTMG.hidden = false
            aTMN.hidden = false
            
        }
        else if(scale < 1 && atmpoi == true){
            aTMC.hidden = true
            aTMG.hidden = true
            aTMN.hidden = true
            
        }
        else if(scale == 1 && atmpoi == true) {
            butATMC.hidden = false
            butATMG.hidden = false
            butATMN.hidden = false
            aTMC.hidden = false
            aTMG.hidden = false
            aTMN.hidden = false
            
        }else if(atmpoi == true)
        {
            butATMC.hidden = false
            butATMG.hidden = false
            butATMN.hidden = false
            aTMC.hidden = false
            aTMG.hidden = false
            aTMN.hidden = false
        }
        
        getButton(aTMC)
        getButton(aTMG)
        getButton(aTMN)
        setpoiLocation(butATMC)
        setpoiLocation(butATMG)
        setpoiLocation(butATMN)
        
    }
    
    func showfood(){
        
        if(scale > 1 && scale <= 1.95 && foodpoi == true){
            butFoodC.hidden = false
            butFoodE.hidden = false
            butFoodH.hidden = false
            butFoodK.hidden = false
            foodC.hidden = false
            foodE.hidden = false
            foodH.hidden = false
            foodK.hidden = false
        }
        else if(scale < 1 && foodpoi == true){
            foodC.hidden = true
            foodE.hidden = true
            foodH.hidden = true
            foodK.hidden = true
        }
        else if(scale == 1 && foodpoi == true) {
            butFoodC.hidden = false
            butFoodE.hidden = false
            butFoodH.hidden = false
            butFoodK.hidden = false
            foodC.hidden = false
            foodE.hidden = false
            foodH.hidden = false
            foodK.hidden = false
            
        }else if(foodpoi == true)
        {
            butFoodC.hidden = false
            butFoodE.hidden = false
            butFoodH.hidden = false
            butFoodK.hidden = false
            foodC.hidden = false
            foodE.hidden = false
            foodH.hidden = false
            foodK.hidden = false
            
        }
        
        getButton(foodC)
        getButton(foodE)
        getButton(foodH)
        getButton(foodK)
        setpoiLocation(butFoodC)
        setpoiLocation(butFoodE)
        setpoiLocation(butFoodH)
        setpoiLocation(butFoodK)
        
    }
    
    func showclinic(){
        
        if(scale > 1 && scale <= 1.95 && clinicpoi == true){
            butClinicC.hidden = false
            clinicC.hidden = false
            
        }
        else if(scale < 1 && clinicpoi == true){
            clinicC.hidden = false
            
        }
        else if(scale == 1 && clinicpoi == true) {
            butClinicC.hidden = false
            clinicC.hidden = false
            
        }else if(clinicpoi == true)
        {
            butClinicC.hidden = false
            clinicC.hidden = false
            
        }
        
        getButton(clinicC)
        setpoiLocation(butClinicC)
        
    }
    
    func showwifi(){
        
        if(scale > 1 && scale <= 1.95 && wifipoi == true){
            butWifiA.hidden = false
            butWifiB.hidden = false
            butWifiC.hidden = false
            butWifiG.hidden = false
            butWifiH.hidden = false
            butWifiK.hidden = false
            butWifiN.hidden = false
            wifiA.hidden = false
            wifiB.hidden = false
            wifiC.hidden = false
            wifiG.hidden = false
            wifiH.hidden = false
            wifiK.hidden = false
            wifiN.hidden = false
            
        }
        else if(scale < 1 && wifipoi == true){
            wifiA.hidden = true
            wifiB.hidden = true
            wifiC.hidden = true
            wifiG.hidden = true
            wifiH.hidden = true
            wifiK.hidden = true
            wifiN.hidden = true
            
        }
        else if(scale == 1 && wifipoi == true) {
            butWifiA.hidden = false
            butWifiB.hidden = false
            butWifiC.hidden = false
            butWifiG.hidden = false
            butWifiH.hidden = false
            butWifiK.hidden = false
            butWifiN.hidden = false
            wifiA.hidden = false
            wifiB.hidden = false
            wifiC.hidden = false
            wifiG.hidden = false
            wifiH.hidden = false
            wifiK.hidden = false
            wifiN.hidden = false
            
        }else if(wifipoi == true)
        {
            butWifiA.hidden = false
            butWifiB.hidden = false
            butWifiC.hidden = false
            butWifiG.hidden = false
            butWifiH.hidden = false
            butWifiK.hidden = false
            butWifiN.hidden = false
            wifiA.hidden = false
            wifiB.hidden = false
            wifiC.hidden = false
            wifiG.hidden = false
            wifiH.hidden = false
            wifiK.hidden = false
            wifiN.hidden = false
        }
        
        getButton(wifiA)
        getButton(wifiB)
        getButton(wifiC)
        getButton(wifiG)
        getButton(wifiH)
        getButton(wifiK)
        getButton(wifiN)
        setpoiLocation(butWifiA)
        setpoiLocation(butWifiB)
        setpoiLocation(butWifiC)
        setpoiLocation(butWifiG)
        setpoiLocation(butWifiH)
        setpoiLocation(butWifiK)
        setpoiLocation(butWifiN)
        
    }
    
    
    func showsport(){
        
        if(scale > 1 && scale <= 1.95 && sportpoi == true){
            butSport.hidden = false
            sport.hidden = false
            
        }
        else if(scale < 1 && sportpoi == true){
            sport.hidden = false
            
        }
        else if(scale == 1 && sportpoi == true) {
            butSport.hidden = false
            sport.hidden = false
            
        }else if(sportpoi == true)
        {
            butSport.hidden = false
            sport.hidden = false
        }
        
        
        getButton(sport)
        setpoiLocation(butSport)
        
    }
    
    
    //---Action Sheet-----------------------
    func downloadSheet(sender: AnyObject)
    {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil , destructiveButtonTitle: nil, otherButtonTitles: "Building Details", "Bus Stop", "ATM", "Food", "Clinic", "Wifi" ,"Sport")
        
        actionSheet.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        scrollView.setZoomScale(0, animated: true)
        poibool = true
        buspoi = false
        atmpoi = false
        foodpoi = false
        
        print("\(buttonIndex)")
        switch (buttonIndex){
            
            
        case 0:
            hidden()
            poihidden()
            poibool = false
            showbuildinganno()
        case 1:
            hidden()
            poihidden()
            buspoi = true
            showbus()
        case 2:
            hidden()
            poihidden()
            atmpoi = true
            showATM()
        case 3:
            hidden()
            poihidden()
            foodpoi = true
            showfood()
        case 4:
            hidden()
            poihidden()
            clinicpoi = true
            showclinic()
        case 5:
            hidden()
            poihidden()
            wifipoi = true
            showwifi()
        case 6:
            hidden()
            poihidden()
            sportpoi = true
            showsport()
        default:
            print("Default")
            //Some code here..
            
        }
    }
    
    
    
    
}


//
//  MapViewController.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/13/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MapKit
import Parse

let annotationReuseIdentifier = "JCAnnotationReuseIdentifier";

class MapViewController: UIViewController, JCTiledScrollViewDelegate, JCTileSource {
    
    
    struct Name{
        static var nameof = ""
        static var imageview : NSString = ""
        static var floor : Int = 0
        static var gallery : Int = 0
    }
    
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var mutex = pthread_mutex_t()
    var semaphore = dispatch_semaphore_t()
    var scrollView: JCTiledScrollView!
    var buta:UIButton = UIButton()
    var butb:UIButton = UIButton()
    var butc:UIButton = UIButton()
    var butd:UIButton = UIButton()
    var bute:UIButton = UIButton()
    var butf:UIButton = UIButton()
    var butg:UIButton = UIButton()
    var buth:UIButton = UIButton()
    var buti:UIButton = UIButton()
    var butj:UIButton = UIButton()
    var butk:UIButton = UIButton()
    var butl:UIButton = UIButton()
    var butm:UIButton = UIButton()
    var butn:UIButton = UIButton()
    var buto:UIButton = UIButton()
    var butp:UIButton = UIButton()
    var a:UIImageView   = UIImageView()
    var b:UIImageView = UIImageView()
    var c:UIImageView = UIImageView()
    var d:UIImageView = UIImageView()
    var e:UIImageView = UIImageView()
    var f:UIImageView = UIImageView()
    var g:UIImageView = UIImageView()
    var h:UIImageView = UIImageView()
    var i:UIImageView = UIImageView()
    var j:UIImageView = UIImageView()
    var k:UIImageView = UIImageView()
    var l:UIImageView = UIImageView()
    var m:UIImageView = UIImageView()
    var n:UIImageView = UIImageView()
    var o:UIImageView = UIImageView()
    var p:UIImageView = UIImageView()
    var lastscale:CGFloat = CGFloat()
    var textlabel:UILabel = UILabel()
        var first:Bool = Bool()
    var thelastone:CGFloat = CGFloat()
    
    var tag:Int = 0
    var y:Int = 0
    var z:Int = 0
    var names:[String] = ["Heritage Hall","Learning Complex I","Student Pavilion I","Faculty of Science","FEGT","Administration Block","Library","FBF","Lecture Complex I","Engineering Workshop","Student Pavilion II","Lecture Complex II","Grand Hall","FICT","Sports Complex","FAS & ICS"]
    var eventcount: [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var eventname : [String] = []
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    //Load the annotation color from plist
    func loadGameData() {
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
        Name.imageview = dict?.objectForKey(annotationkey) as! String
       
        
    }
    
    //-------------------------------------------------------
    
    func checkconnection(){
        var temp : [String] = []
        var counter:Int = 0
        var check : Int = 0
        
        var query = PFQuery(className:"Event")
        var today = NSDate()
        query.whereKey("endDate", greaterThanOrEqualTo: today)
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error:NSError?) -> Void in
            
            var name :String
            // Looping through the objects to get the names of the workers in each object
            
            for object in objects! {
                
                //here to increase count if event++
                temp.append(object["venue"] as! String)
                
            }
            
            // temp = String(hello)
            println(temp)
            
            NSLog("Done Load Data")
            self.eventname = temp
            counter++
            check++
            
            
        })
    }
    
    override func viewDidLoad() {
       
        loadGameData()
        super.viewDidLoad()
        Name.floor = 0
        Name.gallery = 0
        pthread_mutex_init(&mutex,nil)
        dispatch_semaphore_create(0)
        
        if Reachability.isConnectedToNetwork(){
            println("Internet connection ok")
            checkconnection()
        }
        else
        {
            println("No internet connection")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        
        
        
        
       // var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("addRandomAnnotations"), userInfo: nil, repeats: true)
       
        first = true
        scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf"))
        
        scrollView.tiledScrollViewDelegate = self
        scrollView.zoomScale = 1.0
        var timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("addRandomAnnotations"), userInfo: nil, repeats: false)
        scrollView.dataSource = self
        scrollView.tiledScrollViewDelegate = self
        scrollView.backgroundColor = UIColor(red: 201/255, green: 219/255, blue: 111/255, alpha: 1.0)
        scrollView.tiledView.shouldAnnotateRect = true
        // totals 4 sets of tiles across all devices, retina devices will miss out on the first 1x set
        scrollView.levelsOfZoom = 3;
        scrollView.levelsOfDetail = 3;
        
        view.addSubview(scrollView)
        
     
       
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildingName(#room: String) -> String {
        
        // Get the Building initial from Room number
        var initial = room.substringToIndex(advance(room.startIndex, 1))
        var length = count(room)
        
        if (length >= 7 || room == "FBF" || room == "FEGT"){
            return room
        }
        
        // Return UTAR Building Name
        switch initial {
        case "A":
            return "Heritage Hall"
        case "B":
            return "Learning Complex I"
        case "C":
            return "Student Pavilion I"
        case "D":
            return "Faculty of Science"
        case "E":
            return "FEGT"
        case "F":
            return "Administration"
        case "G":
            return "Library"
        case "H":
            return "FBF"
        case "I":
            return "Lecture Complex I"
        case "J":
            return "Engineering Workshop"
        case "K":
            return "Student Pavilion II"
        case "L":
            return "Lecture Complex II"
        case "M":
            return "Grand Hall"
        case "N":
            return "FICT"
        case "P":
            return "FAS & ICS"
        default:
            return room
        }
        
    }
   
    
    func addRandomAnnotations() {
        for(y = 0 ; y < names.count; y++){
            var eventcounter:Int = 0
            for(z = 0 ; z < eventname.count; z++){
                let c : String = buildingName(room: eventname[z])
                if(eventname[z] == names[y] || c == names[y]){
                    
                    eventcounter++
                    
                }
                eventcount[y] = String(eventcounter)
                println(eventcount)
            }
        }
        var image:UIImage = UIImage()
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
        
        
    }
    
    func setButton( imageview : UIImageView,label:String,eventnum:String,size:CGRect)->UIButton{
        
        tag++
        textlabel.text = label
        var button:UIButton = UIButton()
        button.frame = CGRect(x: size.origin.x-75 , y: size.origin.y-50 , width: 170, height: 50)
        button.tag = tag
        var annot:UIImageView = UIImageView()
        annot.frame = CGRectMake(0,0,150,50)
        var image:UIImage = UIImage()
        var image1:UIImageView = UIImageView()
        if(Name.imageview == "White"){
            image = UIImage(named: "MapPinWhite")!
        }
        else{
            image = UIImage(named: "MapPinBlack")!
        }
        
        var label1 : UILabel = UILabel()
        var event :UILabel = UILabel()
        image1 = imageview
        image1.alpha = 0.8
        annot = UIImageView(image:image)
        image1.userInteractionEnabled = true
        annot.userInteractionEnabled = true
        image1.frame = size
        label1.frame = CGRect(x: 17, y: -2, width: 150, height: 50)
        label1.text = label
        label1.textAlignment = NSTextAlignment.Center
        label1.font = UIFont(name: "Avenir Next", size: 12)
        
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
        annot.addSubview(event)
        
        image1.bounds = CGRect(x: 85, y: 50, width: 150, height: 50)
        image1.addSubview(annot)
        scrollView.scrollView.addSubview(image1)
        scrollView.scrollView.addSubview(button)
        return button
    }
    
    func tiledScrollViewDidZoom(scrollView: JCTiledScrollView!) {
        var scale:CGFloat;
        
        scale = CGFloat(scrollView.zoomScale)
        NSLog("%f",scale)
        if(scale > 1 && scale <= 1.95){
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
        }
        else if(scale < 1){
            a.hidden = true
            b.hidden = true
            c.hidden = true
            d.hidden = true
            e.hidden = true
            f.hidden = true
            g.hidden = true
            h.hidden = true
            i.hidden = true
            j.hidden = true
            k.hidden = true
            l.hidden = true
            m.hidden = true
            n.hidden = true
            o.hidden = true
            p.hidden = true
        }
        else if(scale == 1){
            a.hidden = false
            c.hidden = false
            g.hidden = false
            j.hidden = false
            k.hidden = false
            m.hidden = false
            n.hidden = false
            o.hidden = false
            buta.hidden = false
            butc.hidden = false
            butg.hidden = false
            butj.hidden = false
            butk.hidden = false
            butm.hidden = false
            butn.hidden = false
            buto.hidden = false
        }else
        {
            a.hidden = false
            b.hidden = false
            c.hidden = false
            d.hidden = false
            e.hidden = false
            f.hidden = false
            g.hidden = false
            h.hidden = false
            i.hidden = false
            j.hidden = false
            k.hidden = false
            l.hidden = false
            m.hidden = false
            n.hidden = false
            o.hidden = false
            p.hidden = false
            butb.hidden = false
            butd.hidden = false
            bute.hidden = false
            butf.hidden = false
            buth.hidden = false
            buti.hidden = false
            butl.hidden = false
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
        
        
        first = false
        thelastone = scale
        
    }
    
    
   

    func setButtonLocation(image:UIButton)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        
        pthread_mutex_lock(&mutex)
        if(first == true){
            NSLog("First is true")
            image.frame = CGRect(x:(image.frame.origin.x+75)/lastscale, y: (image.frame.origin.y+50)/lastscale,width: 170, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-75, y: (image.frame.origin.y*scale)-50,width: 170, height: 50)
            
            NSLog("LastScale:%f",thelastone)
        }
        if(first == false)
        {
            NSLog("First is false")
            image.frame = CGRect(x:(image.frame.origin.x+75)/thelastone, y: (image.frame.origin.y+50)/thelastone,width: 170, height: 50)
            image.frame = CGRect(x:(image.frame.origin.x*scale)-75, y: (image.frame.origin.y*scale)-50,width: 170, height: 50)
            
            
            NSLog("LastScale:%f",thelastone)
        }
        
        
        
        pthread_mutex_unlock(&mutex)
        
        return image.frame
    }
    
 
    
    func getButton(image:UIImageView)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        
        pthread_mutex_lock(&mutex)
        if(first == true){
            NSLog("First is true")
            image.frame = CGRect(x:image.frame.origin.x/lastscale, y: image.frame.origin.y/lastscale,width: 150, height: 50)
            image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
            
            NSLog("LastScale:%f",thelastone)
        }
         if(first == false)
        {
            NSLog("First is false")
            image.frame = CGRect(x:image.frame.origin.x/thelastone, y: image.frame.origin.y/thelastone,width: 150, height: 50)
            image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: 150, height: 50)
            
            
             NSLog("LastScale:%f",thelastone)
        }
       
        
        
        pthread_mutex_unlock(&mutex)
        
        return image.frame
    }
    
    func tiledScrollView(scrollView: JCTiledScrollView!, didReceiveSingleTap gestureRecognizer: UIGestureRecognizer!) {
        var tapPoint:CGPoint = gestureRecognizer.locationInView(scrollView.tiledView)
        
    }
    
    func tiledScrollView(scrollView: JCTiledScrollView!, viewForAnnotation annotation: JCAnnotation!) -> JCAnnotationView! {
        
        var view:DemoAnnotationView? = scrollView.dequeueReusableAnnotationViewWithReuseIdentifier(nil) as? DemoAnnotationView;
         var view1:DemoAnnotationView? = scrollView.dequeueReusableAnnotationViewWithReuseIdentifier(annotationReuseIdentifier) as? DemoAnnotationView;
        
        
        if ( (view) == nil )
        {
            
        }
        
       
        
        return view;
    }
    
    
    
    func tiledScrollView(scrollView: JCTiledScrollView!, imageForRow row: Int, column: Int, scale: Int) -> UIImage! {
        
        let fileName:String = "Map_\(scale)x_\(row)_\(column).png";
        println(fileName);
        return UIImage(named: fileName)
        
    }
    
    
    @IBAction func refreshButton(sender: AnyObject) {
        viewDidLoad()
    }
    
    
    func pressed(sender: UIButton!) {
        
        
        
        //perform segue
        var x:Int = 0
        for(x = 0 ; x < names.count ; x++){
            if(sender.tag == x+1){
                
                Name.nameof = names[x]
                
                var query = PFQuery(className:"Building")
                query.whereKey("name", equalTo:Name.nameof)
                query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
                    
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
                
                
                self.performSegueWithIdentifier("Buildingdetails", sender: nil)
            
            }
        }
        
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

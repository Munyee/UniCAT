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
    
    var names:[String] = ["Heritage Hall","Learning Complex I","Block C","Block D","Block E","Block F","Block G","Block H","Block I","Block J","Block K","Block L","Grand Hall","Block N","Sports Complex","Block P"]
    var eventcount: [String] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         pthread_mutex_init(&mutex,nil)
        dispatch_semaphore_create(0)
        var temp : [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
        var counter:Int = 0
        for(y = 0 ; y < names.count; y++){
            
            var hello : Int = 0
            hello = 0
            
            
            var query = PFQuery(className:"Event")
            query.whereKey("venue", equalTo:names[y])
            query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error:NSError?) -> Void in
            
                
                if error == nil {
                    
                    
                    // Looping through the objects to get the names of the workers in each object
                    for object in objects! {
                        
                        //here to increase count if event++
                        hello++
                        
                        
                    }
                    
                    
                   // temp = String(hello)
                    NSLog("Done Load Data")
                    temp[counter] = String(hello)
                    println(objects?.last)
                    super.reloadInputViews()
                    counter++
                    
                }
                
                self.eventcount = temp
            })
        
           
        }
        
        
       // var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("addRandomAnnotations"), userInfo: nil, repeats: true)
       
        first = true
        scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf"))
        
        scrollView.tiledScrollViewDelegate = self
        scrollView.zoomScale = 1.0
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("addRandomAnnotations"), userInfo: nil, repeats: false)
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
        NSLog("%f",scrollView.scrollView.frame.size.width)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func addRandomAnnotations() {
        
        var image:UIImage = UIImage()
        buta = setButton( a, label: names[0], eventnum: eventcount[0], size: CGRect(x: 612, y: 560, width: 150, height: 50))
        butb = setButton( b, label: "Learning Complex I", eventnum: "0", size: CGRect(x: 610, y: 463, width: 150, height: 50))
        butc = setButton( c, label: "Student Pavilion I", eventnum: "0", size: CGRect(x: 622, y: 392, width: 150, height: 50))
        butd = setButton( d, label: "Block D", eventnum: "0", size: CGRect(x: 645, y: 260, width: 150, height: 50))
        bute = setButton( e, label: "Block E", eventnum: "0", size: CGRect(x: 660, y: 165, width: 150, height: 50))
        butf = setButton( f, label: "Block F", eventnum: "0", size: CGRect(x: 468, y: 280, width: 150, height: 50))
        butg = setButton( g, label: "Block G", eventnum: "0", size: CGRect(x: 440, y: 320, width: 150, height: 50))
        buth = setButton( h, label: "Block H", eventnum: "0", size: CGRect(x: 390, y: 385, width: 150, height: 50))
        buti = setButton( i, label: "Block I", eventnum: "0", size: CGRect(x: 423, y: 420, width: 150, height: 50))
        butj = setButton( j, label: "Block J", eventnum: "0", size: CGRect(x: 336, y: 210, width: 150, height: 50))
        butk = setButton( k, label: "Block K", eventnum: "0", size: CGRect(x: 325, y: 445, width: 150, height: 50))
        butl = setButton( l, label: "Block L", eventnum: "0", size: CGRect(x: 317, y: 505, width: 150, height: 50))
        butm = setButton( m, label: "Grand Hall", eventnum: "0", size: CGRect(x: 345, y: 550, width: 150, height: 50))
        butn = setButton( n, label: "Block N", eventnum: "0", size: CGRect(x: 423, y: 612, width: 150, height: 50))
        buto = setButton( o, label: "Sports Complex", eventnum: "0", size: CGRect(x: 325, y: 835, width: 150, height: 50))
        butp = setButton( p, label: "Block P", eventnum: "0", size: CGRect(x: 460, y: 590, width: 150, height: 50))
        
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
        image = UIImage(named: "MapPin")!
        var label1 : UILabel = UILabel()
        var event :UILabel = UILabel()
        image1 = imageview
        annot = UIImageView(image:image)
        image1.userInteractionEnabled = true
        annot.userInteractionEnabled = true
        image1.frame = size
        label1.frame = CGRect(x: 17, y: -2, width: 150, height: 50)
        label1.text = label
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = NSTextAlignment.Center
        label1.font = UIFont(name: "Avenir Next", size: 12)
        event.frame = CGRect(x: 1, y: -2, width: 30, height: 50)
        event.text = eventnum
        event.textColor = UIColor.whiteColor()
        event.textAlignment = NSTextAlignment.Center
        event.font = UIFont(name: "Avenir Next", size: 12)
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
        if(scale > 1 && scale <= 2){
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
        
    }
    
    
    func pressed(sender: UIButton!) {
        var alertView = UIAlertView();
        
        var x:Int = 0
        for(x = 0 ; x < names.count ; x++){
            if(sender.tag == x+1){
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

//
//  GoogleMapViewController.swift
//  UniCAT
//
//  Created by Munyee on 27/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GoogleMapViewController: UIViewController,JCTiledScrollViewDelegate,JCTileSource,UIActionSheetDelegate, MapRefreshViewDelegate,UIGestureRecognizerDelegate {

    
    struct Name{
        static var nameof = ""
        static var imageview : NSString = ""
        static var floor : Int = 0
        static var gallery : Int = 0
    }
    
    @IBOutlet weak var cap: SpringImageView!
    @IBOutlet weak var typeButton: UIButton!
    var typeName = ["UniCAT","Notification", "Convocation"]
    var mode = ["normal","convo"]
    var selection = 0
    var depnum = [Int]()
    
    var locationx = CGFloat()
    var locationy = CGFloat()
    
    var first = Bool()
    var thelastone = CGFloat()
    var lastscale = CGFloat()
    var scale:CGFloat = 1
    var lon = Double()
    var lat = Double()
    var joinGroup = NSMutableArray()
    var buildingType = ""
    var today = NSDate()
    let building = Building()
    
    var buildingImage = [SpringImageView()]
    var atmImage = [SpringImageView()]
    
    var button = [UIButton()]
    //arr of normal view
    var atmButton = [UIButton()]
    var arrButton = [[UIButton()]]
    var arrObject = [Set<PFObject>()]
    var arrAlphabet = [[String()]]
    var arrNames = [[String()]]
    var arrDetails = [[String()]]
    var arrImage = [[SpringImageView()]]
    
    
    //arr of convo view
    var arrConvoButton = [UIButton()]
    var arrConvoObject = Set<PFObject>()
    var arrConvoImage = [SpringImageView()]
    var arrConvoAlphabet = [String()]
    var arrConvoNames = [String()]
    var arrConvoDetails = [String()]
    var convoCount = 0
    
    //arr of notification
    var arrNotiButton = [UIButton()]
    var arrNotiObject = Set<PFObject>()
    var arrNotiImage = [SpringImageView()]
    var blockName = [String()]
    
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
    let allPOI = ["building", "departments", "bus", "atm","bank", "food", "clinic","book","washroom","sport","gym"]
    let departments = ["DACE", "DPP", "ITISC", "CEE", "IPSR", "DCCPR", "DISS", "DGS", "DEF", "DSS", "DARP", "DSSC", "DSA", "DFN", "DEAS"]
    var selectedBuilding = ""
    var selectedAlphabet = ""
    var selectedEventCount = ""
    var selectedDetails = ""
    var names:[String] = []
    var alphabet:[String] = []
    var eventcount: [String] = []
    var eventname : [String] = []
    var buildings = ["Heritage Hall","Learning Complex I","Student Pavilion I","Faculty of Science","FEGT","Administration Block","Library","FBF","Lecture Complex I","Engineering Workshop","Student Pavilion II","Lecture Complex II","Grand Hall","FICT & IPSR Lab","FAS & ICS","Sports Complex"]
    
    
    
    func tiledScrollViewDidZoom(scrollView: JCTiledScrollView!) {
        scale = CGFloat(scrollView.zoomScale)
        
        if (typeButton.titleLabel!.text == "Convocation"){
            for (var y = 0 ; y < arrConvoImage.count - 1 ; y++){
                getButton(arrConvoImage[y])
                setButtonLocation(arrConvoButton[y+1])
            }
        }
        
        else if (numtype == 0 && typeButton.titleLabel!.text == "UniCAT"){
            
            
            
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
        else if(typeButton.titleLabel!.text == "UniCAT"){
            
            for (var y = 0 ; y < arrImage[numtype].count-1 ; y++){
                getButton(arrImage[numtype][y])
                setButtonLocation(arrButton[numtype][y+1])
                
                
            }
            
            
        }
        else if(typeButton.titleLabel!.text == "Notification"){
            for (var y = 0 ; y < self.arrNotiImage.count ; y++){
                self.getButton(self.arrNotiImage[y])
                self.setButtonLocation(self.arrNotiButton[y])
                
                
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
        
        
        
        
        
        let currentUser = PFUser.currentUser()
        
        if(currentUser != nil){
            typeName = ["UniCAT","Notification", "Convocation"]
        }else{
            typeName = ["UniCAT", "Convocation"]
        }
        
        if(initView){
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Fetching data"
            initView = false
            
            
        
            
        }
        
        if (selection != 0){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if (currentUser != nil && selection == 1){
        
            
        
            if arrNotiButton.count > 0 {
                for (var y = 0 ; y < self.arrNotiImage.count ; y++){
                    
                    arrNotiImage[y].hidden = true
                    arrNotiButton[y].hidden = true
                    
                    if(y == self.arrNotiImage.count-1){
                        arrNotiButton.removeAll()
                        arrNotiImage.removeAll()
                        arrNotiObject.removeAll()
                    }
                }
            }
        
        
        
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Fetching data"
            
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                buildingImage[actionx].hidden = true
                button[actionx].hidden = true
            }
            
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                
                
                self.buildingImage[actionx].hidden = true
                self.button[actionx+1].hidden = true
            }
            
            for (var c = 0 ; c < allPOI.count ; c++){
                for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                    
                    if(arrButton[c].count > 1){
                        arrImage[c][y].hidden = true
                        arrButton[c][y+1].hidden = true
                    }
                    
                    
                }
            }
            
            
            
            if arrConvoButton.count > 1 {
                for (var y = 0 ; y < self.arrConvoImage.count-1 ; y++){
                    
                    arrConvoImage[y].hidden = true
                    arrConvoButton[y+1].hidden = true
                    
                }
            }
        
            self.blockName.removeAll()
        
            let currentUser = PFUser.currentUser()
            
            if(currentUser != nil){
                let joinquery = PFQuery(className:"JoinGroup")
                joinquery.whereKey("user",equalTo:currentUser!)
                print(currentUser!.objectId!)
                joinquery.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) join.")
                        self.joinGroup.removeAllObjects()
                        
                        for object in objects!{
                            let item = object["group"] as! PFObject
                            
                            self.joinGroup.addObject(item)
                        }
                        // Do something with the found objects
                        
                        let query = PFQuery(className:"Group")
                        query.whereKey("creator",equalTo:currentUser!)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("Successfully retrieved \(objects!.count) groups.")
                                
                                // Do something with the found objects
                                for object in objects!{
                                    
                                    
                                    self.joinGroup.addObject(object)
                                }
                                
                                var x = 0
                                
                                if (self.joinGroup.count == 0){
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let title = "No group found"
                                        let alert = UIAlertController(title: title , message: "Add a new group now?", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let delete = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                                            self.tabBarController?.selectedIndex = 2
                                        }
                                        
                                        alert.addAction(delete)
                                        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.Cancel,handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                }
                                
                                
                                
                                for item in self.joinGroup{
                                    let query = PFQuery(className:"GroupEvent")
                                    query.includeKey("group")
                                    query.orderByAscending("date")
                                    query.whereKey("date", greaterThanOrEqualTo:self.today)
                                    query.whereKey("group", equalTo: item)
                                    query.findObjectsInBackgroundWithBlock {
                                        (objects: [PFObject]?, error: NSError?) -> Void in
                                        
                                        if error == nil {
                                            // The find succeeded.
                                            print("Successfully retrieved \(objects!.count) scores.")
                                            

                                            // Do something with the found objects
                                            if let objects = objects {
                                                for object in objects {
                                                    
                                                    
                                                    self.arrNotiObject.insert(object)
                                                    
                                                    
                                                    
                                                }
                                                x++
                                            }
                                            
                                           
                                            
                                            if (self.joinGroup.count == x) {
                                                
                                                if(self.arrNotiObject.count == 0){
                                                    dispatch_async(dispatch_get_main_queue()) {
                                                        
                                                        let title = "Error"
                                                        let alert = UIAlertController(title: title , message: "No event found", preferredStyle: UIAlertControllerStyle.Alert)
                                                        
                                                        
                                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel,handler: nil))
                                                        
                                                        let vc = MapPickerViewController()
                                                        vc.dismissViewControllerAnimated(true, completion: nil)
                                                        self.presentViewController(alert, animated: true, completion: nil)
                                                    }
                                                }
                                                
                                                var y = 0
                                                var count = 0

                                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                                
                                                for(var g = 0 ; g <= self.buildings.count ; g++){
                                                    for item in self.arrNotiObject{
                                                        
                                                        
//                                                        let coor = item["location"] as! PFGeoPoint
                                                        let name = item["block"] as! String
                                                        
                                                        var location:CLLocation = CLLocation(latitude: 0, longitude: 0)
                                                        
                                                        switch(g){
                                                        case 0:
                                                            location = CLLocation(latitude: 4.336586, longitude: 101.135725)
                                                        case 1:
                                                            location = CLLocation(latitude: 4.335357, longitude: 101.141050)
                                                        case 2:
                                                            location = CLLocation(latitude: 4.336641, longitude: 101.141069)
                                                        case 3:
                                                            location = CLLocation(latitude: 4.337290, longitude: 101.142339)
                                                        case 4:
                                                            location = CLLocation(latitude: 4.338071, longitude: 101.143580)
                                                        case 5:
                                                            location = CLLocation(latitude: 4.338780, longitude: 101.143479)
                                                        case 6:
                                                            location = CLLocation(latitude: 4.339766, longitude: 101.143608)
                                                        case 7:
                                                            location = CLLocation(latitude: 4.339929, longitude: 101.143061)
                                                        case 8:
                                                            location = CLLocation(latitude: 4.341391, longitude: 101.142968)
                                                        case 9:
                                                            location = CLLocation(latitude: 4.340802, longitude: 101.142486)
                                                        case 10:
                                                            location = CLLocation(latitude: 4.341213, longitude: 101.144216)
                                                        case 11:
                                                            location = CLLocation(latitude: 4.342081, longitude: 101.141268)
                                                        case 12:
                                                            location = CLLocation(latitude: 4.341819, longitude: 101.140305)
                                                        case 13:
                                                            location = CLLocation(latitude: 4.340561, longitude: 101.137677)
                                                        case 14:
                                                            location = CLLocation(latitude: 4.338680, longitude: 101.136600)
                                                        case 15:
                                                            location = CLLocation(latitude: 4.338530, longitude: 101.137182)
                                                        case 16:
                                                            location = CLLocation(latitude: 4.337456, longitude: 101.134147)
                                                        default:
                                                            break
                                                            
                                                        }
                                                        
                                                        if(g == 0){
                                                            if (name == "Arena"){
                                                                let tempImage = SpringImageView()
                                                                self.arrNotiImage.insert(tempImage, atIndex: count)
                                                                self.arrNotiButton.append(self.setpoi(self.arrNotiImage[y], size: CGRect(x: ((location.coordinate.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - location.coordinate.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: "shout", block: "", tag: y++))
                                                                count++
                                                                self.blockName.append("Arena")
                                                                break
                                                                
                                                            }
                                                            
                                                        }else {
                                                            if (name == self.buildings[g-1] ){
                                                                let tempImage = SpringImageView()
                                                                self.arrNotiImage.insert(tempImage, atIndex: count)
                                                                self.arrNotiButton.append(self.setpoi(self.arrNotiImage[y], size: CGRect(x: ((location.coordinate.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - location.coordinate.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: "noti", block: "", tag: y++))
                                                                count++
                                                                self.blockName.append(self.buildings[g-1])
                                                                
                                                                break
                                                                
                                                            }
                                                            
                                                        }

                                                        
                                                        

                                                        
                                                    }
                                                    if(y == self.buildings.count+1){
                                                        for (var z = 0 ; z < self.arrNotiImage.count ; z++){
                                                            self.getButton(self.arrNotiImage[z])
                                                            self.setButtonLocation(self.arrNotiButton[z])
                                                            
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                        } else {
                                            // Log details of the failure
                                            print("Error: \(error!) \(error!.userInfo)")
                                        }
                                    }
                                    
                                }
                                
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    
                }
            }
        
        
        }
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
       
        buildingImage = []
        first = true
        tag = 0
        super.viewDidLoad()
        
        cap.hidden = true
        convoCount = 0
        
        
        if(PFUser.currentUser() == nil){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
        }
        
        
        for (var x = 0 ; x < allPOI.count ; x++){
            let tempButton = [UIButton()]
            let tempObject = Set<PFObject>()
            let tempImage = [SpringImageView()]
            let tempAlphabet = [String()]
            arrButton.insert(tempButton, atIndex: x)
            arrObject.insert(tempObject, atIndex: x)
            arrImage.insert(tempImage, atIndex: x)
            arrAlphabet.insert(tempAlphabet, atIndex: x)
            arrNames.insert(tempAlphabet, atIndex: x)
            arrDetails.insert(tempAlphabet, atIndex: x)
            count.insert(0, atIndex: x)
        }
        
        self.buildingType = "building"
        
        
        let button1: UIButton = UIButton()
        
        button1.setImage(UIImage(named: "poi"), forState: .Normal)
        button1.frame = CGRectMake(0, 0, 45, 45)
        button1.targetForAction("actioncall", withSender: nil)
        button1.addTarget(self, action: "downloadSheet:", forControlEvents: .TouchUpInside)
        
        let rightItem1:UIBarButtonItem = UIBarButtonItem()
        rightItem1.customView = button1
        
        let array : Array = [rightItem1];
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
//        for (var a = 0 ; a < allPOI.count ; a++){
            let query = PFQuery(className:"Annotations")
//            query.whereKey("type", equalTo:self.allPOI[a])
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    
                    // Do something with the found objects
                    if let objects = objects {
                        
                        for object in objects {
                            let type = object["type"] as! String
                            let mode = object["mode"] as! String
                            let building = object["name"] as! String
                            let alp = object["alphabet"] as! String
                            let details = object["details"] as! String
                            
                            switch(mode){
                            case "normal":
                                switch(type){
                                case "building":
                                    let image = SpringImageView()
                                    self.buildingImage.append(image)
                                    self.eventcount.append("o")
                                    
                                    self.names.append(building)
                                    
                                    self.alphabet.append(alp)
                                    self.buildingObject.insert(object)
                                    
                                case "bus":
                                    let index = 2
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)
                                    
                                case "departments":
                                   let index = 1
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                    
                                case "atm":
                                    let index = 3
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)
                                    

                                    
                                case "bank":
                                    let index = 4
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                    
                                case "food":
                                    let index = 5
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                    
                                case "clinic":
                                    let index = 6
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                case "book":
                                    let index = 7
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                case "washroom":
                                    let index = 8
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                case "sport","gym":
                                    let index = 9
                                    let tempButton = [UIButton()]
                                    self.arrButton.insert(tempButton, atIndex: index)
                                    let image = SpringImageView()
                                    self.arrImage[index].append(image)
                                    self.arrObject[index].insert(object)

                                default:
                                    break
                                }
                                
                            case "convo" :
                                let image = SpringImageView()
                                self.arrConvoImage.append(image)
                                
                                self.arrConvoObject.insert(object)
                                
                            default:
                                break
                            }
                            
                            
                            
                        }
                        if self.buildingObject.count == 16{
                            self.checkconnection()
                        }
                        
                    }
                    
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
//        }
        
        scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf"))
        
        scrollView.tiledScrollViewDelegate = self
        scrollView.zoomScale = 1.0
        
        scrollView.dataSource = self
        scrollView.tiledScrollViewDelegate = self
        scrollView.tiledView.shouldAnnotateRect = true
        scrollView.levelsOfZoom = 1;
        scrollView.levelsOfDetail = 1;
        
        
            let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            lpgr.delegate = self
            scrollView.addGestureRecognizer(lpgr)
        
        let long = (CGFloat)((101.14105 - longmin) / (longmax - longmin) * 1000)
        let lat = (CGFloat)((latmax - 4.335357) / (latmax - latmin) * 1000)
        scrollView.scrollView.setContentOffset (CGPoint(x: long - UIScreen.mainScreen().bounds.width/2, y: lat - UIScreen.mainScreen().bounds.height/2), animated: true)
        
        
        
        view.addSubview(scrollView)
        
    }
    
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let currentUser = PFUser.currentUser()
        let approve = currentUser!["approve"] as? String
        if  approve == "yes" {
        
        self.locationx = gestureReconizer.locationInView(scrollView.scrollView).x
        self.locationy = gestureReconizer.locationInView(scrollView.scrollView).y
        if gestureReconizer.state == UIGestureRecognizerState.Began {
            self.performSegueWithIdentifier("mapToGroup", sender: nil)

        }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setpoi(imageview :SpringImageView,size:CGRect,item:String,block:String, tag:Int) -> UIButton{
        
        let button :UIButton = UIButton()
        button.frame = CGRect(x: size.origin.x-size.width/2, y: size.origin.y-size.height, width: size.width, height: size.height)
        button.tag = tag
        button.setTitle(block, forState: .Normal)
        button.setTitleColor(UIColor.clearColor(), forState: .Normal)
        button.addTarget(self, action: "busPress:", forControlEvents: .TouchUpInside)
        var annot : UIImageView = UIImageView()
        annot.frame = CGRectMake(0, 0, size.width, size.height)
        var image : UIImage = UIImage()
        var image1 : UIImageView = UIImageView()
        image1 = imageview
        image1.frame = size
        
        var capimage : UIImage = UIImage()
        var capImageView : UIImageView = UIImageView()
        
            //set the convo cap
        
            
            
            
            capimage = UIImage(named:"Cap")!
            capImageView = UIImageView(image: capimage)
            
            
            capImageView.frame = CGRect(x: -12, y: -12, width: 45*1.42, height: 45.0)
            
            capImageView.transform = CGAffineTransformMakeRotation(-0.28);

        
        
        switch(item){
        case "bus":
            image = UIImage(named: "Bus")!
        case "departments":
            image = UIImage(named: "dep")!
        case "atm":
            image = UIImage(named: "atm")!
        case "bank":
            image = UIImage(named: "bank")!
        case "book":
            image = UIImage(named: "book")!
        case "gym":
            image = UIImage(named: "gym")!
        case "sport":
            image = UIImage(named: "sport")!
        case "food":
            image = UIImage(named: "Food")!
        case "clinic":
            image = UIImage(named: "Clinic")!
        case "washroom":
            image = UIImage(named: "washroom")!
        case "noti":
            image = UIImage(named: "group")!
        case "shout":
            image = UIImage(named :"shout")!
        default:
            break
        }
        
        image1.bounds = CGRect(x: size.width/2, y: size.height, width: size.width, height: size.height)
        annot = UIImageView(image:image)
        
        image1.addSubview(annot)
        if (typeName[selection] == "Convocation"){
            image1.addSubview(capImageView)
        }
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
        image1.alpha = 0.5
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
                selectedDetails = arrDetails[0][arrDetails[0].count-1]
                self.performSegueWithIdentifier("mapToBuilding", sender: nil)
                break
            }
            if(sender.tag%names.count == x+1){
                
                Name.nameof = names[x]
               
                
                selectedBuilding = names[x]
                selectedAlphabet = alphabet[x]
                selectedEventCount = eventcount[x]
                selectedDetails = arrDetails[0][x+1]
                self.performSegueWithIdentifier("mapToBuilding", sender: nil)
                break
            }
        }
        
    }

  
    
    //Set the Annotation location
    func getButton(image:SpringImageView)->CGRect{
        var scale:CGFloat;
        
        lastscale = 1
        scale = CGFloat(scrollView.zoomScale)
        print(scale)
        
        if(first == true){
            
            image.frame = CGRect(x:image.frame.origin.x/lastscale, y: image.frame.origin.y/lastscale,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: image.frame.width, height: image.frame.height)
            
        }
        else if(first == false)
        {
            image.frame = CGRect(x:image.frame.origin.x/thelastone, y: image.frame.origin.y/thelastone,width: image.frame.width, height: image.frame.height)
            image.frame = CGRect(x:image.frame.origin.x*scale, y: image.frame.origin.y*scale,width: image.frame.width, height: image.frame.height)
            
            
        }
        
    
        
        
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
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel" , destructiveButtonTitle: nil, otherButtonTitles: "Buildings","Departments","Bus Stop", "ATM","Bank", "Food", "Clinic","Book Store","Wash Room","Sports")
        actionSheet.tag = 1
        
        actionSheet.showInView(self.view)
    }
    
    
    func activeQR(sender:UIButton!){
        
        self.performSegueWithIdentifier("MapToQR", sender: nil)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
    
        
        if (actionSheet.tag == 1){
            depnum = []
            if (buttonIndex > 0){
                numtype = buttonIndex - 1
                self.buildingType = allPOI[numtype]
            }
            
            if (buttonIndex == 2){
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil , destructiveButtonTitle: nil, otherButtonTitles: "Department of Admissions and Credit Evaluation", "Division of Programme Promotion", "IT Infrastructure and Support Centre", "Centre for Extension Education",  "Institute of Postgraduate Studies and Research", "Division of Corporate Communication and Public Relation", "Department of International Student Service", "Department of General Services", "Department of Estate and Facilities", "Department of Safety and Security", "Deparment of Alumni Relations and Placement", "Department of Soft Skills Competency", "Department of Student Affairs", "Division of Finance", "Division of Examination, Awards and Scholarship")
                actionSheet.tag = 2
                actionSheet.showInView(self.view)
            }
            
            
            else if (buttonIndex == 0){
                actionSheet.dismissWithClickedButtonIndex(0, animated: true)
            }
            
            if (buttonIndex == 1 && buttonIndex != 2 ){
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
            
            else if(buttonIndex > 1){
                for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                    buildingImage[actionx].hidden = true
                    button[actionx].hidden = true
                }
            }
            
            
            if (buttonIndex > 0){
                
                
                if(count[buttonIndex-1] == 0){
                    
                    
                            
                    for item in self.arrObject[buttonIndex-1]{
                        let type = item["type"] as! String
                        let coor = item["coordinate"] as! PFGeoPoint
                        let name = item["name"] as! String
                        let alp = item["alphabet"] as! String
                        let details = item["details"] as! String
                        self.buildingType = type
                        
                        self.arrAlphabet[numtype].append(alp)
                        self.arrNames[numtype].append(name)
                        self.arrDetails[numtype].append(details)
                        for(var x = 0 ; x < alphabet.count ; x++){
                            if(alphabet[x] == alp){
                                self.arrButton[buttonIndex-1].append(self.setpoi(self.arrImage[buttonIndex-1][self.count[buttonIndex-1]], size: CGRect(x: ((coor.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - coor.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: type, block: name,tag:self.count[buttonIndex-1]))
                                self.count[buttonIndex-1]++
                            }
                        }
                        
                    }
                }
                
                var check = 0
                var short = 0.0
                var point = PFGeoPoint()
                var select = 0
                
                for (var c = 0 ; c < allPOI.count ; c++){
                    
                    if (buttonIndex == 2){
                        
                    }
                    else if (c == buttonIndex-1){
                        print(arrObject[c])
                        
                        for item in arrObject[c]{
                            
                            let coor = item["coordinate"] as! PFGeoPoint
                            let userpoint = PFGeoPoint(latitude: self.lat, longitude: self.lon)
                            let distance = coor.distanceInKilometersTo(userpoint)
                            print(distance)
                            
                            
                            if(short == 0){
                                short = distance
                                point = coor
                                select = c
                                check++
                            }
                            else{
                                if(distance < short){
                                    short = distance
                                    point = coor
                                    select = c
                                    check++
                                    
                                }
                                else{
                                    check++
                                }
                            }
                            
                            
                            
                            if(check == arrObject[c].count){
                                let long = (CGFloat)((point.longitude - longmin) / (longmax - longmin) * 1000)
                                let lat = (CGFloat)((latmax - point.latitude) / (latmax - latmin) * 1000)
                                scrollView.scrollView.setContentOffset (CGPoint(x: long - UIScreen.mainScreen().bounds.width/2, y: lat - UIScreen.mainScreen().bounds.height/2), animated: true)
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                        
                        if( c == buttonIndex-1 && buttonIndex != 2){
                            
                            arrImage[c][y].hidden = false
                            arrButton[c][y+1].hidden = false
                            self.arrImage[c][y].animation = "fadeIn"
                            self.arrImage[c][y].curve = "easeIn"
                            self.arrImage[c][y].duration = 2.5
                            self.arrImage[c][y].animate()
                            getButton(arrImage[c][y])
                            setButtonLocation(arrButton[c][y+1])
                            
                        }
                            
                        else if(arrButton[c].count > 1 && buttonIndex != 2){
                            arrImage[c][y].hidden = true
                            arrButton[c][y+1].hidden = true
                        }
                        
                        
                    }
                    
                    
                    
                }
            }
        }
        else if (actionSheet.tag == 2){

            depnum = []
            
            for (var c = 0 ; c < allPOI.count ; c++){
                for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                    
                    if(arrButton[c].count > 1){
                        arrImage[c][y].hidden = true
                        arrButton[c][y+1].hidden = true
                    }
                    
                    
                }
            }
            
            
            if(buttonIndex >= 0){
                var x = 0
                for item in arrObject[1]{
                    let coor = item["coordinate"] as! PFGeoPoint
                    let name = item["name"] as! String
                    
                    if name == departments[buttonIndex]{
                        depnum.append(x)
                        arrImage[1][x].hidden = false
                        arrButton[1][x+1].hidden = false
                        self.arrImage[1][x].animation = "fadeIn"
                        self.arrImage[1][x].curve = "easeIn"
                        self.arrImage[1][x].duration = 2.5
                        self.arrImage[1][x].animate()
                        getButton(arrImage[1][x])
                        setButtonLocation(arrButton[1][x+1])
                        let userpoint = PFGeoPoint(latitude: self.lat, longitude: self.lon)
                        let distance = coor.distanceInKilometersTo(userpoint)
                       
                        
                        
                        
                        
                        
                        
                        
                            let long = (CGFloat)((coor.longitude - longmin) / (longmax - longmin) * 1000)
                            let lat = (CGFloat)((latmax - coor.latitude) / (latmax - latmin) * 1000)
                            scrollView.scrollView.setContentOffset (CGPoint(x: long - UIScreen.mainScreen().bounds.width/2, y: lat - UIScreen.mainScreen().bounds.height/2), animated: true)
                        

                        x++
                        
                    }
                    else{
                        x++
                    }
                }
                
            }

        }
        
        
        
    }
    
    
    
    func checkconnection(){
        
        var temp : [String] = []
        var counter:Int = 0
        var check : Int = 0
        
        
        if(arrConvoObject.count == 0){
            typeName = ["UniCAT"]
        }
        
        //check event
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
                            let details = item["details"] as! String
                            
                            if (building == self.names[y]){
                            
                                
                                let layer = item["layer"] as! String
                                
                                self.arrDetails[0].append(details)
                                
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
    
    @IBAction func chooseType(sender: AnyObject) {
        scrollView.setZoomScale(1, animated: true)
    self.performSegueWithIdentifier("pickerView", sender: self)
    }
    
    func updateClass(classType: Int) {
        selection = classType
        
        typeButton.setTitle(typeName[selection], forState: UIControlState.Normal)
        
        if(selection == 0){
            convoCount = 0
            cap.hidden = true
            self.buildingType = allPOI[numtype]
            
            let button1: UIButton = UIButton()
            
            button1.setImage(UIImage(named: "poi"), forState: .Normal)
            button1.frame = CGRectMake(0, 0, 45, 45)
            button1.targetForAction("actioncall", withSender: nil)
            button1.addTarget(self, action: "downloadSheet:", forControlEvents: .TouchUpInside)
            
            let rightItem1:UIBarButtonItem = UIBarButtonItem()
            rightItem1.customView = button1
            
            let array : Array = [rightItem1];
            self.navigationItem.rightBarButtonItems = array
            
            
            let qrbutton: UIButton = UIButton()
            qrbutton.setImage(UIImage(named: "QR"), forState: .Normal)
            qrbutton.frame = CGRectMake(0, 0, 45, 45)
            qrbutton.targetForAction("actioncall", withSender: nil)
            qrbutton.addTarget(self, action: "activeQR:", forControlEvents: .TouchUpInside)
            
            let qrItem:UIBarButtonItem = UIBarButtonItem()
            qrItem.customView = qrbutton
            
            self.navigationItem.leftBarButtonItem = qrItem
            
            if(numtype == 0){
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
                if (depnum.count != 0){
                    for (var y = 0 ; y < depnum.count; y++){
                        
                        
                        arrImage[numtype][depnum[y]].hidden = false
                        arrButton[numtype][depnum[y]+1].hidden = false
                        self.arrImage[numtype][depnum[y]].animation = "fadeIn"
                        self.arrImage[numtype][depnum[y]].curve = "easeIn"
                        self.arrImage[numtype][depnum[y]].duration = 2.5
                        self.arrImage[numtype][depnum[y]].animate()
                        getButton(arrImage[numtype][depnum[y]])
                        setButtonLocation(arrButton[numtype][depnum[y]+1])
                        
                    }
                }
                else{
                    for (var y = 0 ; y < arrImage[numtype].count-1 ; y++){
                        
                        
                        arrImage[numtype][y].hidden = false
                        arrButton[numtype][y+1].hidden = false
                        self.arrImage[numtype][y].animation = "fadeIn"
                        self.arrImage[numtype][y].curve = "easeIn"
                        self.arrImage[numtype][y].duration = 2.5
                        self.arrImage[numtype][y].animate()
                        getButton(arrImage[numtype][y])
                        setButtonLocation(arrButton[numtype][y+1])
                        
                        
                        
                    }
                }
                
            }
            
            if arrConvoButton.count > 1 {
                for (var y = 0 ; y < self.arrConvoImage.count-1 ; y++){
                    
                    arrConvoImage[y].hidden = true
                    arrConvoButton[y+1].hidden = true
                    
                }
            }
            
            if arrNotiButton.count > 0 {
                for (var y = 0 ; y < self.arrNotiImage.count ; y++){
                    
                    arrNotiImage[y].hidden = true
                    arrNotiButton[y].hidden = true
                    
                }
            }
 
        
        }
        else if selection == 1 && typeName[selection] == "Notification"{
            convoCount = 0
            cap.hidden = true
            self.navigationItem.rightBarButtonItem = nil

            if arrNotiButton.count > 0 {
                for (var y = 0 ; y < self.arrNotiImage.count ; y++){
                    
                    arrNotiImage[y].hidden = true
                    arrNotiButton[y].hidden = true
                    
                    if(y == self.arrNotiImage.count-1){
                        arrNotiButton.removeAll()
                        arrNotiImage.removeAll()
                        arrNotiObject.removeAll()
                    }
                }
            }
            
            
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Fetching data"
            
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                buildingImage[actionx].hidden = true
                button[actionx].hidden = true
            }
            
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                
                
                self.buildingImage[actionx].hidden = true
                self.button[actionx+1].hidden = true
            }
            
            for (var c = 0 ; c < allPOI.count ; c++){
                for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                    
                    if(arrButton[c].count > 1){
                        arrImage[c][y].hidden = true
                        arrButton[c][y+1].hidden = true
                    }
                    
                    
                }
            }
            
            
            
            if arrConvoButton.count > 1 {
                for (var y = 0 ; y < self.arrConvoImage.count-1 ; y++){
                    
                    arrConvoImage[y].hidden = true
                    arrConvoButton[y+1].hidden = true
                    
                }
            }
            
            blockName.removeAll()
            
            let currentUser = PFUser.currentUser()
            
            if(currentUser != nil){
                let joinquery = PFQuery(className:"JoinGroup")
                joinquery.whereKey("user",equalTo:currentUser!)
                print(currentUser!.objectId!)
                joinquery.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) join.")
                        self.joinGroup.removeAllObjects()
                        
                        for object in objects!{
                            let item = object["group"] as! PFObject
                            
                            self.joinGroup.addObject(item)
                        }
                        // Do something with the found objects
                        
                        let query = PFQuery(className:"Group")
                        query.whereKey("creator",equalTo:currentUser!)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("Successfully retrieved \(objects!.count) groups.")
                                
                                // Do something with the found objects
                                for object in objects!{
                                    
                                    
                                    self.joinGroup.addObject(object)
                                }
                                
                                var x = 0
                                
                                if (self.joinGroup.count == 0){
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let title = "No group found"
                                        let alert = UIAlertController(title: title , message: "Add a new group now?", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let delete = UIAlertAction(title : "Ok", style:  UIAlertActionStyle.Default) { (action) in
                                            self.tabBarController?.selectedIndex = 2
                                        }
                                        
                                        alert.addAction(delete)
                                        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.Cancel,handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                }
                                
                                
                                
                                for item in self.joinGroup{
                                    let query = PFQuery(className:"GroupEvent")
                                    query.includeKey("group")
                                    query.orderByAscending("date")
                                    query.whereKey("date", greaterThanOrEqualTo:self.today)
                                    query.whereKey("group", equalTo: item)
                                    query.findObjectsInBackgroundWithBlock {
                                        (objects: [PFObject]?, error: NSError?) -> Void in
                                        
                                        if error == nil {
                                            // The find succeeded.
                                            print("Successfully retrieved \(objects!.count) scores.")
                                            
                                            
                                            // Do something with the found objects
                                            if let objects = objects {
                                                for object in objects {
                                                    
                                                    
                                                    self.arrNotiObject.insert(object)
                                                    
                                                    
                                                    
                                                }
                                                x++
                                            }
                                            
                                            
                                            
                                            if (self.joinGroup.count == x) {
                                                
                                                if(self.arrNotiObject.count == 0){
                                                    dispatch_async(dispatch_get_main_queue()) {
                                                        
                                                        let title = "Error"
                                                        let alert = UIAlertController(title: title , message: "No event found", preferredStyle: UIAlertControllerStyle.Alert)
                                                        
                                                        
                                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel,handler: nil))
                                                        
                                                        let vc = MapPickerViewController()
                                                        vc.dismissViewControllerAnimated(true, completion: nil)
                                                        self.presentViewController(alert, animated: true, completion: nil)
                                                    }
                                                }
                                                
                                                var y = 0
                                                var count = 0
                                                
                                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                                
                                                for(var g = 0 ; g <= self.buildings.count ; g++){
                                                    for item in self.arrNotiObject{
                                                        
                                                        
                                                        //                                                        let coor = item["location"] as! PFGeoPoint
                                                        let name = item["block"] as! String
                                                        
                                                        var location:CLLocation = CLLocation(latitude: 0, longitude: 0)
                                                        
                                                        switch(g){
                                                        case 0:
                                                            location = CLLocation(latitude: 4.336586, longitude: 101.135725)
                                                        case 1:
                                                            location = CLLocation(latitude: 4.335357, longitude: 101.141050)
                                                        case 2:
                                                            location = CLLocation(latitude: 4.336641, longitude: 101.141069)
                                                        case 3:
                                                            location = CLLocation(latitude: 4.337290, longitude: 101.142339)
                                                        case 4:
                                                            location = CLLocation(latitude: 4.338071, longitude: 101.143580)
                                                        case 5:
                                                            location = CLLocation(latitude: 4.338780, longitude: 101.143479)
                                                        case 6:
                                                            location = CLLocation(latitude: 4.339766, longitude: 101.143608)
                                                        case 7:
                                                            location = CLLocation(latitude: 4.339929, longitude: 101.143061)
                                                        case 8:
                                                            location = CLLocation(latitude: 4.341391, longitude: 101.142968)
                                                        case 9:
                                                            location = CLLocation(latitude: 4.340802, longitude: 101.142486)
                                                        case 10:
                                                            location = CLLocation(latitude: 4.341213, longitude: 101.144216)
                                                        case 11:
                                                            location = CLLocation(latitude: 4.342081, longitude: 101.141268)
                                                        case 12:
                                                            location = CLLocation(latitude: 4.341819, longitude: 101.140305)
                                                        case 13:
                                                            location = CLLocation(latitude: 4.340561, longitude: 101.137677)
                                                        case 14:
                                                            location = CLLocation(latitude: 4.338680, longitude: 101.136600)
                                                        case 15:
                                                            location = CLLocation(latitude: 4.338530, longitude: 101.137182)
                                                        case 16:
                                                            location = CLLocation(latitude: 4.337456, longitude: 101.134147)
                                                        default:
                                                            break
                                                            
                                                        }
                                                        
                                                        if(g == 0){
                                                            if (name == "Arena"){
                                                                let tempImage = SpringImageView()
                                                                self.arrNotiImage.insert(tempImage, atIndex: count)
                                                                self.arrNotiButton.append(self.setpoi(self.arrNotiImage[y], size: CGRect(x: ((location.coordinate.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - location.coordinate.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: "shout", block: "", tag: y++))
                                                                count++
                                                                self.blockName.append("Arena")
                                                                break
                                                                
                                                            }
                                                            
                                                        }else {
                                                            if (name == self.buildings[g-1] ){
                                                                let tempImage = SpringImageView()
                                                                self.arrNotiImage.insert(tempImage, atIndex: count)
                                                                self.arrNotiButton.append(self.setpoi(self.arrNotiImage[y], size: CGRect(x: ((location.coordinate.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - location.coordinate.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: "noti", block: "", tag: y++))
                                                                count++
                                                                self.blockName.append(self.buildings[g-1])

                                                                break
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    if(y == self.buildings.count+1){
                                                        for (var z = 0 ; z < self.arrNotiImage.count ; z++){
                                                            self.getButton(self.arrNotiImage[z])
                                                            self.setButtonLocation(self.arrNotiButton[z])
                                                            
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                        } else {
                                            // Log details of the failure
                                            print("Error: \(error!) \(error!.userInfo)")
                                        }
                                    }
                                    
                                }
                                
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    
                }
            }
         
            
        }else{
            
            self.navigationItem.rightBarButtonItem = nil
            cap.hidden = false
            cap.animation = "fadeInDown"
            cap.curve = "easeInOut"
            cap.duration = 1.0
            cap.force = 0.5
            cap.animate()
            self.cap.transform = CGAffineTransformMakeRotation(-0.28);

            self.navigationItem.rightBarButtonItems = nil
    
            self.navigationItem.leftBarButtonItem = nil
    
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
                buildingImage[actionx].hidden = true
                button[actionx].hidden = true
            }
    
            for (var actionx = 0 ; actionx < buildingImage.count ; actionx++){
    
                self.buildingImage[actionx].hidden = true
                self.button[actionx+1].hidden = true
            }
    
            for (var c = 0 ; c < allPOI.count ; c++){
                for (var y = 0 ; y < arrImage[c].count-1 ; y++){
                    
                    if(arrButton[c].count > 1){
                        arrImage[c][y].hidden = true
                        arrButton[c][y+1].hidden = true
                    }
                    
                    
                }
            }
            
            var check = 0
            var short = 0.0
            var point = PFGeoPoint()
            
            if(arrConvoButton.count == 1){
                for item in self.arrConvoObject{
                    
                    let type = item["type"] as! String
                    let coor = item["coordinate"] as! PFGeoPoint
                    let name = item["name"] as! String
                    let alp = item["alphabet"] as! String
                    let details = item["details"] as! String
                    self.buildingType = type
                    
                    self.arrConvoAlphabet.append(alp)
                    self.arrConvoNames.append(name)
                    self.arrConvoDetails.append(details)
                    for(var x = 0 ; x < alphabet.count ; x++){
                        if(alphabet[x] == alp){
                            self.arrConvoButton.append(self.setpoi(self.arrConvoImage[self.convoCount], size: CGRect(x: ((coor.longitude - self.longmin)/(self.longmax - self.longmin)) * 1000, y:  ((self.latmax - coor.latitude)/(self.latmax - self.latmin)) * 1000, width: 50, height: 72), item: type, block: name,tag:self.convoCount))
                            self.convoCount++
                        }
                    }
                    
                   
                    
                }
            }
            
            
            if arrNotiButton.count > 0 {
                for (var y = 0 ; y < self.arrNotiImage.count ; y++){
                    
                    arrNotiImage[y].hidden = true
                    arrNotiButton[y].hidden = true
                    
                }
            }
            
            for item in self.arrConvoObject{

                let coor = item["coordinate"] as! PFGeoPoint
                let userpoint = PFGeoPoint(latitude: self.lat, longitude: self.lon)
                let distance = coor.distanceInKilometersTo(userpoint)
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
                if(check == arrConvoObject.count){
                    let long = (CGFloat)((point.longitude - longmin) / (longmax - longmin) * 1000)
                    let lat = (CGFloat)((latmax - point.latitude) / (latmax - latmin) * 1000)
                    scrollView.scrollView.setContentOffset (CGPoint(x: long - UIScreen.mainScreen().bounds.width/2, y: lat - UIScreen.mainScreen().bounds.height/2), animated: true)
                }
                
            }

            for (var y = 0 ; y < self.arrConvoImage.count-1 ; y++){
                
                
                
                arrConvoImage[y].hidden = false
                arrConvoButton[y+1].hidden = false
                self.arrConvoImage[y].animation = "fadeIn"
                self.arrConvoImage[y].curve = "easeIn"
                self.arrConvoImage[y].duration = 2.5
                self.arrConvoImage[y].animate()
                getButton(arrConvoImage[y])
                setButtonLocation(arrConvoButton[y+1])
        
            }
       
        }
        
    }
    
    func busPress(sender: UIButton!){

        if (selection == 0){
            selectedBuilding = arrNames[numtype][sender.tag+1]
            selectedAlphabet = arrAlphabet[numtype][sender.tag+1]
            selectedEventCount = "0"
            selectedDetails = arrDetails[numtype][sender.tag+1]
            self.performSegueWithIdentifier("mapToBuilding", sender: nil)

        }
        else if(selection == 1 && typeName[selection] == "Notification"){
            self.performSegueWithIdentifier("mapToGroupEvent", sender: sender.tag)
            scrollView.setZoomScale(1, animated: true)

        }
        else if(selection == 2){
            selectedBuilding = arrConvoNames[sender.tag+1]
            selectedAlphabet = arrConvoAlphabet[sender.tag+1]
            selectedEventCount = "0"
            selectedDetails = arrConvoDetails[sender.tag+1]
            self.performSegueWithIdentifier("mapToBuilding", sender: nil)

        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapToBuilding" {
            let detailScene = segue.destinationViewController as! BuildingViewController
            
            detailScene.currentBuilding = selectedBuilding
            detailScene.currentAlphabet = selectedAlphabet
            detailScene.eventCount = selectedEventCount
            detailScene.buildingtype = buildingType
            detailScene.details = selectedDetails
        }
        else if segue.identifier == "pickerView" {
            let pickerScene = segue.destinationViewController as! MapPickerViewController
            
            pickerScene.type = selection
            pickerScene.typeName = self.typeName
            pickerScene.refreshDelegate = self
        }
        else if segue.identifier == "mapToGroup" {
            let pickerScene = segue.destinationViewController as! EventTableViewController
            
            pickerScene.pointSelected = CLLocationCoordinate2D(latitude: Double(self.locationy), longitude: Double(self.locationx))
            pickerScene.scale = self.scale
        }
        else if segue.identifier == "mapToGroupEvent" {
            let pickerScene = segue.destinationViewController as! ForumTableViewController
            
            pickerScene.block = self.blockName[sender as! Int]
            
//            if(sender as! Int == 0){
//                pickerScene.block = "Arena"
//            }else{
//                pickerScene.block = self.buildings[sender as! Int - 1 ]
//            }
//            var x = 0
//            for item in arrNotiObject{
//                if (x == sender as! Int){
//                    pickerScene.eventObject.insert(item)
//                    break
//                }
//                else{
//                    x++
//                }
//            }
            
        }
    }
    

}

//
//  GoogleMapViewController.swift
//  UniCAT
//
//  Created by Munyee on 27/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class GoogleMapViewController: UIViewController,GMSMapViewDelegate {

    let icon = UIImage(named: "overlay_park.png")
    let latmin = 4.332435;
    let latmax = 4.345159;
    let longmin = 101.133013;
    let longmax = 101.145641;
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        let camera = GMSCameraPosition.cameraWithLatitude(4.335282, longitude: 101.141171, zoom: 17)
        let tempmapView = GMSMapView.mapWithFrame(CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44), camera: camera)
//
        tempmapView.delegate = self
        
        
        let southWest = CLLocationCoordinate2DMake(latmax, longmin)
        let northEast = CLLocationCoordinate2DMake(latmin, longmax)
        
        let region = GMSVisibleRegion(nearLeft: CLLocationCoordinate2DMake(latmin, longmin), nearRight: CLLocationCoordinate2DMake(latmax, longmax), farLeft: CLLocationCoordinate2DMake(latmin, longmin), farRight: CLLocationCoordinate2DMake(latmax, longmax))
        let overlayBounds = GMSCoordinateBounds(region: region)
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
    
        let vancouver = CLLocationCoordinate2DMake(latmax, longmin)
        let calgary = CLLocationCoordinate2DMake(latmin, longmax)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        let camera123 = tempmapView.cameraForBounds(bounds, insets:UIEdgeInsetsZero)
        tempmapView.camera = camera123
        
        tempmapView.setMinZoom(16, maxZoom: 18)
        overlay.map = tempmapView
        self.view = tempmapView
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

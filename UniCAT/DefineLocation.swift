//
//  DefineLocation.swift
//  UniCAT
//
//  Created by Munyee on 7/21/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit

public class DefineLocation{
    
    static var lon : Double = Double()
    static var lat : Double = Double()
    static var updated : Bool = Bool()
    
    class func userlocation(userannotation:UIImageView){
        
        var latmin = 4.332435
        var latmax = 4.345159
        var longmin = 101.133013
        var longmax = 101.145641
        var newlon : Double = Double()
        var newlat : Double = Double()
        updated = false
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.lon = geoPoint!.longitude as Double
                self.lat = geoPoint!.latitude as Double
                print(self.lat)
                print(self.lon)
            }
        }
        
        if(lon != 0 && lon >= longmin && lon <= longmax){
            newlon = (((101.142407 - longmin)/(longmax - longmin))-0.0135)*1000
            
        }
        
        if(lat != 0 && lat >= latmin && lat <= latmax){
            newlat = ((((latmax - 4.337223)/(latmax-latmin))-0.05)*1000)+4
            
        }
        
        var user = UIImageView()
        
        var image = UIImage()
        image = UIImage(named: "user")!
        
        if(newlon != 0 && newlat != 0){
            
            print(newlon)
            print(newlat)
            userannotation.frame = CGRect(x: newlon+13.5, y: newlat+58, width: 27, height: 50)
            userannotation.image = image
            updated = true
        }
        
        
        //return user
        
    }
    
    
}
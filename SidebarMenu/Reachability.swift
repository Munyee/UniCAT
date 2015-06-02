//
//  Reachability.swift
//  SidebarMenu
//
//  Created by Munyee on 5/31/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation

public class Reachability{
    class func isConnectedToNetwork() -> Bool{
        var Status:Bool = false
        let url = NSURL(string:"http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 5
        
        var response : NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}
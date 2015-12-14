//
//  TCUserLocation.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCUserLocationManager.h"

@interface TCUserLocationManager ()

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic, copy) TCUserLocationCallback completionBlock;

@end

@implementation TCUserLocationManager

@synthesize locationManager = _locationManager;

#pragma mark - Location Services

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];        
    }
    return _locationManager;
}

- (void)startLocatingUserWithCompletion:(TCUserLocationCallback)completion
{
    self.completionBlock = completion;
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocatingUser
{    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
//    
//    [self mapView:self.mapView setCameraTarget:newLocation.coordinate selectMarker:nil];
    
    // We don't want a cached location that is too out of date.
    NSTimeInterval locationAge = fabs([newLocation.timestamp timeIntervalSinceNow]);
    if (locationAge > 15.0f) { return; }
    
    // Horizontal accuracy returns a negative value to indicate that the location's
    // longitude and latitude are invalid.
    if (newLocation.horizontalAccuracy < 0) { return; }
    
    // Only save the new location if it's more accurate than previous locations.
    if (nil == self.myLocation || self.myLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.myLocation = newLocation;
        NSLog(@"%@",self.myLocation);
        // If we have a measurement that meets our requirements, we can stop updating the location.
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            [self stopLocatingUser];
            
            // Callback to indicate that we've got the user's location.
            self.completionBlock(self.myLocation, nil);
            self.completionBlock = nil;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] != kCLErrorLocationUnknown) {
        self.completionBlock(nil, error);
        self.completionBlock = nil;
    }
}


- (void)mapView:(GMSMapView *)mapView setCameraTarget:(CLLocationCoordinate2D)coordinate selectMarker:(GMSMarker *)marker
{
    // Show the info window of the selected marker.
    mapView.selectedMarker = marker;
    
    // Zoom in to focus on target location.
    [mapView animateWithCameraUpdate:
     [GMSCameraUpdate setTarget:coordinate zoom:17.0f]];
}

@end

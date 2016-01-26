//
//  TCMapViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "TCGooglePlaces.h"
#import "TCGoogleDirections.h"
#import "TCUserLocationManager.h"
#import "TCMapViewController.h"
#import "TCStepsViewController.h"
#import "TCCellModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CustomInfoWindow.h"


@interface TCMapViewController (){
    CLLocationCoordinate2D currentLocation;
    NSMutableArray *pfFile;
    NSMutableArray *ways;
    NSMutableArray *tempWay;
    int count;
    BOOL markerClick;
    NSString *type;
    CLLocationDistance tempDis;
    BOOL updateTemp;
    MBProgressHUD *recal;
    int navigatecount;
}

@property int counter;
@property (nonatomic,strong) TCDirectionsLeg *leg;

//holding the marker
@property (strong, nonatomic) NSMutableArray *allMarkers;

@property (nonatomic,strong) NSString *buildingName;
/** Google Maps view. */
@property (nonatomic, copy, readonly) NSArray *cellModels;
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic, strong, readonly) TCUserLocationManager *userLocationManager;
/**
 * Labels to display the route's name, distance and duration.
 */
@property (nonatomic, weak) IBOutlet UIView *routeDetailsView;
@property (nonatomic, weak) IBOutlet UILabel *routeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceAndDurationLabel;

/** The bar button item to view detail steps of the route. */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *stepsBarButtonItem;

/**
 * A unique token that you can use to retrieve additional information
 * about this place in a Place Details request.
 */
@property (nonatomic, copy, readonly) NSString *placeReference;


/** Place Details result returned from Google Places API. */
@property (nonatomic, strong) TCPlace *place;

/** Route result returned from Google Directions API. */
@property (nonatomic, strong) TCDirectionsRoute *route;

/** The marker for the step's location. */
@property (nonatomic, strong) GMSMarker *stepMarker;

/** The marker that represents the destination. */
@property (nonatomic, strong) GMSMarker *destinationMarker;

@property CLLocationCoordinate2D endPoint;

@property (nonatomic,strong) NSMutableArray *images;

@end

@implementation TCMapViewController

@synthesize userLocationManager = _userLocationManager;

#pragma mark - Models

- (void)setMyLocation:(CLLocation *)myLocation placeReference:(NSString *)aPlaceReference
{
    // Update my location, only if it has changed.
    if (_myLocation != myLocation) {
        _myLocation = [myLocation copy];
    }
    
    // Only fetch new place details from Google Places API, if place's
    // reference has changed.
    if (_placeReference != aPlaceReference) {
        _placeReference = [aPlaceReference copy];
        
        // Hide the steps bar button item, until we have a valid route.
        self.navigationItem.rightBarButtonItem = nil;
        
        [self getPlaceDetailsWithReference:_placeReference];
    }
}

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    navigatecount = 0;
    count = 0;
    _counter = 0;
    updateTemp = true;
    markerClick = false;
    self.images = [[NSMutableArray alloc] initWithCapacity:500];
    pfFile = [[NSMutableArray alloc]init];
    ways = [[NSMutableArray alloc] init];
    [ways addObject:@"Destination"];
    tempWay = [[NSMutableArray alloc] init];
    self.allMarkers = [[NSMutableArray alloc] init];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    self.userLocationManager.mapView = self.mapView;
    float latmin = 4.332435;
    float latmax = 4.345159;
    float longmin = 101.133013;
    float longmax = 101.145641;
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(latmax, longmin);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(latmin, longmax);
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    
    self.current.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLocation:)];
    tapped.numberOfTapsRequired = 1;
    [self.current addGestureRecognizer:tapped];
    
    UIImage *icon = [UIImage imageNamed:@"overlay_park.png"];
    GMSGroundOverlay *overlay =
    [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
    overlay.bearing = 0;
    overlay.map = self.mapView;
    
    
    self.endPoint = self.location.coordinate;
    
    self.place = [[TCPlace alloc]init];
    self.place.location = self.endPoint;
    self.place.name = self.buildingName;
    // Tell Google Maps to draw the user's location on the map view.
    self.mapView.myLocationEnabled = YES;
    
    if (!self.myLocation) {
        [self startLocatingUser];
    }
    
    [self getDirectionsFromMyLocation:self.myLocation
                              toPlace:self.endPoint];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%@",[object myLocation]);
    
//    if([keyPath isEqualToString:@"myLocation"]) {
//        
//        currentLocation = [object myLocation].coordinate;
//        [self.mapView animateToLocation:[object myLocation].coordinate];
//        [self.mapView animateToZoom:17];
//    }
    
    NSLog(@"%@",_leg);
    
    TCDirectionsStep *step = _leg.steps[navigatecount];
    CLLocation *end = [[CLLocation alloc]initWithLatitude:step.endLocation.latitude longitude:step.endLocation.longitude];
//    CLLocation *end = [[CLLocation alloc]initWithLatitude:4.3356484 longitude:101.1350859];

//    CLLocation *start = [[CLLocation alloc]initWithLatitude:step.startLocation.latitude longitude:step.startLocation.longitude];
//    CLLocation *start = [[CLLocation alloc]initWithLatitude:4.334001499999999 longitude:101.1406238];
    
    //Edit here ===
    CLLocationDistance distance = [end distanceFromLocation:[object myLocation]];
    NSLog(@"Distance is %f",distance);
 
    for (GMSMarker *marker in self.allMarkers) {
        if (marker.position.latitude == end.coordinate.latitude && marker.position.longitude == end.coordinate.longitude){
            [self.mapView setSelectedMarker:marker];
            break;
        }
    }
    
    
    if (updateTemp && _leg != nil){
        tempDis = distance;
        updateTemp = false;
    }
    
    if(distance <= 0.05 && updateTemp==false){
        navigatecount++;
        updateTemp = true;
    }
    
    else if (distance > (tempDis) && !updateTemp){
        recal = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        recal.labelText = @"Recalculating";
        _counter = 0;
        [self.allMarkers removeAllObjects];
        self.destinationMarker = [self createMarkerForPlace:self.place onMap:self.mapView];
        updateTemp = true;
        [tempWay removeAllObjects];
        [self getDirectionsFromMyLocation:self.myLocation
                                  toPlace:self.location.coordinate];
        
       
        
    }
    

}

- (void)dealloc {
    [self.mapView removeObserver:self forKeyPath:@"myLocation"];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDirectionsSteps"]) {
        // Steps view controller is contained in a navigation controller.
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        TCStepsViewController *stepsViewController = (TCStepsViewController *)navigationController.topViewController;
        stepsViewController.delegate = self;
        
        // Make sure we have a route that has at least one leg.
        if (self.route && [self.route.legs count] > 0) {
            // Since we did not specify any waypoints, the route will only
            // have one leg.
             TCDirectionsLeg *leg = self.route.legs[0];
            
            // Pass the array of steps and the place details of the destination.
            
            
            
            
            
            [stepsViewController setSteps:leg.steps destination:self.place];
        }
    }
}

#pragma mark - Google Places API

- (void)getPlaceDetailsWithReference:(NSString *)reference
{    
    [[TCPlacesService sharedService] placeDetailsWithReference:reference completion:^(TCPlace *place, NSError *error) {
        if (place) {
            self.place = place;
            markerClick = true;
            // Create marker for the destination on the map view.
            self.destinationMarker = [self createMarkerForPlace:self.place onMap:self.mapView];
            
            
            
            
            
            
            // Focus camera on destination.
            [self.mapView animateWithCameraUpdate:
             [GMSCameraUpdate setTarget:self.destinationMarker.position]];
            
            // Request Google Directions API for directions starting from
            // my location to destination.
            if (self.myLocation) {
                [self getDirectionsFromMyLocation:self.myLocation
                                          toPlace:self.endPoint];
            }
        } else {
            NSLog(@"[Google Place Details API] - Error : %@", [error localizedDescription]);
        }
    }];
}

- (GMSMarker *)createMarkerForPlace:(TCPlace *)place onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = place.location;
    marker.title = place.name;
    
    if (markerClick == true){
        marker.icon = [UIImage imageNamed:@"marker"];
        self.mapView.delegate = self;
        marker.infoWindowAnchor = CGPointMake(0.50f, 0.37f);
        marker.map = mapView;
        marker.zIndex = _counter;
        [self.allMarkers insertObject:marker atIndex:_counter];
        _counter++;
        markerClick = false;
        
        
    }
    
    return marker;
}


-(UIView*) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoView" owner:self options:nil]objectAtIndex:0];
    
    if ([ways[marker.zIndex]  isEqual: @"turn-left"]){
        infoWindow.label.text = @"Turn Left";
    }else if ([ways[marker.zIndex]  isEqual: @"turn-right"]){
        infoWindow.label.text = @"Turn Right";
    }
    

    if(marker.zIndex == 0){
        infoWindow.customImage.image = self.staticimage;
    }
    else
    {
        infoWindow.customImage.image = [self.images objectAtIndex:marker.zIndex-1];
        
//        MBProgressHUD *loadingNotification = [MBProgressHUD showHUDAddedTo:self.view animated:true];
//        loadingNotification.labelText = @"Loading";
//
//        NSURL *imageFileUrl = [[NSURL alloc] initWithString:image.url];
        //        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        //
        //        //set the image view to the message image
        //        infoWindow.customImage.image = [UIImage imageWithData:imageData];
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:true];
        
        
//        [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error) {
//                infoWindow.customImage.image = [UIImage imageWithData:imageData];
//                [MBProgressHUD hideAllHUDsForView:self.view animated:true];
//            }
//        }];

    }
    
    return infoWindow;
    
    
    
}


#pragma mark - Google Directions API

- (void)getDirectionsFromMyLocation:(CLLocation *)myLocation toPlace:(CLLocationCoordinate2D)endLocation
{
    // Configure the parameters to be send to TCDirectionsService.
    TCDirectionsParameters *parameters = [[TCDirectionsParameters alloc] init];
    parameters.origin = self.myLocation.coordinate;
    parameters.destination = endLocation;
    
    [[TCDirectionsService sharedService] routeWithParameters:parameters completion:^(NSArray *routes, NSError *error) {
        if (routes) {
            // There should only be one route since we did not ask for alternative routes.
            self.route = routes[0];
            
            
            
            
            [recal hide:YES];
            _leg = self.route.legs[0];
            _cellModels = [self createCellModelsWithSteps:_leg.steps];
            
               NSMutableArray *myCellModels = [[NSMutableArray alloc] initWithCapacity:_leg.steps.count];
            for (TCDirectionsStep *step in _leg.steps) {
                TCCellModel *cellModel = [[TCCellModel alloc] initWithText:step.instructions
                                                                detailText:step.distance.text
                                                                     image:nil];
                // Store a reference to the TCDirectionsStep object, so that we
                // can retrieve it later.
                cellModel.userData = step;
                [tempWay addObject:step];
                [myCellModels addObject:cellModel];
                
                
            }
            
            TCCellModel *model = self.cellModels[0];
            self.textLabel.text = model.text;
            self.detailTextLabel.text = model.detailText;
            
            
            
            for (int x = 0 ; x < tempWay.count-1 ; x++){
                TCDirectionsStep *step = tempWay[x+1];
                PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:step.startLocation.latitude longitude:step.startLocation.longitude];
                
                //Add in endLocatiion here
                
                PFQuery *query = [PFQuery queryWithClassName:@"Location"];
                [query whereKey:@"Coordinate" equalTo:geoPoint];
                [query whereKey:@"turn" equalTo:step.image];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (error) {
                        // There was an error
                    } else {
                        
                        for(PFObject *object in objects){
                            
                            [pfFile addObject:object];
                            PFFile *image = [object valueForKey:@"Image"];
                            [ways addObject:step.image];
                            [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (!error) {
                                    [self.images addObject:[UIImage imageWithData:data]];
                                    
                                }
                            }];
                            TCPlace *placeExtra = [[TCPlace alloc]init];
                            placeExtra.location = step.startLocation;
                            markerClick = true;
                            [self createMarkerForPlace:placeExtra onMap:self.mapView];
                            
                            NSLog(@"%@",object);
                        }
                    }
                }];
            }
            

//            if (model.image ==  nil){
//                self.direction.image = [UIImage imageNamed:@"straight.png"];
//            }else
//                self.direction.image = model.image;
//            
            // Move camera viewport to fit the viewport bounding box of this route.
            [self.mapView animateWithCameraUpdate:
             [GMSCameraUpdate fitBounds:self.route.bounds]];
            
            [self drawRoute:self.route onMap:self.mapView];
            [self showRouteDetailsViewWithRoute:self.route];
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self mapView:self.mapView setCameraTarget:self.myLocation.coordinate selectMarker:nil];
            });
            
            
            
            // With a valid route, we can now allow user to view the step-by-step instructions.
//            self.navigationItem.rightBarButtonItem = self.stepsBarButtonItem;
//            self.stepsBarButtonItem.title = @"Path";
        } else {
            NSLog(@"[Google Directions API] - Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)drawRoute:(TCDirectionsRoute *)route onMap:(GMSMapView *)mapView
{
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:route.overviewPath];
    polyline.strokeWidth = 10.0f;
    polyline.map = mapView;
}



- (void)showRouteDetailsViewWithRoute:(TCDirectionsRoute *)route
{
    self.routeNameLabel.text = route.summary; 
    
    // With no waypoints, we only have one leg.
    TCDirectionsLeg *leg = route.legs[0];
    self.distanceAndDurationLabel.text = [NSString stringWithFormat:@"%@, %@",
                                          leg.distance.text, leg.duration.text];
    
    // Fade in animation for the route details view.
    self.routeDetailsView.alpha = 0.0f;
    [UIView animateWithDuration:1.0f animations:^{
        self.routeDetailsView.alpha = 1.0f;
    }];
}

#pragma mark - TCStepsViewController Delegate

- (void)stepsViewControllerDidSelectMyLocation:(TCStepsViewController *)stepsViewController
{
    // Passing in nil to selectMarker will deselect any currently selected marker.
    [self mapView:self.mapView setCameraTarget:self.myLocation.coordinate selectMarker:nil];
}

- (void)stepsViewControllerDidSelectDestination:(TCStepsViewController *)stepsViewController
{
    [self mapView:self.mapView setCameraTarget:self.destinationMarker.position selectMarker:self.destinationMarker];
}

- (void)stepsViewController:(TCStepsViewController *)stepsViewController didSelectStep:(TCDirectionsStep *)step
{    
    // Zoom in to fit the step's path.
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:step.path];
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
    
    // Remove any previous step's marker from the map.
    self.stepMarker.map = nil;
    
    // Create marker to represent the start of the step.
    self.stepMarker = [self createMarkerForStep:step onMap:self.mapView];
    
    // Select the step marker to show its info window.
    self.mapView.selectedMarker = self.stepMarker;    
    [self.mapView animateToLocation:self.stepMarker.position];
}

- (GMSMarker *)createMarkerForStep:(TCDirectionsStep *)step onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [GMSMarker markerWithPosition:step.startLocation];
    marker.icon = [self stepMarkerIcon];
    marker.snippet = step.instructions;
    marker.map = self.mapView;
    
    return marker;
}

/**
 * Returns the image used for the selected step's marker icon.
 */
- (UIImage *)stepMarkerIcon
{
    // Here we are just creating a 1x1 transparent image to be used for
    // the marker icon. Thus, making the marker icon invisible.    
    static UIImage * _image = nil;
    if (!_image) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0f, 1.0f), NO, 0.0f);
        _image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _image;
}

/**
 * Zooms the camera in at given coordinate and selects the marker to open 
 * its info window.
 *
 * @param mapView    The GMSMapView instance.
 * @param coordinate The coordinate to focus camera on.
 * @param marker     The marker to select on the mapView.
 */
- (void)mapView:(GMSMapView *)mapView setCameraTarget:(CLLocationCoordinate2D)coordinate selectMarker:(GMSMarker *)marker
{
    // Show the info window of the selected marker.
    mapView.selectedMarker = marker;
    
    // Zoom in to focus on target location.
    [mapView animateWithCameraUpdate:
     [GMSCameraUpdate setTarget:coordinate zoom:17.0f]];
}

#pragma mark - User Location Manager

- (TCUserLocationManager *)userLocationManager
{
    if (!_userLocationManager) {
        _userLocationManager = [[TCUserLocationManager alloc] init];
    }
    return _userLocationManager;
}

- (void)startLocatingUser
{
    // Show progress HUD while we find the user's location.
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.labelText = @"Finding My Location";
    
    // Make progress HUD consume all touches to disable interaction on
    // background views.
    progressHUD.userInteractionEnabled = YES;
    
    // Get the user's current location. Google Places API uses the user's
    // current location to find relevant places.
    [self.userLocationManager startLocatingUserWithCompletion:^(CLLocation *userLocation, NSError *error) {
        if (userLocation) {
            self.myLocation = userLocation;
            
            [progressHUD hide:YES];
            [self getDirectionsFromMyLocation:self.myLocation
                                      toPlace:self.endPoint];
            markerClick = true;
            [self createMarkerForPlace:self.place onMap:self.mapView];
            
            progressHUD.labelText = @"Fetching Data";
            progressHUD.hidden = NO;
        
            
        } else {
            NSLog(@"[TCUserLocationManager] - Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)currentLocation:(id) sender
{
    [self mapView:self.mapView setCameraTarget:_myLocation.coordinate selectMarker:nil];
}

- (NSArray *)createCellModelsWithSteps:(NSArray *)theSteps
{
    NSMutableArray *myCellModels = [[NSMutableArray alloc] initWithCapacity:theSteps.count + 2];

    
    // Convert the TCDirectionsStep objects to our cell model objects.
    for (TCDirectionsStep *step in theSteps) {
        TCCellModel *cellModel = [[TCCellModel alloc] initWithText:step.instructions
                                                        detailText:step.distance.text
                                                             image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",step.image]] location:step.endLocation];
        // Store a reference to the TCDirectionsStep object, so that we
        // can retrieve it later.
        cellModel.userData = step;
        
        [myCellModels addObject:cellModel];
    }
    
//    // Last cell model object is the destination.
//    TCCellModel *lastCellModel = [[TCCellModel alloc] initWithText:self.destination.name
//                                                        detailText:self.destination.address
//                                                             image:[UIImage imageNamed:@"turn_arrive"]];
//    [myCellModels addObject:lastCellModel];
    
    return [myCellModels copy];
}



@end

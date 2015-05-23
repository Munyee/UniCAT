//
//  MapView.m
//  UniCAT
//
//  Created by Munyee on 3/7/15.
//  Copyright (c) 2015 Munyee. All rights reserved.
//

#import "MapView.h"
#import "SWRevealViewController.h"

@interface MapView ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MapView{
    CLLocationManager *locationManager;
    
}



 UIImageView *imageView;
 UIScrollView *scrollView;
UIImageView *buttonView;


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    [self viewMap];
    
    
}

-(void)viewMap
{
    locationManager = [[CLLocationManager alloc] init];
    
    
    
    CGSize targetSize = CGSizeMake(1000,1000);
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    //create a UIImage,set the imageName to your image name
    UIImage *image = [UIImage imageNamed:@"UTARMAP.jpg"];
    
    [self.blockA removeFromSuperview];
    [self.blockA setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.blockA setFrame:CGRectMake(598 , 590, 100, 40)];
    self.blockA.tag = 1;
    
    
    [self.blockB removeFromSuperview];
    [self.blockB setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.blockB setFrame:CGRectMake(592 , 495, 100, 40)];
    self.blockB.tag = 2;
    
    
    [self.blockC removeFromSuperview];
    [self.blockC setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.blockC setFrame:CGRectMake(560, 410, 100, 40)];
    self.blockC.tag = 3;
    
    
    //create UIImageView and set imageView size to you image height
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    //set the image position
    [scrollView setContentOffset:CGPointMake(300,300) animated:YES];
    [imageView setImage:image];
    //set button in different location and the action
    
    buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    
    //add ImageView to your scrollView
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    
    [scrollView addGestureRecognizer:pinchGestureRecognizer];
    
    [imageView setUserInteractionEnabled:YES];
    [imageView addSubview:self.blockA];
    [imageView addSubview:self.blockB];
    [imageView addSubview:self.blockC];
    [imageView addSubview:self.blockD];
    [scrollView addSubview:imageView];
    
    [scrollView.delegate self];
    
    //set content size of you scrollView to the imageView height
    [scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    
    
    [self.view addSubview:scrollView];
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait )
    {
        [self viewDidLoad];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (BOOL)shouldAutorotate
{
    return  NO;
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


-(void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
        CGFloat lastScale=1;
        if([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan) {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = [pinchGestureRecognizer scale];
        }
    
        if ([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan ||
            [pinchGestureRecognizer state] == UIGestureRecognizerStateChanged) {
            
            CGFloat currentScale = [[[pinchGestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
            
            // Constants to adjust the max/min values of zoom
            const CGFloat kMaxScale = 2.0;
            const CGFloat kMinScale = 1.0;
            
            CGFloat newScale = 1 -  (lastScale - [pinchGestureRecognizer scale]); // new scale is in the range (0-1)
            newScale = MIN(newScale, kMaxScale / currentScale);
            newScale = MAX(newScale, kMinScale / currentScale);
            CGAffineTransform transform = CGAffineTransformScale([[pinchGestureRecognizer view] transform], newScale, newScale);
            [pinchGestureRecognizer view].transform = transform;
            
            lastScale = [pinchGestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
        }
    NSLog(@"Pinched");
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    NSString *name;
    name = sender.titleLabel.text;
 //   NSLog(@"Button: %d Tapped!",sender.tag);
     [self performSegueWithIdentifier:@"details" sender:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
    }
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import "ViewController.h"
#import "ApiRequestManager.h"
#import "DefaultVenues.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _venueQueue = [NSMutableArray new];
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationManager requestWhenInUseAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) venueListToQueue:(NSArray *)venueList withPriority:(long)priority{
    
    [_venueQueue addObject:venueList];

    dispatch_async(dispatch_get_global_queue(priority, 0), ^{

        float i = 0;
        
        for (DefaultVenues * venue in venueList) {
            //TODO FAZER GRADATIVO countar segundo +
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self makePinWithDefaultVenue:venue];
            });
            i += 0.2;
        }
        
    });
    
}

#pragma mark - GMSMapView Helpers

- (void)makePinWithDefaultVenue:(DefaultVenues *)venue{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([venue.lat doubleValue],[venue.lng doubleValue]);
    marker.snippet = venue.venueTitle;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _mapView;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        } break;
        case kCLAuthorizationStatusDenied: {
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = _mapView;
    
    [[ApiRequestManager sharedApi] searchWithVenueType:DefaultVenuesEntryTypeFourSquare currentLocation:@{@"lat":[NSNumber numberWithFloat:newLocation.coordinate.latitude],@"lng":[NSNumber numberWithFloat:newLocation.coordinate.longitude]} newMidiasBlock:^(NSArray *venues) {
        NSLog(@"Sushi Venues list %@",venues);
        [self venueListToQueue:venues withPriority:DISPATCH_QUEUE_PRIORITY_HIGH];
    }];
    
    [[ApiRequestManager sharedApi] searchWithVenueType:DefaultVenuesEntryTypeFourSquareChurras currentLocation:@{@"lat":[NSNumber numberWithFloat:newLocation.coordinate.latitude],@"lng":[NSNumber numberWithFloat:newLocation.coordinate.longitude]} newMidiasBlock:^(NSArray *venues) {
        NSLog(@"Churras Venues list %@",venues);
        [self venueListToQueue:venues withPriority:DISPATCH_QUEUE_PRIORITY_LOW];
    }];
    
}

@end

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

    [[ApiRequestManager sharedApi] searchWithVenueType:DefaultVenuesEntryTypeFourSquare newMidiasBlock:^(NSArray *venues) {
        NSLog(@"Venues list %@",venues);
        [self venueListToQueue:venues];
    }];
    
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

-(void) venueListToQueue:(NSArray *)venueList{
    
    [_venueQueue addObject:venueList];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (DefaultVenues * venue in venueList) {
            [self makePinWithDefaultVenue:venue];
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
}

@end

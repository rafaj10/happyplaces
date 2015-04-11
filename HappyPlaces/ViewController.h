//
//  ViewController.h
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic) GMSMapView *mapView;
@property(strong,nonatomic) NSMutableArray *venueQueue;

@end


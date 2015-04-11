//
//  ApiRequestManager.m
//  conviva
//
//  Created by Rafael Assis on 3/24/15.
//  Copyright (c) 2015 caiena. All rights reserved.
//

#import "ApiRequestManager.h"
#import "DefaultVenues.h"

@interface ApiRequestManager () {
    void (^successBlock)(NSArray *);
}

@end

@implementation ApiRequestManager


#pragma mark - Shared Manager
+ (ApiRequestManager *)sharedApi {
    static ApiRequestManager *_sharedApi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApi = [[self alloc] init];
    });
    
    return _sharedApi;
}

#pragma mark - Helper

- (AFHTTPRequestOperationManager *)defaultManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    return manager;
}

#pragma mark - Public

- (void)searchWithVenueType:(DefaultVenuesEntryType)entryType
            currentLocation:(NSDictionary *)locations
             newMidiasBlock:(void (^)(NSArray *venues))newVenues{
    successBlock = newVenues;
    switch (entryType) {
        case DefaultVenuesEntryTypeFourSquare:
            [self searchUsingFourSquare:locations];
            break;
        case DefaultVenuesEntryTypeGooglePlace:
            [self searchUsingGooglePlace:locations];
            break;
        case DefaultVenuesEntryTypeFourSquareChurras:
            [self searchUsingFourSquareChurras:locations];
            break;
    }
}

#pragma mark - Search Methods

- (void)searchUsingFourSquare:(NSDictionary *)locations{
    NSString * fourPath = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=LELJPZFEFYQQA4U15GDZ3COPKTLWCHAVHNTYWBHPTFBHOOIS&client_secret=L5R5IE4RA4M1LNJ4XES3I1JKUE235G0RJNODRBNA3IMKAUSO&v=20130815&ll=%f,%f&query=sushi",[[locations objectForKey:@"lat"] doubleValue],[[locations objectForKey:@"lng"] doubleValue]];
    
    [[self defaultManager] GET:fourPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * venuesList = [NSMutableArray new];
        
        for (NSDictionary * dict in (NSArray *)[[responseObject objectForKey:@"response"] objectForKey:@"venues"]) {
            [venuesList addObject:[[DefaultVenues alloc] initWithEntryType:DefaultVenuesEntryTypeFourSquare response:dict]];
        }
        
        successBlock(venuesList);

    } failure:nil];
}

- (void)searchUsingFourSquareChurras:(NSDictionary *)locations{
    NSString * fourPath = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=LELJPZFEFYQQA4U15GDZ3COPKTLWCHAVHNTYWBHPTFBHOOIS&client_secret=L5R5IE4RA4M1LNJ4XES3I1JKUE235G0RJNODRBNA3IMKAUSO&v=20130815&ll=%f,%f&query=churrascaria",[[locations objectForKey:@"lat"] doubleValue],[[locations objectForKey:@"lng"] doubleValue]];
    
    [[self defaultManager] GET:fourPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * venuesList = [NSMutableArray new];
        
        for (NSDictionary * dict in (NSArray *)[[responseObject objectForKey:@"response"] objectForKey:@"venues"]) {
            [venuesList addObject:[[DefaultVenues alloc] initWithEntryType:DefaultVenuesEntryTypeFourSquare response:dict]];
        }
        
        successBlock(venuesList);
        
    } failure:nil];
}

-(void) searchUsingGooglePlace:(NSDictionary *)locations{
    NSString * fourPath = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AIzaSyB9276zUBUxClz5sKpNKSkd3JbM_EsnZGk"];
    
    [[self defaultManager] GET:fourPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ok");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"dont");
    }];
}


@end

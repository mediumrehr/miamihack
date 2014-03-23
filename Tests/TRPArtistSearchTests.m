//
//  TRPArtistSearchTests.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

SpecBegin(LocationToPlaylist)

describe(@"search", ^{
    
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    //There will be a warning from this line of code, ignore it
//    [locationManager setDelegate:self];
//    
//    //And we want it to be as accurate as possible
//    //regardless of how much time it takes
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    
//    CLLocation *location = [locationManager location];
//    
//    CLGeocoder *gc = [[CLGeocoder alloc] init];
//    [gc reverseGeocodeLocation:location completionHandler:
//    
//    ^(NSArray *placemarks, NSError *error) {
//        //Get nearby address
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        //String to hold address
//        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//        //Print the location to console
//        NSLog(@"I am currently at %@",locatedAt);
//    }];
    
    
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    
    NSString *endPoint = @"artist/search";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    
    NSString *loc = @"Nashville";
    [request setValue:loc forParameter:@"artist_location"];
    
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"genre", @"hotttnesss", @"discovery", @"artist_location", nil];
    [request setValue:bucket forParameter:@"bucket"];
    [request setIntegerValue:25 forParameter:@"results"];
    // [request setValue:[NSNumber numberWithInt:25] forParameter:@"results"];
    [request setValue:@"hotttnesss-desc" forParameter:@"sort"];
    [request startSynchronous];
    
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    
    NSDictionary *response = [[request response] objectForKey:@"response"];

    NSMutableDictionary *allGenres = [[NSMutableDictionary alloc] init];
    
    if(request.responseStatusCode == 200){ // Successful query
        NSLog(@"Successful query");
        NSArray *artists = [response objectForKey:@"artists"];
        if([artists count] > 0){ // Valid Area
            for(NSDictionary *artist in artists){
                NSLog(@"Artist: %@", [artist objectForKey:@"name"]);
                NSDictionary *location = [artist objectForKey:@"artist_location"];
                NSLog(@"City: %@", [location objectForKey:@"city"]); // To get the artist's location. may be more specific than search.
                NSDictionary *genresForArtist = [artist objectForKey:@"genres"];
                for(NSDictionary *genre in genresForArtist){
                    NSString *genr = [genre objectForKey:@"name"];
                    if([allGenres objectForKey:genr]){
                        int count = [[allGenres objectForKey:genr] integerValue];
                        [allGenres setObject:[NSNumber numberWithInt:++count] forKey:genr];
                    } else{ // add it
                        [allGenres setObject:[NSNumber numberWithInt:1] forKey:genr];
                    }
                }
            }
        } else{
            NSLog(@"Invalid Area");
        }

    }
    
    NSArray *topGenres;
    
    topGenres = [allGenres keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] > [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // NSLog(@"Got data: %@", request.responseString);
    
    expect([request.responseString length]).to.beGreaterThan(0);
    
    // Query For Static Playlist
    endPoint = @"playlist/static";
    
    
    
});

SpecEnd
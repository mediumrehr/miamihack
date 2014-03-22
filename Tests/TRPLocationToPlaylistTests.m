//
//  TRPLocationToPlaylistTests.m
//  Tripster
//
//  Created by Marko Gill on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

SpecBegin(ArtistSearch)

describe(@"locationToPlaylist", ^{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    NSString *endPoint = @"artist/search";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    
    NSString *loc = @"Miami";
    [request setValue:loc forParameter:@"artist_location"];
    
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"genre", @"hotttnesss", @"discovery", @"artist_location", nil];
    [request setValue:bucket forParameter:@"bucket"];
    [request setIntegerValue:5 forParameter:@"results"];
    //[request setValue:[NSNumber numberWithInt:25] forParameter:@"results"];
    [request setValue:@"hotttnesss-desc" forParameter:@"sort"];
    [request startSynchronous];
    
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    
    NSDictionary *response = [[request response] objectForKey:@"response"];
    
    if(request.responseStatusCode == 200){ // Successful query
        NSLog(@"Successful query");
        NSArray *artists = [response objectForKey:@"artists"];
        
        for(NSDictionary *artist in artists){
            NSLog(@"Artist: %@", [artist objectForKey:@"name"]);
            NSDictionary *location = [artist objectForKey:@"artist_location"];
            NSLog(@"City: %@", [location objectForKey:@"city"]); // To get the artist's location. may be more specific than search.
        }
        
    }
    
    // NSLog(@"Got data: %@", request.responseString);
    
    expect([request.responseString length]).to.beGreaterThan(0);
    
    // Query For Static Playlist
    endPoint = @"playlist/static";
});

SpecEnd
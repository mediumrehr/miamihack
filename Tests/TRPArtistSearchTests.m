//
//  TRPArtistSearchTests.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

SpecBegin(ArtistSearch)

describe(@"search", ^{
    
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    NSString *endPoint = @"artist/search";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSString *loc = @"Miami";
    [request setValue:loc forParameter:@"artist_location"];
    [request startSynchronous];
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    NSDictionary *response = [[request response] objectForKey:@"response"];
    NSDictionary *status   =  [response objectForKey:@"status"];

    if([[status objectForKey:@"message"]  isEqual: @"Success"]){ // Successful query
        NSLog(@"Successful query");
        NSArray *artists = [response objectForKey:@"artists"];
        for(NSDictionary *artist in artists){
            NSLog(@"%@", [artist objectForKey:@"name"]);
        }

    }
    
    NSLog(@"Got data: %@", request.responseString);
    
    expect([request.responseString length]).to.beGreaterThan(0);
    
});

SpecEnd
//
//  TRPTripPlaylistTests.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

SpecBegin(Playlist)

describe(@"creation", ^{
    
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    NSString *endPoint = @"playlist/dynamic/create";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSArray *artists = [[NSArray alloc] initWithObjects:@"Pitbull",@"Enrique Iglesias",@"Flo Rida",@"Young Money",@"DJ Khaled", nil];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setValue:artists forParameter:@"artist"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startSynchronous];
    
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    NSDictionary *response = [[request response] objectForKey:@"response"];
    NSDictionary *status   =  [response objectForKey:@"status"];
    NSLog(@"%@",response);
    
    // Get Next Song!
    NSString *endPoint2 = @"playlist/dynamic/next";
    ENAPIRequest *request2 = [ENAPIRequest requestWithEndpoint:endPoint2];
    //NSArray *artists = [[NSArray alloc] initWithObjects:@"Pitbull",@"Enrique Iglesias",@"Flo Rida",@"Young Money",@"DJ Khaled", nil];
    //NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    //[request2 setValue:artists2 forParameter:@"artist"];
    //[request2 setValue:bucket forParameter:@"bucket"];
    [request2 setIntegerValue:1 forParameter:@"results"];
    [request2 setIntegerValue:5 forParameter:@"lookahead"];
    [request2 setValue:[response objectForKey:@"session_id"] forParameter:@"session_id"];
    [request2 startSynchronous];
    
    expect(request2.complete).to.equal(YES);
    expect(request2.responseStatusCode).to.equal(200);
    NSDictionary *response2 = [[request2 response] objectForKey:@"response"];
    NSDictionary *status2   =  [response2 objectForKey:@"status"];
    NSLog(@"%@",response2);
    
    
});

SpecEnd
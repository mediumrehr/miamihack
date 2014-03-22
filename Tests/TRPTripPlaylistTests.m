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
    
    NSString *endPoint = @"playlist/static";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSArray *artists = [[NSArray alloc] initWithObjects:@"Pitbull",@"Enrique Iglesias",@"Flo Rida",@"Young Money",@"DJ Khaled", nil];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setValue:artists forParameter:@"artist"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startSynchronous];
    
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    NSDictionary *response = [[request response] objectForKey:@"response"];
    int playingIndex = 0;
    if(request.responseStatusCode == 200){ // Successful query
        NSArray *songs = [response objectForKey:@"songs"];
        
        // --- EXTRACT SPOTIFY ID ---
        NSDictionary *song = [songs objectAtIndex:playingIndex];
        NSArray *tracks = [song objectForKey:@"tracks"];
        NSDictionary *track = [tracks objectAtIndex:0];
        NSString *spotify_ID = [track objectForKey:@"foreign_id"]; // send this to spotify
        NSLog(@"Print ID: %@",spotify_ID);
        // --- EXTRACT SPOTIFY ID ---
    }
    
    NSLog(@"%@",response);
    
    
});

SpecEnd
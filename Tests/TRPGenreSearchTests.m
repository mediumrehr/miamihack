//
//  TRPTripPlaylistTests.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <libechonest/ENAPI.h>
#import <CocoaLibSpotify.h>
//#import "TRPConstants.h"

SpecBegin(Playlist)

describe(@"creation", ^{
    
    NSString* kEchoNestAPIKey = @"QMT6WYFTWSGPSOQFV";
    NSString* kEchoNestConsumerKey = @"be329eab49668456821db2f2b55821f1";
    NSString* kEchoNestSharedSecret = @"GoSk4Az1Sva8qbP+TpnGFA";
    NSString* kEchoNestQueryHeading = @"http://developer.echonest.com/api/v4/artist/search?api_key=QMT6WYFTWSGPSOQFV&format=json";
    
    
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    NSString *endPoint = @"playlist/static";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSArray *genres = [[NSArray alloc] initWithObjects:@"folk",@"electronic",@"blues",@"lo-fi",@"jazz", nil];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setIntegerValue:15 forParameter:@"results"];
    [request setValue:genres forParameter:@"genre"];
    [request setValue:@"genre-radio" forParameter:@"type"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startSynchronous];
    
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    NSDictionary *response = [[request response] objectForKey:@"response"];
    NSString *sessionID = [response objectForKey:@"session_id"];
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
    
    // Get Next Song!
    NSString *endPoint2 = @"playlist/dynamic/next";
    ENAPIRequest *request2 = [ENAPIRequest requestWithEndpoint:endPoint2];
    [request2 setIntegerValue:1 forParameter:@"results"];
    [request2 setIntegerValue:5 forParameter:@"lookahead"];
    [request2 setValue:[response objectForKey:@"session_id"] forParameter:@"session_id"];
    [request2 startSynchronous];
    
    expect(request2.complete).to.equal(YES);
    expect(request2.responseStatusCode).to.equal(200);
    NSDictionary *response2 = [[request2 response] objectForKey:@"response"];
    NSDictionary *status2   =  [response2 objectForKey:@"status"];
    NSArray *songs = [response2 objectForKey:@"songs"];
    NSString *spotifyID = [[[[songs objectAtIndex:0] objectForKey:@"tracks"] objectAtIndex:0] objectForKey:@"foreign_id"];
    
    
    NSArray *lookAhead = [response2 objectForKey:@"lookahead"];
    
    NSLog(@"%@",response2);
    
    //NSArray *artists = [[NSArray alloc] initWithObjects:@"Pitbull",@"Enrique Iglesias",@"Flo Rida",@"Young Money",@"DJ Khaled", nil];
    //NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    //[request2 setValue:artists2 forParameter:@"artist"];
    //[request2 setValue:bucket forParameter:@"bucket"];
    
    
});

SpecEnd
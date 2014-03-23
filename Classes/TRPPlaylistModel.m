//
//  TRPPlaylistModel.m
//  Tripster
//
//  Created by Marko Gill on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPPlaylistModel.h"

@implementation TRPPlaylistModel
@synthesize sessionID, requestType, canRequestTrack, delegate;

- (id) init
{
    self = [super init];
    if(self){
        sessionID = @"";
        canRequestTrack = false;
    }
    return self;
}

- (void) createSessionWithArtists:(NSArray*) artists{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    canRequestTrack = false;
    requestType = @"StartSession";
    
    NSString *endPoint = @"playlist/dynamic/create";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setValue:artists forParameter:@"artist"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startAsynchronous];
}

/* returns true if songs can be requested. returns false if songs cannot be requested. */
- (bool) getSongsForCurrentSession{
    
    if(canRequestTrack){
        requestType = @"NextSong";
        // Get Next Song!
        NSString *endPoint = @"playlist/dynamic/next";
        ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
        [request setIntegerValue:1 forParameter:@"results"];
        [request setIntegerValue:0 forParameter:@"lookahead"]; // Look Aheads do anything for us ???
        [request setValue:sessionID forParameter:@"session_id"];
        [request startAsynchronous];
        return true;
    }
    
    return false;
}

- (void) requestFailed:(ENAPIRequest *)request{
    if([delegate respondsToSelector:@selector(failedToCreatePlaylist)]){
        [delegate failedToCreatePlaylist];
    }
}

- (void) requestFinished:(ENAPIRequest *)request{
    
    NSDictionary *response;
    if([requestType isEqualToString:@"StartSession"]){
        response = [[request response] objectForKey:@"response"];
        sessionID = [response objectForKey:@"session_id"];
        canRequestTrack = true;
        if([delegate respondsToSelector:@selector(successfullyCreatedPlaylist)]){
            [delegate successfullyCreatedPlaylist];
        }
    } else if([requestType isEqualToString:@"NextSong"]){
        response = [[request response] objectForKey:@"response"]; // contains Song and Look Ahead
            NSArray *songs = [response objectForKey:@"songs"];
            if([songs count] > 0){
                NSString *spotifyID = [[[[songs objectAtIndex:0] objectForKey:@"tracks"] objectAtIndex:0] objectForKey:@"foreign_id"];
                [self didReceiveNextSong:spotifyID];

                
            }
            // NSArray *lookAhead = [response objectForKey:@"lookahead"];
            
        }
    }
}

-(void)didReceiveNextSong:(urlString *)urlString{
    if ([delegate respondsToSelector:@selector(didReceiveNextSong:)]) {
        [delegate didReceiveNextSong:urlString];
    }
}



@end

//
//  ArtistModel.m
//  Tripster
//
//  Created by Andrew Ayers on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "ArtistModel.h"

@implementation ArtistModel

@synthesize delegate;

-(id)init
{
    self = [super init];
    if(self){
        // Perform Custom init here
    }
    return self;
}


-(void)createArtistsModelforLocation:(NSString *)location{
    
    //[self init];
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    
    NSString *endPoint = @"artist/search";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    [request setDelegate:self];
    [request setValue:location forParameter:@"artist_location"];
    
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"genre", @"hotttnesss", @"discovery", @"artist_location", nil];
    [request setValue:bucket forParameter:@"bucket"];
    [request setIntegerValue:5 forParameter:@"results"];
    // [request setValue:[NSNumber numberWithInt:25] forParameter:@"results"];
    [request setValue:@"hotttnesss-desc" forParameter:@"sort"];
    [request startAsynchronous];

}

-(void)requestFinished:(ENAPIRequest *)request{
    //Artist request
    NSDictionary *response = [[request response] objectForKey:@"response"];
    
    if(request.responseStatusCode == 200){ // Successful query
        
        NSLog(@"Successful query");
        NSArray *artists = [response objectForKey:@"artists"];
        if([artists count] > 0){ // Valid Area
            for(NSDictionary *artist in artists){
                NSLog(@"Artist: %@", [artist objectForKey:@"name"]);
                NSDictionary *location = [artist objectForKey:@"artist_location"];
                NSLog(@"City: %@", [location objectForKey:@"city"]); // To get the artist's location. may be more specific than search.
            }
            [self didReceiveArtistModel:artists withMessage:@"success"];
        } else{
            NSLog(@"Invalid Area");
            [self didReceiveArtistModel:nil withMessage:@"invalid area"];
        }
        
    }
}

-(void)requestFailed:(ENAPIRequest *)request{
    //Error Handling for failed artist request
    [self didReceiveArtistModel:nil withMessage:@"request failed"];
}

#pragma mark protocol methods

-(void)didReceiveArtistModel:(NSArray *)artists withMessage:(NSString *)message{
    if([delegate respondsToSelector:@selector(didReceiveArtistModel:withMessage:)]){
        [delegate didReceiveArtistModel:artists withMessage:message];
    }
}
@end

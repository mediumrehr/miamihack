//
//  TRPGenreSearchTests.m
//  Tripster
//
//  Created by Daniel Avissar on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

SpecBegin(GenreSearch)

describe(@"search", ^{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    NSString *endPoint = @"genre/search";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSString *genre_name = @"metal";
    [request setValue:genre_name forParameter:@"name"];
    [request startSynchronous];
    expect(request.complete).to.equal(YES);
    expect(request.responseStatusCode).to.equal(200);
    NSLog(@"Got genre data: %@", request.responseString);
    expect([request.responseString length]).to.beGreaterThan(0);
    
    
});

SpecEnd

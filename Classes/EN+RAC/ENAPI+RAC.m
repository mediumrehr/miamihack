//
//  ENAPI+RAC.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "ENAPI+RAC.h"

@implementation ENAPI (RAC)

+ (RACSignal*)requestArtistsForLocation:(NSString*)location {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber)
            {
                ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:@"artist/search"];
                [request setValue:location forParameter:@"artist_location"];

                NSArray *buckets = @[@"genre",
                                     @"hotttnesss",
                                     @"images",
                                     @"artist_location",
                                     @"id:spotify-US"];

                [request setValue:buckets forParameter:@"bucket"];
                [request setIntegerValue:50 forParameter:@"results"];
                [request setValue:@"hotttnesss-desc" forParameter:@"sort"];

                return [self dispatchRequest:request forSubscriber:subscriber];
            }];
}

+ (RACSignal*)requestInfoForArtists:(NSSet*)artistIDs {
    return [[RACSignal merge:[artistIDs.rac_sequence map:^id(NSString *artistID) {
        return [self requestInfoForArtist:artistID];
    }]] collect];
}

+ (RACSignal*)requestInfoForArtist:(NSString*)artistID {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber)
            {
                ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:@"artist/profile"];
                [request setValue:artistID forParameter:@"id"];
                [request setValue:@[@"artist_location",
                                    @"images"] forParameter:@"bucket"];
                return [self dispatchRequest:request forSubscriber:subscriber];
            }];
}


+ (RACSignal*)requestStaticPlaylistForArtists:(NSSet*)artists {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber)
            {
                ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:@"playlist/static"];
                [request setValue:[artists allObjects] forParameter:@"artist_id"];
                [request setValue:@[@"id:spotify-US",
                                    @"tracks",
                                    @"artist_location",
                                    @"song_hotttnesss"] forParameter:@"bucket"];

                [request setIntegerValue:50 forParameter:@"results"];
                [request setValue:@"song_hotttnesss-desc" forParameter:@"sort"];

                return [self dispatchRequest:request forSubscriber:subscriber];
            }];
}

+ (RACDisposable*)dispatchRequest:(ENAPIRequest*)request forSubscriber:(id<RACSubscriber>)subscriber {
    @weakify(subscriber);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [request startSynchronous];

        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(subscriber);
            if (!subscriber) {
                return;
            }
            if (request.error || request.responseStatusCode != 200) {
                [subscriber sendError:request.error ?:
                 [NSError errorWithDomain:@"ENAPIErrorDomain"
                                     code:request.responseStatusCode
                                 userInfo:@{NSLocalizedDescriptionKey: request.responseString}]];
            } else {
                [subscriber sendNext:request.response];
            }
            [subscriber sendCompleted];
        });
    });

    return [RACDisposable disposableWithBlock:^{
        [request cancel];
    }];
}

@end

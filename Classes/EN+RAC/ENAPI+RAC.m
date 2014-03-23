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
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:@"artist/search"];
    [request setValue:location forParameter:@"artist_location"];

    NSArray *buckets = @[@"genre",
                         @"hotttnesss",
                         @"discovery",
                         @"artist_location"];

    [request setValue:buckets forParameter:@"bucket"];
    [request setIntegerValue:50 forParameter:@"results"];
    [request setValue:@"hotttnesss-desc" forParameter:@"sort"];

    return [RACSignal startLazilyWithScheduler:[RACScheduler mainThreadScheduler]
                                         block: ^(id<RACSubscriber> subscriber)
            {
                __weak id<RACSubscriber> weakSubscriber = subscriber;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [request startSynchronous];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (request.error || request.responseStatusCode != 200) {
                            [weakSubscriber sendError:request.error ?:
                             [NSError errorWithDomain:@"ENAPIErrorDomain"
                                                 code:request.responseStatusCode
                                             userInfo:@{NSLocalizedDescriptionKey: request.responseString}]];
                        } else {
                            [weakSubscriber sendNext:request.response];
                            [weakSubscriber sendCompleted];
                        }
                    });
                });
            }];
}

@end

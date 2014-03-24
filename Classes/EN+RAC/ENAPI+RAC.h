//
//  ENAPI+RAC.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "ENAPI.h"

@interface ENAPI (RAC)

+ (RACSignal*)requestArtistsForLocation:(NSString*)location;

+ (RACSignal*)requestStaticPlaylistForArtists:(NSSet*)artists;

+ (RACSignal*)requestInfoForArtists:(NSSet*)artistIDs;

+ (RACSignal*)requestInfoForArtist:(NSString*)artistID;

@end

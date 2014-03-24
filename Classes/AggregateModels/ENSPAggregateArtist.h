//
//  ENSPAggregateArtist.h
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/SPArtist.h>
@interface ENSPAggregateArtist : NSObject
@property (nonatomic, strong) NSString *enArtistID;
@property (nonatomic, strong) NSDictionary *enArtistData;
@property (nonatomic, strong) SPArtist *spArtist;
@end

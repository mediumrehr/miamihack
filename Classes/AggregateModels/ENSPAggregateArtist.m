//
//  ENSPAggregateArtist.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "ENSPAggregateArtist.h"

@implementation ENSPAggregateArtist

- (NSUInteger)hash
{
    return [_enArtistID hash];
}

@end

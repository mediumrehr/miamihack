//
//  TRPTripArtistSelectionStep.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripArtistSelectionStep.h"

@interface TRPTripArtistSelectionStep ()
@property (nonatomic, strong) NSMutableSet *artistModels;
@end

@implementation TRPTripArtistSelectionStep

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _artistModels = [NSMutableSet new];

    return self;
}

- (NSSet*)artists
{
    return [_artistModels copy];
}

- (void)addArtist:(id)artistModel
{
    [_artistModels addObject:artistModel];
}

- (void)removeArtist:(id)artistModel
{
    [_artistModels removeObject:artistModel];
}

- (void)removeAllArtists
{
    [_artistModels removeAllObjects];
}

- (BOOL)isValid
{
    return [_artistModels count] > 0;
}

- (NSString*)tripModelKey
{
    return @"artistIDs";
}

- (id)tripModelValue
{
    return [NSSet setWithArray:
            [[_artistModels.rac_sequence
              map:^id(id artistModel) {
                  // TODO: get EN ID of artist
                  return artistModel;
              }] array]];
}

@end

//
//  TRPTripArtistSelectionStep.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRPTripCreationStep.h"

@interface TRPTripArtistSelectionStep : NSObject
<TRPTripCreationStep>

- (NSSet*)artists;

- (void)addArtist:(id)artistModel;
- (void)removeArtist:(id)artistModel;

@end

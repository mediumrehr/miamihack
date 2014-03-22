//
//  TRPTripLocationStep.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripLocationStep.h"

@implementation TRPTripLocationStep

- (BOOL)isValid
{
    return [_location length] > 0;
}

- (NSString*)tripModelKey
{
    return @"location";
}

- (id)tripModelValue
{
    return _location;
}

@end

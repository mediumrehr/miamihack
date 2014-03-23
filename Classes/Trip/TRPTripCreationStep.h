//
//  TRPTripCreationStep.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRPTripModel.h"

@protocol TRPTripCreationStep <NSObject>

- (BOOL)isValid;

- (NSString*)tripModelKey;
- (id)tripModelValue;

@end

static TRPMutableTripModel* TRPTripModelFromSteps(RACSequence *steps) {
    return [steps foldLeftWithStart:[TRPMutableTripModel new]
                             reduce:^id(TRPMutableTripModel *mutableModel, id<TRPTripCreationStep> step) {
                                 [mutableModel setValue:[step tripModelValue] forKey:[step tripModelKey]];
                                 return mutableModel;
                             }];
}
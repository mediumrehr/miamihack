//
//  TRPTripViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"

@interface TRPTripViewController : UIViewController
@property (nonatomic, strong, readonly) TRPTripModel *model;

- (id)initWithTripModel:(TRPTripModel*)model;

@end

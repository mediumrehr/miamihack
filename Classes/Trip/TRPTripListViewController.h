//
//  TRPTripListViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripStorage.h"

@interface TRPTripListViewController : UIViewController
@property (nonatomic, strong) id<TripStorage> tripStorage;
@end

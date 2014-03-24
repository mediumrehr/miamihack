//
//  TRPTripDetailViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"
#import "TRPTripStorage.h"
#import <CocoaLibSpotify/SPPlaybackManager.h>

@interface TRPTripDetailViewController : UIViewController
@property (nonatomic, strong) TRPTripModel *tripModel;
@property (nonatomic, strong) id<TripStorage> storage;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@end

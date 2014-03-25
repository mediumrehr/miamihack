//
//  TRPTripListViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripStorage.h"
#import "TRPMutableCollectionViewCell.h"
#import <CocoaLibSpotify/SPPlaybackManager.h>
@interface TRPTripListViewController : UIViewController <TRPMutableCollectionCellDelegate>
@property (nonatomic, strong) id<TripStorage> tripStorage;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@end

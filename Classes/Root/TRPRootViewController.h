//
//  TRPRootViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRPRootViewControllerAuthDelegate <NSObject>

- (void)logout;

@end

@class TRPTripModel;
@interface TRPRootViewController : UIViewController
// TODO: add playback controls view controller

@property (nonatomic, strong) UIViewController *currentViewController;

- (instancetype)initWithAuthDelegate:(id<TRPRootViewControllerAuthDelegate>)authDelegate;

- (void)createNewTrip;

- (void)startTrip:(TRPTripModel*)model;

@end

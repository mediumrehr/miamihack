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

@interface TRPRootViewController : UIViewController
// TODO: add playback controls view controller

- (instancetype)initWithAuthDelegate:(id<TRPRootViewControllerAuthDelegate>)authDelegate;

@end

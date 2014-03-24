//
//  TRPLeftDrawerViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLibSpotify/SPSession.h>

@protocol TRPLeftDrawerViewControllerDelegate <NSObject>
- (void)logout:(dispatch_block_t)completion;
@end

@interface TRPLeftDrawerViewController : UITableViewController
@property (nonatomic, weak) id<TRPLeftDrawerViewControllerDelegate> delegate;
@property (nonatomic, strong) SPUser *user;
@end

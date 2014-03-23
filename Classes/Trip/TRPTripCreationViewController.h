//
//  TRPTripCreationViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripCreationStep.h"
#import "TRPTripModel.h"

@class TRPTripCreationViewController;
@protocol TRPTripCreationViewControllerDelegate <NSObject>

- (void)controller:(TRPTripCreationViewController*)controller
     didCreateTrip:(TRPTripModel*)tripModel;

@end

@interface TRPTripCreationViewController : UIViewController
@property (nonatomic, weak) id<TRPTripCreationViewControllerDelegate> delegate;
@property (strong, nonatomic) UITableView *tableView;
@end

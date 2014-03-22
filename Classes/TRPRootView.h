//
//  TRPRootView.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRPRootView;
@protocol TRPRootViewDelegate <NSObject>

- (void)didTouchLogout:(TRPRootView*)rootView;

@end

@interface TRPRootView : UIView
@property (nonatomic, weak) id<TRPRootViewDelegate> delegate;
@property (nonatomic, strong) UIToolbar *topToolbar;
@property (nonatomic, strong) UIView *contentView;
@end

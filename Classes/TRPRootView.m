//
//  TRPRootView.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPRootView.h"

@implementation TRPRootView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }

    _topToolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(touchedLogout:)];
    [_topToolbar setItems:@[logoutButton]];
    [self addSubview:_topToolbar];

    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize toolbarSize = [_topToolbar sizeThatFits:self.bounds.size];
    toolbarSize.height += [[UIApplication sharedApplication] statusBarFrame].size.height;;
    _topToolbar.frame = (CGRect){
        .origin = CGPointZero,
        .size = toolbarSize
    };

    _contentView.frame = CGRectMake(0,
                                    CGRectGetMaxY(_topToolbar.frame),
                                    self.bounds.size.width,
                                    self.bounds.size.height - CGRectGetMaxY(_topToolbar.frame));
}

#pragma mark UI Actions

- (void)touchedLogout:(id)sender
{
    [_delegate didTouchLogout:self];
}

@end

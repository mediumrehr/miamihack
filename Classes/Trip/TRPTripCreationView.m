//
//  TRPTripCreationView.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationView.h"

@interface TRPTripCreationView ()
@property (nonatomic, strong) UITextField *locationField;
@end

@implementation TRPTripCreationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.locationField = [[UITextField alloc] init];
        self.locationField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.locationField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect locationFieldFrame = CGRectInset(self.bounds, 40, 0);
    locationFieldFrame.size.height = 30;
    locationFieldFrame.origin.y = 20;
    self.locationField.frame = locationFieldFrame;
}

@end

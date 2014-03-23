//
//  TRPTripPlaybackView.m
//  Tripster
//
//  Created by Rob Rehrig on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripPlaybackView.h"

@implementation TRPTripPlaybackView
@synthesize testButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:self.testButton];
    }
    return self;
}

- (void)layoutSubviews
{
    self.testButton.frame = CGRectMake(0.0, self.bounds.size.height/2.0, self.bounds.size.width, 30);
    [self.testButton setTitle:@"Test Button" forState:UIControlStateNormal];
}

@end

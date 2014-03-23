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
        artistModel = [[ArtistModel alloc] init];
        self.locationField = [[UITextField alloc] init];
        [self.locationField setDelegate:self];
        self.locationField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.locationField];
        [artistModel setDelegate:self];
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

//when clicking the return button in the keybaord
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    [artistModel createArtistsModelforLocation:textField.text];

}

-(void)didReceiveArtistModel:(NSArray *)artists withMessage:(NSString *)message{
    NSLog(@" Artist Array %@",artists);
    
}

@end

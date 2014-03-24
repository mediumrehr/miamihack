//
//  TRPMutableCollectionViewCell.m
//  Tripster
//
//  Created by Andrew Ayers on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPMutableCollectionViewCell.h"

@interface TRPMutableCollectionViewCell()
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *locButton;
@end
@implementation TRPMutableCollectionViewCell
@synthesize titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_backgroundImageView];
        
        titleLabel = [[UITextField alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.shadowColor = [UIColor blackColor];
//        _titleLabel.numberOfLines = 1;
//        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        [titleLabel setDelegate:self];
        [self.contentView addSubview:titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.shadowColor = [UIColor blackColor];
        _subtitleLabel.numberOfLines = 1;
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_subtitleLabel];
        
        _locButton = [[UIButton alloc] init];
        [_locButton setTitle:@"Get Location" forState:UIControlStateNormal];
        [self.contentView addSubview:_locButton];
        
    }
    return self;
}
+ (float)defaultPadding
{
    return 10.f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float padding = [[self class] defaultPadding];
    float labelWidth = self.contentView.bounds.size.width - 2*padding;
    
    self.backgroundImageView.frame = self.contentView.bounds;
    
    CGSize subtitleSize = [self.subtitleLabel sizeThatFits:
                           CGSizeMake(labelWidth,
                                      self.subtitleLabel.font.ascender - self.subtitleLabel.font.descender)];
    self.subtitleLabel.frame = (CGRect){
        .origin = CGPointMake(padding,
                              CGRectGetMaxY(self.contentView.frame) - subtitleSize.height - padding),
        .size = CGSizeMake(MIN(subtitleSize.width, labelWidth), subtitleSize.height)
    };
    
//    CGSize titleSize = [self.titleLabel sizeThatFits:
//                        CGSizeMake(labelWidth,
//                                   self.titleLabel.font.ascender - self.titleLabel.font.descender)];
    CGSize titleSize = CGSizeMake(self.contentView.bounds.size.width, self.titleLabel.font.ascender - self.titleLabel.font.descender);
    
    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(padding,
                              self.subtitleLabel.frame.origin.y - titleSize.height - padding),
        .size = CGSizeMake(MIN(titleSize.width, labelWidth), titleSize.height)
    };
    
    self.locButton.center = self.contentView.center;
    
}

-(void)showLocationButton:(BOOL)isShowing{
    [_locButton setHidden:!isShowing];
}
//when clicking the return button in the keybaord
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [super setTitle:textField.text];
}

-(void)startEditing{
    //TODO: Doesn't Work
    [[self titleLabel] becomeFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

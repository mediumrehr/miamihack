//
//  TRPTripCollectionViewCell.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCollectionViewCell.h"

@interface TRPTripCollectionViewCell ()
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *artistsLabel;
@end

@implementation TRPTripCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.shadowColor = [UIColor blackColor];
        [self.contentView addSubview:_locationLabel];

        _artistsLabel = [[UILabel alloc] init];
        _artistsLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        _artistsLabel.textColor = [UIColor lightGrayColor];
        _artistsLabel.shadowColor = [UIColor blackColor];
        [self.contentView addSubview:_artistsLabel];
    }
    return self;
}

+ (float)defaultPadding
{
    return 20.f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    float padding = [[self class] defaultPadding];

    self.artistsLabel.frame = (CGRect){
        .origin = CGPointMake(padding,
                              CGRectGetMaxY(self.contentView.frame) - _artistsLabel.bounds.size.height - padding),
        .size = _artistsLabel.bounds.size
    };

    self.locationLabel.frame = (CGRect) {
        .origin = CGPointMake(padding, self.artistsLabel.frame.origin.y - padding),
        .size = self.locationLabel.bounds.size
    };
}

- (void)setTripLocation:(NSString *)tripLocation
{
    if ([self.locationLabel.text isEqualToString:tripLocation]) {
        return;
    }

    self.locationLabel.text = tripLocation;
    [self.locationLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setArtists:(NSString *)artists
{
    if ([self.artistsLabel.text isEqualToString:artists]) {
        return;
    }

    self.artistsLabel.text = artists;
    [self.artistsLabel sizeToFit];
    [self setNeedsLayout];
}

@end

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

        float padding = [[self class] defaultPadding];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding,
                                                                   0,
                                                                   self.contentView.bounds.size.width - 2*padding,
                                                                   [UIFont labelFontSize])];
        _locationLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.shadowColor = [UIColor blackColor];
        [self.contentView addSubview:_locationLabel];

        _artistsLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding,
                                                                  0,
                                                                  self.contentView.bounds.size.width - 2*padding,
                                                                  [UIFont smallSystemFontSize])];
        _artistsLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _artistsLabel.textColor = [UIColor lightGrayColor];
        _artistsLabel.shadowColor = [UIColor blackColor];
        [self.contentView addSubview:_artistsLabel];
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

    self.artistsLabel.frame = (CGRect){
        .origin = CGPointMake(padding,
                              CGRectGetMaxY(self.contentView.frame) - self.artistsLabel.bounds.size.height - padding),
        .size = _artistsLabel.bounds.size
    };

    self.locationLabel.frame = (CGRect) {
        .origin = CGPointMake(padding,
                              self.artistsLabel.frame.origin.y - self.locationLabel.bounds.size.height - padding),
        .size = self.locationLabel.bounds.size
    };
}

- (void)setTripLocation:(NSString *)tripLocation
{
    if ([self.locationLabel.text isEqualToString:tripLocation]) {
        return;
    }

    self.locationLabel.text = tripLocation;
    [self setNeedsLayout];
}

- (void)setArtists:(NSString *)artists
{
    if ([self.artistsLabel.text isEqualToString:artists]) {
        return;
    }

    self.artistsLabel.text = artists;
    [self setNeedsLayout];
}

@end

//
//  TRPTripCollectionViewCell.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPGenericCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TRPGenericCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation TRPGenericCollectionViewCell

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

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];

        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.shadowColor = [UIColor blackColor];
        _subtitleLabel.numberOfLines = 1;
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_subtitleLabel];
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

    CGSize titleSize = [self.titleLabel sizeThatFits:
                        CGSizeMake(labelWidth,
                                   self.titleLabel.font.ascender - self.titleLabel.font.descender)];

    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(padding,
                              self.subtitleLabel.frame.origin.y - titleSize.height - padding),
        .size = CGSizeMake(MIN(titleSize.width, labelWidth), titleSize.height)
    };
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.titleLabel.text = @"";
    self.subtitleLabel.text = @"";
    [self.backgroundImageView cancelCurrentImageLoad];
    self.backgroundImageView.image = nil;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [UIView animateWithDuration:0.25 animations:^{
        if (selected) {
            self.selectedBackgroundView.frame = CGRectInset(self.contentView.bounds, -2.f, -2.f);
        } else {
            self.selectedBackgroundView.frame = self.contentView.bounds;
        }
    }];
}

- (void)setBackgroundImageURL:(NSURL *)backgroundImageURL
{
    [self.backgroundImageView setImageWithURL:backgroundImageURL];
}

- (void)setTitleFont:(UIFont*)font
{
    self.titleLabel.font = font;
    [self setNeedsLayout];
}

- (void)setSubtitleFont:(UIFont *)font
{
    self.subtitleLabel.font = font;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
    [self setNeedsLayout];
}

@end

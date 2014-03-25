//
//  TRPMutableCollectionViewCell.h
//  Tripster
//
//  Created by Andrew Ayers on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPGenericCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>

@protocol TRPMutableCollectionCellDelegate <NSObject>
-(void)textFieldDidFinishEditingForCell:(id)cell;
@end

@interface TRPMutableCollectionViewCell : TRPGenericCollectionViewCell <UITextFieldDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locManager;
    CLPlacemark *placemark;
    CLGeocoder *geocoder;
}
-(void)startEditing;
-(void)showLocationButton:(BOOL)isShowing;
@property (nonatomic, strong) UITextField *titleLabel;
@property int index;
@property (nonatomic, weak) id<TRPMutableCollectionCellDelegate> delegate;


@end

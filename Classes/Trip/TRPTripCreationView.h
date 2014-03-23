//
//  TRPTripCreationView.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistModel.h"
#import "TRPTripModel.h"

@interface TRPTripCreationView : UIView <UITextFieldDelegate, ArtistModelDelegate, UITableViewDataSource, UITableViewDelegate>{
    ArtistModel *artistModel;
    TRPMutableTripModel *tripmodel;
}

@property (nonatomic, retain) UITableView *tabView;

-(IBAction)createPlaylist:(id)sender;

@end

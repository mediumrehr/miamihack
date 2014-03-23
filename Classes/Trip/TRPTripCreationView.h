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
@protocol TripCreationViewDelegate <NSObject>
-(void)pushNextVC;

@end


@interface TRPTripCreationView : UIView <UITextFieldDelegate, ArtistModelDelegate, UITableViewDataSource, UITableViewDelegate>{
    ArtistModel *artistModel;
    TRPMutableTripModel *tripmodel;
    NSMutableArray *selectedArtists;
}

@property (nonatomic, retain) UITableView *tabView;
@property id delegate;

-(IBAction)createPlaylist:(id)sender;

@end

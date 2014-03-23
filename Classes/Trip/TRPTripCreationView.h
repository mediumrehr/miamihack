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
#import <CoreLocation/CoreLocation.h>

@class TRPTripCreationView;
@protocol TripCreationViewDelegate <NSObject>

- (void)creationView:(TRPTripCreationView*)view
   didUpdateLocation:(NSString*)location;


- (void)creationView:(TRPTripCreationView*)view
        didAddArtist:(id)artist;

- (void)creationView:(TRPTripCreationView*)view
     didRemoveArtist:(id)artist;

- (BOOL)isArtistSelected:(NSString*)artistID;

- (BOOL)isGenreSelected:(NSString*)genreID;

@end


@interface TRPTripCreationView : UIView
<UITextFieldDelegate, ArtistModelDelegate, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
{
    ArtistModel *artistModel;
    TRPMutableTripModel *tripmodel;
    NSMutableDictionary *selectedArtists, *selectedGenres;
    NSMutableArray *queriedGenres;
    bool isGenre;
    CLLocationManager *locManager;
    CLPlacemark *placemark;
    CLGeocoder *geocoder;
}
@property (nonatomic, weak) id delegate;

- (void)setPossibleArtists:(NSArray*)artists genres:(NSArray*)genres;

-(IBAction)createPlaylist:(id)sender;
-(IBAction)changeFilterType:(UISegmentedControl *)sender;
-(IBAction)getLocation:(id)sender;

@end

//
//  TRPTripDetailViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripDetailViewController.h"
#import "TRPGenericCollectionViewCell.h"
#import "ENAPI+RAC.h"
#import "ENSPAggregateArtist.h"
#import <CocoaLibSpotify/SPSession.h>
#import <CocoaLibSpotify/SPPlaylist.h>
#import <CocoaLibSpotify/SPPlaylistContainer.h>
#import <CocoaLibSpotify/SPTrack.h>
#import "SPPlaylistPlaybackDelegate.h"

static int ddLogLevel = LOG_LEVEL_DEBUG;

@interface TRPTripDetailViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TRPMutableTripModel *mutableTrip;
@property (nonatomic, strong) NSArray *aggregateArtists;
@property (nonatomic, strong) NSMutableSet *selectedAggregateArtists;
@property (nonatomic, strong) SPPlaylist *playlist;
@end

@implementation TRPTripDetailViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if ([parent isKindOfClass:[UINavigationController class]]) {
        [self didMoveToNavigationController:(UINavigationController*)parent];
    }
}

- (void)didMoveToNavigationController:(UINavigationController*)parentNavigationController
{
    [parentNavigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - View

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.itemSize = CGSizeMake((self.view.bounds.size.width - 30.f) / 2.f, self.view.bounds.size.height / 3.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height,
                                                        10.f,
                                                        20.f,
                                                        10.f);
    [self.collectionView registerClass:[TRPGenericCollectionViewCell class] forCellWithReuseIdentifier:@"TripCell"];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.navigationItem.hidesBackButton = NO;

    @weakify(self);
    [RACObserve(self, aggregateArtists) subscribeNext:^(NSArray *artists) {
        @strongify(self);
        [self.collectionView reloadData];
        [self updateCellSelection];
    }];

    [self updateCellSelection];
}

#pragma mark - Setters

- (void)setSelectedAggregateArtists:(NSMutableSet *)selectedAggregateArtists
{
    if ([_selectedAggregateArtists isEqual:selectedAggregateArtists]) {
        return;
    }

    _selectedAggregateArtists = selectedAggregateArtists;

    [self setupSelectedAritstsBindings];
}

- (void)setTripModel:(TRPTripModel *)tripModel
{
    if ([self.tripModel isEqual:tripModel]) {
        return;
    }
    _tripModel = tripModel;
    self.mutableTrip = [tripModel mutableCopy];
    self.selectedAggregateArtists = [tripModel.artistIDs mutableCopy];

    if (_tripModel.spotifyPlaylistURL) {
        @weakify(self);
        [SPPlaylist playlistWithPlaylistURL:_tripModel.spotifyPlaylistURL
                                  inSession:[SPSession sharedSession]
                                   callback:^(SPPlaylist *playlist) {
                                       @strongify(self);
                                       self.playlist = playlist;
                                   }];
    }

    [self setupTripModelBindings];
}

- (void)setPlaylist:(SPPlaylist *)playlist
{
    if ([_playlist isEqual:playlist]) {
        return;
    }

    _playlist = playlist;

    [self.mutableTrip setSpotifyPlaylistURL:_playlist.spotifyURL];

    self.playbackManager.playlistPlaybackDelegate.playlist = self.playlist;
}

#pragma mark - Playlist

- (void)createSpotifyPlaylist:(NSArray*)recommendedTracks
{
    DDLogInfo(@"Creating new spotify playlist: %@", recommendedTracks);
    @weakify(self);
    [SPAsyncLoading
     waitUntilLoaded:[[SPSession sharedSession] userPlaylists]
     timeout:5.f
     then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
         if ([loadedItems count] < 1) {
             return;
         }

         SPPlaylistContainer *userPlaylists = [loadedItems lastObject];

         if (self.playlist) {
             SPPlaylist *playlist = self.playlist;
             [userPlaylists removeItem:playlist callback:^(NSError *error) {
                 if (error) {
                     DDLogError(@"Failed to remove playilst %@", playlist.spotifyURL);
                 }
             }];
         }

         self.playlist = nil;

         [userPlaylists
          createPlaylistWithName:_tripModel.location
          callback:^(SPPlaylist *createdPlaylist) {
              [SPAsyncLoading waitUntilLoaded:createdPlaylist timeout:10.f then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                  @strongify(self);
                  if (!self) {
                      return;
                  }
                  if ([loadedItems count] < 1) {
                      return;
                  }

                  SPPlaylist *loadedPlaylist = [loadedItems lastObject];

                  NSArray *nonNullTracks = [[recommendedTracks.rac_sequence filter:^BOOL(id value) {
                      return ![[NSNull null] isEqual:value];
                  }] array];

                  @weakify(loadedPlaylist);
                  [loadedPlaylist addItems:nonNullTracks atIndex:0 callback:^(NSError *error) {
                      @strongify(loadedPlaylist);
                      if (error) {
                          DDLogError(@"Failed to add tracks to playlist %@. %@", loadedPlaylist, error);
                      } else {
                          DDLogInfo(@"Added new tracks to playlist %@. %@", loadedPlaylist, nonNullTracks);
                          self.playlist = loadedPlaylist;
                      }
                  }];
              }];
          }];
     }];
}

#pragma mark - Artist Recommendations

- (void)fetchTracksForSelectedArtistIDs
{
    if ([self.selectedAggregateArtists count]) {
        @weakify(self)
        [[ENAPI requestStaticPlaylistForArtists:self.mutableTrip.artistIDs]
         subscribeNext:^(NSDictionary *response) {
             NSArray *songs = response[@"response"][@"songs"];
             [[[RACSignal merge:[songs.rac_sequence map:^id(NSDictionary *song) {
                 return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                     NSString *foreignID = [song[@"tracks"] lastObject][@"foreign_id"];
                     NSString *trackID = [[foreignID componentsSeparatedByString:@":"] lastObject];
                     NSURL *trackURL = [NSURL URLWithString:[NSString stringWithFormat:@"spotify:track:%@", trackID]];
                     [SPTrack trackForTrackURL:trackURL
                                     inSession:[SPSession sharedSession]
                                      callback:^(SPTrack *track) {
                                          if (track) {
                                              [SPAsyncLoading
                                               waitUntilLoaded:track
                                               timeout:2.f
                                               then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                                                   [subscriber sendNext:track];
                                                   [subscriber sendCompleted];
                                               }];
                                          } else {
                                              [subscriber sendNext:[NSNull null]];
                                              [subscriber sendCompleted];
                                          }
                                      }];
                     return [RACDisposable disposableWithBlock:^{}];
                 }];
             }]] collect] subscribeNext:^(NSArray *tracks) {
                 @strongify(self);
                 [self createSpotifyPlaylist:tracks];
             } error:^(NSError *error) {
                 DDLogVerbose(@"Failed to accumulate all tracks: %@", error);
             }];
         }
         error:^(NSError *error) {
             [[[UIAlertView alloc] initWithTitle:@"Failed to Create Playlist"
                                         message:[error description]
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] show];
         }];
    }
}

#pragma mark - Bindings

- (void)setupSelectedAritstsBindings
{
    @weakify(self);
    void(^updateTripModelWithSelectedArtists)(id) = ^(ENSPAggregateArtist *addedArtist) {
        @strongify(self);
        [self.mutableTrip setArtistIDs:self.selectedAggregateArtists];
        if ([self.mutableTrip diff:self.tripModel]) {
            [self fetchTracksForSelectedArtistIDs];
        }
    };

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(addObject:)]
     subscribeNext:updateTripModelWithSelectedArtists];

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(removeObject:)]
     subscribeNext:updateTripModelWithSelectedArtists];

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(removeAllObjects)]
     subscribeNext:updateTripModelWithSelectedArtists];
}

- (void)setupTripModelBindings
{
    TRPMutableTripModel *mutableTrip = _mutableTrip;
    @weakify(self);
    [RACObserve(mutableTrip, location) subscribeNext:^(NSString *location) {
        @strongify(self)
        self.navigationItem.title = location;
        [self setupLocationSignal:location];
    }];

    [[RACSignal merge:@[RACObserve(mutableTrip, artistIDs),
                        RACObserve(mutableTrip, spotifyPlaylistURL)]]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.tripModel diff:mutableTrip]) {
             [self.storage saveTrip:[mutableTrip copy]];
         }
    }];
}

- (void)setupLocationSignal:(NSString*)location
{
    @weakify(self);
    [[ENAPI requestArtistsForLocation:location]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         if (!self) {
             return;
         }

        self.aggregateArtists = [[[response[@"response"][@"artists"] rac_sequence] map:^id(NSDictionary *artistData) {
            ENSPAggregateArtist *aggregateArtist = [ENSPAggregateArtist new];
            aggregateArtist.enArtistData = artistData;
            aggregateArtist.enArtistID = artistData[@"id"];
            [ENSPAggregateArtist loadSpotifyArtistFromENArtistData:artistData
                                                        completion:^(SPArtist *spArtist) {
                                                            aggregateArtist.spArtist = spArtist;
                                                        }];
            return aggregateArtist;
         }] array];
     }
     error:^(NSError *error) {
         NSString *errorMessage = [NSString stringWithFormat:@"Failed to find artists in %@. %@",
                                   location, error];

         [[[UIAlertView alloc] initWithTitle:@"Artist Location Failure"
                                    message:errorMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI Utils

- (void)updateCellSelection
{
    if (!self.aggregateArtists) {
        return;
    }
    for (NSString *artistID in self.selectedAggregateArtists) {
        NSUInteger index = [self.aggregateArtists indexOfObjectPassingTest:^BOOL(ENSPAggregateArtist *artist,
                                                                                NSUInteger idx,
                                                                                BOOL *stop) {
            return [artist.enArtistID isEqualToString:artistID];
        }];
        if (index == NSNotFound) {
            continue;
        }
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                          animated:NO
                                    scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}

#pragma mark - UICollectionViewDataSource

- (int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.aggregateArtists count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRPGenericCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TripCell"
                                                                                   forIndexPath:indexPath];
    [cell setTitleFont:[UIFont systemFontOfSize:13.f]];
    cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];

    ENSPAggregateArtist *artist = self.aggregateArtists[indexPath.row];
    [cell setTitle:artist.enArtistData[@"name"]];
    [cell setBackgroundImageURL:[artist.enArtistData[@"images"] firstObject][@"url"]];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedAggregateArtists count] < 5) {
        [self.selectedAggregateArtists addObject:[self.aggregateArtists[indexPath.row] enArtistID]];
        return;
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAggregateArtists removeObject:[self.aggregateArtists[indexPath.row] enArtistID]];
}

@end

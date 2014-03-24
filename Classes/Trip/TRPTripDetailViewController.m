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

@interface TRPTripDetailViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TRPMutableTripModel *mutableTrip;
@property (nonatomic, strong) NSArray *aggregateArtists;
@property (nonatomic, strong) NSMutableSet *selectedAggregateArtists;
@end

@implementation TRPTripDetailViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _selectedAggregateArtists = [NSMutableSet new];

    @weakify(self);
    void(^updateTripModelWithSelectedArtists)(id) = ^(ENSPAggregateArtist *addedArtist) {
        @strongify(self);
        [self.mutableTrip setArtistIDs:[NSSet setWithArray:[[self.selectedAggregateArtists.rac_sequence
                                                             map:^(ENSPAggregateArtist *artist) {
                                                                 return artist.enArtistID;
                                                             }] array]]];
    };

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(addObject:)]
     subscribeNext:updateTripModelWithSelectedArtists];

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(removeObject:)]
     subscribeNext:updateTripModelWithSelectedArtists];

    [[self.selectedAggregateArtists rac_signalForSelector:@selector(removeAllObjects)]
     subscribeNext:updateTripModelWithSelectedArtists];

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
    self.collectionView.contentInset = UIEdgeInsetsMake(0.f, 10.f, 20.f, 10.f);
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
        [self.selectedAggregateArtists removeAllObjects];
        [self.collectionView reloadData];
    }];
}

- (void)setTripModel:(TRPTripModel *)tripModel
{
    if ([self.tripModel isEqual:tripModel]) {
        return;
    }
    _tripModel = tripModel;
    self.mutableTrip = [tripModel mutableCopy];

    [self setupBindings];
}

- (void)setupBindings
{
    TRPMutableTripModel *mutableTrip = _mutableTrip;
    @weakify(self);
    [RACObserve(mutableTrip, location) subscribeNext:^(NSString *location) {
        @strongify(self)
        self.navigationItem.title = location;
        [self setupLocationSignal:location];
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
        [self.selectedAggregateArtists addObject:self.aggregateArtists[indexPath.row]];
        return;
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAggregateArtists removeObject:self.aggregateArtists[indexPath.row]];
}

@end

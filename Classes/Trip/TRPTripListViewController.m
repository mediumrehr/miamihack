//
//  TRPTripListViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripListViewController.h"
#import "TRPGenericCollectionViewCell.h"
#import "TRPTripDetailViewController.h"
#import "ENAPI+RAC.h"

static int ddLogLevel = LOG_LEVEL_DEBUG;

@interface TripListItem : NSObject
@property (nonatomic, strong) NSString *tripID;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *artistNames;
@end

@implementation TripListItem
@end

@interface TRPTripListViewController ()
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray /*<TripListItem>*/ *trips;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TRPTripListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    parentNavigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController == self) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.tripStorage) {
        return;
    }

    [self reloadDataFromStorage];
}

- (void)reloadDataFromStorage
{
    _trips = [[[[_tripStorage allTrips] rac_sequence] map:^id(TRPTripModel *tripModel) {
        TripListItem *item = [TripListItem new];
        item.tripID = tripModel.tripID;
        item.location = tripModel.location;
        if ([tripModel.artistIDs count] == 0) {
            return item;
        }
        @weakify(self)
        [[ENAPI requestInfoForArtists:tripModel.artistIDs]
         subscribeNext:^(NSArray *responses) {
             @strongify(self);
             if (!self) {
                 return;
             }
             NSArray *artistNames = [responses valueForKeyPath:@"response.artist.name"];
             item.artistNames = [artistNames componentsJoinedByString:@", "];
         } error:^(NSError *error) {
             if (error) {
                 DDLogError(@"Failed to get info for artists: %@. %@", tripModel.artistIDs, error);
             }
         }];

        return item;
    }] array];

    [self.collectionView reloadData];
}

#pragma mark -

- (void)setTripStorage:(id<TripStorage>)tripStorage
{
    if ([self.tripStorage isEqual:tripStorage]) {
        return;
    }

    _tripStorage = tripStorage;

    [self reloadDataFromStorage];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.opaque = YES;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.f;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width - 40.f, self.view.bounds.size.height / 3.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(40.f, 20.f, 20.f, 20.f);
    [self.collectionView registerClass:[TRPGenericCollectionViewCell class] forCellWithReuseIdentifier:@"TripCell"];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (long)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (long)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.trips count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRPGenericCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TripCell"
                                                                                forIndexPath:indexPath];
    TripListItem *trip = self.trips[indexPath.row];
    [[cell rac_deallocDisposable] dispose];
    [RACObserve(trip, location) subscribeNext:^(id x) {
        cell.title = trip.location;
    }];
    [RACObserve(trip, artistNames) subscribeNext:^(id x) {
        cell.subtitle = trip.artistNames;
    }];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (void)collectionView:(UICollectionView *)collectionView
//  didEndDisplayingCell:(UICollectionViewCell *)cell
//    forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TripListItem *selectedTrip = self.trips[indexPath.row];
    TRPTripModel *tripModel = [self.tripStorage tripWithIdentifier:selectedTrip.tripID];
    TRPTripDetailViewController *tripDetailViewController = [[TRPTripDetailViewController alloc] init];
    tripDetailViewController.tripModel = tripModel;
    tripDetailViewController.storage = self.tripStorage;
    tripDetailViewController.playbackController = self.playbackController;
    [self.navigationController pushViewController:tripDetailViewController animated:YES];
}

@end

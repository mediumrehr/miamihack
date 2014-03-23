//
//  TRPTripCreationView.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationView.h"

@interface TRPTripCreationView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UIButton *createPlaylistButton;
@property (nonatomic, strong) UISegmentedControl *filterTypeSelect;
@property (nonatomic, strong) UIButton *locButton;
@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, strong) NSArray *genres;
@end

@implementation TRPTripCreationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isGenre = false;

        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        self.locationField = [[UITextField alloc] init];
        [self.locationField setDelegate:self];
        self.locationField.borderStyle = UITextBorderStyleRoundedRect;
        self.locationField.placeholder = @"Location";
        [self addSubview:self.locationField];
        
        NSArray *itemArray = [NSArray arrayWithObjects:@"Artist", @"Genre", nil];
        self.filterTypeSelect = [[UISegmentedControl alloc] initWithItems:itemArray];
        self.filterTypeSelect.selectedSegmentIndex = 0;
        [self.filterTypeSelect addTarget:self action:@selector(changeFilterType:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.filterTypeSelect];
        [tripmodel setIsGenre:NO];

        self.createPlaylistButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.createPlaylistButton addTarget:self
                                      action:@selector(createPlaylist:)
                            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.createPlaylistButton];
        
        self.locButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locButton addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventTouchUpInside];
        self.locButton.frame = CGRectMake(250.0, 20.0, 30.0, 30.0);
        //self.locButton.adjustsImageWhenHighlighted = NO;
        UIImage *locSearchNormal = [UIImage imageNamed:@"locsearch_normal.png"];
        UIImage *locSearchPressed = [UIImage imageNamed:@"locsearch_pressed.png"];
        [self.locButton setBackgroundImage:locSearchNormal forState:UIControlStateNormal];
        [self.locButton setBackgroundImage:locSearchPressed forState:UIControlStateHighlighted];
        [self addSubview:self.locButton];
        
        //Create location manager object
        locManager = [[CLLocationManager alloc] init];
        
        //There will be a warning from this line of code, ignore it
        [locManager setDelegate:self];
        
        //And we want it to be as accurate as possible
        //regardless of how much time it takes
        [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //Tell our manager to start looking for its location immediately
        //[locManager startUpdatingLocation];
        placemark = [[CLPlacemark alloc] init];
        geocoder = [[CLGeocoder alloc] init];
    }
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeRightGestureRecognizer];
    

    return self;
}

- (void)setPossibleArtists:(NSArray*)artists genres:(NSArray *)genres
{
    _artists = artists;
    _genres = genres;
    [self.tableView reloadData];
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
//    if ([[tripmodel chosenSeeds] count]>0) {
//        [delegate pushPlaybackVC];
//    }
}

- (void) locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*) oldLocation
{
    // This will be called every time the device has any new location information.
    CLLocation *loc = newLocation;
    if (loc) {
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemark, NSError *error) {
            CLPlacemark *topResult = [placemark objectAtIndex:0];
            NSString *title = [NSString stringWithFormat:@"%@ %@ %@ %@", topResult.country, topResult.locality, topResult.subLocality, topResult.thoroughfare];
            NSLog(@"%@",title);
            [self.locationField setText:topResult.locality];
            [self textFieldDidEndEditing:self.locationField];
            [locManager stopUpdatingLocation];
        }];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filterTypeSelect.selectedSegmentIndex == 0)
        return [_artists count];
    else if (self.filterTypeSelect.selectedSegmentIndex == 1)
        return [_genres count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier;
    NSString *cellText;
    
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if (self.filterTypeSelect.selectedSegmentIndex == 0) {
        NSDictionary *artist = _artists[indexPath.row];
        cell.textLabel.text = artist[@"name"];
        if ([_delegate isArtistSelected:artist[@"id"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (self.filterTypeSelect.selectedSegmentIndex == 1) {
        NSString *genre = nil;
        cell.textLabel.text = genre;
        if ([_delegate isGenreSelected:genre]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (self.filterTypeSelect.selectedSegmentIndex == 0) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_delegate creationView:self didRemoveArtist:_artists[path.row]];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_delegate creationView:self didAddArtist:_artists[path.row]];
        }
    }
    else if (self.filterTypeSelect.selectedSegmentIndex == 1) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [cell setSelected:NO];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    //CGRect locationFieldFrame = CGRectInset(self.bounds, 20, 0);
    CGRect locationFieldFrame = CGRectMake(40.0, 20.0, 215.0, 30.0);
    //locationFieldFrame.size.height = 30;
    //locationFieldFrame.origin.y = 20;
    self.locationField.frame = locationFieldFrame;
    
    self.createPlaylistButton.frame = CGRectMake(0.0, height - 40.0, width, 40.0);
    [self.createPlaylistButton setTitle:@"Create Playlist" forState:UIControlStateNormal];
    [self.createPlaylistButton setBackgroundColor:[UIColor blackColor]];
    self.createPlaylistButton.titleLabel.textColor = [UIColor whiteColor];
    [self.createPlaylistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.createPlaylistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    CGFloat bottomOfLocField = self.locationField.frame.origin.y + self.locationField.frame.size.height + 10;
    self.filterTypeSelect.frame = CGRectMake(40.0, bottomOfLocField, self.bounds.size.width - 80.0, 30);

    CGFloat bottomOfTypeSel = self.filterTypeSelect.frame.origin.y + self.filterTypeSelect.frame.size.height + 10;
    _tableView.frame = CGRectMake(0.0, bottomOfTypeSel, width, self.createPlaylistButton.frame.origin.y - bottomOfTypeSel - 10);
    [self addSubview:_tableView];
}

-(void)getLocation:(id)sender{
    [self.locationField resignFirstResponder];
    [locManager startUpdatingLocation];
}
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    self.locationField.placeholder = nil;
}

//when clicking the return button in the keybaord
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [artistModel createArtistsModelforLocation:textField.text];
    [tripmodel setLocation:textField.text];
}

- (void)changeFilterType:(UISegmentedControl *)sender
{
    isGenre = !isGenre;
    [self.tableView reloadData];
}

-(void)didReceiveArtistModel:(NSArray *)artists AndGeneratedGenres:(NSArray *)genres withMessage:(NSString *)message{
    NSLog(@" Artist Array %@",artists);
    [tripmodel setNeedsNewPlaylist:YES];
    [tripmodel setArtistIDs:nil];
    [selectedArtists removeAllObjects];
    [selectedGenres removeAllObjects];
    [tripmodel setChosenSeeds:nil];
    [tripmodel setArtistIDs:[artists mutableCopy]];
    [queriedGenres removeAllObjects];
    queriedGenres = [genres mutableCopy];
    [self.tableView reloadData];
}

-(void)createPlaylist:(id)sender{
    if (isGenre && ([selectedGenres count] > 0))
        [tripmodel setChosenSeeds:[[selectedGenres allKeys] mutableCopy]];
    else if ([selectedArtists count] > 0)
        [tripmodel setChosenSeeds:[[selectedArtists allKeys] mutableCopy]];
    else
        return;
    
    [tripmodel setIsGenre:self.filterTypeSelect.selectedSegmentIndex];
//    [delegate pushPlaybackVC];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.delegate creationView:self didUpdateLocation:textField.text];
    return YES;
}

@end

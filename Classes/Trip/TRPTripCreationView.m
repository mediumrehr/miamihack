//
//  TRPTripCreationView.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationView.h"

@interface TRPTripCreationView ()
@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UIButton *createPlaylistButton;
@end

@implementation TRPTripCreationView
@synthesize tabView, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        artistModel = [[ArtistModel alloc] init];
        [artistModel setDelegate:self];
        tripmodel = [TRPMutableTripModel getTripModel];
        
        self.locationField = [[UITextField alloc] init];
        [self.locationField setDelegate:self];
        self.locationField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.locationField];
        
        self.createPlaylistButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.createPlaylistButton addTarget:self action:@selector(createPlaylist:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.createPlaylistButton];
        
        selectedArtists = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tripmodel artistIDs] count];
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
    cellText = [[[tripmodel artistIDs] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [[cell textLabel] setText:cellText];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        // remove from selectedArtists
        [selectedArtists removeObjectIdenticalTo:[cell.textLabel text]];
    } else {
        if ([selectedArtists count]<5) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // add to selectedArtists
            [selectedArtists addObject:[cell.textLabel text]];
        }
        else {
            [cell setSelected:NO];
        }
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGRect locationFieldFrame = CGRectInset(self.bounds, 40, 0);
    locationFieldFrame.size.height = 30;
    locationFieldFrame.origin.y = 20;
    self.locationField.frame = locationFieldFrame;
    
    self.createPlaylistButton.frame = CGRectMake(0.0, height - 50.0, width, locationFieldFrame.size.height);
    [self.createPlaylistButton setTitle:@"Create Playlist" forState:UIControlStateNormal];
    
    tabView = [[UITableView alloc] init];
    tabView.dataSource = self;
    tabView.delegate = self;
    CGFloat bottomOfLocField = self.locationField.frame.origin.y + self.locationField.frame.size.height + 10;
    tabView.frame = CGRectMake(0.0, bottomOfLocField, width, self.createPlaylistButton.frame.origin.y - bottomOfLocField - 10);
    [self addSubview:tabView];
}

//when clicking the return button in the keybaord
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    [artistModel createArtistsModelforLocation:textField.text];
    [tripmodel setLocation:textField.text];
}

-(void)didReceiveArtistModel:(NSArray *)artists AndGeneratedGenres:(NSArray *)genres withMessage:(NSString *)message{
    NSLog(@" Artist Array %@",artists);
    [tripmodel setArtistIDs:nil];
    [tripmodel setArtistIDs:[artists mutableCopy]];
    [tabView reloadData];
}

-(void)createPlaylist:(id)sender{
    [delegate pushNextVC];
}
@end

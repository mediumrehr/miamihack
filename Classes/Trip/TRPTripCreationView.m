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
@end

@implementation TRPTripCreationView
@synthesize tabView;

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
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier;
    NSString *cellText;
    
//    if(indexPath.section == 0){
//        identifier = @"Patient Cell";
//        cellText = [patientsNameArray objectAtIndex:[indexPath row]];
//        
//    } else if(indexPath.section == 1){
//        identifier = @"Activity Cell";
//        cellText = [activityArray objectAtIndex:[indexPath row]];
//        
//    } else if(indexPath.section == 2){
//        identifier = @"Deviation Cell";
//        cellText = [deviationArray objectAtIndex:[indexPath row]];
//    }
    
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [[cell textLabel] setText:cellText];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect locationFieldFrame = CGRectInset(self.bounds, 40, 0);
    locationFieldFrame.size.height = 30;
    locationFieldFrame.origin.y = 20;
    self.locationField.frame = locationFieldFrame;
    
    UITableView *table = [[UITableView alloc] init];
    table.dataSource = self;
    table.delegate = self;
    table.frame = CGRectMake(40, 70, locationFieldFrame.size.width, 300);
    [self addSubview:table];
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

-(void)didReceiveArtistModel:(NSArray *)artists withMessage:(NSString *)message{
    NSLog(@" Artist Array %@",artists);
    
}

@end

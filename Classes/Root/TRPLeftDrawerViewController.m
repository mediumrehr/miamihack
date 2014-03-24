//
//  TRPLeftDrawerViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPLeftDrawerViewController.h"
#import <CocoaLibSpotify/SPUser.h>
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger, TRPLeftDrawerCell) {
    TRPLeftDrawerCell_User = 0,
    TRPLeftDrawerCell_Logout,
    TRPLeftDrawerCellCount
};

#define kLeftDrawerCell @"LeftDrawerCell"

@interface TRPLeftDrawerViewController ()
@end

@implementation TRPLeftDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLeftDrawerCell];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overidden Setters

- (void)setUser:(SPUser *)user
{
    if ([_user isEqual:user]) {
        return;
    }
    _user = user;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftDrawerCell];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    switch (indexPath.row) {
        case TRPLeftDrawerCell_User:
            if (self.user.isLoaded) {
                cell.textLabel.text = [NSString stringWithFormat:@"Logged in as: %@", [self.user displayName]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case TRPLeftDrawerCell_Logout:
            cell.textLabel.text = @"Logout";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TRPLeftDrawerCellCount;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == TRPLeftDrawerCell_Logout) {
        [_delegate logout:nil];
    }
}

@end

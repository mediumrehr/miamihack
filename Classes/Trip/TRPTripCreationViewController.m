//
//  TRPTripCreationViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationViewController.h"
#import "TRPTripCreationView.h"

@interface TRPTripCreationViewController ()

@end

@implementation TRPTripCreationViewController

- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    self.view = [[TRPTripCreationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end

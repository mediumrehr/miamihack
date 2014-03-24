//
//  TRPTripDetailViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripDetailViewController.h"
#import "ENAPI+RAC.h"
@interface TRPTripDetailViewController ()
@property (nonatomic, weak) RACDisposable *latestLocationRequest;
@end

@implementation TRPTripDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

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

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.title = self.tripModel.location;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTripModel:(TRPTripModel *)tripModel
{
    if ([self.tripModel isEqual:tripModel]) {
        return;
    }
    _tripModel = tripModel;
    self.navigationItem.title = tripModel.location;
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

//
//  FavoritePlacesViewController.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/10/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "FavoritePlacesViewController.h"

@interface FavoritePlacesViewController ()

@end

@implementation FavoritePlacesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (IBAction)tappedCloseButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MapViewController.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/9/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.place) {
        [self configureViewWithCoordinates:CLLocationCoordinate2DMake([self.place.latitude doubleValue], [self.place.longitude doubleValue])];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup

- (void)configureViewWithCoordinates:(CLLocationCoordinate2D)coordinates {
    
    // Zoom map
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    // Add pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinates];
    [annotation setTitle:self.place.title];
    [self.mapView addAnnotation:annotation];
}

#pragma mark - IBAction Methods

- (IBAction)tappedCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

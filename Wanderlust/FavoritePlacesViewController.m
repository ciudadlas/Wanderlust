//
//  FavoritePlacesViewController.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/10/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "FavoritePlacesViewController.h"
#import "ExplorePlacesCustomAnimator.h"
#import "ExplorePlacesViewController.h"
#import <CoreData/CoreData.h>
#import "Place+Read.h"
#import "AppDelegate.h"
#import "Macros.h"
#import "FavoritePlaceTableViewCell.h"
#import "UIImageView+AFNetworkingFadeInAdditions.h"

static NSString *const CellIdentifier = @"FavoritePlaceTableViewCell";

@interface FavoritePlacesViewController () <UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation FavoritePlacesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup Helpers

- (void)setupView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configureCell:(FavoritePlaceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.placeTitle.text = place.title;
    cell.placeAddress.text = place.address;
    cell.placeImageView.image = nil;
    
    [cell.placeImageView setImageWithURL:place.imageDownloadURL placeholderImage:[UIImage imageNamed:@"favorites_placeholder"] fadeInWithDuration:0.3];
}

#pragma mark - Get Data Methods

- (void)getData {
    if (!self.managedObjectContext) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;        
    }
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        DLog(@"Error fetching favorite places %@", [error localizedDescription]);
    }
}

#pragma mark - IBAction Methods

- (IBAction)tappedCloseButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    // Check if we're transitioning from this view controller to the explore places view controller
    // If so return our custom animator object for the transition animation
    if (fromVC == self && [toVC isKindOfClass:[ExplorePlacesViewController class]]) {
        return [[ExplorePlacesCustomAnimator alloc] init];
    } else {
        return nil;
    }
}

#pragma mark - Custom Getter

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Place" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavorited == %@", [NSNumber numberWithBool:YES]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavoritePlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

@end

//
//  ViewController.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "PlacesViewController.h"
#import "APIClient.h"
#import "Macros.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import "Place+Read.h"
#import "MapViewController.h"

@interface PlacesViewController ()

@property (weak, nonatomic) IBOutlet CardsStackView *cardsStack;
@property (weak, nonatomic) PannableCardView *cardOnTop;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;

@property (strong, nonatomic) NSArray *places;

@end

@implementation PlacesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    self.cardsStack.delegate = self;
    self.cardsStack.dataSource = self;
    
    // Don't show any text while items are loading
    self.placeAddress.text = @"";
    self.placeName.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.places) {
        [self getPlaces];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup

- (void)setupView {
    self.placeName.numberOfLines = 2;
    self.placeName.minimumScaleFactor = 8.0 / self.placeName.font.pointSize;
    self.placeName.adjustsFontSizeToFitWidth = YES;
    
    self.placeAddress.numberOfLines = 1;
    self.placeAddress.minimumScaleFactor = 8.0 / self.placeName.font.pointSize;
    self.placeAddress.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - Get Data Helper Methods

- (void)getPlaces {
    
    [SVProgressHUD showWithStatus:@"Loading places..."];
    
    [[APIClient sharedInstance] getPlacesWithCompletionBlock:^(NSError *error, NSDictionary *response) {
        if (!error) {
            NSArray *places = response[@"places"];
            self.places = places;
            DLog(@"Received %lu places from the API.", (unsigned long)places.count);
            
            [self.cardsStack reload];
            
            [SVProgressHUD showSuccessWithStatus:@"Success!"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error getting places: %@", [error localizedDescription]]];
        }
    }];
}

- (void)setImageForImageView:(UIImageView *)view withPlace:(Place *)place {
    
    __weak UIImageView *weakImageView = view;
    NSURLRequest *request = [NSURLRequest requestWithURL:place.imageDownloadURL];
    [view setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView *strongImageView = weakImageView;
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed downloading image with error %@", [error localizedDescription]);
    }];
}

#pragma mark - CardsStackViewDataSource Methods

- (NSInteger)numberOfCardsOnStack:(CardsStackView *)stackView {
    // Only when we have data for places, we want the cards stack to load cards
    if (self.places) {
        return 5;
    } else {
        return 0;
    }
}

- (PannableCardView *)nextCardViewToShow:(CardsStackView *)stackView {
    NSUInteger randomIndex = arc4random() % [self.places count];
    Place *randomPlace = [self.places objectAtIndex:randomIndex];
    NSLog(@"Random place %@", randomPlace.title);
    
    PannableCardView *newCardView = [[PannableCardView alloc] initWithFrame:stackView.bounds];
    newCardView.delegate = stackView;
    newCardView.tag = randomIndex;
    
    [self setImageForImageView:newCardView.imageView withPlace:randomPlace];
    
    return newCardView;
}

#pragma mark - CardsStackViewDelegate Methods

- (void)stackView:(CardsStackView *)stackView cardViewDidAppearOnTopOfStack:(PannableCardView *)cardView {
    int tag = (int)cardView.tag;
    Place *place = [self.places objectAtIndex:tag];

    self.placeName.text = place.title;
    self.placeAddress.text = place.address;
    self.cardOnTop = cardView;
}

- (void)stackView:(CardsStackView *)stackView didTapOnCardView:(PannableCardView *)cardView {
    [self performSegueWithIdentifier:@"MapViewControllerSegue" sender:self];
}

- (void)stackView:(CardsStackView *)stackView didSwipeCardViewLeft:(PannableCardView *)cardView {
    NSLog(@"Card view swiped left");
}

- (void)stackView:(CardsStackView *)stackView didSwipeCardViewRight:(PannableCardView *)cardView {
    NSLog(@"Card view swiped right");
}

#pragma mark - View Controller Transition

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapViewControllerSegue"]) {

        MapViewController *mapVC = [segue destinationViewController];
        Place *place = [self.places objectAtIndex:self.cardOnTop.tag];
        mapVC.place = place;
    }
}

@end

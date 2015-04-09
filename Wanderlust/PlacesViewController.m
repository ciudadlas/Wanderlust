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

@interface PlacesViewController ()

@property (weak, nonatomic) IBOutlet CardsStackView *cardsStack;
@property (strong, nonatomic) NSArray *places;

@end

@implementation PlacesViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cardsStack.delegate = self;
    self.cardsStack.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Data Helper Methods

- (void)getLocations {
    
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
    
    PannableCardView *newCardView = [[PannableCardView alloc] initWithFrame:stackView.bounds];
    newCardView.delegate = stackView;
    newCardView.tag = randomIndex;
    
    [self setImageForImageView:newCardView.imageView withPlace:randomPlace];
    
    return newCardView;
}

#pragma mark - CardsStackViewDelegate Methods

- (void)cardViewSwipedLeft:(CardsStackView *)stackView cardView:(PannableCardView *)cardView {
    NSLog(@"Card view swiped left");
}

- (void)cardViewSwipedRight:(CardsStackView *)stackView cardView:(PannableCardView *)cardView {
    NSLog(@"Card view swiped right");
}

@end

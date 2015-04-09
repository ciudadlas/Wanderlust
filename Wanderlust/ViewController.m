//
//  ViewController.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "ViewController.h"
#import "APIClient.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CardsStackView *cardsStack;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cardsStack.delegate = self;
    self.cardsStack.dataSource = self;
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Data Helper Methods

- (void)getData {
    [[APIClient sharedInstance] getLocationsWithCompletionBlock:^(NSError *error, NSDictionary *response) {
        NSLog(@"response %@", response);
    }];
}

#pragma mark - CardsStackViewDelegate Methods

- (NSInteger)numberOfCardsOnStack:(CardsStackView *)stackView {
    return 5;
}

- (PannableCardView *)nextCardViewToShow:(CardsStackView *)stackView {
    PannableCardView *newCardView = [[PannableCardView alloc] initWithFrame:stackView.bounds];
    newCardView.imageView.image = [UIImage imageNamed:@"cat"];
    newCardView.delegate = stackView;
    
    return newCardView;
}

#pragma mark - CardsStackViewDataSource Methods

- (void)cardViewSwipedLeft:(CardsStackView *)stackView cardView:(PannableCardView *)cardView {
    NSLog(@"Card view swiped left");
}

- (void)cardViewSwipedRight:(CardsStackView *)stackView cardView:(PannableCardView *)cardView {
    NSLog(@"Card view swiped right");
}

@end

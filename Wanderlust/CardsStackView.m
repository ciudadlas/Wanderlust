//
//  CardsStackView.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "CardsStackView.h"
#import "PannableCardView.h"

@interface CardsStackView()

@property (nonatomic) BOOL addedViews;

@end

@implementation CardsStackView

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"self.bound %@", NSStringFromCGRect(self.bounds));
    
    if (!self.addedViews) {
        self.addedViews = YES;

        // Default number of cards on stack
        NSInteger numberOfCardsOnStack = 3;
        
        if ([self.dataSource respondsToSelector:@selector(numberOfCardsOnStack:)]) {
            numberOfCardsOnStack = [self.dataSource numberOfCardsOnStack:self];
        }
                                          
        for (int i = 0; i < numberOfCardsOnStack; i++) {
            [self addCardView];
        }
    }
}

#pragma mark - Helper Methods

- (void)addCardView {
    if ([self.dataSource respondsToSelector:@selector(nextCardViewToShow:)]) {
        PannableCardView *newCardView = [self.dataSource nextCardViewToShow:self];
        [self addSubview:newCardView];
    }
    
    [self debugPrintNumberOfViewsOnStack];
}

#pragma mark - PannableCardViewDelegate Methods

- (void)cardSwipedRight:(PannableCardView *)view {
    [view removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedRight:cardView:)]) {
        [self.delegate cardViewSwipedRight:self cardView:view];
    }
    
    [self addCardView];
}

- (void)cardSwipedLeft:(PannableCardView *)view {
    [view removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedLeft:cardView:)]) {
        [self.delegate cardViewSwipedLeft:self cardView:view];
    }
    
    [self addCardView];
}

#pragma mark - Debug Methods

- (void)debugPrintNumberOfViewsOnStack {
    int numberOfCards = 0;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PannableCardView class]]) {
            numberOfCards++;
        }
    }
    
    NSLog(@"Number of cards %i", numberOfCards);
}

@end

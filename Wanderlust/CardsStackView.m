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

#pragma mark - PannableCardViewDelegate Methods

- (void)cardSwipedRight:(PannableCardView *)view {
    [view removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedRight:cardView:)]) {
        [self.delegate cardViewSwipedRight:self cardView:view];
    }
    
    [self addCardView];
    [self findViewOnTop];
}

- (void)cardSwipedLeft:(PannableCardView *)view {
    [view removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedLeft:cardView:)]) {
        [self.delegate cardViewSwipedLeft:self cardView:view];
    }
    
    [self addCardView];
    [self findViewOnTop];
}

#pragma mark - Helper Methods

- (void)addCardView {
    if ([self.dataSource respondsToSelector:@selector(nextCardViewToShow:)]) {
        PannableCardView *newCardView = [self.dataSource nextCardViewToShow:self];
        
        // Add new views to the bottom of the stack, not the top
        [self insertSubview:newCardView atIndex:0];
    }
    
    [self debugPrintNumberOfViewsOnStack];
}

- (void)findViewOnTop {
    PannableCardView *topCardView = [self.subviews lastObject];
    
    if ([self.delegate respondsToSelector:@selector(cardViewDidAppearOnTopOfStack:cardView:)]) {
        [self.delegate cardViewDidAppearOnTopOfStack:self cardView:topCardView];
    }
}

- (void)reload {

    NSInteger numberOfCardsOnStack;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfCardsOnStack:)]) {
        numberOfCardsOnStack = [self.dataSource numberOfCardsOnStack:self];
    } else {
        numberOfCardsOnStack = 3;
    }
    
    for (int i = 0; i < numberOfCardsOnStack; i++) {
        [self addCardView];
    }
    
    [self findViewOnTop];
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

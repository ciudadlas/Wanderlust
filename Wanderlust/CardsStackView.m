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
            if ([self.dataSource respondsToSelector:@selector(nextCardViewToShow:)]) {
                PannableCardView *newCardView = [self.dataSource nextCardViewToShow:self];
                [self addSubview:newCardView];
            }
        }
    }
}

#pragma mark - PannableCardViewDelegate Methods

- (void)cardSwipedRight:(PannableCardView *)view {
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedRight:cardView:)]) {
        [self.delegate cardViewSwipedRight:self cardView:view];
    }
    [view removeFromSuperview];
}

- (void)cardSwipedLeft:(PannableCardView *)view {
    if ([self.delegate respondsToSelector:@selector(cardViewSwipedLeft:cardView:)]) {
        [self.delegate cardViewSwipedLeft:self cardView:view];
    }
    [view removeFromSuperview];
}


@end

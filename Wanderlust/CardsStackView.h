//
//  CardsStackView.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PannableCardView.h"
@class CardsStackView;

@protocol CardsStackViewDataSource <NSObject>

@required

/**
 * Delegate method for specifying the number of cards the stack has
 */
- (NSInteger)numberOfCardsOnStack:(CardsStackView *)stackView;

/**
 * Delegate method for returning the next card view to show after a swipe
 */
- (PannableCardView *)nextCardViewToShow:(CardsStackView *)stackView;

@end

@protocol CardsStackViewDelegate <NSObject>

@optional

/**
 * Delegate method that is called when a card view is swiped left
 */
- (void)stackView:(CardsStackView *)stackView didSwipeCardViewLeft:(PannableCardView *)cardView;

/**
 * Delegate method that is called when a card view is swiped right
 */
- (void)stackView:(CardsStackView *)stackView didSwipeCardViewRight:(PannableCardView *)cardView;

/**
 * Delegate method that is called when a card view is tapped once
 */
- (void)stackView:(CardsStackView *)stackView didTapOnCardView:(PannableCardView *)cardView;

/**
 * Delegate method that is called when a card view is appears at the top of the stack
 */
- (void)stackView:(CardsStackView *)stackView cardViewDidAppearOnTopOfStack:(PannableCardView *)cardView;


@end

@interface CardsStackView : UIView <PannableCardViewDelegate>

@property (weak, nonatomic) id <CardsStackViewDataSource> dataSource;
@property (weak, nonatomic) id <CardsStackViewDelegate> delegate;

- (void)reload;

@end

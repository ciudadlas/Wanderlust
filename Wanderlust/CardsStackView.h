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
- (void)cardViewSwipedLeft:(CardsStackView *)stackView cardView:(PannableCardView *)cardView;

/**
 * Delegate method that is called when a card view is swiped right
 */
- (void)cardViewSwipedRight:(CardsStackView *)stackView cardView:(PannableCardView *)cardView;

/**
 * Delegate method that is called when a card view is tapped once
 */
- (void)stackView:(CardsStackView *)stackView didTapCardView:(PannableCardView *)cardView;


/**
 * Delegate method that is called when a card view is appears at the top of the stack
 */
- (void)cardViewDidAppearOnTopOfStack:(CardsStackView *)stackView cardView:(PannableCardView *)cardView;


@end

@interface CardsStackView : UIView <PannableCardViewDelegate>

@property (weak, nonatomic) id <CardsStackViewDataSource> dataSource;
@property (weak, nonatomic) id <CardsStackViewDelegate> delegate;

- (void)reload;

@end

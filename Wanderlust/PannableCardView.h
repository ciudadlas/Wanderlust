//
//  PannableCardView.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PannableCardView;

@protocol PannableCardViewDelegate <NSObject>

@optional

/**
 * Delegate method that is called after a card view is swiped left
 */
- (void)cardSwipedLeft:(PannableCardView *)view;

/**
 * Delegate method that is called after a card view is swiped right
 */
- (void)cardSwipedRight:(PannableCardView *)view;

@end

@interface PannableCardView : UIView

@property (weak, nonatomic) id <PannableCardViewDelegate> delegate;

@end

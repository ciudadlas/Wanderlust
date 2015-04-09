//
//  CardView.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Macros.h"
#import "PannableCardView.h"

static CGFloat const ActionMargin = 120;          // Distance from center of the view, at which the card should swipe away.

static CGFloat const ScaleStrength = 4;           // How quickly the card shrinks in size. Higher value means slower down-scaling
static CGFloat const ScaleMax = 0.93;             // Upper limit for how much the card should scale. Higher value means it down-scales less

static CGFloat const RotationStrength = 320;      // Strength of rotation. Higher value means slower rotation
static CGFloat const RotationMax = 1;             // The maximum rotation allowed in radians.  Higher value means card can keep rotating longer
static CGFloat const RotationAngle = M_PI/8;      // Higher value means stronger rotation angle

@interface PannableCardView()

@property (strong, nonatomic) UIGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) CGFloat xFromCenter;
@property (nonatomic) CGFloat yFromCenter;

@end

@implementation PannableCardView

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupGestureRecognizers];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = self.bounds;
}

#pragma mark - View Setup Methods

- (void)setupView {
    self.layer.cornerRadius = 15;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.borderColor = HEXCOLOR(0xE4E3DA).CGColor;
    self.layer.borderWidth = 5;
    self.layer.allowsEdgeAntialiasing = YES;
    
    self.backgroundColor = HEXCOLOR(0xF4D338);
    
    self.clipsToBounds = YES;
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
}

- (void)setupGestureRecognizers {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)resetView {
    self.center = self.originalCenter;
    self.transform = CGAffineTransformIdentity;
}

#pragma mark - Gesture Recognizer Actions

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // Extract the coordinate data from the swipe movement. (i.e. How much did the user move?)
    self.xFromCenter = [gestureRecognizer translationInView:self].x; // This value is positive for right pan, negative for left pan
    self.yFromCenter = [gestureRecognizer translationInView:self].y; // This value is positive for upwards pan, negative for downwards pan
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self handleSwipeStart:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleSwipeChange:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handleSwipeEnd:gestureRecognizer];
            break;
            
        default:
            break;
    }
}

- (void)handleSwipeStart:(UIPanGestureRecognizer *)gectureRecognizer {
    self.originalCenter = self.center;
}

- (void)handleSwipeChange:(UIPanGestureRecognizer *)gectureRecognizer {
    
    // Update center
    self.center = CGPointMake(self.originalCenter.x + self.xFromCenter, self.originalCenter.y + self.yFromCenter);
    
    // Update scale and transformation
    CGFloat rotationStrength = MIN(self.xFromCenter / RotationStrength, RotationMax);
    CGFloat rotationAngel = RotationAngle * rotationStrength;
    CGFloat scale = MAX(1 - fabsf(rotationStrength) / ScaleStrength, ScaleMax);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
    
    self.transform = scaleTransform;
}

- (void)handleSwipeEnd:(UIPanGestureRecognizer *)gectureRecognizer {
    
    if (self.xFromCenter > ActionMargin) {
        [self processRightSwipe];
    } else if (self.xFromCenter < -ActionMargin) {
        [self processLeftSwipe];
    } else {
        [self snapBackToOriginalFrame];
    }
}

- (void)snapBackToOriginalFrame {
    [UIView animateWithDuration:0.15 delay:0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
        [self resetView];
    } completion:^(BOOL finished) {
        //
    }];
}

#pragma mark - Swipe Handling Methods

- (void)processRightSwipe {

    CGPoint finishPoint = CGPointMake(500, 2*self.yFromCenter + self.originalCenter.y);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        // Call delegate
        if ([self.delegate respondsToSelector:@selector(cardSwipedRight:)]) {
            [self.delegate cardSwipedRight:self];
        }
        
        [self resetView];

    }];
}

- (void)processLeftSwipe {

    CGPoint finishPoint = CGPointMake(-500, 2*self.yFromCenter + self.originalCenter.y);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = finishPoint;
    } completion:^(BOOL finished) {

        // Call delegate
        if ([self.delegate respondsToSelector:@selector(cardSwipedLeft:)]) {
            [self.delegate cardSwipedLeft:self];
        }
        
        [self resetView];
    }];
}

@end

//
//  ExplorePlacesAnimator.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "ExplorePlacesCustomAnimator.h"
#import "ExplorePlacesViewController.h"
#import "FavoritePlacesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ExplorePlacesCustomAnimator ()

@property (weak, nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ExplorePlacesCustomAnimator

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    UIView *containerView = transitionContext.containerView;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Add the view of toViewController to the animation container view
    [containerView addSubview:toViewController.view];
    
    // Starting path
    UIBezierPath *pathInitial = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
    
    // End path
    CGPoint farAwayPoint = CGPointMake(0, - 2 * CGRectGetHeight(toViewController.view.bounds));
    CGFloat radius = sqrt((farAwayPoint.x*farAwayPoint.x) + (farAwayPoint.y*farAwayPoint.y));
    UIBezierPath *pathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, 0, 0), -radius, -radius)];

    // Set up mask layer to animate
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.path = pathFinal.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    // Set up animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(pathInitial.CGPath);
    animation.toValue = (__bridge id)(pathFinal.CGPath);
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    
    // Apply animation to mask layer
    [toViewController.view.layer.mask addAnimation:animation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:YES];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end

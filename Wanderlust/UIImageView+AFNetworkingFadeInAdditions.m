//
//  UIImageView+AFNetworkingFadeInAdditions.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "UIImageView+AFNetworkingFadeInAdditions.h"

@implementation UIImageView (AFNetworkingFadeInAdditions)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage fadeInWithDuration:(CGFloat)duration
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak typeof (self) weakSelf = self;
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (!request) // image was cached
            [weakSelf setImage:image];
        else
            [UIView transitionWithView:weakSelf duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [weakSelf setImage:image];
            } completion:nil];
    } failure:nil];
}

// This provides a block that returns the image and if it was cached or not, so that the call maker can process the image as needed
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *image, BOOL cached))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (!request) // image was cached
        {
            completionBlock(image, YES);
        }
        else
        {
            completionBlock(image, NO);
        }
        
    } failure:nil];
}

@end

//
//  UIImageView+AFNetworkingFadeInAdditions.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

// Taken from: https://gist.github.com/manmal/5038010

@interface UIImageView (AFNetworkingFadeInAdditions)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage fadeInWithDuration:(CGFloat)duration;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *image, BOOL cached))completionBlock;

@end
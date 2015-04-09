//
//  Place+Read.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/9/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place+Read.h"

static NSString *const ImageDownloadPath = @"https://travelpoker-production.s3.amazonaws.com/uploads/card/image/%@/%@";

@implementation Place (Read)

- (NSURL *)imageDownloadURL {
    NSString *imagePath = [NSString stringWithFormat:ImageDownloadPath, self.placeID, self.imagePath];
    return [NSURL URLWithString:imagePath];
}

@end

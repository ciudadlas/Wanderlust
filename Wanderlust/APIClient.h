//
//  APIClient.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^APIResult)(NSError *error, NSDictionary *response);

@interface APIClient : AFHTTPRequestOperationManager

+ (APIClient *)sharedInstance;
- (void)getLocationsWithCompletionBlock:(APIResult)completionBlock;

@end

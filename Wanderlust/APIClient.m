//
//  APIClient.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "APIClient.h"
#import "Macros.h"
#import "Place+Create.h"

static NSString *const GetLocationsURLPath = @"https://gist.githubusercontent.com/shreyansb/678d35d7efaa4cbfb81d/raw/7e04c3d88f6c06d7a794ae570f39a96107b18457/gistfile1.json";

@implementation APIClient

#pragma mark - Initialization

+ (APIClient *)sharedInstance {
    static APIClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    
    return sharedClient;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

#pragma mark - Fetch Data Methods

- (void)getPlacesWithCompletionBlock:(APIResult)completionBlock {
    
    // Make the API call
    [self GET:GetLocationsURLPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"Request URL: %@", operation.request.URL);
        
        // This context is causing crash
        NSManagedObjectContext* context = [[NSManagedObjectContext alloc]
                                           initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        NSMutableArray *places = [NSMutableArray new];
        
        // Parse the API call results
        for (NSDictionary *singleLocation in responseObject) {
            Place *newPlace = [Place placeWithInfo:singleLocation inManagedObjectContext:context];
            [places addObject:newPlace];
        }
        
        [self propagateResponse:@{@"places": places} error:nil withBlock:completionBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DLog(@"Error while getting locations: %@", [error localizedDescription]);
        [self propagateResponse:nil error:error withBlock:completionBlock];
    }];
}

#pragma mark - Data Propogation Helper

- (void)propagateResponse:(NSDictionary *)userInfo error:(NSError *)error withBlock:(APIResult)block {
    
    if (block != NULL) {
        block(error, userInfo);
    }
}

@end

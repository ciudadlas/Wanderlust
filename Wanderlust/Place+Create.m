//
//  Place+Create.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place+Create.h"
#import "Macros.h"

@implementation Place (Create)

+ (Place *)placeWithInfo:(NSDictionary *)infoDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Place *item = nil;
    
    NSNumber *placeID = [NSNumber numberWithInteger:[[infoDictionary objectForKey:@"id"] integerValue]];
    NSString *title = [infoDictionary objectForKey:@"title"];
    NSString *imagePath = [infoDictionary objectForKey:@"image"];
    NSString *address = [infoDictionary objectForKey:@"location"];
    NSNumber *latitude = [NSNumber numberWithFloat:[[infoDictionary objectForKey:@"latitude"] floatValue]];
    NSNumber *longitude = [NSNumber numberWithFloat:[[infoDictionary objectForKey:@"longitude"] floatValue]];
    
    // Here check if id already exists in Core Data before saving
    
    if (placeID && title && imagePath && address && latitude && longitude) {
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        item.placeID = placeID;
        item.title = title;
        item.address = address;
        item.latitude = latitude;
        item.longitude = longitude;
        item.imagePath = imagePath;
    }

    if (item) {
        NSError *error = nil;
        [context save:&error];
        if (error) {
            DLog(@"Error saving the context: %@", [error description]);
        }
    }
    
    return item;    
}

+ (NSArray *)placesWithDataArray:(NSArray *)placesArray inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSMutableArray *places = [NSMutableArray new];
    
    for (NSDictionary *singleLocation in placesArray) {
        Place *newPlace = [Place placeWithInfo:singleLocation inManagedObjectContext:context];
        [places addObject:newPlace];
    }
    
    return [NSArray arrayWithArray:places];
}

@end

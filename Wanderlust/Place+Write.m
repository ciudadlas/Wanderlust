//
//  Place+Create.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place+Write.h"
#import "Macros.h"

@implementation Place (Write)

#pragma mark - Class Methods

+ (Place *)placeWithInfo:(NSDictionary *)infoDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Place *item = nil;
    
    NSNumber *placeID = [NSNumber numberWithInteger:[[infoDictionary objectForKey:@"id"] integerValue]];
    NSString *title = [infoDictionary objectForKey:@"title"];
    NSString *imagePath = [infoDictionary objectForKey:@"image"];
    NSString *address = [infoDictionary objectForKey:@"location"];
    NSNumber *latitude = [NSNumber numberWithFloat:[[infoDictionary objectForKey:@"latitude"] floatValue]];
    NSNumber *longitude = [NSNumber numberWithFloat:[[infoDictionary objectForKey:@"longitude"] floatValue]];
    
    // Here check if a place with this ID already is stored, to avoid duplicate items in the store
    item = [self placeWithID:placeID inManagedObjectContext:context];
    
    // If not, create a new object and set the id on it
    if (!item && placeID) {
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        item.placeID = placeID;
    }
    
    // Require all the fields to be valid for creating a new object
    if (title && imagePath && address && latitude && longitude) {
        item.title = title;
        item.address = address;
        item.latitude = latitude;
        item.longitude = longitude;
        item.imagePath = imagePath;
    }
    
    // If have an item, save it
    if (item) {
        NSError *error = nil;
        [context save:&error];
        if (error) {
            DLog(@"Error saving the context: %@", [error description]);
        }
    }
    
    return item;    
}

+ (NSMutableArray *)placesWithDataArray:(NSArray *)placesArray inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSMutableArray *places = [NSMutableArray new];
    
    for (NSDictionary *singleLocation in placesArray) {
        Place *newPlace = [Place placeWithInfo:singleLocation inManagedObjectContext:context];
        [places addObject:newPlace];
    }
    
    return places;
}

+ (Place *)placeWithID:(NSNumber *)placeId inManagedObjectContext:(NSManagedObjectContext *)context {
    Place *returnValue = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Place" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"placeID == %@", placeId];
    
    [fetchRequest setSortDescriptors:nil];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if(!error) {
        if (results.count != 0) {
            returnValue =  [results firstObject];
        }
    } else {
        DLog(@"Error saving the context: %@", [error localizedDescription]);
    }
    
    return returnValue;
}

#pragma mark - Instance Methods

- (BOOL)setFavorited:(BOOL)favorited inManagedObjectContext:(NSManagedObjectContext *)context {
    self.isFavorited = [NSNumber numberWithBool:favorited];
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        DLog(@"Error saving the context: %@", [error localizedDescription]);
        return NO;
    } else {
        DLog(@"Succesfully favorited object");
        return YES;
    }
}

- (BOOL)deleteInManagedObjectContext:(NSManagedObjectContext *)context {
    [context deleteObject:self];
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        DLog(@"Error saving the context: %@", [error localizedDescription]);
        return NO;
    } else {
        DLog(@"Succesfully deleted object");
        return YES;
    }

}

@end

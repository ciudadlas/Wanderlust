//
//  Place+Create.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place.h"

@interface Place (Write)

+ (NSMutableArray *)placesWithDataArray:(NSArray *)placesArray inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)setFavorited:(BOOL)favorited inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)deleteInManagedObjectContext:(NSManagedObjectContext *)context;

@end

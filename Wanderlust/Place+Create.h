//
//  Place+Create.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+ (NSArray *)placesWithDataArray:(NSArray *)placesArray inManagedObjectContext:(NSManagedObjectContext *)context;

@end

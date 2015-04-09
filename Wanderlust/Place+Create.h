//
//  Place+Create.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/8/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+ (Place *)placeWithInfo:(NSDictionary *)infoDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

@end

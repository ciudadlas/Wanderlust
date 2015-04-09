//
//  Place.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/9/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * placeID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isFavorited;

@end

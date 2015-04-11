//
//  FavoritePlaceTableViewCell.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritePlaceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *placeImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeTitle;
@property (nonatomic, weak) IBOutlet UILabel *placeAddress;

@end

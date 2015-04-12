//
//  FavoritePlaceTableViewCell.h
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritePlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;

@end

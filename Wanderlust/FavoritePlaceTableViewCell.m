//
//  FavoritePlaceTableViewCell.m
//  Wanderlust
//
//  Created by Serdar Karatekin on 4/11/15.
//  Copyright (c) 2015 Serdar Karatekin. All rights reserved.
//

#import "FavoritePlaceTableViewCell.h"

@implementation FavoritePlaceTableViewCell

- (void)awakeFromNib {
    self.placeImageView.layer.cornerRadius = round(self.placeImageView.bounds.size.width / 2);
    self.placeImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

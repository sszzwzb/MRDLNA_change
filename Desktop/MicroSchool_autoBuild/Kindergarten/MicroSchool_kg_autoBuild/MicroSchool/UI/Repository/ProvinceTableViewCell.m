//
//  ProvinceTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 15-2-5.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "ProvinceTableViewCell.h"

@implementation ProvinceTableViewCell
@synthesize titleLabel,arrowImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory.png"];
    }
}

@end

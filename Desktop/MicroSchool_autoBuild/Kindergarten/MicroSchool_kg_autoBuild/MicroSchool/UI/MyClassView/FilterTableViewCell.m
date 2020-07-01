//
//  FilterTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-9-18.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell
@synthesize selectedImgV,titleLabel,isSelected;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MyClassListTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-9-17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyClassListTableViewCell.h"

@implementation MyClassListTableViewCell
@synthesize headImgView,titleLabel,introductionLabel,ParentNameLabel;

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

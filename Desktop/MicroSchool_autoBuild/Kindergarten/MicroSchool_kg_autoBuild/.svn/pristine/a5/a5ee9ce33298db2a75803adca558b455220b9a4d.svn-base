//
//  SubscribeViewNewsListTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/23.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SubscribeViewNewsListTableViewCell.h"

@implementation SubscribeViewNewsListTableViewCell

@synthesize detailLabel,detailImgV,viewNumImgV,viewNumLabel,dateLineLabel,titleLabel;

- (void)awakeFromNib {
    // Initialization code
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 72.0, [UIScreen mainScreen].bounds.size.width - 30.0, 38.0)];
    detailLabel.font = [UIFont systemFontOfSize:15.0];
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:detailLabel];
    
    viewNumImgV = [[UIImageView alloc]initWithFrame:CGRectMake(248, 49.0, 20.0, 20.0)];
    viewNumImgV.image = [UIImage imageNamed:@"icon_liulan.png"];
    [self.contentView addSubview:viewNumImgV];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

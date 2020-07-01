//
//  CertificationTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/23.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "CertificationTableViewCell.h"

@implementation CertificationTableViewCell
@synthesize detailLabel,titleLabel,headImgV;

- (void)awakeFromNib {
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, [UIScreen mainScreen].bounds.size.width-90.0, 60.0)];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:detailLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
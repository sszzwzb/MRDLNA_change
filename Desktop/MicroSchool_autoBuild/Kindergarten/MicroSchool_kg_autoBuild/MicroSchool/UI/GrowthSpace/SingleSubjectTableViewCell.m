//
//  SingleSubjectTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "SingleSubjectTableViewCell.h"

@implementation SingleSubjectTableViewCell
@synthesize scoreNameLabel,dateLineLabel,classRankLabel,schoolRankLabel,classScoreRankImgV,schoolScoreRankImgV,totalLabel,classAverage,schoolAverage,classHighest,schoolHighest;

- (void)awakeFromNib {
    // Initialization code
    classScoreRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(107.0, 69.0, 10.0, 10.0)];
    [self.contentView addSubview:classScoreRankImgV];
    
    schoolScoreRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(272.0, 69.0, 10.0, 10.0)];
    [self.contentView addSubview:schoolScoreRankImgV];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

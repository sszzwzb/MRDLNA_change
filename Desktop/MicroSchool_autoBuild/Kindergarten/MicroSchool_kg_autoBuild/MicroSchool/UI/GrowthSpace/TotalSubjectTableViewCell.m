//
//  TotalSubjectTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "TotalSubjectTableViewCell.h"

@implementation TotalSubjectTableViewCell
@synthesize scoreNameLabel,dateLineLabel,classRankLabel,schoolRankLabel,classScoreRankImgV,schoolScoreRankImgV,totalLabel,classRankTitleLab,schoolRankTitleLab;

- (void)awakeFromNib {
    // Initialization code
    classScoreRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(91.0, 60.0, 10.0, 10.0)];
    [self.contentView addSubview:classScoreRankImgV];
    
    schoolScoreRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(216.0, 60.0, 10.0, 10.0)];
    [self.contentView addSubview:schoolScoreRankImgV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

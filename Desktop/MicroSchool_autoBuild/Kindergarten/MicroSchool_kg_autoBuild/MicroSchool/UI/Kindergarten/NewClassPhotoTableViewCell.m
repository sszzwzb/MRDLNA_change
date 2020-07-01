//
//  NewClassPhotoTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "NewClassPhotoTableViewCell.h"

@implementation NewClassPhotoTableViewCell
@synthesize dayLabel,monthLabel,imgV,titleLabel,imgNumLabel,clickChangeColorBtn,index,type,delegte,baseView;


- (void)awakeFromNib {
    // Initialization code
    
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"seletStyle.png"] forState:UIControlStateHighlighted];
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"dateBg.png"] forState:UIControlStateNormal];
    
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 5.0;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = imgV.bounds;
    maskLayer.path = maskPath.CGPath;
    imgV.layer.mask = maskLayer;
    
//    _videoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90.0, 90.0)];
//    UIImageView *videoMark = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 72.0, 13.0, 13.0)];
//    videoMark.image = [UIImage imageNamed:@"videoMark.png"];
//    [_videoImgV addSubview:videoMark];
//    [baseView addSubview:_videoImgV];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoPicDetail:(id)sender {
    
    [delegte gotoFootmarkPicDetail:index type:type];
}

@end

//
//  FootmarkPicTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "FootmarkPicTableViewCell.h"

@implementation FootmarkPicTableViewCell
@synthesize dayLabel,monthLabel,imgV,titleLabel,imgNumLabel,tagImgV,clickChangeColorBtn,index,type,delegte,baseView;


- (void)awakeFromNib {
    // Initialization code
    
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 5.0;
    
//    _videoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60.0, 60.0)];
//    UIImageView *videoMark = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 42.0, 13.0, 13.0)];
//    videoMark.image = [UIImage imageNamed:@"videoMark.png"];
//    [_videoImgV addSubview:videoMark];
//    [baseView addSubview:_videoImgV];
    
    
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"seletStyle.png"] forState:UIControlStateHighlighted];
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"dateBg.png"] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)gotoPicDetail:(id)sender {
    
    [delegte gotoFootmarkPicDetail:index type:type];
}
@end

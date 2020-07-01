//
//  HomeworkHomeTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HomeworkHomeTableViewCell.h"

@implementation HomeworkHomeTableViewCell
@synthesize dayLabel,monthLabel,homeNameLabel,publishNameLabel,publishNameImgV,commentNumLabel,commentNumImgV,clickChangeColorBtn,index,type,delegte,label_viewnum,imgView_viewnum,icon_finishImgV,finishNumLabel,totalTimeLabel,totalTimeView;

- (void)awakeFromNib {
    // Initialization code
    
#if 0
    // 评论次数
    commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-20-10, 38.0, 13, 21.0)];
    commentNumLabel.font = [UIFont systemFontOfSize:13.0];
    commentNumLabel.textColor = [UIColor lightGrayColor];
    //commentNumLabel.backgroundColor = [UIColor yellowColor];
    commentNumLabel.textAlignment = NSTextAlignmentRight;
    //评论次数图片
    commentNumImgV = [[UIImageView alloc] initWithFrame:CGRectMake(commentNumLabel.frame.origin.x-10-14.0, 38.0+5, 14.0, 14.0)];
    
    // 浏览人数
    label_viewnum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                              commentNumImgV.frame.origin.x - 20-21.0,
                                                              commentNumImgV.frame.origin.y,
                                                              13,
                                                              21)];
    label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
    label_viewnum.font = [UIFont systemFontOfSize:13.0f];
    label_viewnum.textColor = [UIColor lightGrayColor];
    
    // 浏览人数图片
    imgView_viewnum =[[UIImageView alloc]initWithFrame:CGRectMake(label_viewnum.frame.origin.x - 20-21.0,label_viewnum.frame.origin.y,14.0,14.0)];
    imgView_viewnum.image = [UIImage imageNamed:@"icon_viewNum.png"];
    

    //发布人
    //publishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentNumImgV.frame.origin.x - 20-21.0, 38.0, 10, 21.0)];
    publishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView_viewnum.frame.origin.x - 20-21.0, 38.0, 10, 21.0)];
    publishNameLabel.font = [UIFont systemFontOfSize:13.0];
    publishNameLabel.textColor = [UIColor lightGrayColor];
    publishNameLabel.textAlignment = NSTextAlignmentRight;
    //publishNameLabel.backgroundColor = [UIColor yellowColor];
    //发布人图片
    publishNameImgV = [[UIImageView alloc] initWithFrame:CGRectMake(publishNameLabel.frame.origin.x-10-14.0, 38.0+5, 14.0, 14.0)];
#endif
    
    
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"seletStyle.png"] forState:UIControlStateHighlighted];
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"dateBg.png"] forState:UIControlStateNormal];
#if 0
    [self.contentView addSubview:commentNumLabel];
    [self.contentView addSubview:commentNumImgV];
    [self.contentView addSubview:label_viewnum];
    [self.contentView addSubview:imgView_viewnum];
#endif
    
    //发布人图标
    publishNameImgV = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 38.0+3.0, 14.0, 14.0)];
    //发布人
    publishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(publishNameImgV.frame.origin.x+14.0+5, 38.0, 10, 21.0)];
    publishNameLabel.font = [UIFont systemFontOfSize:13.0];
    publishNameLabel.textColor = [UIColor lightGrayColor];
    publishNameLabel.textAlignment = NSTextAlignmentRight;
    //publishNameLabel.backgroundColor = [UIColor yellowColor];
    
    //完成作业图标
     icon_finishImgV = [[UIImageView alloc] initWithFrame:CGRectMake(publishNameLabel.frame.origin.x+publishNameLabel.frame.size.width+10, 38.0+3.0, 14.0, 14.0)];
    //完成作业人数
    finishNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon_finishImgV.frame.origin.x+14.0+5, 38.0, 40.0, 21.0)];
    finishNumLabel.font = [UIFont systemFontOfSize:13.0];
    finishNumLabel.textColor = [UIColor lightGrayColor];
    finishNumLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:publishNameImgV];
    [self.contentView addSubview:publishNameLabel];
    [self.contentView addSubview:icon_finishImgV];
    [self.contentView addSubview:finishNumLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickChangeColor:(id)sender {
    
    [delegte gotoHomeDetail:index type:type];
}
@end

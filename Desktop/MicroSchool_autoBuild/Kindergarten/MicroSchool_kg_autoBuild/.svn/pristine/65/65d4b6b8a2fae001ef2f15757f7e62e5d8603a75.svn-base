//
//  MicroSchoolMainMenuTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MicroSchoolMainMenuTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation MicroSchoolMainMenuTableViewCell

@synthesize name;
@synthesize comment;

@synthesize imgView_icon;
@synthesize videoNewImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // icon
        imgView_icon =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                   25,
                                                                   (60 - 40)/2,
                                                                   40,
                                                                   40)];
        imgView_icon.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_icon];
        
        // 标题
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                imgView_icon.frame.origin.x + imgView_icon.frame.size.width + 25,
                                                                imgView_icon.frame.origin.y+2,
                                                                WIDTH - 75 - 35 - 30,
                                                                15)];
        
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:14.0f];
        label_name.numberOfLines = 0;
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        //label_title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_name];
        
        // 介绍
        label_comment = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_name.frame.origin.x,
                                                               label_name.frame.origin.y + label_name.frame.size.height+2,
                                                               WIDTH - 75 - 35 - 20,
                                                               20)];
        
        //设置title自适应对齐
        label_comment.lineBreakMode = NSLineBreakByWordWrapping;
        label_comment.font = [UIFont systemFontOfSize:11.0f];
        label_comment.textColor = [UIColor grayColor];
        label_comment.backgroundColor = [UIColor clearColor];
        label_comment.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_comment];
        
        videoNewImg = [[UIImageView alloc] init];
        videoNewImg.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 32.0-20.0, (60-20)/2, 32, 20);
        [self.contentView addSubview:videoNewImg];
        
        // 每条cell最下方的线
//        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,58,280,1)];
//        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
//        [self.contentView addSubview:imgView_line1];
        
//        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(20, 59, 280, 1)];
//        lineV.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.7];
//        [self.contentView addSubview:lineV];
        
        UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(20, 59, WIDTH-40, 1)];
        imgView_line.image=[UIImage imageNamed:@"lineSystem.png"];
        [self.contentView addSubview:imgView_line];
       
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}

- (void)setComment:(NSString *)n {
    if(![n isEqualToString:comment]) {
        comment = [n copy];
        label_comment.text = comment;
    }
}

@end

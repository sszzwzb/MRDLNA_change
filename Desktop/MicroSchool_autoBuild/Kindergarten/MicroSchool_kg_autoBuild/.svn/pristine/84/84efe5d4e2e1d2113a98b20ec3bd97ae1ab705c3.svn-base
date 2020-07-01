//
//  SetPersonalInfoTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-3.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetPersonalInfoTableViewCell.h"

// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation SetPersonalInfoTableViewCell

@synthesize name,userName,realName,userTitleName;
@synthesize imgView_thumb;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // name
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  15,
                                                                  (75-15)/2,
                                                                  100,
                                                                  15)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:17.0f];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.backgroundColor = [UIColor clearColor];
        label_name.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_name];
        
        // realNameLab
        realNameLab = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               98,
                                                                (90-15)/3,
                                                                200,
                                                                15)];//add by kate 2014.12.03
        //设置title自适应对齐
        realNameLab.lineBreakMode = NSLineBreakByWordWrapping;
        realNameLab.font = [UIFont systemFontOfSize:14.0f];
        realNameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        realNameLab.textAlignment = NSTextAlignmentLeft;
        realNameLab.backgroundColor = [UIColor clearColor];
        realNameLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:realNameLab];
        
        // userNameTitleLab
        userNameTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     98,
                                                                     (90-15)/3+25,
                                                                     50,
                                                                     15)];
        //设置title自适应对齐
        userNameTitleLab.lineBreakMode = NSLineBreakByWordWrapping;
        userNameTitleLab.font = [UIFont systemFontOfSize:14.0f];
        userNameTitleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        userNameTitleLab.textAlignment = NSTextAlignmentLeft;
        userNameTitleLab.backgroundColor = [UIColor clearColor];
        userNameTitleLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:userNameTitleLab];
        
        // userNameLab
        userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               userNameTitleLab.frame.origin.x+userNameTitleLab.frame.size.width,
                                                               (90-15)/3+25,
                                                               100,
                                                               15)];
        //设置title自适应对齐
        userNameLab.lineBreakMode = NSLineBreakByWordWrapping;
        userNameLab.font = [UIFont systemFontOfSize:14.0f];
        userNameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        userNameLab.textAlignment = NSTextAlignmentLeft;
        userNameLab.backgroundColor = [UIColor clearColor];
        userNameLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:userNameLab];
        
        // 缩略图
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-80,12,50,50)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 50/2;
        [self.contentView addSubview:imgView_thumb];

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

- (void)setUserName:(NSString *)n {
    if(![n isEqualToString:userName]) {
        userName = [n copy];
        userNameLab.text = userName;
    }
}

- (void)setRealName:(NSString *)n {
    if(![n isEqualToString:realName]) {
        realName = [n copy];
        realNameLab.text = realName;
    }
}

- (void)setUserTitleName:(NSString *)n {
    if(![n isEqualToString:userTitleName]) {
        userTitleName = [n copy];
        userNameTitleLab.text = userTitleName;
    }
}

@end

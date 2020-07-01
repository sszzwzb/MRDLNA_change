//
//  HomeworkDetailCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-6.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeworkDetailCell.h"

@implementation HomeworkDetailCell


@synthesize username;
@synthesize dateline;
@synthesize message;
@synthesize pid;
@synthesize uid;

@synthesize label_message;
@synthesize label_dateline;
@synthesize label_username;
@synthesize imgView_thumb;
@synthesize imgView_line;
@synthesize imgView_leftLine;

@synthesize imgView_leftlittilPoint;
@synthesize imgView_leftlittilMiddlePoint;

@synthesize label_leftNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 缩略图
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                    40,
                                                                    10,
                                                                    40,
                                                                    40)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 20.0f;
        [self.contentView addSubview:imgView_thumb];
        
        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 3,
                                                                   imgView_thumb.frame.origin.y + 3,
                                                                   200,
                                                                   15)];
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:14.0f];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor blackColor];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];
        
        // 回复图片
        UIImageView *imgView_reply =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                 280,
                                                                                 label_username.frame.origin.y + 5,
                                                                                 15,
                                                                                 15)];
        imgView_reply.image=[UIImage imageNamed:@"icon_reply.png"];
        imgView_reply.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_reply];
        
        // 日期
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   label_username.frame.origin.x,
                                                                   label_username.frame.origin.y + label_username.frame.size.height,
                                                                   120,
                                                                   20)];
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor grayColor];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];
        
        // 内容
        label_message = [[UILabel alloc] initWithFrame:CGRectZero];
        label_message.lineBreakMode = NSLineBreakByWordWrapping;
        label_message.font = [UIFont systemFontOfSize:12.0f];
        label_message.numberOfLines = 0;
        label_message.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        label_message.textColor = [UIColor blackColor];
        label_message.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label_message];
        
        imgView_line =[[UIImageView alloc]initWithFrame:CGRectZero];
        imgView_line.image=[UIImage imageNamed:@"hengxian.jpg"];
        [self.contentView addSubview:imgView_line];
        
        // 左边竖线
        imgView_leftLine =[[UIImageView alloc]
                           initWithFrame:CGRectMake(15,
                                                    0,
                                                    1,
                                                    25)] ;
        imgView_leftLine.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_leftLine];
        
        // 左边最上小圆点
        imgView_leftlittilPoint =[[UIImageView alloc]
                                  initWithFrame:CGRectMake(15,
                                                           15,
                                                           1,
                                                           25)] ;
        imgView_leftlittilPoint.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_leftlittilPoint];
        
        // 左边中间小圆点
        imgView_leftlittilMiddlePoint =[[UIImageView alloc]
                                        initWithFrame:CGRectMake(15,
                                                                 15,
                                                                 1,
                                                                 25)] ;
        imgView_leftlittilMiddlePoint.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_leftlittilMiddlePoint];
        
        // 楼层数
        label_leftNum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  label_leftNum.frame.origin.x + 3,
                                                                  label_leftNum.frame.origin.y + 3,
                                                                  15,
                                                                  15)];
        label_leftNum.lineBreakMode = NSLineBreakByWordWrapping;
        label_leftNum.font = [UIFont systemFontOfSize:8.0f];
        label_leftNum.numberOfLines = 0;
        label_leftNum.textColor = [UIColor whiteColor];
        label_leftNum.backgroundColor = [UIColor clearColor];
        label_leftNum.lineBreakMode = NSLineBreakByTruncatingTail;
        label_leftNum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label_leftNum];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setUsername:(NSString *)n {
    if(![n isEqualToString:username]) {
        username = [n copy];
        label_username.text = username;
    }
}

- (void)setDateline:(NSString *)n {
    if(![n isEqualToString:dateline]) {
        dateline = [n copy];
        label_dateline.text = dateline;
    }
}

- (void)setMessage:(NSString *)n {
    if(![n isEqualToString:message]) {
        message = [n copy];
        label_message.text = message;
    }
}

@end

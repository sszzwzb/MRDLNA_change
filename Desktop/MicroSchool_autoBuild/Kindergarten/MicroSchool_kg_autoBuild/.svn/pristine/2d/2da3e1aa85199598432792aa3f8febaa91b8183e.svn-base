//
//  HomeworkDetailTopCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-6.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeworkDetailTopCell.h"

@implementation HomeworkDetailTopCell

@synthesize subject;
@synthesize username;
@synthesize dateline;
@synthesize replynum;
@synthesize expectedtime;

@synthesize imgView_thumb;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 标题
        label_subject = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:17.0f];
        label_subject.numberOfLines = 2;
        label_subject.textColor = [UIColor blackColor];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        
        // 缩略图
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                    label_subject.frame.origin.x,
                                                                    label_subject.frame.origin.y + label_subject.frame.size.height +5,
                                                                    40,
                                                                    40)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 20.0f;
        [self.contentView addSubview:imgView_thumb];
        
        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 10,
                                                                   imgView_thumb.frame.origin.y,
                                                                   200,
                                                                   20)];
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:14.0f];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor blackColor];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];
        
        // 时间图片
        UIImageView *imgView_startTime =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                     150,
                                                                                     imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height  -15,
                                                                                     15,
                                                                                     15)];
        imgView_startTime.image=[UIImage imageNamed:@"icon_event_start_time.png"];
        imgView_startTime.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_startTime];
        
        // 日期
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_startTime.frame.origin.x + imgView_startTime.frame.size.width + 1,
                                                                   imgView_startTime.frame.origin.y-3,
                                                                   110,
                                                                   20)];
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor grayColor];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];
        
        // 回复次数图片
        UIImageView *imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                   label_dateline.frame.origin.x + label_dateline.frame.size.width,
                                                                                   imgView_startTime.frame.origin.y-2,
                                                                                   17,
                                                                                   17)];
        imgView_message.image=[UIImage imageNamed:@"icon_item_message_p.png"];
        imgView_message.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_message];
        
        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 1,
                                                                   label_dateline.frame.origin.y,
                                                                   15,
                                                                   20)];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:12.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor grayColor];
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_replynum];
        
        UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                10,
                                                                                imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height+ 5,
                                                                                300,
                                                                                1)];
        
        imgView_line.image=[UIImage imageNamed:@"hengxian.jpg"];
        [self.contentView addSubview:imgView_line];
        
        // 右上角红色三角
        UIImageView *imgView_bg_top =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                260,
                                                                                0,
                                                                                60,
                                                                                50)];
        
        imgView_bg_top.image=[UIImage imageNamed:@"bg_task_top.png"];
        [self.contentView addSubview:imgView_bg_top];
        
        // 右上角闹钟
        UIImageView *imgView_bg_clock =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                  290,
                                                                                  0,
                                                                                  30,
                                                                                  30)];
        
        imgView_bg_clock.image=[UIImage imageNamed:@"icon_clock.png"];
        [self.contentView addSubview:imgView_bg_clock];

        // 作业时间
        label_expectedtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   290,
                                                                   10,
                                                                   30,
                                                                   15)];
        label_expectedtime.lineBreakMode = NSLineBreakByWordWrapping;
        label_expectedtime.textAlignment = NSTextAlignmentCenter;
        label_expectedtime.font = [UIFont systemFontOfSize:9.0f];
        label_expectedtime.numberOfLines = 0;
//        label_expectedtime.text = @"0";
        label_expectedtime.textColor = [UIColor whiteColor];
        label_expectedtime.backgroundColor = [UIColor clearColor];
        label_expectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_expectedtime];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSubject:(NSString *)n {
    if(![n isEqualToString:subject]) {
        subject = [n copy];
        label_subject.text = subject;
    }
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

- (void)setReplynum:(NSString *)n {
    if(![n isEqualToString:replynum]) {
        replynum = [n copy];
        label_replynum.text = replynum;
    }
}

- (void)setExpectedtime:(NSString *)n {
    if(![n isEqualToString:expectedtime]) {
        expectedtime = [n copy];
        label_expectedtime.text = expectedtime;
    }
}

@end

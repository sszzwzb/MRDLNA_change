//
//  MyTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-27.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

@synthesize subject;
@synthesize dateline;
@synthesize viewnum;
@synthesize username;
@synthesize replynum;

@synthesize imgView_thumb;
@synthesize imgView_stick;
@synthesize imgView_digest;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 置顶
        imgView_stick =[[UIImageView alloc]initWithFrame:CGRectMake(270, 0, 21, 21)];
        imgView_stick.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_stick];
        
        // 加精
        imgView_digest =[[UIImageView alloc]initWithFrame:CGRectMake(295, 0, 21, 21)];
        imgView_digest.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_digest];

        // 内容
        label_subject = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 280, 20)];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:16.0f];
        label_subject.numberOfLines = 0;
        label_subject.textColor = [UIColor blackColor];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        
        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   10,
                                                                   40,
                                                                   100,
                                                                   20)];
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:12.0f];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor grayColor];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];
        
        // 时间图片
        UIImageView *imgView_startTime =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                     label_username.frame.origin.x + label_username.frame.size.width,
                                                                                     label_username.frame.origin.y+3,
                                                                                     15,
                                                                                     15)];
        imgView_startTime.image=[UIImage imageNamed:@"icon_event_start_time.png"];
        imgView_startTime.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_startTime];

        // 日期
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_startTime.frame.origin.x + imgView_startTime.frame.size.width + 1,
                                                                   label_username.frame.origin.y,
                                                                   140,
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
                                                                                   label_dateline.frame.origin.x + label_dateline.frame.size.width+6,
                                                                                   label_dateline.frame.origin.y + 1,
                                                                                   17,
                                                                                   17)];
        imgView_message.image=[UIImage imageNamed:@"icon_item_message_p.png"];
        [self.contentView addSubview:imgView_message];
        
        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 1,
                                                                   label_username.frame.origin.y,
                                                                   20,
                                                                   20)];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:11.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor grayColor];
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_replynum];
        
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

- (void)setDateline:(NSString *)n {
    if(![n isEqualToString:dateline]) {
        dateline = [n copy];
        label_dateline.text = dateline;
    }
}

- (void)setViewnum:(NSString *)n {
    if(![n isEqualToString:viewnum]) {
        viewnum = [n copy];
        label_viewnum.text = viewnum;
    }
}

- (void)setUsername:(NSString *)n {
    if(![n isEqualToString:username]) {
        username = [n copy];
        label_username.text = username;
    }
}

- (void)setReplynum:(NSString *)n {
    if(![n isEqualToString:replynum]) {
        replynum = [n copy];
        label_replynum.text = replynum;
    }
}

@end

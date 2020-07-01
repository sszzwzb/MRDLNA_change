//
//  DiscussTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-10.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "DiscussTableViewCell.h"


@implementation DiscussTableViewCell

@synthesize subject;
@synthesize dateline;
@synthesize viewnum;
@synthesize username;
@synthesize replynum;

//@synthesize imgView_thumb;
@synthesize btn_thumb;

@synthesize imgView_stick;
@synthesize imgView_digest;

@synthesize uid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 置顶
        imgView_stick =[[UIImageView alloc]initWithFrame:CGRectMake(270, 13, 21, 21)];
        imgView_stick.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_stick];
        
        // 加精
        imgView_digest =[[UIImageView alloc]initWithFrame:CGRectMake(295, 13, 21, 21)];
        imgView_digest.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_digest];

        // 内容
        label_subject = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 270-10.0, 20)];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:16.0f];
        label_subject.numberOfLines = 0;
        label_subject.textColor = [UIColor blackColor];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        
        // 头像
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_thumb.frame = CGRectMake(
                                     label_subject.frame.origin.x,
                                     label_subject.frame.origin.y + label_subject.frame.size.height + 5,
                                     40,
                                     40);
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 40/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];

//        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
//                                        label_subject.frame.origin.x,
//                                        label_subject.frame.origin.y + label_subject.frame.size.height + 5,
//                                        40,
//                                        40)];
//        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
//        imgView_thumb.layer.masksToBounds = YES;
//        imgView_thumb.layer.cornerRadius = 20.0f;
//        [self.contentView addSubview:imgView_thumb];

        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   btn_thumb.frame.origin.x + btn_thumb.frame.size.width + 5,
                                                                   btn_thumb.frame.origin.y + 3,
                                                                   200,
                                                                   20)];
        
//        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                                   imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 5,
//                                                                   imgView_thumb.frame.origin.y + 3-7,
//                                                                   100,
//                                                                   20)];
        
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:12.0f];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor grayColor];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];

        // 浏览次数
//        label_viewnum = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                                  label_username.frame.origin.x,
//                                                                  label_username.frame.origin.y + label_username.frame.size.height-2,
//                                                                  100,
//                                                                  20)];
        
        label_viewnum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  label_username.frame.origin.x,
                                                                  label_username.frame.origin.y + label_username.frame.size.height-2,
                                                                  90,
                                                                  20)];
        label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
        label_viewnum.font = [UIFont systemFontOfSize:12.0f];
        label_viewnum.numberOfLines = 0;
        label_viewnum.textColor = [UIColor grayColor];
        label_viewnum.backgroundColor = [UIColor clearColor];
        label_viewnum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_viewnum];

        // 日期
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   label_viewnum.frame.origin.x + label_viewnum.frame.size.width +5,
                                                                   label_viewnum.frame.origin.y,
                                                                   130,
                                                                   20)];
        
//        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                                   imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 5,
//                                                                   label_viewnum.frame.origin.y+18,
//                                                                   120,
//                                                                   20)];
        
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor grayColor];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];

        // 回复次数图片
        UIImageView *imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(260,60,20,20)];
        imgView_message.image=[UIImage imageNamed:@"icon_item_message_p.png"];
        [self.contentView addSubview:imgView_message];

        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 4,
                                                                   imgView_message.frame.origin.y + 1,
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

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromDiscussView2ProfileView" object:self userInfo:dic];
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

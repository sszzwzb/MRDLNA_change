//
//  ClassDiscussTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-12-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassDiscussTableViewCell.h"
#import "Masonry.h"
#import "BaseViewController.h"

@implementation ClassDiscussTableViewCell

@synthesize subject;
@synthesize dateline;
@synthesize viewnum;
@synthesize username;
@synthesize replynum;

//@synthesize imgView_thumb;
@synthesize btn_thumb;

@synthesize imgView_stick;
@synthesize imgView_digest;
@synthesize label_viewnum,label_replynum,imgView_message;

@synthesize uid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 置顶
        imgView_stick =[UIImageView new];
        imgView_stick.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_stick];
        [imgView_stick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.left.equalTo(self.contentView.mas_left).with.offset(270);
            make.size.mas_equalTo(CGSizeMake(21,21));
        }];
        
        // 加精
        imgView_digest =[UIImageView new];
        imgView_digest.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_digest];
        [imgView_digest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.left.equalTo(self.contentView.mas_left).with.offset(295);
            make.size.mas_equalTo(CGSizeMake(21,21));
        }];
        
        // 内容
        label_subject = [UILabel new];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:15.0];
        label_subject.numberOfLines = 0;
        label_subject.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        [label_subject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(280,20.0));
        }];
        
        // 头像
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn_thumb.frame = CGRectMake(
//                                     label_subject.frame.origin.x,
//                                     label_subject.frame.origin.y + label_subject.frame.size.height + 11.0,
//                                     30.0,
//                                     30.0);
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 30/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];
        [btn_thumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_subject.mas_bottom).with.offset(11.0);
            make.left.equalTo(label_subject.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(30.0,30.0));
        }];
        
        // 名字
        label_username = [UILabel new];
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:14.0];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:102.0/255.0];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];
        [label_username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn_thumb.mas_top).with.offset(-5.0);
            make.left.equalTo(btn_thumb.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(200,20.0));
        }];
        // 日期
        label_dateline = [UILabel new];
        
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];
        [label_dateline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_username.mas_bottom).with.offset(0);
            make.left.equalTo(label_username.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(70,15.0));
        }];
        
        // 浏览次数图片
        UIImageView *imgView_viewnum =[UIImageView new];
        imgView_viewnum.image=[UIImage imageNamed:@"icon_liulan.png"];
        [self.contentView addSubview:imgView_viewnum];
        [imgView_viewnum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_dateline.mas_top).with.offset(0);
            make.left.equalTo(label_dateline.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(15.0,15.0));
        }];
    
        label_viewnum = [UILabel new];
        label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
        label_viewnum.font = [UIFont systemFontOfSize:12.0f];
        label_viewnum.numberOfLines = 0;
        label_viewnum.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];;
        label_viewnum.backgroundColor = [UIColor clearColor];
        label_viewnum.lineBreakMode = NSLineBreakByTruncatingTail;
        //label_viewnum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label_viewnum];
        [label_viewnum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView_viewnum.mas_top).with.offset(0);
            make.left.equalTo(imgView_viewnum.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(30,15.0));
        }];
        
        
        // 回复次数图片
        imgView_message =[UIImageView new];
        imgView_message.image = [UIImage imageNamed:@"icon_hw_comment.png"];
        [self.contentView addSubview:imgView_message];
        [imgView_message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_viewnum.mas_top).with.offset(0);
            make.left.equalTo(label_viewnum.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(30.0,15.0));
        }];
        
        // 回复次数
        label_replynum = [UILabel new];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:12.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];;
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        //label_replynum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label_replynum];
        [label_replynum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView_message.mas_top).with.offset(0);
            make.left.equalTo(imgView_message.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(20,15.0));
        }];
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  HomeworkTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeworkTableViewCell.h"

@implementation HomeworkTableViewCell

@synthesize subject;
@synthesize dateline;
@synthesize viewnum;
@synthesize username;
@synthesize replynum;
@synthesize expectedtime;
@synthesize tid;

@synthesize imgView_thumb;
@synthesize imgView_displayorder;
@synthesize imgView_digest;
@synthesize button_delete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //----update by kate 2014.12.08---------------------------------------------
//        // 闹钟
//        UIImageView *imgView_bg_top =[[UIImageView alloc]initWithFrame:CGRectMake(
//                                                                                  5,
//                                                                                  5,
//                                                                                  15,
//                                                                                  15)];
//        
//        imgView_bg_top.image=[UIImage imageNamed:@"tlq_clock.png"];
//        [self.contentView addSubview:imgView_bg_top];
//
//        // 作业时间
//        label_expectedtime = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                                       imgView_bg_top.frame.origin.x + imgView_bg_top.frame.size.width + 3,
//                                                                       imgView_bg_top.frame.origin.y + 3,
//                                                                       130,
//                                                                       10)];
//        label_expectedtime.lineBreakMode = NSLineBreakByWordWrapping;
//        label_expectedtime.textAlignment = NSTextAlignmentLeft;
//        label_expectedtime.font = [UIFont systemFontOfSize:12.0f];
//        label_expectedtime.numberOfLines = 0;
//        label_expectedtime.textColor = [UIColor redColor];
//        label_expectedtime.backgroundColor = [UIColor clearColor];
//        label_expectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
//        [self.contentView addSubview:label_expectedtime];
        //----------------------------------------------------

        // 置顶
        //        imgView_stick =[[UIImageView alloc]initWithFrame:CGRectMake(280, -5, 25, 51)];
        imgView_displayorder =[[UIImageView alloc]initWithFrame:CGRectMake(270, 0, 21, 21)];
        imgView_displayorder.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_displayorder];
        
        // 加精
        //        imgView_stick =[[UIImageView alloc]initWithFrame:CGRectMake(280, -5, 25, 51)];
        imgView_digest =[[UIImageView alloc]initWithFrame:CGRectMake(295, 0, 21, 21)];
        imgView_digest.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_digest];

        //---update by kate 2014.12.08----------------------------------
        // 内容
        label_subject = [[UILabel alloc] initWithFrame:CGRectMake(5+11,
                                                                  5 + 3+5+3, 280, 20)];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:15.0f];
        label_subject.numberOfLines = 0;
        label_subject.textColor = [UIColor blackColor];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                    label_subject.frame.origin.x,
                                                                    label_subject.frame.origin.y + label_subject.frame.size.height + 7,
                                                                    40,
                                                                    40)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 40/2;
        [self.contentView addSubview:imgView_thumb];
        
        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 5,
                                                                   imgView_thumb.frame.origin.y+2,
                                                                   200,
                                                                   15)];// 2015.11.2 宽度修改
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:12.0f];
        label_username.numberOfLines = 0;
        label_username.textColor = [UIColor grayColor];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];
        
        // 时间
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   label_username.frame.origin.x,
                                                                   label_username.frame.origin.y + label_username.frame.size.height+5,
                                                                   80,
                                                                   20)];
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor grayColor];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];

        
        
        // 闹钟
        UIImageView *imgView_bg_top =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                  label_dateline.frame.origin.x + label_dateline.frame.size.width + 10 - 20,
                                                                                  label_dateline.frame.origin.y,
                                                                                  20,
                                                                                  20)];
        
        imgView_bg_top.image=[UIImage imageNamed:@"tlq_clock.png"];
        [self.contentView addSubview:imgView_bg_top];
        
        // 作业时间
        label_expectedtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                       imgView_bg_top.frame.origin.x + imgView_bg_top.frame.size.width + 3-2,
                                                                       imgView_bg_top.frame.origin.y,
                                                                       40+7,
                                                                       20)];
        label_expectedtime.lineBreakMode = NSLineBreakByWordWrapping;
        label_expectedtime.textAlignment = NSTextAlignmentLeft;
        label_expectedtime.font = [UIFont systemFontOfSize:12.0f];
        label_expectedtime.numberOfLines = 0;
        label_expectedtime.textColor = [UIColor colorWithRed:0.0/255.0 green:121.0/255.0 blue:215.0/255.0 alpha:1];
        label_expectedtime.backgroundColor = [UIColor clearColor];
        label_expectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_expectedtime];
        //-----------------------------------------------------------
        
        // 浏览次数图片
        UIImageView *imgView_viewnum =[[UIImageView alloc]initWithFrame:CGRectMake(label_expectedtime.frame.origin.x + label_expectedtime.frame.size.width + 3,label_expectedtime.frame.origin.y,20,20)];
        imgView_viewnum.image=[UIImage imageNamed:@"icon_liulan.png"];
        [self.contentView addSubview:imgView_viewnum];

        // 浏览次数
        label_viewnum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  imgView_viewnum.frame.origin.x + imgView_viewnum. frame.size.width + 3,
                                                                  imgView_viewnum.frame.origin.y,
                                                                  20,
                                                                  20)];
        label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
        label_viewnum.font = [UIFont systemFontOfSize:12.0f];
        label_viewnum.numberOfLines = 0;
        label_viewnum.textColor = [UIColor grayColor];
        label_viewnum.backgroundColor = [UIColor clearColor];
        label_viewnum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_viewnum];
        
        
        // 回复次数图片
        UIImageView *imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                   label_viewnum.frame.origin.x + label_viewnum.frame.size.width + 8,
                                                                                   label_viewnum.frame.origin.y,
                                                                                   20,
                                                                                   20)];
        imgView_message.image=[UIImage imageNamed:@"icon_hw_comment.png"];
        [self.contentView addSubview:imgView_message];
        
        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 3,
                                                                   imgView_message.frame.origin.y,
                                                                   20,
                                                                   20)];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:12.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor grayColor];
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_replynum];
        
        // 每条cell最下方的线
        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(10,89,310,1)];
        [_imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_imgView_line];

        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        
        // 指定为拉伸模式，伸缩后重新赋值
        CGSize buttonSize;
        buttonSize.width = 40;
        buttonSize.height = 90;
        
        UIImage *newImage_d;
        UIImage *newImage_p;
        UIImage *image_d1;
        UIImage *image_p1;
        
        // 默认状态图片
        UIImage *image_d = [UIImage imageNamed:@"delete.png"];
        image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        // 选择状态图片
        UIImage *image_p = [UIImage imageNamed:@"delete.png"];
        image_p = [image_p resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        image_d1 = [UIImage imageNamed:@"icon_trash.png"];
        image_p1 = [UIImage imageNamed:@"icon_trash.png"];
        
        UIGraphicsBeginImageContext(buttonSize);
        [image_d drawInRect:CGRectMake(0,0,buttonSize.width,90)];
        [image_d1 drawInRect:CGRectMake((buttonSize.width-30)/2,(buttonSize.height-30)/2,30,30)];
        
        newImage_d = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(buttonSize);
        [image_p drawInRect:CGRectMake(0,0,buttonSize.width,90)];
        [image_p1 drawInRect:CGRectMake((buttonSize.width-30)/2,(buttonSize.height-30)/2,30,30)];
        
        newImage_p = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        /*// 删除button update by kate 2014.12.08
        button_delete = [UIButton buttonWithType:UIButtonTypeCustom];
        button_delete.frame = CGRectMake(280, 0, 40, 90);
        //button.center = CGPointMake(160.0f, 140.0f);
        
        button_delete.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置title自适应对齐
        button_delete.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [button_delete setBackgroundImage:newImage_d forState:UIControlStateNormal] ;
        [button_delete setBackgroundImage:newImage_p forState:UIControlStateHighlighted] ;
        // 添加 action
        [button_delete addTarget:self action:@selector(delete_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button_delete];*/
    }
    return self;
}

- (IBAction)delete_btnclick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"删除这个作业？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消"
                              , nil];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:tid forKey:@"tid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_deleteMyHomeWork" object:self userInfo:dic];
    }
    else {
        // nothing
    }
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

- (void)setExpectedtime:(NSString *)n {
    if(![n isEqualToString:expectedtime]) {
        expectedtime = [n copy];
        label_expectedtime.text = expectedtime;
    }
}

@end

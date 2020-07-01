//
//  DiscussDetailTopCell.m
//  MicroSchool
//
//  Created by jojo on 13-12-24.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "DiscussDetailTopCell.h"

@implementation DiscussDetailTopCell

@synthesize subject;
@synthesize username;
@synthesize dateline;
@synthesize replynum;
@synthesize viewnum;
@synthesize expectedtime;
@synthesize  timeLabel,timeTitleLabel;


//@synthesize imgView_thumb;
@synthesize imgView_line;
@synthesize imgView_bg_clock;

@synthesize playRecordButtonSubject;
@synthesize animationImageViewSubject;
@synthesize playImageViewSubject;

@synthesize uid;
@synthesize btn_thumb;
@synthesize label_viewnum,label_replynum,imgView_message,label_dateline;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 标题
        label_subject = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 280, 50)];
        label_subject.lineBreakMode = NSLineBreakByWordWrapping;
        label_subject.font = [UIFont systemFontOfSize:15.0];
        label_subject.numberOfLines = 3;
        label_subject.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label_subject.backgroundColor = [UIColor clearColor];
        label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_subject];
        
        // 缩略图
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_thumb.frame = CGRectMake(
                                     label_subject.frame.origin.x,
                                     label_subject.frame.origin.y + label_subject.frame.size.height +11.0,
                                     30.0,
                                     30.0);
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 30/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];

//        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
//                                                                    label_subject.frame.origin.x,
//                                                                    label_subject.frame.origin.y + label_subject.frame.size.height +5,
//                                                                    40,
//                                                                    40)];
//        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
//        imgView_thumb.layer.masksToBounds = YES;
//        imgView_thumb.layer.cornerRadius = 20.0f;
//        [self.contentView addSubview:imgView_thumb];
        
        // 名字
        label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   btn_thumb.frame.origin.x + btn_thumb.frame.size.width + 5.0,
                                                                   btn_thumb.frame.origin.y,
                                                                   200,
                                                                   20)];
        label_username.lineBreakMode = NSLineBreakByWordWrapping;
        label_username.font = [UIFont systemFontOfSize:14.0f];
        label_username.numberOfLines = 0;
        label_username.textColor =  [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        label_username.backgroundColor = [UIColor clearColor];
        label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_username];

        // 时间图片
//        UIImageView *imgView_startTime =[[UIImageView alloc]initWithFrame:CGRectMake(
//                                                                        150,
//                                                                        btn_thumb.frame.origin.y + btn_thumb.frame.size.height  -15,
//                                                                        15,
//                                                                        15)];
//        imgView_startTime.image=[UIImage imageNamed:@"icon_event_start_time.png"];
//        imgView_startTime.contentMode = UIViewContentModeScaleToFill;
//        [self.contentView addSubview:imgView_startTime];

        // 日期
        label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   label_username.frame.origin.x,
                                                                   label_username.frame.origin.y+label_username.frame.size.height,
                                                                   70.0,
                                                                   15.0)];
        
        label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        label_dateline.font = [UIFont systemFontOfSize:12.0f];
        label_dateline.numberOfLines = 0;
        label_dateline.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        label_dateline.backgroundColor = [UIColor clearColor];
        label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_dateline];
        
        // 浏览次数图片
        UIImageView *imgView_viewnum =[[UIImageView alloc]initWithFrame:CGRectMake(label_dateline.frame.origin.x + label_dateline.frame.size.width + 5.0,
                                                                                   label_dateline.frame.origin.y,15.0,15.0)];
        imgView_viewnum.image=[UIImage imageNamed:@"icon_liulan.png"];
        [self.contentView addSubview:imgView_viewnum];
        
        label_viewnum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  imgView_viewnum.frame.origin.x + imgView_viewnum. frame.size.width + 5.0,
                                                                  imgView_viewnum.frame.origin.y,
                                                                  20,
                                                                  15.0)];
        label_viewnum.lineBreakMode = NSLineBreakByWordWrapping;
        label_viewnum.font = [UIFont systemFontOfSize:12.0f];
        label_viewnum.numberOfLines = 0;
        label_viewnum.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];;
        label_viewnum.backgroundColor = [UIColor clearColor];
        label_viewnum.lineBreakMode = NSLineBreakByTruncatingTail;
        //label_viewnum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label_viewnum];
        
        // 回复次数图片
        imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(label_viewnum.frame.origin.x + label_viewnum.frame.size.width+5.0,
                                                                      label_viewnum.frame.origin.y,15.0,15.0)];
        imgView_message.image = [UIImage imageNamed:@"icon_hw_comment.png"];
        [self.contentView addSubview:imgView_message];
        
        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 5.0,
                                                                   imgView_message.frame.origin.y,
                                                                   20,
                                                                   15.0)];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:12.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];;
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        //label_replynum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label_replynum];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(btn_thumb.frame.origin.x, label_dateline.frame.origin.y+label_dateline.frame.size.height+10, [UIScreen mainScreen].bounds.size.width - btn_thumb.frame.origin.x*2, 1)];
        line.image = [UIImage imageNamed:@"lineSystem.png"];
        [self.contentView addSubview:line];
        
        
        timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   btn_thumb.frame.origin.x,
                                                                   label_dateline.frame.origin.y + label_dateline.frame.size.height,
                                                                   91.0,
                                                                   20)];
        timeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        timeTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        timeTitleLabel.numberOfLines = 0;
        timeTitleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        timeTitleLabel.backgroundColor = [UIColor clearColor];
        timeTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:timeTitleLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   timeTitleLabel.frame.origin.x+timeTitleLabel.frame.size.width,
                                                                   timeTitleLabel.frame.origin.y,
                                                                   140,
                                                                   20)];
        timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        timeLabel.numberOfLines = 0;
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:timeLabel];
        
        // 闹钟
        imgView_bg_clock =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                       250-10,
                                                                       label_dateline.frame.origin.y,
                                                                       20,
                                                                       20)];
        
        imgView_bg_clock.image=[UIImage imageNamed:@"tlq_clock.png"];
        imgView_bg_clock.hidden = YES;
        [self.contentView addSubview:imgView_bg_clock];
        
        
        // 作业时间
        _label_expectedtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                       imgView_bg_clock.frame.origin.x + imgView_bg_clock.frame.size.width-5,
                                                                       label_dateline.frame.origin.y+3,
                                                                       40+20,
                                                                       15)];
        _label_expectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_expectedtime.textAlignment = NSTextAlignmentCenter;
        _label_expectedtime.font = [UIFont systemFontOfSize:14.0f];
        _label_expectedtime.textColor = [[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0];
        _label_expectedtime.backgroundColor = [UIColor clearColor];
        _label_expectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_expectedtime];
        
        _imgView_line_bottom =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_line_bottom.image=[UIImage imageNamed:@"hengxian.jpg"];
        [self.contentView addSubview:_imgView_line_bottom];

        _imgView_line_bottom1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_line_bottom1.image=[UIImage imageNamed:@"hengxian.jpg"];
        [self.contentView addSubview:_imgView_line_bottom1];

        // 播放button
        playRecordButtonSubject = [UIButton buttonWithType:UIButtonTypeCustom];
        playRecordButtonSubject.frame = CGRectMake(0,
                                                   0,
                                                   0,
                                                   0);
        [playRecordButtonSubject setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                           forState:UIControlStateNormal];
        [playRecordButtonSubject setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                           forState:UIControlStateHighlighted];
        
        [playRecordButtonSubject addTarget:self action:@selector(play_btnclick:) forControlEvents:UIControlEventTouchDown];
        [playRecordButtonSubject setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [playRecordButtonSubject setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        playRecordButtonSubject.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [playRecordButtonSubject setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        playRecordButtonSubject.hidden = YES;
        [self.contentView addSubview:playRecordButtonSubject];
        
        // 播放按钮上得播放三角
        playImageViewSubject = [[UIImageView alloc]init];
        playImageViewSubject.frame = CGRectMake(playRecordButtonSubject.frame.origin.x + (playRecordButtonSubject.frame.size.width/2 - 10)/2 + playRecordButtonSubject.frame.size.width/2 - 5,
                                                playRecordButtonSubject.frame.origin.y + (playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
        playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_media_play.png"];
        playImageViewSubject.hidden = YES;
        [self.contentView addSubview:playImageViewSubject];
        
        // 播放中的音量动画
        animationImageViewSubject = [[UIImageView alloc]init];
        animationImageViewSubject.frame = CGRectMake(playRecordButtonSubject.frame.origin.x + (playRecordButtonSubject.frame.size.width/2 - 10)/2 + playRecordButtonSubject.frame.size.width/2,
                                                     playRecordButtonSubject.frame.origin.y + (playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
        //将序列帧数组赋给UIImageView的animationImages属性
        animationImageViewSubject.animationImages = [NSArray arrayWithObjects:
                                                     [UIImage imageNamed:@"amr/icon_send_horn_bbs.png"],
                                                     [UIImage imageNamed:@"amr/icon_send_horn01_bbs.png"],
                                                     [UIImage imageNamed:@"amr/icon_send_horn02_bbs.png"],
                                                     [UIImage imageNamed:@"amr/icon_send_horn03_bbs.png"],nil];
        //设置动画时间
        animationImageViewSubject.animationDuration = 0.75;
        //设置动画次数 0 表示无限
        animationImageViewSubject.animationRepeatCount = 0;
        [self.contentView addSubview:animationImageViewSubject];
        
        // 浏览痕迹
        _imgView_historyBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_historyBg.contentMode = UIViewContentModeScaleToFill;
        [_imgView_historyBg setImage:[UIImage imageNamed:@"tlq_history.png"]];
        _imgView_historyBg.userInteractionEnabled = NO;
        [self.contentView addSubview:_imgView_historyBg];

        // 浏览痕迹上面的5各头像
        _imgView_headImg1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg1.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg1.layer.masksToBounds = YES;
        _imgView_headImg1.layer.cornerRadius = 15.0;
        _imgView_headImg1.userInteractionEnabled = NO;
        [self.contentView addSubview:_imgView_headImg1];

        _imgView_headImg2 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg2.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg2.layer.masksToBounds = YES;
        _imgView_headImg2.layer.cornerRadius = 15.0;
        _imgView_headImg2.userInteractionEnabled = NO;
        [self.contentView addSubview:_imgView_headImg2];

        _imgView_headImg3 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg3.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg3.layer.masksToBounds = YES;
        _imgView_headImg3.layer.cornerRadius = 15.0;
        _imgView_headImg3.userInteractionEnabled = NO;

        [self.contentView addSubview:_imgView_headImg3];

        _imgView_headImg4 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg4.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg4.layer.masksToBounds = YES;
        _imgView_headImg4.layer.cornerRadius = 15.0;
        _imgView_headImg4.userInteractionEnabled = NO;

        [self.contentView addSubview:_imgView_headImg4];

        _imgView_headImg5 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg5.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg5.layer.masksToBounds = YES;
        _imgView_headImg5.layer.cornerRadius = 15.0;
        _imgView_headImg5.userInteractionEnabled = NO;

        [self.contentView addSubview:_imgView_headImg5];
        
        _label_historyCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_historyCount.lineBreakMode = NSLineBreakByWordWrapping;
        _label_historyCount.font = [UIFont systemFontOfSize:14.0f];
        _label_historyCount.numberOfLines = 0;
        _label_historyCount.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        _label_historyCount.backgroundColor = [UIColor clearColor];
        _label_historyCount.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_historyCount.userInteractionEnabled = NO;

        [self.contentView addSubview:_label_historyCount];
        
        _btn_history = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_history.frame = CGRectZero;
        [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
        _btn_history.contentMode = UIViewContentModeScaleToFill;
        
//        [_btn_history setBackgroundColor:[UIColor redColor]];
        //        [_btn_history setBackgroundImage:[UIImage imageNamed:@"tlq_history.png"] forState:UIControlStateNormal] ;
        //        [_btn_history setBackgroundImage:[UIImage imageNamed:@"tlq_history.png"] forState:UIControlStateHighlighted] ;
        [self.contentView addSubview:_btn_history];
    }
    return self;
}

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromDiscussDetailView2ProfileView" object:self userInfo:dic];
}

- (IBAction)btnclick_history:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromDiscussDetailView2History" object:self userInfo:dic];
}

- (IBAction)play_btnclick:(id)sender
{
    // temp
    if ([animationImageViewSubject isAnimating]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"2", @"isPlayStatus",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInTopCell" object:self userInfo:dic];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1", @"isPlayStatus",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInTopCell" object:self userInfo:dic];
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

- (void)setViewnum:(NSString *)n {
    if(![n isEqualToString:viewnum]) {
        viewnum = [n copy];
        label_viewnum.text = viewnum;
    }
}

- (void)setReplynum:(NSString *)n {
    if(![n isEqualToString:replynum]) {
        replynum = [n copy];
        label_replynum.text = replynum;
    }
}

// add by kate 2014.04.18
- (void)setExpectedtime:(NSString *)n {
    if(![n isEqualToString:expectedtime]) {
        expectedtime = [n copy];
        _label_expectedtime.text = expectedtime;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		return NO;
	}
	return YES;
}

@end

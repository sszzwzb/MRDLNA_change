//
//  MsgAudioView.m
//  MicroSchool
//
//  Created by zhanghaotian on 6/6/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "MsgAudioView.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicConstant.h"
#import "Utilities.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MsgAudioView

@synthesize bgView;
@synthesize showImgView;
@synthesize bgViewRcv, bgViewSend,bgViewRcv0,bgViewRcv1,bgViewRcv2,bgViewRcv3,bgViewRcv4,bgViewRcv5,bgViewRcv6,bgViewRcv7,bgViewRcv8,bgViewRcv9;
@synthesize entityForpic;
@synthesize bgImgRcv;
@synthesize bgImgSend;
@synthesize coverView;
@synthesize animationImageView = _animationImageView;
@synthesize playImageViewSubject = _playImageViewSubject;
@synthesize entityForGroup;//add 2015.06.21
@synthesize entityForMix;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.bgImgRcv = [UIImage imageNamed:@"friend/bg_recive_nor"];
//        self.bgImgSend = [UIImage imageNamed:@"friend/bg_sent_nor"];
        
        bgViewRcv = [UIImage imageNamed:@"ReceiveBubble.png"];//update 2015.07.16
       
        //ReceiveBubble_animat0@2x
        bgViewSend = [UIImage imageNamed:@"SendBubble.png"];
        
        bgView = [[UIImageView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.userInteractionEnabled = YES;
        //bgView.image = [UIImage imageNamed:@"SendBubble.png"];
        [bgView setFrame:CGRectMake(0, 8, 100, 35)];
        
//        bgViewRcv0 =  [UIImage imageNamed:@"ReceiveBubble_animat0"];
//        bgViewRcv1 =  [UIImage imageNamed:@"ReceiveBubble_animat1"];
//        bgViewRcv2 =  [UIImage imageNamed:@"ReceiveBubble_animat2"];
        bgViewRcv0 =  [UIImage imageNamed:@"1"];
        bgViewRcv1 =  [UIImage imageNamed:@"2"];
        bgViewRcv2 =  [UIImage imageNamed:@"3"];
        bgViewRcv3 =  [UIImage imageNamed:@"4"];
        bgViewRcv4 =  [UIImage imageNamed:@"5"];
        bgViewRcv5 =  [UIImage imageNamed:@"6"];
        bgViewRcv6 =  [UIImage imageNamed:@"7"];
        bgViewRcv7 =  [UIImage imageNamed:@"8"];
        bgViewRcv8 =  [UIImage imageNamed:@"9"];
        bgViewRcv9 =  [UIImage imageNamed:@"10"];
    
        bgView.animationImages = [NSArray arrayWithObjects:bgViewRcv0,bgViewRcv1,bgViewRcv2,bgViewRcv3,bgViewRcv4,bgViewRcv5,bgViewRcv6,bgViewRcv7,bgViewRcv8,bgViewRcv9,nil];
        
        //设置动画时间
        bgView.animationDuration = 1.6;
        //设置动画次数 0 表示无限
        bgView.animationRepeatCount = 0;
        
        self.frame = CGRectMake([Utilities getScreenSize].width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);

        [self addSubview:bgView];
        
        audioSecondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 25.0, 20.0, 15.0)];
        audioSecondLabel.textColor = [UIColor colorWithRed:102.0/256.0 green:102.0/256.0 blue:102.0/256.0 alpha:1];
        audioSecondLabel.font = [UIFont systemFontOfSize:13.0];
        audioSecondLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:audioSecondLabel];
        
        unReadImgV = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 8, 8)];//add 2015.11.03
        [self addSubview:unReadImgV];
        
        // 播放按钮上得播放三角
        _playImageViewSubject = [[UIImageView alloc]init];
        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-20)/2-20, (bgView.frame.size.height-20)/2, 20, 20);
        _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_send_horn03"];
        
        [bgView addSubview:_playImageViewSubject];

        // 播放中的音量动画
        _animationImageView = [[UIImageView alloc]init];
        _animationImageView.frame = CGRectMake((100-20)/2-20, (35-20)/2, 20, 20);
        //将序列帧数组赋给UIImageView的animationImages属性
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"amr/icon_send_horn"],
                                              [UIImage imageNamed:@"amr/icon_send_horn01"],
                                              [UIImage imageNamed:@"amr/icon_send_horn02"],
                                              [UIImage imageNamed:@"amr/icon_send_horn03"],nil];

        //设置动画时间
        _animationImageView.animationDuration = 0.75;
        //设置动画次数 0 表示无限
        _animationImageView.animationRepeatCount = 0;
        
        [bgView addSubview:_animationImageView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopMsgAudio)
                                                     name:@"audioDone"
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(startAnimat)
//                                                     name:@"startAnimat"
//                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    self.bgImgRcv = nil;
    self.bgImgSend = nil;
    self.coverView = nil;
}

- (void)playMsgAudio
{
    NSLog(@"sdlkfjsldkfjlkj");
    if (self.entityForpic!=nil) {
        
        _playImageViewSubject.hidden = YES;
        [_animationImageView startAnimating];
        
        NSMutableArray *objArray = [[NSMutableArray alloc] init];
        [objArray addObject:self.index];
        [objArray addObject:entityForpic];
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_PLAY_AUDIO
        //                                                    object:entityForpic];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_PLAY_AUDIO
                                                            object:objArray];
    }else if (self.entityForGroup!=nil){//add 2015.06.01
        
        _playImageViewSubject.hidden = YES;
        [_animationImageView startAnimating];
        
        NSMutableArray *objArray = [[NSMutableArray alloc] init];
        [objArray addObject:self.index];
        [objArray addObject:entityForGroup];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_PLAY_AUDIO_GROUP
                                                            object:objArray];
    }else if (self.entityForMix!=nil){//add 2015.06.01
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        long long  uid = [[userInfo objectForKey:@"uid"] longLongValue];
        long long key = entityForMix.user_id;
        if (entityForMix.is_recieved == MSG_IO_FLG_SEND) {
            if (entityForMix.user_id == 0) {
                key = uid;
            }
        }
        
        NSString *audioDir = [Utilities getChatAudioDir:key];
        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForMix.msg_id, FILE_AMR_EXTENSION];
        
        NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
        if (fileData == nil || [fileData length] == 0) {
            
        }else{
           
            if (entityForMix.audio_r_status == 1) {
                _playImageViewSubject.hidden = YES;
                [_animationImageView startAnimating];
                
            }else{
                _playImageViewSubject.hidden = NO;
                [_animationImageView stopAnimating];
                
            }
        }
        
        NSMutableArray *objArray = [[NSMutableArray alloc] init];
        [objArray addObject:self.index];
        [objArray addObject:entityForMix];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_PLAY_AUDIO_MIX
                                                            object:objArray];
    }
    
}

-(void)startAnimat{
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    
    long long  uid = [[userInfo objectForKey:@"uid"] longLongValue];
    long long key = entityForMix.user_id;
    if (entityForMix.is_recieved == MSG_IO_FLG_SEND) {
        if (entityForMix.user_id == 0) {
            key = uid;
        }
    }
    
    NSString *audioDir = [Utilities getChatAudioDir:key];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForMix.msg_id, FILE_AMR_EXTENSION];
    NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
    if (fileData == nil || [fileData length] == 0) {
        return;
    }
    
    _playImageViewSubject.hidden = YES;
  
    if (!_animationImageView.isAnimating) {
        
        if ([_index integerValue] == _numOfCellAudioPlaying) {
            
            _playImageViewSubject.hidden = YES;
            [_animationImageView startAnimating];
            
        }else{
            _playImageViewSubject.hidden = NO;
        }
      
    }
    
}

// 由于发送多个消息导致程序崩溃 废弃 改成通过index取cell
-(void)stopMsgAudio{
    
    if (_animationImageView.isAnimating){
        [_animationImageView stopAnimating];
    }
     _playImageViewSubject.hidden = NO;
    
}

// 更新聊天画面
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity
{
    //bgView.backgroundColor = [UIColor redColor];
    self.entityForpic = entity;
    if (entityForpic.is_recieved == MSG_IO_FLG_RECEIVE) {
        //bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"ReceiveBubble.png"];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
         _playImageViewSubject.hidden = NO;
         _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_recive_horn_nor.png"];
//        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-20)/2+10, (bgView.frame.size.height-20)/2, 20, 20);
//        _animationImageView.frame = CGRectMake((100-20)/2+10, (35-20)/2, 20, 20);
        
        if (entity.audioSecond > 0) {
            
            //NSLog(@"entity.msg_state:%d",entity.msg_state);
            
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
            if (entity.msg_state_audio != MSG_READ_FLG_READ_AUDIO) {//接收成功 未读
                unReadImgV.image = [UIImage imageNamed:@"icon_new.png"];
                //NSLog(@"audioSecond:%ld",(long)entity.audioSecond);
            }else{
                unReadImgV.image = nil;
            }
            
        }else{
           
            audioSecondLabel.text = @"";
            unReadImgV.image = nil; //语音时长为0不显示红点 志伟确认 2015.11.04
        }
        
        
        
        if (entity.audioSecond <=2) {//update 2015.11.03
            [bgView setFrame:CGRectMake(0, 8, 70.0, 35)];
        }else{
           [bgView setFrame:CGRectMake(0, 8, (entity.audioSecond-2)*2.1+74.0, 35.0)];
        }
        
        // 播放动画位置调整2015.11.03
//        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-3-20)/2, (bgView.frame.size.height-20)/2, 20, 20);
//        _animationImageView.frame = CGRectMake((bgView.frame.size.width-3-20)/2, (35-20)/2, 20, 20);
        
        _playImageViewSubject.frame = CGRectMake(bgView.frame.origin.x+2+15, (bgView.frame.size.height-20)/2, 20, 20);
        _animationImageView.frame = CGRectMake(bgView.frame.origin.x+2+15, (bgView.frame.size.height-20)/2, 20, 20);
        
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"amr/icon_recive_horn_nor"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn01"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn02"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn03"],nil];

        
        //        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD-10-10-5, 0, bgView.frame.size.width, bgView.frame.size.height);
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        //imageRect = CGRectMake(10, 4, imageSize.width, imageSize.height);
        //showImgView.frame = imageRect;
        
//        audioSecondLabel.frame = CGRectMake(self.frame.origin.x+bgView.frame.size.width-12.0, 19.0, 20.0, 15.0);
         audioSecondLabel.frame = CGRectMake(bgView.frame.size.width+5.0, 19.0, 20.0+5.0, 15.0);
        if ([audioSecondLabel.text isEqual:@""]) {
           unReadImgV.frame = CGRectMake(audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);
        }else{
          unReadImgV.frame = CGRectMake(audioSecondLabel.frame.size.width+audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);
        }
        
        
    } else if (entityForpic.is_recieved == MSG_IO_FLG_SEND) {
        //bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"SendBubble.png"];
         bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        _playImageViewSubject.hidden = NO;
        _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_send_horn03.png"];
        
        if (entity.audioSecond > 0) {
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
        }else{
           audioSecondLabel.text = @"";
        }
        
        if (entity.audioSecond <=2) {//update 2015.11.03
             bgView.frame = CGRectMake(30.0, bgView.frame.origin.y, 70.0, bgView.frame.size.height);
        }else{
            [bgView setFrame:CGRectMake(30.0, bgView.frame.origin.y, (entity.audioSecond-2)*2.1+74.0, bgView.frame.size.height)];
        }
        
        // 播放动画位置调整2015.11.03
//        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (bgView.frame.size.height-20)/2, 20, 20);
//        _animationImageView.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (35-20)/2, 20, 20);
        _playImageViewSubject.frame = CGRectMake(bgView.frame.size.width-8-13-15, (bgView.frame.size.height-20)/2, 20, 20);
        _animationImageView.frame = CGRectMake(bgView.frame.size.width-8-13-15, (35-20)/2, 20, 20);
        
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],
                                               [UIImage imageNamed:@"amr/icon_send_horn01"],
                                               [UIImage imageNamed:@"amr/icon_send_horn02"],
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],nil];

        
        //self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10, 0, bgView.frame.size.width, bgView.frame.size.height);
        //bgView.frame = CGRectMake(30.0, bgView.frame.origin.y, bgView.frame.size.width, bgView.frame.size.height);
        //        self.frame = CGRectMake(320 - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10+10-30, 0, bgView.frame.size.width+20, bgView.frame.size.height);
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD-30, 0, bgView.frame.size.width+30, bgView.frame.size.height);
        
        audioSecondLabel.frame = CGRectMake(0.0, 20.0, 20.0+5.0, 15.0);
        
        unReadImgV.image = nil;//2015.11.13
       
        /*if (entityForpic.msg_state == MSG_SENDING || entityForpic.msg_state == MSG_SEND_FAIL) {
            coverView.frame = imageRect;
            coverView.hidden = NO;
            [bgView addSubview:coverView];
        } else {
            coverView.hidden = YES;
        }*/
    }
    
    if (_isStart) {//add 2015.10.15
        [self startAnimat];
        NSLog(@"%@:startAnimat",_index);
    }
    
    //添加点击语音手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMsgAudio)];
    [bgView addGestureRecognizer:singleTouch];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
}

//---add 2015.06.01----------------------------------------------------------
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
    
    //bgView.backgroundColor = [UIColor redColor];
    self.entityForGroup = entity;
    if (entityForGroup.is_recieved == MSG_IO_FLG_RECEIVE) {
        //bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"ReceiveBubble.png"];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];

        if (entity.audioSecond > 0) {
            
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
            if (entity.msg_state_audio != MSG_READ_FLG_READ_AUDIO) {//接收成功 未读
                unReadImgV.image = [UIImage imageNamed:@"icon_new.png"];
            }else{
                unReadImgV.image = nil;
            }
            
        }else{
            
            audioSecondLabel.text = @"";
            unReadImgV.image = nil;//语音时长为0不显示红点 志伟确认 2015.11.04
            
        }
        
        if (entity.audioSecond <=2) {//update 2015.11.03
            [bgView setFrame:CGRectMake(0, 8, 70.0, 35)];
            //[bgView setFrame:CGRectMake(0, 8, 100, 35)];
            
        }else{
            [bgView setFrame:CGRectMake(0, 8, (entity.audioSecond-2)*2.1+74.0, 35.0)];
        }
        
        if ([entity.userName length] > 0) {//update 2015.07.20
            
            [bgView setFrame:CGRectMake(0, 8+10.0, bgView.frame.size.width, 35)];
            self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height+15.0);
            
        }else{
            
           self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        }
        
        _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_recive_horn_nor.png"];
        //_playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-20)/2+10, (bgView.frame.size.height-20)/2, 20, 20);
        //语音动画显示在靠头像一侧 2015.11.03
//        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-3-20)/2, (bgView.frame.size.height-20)/2, 20, 20);
//        _animationImageView.frame = CGRectMake((bgView.frame.size.width-3-20)/2, (35-20)/2, 20, 20);
        _playImageViewSubject.frame = CGRectMake(bgView.frame.origin.x+2+15, (bgView.frame.size.height-20)/2, 20, 20);
        _animationImageView.frame = CGRectMake(bgView.frame.origin.x+2+15, (35-20)/2, 20, 20);
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"amr/icon_recive_horn_nor"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn01"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn02"],
                                               [UIImage imageNamed:@"amr/icon_recive_horn03"],nil];
        
        //audioSecondLabel.frame = CGRectMake(self.frame.origin.x+bgView.frame.size.width-12.0, 19.0, 20.0, 15.0);
        audioSecondLabel.frame = CGRectMake(bgView.frame.size.width+5.0, 20.0, 20.0+5.0, 15.0);
        if ([entity.userName length] > 0) {//update 2015.07.20
        
            audioSecondLabel.frame = CGRectMake(bgView.frame.size.width+5.0, 19.0+10.0, 20.0+5.0, 15.0);
        }

        if ([audioSecondLabel.text isEqual:@""]) {
            unReadImgV.frame = CGRectMake(audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);
        }else{
            unReadImgV.frame = CGRectMake(audioSecondLabel.frame.size.width+audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);// 2015.11.03 2.9.1新需求
        }
        
        if (![_animationImageView isAnimating]) {
             _playImageViewSubject.hidden = NO;
        }else{
            
            NSLog(@"animating");
        }
      
       
    } else if (entityForGroup.is_recieved == MSG_IO_FLG_SEND) {
        //bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"SendBubble.png"];
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_send_horn03.png"];
        //_playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-20)/2-15, (bgView.frame.size.height-20)/2, 20, 20);
       
        //self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10, 0, bgView.frame.size.width, bgView.frame.size.height);
      
        if (entity.audioSecond > 0) {
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
        }else{
            audioSecondLabel.text = @"";
        }
        
        if (entity.audioSecond <=2) {//update 2015.11.03
             bgView.frame = CGRectMake(30.0, 8.0, 70.0, bgView.frame.size.height);
            
        }else{
            [bgView setFrame:CGRectMake(30.0, 8.0, (entity.audioSecond-2)*2.1+74.0, 35.0)];
        }
        
        //bgView.frame = CGRectMake(30.0, 8.0, bgView.frame.size.width, bgView.frame.size.height);
        //self.frame = CGRectMake(320 - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10+10-30, 0, bgView.frame.size.width+20, bgView.frame.size.height);
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD-30, 0, bgView.frame.size.width+30, bgView.frame.size.height);
        //语音动画显示在靠头像一侧 2015.11.03
//        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (bgView.frame.size.height-20)/2, 20, 20);
//        
//        _animationImageView.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (35-20)/2, 20, 20);
        _playImageViewSubject.frame = CGRectMake(bgView.frame.size.width-8-13.0-15.0, (bgView.frame.size.height-20)/2, 20, 20);
        
        _animationImageView.frame = CGRectMake(bgView.frame.size.width-8-13.0-15.0, (35-20)/2, 20, 20);
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],
                                               [UIImage imageNamed:@"amr/icon_send_horn01"],
                                               [UIImage imageNamed:@"amr/icon_send_horn02"],
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],nil];
        audioSecondLabel.frame = CGRectMake(0.0, 20.0, 20.0+5.0, 15.0);
        
        unReadImgV.image = nil;//2015.11.13
        
    }
    
    if (_isStart) {//add 2015.10.15
        [self startAnimat];
        NSLog(@"startAnimat");
    }
    
    //添加点击语音手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMsgAudio)];
    [bgView addGestureRecognizer:singleTouch];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
    
}
//----------------------------------------------------------------------------
//---2016.01.19---------------------------------------------------------------
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity{
    
    //bgView.backgroundColor = [UIColor redColor];
    self.entityForMix = entity;
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        //bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"ReceiveBubble.png"];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
        
        if (entity.audioSecond > 0) {
            
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
            
            if (entityForMix.audio_r_status == 1) {
                if (entity.msg_state_audio != MSG_READ_FLG_READ_AUDIO) {//接收成功 未读
                    unReadImgV.image = [UIImage imageNamed:@"icon_new.png"];
                }else{
                    unReadImgV.image = nil;
                }
            }else{
               unReadImgV.image = nil;
               audioSecondLabel.text = @"";
            }
            
        }else{
            
            audioSecondLabel.text = @"";
            unReadImgV.image = nil;//语音时长为0不显示红点 志伟确认 2015.11.04
            
        }
        
        if (entity.audioSecond <=2) {//update 2015.11.03
            [bgView setFrame:CGRectMake(0, 8, 70.0, 35)];
            //[bgView setFrame:CGRectMake(0, 8, 100, 35)];
            
        }else{
            [bgView setFrame:CGRectMake(0, 8, (entity.audioSecond-2)*2.1+74.0, 35.0)];
        }
        
        //self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD-10-10-5, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        if ([entity.userName length] > 0) {//update 2015.07.20
            
            [bgView setFrame:CGRectMake(0, 8+10.0, bgView.frame.size.width, 35)];
            self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height+15.0);
            
        }else{
            
            self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        }
        
       
//        _timer = [NSTimer scheduledTimerWithTimeInterval:3
//                                                           target:self
//                                                            selector:@selector(showArrow:)
//                                                         userInfo:nil
//                                                          repeats:YES];

       
         //bgView.animationImages = [NSArray arrayWithObjects:bgViewRcv,bgViewRcv0,bgViewRcv1,bgViewRcv2,bgViewRcv1,bgViewRcv0,nil];
         bgView.animationImages = [NSArray arrayWithObjects:bgViewRcv0,bgViewRcv1,bgViewRcv2,bgViewRcv3,bgViewRcv4,bgViewRcv5,bgViewRcv6,bgViewRcv7,bgViewRcv8,bgViewRcv9,nil];
        
       
        //语音动画显示在靠头像一侧 2015.11.03
        _playImageViewSubject.frame = CGRectMake(bgView.frame.origin.x+2+15, (bgView.frame.size.height-20)/2, 20, 20);
        _animationImageView.frame = CGRectMake(bgView.frame.origin.x+2+15, (35-20)/2, 20, 20);
        
        
        
        //audioSecondLabel.frame = CGRectMake(self.frame.origin.x+bgView.frame.size.width-12.0, 19.0, 20.0, 15.0);
        audioSecondLabel.frame = CGRectMake(bgView.frame.size.width+5.0, 20.0, 20.0+5.0, 15.0);
        if ([entity.userName length] > 0) {//update 2015.07.20
            
            audioSecondLabel.frame = CGRectMake(bgView.frame.size.width+5.0, 19.0+10.0, 20.0+5.0, 15.0);
        }
        
        if ([audioSecondLabel.text isEqual:@""]) {
            unReadImgV.frame = CGRectMake(audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);
        }else{
            unReadImgV.frame = CGRectMake(audioSecondLabel.frame.size.width+audioSecondLabel.frame.origin.x, audioSecondLabel.frame.origin.y +3.0, 8.0, 8.0);// 2015.11.03 2.9.1新需求
        }
        
        if (entityForMix.audio_r_status == 1) {
            
             [bgView stopAnimating];
            _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_recive_horn_nor.png"];
            _animationImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"amr/icon_recive_horn_nor"],
                                                   [UIImage imageNamed:@"amr/icon_recive_horn01"],
                                                   [UIImage imageNamed:@"amr/icon_recive_horn02"],
                                                   [UIImage imageNamed:@"amr/icon_recive_horn03"],nil];
           
            if (![_animationImageView isAnimating]) {
                
                _playImageViewSubject.hidden = NO;
                
                if ([_index integerValue] == _numOfCellAudioPlaying) {
                    
                    _isStart = YES;
                }
                
            }else{
                
                NSLog(@"animating");
                //NSLog(@"msgid:bbbbbbbbb-%lld",entityForMix.msg_id);
            }
            
        }else{
            
            _playImageViewSubject.image = nil;
            if (_animationImageView.isAnimating) {
                NSLog(@"animating");
               // NSLog(@"msgid:ccccccccc-%lld",entityForMix.msg_id);
 
            }else{
               _animationImageView.animationImages = nil;
               // NSLog(@"msgid:dddddddd-%lld",entityForMix.msg_id);
            }
            
            [bgView startAnimating];
        }
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        //bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        //bgView.image = [UIImage imageNamed:@"SendBubble.png"];
        
        bgView.animationImages = nil;
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        _playImageViewSubject.image = [UIImage imageNamed:@"amr/icon_send_horn03.png"];
        //_playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-20)/2-15, (bgView.frame.size.height-20)/2, 20, 20);
        
        //self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        if (entity.audioSecond > 0) {
            audioSecondLabel.text = [NSString stringWithFormat:@"%ld″",(long)entity.audioSecond];
        }else{
            audioSecondLabel.text = @"";
        }
        
        if (entity.audioSecond <=2) {//update 2015.11.03
            bgView.frame = CGRectMake(30.0, 8.0, 70.0, bgView.frame.size.height);
            
        }else{
            [bgView setFrame:CGRectMake(30.0, 8.0, (entity.audioSecond-2)*2.1+74.0, 35.0)];
        }
        
        //bgView.frame = CGRectMake(30.0, 8.0, bgView.frame.size.width, bgView.frame.size.height);
        //self.frame = CGRectMake(320 - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10+10-30, 0, bgView.frame.size.width+20, bgView.frame.size.height);
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD-30, 0, bgView.frame.size.width+30, bgView.frame.size.height);
        //语音动画显示在靠头像一侧 2015.11.03
        //        _playImageViewSubject.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (bgView.frame.size.height-20)/2, 20, 20);
        //
        //        _animationImageView.frame = CGRectMake((bgView.frame.size.width-8-20)/2, (35-20)/2, 20, 20);
        _playImageViewSubject.frame = CGRectMake(bgView.frame.size.width-8-13.0-15.0, (bgView.frame.size.height-20)/2, 20, 20);
        
        _animationImageView.frame = CGRectMake(bgView.frame.size.width-8-13.0-15.0, (35-20)/2, 20, 20);
        _animationImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],
                                               [UIImage imageNamed:@"amr/icon_send_horn01"],
                                               [UIImage imageNamed:@"amr/icon_send_horn02"],
                                               [UIImage imageNamed:@"amr/icon_send_horn03"],nil];
        audioSecondLabel.frame = CGRectMake(0.0, 20.0, 20.0+5.0, 15.0);
        
        unReadImgV.image = nil;//2015.11.13
        
        if (![_animationImageView isAnimating]) {
            
            _playImageViewSubject.hidden = NO;
            
            if ([_index integerValue] == _numOfCellAudioPlaying) {
                
                _isStart = YES;
            }
            
        }else{
            
            NSLog(@"animating");
            //NSLog(@"msgid:bbbbbbbbb-%lld",entityForMix.msg_id);
        }
        
    }
    
    if (_isStart) {//add 2015.10.15
         NSLog(@"start msgid:%lld",entityForMix.msg_id);
        [self startAnimat];
    }
    
    //添加点击语音手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMsgAudio)];
    [bgView addGestureRecognizer:singleTouch];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
    
}

-(void)targetMethod{
    
    bgView.hidden = YES;
    
}
//---------------------------------------------------------------------------------------------------------------

-(void)showMenu:(UIGestureRecognizer*)gestureRecognizer{
    
    [self becomeFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO];
    
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu2Delete:)];
       [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
    [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
    [menuController setMenuVisible:YES animated:YES];
   
}

// 删除
-(void)menu2Delete:(UIMenuController *)menuController{
    
    //发通知删除一条cell
    if (self.entityForpic!=nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG object:entityForpic];
    }else if (self.entityForGroup!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_GROUP object:entityForGroup];
    }else if (self.entityForMix!=nil){
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.index,@"index",entityForMix,@"object",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_MIX object:dic];
    }
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menu2Delete:)){
        return YES;
    }else{
        return NO;
    }
}

-(void)showAnimate:(CABasicAnimation*)theAnimate fromValue:(id)fromValue toValue:(id)toValue imgv:(UIImageView*)imgv{
    
    theAnimate.fromValue = fromValue;
    theAnimate.toValue = toValue;
    [imgv.layer addAnimation:theAnimate forKey:@"animateOpacity"];
    

}

-(void)targetMethod:(id)sender{
    
    NSTimer *time = sender;
    CABasicAnimation *animate = [time.userInfo objectForKey:@"theAnimation"];
    UIImageView *imgv = [time.userInfo objectForKey:@"imgv"];
    
    [self showAnimate:animate fromValue:animate.toValue toValue:animate.fromValue imgv:imgv];
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:animate,@"animate",imgv,@"imgv", nil];
//    
//    [self performSelector:@selector(reAnimate:) withObject:dic afterDelay:1.0];
    
}


-(void)showArrow:(id)sender{
    
    [UIView beginAnimations:@"ShowArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showArrowDidStop:finished:context:)];
    // Make the animatable changes.
    bgView.alpha = 0.0;
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
}
// Called at the end of the preceding animation.

- (void)showArrowDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
   
    [UIView beginAnimations:@"HideArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.0];
    bgView.alpha = 1.0;
    [UIView commitAnimations];
    
}

@end

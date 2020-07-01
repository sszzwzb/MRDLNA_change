//
//  MsgAudioView.h
//  MicroSchool
//
//  Created by zhanghaotian on 6/6/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ChatDetailObject.h"
#import "GroupChatDetailObject.h"// add 2015.05.29
#import "MixChatDetailObject.h"
#import "BaseViewController.h"

@interface MsgAudioView : UIView
{
    //背景pop
    UIImageView *bgView;
    UIImageView *showImgView;
    UIImage *bgImgSend;
    UIImage *bgImgRcv;
    ChatDetailObject *entityForpic;
    UIView *coverView;
    //UIImageView *animationImageView;
    //UIImageView *playImageViewSubject;
    ///时长Label
    UILabel *audioSecondLabel;
    UIImageView *unReadImgV;//语音未读红点
    //CABasicAnimation *theAnimation;
}
@property (nonatomic, retain) UIImageView *animationImageView;
@property (nonatomic, retain) UIImageView *playImageViewSubject;
@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIImage *bgViewRcv;
@property (nonatomic, retain) UIImage *bgViewRcv0;
@property (nonatomic, retain) UIImage *bgViewRcv1;
@property (nonatomic, retain) UIImage *bgViewRcv2;
@property (nonatomic, retain) UIImage *bgViewRcv3;
@property (nonatomic, retain) UIImage *bgViewRcv4;
@property (nonatomic, retain) UIImage *bgViewRcv5;
@property (nonatomic, retain) UIImage *bgViewRcv6;
@property (nonatomic, retain) UIImage *bgViewRcv7;
@property (nonatomic, retain) UIImage *bgViewRcv8;
@property (nonatomic, retain) UIImage *bgViewRcv9;
@property (nonatomic, retain) UIImage *bgViewSend;
@property (nonatomic, retain) UIImage *bgImgSend;
@property (nonatomic, retain) UIImage *bgImgRcv;
@property (nonatomic, retain) ChatDetailObject *entityForpic;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) NSString *index;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger numOfCellAudioPlaying;//点击播放那条语音的index


// 更新聊天画面
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity;
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity;// 2015.05.29
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity;// add 2016.01.19
@property (nonatomic,retain) GroupChatDetailObject *entityForGroup;//add by kate 2015.06.01
@property (nonatomic, retain) MixChatDetailObject *entityForMix;// add 2016.01.19
-(void)startAnimat;
@end

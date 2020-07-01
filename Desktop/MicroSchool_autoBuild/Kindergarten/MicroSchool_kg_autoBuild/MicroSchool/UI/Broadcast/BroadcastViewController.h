//
//  BroadcastViewController.h
//  MicroSchool
//
//  Created by jojo on 15/1/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "BroadcastHistoryViewController.h"

#import "MBProgressHUD+Add.h"
#import <MediaPlayer/MPMediaPickerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "BroadcastModel.h"

#import "TSNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>

#import <AVKit/AVKit.h>
#import "UIColor+Tools.h"

@interface BroadcastViewController : BaseViewController<HttpReqCallbackDelegate, MPMediaPickerControllerDelegate, UIScrollViewDelegate>
{
    MBProgressHUD *progressHud;

    UIView *noDataView;
    UIView *noNetworkV;
    
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
    //2019.11.15 by zhenguo 
    BOOL _isPlaying;
    float _total; //总时间
}

// 背景scrollview
@property (nonatomic,retain) UIScrollView *scrollView;

// 广播上方背景图片
@property (nonatomic,retain) UIImageView *imgView_bg;

// 广播标题
@property (nonatomic, retain) UILabel *label_title;

// 广播人
@property (nonatomic, retain) UILabel *label_creater;

// 广播内容
@property (nonatomic, strong) MPMoviePlayerController *movie_content;

// 广播id
@property (nonatomic,retain) NSString *nid;

// 播放url
@property (nonatomic,retain) NSURL *playUrl;

// 模块名字
@property (nonatomic,retain) NSString *moduleName;

// 数据model
@property (nonatomic,retain) BroadcastModel *model;

@property (nonatomic,retain) NSString *otherSid;//其他学校的sid add by kate 2015.04.22

// 有问题时候的提示文案
@property (nonatomic, retain) UILabel *label_errMsg;

// 控件是否是已经初始化完毕
@property (nonatomic,retain) NSString *isInit;

@property(nonatomic,strong) NSString *mid;//模块id 用于存贮lastid 2015.11.12
@property(nonatomic,strong) NSDictionary *newsDic;//2015.11.12

 // 2019.11.15 by zhenguo 用于音频播放修改
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,weak) UIImageView *musicImageView;
@property (nonatomic,weak) UIButton *playButton;
@property (nonatomic,weak) UILabel *beginTimeLabel;
@property (nonatomic,weak) UILabel *endTimeLabel;
@property (nonatomic,weak) UISlider *progressSlider;
@property (nonatomic,assign) __block BOOL isSliderTouch;

@end
//
//  SightPlayerViewController.h
//  VideoRecord
//
//  Created by CheungStephen on 4/7/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

#import "SightDecode.h"
#import "NetworkUtility.h"
#import "BaseViewController.h"
#import "Utilities.h"

@interface SightPlayerViewController : BaseViewController

@property(nonatomic,retain) NSURL * videoURL;

// 是否是本地的视频
@property(nonatomic,assign) BOOL isLocalUrl;


@property(nonatomic,retain) NSMutableArray *imagesAry;

@property(nonatomic,retain) AVPlayer *player;
@property(nonatomic,retain) AVPlayerLayer *playerLayer;
@property(nonatomic,retain) AVPlayerItem *playerItem;

@property(nonatomic,retain) UIImageView* playImg;

@property(nonatomic, retain) UIView *alphaView;

@end

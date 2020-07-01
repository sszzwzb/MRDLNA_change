//
//  CCTVViewController.h
//  MicroSchool
//
//  Created by jojo on 15/8/24.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

//#import "RTSPPlayer.h"

@interface CCTVViewController : BaseViewController
{
    float lastFrameTime;
}

@property(nonatomic,retain) NSString *titleName;

//@property (nonatomic, retain) RTSPPlayer *rtspPlayer;
@property (nonatomic, retain) NSString *playUrl;

@property (nonatomic, retain) NSString *isReadyPlay;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSTimer *nextFrameTimer;

@end

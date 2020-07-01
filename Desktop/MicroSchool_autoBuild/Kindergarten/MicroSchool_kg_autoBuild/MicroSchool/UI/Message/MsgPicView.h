//
//  MsgPicView.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ChatDetailObject.h"
#import "GroupChatDetailObject.h"// add 2015.05.29
#import "HJShapedImageView.h"
#import "MixChatDetailObject.h"

@interface MsgPicView : UIView
{
    //背景pop
    UIImageView *bgView;
    //UIImageView *showImgView;
    HJShapedImageView *showImgView;//add 2015.07.16
    UIImage *bgImgSend;
    UIImage *bgImgRcv;
    ChatDetailObject *entityForpic;
    //UIView *coverView;
    
    HJShapedImageView *coverView;//add 2015.07.17
}

@property (nonatomic, retain) UIImageView *bgView;
//@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) HJShapedImageView *showImgView;//update 2015.07.16
@property (nonatomic, retain) UIImage *bgViewRcv;
@property (nonatomic, retain) UIImage *bgViewSend;
@property (nonatomic, retain) UIImage *bgImgSend;
@property (nonatomic, retain) UIImage *bgImgRcv;
@property (nonatomic, retain) ChatDetailObject *entityForpic;
@property (nonatomic, retain) UIView *coverView;

// 更新聊天画面
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity;

// 取得图片的大小
- (CGSize)getPicSizeWithImage:(UIImage *)image;

- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity;// 2015.05.29

- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity;// add 2016.01.19

@property (nonatomic,retain) GroupChatDetailObject *entityForGroup;//add by kate 2015.06.01
@property (nonatomic, retain) MixChatDetailObject *entityForMix;// add 2016.01.19
@end

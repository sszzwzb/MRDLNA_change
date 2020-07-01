//
//  UIHeadImage.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObject.h"
#import "UIImageView+WebCache.h"

@protocol HeadImageDelegate;

@interface UIHeadImage : UIImageView <UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    long long _user_id;                      //头像的UUID
    NSString *_imagePath;                 //头像的本地地址
    NSInteger _Radius;                    //圆角
    NSString *_url;
    id <HeadImageDelegate> delegate;
    BOOL isServer;
}

@property (nonatomic, retain) NSString *imgPath;         //头像路径
@property (nonatomic, assign) long long user_id;           //图像user_id
@property (nonatomic, assign) id <HeadImageDelegate> delegate;

- (void)setRound:(NSInteger)radius;

//初始化对象
- (void)setMember:(long long)user_id;
//初始化对象
//- (void)setMember:(UserObject*)user uid:(long long)user_id;
@end

@protocol HeadImageDelegate <NSObject>

@optional

- (void)touchImage;//单击头像
-(void)touchLongImage;//长按头像at某人 //用于判断长按 2016.07.06

@end


//
//  UIHeadImage.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "UIHeadImage.h"
#import "PublicConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "DBDao.h"
#import "FRNetPoolUtils.h"
#import "UIImageView+WebCache.h"

@implementation UIHeadImage

@synthesize user_id = _user_id;
@synthesize imgPath = _imagePath;
@synthesize delegate;


#pragma mark -
#pragma mark 初始化

- (id)initWithFrame:(CGRect)frame;
{
    //初始化画面大小
	self = [super initWithFrame:frame];
    
    if (self) {
        _Radius = 0;
        self.layer.cornerRadius = _Radius;
        self.layer.masksToBounds = YES;
        _url =[[NSString alloc] initWithString:@""];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(atSomebody:)];
        longPressRecognizer.delegate = self;
        [longPressRecognizer setMinimumPressDuration:1.0];
        [self addGestureRecognizer:longPressRecognizer];
        
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserInfo:)];
        singleTouch.delegate = self;
        [self addGestureRecognizer:singleTouch];
        
    }

    return self;
}

/*- (void)setMember:(long long)user_id
{
    self.user_id = user_id;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myUserID = [Utilities replaceNull:[userDefaults objectForKey:@"MyUserID"]];
    
    if ([myUserID isEqualToString:[NSString stringWithFormat:@"%lli", self.user_id]]) {
        // 目前乘客端没有头像，显示默认头像
        self.image = [UIImage imageNamed:@"bg_head"];
    } else {
        // 顾问的头像
        [self getUserInfoWithUserID:user_id];
    }
}*/

- (void)setMember:(long long)user_id
{
    self.user_id = user_id;
    
    GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;;
    NSDictionary *message_info = [g_userInfo getUserDetailInfo];
    NSString* userid = [message_info objectForKey:@"uid"];
    long long uid = [userid longLongValue];
    
    if (uid == user_id) {
        
    } else {
        
        [self getUserInfoWithUserID:user_id];
        
    }

}

/*- (void)setMember:(UserObject*)user uid:(long long)user_id
{
    self.user_id = user_id;

    GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;;
    NSDictionary *message_info = [g_userInfo getUserDetailInfo];
    NSString* userid = [message_info objectForKey:@"uid"];
    long long uid = [userid longLongValue];
    
    if (uid == user_id) {
        
    } else {
        // 顾问的头像
        [self getUserInfoWithUserID:user];
        
    }
}*/


- (void)getUserInfoWithUserID:(long long)user_id
{

    UserObject *localUser = [UserObject getUserInfoWithID:user_id];
    if (localUser && [localUser.headimgurl length] > 0) {
        // 从服务器拉取头像
        NSString *imageName = [localUser.headimgurl lastPathComponent];
        NSString *imagePath = [Utilities getHeadImagePath:self.user_id imageName:imageName];
        if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                self.image = image;
            } else {
                // 没有头像的话显示默认头像
                self.image = [UIImage imageNamed:@"icon_avatar_big.png"];
            }
        }
    } else {
        // 没有头像的话显示默认头像
        self.image = [UIImage imageNamed:@"icon_avatar_big.png"];
    }
    
//    if(!isServer){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UserObject *serverUser = [FRNetPoolUtils getSalesmenWithID:user_id];
            if (serverUser && [serverUser.headimgurl length] > 0) {
                // 从服务器拉取头像
                NSString *imageName = [serverUser.headimgurl lastPathComponent];
                NSString *imagePath = [Utilities getHeadImagePath:self.user_id imageName:imageName];
                if ([imagePath length] > 0) {
                    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        NSString *userHeadUrl = [[NSString alloc] initWithFormat:@"%@", serverUser.headimgurl];
                        [FRNetPoolUtils getImgWithUrl:userHeadUrl picType:PIC_TYPE_HEAD userid:user_id msgid:0];
                        [userHeadUrl release];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 从服务器拉取头像
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                            if (image) {
                                self.image = image;
                            } else {
                                // 没有头像的话显示默认头像
                                self.image = [UIImage imageNamed:@"icon_avatar_big.png"];
                            }
                        }
                       // isServer = YES;
                    });
                }
            }
        });

 //   }
    
}

/*- (void)getUserInfoWithUserID:(UserObject*)user
{
    
    
    UserObject *localUser = user;
    if (localUser && [localUser.headimgurl length] > 0) {
        // 从服务器拉取头像
        NSString *imageName = [localUser.headimgurl lastPathComponent];
        NSString *imagePath = [Utilities getHeadImagePath:self.user_id imageName:imageName];
        if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                self.image = image;
            } else {
                // 没有头像的话显示默认头像
                self.image = [UIImage imageNamed:@"bg_head"];
            }
        }
    } else {
        // 没有头像的话显示默认头像
        self.image = [UIImage imageNamed:@"bg_head"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserObject *serverUser = user;
        if (serverUser && [serverUser.headimgurl length] > 0) {
            // 从服务器拉取头像
            NSString *imageName = [serverUser.headimgurl lastPathComponent];
            NSString *imagePath = [Utilities getHeadImagePath:self.user_id imageName:imageName];
            if ([imagePath length] > 0) {
                if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                    NSString *userHeadUrl = [[NSString alloc] initWithFormat:@"%@", serverUser.headimgurl];
                    //[FRNetPoolUtils getImgWithUrl:userHeadUrl picType:PIC_TYPE_HEAD userid:[user.user_id longLongValue] msgid:0];
                    [FRNetPoolUtils getPicWithUrl:userHeadUrl picType:PIC_TYPE_HEAD userid:user.user_id msgid:0];
                    [userHeadUrl release];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 从服务器拉取头像
                    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                        if (image) {
                            self.image = image;
                        } else {
                            // 没有头像的话显示默认头像
                            self.image = [UIImage imageNamed:@"bg_head"];
                        }
                    }
                });
            }
        }
    });
}*/


- (void)dealloc
{
    self.imgPath = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark 设置头像，刷新画面

- (void)setRound:(NSInteger)radius
{
    _Radius = radius;
    self.layer.cornerRadius = _Radius;
    if (_Radius > 0) {
        self.layer.masksToBounds = YES;
    }else {
        self.layer.masksToBounds = NO;
    }
}

/*#pragma mark -
#pragma mark touch 事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (delegate) {
        if ([delegate respondsToSelector:@selector(touchImage)]) {
			[delegate touchImage];
        }
    }
}*/


-(void)gotoUserInfo:(UITapGestureRecognizer *)gestureRecognizer{
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(touchImage)]) {
            
            [delegate touchImage];
        }
        
    }
    
}

-(void)atSomebody:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    //避免长按执行两次 判断state
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (delegate) {
            
            if ([delegate respondsToSelector:@selector(touchLongImage)]) {
                
                [delegate touchLongImage];
            }
        }
    }
    
    
}

@end


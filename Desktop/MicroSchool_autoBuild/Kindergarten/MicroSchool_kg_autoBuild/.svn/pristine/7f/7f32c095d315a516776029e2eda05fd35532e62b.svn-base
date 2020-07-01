//
//  BaseViewController.h
//  AppTemplate
//
//  Created by Stephen Cheung on 13-8-7.
//  Copyright (c) 2013年 Stephen Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utilities.h"
#import "NetworkUtility.h"
#import "TSNetworking.h"
#import "GlobalSingletonUserInfo.h"
#import "PublicConstant.h"
#import "DataReport.h"
#import "TSAlertView.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "TSTapGestureRecognizer.h"
#import "UIGuidelineDefine.h"
#import "TSTableView.h"
#import "TSPopupView.h"

// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface BaseViewController : UIViewController
{
    NetworkUtility *network;
    
    GlobalSingletonUserInfo* g_userInfo;
    
    UIImageView *imgView_leftLine;
    UIImageView *imgView_rightLine;
}
-(void)setCustomizeLongRightButtonWithName:(NSString*)name color:(UIColor *)color;
-(void)setCustomizeTitle:(NSString *)title font:(UIFont*)font;//add by kate 2016.03.22
-(void)setCustomizeTitle:(NSString *)title;
-(void)setCustomizeBackgroundImg:(NSString *)path;

-(void)setCustomizeLeftButton;
-(void)setCustomizeLeftButtonWithName:(NSString*)name;
-(void)setCustomizeLeftButtonWithImage:(NSString*)imageName;
-(void)setBackImage:(NSString*)imageName;//乐园页面webview二级页面调用此方法修改头像
-(void)setRedPointHidden:(BOOL)isHidden;

-(void)setCustomizeRightButton;
-(void)setCustomizeRightButton:(NSString*)fileName;
-(void)setCustomizeRightButtonWithName:(NSString*)name;
-(void)setCustomizeRightButtonWithName:(NSString*)name font:(UIFont*)font;
-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color;

-(void)selectLeftAction:(id)sender;
-(void)selectRightAction:(id)sender;

-(void)hideKeyBoard;
-(BOOL)dismissAllKeyBoardInView:(UIView *)view;

-(void)forbiddenLeftAndRightKey;
-(void)enableLeftAndRightKey;

-(void)showLeftLine;
-(void)hideLeftLine;
-(void)hideLeftAndRightLine;

@property (nonatomic, retain) UIImageView *redPointOnNavigationBar;

@end

//
//  MyTabBarController.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolHomeViewController.h"
#import "ParksHomeViewController.h"
#define UPDATE_BADGE_VALUE @"UPDATE_BADGE_VALUE"

@interface MyTabBarController : UITabBarController<UIGestureRecognizerDelegate>
{
	NSMutableArray *buttons;
	int currentSelectedIndex;
    int beforeSelectedIndex;
    UIImageView *bgImageView;
    
    // 3 button
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
    UIButton *button_addFriend;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    
    UIView *centerView; // modify by kate 2014.08.17
    
    UIButton *button_center;
  

}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSMutableArray *tabLables;
/* 设置tabBar是否隐藏 */
+ (void)setTabBarHidden:(BOOL)bHide;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)setTabButtonBgImage:(UIButton *)button;
- (void)setPressButtonBgImage:(int)buttonIndex;
- (void)setTabTitle;
- (id)initWithSelectIndex:(NSInteger)Index;

@end


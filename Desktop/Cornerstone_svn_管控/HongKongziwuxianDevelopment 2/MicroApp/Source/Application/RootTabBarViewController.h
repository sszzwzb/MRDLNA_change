//
//  RootTabBarViewController.h
//  CarHome
//
//  Created by kaiyi on 2017/12/7.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarViewController : UITabBarController

@property (nonatomic, assign) int currentSelectedIndex;  //  当前

/* 设置tabBar是否隐藏 */
+ (void)setTabBarHidden:(BOOL)bHide;

- (void)hideRealTabBar;
//- (void)customTabBar;
//- (void)selectedTab:(UIButton *)button;
//- (void)setTabButtonBgImage:(UIButton *)button;
//- (void)setPressButtonBgImage:(int)buttonIndex;
//- (void)setTabTitle;
//- (id)initWithSelectIndex:(NSInteger)Index;

@end

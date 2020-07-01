//
//  BaseViewController.h
//  NewMicroSchool
//
//  Created by kaiyi on 2017/8/24.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseTableView.h"

@interface BaseViewController : UIViewController
{
    AFNNetworkUtility *network;
}

-(void)selectLeftAction:(id)sender;
-(void)selectRightAction:(id)sender;
-(BOOL)gestureRecognizerShouldBegin;


-(void)setCustomizeTitle:(NSString *)title;
-(void)setCustomizeTitle:(NSString *)title bgImg:(NSString*)bgImgName;
-(void)setCustomizeTitle:(NSString *)title bgImg:(NSString*)bgImgName titleColor:(UIColor*)color;

-(void)setCustomizeSearchBarTitle:(NSString *)title;
-(void)setCustomizeSearchBarButTitle:(NSString *)title;
-(void)selectSearchBarButAction:(id)sender;


-(void)setCustomizeLeftButton;
-(void)setCustomizeLeftButtonWithName:(NSString*)name;
-(void)setCustomizeLeftButtonWithName:(NSString*)name color:(UIColor*)color;
-(void)setCustomizeLeftButtonChoiceImage:(NSString*)imageName;
-(void)setCustomizeLeftButtonChoiceDownArrowButtonWittName:(NSString*)name;  //  带向下箭头的
-(void)hideLeftButton;


-(void)setCustomizeRightButton;
-(void)setCustomizeRightButtonWithName:(NSString*)name;
-(void)setCustomizeRightButtonWithName:(NSString*)name font:(UIFont*)font;
-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color;
-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color width:(CGFloat)width;
-(void)setCustomizeRightButtonChoiceImage:(NSString*)imageName;
-(void)setCustomizeRightButtonChoiceImageUrl:(NSString*)imageUrl placeholderImage:(NSString *)placeholderImage isRound:(BOOL)round;  //  网络圆角图片
-(void)setCustomizeRightButtonChoiceImage1:(NSString*)image1 image2:(NSString*)image2 image3:(NSString*)image3;  //  三个本地图片


@end

//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h



#define KScreenWidth        [UIScreen mainScreen].bounds.size.width
#define KScreenHeight       [UIScreen mainScreen].bounds.size.height


// 判断是否是iPhone X
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否是iPhone X /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
//([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 ? YES :NO)
#define iPhoneX ({BOOL is_iPhoneX = NO;if (@available(iOS 11.0, *)) {is_iPhoneX = ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 ? YES :NO);}is_iPhoneX;})


// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define KScreenNavigationBarHeight (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define KScreenTabBarHeight (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define KScreenTabBarIndicatorHeight (iPhoneX ? 34.f : 0.f)




#define rgba(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define rgb(r,g,b)          rgba(r,g,b,1.0)

#define UIColorFromRGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



//    默认字体
#define FONT(F) [UIFont systemFontOfSize: F]

//方正黑体简体字体定义
#define FONT_F(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//字很小  字体
#define FONT_A(F)   [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:F]

//字体加粗
#define FONT_B(F) [UIFont boldSystemFontOfSize:F]






#define color_black         rgb(51, 51, 51)  //  黑色
#define color_blue          rgb(2, 146, 246)  //  蓝色
#define color_blue2         rgb(17, 146, 246)  //  蓝色
#define color_gray          [UIColor lightGrayColor]  //  灰色
#define color_gray2         rgb(160, 160, 160)  //  灰色 2 ,深灰
#define color_green         rgb(19, 202, 208)  //  绿色
#define color_grayBG        rgb(247, 247, 247)  //  灰色 背景，非通用

#define color_blackAlpha    rgba(1, 1, 1, 0.4)  //  黑色

#define color_orangeL       rgb(255, 101, 0)  //  橘黄色L
#define color_orangeR       rgb(255, 171, 0)  //  橘黄色R

#define color_red           rgb(255, 0, 0)  //   纯红色

#define color_purple        rgb(185, 51, 255)  //   紫色



#define TEXT_NONETWORK @"网络出错了，请检查网络"





















#define DEBUG       1


#ifdef DEBUG
#define CLog(fmt, ...) NSLog((@"%s [Line: %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define CLogwt(tag, fmt, ...) NSLog((@"[%@](%d) " fmt), tag, __LINE__, ##__VA_ARGS__)
#else
#define CLog(fmt, ...)
#define CLogwt(tag, fmt, ...)
#endif











//TODO 提示
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
// 最终使用下面的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


#endif

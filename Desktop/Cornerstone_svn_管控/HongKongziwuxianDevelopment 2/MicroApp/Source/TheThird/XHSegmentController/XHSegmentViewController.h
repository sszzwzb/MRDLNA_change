//
//  XHSegmentViewController.h
//  ShouChouJin
//
//  Created by xihe on 15/9/23.
//  Copyright © 2015年 ouer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentControl.h"

#import "BaseViewController.h"

@interface XHSegmentViewController : BaseViewController

@property(nonatomic, strong, readonly) XHSegmentControl   *segmentControl;   //   button
@property(nonatomic, strong, readonly) UIScrollView       *scrollView;  //   界面

//  segment properties
@property(nonatomic)            XHSegmentType   segmentType;    //   样式
@property(nonatomic, strong)    UIImage         *segmentBackgroundImage;   //   背景图片
@property(nonatomic, strong)    UIColor         *segmentBackgroundColor;   //   背景颜色
@property(nonatomic)            CGFloat         segmentLineWidth;      //  linewidth > 0，底部高亮线
@property(nonatomic, strong)    UIColor         *segmentHighlightColor;  //   选中字体颜色
@property(nonatomic, strong)    UIColor         *segmentBorderColor;  //  下划线颜色，
@property(nonatomic)            CGFloat         segmentBorderWidth;   //  下划线高度
@property(nonatomic, strong)    UIColor         *segmentTitleColor;   //  未选中的颜色
@property(nonatomic, strong)    UIFont          *segmentTitleFont;
@property(nonatomic, strong)    NSArray         *viewControllers;  //   controller

@end

//
//  EventDetailViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FileViewerViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface EventDetailViewController : UIViewController<UIGestureRecognizerDelegate, UIWebViewDelegate>
{    
    UIButton *button;
    UIWebView* webView;
}

-(void)setDetailMsg:(NSString*)msg andPics:(NSArray *)pics;

-(void) getJoined:(NSString*) jonied andStatus:(NSString*) status andNum:(NSString*) num;
@property (retain, nonatomic) NSString *joined;

// 增加了多图滑动查看,图片数组
@property (retain, nonatomic) NSArray *pics;

@end

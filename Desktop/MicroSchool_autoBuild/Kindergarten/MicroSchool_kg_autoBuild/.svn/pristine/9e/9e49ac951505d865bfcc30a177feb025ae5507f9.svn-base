//
//  NewsDetailOtherViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FileViewerViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "NewsCommentViewController.h"

@interface NewsDetailOtherViewController : BaseViewController<UIScrollViewDelegate, HttpReqCallbackDelegate,UIGestureRecognizerDelegate, UIWebViewDelegate>{
    
    UILabel *label_titil;
    UILabel *label_date;
    UIImageView *imgView_line;
    
    NSString *_titleName;
    UIWebView* webView;
}

- (id)initWithVar:(NSString *)newsName;

@property (retain, nonatomic) NSString *newsid;
@property (retain, nonatomic) NSString *newsDate;

@property (retain, nonatomic) NSString *updatetime;
// 增加了多图滑动查看,图片数组
@property (retain, nonatomic) NSArray *pics;
@property(nonatomic,strong)NSString *otherSid;//其他学校学校id

// 自定义公告的btn
@property (retain, nonatomic) UIButton *btn_comment;

@end

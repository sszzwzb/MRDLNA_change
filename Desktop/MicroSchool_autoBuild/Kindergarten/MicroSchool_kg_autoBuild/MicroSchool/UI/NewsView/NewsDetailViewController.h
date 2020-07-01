//
//  NewsDetailViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-11.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "NewsDetailObject.h"
#import "NewsDetailDBDao.h"
#import "NewsListDBDao.h"

#import "FileViewerViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "NewsCommentViewController.h"

@interface NewsDetailViewController : BaseViewController <UIScrollViewDelegate, HttpReqCallbackDelegate,UIGestureRecognizerDelegate, UIWebViewDelegate>
{
    UILabel *label_titil;
    UILabel *label_author;
    UILabel *label_viewnum;

    UILabel *label_date;
    UIImageView *imgView_line;
    
    NSString *_titleName;
    UIWebView* _webView;
}

- (id)initWithVar:(NSString *)newsName;

@property (retain, nonatomic) NSString *newsid;
@property (retain, nonatomic) NSString *newsDate;

// 新闻类模块id
@property (retain, nonatomic) NSString *newsMid;

@property (retain, nonatomic) NSString *updatetime;

// 增加了多图滑动查看,图片数组
@property (retain, nonatomic) NSArray *pics;

// 内链链接显示 innerLink
@property (retain, nonatomic) NSString *viewType;

// 内链链接的请求的参数
@property (retain, nonatomic) NSDictionary *innerLinkReqData;

// 自定义公告的btn
@property (retain, nonatomic) UIButton *btn_comment;

// 浏览次数
@property (retain, nonatomic) NSString *viewNum;
@property (retain, nonatomic) UIImageView *imgView_viewnum;

@property (assign, nonatomic) BOOL isEduinspectorNews;

#if BUREAU_OF_EDUCATION
@property (retain, nonatomic) NSString *schoolName;
@property (retain, nonatomic) UIImageView *imgView_schoolType;
@property (retain, nonatomic) NSString *schoolCount;

@property(nonatomic,strong) NSString *newsType;
#endif
//Chenth 6.8 下发通知详情页 改接口新增一个条件判定
@property (nonatomic, assign) BOOL isFromDownNotification;
@property (nonatomic, strong) NSString *seeCount;
@end

//
//  KnowledgeDetailViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "KnowledgeCommentViewController.h"
#import "EduModuleDetailViewController.h"
#import "KnowledgeDetailModel.h"
#import "AuthorZoneViewController.h"

#import "FileViewerViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "UIImageView+WebCache.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface KnowledgeDetailViewController : BaseViewController<UIScrollViewDelegate, HttpReqCallbackDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    UIScrollView* _scrollerView;
    
    UILabel *label_name;
    UILabel *label_school;

    UIImageView *imgView;
    
    UIButton *button_collect;
    UIWebView *webViewContent;
    UIWebView *webViewContentHiden;
    float webHight;

    UIImageView *imgView_line2;
    
    UIButton *button_thanks;
    UIButton *button_noHelp;
    UIButton *button_collection;
    UIButton *button_comment;

//    NSMutableDictionary *detailInfo;
    
    NSInteger likeFlag;
    NSInteger collectionFlag;
    
    NSString *aaa;
}

@property (retain, nonatomic) NSString *tid;
@property (retain, nonatomic) NSString *subuid;

// 标题
@property (nonatomic,retain) UILabel *label_title;

// 数据model
@property (nonatomic,retain) KnowledgeDetailModel *model;

// 点击喜欢或者不喜欢
@property (retain, nonatomic) NSString *goodOrBadClicked;

// 点击去作者空间
@property (retain, nonatomic) UIButton *button_toAuthor;

// 增加了多图滑动查看,图片数组
@property (retain, nonatomic) NSArray *pics;

@end

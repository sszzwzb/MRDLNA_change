//
//  EduModuleDetailViewController.h
//  MicroSchool
//
//  Created by jojo on 14-8-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "FileViewerViewController.h"

@interface EduModuleDetailViewController : BaseViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView* webView;
}

@property (retain, nonatomic) NSString *detailInfo;
@property (retain, nonatomic) NSURL *requestURL;

@property (retain, nonatomic) NSString *titlea;

@end

//
//  ParksHomeViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface ParksHomeViewController : BaseViewController<EGORefreshTableDelegate,UIWebViewDelegate,UIScrollViewDelegate,HttpReqCallbackDelegate>{
    NSString *isNewVersion;
    NSInteger reflashFlag;
    BOOL _reloading;
    BOOL isRefresh;//检查是否是下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIView *noDataView;
    UIWebView *webView;

}
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIImageView *noRecipesView;

@end

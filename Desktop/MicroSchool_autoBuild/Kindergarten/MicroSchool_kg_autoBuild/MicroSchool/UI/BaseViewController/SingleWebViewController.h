//
//  SingleWebViewController.h
//  MicroSchool
//
//  Created by jojo on 14/12/2.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FRNetPoolUtils.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MyTabBarController.h"


typedef NS_ENUM(NSUInteger, SWType) {// 2015.09.23
    
    SWLoadRequest         = 0,// 需要传requestURL的 NSString类型 可转义 默认值 不传就走这个分支
    SWSubsribe            = 1,// 校园导读
    SWLoadURl             = 2,// 需要传url的 NSURL类型
    SWLoadHtml            = 3,// 需要传loadHtmlStr的
    SWFile                = 4,// 显示File的webview  需要传url的 NSURL类型 背景色不一致
    
};

@interface SingleWebViewController : BaseViewController<UIWebViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    
    UIWebView* currentWebView;
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;

    
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
    UIButton *button_addFriend;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    
    UIButton *closeBtn;
    
    BOOL isClose;
    
    MBProgressHUD *HUD;
    NSDictionary *diction;
    
    NSArray *pics;//连续查看大图数组 从校园订阅来
}

@property (retain, nonatomic) NSString *requestURL;
@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) NSString *loadHtmlStr;
@property (retain, nonatomic) NSString *isShowSubmenu;

@property (retain, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSString *fromName;// 从哪里来

@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;// 备用的现在用不着
@property (strong,nonatomic)NSString *currentHeadImgUrl;//需要传过来
@property (strong,nonatomic)NSString *aid;// 校园订阅 订阅新闻id
//Chenth 5.23
@property (nonatomic, assign) BOOL hideBar;
@property (retain, nonatomic) NSString *isRotate;

@property (nonatomic, assign) SWType webType;//加载类型 2015.09.23
@property (nonatomic, assign) BOOL closeVoice;
@property (nonatomic, assign) BOOL isFromEvent;

@end

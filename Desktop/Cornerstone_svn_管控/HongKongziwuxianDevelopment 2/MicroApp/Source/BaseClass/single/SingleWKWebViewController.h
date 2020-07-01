//
//  SingleWKWebViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/4/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, SWKWType) {// 2015.09.23
    
    SWKWLoadRequest         = 0,// 需要传requestURL的 NSString类型 可转义 默认值 不传就走这个分支
    SWKWLoadRequestHidden   = 1,// 隐藏StaBar的正常请求
    SWKWLoadRequestClose    = 2,// 带关闭的
    
};

@interface SingleWKWebViewController : BaseViewController

@property (nonatomic, assign) SWKWType webType;//加载类型

@property (strong,nonatomic) NSString *fromName;
@property (strong,nonatomic) NSString *requestURL;


@property (nonatomic,assign) BOOL isPreviousNavBarIsHiddenAndBackIsShow;  //  进来之前的状态是隐藏 NavTab 出去的时候也隐藏  用于SWKWLoadRequest

@end

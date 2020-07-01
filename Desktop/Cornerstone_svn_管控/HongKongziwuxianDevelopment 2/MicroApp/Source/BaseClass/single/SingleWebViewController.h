//
//  SingleWebViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/4/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, SWType) {// 2015.09.23
    
    SWLoadRequest         = 0,// 需要传requestURL的 NSString类型 可转义 默认值 不传就走这个分支
    SWLoadRequestHidden   = 1,// 隐藏StaBar的正常请求
    SWLoadRequestClose    = 2,// 带关闭的
    SWLoadRequestSingle   = 3,// 禁止页面跳转的 SWLoadRequest
};

@interface SingleWebViewController : BaseViewController

@property (nonatomic, assign) SWType webType;//加载类型

@property (strong,nonatomic) NSString *fromName;
@property (strong,nonatomic) NSString *requestURL;

@end

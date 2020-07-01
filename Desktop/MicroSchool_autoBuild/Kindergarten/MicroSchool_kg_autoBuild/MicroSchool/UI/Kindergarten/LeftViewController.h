//
//  LeftViewController.h
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SchoolHomeViewController.h"

@protocol LeftDelegate<NSObject>
- (void)deleteCell:(NSString*)str;
@end

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *pointsDic;
    NSString *isNewFeedback;
    NSMutableDictionary *personalInfo;
    UIImageView *MyMsgsImgView;

}

@property(nonatomic,strong)NSMutableArray *itemsArr;
@property(nonatomic,retain) UIImageView *settingImgView;
@property (nonatomic, strong) NSString *payUrl;
@property (strong, nonatomic) id<LeftDelegate>cellDelegate;

@end

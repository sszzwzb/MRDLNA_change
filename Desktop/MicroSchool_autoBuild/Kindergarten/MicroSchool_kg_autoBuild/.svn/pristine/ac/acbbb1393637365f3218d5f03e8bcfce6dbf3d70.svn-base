//
//  TSProgressHUD.h
//  MicroSchool
//
//  Created by jojo on 15/4/16.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "TSNetworking.h"

@interface TSProgressHUD : NSObject

// singleton
+ (instancetype)sharedClient;

- (void)doShowProcessingHud:(UIView *)descV;
- (void)doShowFirstLoadProcessingHud:(UIView *)descV;
- (void)doShowSystemProcessingHud:(UIView *)descV;
- (void)doDismissProcessingHud:(UIView *)descV;

- (void)doShowSuccessedHud:(NSString *)text descView:(UIView *)descV;
- (void)doShowFailedHud:(NSString *)text descView:(UIView *)descV;
- (void)doShowTextHud:(NSString *)text descView:(UIView *)descV;

- (void)doShowTSNetworkingErr:(TSNetworkingErrType)errType descView:(UIView *)descV;

#if 0
// 计划将整个hud做成一个单例，但是在多个hud一起加载时，消除会出问题
// 业务上这个可以避免，先做成多个hud的实例，但是这个类还是需要保持单例，简化管理流程
@property (retain, nonatomic) MBProgressHUD *processingHud;

@property (assign, nonatomic) BOOL isShowing;
@property (assign, nonatomic) NSInteger processingCnt;
#endif

@end

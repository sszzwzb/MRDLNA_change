//
//  QHCamRelayInfoService.h
//  QHCamSDK
//
//  Created by chengbao on 16/4/4.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHCamError;
@class QHCamBaseInfo;

/**
 * 播放器播放视频时需要的参数
 *
 */
@interface QHCamRelayInfo : NSObject

@property (strong, nonatomic) NSString *sig;
@property (strong, nonatomic) NSString *playKey;
@property (strong, nonatomic) NSString *relayId;
@property (strong, nonatomic) NSString *relayStr;

@end


/**
 * 用来获取QHCamRelayInfo的类
 *
 */
@interface QHCamRelayInfoService : NSObject


+ (instancetype)shareInstance;

/**
 * 请求QHCamRelayInfo
 *
 * @param cameraInfo 设置要获取的摄像机的信息 @see QHCamBaseInfo
 * @param callback 回调的block
 *
 */
- (void)reqVideoPlayInfo:(QHCamBaseInfo *)cameraInfo callback:(void(^)(QHCamRelayInfo *relayInfo, QHCamError* err))playInfoBlock;

@end

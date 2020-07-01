//
//  QHCamAddCamera.h
//  QHCamSDK
//
//  Created by chengb on 16/3/5.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHCamError.h"

typedef void(^SendComplete)(BOOL successful);

@interface QHCameraInfo : NSObject

@property (nonatomic, strong) NSString *sn;

@end

@interface QHCamAddCamera : NSObject

/**
 * 将用户的wifi等信息以声波的形式发送给摄像头，摄像头收到信息后会自动连接到服务器，从而完成app和摄像头硬件的配对
 *
 * @param ssid wifi的名称
 * @param password wifi的密码
 * @param timestamp 当前时间， 可以通过下面方法取得： (long long)[[NSDate date] timeIntervalSince1970]
 * @param uid 用户id
 * @param complete 声波发送完毕的回调
 *
 */

- (void)sendWav:(NSString*)ssid password:(NSString*)password timestamp:(long long)timestamp uid:(NSString*)uid complete:(SendComplete)complete;

/**
 * 绑定摄像头
 *
 * @param timestamp         时间戳
 * @param resultBlock       绑定结束回调，isSuccess为0表示绑定成功，其它值表示绑定失败。
 * @param resultBlock       绑定结束回调，cameraInfo不为nil表示绑定成功，error不为nil表示绑定失败。
 *
 */
-(void)bindDeviceTS:(NSString*)timestamp success:(void(^)(int isSuccess))resultBlock;/*<此接口废弃，为兼容以前暂时保留。用下面的接口*/
-(void)bindDeviceTS:(NSString*)timestamp callback:(void(^)(QHCameraInfo *cameraInfo, QHCamError *error))resultBlock;

@end

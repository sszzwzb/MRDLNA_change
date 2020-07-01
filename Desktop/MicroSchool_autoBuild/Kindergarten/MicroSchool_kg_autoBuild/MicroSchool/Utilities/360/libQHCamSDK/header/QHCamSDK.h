//
//  QHCamSDK.h
//  QHCamSDK
//
//  Created by chengbao on 16/3/3.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum __tagQHCamSDKCommonErr
{
    QHCamSDKCommonErr_None = 0,                  //没有错误发生
    QHCamSDKCommonErr_Params = -101000,          //参数不正确
    QHCamSDKCommonErr_NOAuth,                    //没有配置正确的appID和appKey
    QHCamSDKCommonErr_User,                      //设置的user 信息不正确
    
    QHCamSDKCommonErr_NoSupport = - 110000,      //此功能不支持
}QHCamSDKCommonErr;


@interface QHCamSDK : NSObject


/**
 * 设置分配给第三方app的appID和appKey, 360sdk会分配给每个app一个唯一id和appKey，用来鉴权用
 * 在使用QHCamSDK前，必须要调用下面函数，设置appID和appKey
 *
 * @param appID 用来表示唯一的一个第三方应用，建议用第二个接口，appID现在改成字符串了，兼容原来的数字性appID.
 * @param appKey 用来校验是否和appID相互配对
 *
 * @return 配置成功，返回YES， 失败返回NO
 *
 */
+ (QHCamSDKCommonErr)configAppID:(int)appID appKey:(NSString *)appKey;
+ (QHCamSDKCommonErr)configStringAppID:(NSString *)appID appKey:(NSString *)appKey;


/**
 * 配置当前浏览摄像头用户的信息，当前只能一组值生效，当再次调用时， 之前设置的值将会无效
 *
 * @param uid 用户ID, 是第三方app的用户ID
 * @param pushKey 用来加解密长链中传输的数据
 * @param usid QHCam服务器对应于uid的用户id
 *
 * @return 传入值不正确时， 返回NO， 否则返回YES
 */
+ (QHCamSDKCommonErr)configUserInfo:(NSString *)uid pushKey:(NSString *)pushKey usid:(NSString *)usid;


/**
 * 获取当前的uid
 *
 * @return 返回设置的uid， 如果没有设置，则返回nil
 */
+ (NSString *)currentUid;

/**
 * 获取当前的appId
 *
 * @return 返回设置的appId， 如果没有设置，则返回nil
 */
+ (NSString *)currentAppid;

/**
 * 调用下面函数可以用来开启debug模式，debug的信息会打印处理。
 * 默认，QHCamSDK处于关闭debug模式
 *
 * @param enble YES表示开启debug模式， NO表示关闭debug模式
 */
+ (void)debugEnble:(BOOL)enble;


/**
 * 获取当前sdk的版本号
 * 
 * @return NSString 返回版本号信息
 */
+ (NSString *)sdkVersion;


@end


#import "QHCamLivePlayer.h"
#import "QHCamRecordPlayer.h"
#import "QHCamAddCamera.h"
#import "QHCameraSettingService.h"
#import "QHCamRelayInfoService.h"

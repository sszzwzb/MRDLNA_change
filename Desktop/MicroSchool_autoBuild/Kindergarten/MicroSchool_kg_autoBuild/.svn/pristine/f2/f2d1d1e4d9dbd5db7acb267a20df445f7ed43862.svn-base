//
//  QHCameraSettingService.h
//  360CameraSDK
//
//  Created by chengbao on 16/3/8.
//  Copyright © 2016年 张振-iri. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 摄像头设置信息
 *
 */
@interface QHCameraSettingInfo : NSObject

@property(nonatomic, assign, readonly) long volume;            //摄像头音量大小 0- 100
@property(nonatomic, assign, readonly) BOOL lightSwitch;       //摄像头灯是否开启 YES：开，NO：关
@property(nonatomic, assign, readonly) BOOL positionInversion; //摄像头画面是否颠倒 YES：颠倒， NO：竖立
@property(nonatomic, assign, readonly) BOOL soundSwitch;       //摄像头mic是否开启  YES：开启  NO：关闭
@property(nonatomic, assign, readonly) BOOL softPowerOff;      //摄像头软开关状态， YES：软开关关  NO：软开关开
@property(nonatomic, assign, readonly) NSString *versionName;  //摄像头的固件版本号
@property(nonatomic, assign, readonly) BOOL cloudRecord;       //此摄像头是否开启云录功能

@end




typedef void (^CameraSettingCallBack)(id value, NSError *err);

@interface QHCameraSettingService : NSObject



/**
 * 获取摄像机设置信息
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为QHCameraSettingInfo @see QHCameraSettingInfo
 */
- (void)getCameraSetting:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;


/**
 * 获取摄像机的声音状态
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber，YES为开， NO为关
 *
 */
- (void)getCameraSoundSwitch:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;


/**
 * 设置摄像机的声音状态
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber， YES为开， NO为关
 *
 */
- (void)setCameraSoundSwitch:(BOOL)on sn:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;



/**
 * 获取摄像机的声音大小
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber， 范围0 - 100
 *
 */
- (void)getCameraVolume:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;



/**
 * 设置摄像机声音音量
 *
 * @param volume 音量大小 0 - 100
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber， 范围0-100
 */
- (void)setCameraVolume:(int)volume sn:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;


/**
 * 获取摄像机灯的状态
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber, YES为开， NO为关
 *
 */
- (void)getCameraLightSwitch:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;


/**
 * 设置摄像机的灯的状态
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber,  YES为开启， NO为关闭
 *
 */
- (void)setCameraLightSwitch:(BOOL)on sn:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;



/**
 * 获取摄像机开启和关闭的软开关状态
 *
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber, YES为关闭， NO为未关闭
 *
 */
- (void)getCameraSoftPowerOffState:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;


/**
 * 设置摄像机软开关的接口
 *
 * @param on YES 关闭摄像头  NO 开启摄像头
 * @param sn 摄像机的sn
 * @param sn_token 摄像机的sn_token
 * @param callback, 如果有错误产生， 则err不为nil， value为nil， 反之， err为nil， value为non-nil，value格式为NSNumber,  YES为关闭， NO为未关闭
 *
 */
- (void)setCameraSoftPowerOffState:(BOOL)on sn:(NSString *)sn sn_token:(NSString *)sn_token callback:(CameraSettingCallBack)callback;





@end

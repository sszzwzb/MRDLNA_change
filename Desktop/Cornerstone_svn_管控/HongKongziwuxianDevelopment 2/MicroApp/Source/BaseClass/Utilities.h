//
//  Utilities.h
//  CarHome
//
//  Created by kaiyi on 2017/12/19.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"

@interface Utilities : NSObject


+(BOOL)isConnected;


/*
 hud相关.-------------------------
 */

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV;

// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV;


// 执行请求成功与否的hud。
// text为显示的文字，传nil则为默认成功与失败。
+ (void)showSuccessedHud:(NSString *)text descView:(UIView *)descV;
+ (void)showFailedHud:(NSString *)text descView:(UIView *)descV;
+ (void)showTextHud:(NSString *)text descView:(UIView *)descV;
+ (void)showMultiLineTextHud:(NSString *)title content:(NSString *)text descView:(UIView *)descV;



/*
 页面显示相关.-------------------------
 */
//
//// 空白页通用
//+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2;
//+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;
//
//
//// 空白页显示
//+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name startY:(float)start;
//+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name imgW:(float)imgWidth textColor:(UIColor*)textColor startY:(float)start;
//// 空白页消失
//+(void)dismissNodataView:(UIView*)desV;
//

// 无网络连接通用
+ (UIView*)showNoNetworkView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;


//  飞机列表页没有数据显示
+ (UIView*)showNoListView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;

+ (void)showNoListView:(NSString*)msg msg2:(NSString*)msg2 descView:(UIView *)descV isShow:(BOOL)isShow;


//  最后7个变红
+(NSAttributedString *)last7_RedWithString:(NSString *)string;


//  去掉服务器返回结果文本中的<null>  数组
+ (NSArray *)replaceArrNull:(NSArray *)arr;

// 去掉服务器返回结果文本中的<null>
+ (NSString *)replaceNull:(NSString *)source;



//  转json
+(NSString *)objectToJsonWithObject:(NSObject *)object;

//  转json str，去掉格式的str
+(NSString *)objectToJsonStringWithObject:(NSObject *)object;

// 将JSON字符串转化为字典或者数组
+ (id)JsonStrtoArrayOrNSDictionary:(id)jsonData;

//将string字符串转换为array数组
+(NSArray *)strChangeArrWithStr:(NSString *)str;

//将array数组转换为string字符串
+(NSString *)arrChangestrWithArr:(NSArray *)array;



//  Linux时间戳
//字符串转时间戳 如：  @"YYYY-MM-dd HH:mm:ss"
+ (NSString *)getTimeStrWithString:(NSString *)str;

//  NSDate时间转时间戳
+ (NSString *)getCurrentTimeStampWithNsDate:(NSDate *)date;

//  当前时间的时间戳
+ (NSString *)getCurrentTimeStampStr;





/**
 * @method
 *
 * @brief 根据路径获取视频时长和大小
 * @param path       视频路径
 * @return    字典    @"size"－－文件大小   @"duration"－－视频时长
 */
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path;

//   UIlable,自适应宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

//   UIlable,自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;



//   电话号码
+ (BOOL)isValidPhoneNumber:(NSString *)mobile;

//获得设备型号
+(NSString *)getCurrentDeviceModel;

@end

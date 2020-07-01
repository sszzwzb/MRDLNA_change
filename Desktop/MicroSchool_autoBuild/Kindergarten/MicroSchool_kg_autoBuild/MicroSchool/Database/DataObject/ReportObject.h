//
//  ReportObject.h
//  ShenMaPassenger
//
//  Created by Kate on 14-3-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportObject : NSObject
{
    /* 日志格式
     设备类型：3 android  4 IOS
     
     1.用户行为id（见上报点列表）
     2.用户行为时间（精确到秒）
     3.用户id（唯一id）
     4.用户设备id（imei）
     5.平台id（安卓/苹果）
     6.当前版本号
     7.新闻类的模块名称
     
     上报格式
     
     首次上报
     “上报点id（1001）|时间戳（秒）|学校id|用户id|imei|平台id|build号|版本号|经度|纬度|手机品牌|手机型号|OS版本号"
     
     其他上报
     “上报点id|时间戳（秒）|学校id|用户id|imei|平台id|build号|版本号|经度|纬度|新闻模块标题（可不填)"

     */
    
    NSString *timestamp;// 时间戳
    NSString *eventNo;// 上报点id
    NSString *newsModuleName;// 新闻类模块名称
    NSString *longitude;// 经度
    NSString *latitude;// 纬度
    
    
}

#pragma mark -
#pragma mark 属性

@property (nonatomic, retain) NSString *timestamp;// 时间戳
@property (nonatomic, retain) NSString *eventNo;//上报点id
@property (nonatomic, retain) NSString *newsModuleName;// 新闻类模块名称
@property (nonatomic, retain) NSString *longitude;// 经度
@property (nonatomic, retain) NSString *latitude;// 纬度
@property (nonatomic, assign) NSInteger *reportType;//上报类型

#pragma mark -
#pragma mark DB相关方法

// 其他上报 如果是新闻类需要加新闻模块的名字
+ (void)event:(NSString *)eventId module:(NSString*)name;
+ (void)event:(NSString *)eventId;

@end

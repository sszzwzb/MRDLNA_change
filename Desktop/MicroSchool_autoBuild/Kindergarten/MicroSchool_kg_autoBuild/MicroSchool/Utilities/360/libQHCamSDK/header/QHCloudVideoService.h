//
//  QHCloudVideoService.h
//  QHCamSDK
//
//  Created by dongzhiqiang on 16/5/9.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HGGetCloudListSortType_Asc  = 0,    /*<按时间升序请求数据*/
    HGGetCloudListSortType_Desc = 1     /*<按时间降序请求数据*/
}HGGetCloudListSortType;


@interface CloudVideoEventItem : NSObject

@property (nonatomic,strong)NSString *sn;               //sn号
@property (nonatomic,strong)NSString* eventId;          //事件Id  用于删除
@property (nonatomic,strong)NSString *eventCover;       //事件封面
@property (nonatomic,assign)long long eventTime;        //时间触发时间  格式：时间戳 单位:毫秒
@property (nonatomic,assign)int eventDuration;          //事件时长 格式：持续时间 单位:毫秒
@property (nonatomic,strong)NSString *eventHls;         //m3u8地址  格式：http://xxx.m3u8
@property (nonatomic,strong)NSString *playKey;          //m3u8解密key

- (id) initWithDict:(NSDictionary *)responseDict;

@end

@interface QHCloudVideoService : NSObject


/**
 *  获取事件列表接口
 *
 *  @param sn           要修改的摄像头sn
 *  @param snToken      snToken
 *  @param beginDay     请求开始日期，格式如：20160506
 *  @param endDay       请求结束日期，格式如：20160606
 *  @param page         请求页码，从0开始
 *  @param pageSize     每页数据条数
 *  @param sortType     排序规则	0：降序    1：升序
 *  @param blockResult  回调block，成功返回eventList，失败的话eventList为nil，errorMsg是错误信息；eventList数组里面是
 *
 */
- (void)reqGetEventListWithSn:(NSString *)sn
                      snToken:(NSString *)snToken
                     beginDay:(NSString *)beginDay
                       endDay:(NSString *)endDay
                         page:(NSInteger)page
                     pageSize:(NSInteger)pageSize
                     sortType:(HGGetCloudListSortType)sortType
                  resultBlock:(void(^)(NSArray *eventList, NSString *errorMsg))blockResult;

@end




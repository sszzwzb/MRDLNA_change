//
//  QHAlbumService.h
//  QHCamSDK
//
//  Created by dongzhiqiang on 16/7/22.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QHAlbumInfo : NSObject
@property (nonatomic, strong) NSString *date;       //日期
@property (nonatomic, strong) NSArray *dataArray;   //当前date日期的相册信息,里面是QHAlbumIndexInfo对象列表
@end

@interface QHAlbumIndexInfo : NSObject

@property (nonatomic, strong) NSString *sn;   //sn号
@property (nonatomic, strong) NSString *title;//摄像机的标题
@property (nonatomic, assign) NSInteger total;//图片总数
@property (nonatomic, strong) NSArray *dataArray;//相册封面图片信息，里面是QHAlbumCoverInfo对象列表

- (id)initWithDict:(NSDictionary *)dict;
@end


@interface QHAlbumCoverInfo : NSObject
@property (nonatomic, strong) NSString *sn;   //sn号
@property (nonatomic, strong) NSString *imgKey;//图片id
@property (nonatomic, assign) NSInteger subType;//事件的字类型 1表示纯图片防盗报警，2表示关联云存报警，3表示视频报警
@property (nonatomic, assign) long long eventTime;//图片创建时间
@property (nonatomic, strong) NSString *thumbUrl;//缩略图URL
@property (nonatomic, strong) NSString *snapUrl;//原图URL
@property (nonatomic, strong) NSString *cloudEvent;//事件id
@property (nonatomic, assign) long long startTime;//云录开始时间	sub_type为2时，此值必读
@property (nonatomic, assign) NSInteger duration;//视频时长（毫秒）sub_type为2或3时，此值必读
@property (nonatomic, assign) NSInteger alarmType;//引起报警的原因 sub_type为2，3时，若值是1：表示画面变化，为2：表示是哭声，为3：表示是异响

- (id)initWithDict:(NSDictionary *)dict;
@end


typedef void (^AlbumServiceCallBack)(NSArray* value, NSError *err);


@interface QHAlbumService : NSObject


/**
 *  获取按天日期的图片索引列表
 *
 *  @param   snTokenDict:    想要获取的设备sn、snToken,格式：{"sn1":"sntoken1","sn2":"sntoken2"}
 *              endDate:   截止日期，例如20160602，默认取当天。时间轴按日期倒序排列  分页方式：取当前页最后一条记录的日期+1作为下一页的end_date参数
 *                  days:	天数	,一次返回的最大天数，默认是7
 *  @param callback 回调block，成功返回value为图片数据列表，失败的话value为nil，err是错误信息；
 *               value数组里面是QHAlbumInfo的对象列表。
 */
- (void)getAlbumImageWithSnToken:(NSDictionary *)snTokenDict endDate:(NSString *)endDate days:(NSUInteger)days callback:(AlbumServiceCallBack)callback;


/**
 *  获取单日图片列表
 *
 *  @param   sn:    想要获取的设备sn
 ＊       snToken:   snToken
 *          date:   日期，例如20160602
 *     timestamp:   分页时间，单位毫秒，查询小于此时间戳的图片。分页方式：取当前页最后一张图片的时间戳作为下一页请求的timestamp参数，第一页传入0.
 *          count   分页时单页最大数量，默认是20，最大是100
 *          human   人形识别参数 0表示无人，1表示有人，-1表示获取全部
 *  @param callback 回调block，成功返回value为图片数据列表，失败的话value为nil，err是错误信息；
 *               value数组里面是QHAlbumCoverInfo的对象列表。
 */
- (void)getDateAlbumImageWithSn:(NSString*)sn snToken:(NSString *)snToken date:(NSString *)date timestamp:(long long)timestamp count:(NSInteger)count human:(NSInteger)human callback:(AlbumServiceCallBack)callback;


/**
 *  删除单日图片
 *
 *  @param   sn:    想要获取的设备sn
 *      snToken:   snToken
 *          date   日期，例如20160602
 *  @param callback 回调block，成功返回value为YES，失败的话value为nil，err是错误信息；
 */
- (void)delDateAlbumImageWithSn:(NSString*)sn snToken:(NSString *)snToken date:(NSString *)date callback:(void (^)(BOOL,NSError*))callback;

/**
 *  删除单张图片-通过图片id
 *
 *  @param   sn:    想要获取的设备sn
 *      snToken:   snToken
 *          date   日期，例如20160602
 *        imageId   图片id
 *  @param callback 回调block，成功返回value为yes，失败的话value为nil，err是错误信息；
 */
- (void)delAlbumImageWithSn:(NSString*)sn snToken:(NSString *)snToken date:(NSString *)date imageId:(NSString *)imageId callback:(void (^)(BOOL,NSError*))callback;

@end

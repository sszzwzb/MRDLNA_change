//
//  QHCamRecordPlayer.h
//  QHCamSDK
//
//  Created by chengb on 16/3/7.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import "QHCamPlayer.h"

@interface QHCamRecordInfo : NSObject

@property (strong, nonatomic) NSString *infoSn;  //返回数据中的sn
@property (strong, nonatomic) NSNumber *sdFreeMb;   //卡中可用空间
@property (strong, nonatomic) NSNumber *sdTotalMB;
@property (strong, nonatomic) NSMutableArray *fromToArray;  //卡录时间段, 是dic的数组， 结构为{@"from" : NSNumber, @"to" : NSNumber}

@property (strong, nonatomic) NSNumber *beginTime; //录像起始时间, 是自1970的秒数
@property (strong, nonatomic) NSNumber *endTime;   //录像结束时间, 是自1970的秒数
@property (assign, nonatomic) BOOL hasSdCard;      //相机中是否有卡

@property (strong, nonatomic) NSString *errMsg;

- (instancetype)initWithRecordInfo:(NSDictionary *)recordInfoDic;
- (instancetype)initWithErrorMsg:(NSString *)errorStr;

/**
 *  是否得到卡录信息
 */
- (BOOL)hasGotRecordInfo;

/**
 *  录像总时间
 */
- (int)totleRecordTime;

/**
 *  选中的时间是否又卡录
 */
- (BOOL)hasRecordAtTime:(int)seconds;

@end


/**
 * 取得卡录信息后的回调， 如果没有错误产生，则errMsg为nil， info为需要的数据， 反之errMsg不为空，
 * info为nil
 * 
 * @param info record 信息
 * @param errMsg 错误信息
 *
 */
typedef void(^RecordInfoCallback)(QHCamRecordInfo *info, NSString *errMsg);

@interface QHCamRecordPlayer : QHCamPlayer



/**
 * 取得卡录信息
 *
 * @param callback 异步返回卡录信息 @see RecordInfoCallback
 *
 */
- (void)getRecordInfo:(RecordInfoCallback)callback;


/**
 * 开始播放特定时间的卡录信息
 *
 * @param selectTime 选择的卡录时间， 自1970的秒数, 这个函数的回调和 @see QHCamPlayer的回调函数是一致的
 *
 */
- (void)startPlayerRecordInfo:(NSNumber *)selectTime;


@end

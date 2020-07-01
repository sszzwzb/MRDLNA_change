//
//  AFNManagerRequest.h
//  QIANXIAOCHUAN3NEW
//
//  Created by kaiyi on 2017/4/21.
//  Copyright © 2017年 kaiyi. All rights reserved.
//


//#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import "AFNetworking.h"  //AF 3.0 版本


#pragma mark 网络请求类型
enum HTTPMETHOD{
    METHOD_GET   = 0,       //GET请求  form-data
    METHOD_POST  = 1,       //POST请求
    METHOD_POST_RAW  = 2,   //POST请求   //  不是所有都有
};

@interface AFNManagerRequest : NSObject

/**
 *  类方法
 */
+ (AFNManagerRequest *)sharedUtil;



/**
 * AF数据请求
 */
+(void)requestAFURL:(NSString *)URLString
         httpMethod:(NSInteger)method
         parameters:(id)parameters
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure;


/**
 * 上传单张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure;


/**
 * 上传多张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
     imageDataArray:(NSArray *)imageDataArray
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure;

/**
 * 上传多张图片   不可复用DIY
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
    imageDataArray0:(NSArray *)imageDataArray0
    imageDataArray1:(NSArray *)imageDataArray1
    imageDataArray2:(NSArray *)imageDataArray2
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure;


/**
 * 上传文件
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
           fileData:(NSData *)fileData
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure;


/*json
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/*json
 * @brief 把字典转换成字符串
 * @param jsonString JSON格式的字符串
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type;


@end


#pragma mark - ReachabilityUtility
@interface ReachabilityUtility : UIAlertView

+ (instancetype)shareNetwork;

- (void)up_isNetworAccess;

@end


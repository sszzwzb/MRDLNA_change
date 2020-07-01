//
//  TSNetworking.h
//  MicroSchool
//
//  Created by jojo on 15/3/3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"

#import "CommonDefine.h"
//#import "Utilities.h"

#ifdef DEBUG
#define API_BASE @"http://staging.api.example.com/"
#else
#define API_BASE @"http://api.example.com/"
#endif

#if IS_TEST_SERVER
#define API_URL              @"http://api-test.5xiaoyuan.cn/weixiao/api.php"
#else
#define API_URL              @"http://api.5xiaoyuan.cn/weixiao/api.php"  //  2017.10.13  更改 之前 @"http://www.5xiaoyuan.cn/weixiao/api.php"
#endif

@interface TSNetworking : AFHTTPSessionManager

typedef enum TSNetworkingErrType{
    ReqErrorNotConnectedToInternet          = -1,
    ReqErrorCannotDecodeContentData         = -2,
    ReqErrorTimeOut                         = -3,
    ReqErrorBadServerResponse               = -4,

    ReqErrorOther                           = -999, // refrence to NSURLError.h
}TSNetworkingErrType;

typedef enum TSNetworkingReqType{
    NetworkingReqTypePost                   = 1,      // post一个form表单
    NetworkingReqTypeGetFile                = 2,      // 通过url获取一个文件
    NetworkingReqTypePostWithFile           = 3,      // 带上传文件的form表单
    
    TypeErr                                 = 999,
}TSNetworkingReqType;

typedef void (^HTTPRequestSuccessBlock)(TSNetworking *request, id responseObject);
typedef void (^HTTPRequestFailedBlock)(TSNetworking *request, TSNetworkingErrType error);

@property (nonatomic, assign) TSNetworkingReqType reqType;

// singleton
+ (instancetype)sharedClient;

/*
 POST请求
 通用请求接口，使用API_URL作为请求url。
 */
- (void)requestWithBaseURLAndParams:(NSDictionary *)params
                       successBlock:(HTTPRequestSuccessBlock)successReqBlock
                        failedBlock:(HTTPRequestFailedBlock)failedReqBlock;

/*
 通过url获取文件
 */
- (void)requestGetFileWithCustomizeURL:(NSString *)urlString
                                params:(NSDictionary *)params
                          successBlock:(HTTPRequestSuccessBlock)successReqBlock
                           failedBlock:(HTTPRequestFailedBlock)failedReqBlock;

/*
 通过传入的url作为请求url，参数仍然写在params。
 区别是params包含了字段fileType。
 fileType {
            @png,
            @amr,
            @file,
 }
 params里面包含是否上传文件的字段files，
 files：如为空则为定制url请求，
 files：不为空则为上传文件的请求。
 NSArray {
            NSDictionary [key, value],
            NSDictionary [key, value]
 }
 */
- (void)requestWithCustomizeURL:(NSString *)urlString
                         params:(NSDictionary *)params
                   successBlock:(HTTPRequestSuccessBlock)successReqBlock
                    failedBlock:(HTTPRequestFailedBlock)failedReqBlock;

/*
 Cancel掉当前页面所有request。
 */
- (void)cancelAll;

/*
 按照后台协议要求，拼接请求url。
 */
- (NSString *)dealWithReqUrl:(NSString *)apiUrl;

/*
 设置通用参数，比如uid和sid。
 */
- (void)setCommonParams:(NSMutableDictionary *)reqParam;

/*
 判断请求是否需要添加uid参数，不需要uid参数的请求需要把op和ac写在里面。
 */
- (BOOL)isReqNeedsUid:(NSDictionary *)params;

/*
 通用请求接口，使用REQ_URL作为请求url。
 是否需要集成hud，tbd。
 */
#if 0
- (void)requestBaseURLAndParams:(NSDictionary *)params
                        withHud:(BOOL)isHud
                   successBlock:(HTTPRequestSuccessBlock)successReqBlock
                    failedBlock:(HTTPRequestFailedBlock)failedReqBlock;
#endif


@end

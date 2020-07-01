//
//  NetworkUtility.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-15.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


//typedef enum{
//    Http_Video = 0,                             //   视频  语音  图片上传
//    HttpReq_GetFile,                            //  get 请求
//
//    
//    HttpReq_GetCustomizeModule = 998,           // 定制生成模块列表
//    HttpReq_End = 999,
//} HttpReqType;

// 网络请求cb代理
@protocol HttpReqCallbackDelegate <NSObject>

// 接收http返回data
-(void)reciveHttpData:(NSData*)data andType:(HttpReqType)type;

// 接收失败
-(void)reciveHttpDataError:(NSError*)err;

@end

@interface NetworkUtility : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
     id <HttpReqCallbackDelegate> delegate;
     ASIFormDataRequest *request1;
}

@property (nonatomic, assign) id <HttpReqCallbackDelegate> delegate;

// 发送请求
-(void)sendHttpReq:(HttpReqType)type andData:(NSDictionary*)data;

// 取消请求
-(void)cancelCurrentRequest;

// 发送请求失败
-(void)requestDidFailed:(ASIFormDataRequest *)request;

@end

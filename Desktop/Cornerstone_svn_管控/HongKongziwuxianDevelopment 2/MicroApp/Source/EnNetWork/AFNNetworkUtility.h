//
//  AFNNetworkUtility.h
//  CarHome
//
//  Created by kaiyi on 2017/12/19.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "AFNManagerRequest.h"

typedef enum{
    Http_Video = 0,                             //   视频  语音  图片上传
    HttpReq_Get = 1,                            //  get 请求
    
    HttpReq_GetLogin,                           //  登录
    HttpReq_GetPlaneListS,                      //  飞机机型
    HttpReq_GetOrderList,                       //  飞机确定航班
    HttpReq_GetOrderFinList,                    //  起飞凭证中的完成列表
    HttpReq_GetOrderFinOilList,                 //  已完成剩油得
    HttpReq_GetOrderFinWCList,                  //  外采已完成接口
    HttpReq_GetFlyingTube,                      //  外采上传权限
    HttpReq_DeleteFinOil,                       //  剩余油量撤销
    HttpReq_DeleteFinWC,                        //  外采报销撤销
    
    
    
    HttpReq_Post = 500,                                 //  post 请求
    HttpReq_FileUpload_ashx,                            //  post 图片上传    发布
    HttpReq_FileUploadTS_ashx,                          //  post 外采报销   t图片  发布
    HttpReq_FileUploadOil_ashx,                         //  post 剩余油量   图片  发布
    
    
    HttpReq_End = 999,
} HttpReqType;


@protocol HttpReqCallbackDelegate <NSObject>

// 接收http返回data
-(void)reciveHttpData:(id)data andType:(HttpReqType)type;

// 接收失败
-(void)reciveHttpDataError:(NSError*)err;

@end

@interface AFNNetworkUtility : NSObject

@property (nonatomic, assign) id <HttpReqCallbackDelegate> delegate;

// 发送请求
-(void)sendHttpReq:(HttpReqType)type andData:(NSDictionary*)data;

@end

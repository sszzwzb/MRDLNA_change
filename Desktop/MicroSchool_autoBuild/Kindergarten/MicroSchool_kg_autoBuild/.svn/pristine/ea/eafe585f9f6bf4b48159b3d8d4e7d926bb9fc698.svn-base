//
//  CameraInfoModel.h
//  MicroSchool
//
//  Created by CheungStephen on 22/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TSBaseModel.h"

@interface CameraInfoModel : TSBaseModel

// 开放平台分配给开发者的业务 id
@property(nonatomic, retain) NSString *appId;

// app_sdk_key: 开放平台分配给开发者的 SDK 请求秘钥，和 app_id 进行 匹配
@property(nonatomic, retain) NSString *appSdkKey;

// 摄像机的设备序列号，可以在摄像机的底座或包装盒的背面找到
@property(nonatomic, retain) NSString *sn;

// sn_token:用户和 sn 在开放平台处的标识，用来验证用户对 sn 的权限，和 app_id，uid，sn 都有关系，由开发者生成，SDK 需要;
@property(nonatomic, retain) NSString *snToken;


@property(nonatomic, retain) NSString *pushKey;
@property(nonatomic, retain) NSString *usid;
@property(nonatomic, retain) NSString *userInfo;



// 开发者的应用中的用户 id，开放平台用于标识最终用户
@property(nonatomic, retain) NSString *cameraUid;


// usid，sn_token，开发方可以缓存。过期后:a)usid 过期，调用开放平台服 务端 API 更新数据;b)sn_token，调用开发者服务端 API 更新数据
@property(nonatomic, retain) NSString *cameraUsid;

@end

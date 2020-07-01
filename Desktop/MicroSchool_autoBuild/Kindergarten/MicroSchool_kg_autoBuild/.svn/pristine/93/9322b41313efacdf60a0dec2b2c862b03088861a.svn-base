//
//  GlobalSingletonUserInfo.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-15.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSingletonUserInfo : NSObject
{
    // username，uid，email
    NSDictionary* userLoginInfoDic;
    
    // 用户详细信息
    NSMutableDictionary* userDetailInfoDic;
    
    // 用户注册信息(用户注册时候保存)
    NSMutableDictionary* userPersonalInfoDic;

    // 用户信息(设置中保存)
    NSMutableDictionary* userSettingPersonalInfoDic;
    
    // 是否是第一次登陆
    NSInteger* loginIndex;
    
    // 用户手机号码
    NSString* userPhoneNum;
    
    // 该用户所选择的class id
    NSString* userCid;
    
    // 是否是从homework submit返回到钱画面的标志位
    NSString* isHomeworkSubmit;

}

+(GlobalSingletonUserInfo*)sharedGlobalSingleton;

// 用户详细信息：
-(BOOL)setUserDetailInfo:(NSMutableDictionary*)dic;
-(NSMutableDictionary*)getUserDetailInfo;

// 用户注册信息
-(BOOL)setUserPersonalInfo:(NSMutableDictionary*)dic;
-(NSMutableDictionary*)getUserPersonalInfo;
// 重置注册信息
-(void)resetPersonalInfo;


// 用户注册信息-设置
-(BOOL)setUserSettingPersonalInfo:(NSMutableDictionary*)dic;
-(NSMutableDictionary*)getUserSettingPersonalInfo;

// 是否是第一次登陆
-(BOOL)setLoginIndex:(NSInteger*)loginIndex;
-(NSInteger*)getLoginIndex;

// 用户手机号码
-(BOOL)setUserPhoneNum:(NSString*)phoneNum;
-(NSString*)getUserPhoneNum;

// 用户手机号码
-(BOOL)setUserCid:(NSString*)cid;
-(NSString*)getUserCid;

// 是否是从homework submit返回到钱画面的标志位
-(BOOL)setIsHomeworkSubmit:(NSString*)flag;
-(NSString*)getIsHomeworkSubmit;

@end

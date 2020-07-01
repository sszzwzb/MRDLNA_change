//
//  GlobalSingletonUserInfo.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-15.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "GlobalSingletonUserInfo.h"

@implementation GlobalSingletonUserInfo

-(id)init{
    self = [super init];
    if(self){
        //全局属性初始化
        userLoginInfoDic = nil;
        userDetailInfoDic = nil;
        
        userDetailInfoDic = nil;
        
        userPersonalInfoDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"", @"name",
                                      @"学生", @"identity",
                                      @"2", @"gender",
                                      @"1995", @"birthyear",
                                      @"1", @"birthmonth",
                                      @"1", @"birthday",
                                      @"", @"schoolYear",
                                      @"", @"class",
                                      @"", @"cid",
                                      @"", @"number",
                                      @"", @"idNumber",
                                      @"", @"reason",
                                      @"", @"relations",
                                      @"", @"relationsId",
                                      nil];
        
        userSettingPersonalInfoDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               @"", @"name",
                               @"2", @"gender",
                               @"", @"spacenote",
                                      
                               @"", @"birthyear",
                               @"", @"birthmonth",
                               @"", @"birthday",
                                      
                               @"", @"birthprovince",
                               @"", @"birthcity",
                               @"", @"resideprovince",
                               @"", @"residecity",
                               @"", @"blood",
                                      
                               @"", @"usertype",
                               @"", @"yeargrade",
                               @"", @"class",
                               @"", @"studentid",
                                      
                               nil];
        
        loginIndex = nil;
        userPhoneNum = nil;
    }
    return self;
}

+(GlobalSingletonUserInfo*)sharedGlobalSingleton
{
    static GlobalSingletonUserInfo *sharedGlobalSingleton;
    @synchronized(self)
    {
        if (!sharedGlobalSingleton)
            sharedGlobalSingleton = [[GlobalSingletonUserInfo alloc] init];
        return sharedGlobalSingleton;
    }
}

-(BOOL)setUserDetailInfo:(NSMutableDictionary*)dic
{
    userDetailInfoDic = dic;
    return true;
}

-(NSMutableDictionary*)getUserDetailInfo
{
    return userDetailInfoDic;
}

// 用户注册信息
-(BOOL)setUserPersonalInfo:(NSMutableDictionary*)dic
{
    userPersonalInfoDic = dic;
    return true;
}

-(NSDictionary*)getUserPersonalInfo
{
    return userPersonalInfoDic;
}

-(void)resetPersonalInfo
{
    userPersonalInfoDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"", @"name",
                           @"学生", @"identity",
                           @"2", @"gender",
                           @"1995", @"birthyear",
                           @"1", @"birthmonth",
                           @"1", @"birthday",
                           @"", @"schoolYear",
                           @"", @"class",
                           @"", @"cid",
                           @"", @"number",
                           @"", @"idNumber",
                           @"", @"reason",
                           @"", @"relations",
                           @"", @"relationsId",
                           nil];
}

-(BOOL)setUserSettingPersonalInfo:(NSMutableDictionary*)dic
{
    userSettingPersonalInfoDic = dic;
    return true;
}

-(NSMutableDictionary*)getUserSettingPersonalInfo
{
    return userSettingPersonalInfoDic;
}

-(BOOL)setLoginIndex:(NSInteger*)index
{
    loginIndex = index;
    return true;
}

-(NSInteger*)getLoginIndex
{
    return loginIndex;
}

-(BOOL)setUserPhoneNum:(NSString*)phoneNum
{
    userPhoneNum = phoneNum;
    return true;
}

-(NSString*)getUserPhoneNum
{
    return userPhoneNum;
}

-(BOOL)setUserCid:(NSString*)cid
{
    userCid = cid;
    return true;
}

-(NSString*)getUserCid
{
    return userCid;
}

// 是否是从homework submit返回到前画面的标志位
-(BOOL)setIsHomeworkSubmit:(NSString*)flag
{
    isHomeworkSubmit = flag;
    return true;
}

-(NSString*)getIsHomeworkSubmit
{
    return isHomeworkSubmit;
}


@end

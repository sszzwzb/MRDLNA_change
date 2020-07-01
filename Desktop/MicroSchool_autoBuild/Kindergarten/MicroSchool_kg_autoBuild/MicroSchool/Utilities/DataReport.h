//
//  DataReport.h
//  MicroSchool
//
//  Created by jojo on 14-8-26.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKTypes.h>
#import <MapKit/MKFoundation.h>
#import <MapKit/MKPlacemark.h>

#import "NetworkUtility.h"
#import "GlobalSingletonUserInfo.h"
#import "Utilities.h"

@interface DataReport : NSObject <CLLocationManagerDelegate, HttpReqCallbackDelegate>
{
    GlobalSingletonUserInfo* g_userInfo;
    
    NSString *typeReport;
}

+(DataReport*)sharedGlobalSingletonDataReport;

-(void)dataReportGPStype:(NSString *)type;
-(void)dataReportActiontype:(NSString *)type;

@property (nonatomic, retain) CLLocationManager *locationManager;

// gps上报内容
// 成功登录（登录按钮）
#define DataReport_Act_Login                            @"DataReport_Act_Login"     //ok done
// 成功注册（注册上传头像后后的确认按钮）
#define DataReport_Act_Regist                           @"DataReport_Act_Regist"    //ok
// 成功找回（找回按钮）
#define DataReport_Act_GetBackPwd                       @"DataReport_Act_GetBackPwd"    //ok
// 意见反馈（确认按钮）
#define DataReport_Act_FeedBack                         @"DataReport_Act_FeedBack"      //ok done
// 修改密码（保存按钮）
#define DataReport_Act_ChangePwd                        @"DataReport_Act_ChangePwd"     //ok done
// 联系方式（保存按钮）
#define DataReport_Act_Contact                          @"DataReport_Act_Contact"       //ok done
// 个人资料维护（保存按钮）
#define DataReport_Act_SavePersonalInfo                 @"DataReport_Act_SavePersonalInfo"      //ok 
// 通讯录 - 添加好友
#define DataReport_Act_PhoneBook_AddFriend              @"DataReport_Act_PhoneBook_AddFriend"   //ok
// 通讯录 - 聊天发送
#define DataReport_Act_PhoneBook_SendMsg                @"DataReport_Act_PhoneBook_SendMsg"     //ok
// 通讯录 - 多人发送
#define DataReport_Act_PhoneBook_MultiSendMsg           @"DataReport_Act_PhoneBook_MultiSendMsg"    //ok done
// 责任督学 - 发送提问
#define DataReport_Act_SendQuestion                     @"DataReport_Act_SendQuestion"      //ok done
// 讨论区 - 发贴
#define DataReport_Act_Discuss_Create                   @"DataReport_Act_Discuss_Create"    //ok done
// 讨论区 - 回帖
#define DataReport_Act_Discuss_Reply                    @"DataReport_Act_Discuss_Reply"     //ok
// 我的班级 - 发公告
#define DataReport_Act_Class_CreateNews                 @"DataReport_Act_Class_CreateNews"
// 我的班级 - 回公告
#define DataReport_Act_Class_ReplyNews                  @"DataReport_Act_Class_ReplyNews"       //ok
// 我的班级 - 发作业
#define DataReport_Act_Class_CreateHonework             @"DataReport_Act_Class_CreateHonework"  //ok
// 我的班级 - 回作业
#define DataReport_Act_Class_ReplyHonework              @"DataReport_Act_Class_ReplyHonework"   //ok

//typedef enum{
//    Act_Login = 0,                      // 成功登录（登录按钮）
//    Act_Regist,                         // 成功注册（注册上传头像后后的确认按钮）
//    Act_GetBackPwd,                     // 成功找回（找回按钮）
//    Act_FeedBack,                       // 意见反馈（确认按钮）
//    Act_ChangePwd,                      // 修改密码（保存按钮）
//    Act_Contact,                        // 联系方式（保存按钮）
//    Act_SavePersonalInfo,               // 个人资料维护（保存按钮）
//    Act_PhoneBook_AddFriend,            // 通讯录 - 添加好友
//    Act_PhoneBook_SendMsg,              // 通讯录 - 聊天发送
//    Act_PhoneBook_MultiSendMsg,         // 通讯录 - 多人发送
//    Act_SendQuestion,                   // 责任督学 - 发送提问
//    Act_Discuss_Create,                 // 讨论区 - 发贴
//    Act_Discuss_Reply,                  // 讨论区 - 回帖
//    Act_Class_CreateNews,               // 我的班级 - 发公告
//    Act_Class_ReplyNews,                // 我的班级 - 回公告
//    Act_Class_CreateHonework,           // 我的班级 - 发作业
//    Act_Class_ReplyHonework,            // 我的班级 - 回作业
//
//    Act_End = 999,
//} DataReportAct;

@end

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

#import "GlobalSingletonUserInfo.h"
#import "CommonDefine.h"
#import "Utilities.h"

#import "PublicConstant.h"

#if IS_TEST_SERVER
// 服务器api地址
#define REQ_URL                 @"http://api-test.5xiaoyuan.cn/weixiao/api.php"
#define REQ_PIC_URL             @"http://api-test.5xiaoyuan.cn/weixiao/pic.php?density=%@&pid=%@"

#define SERVER_URL              @"http://api-test.5xiaoyuan.cn"
#define Report_URL              @"http://182.92.8.28:8082/log/"

#define AC_HEAR_URL             @"http://test.5xiaoyuan.cn/ucenter/avatar.php?"

#define AC_CLASS                @"http://test.5xiaoyuan.cn/wx.php?ac=class"

#define AC_PROFILE              @"http://test.5xiaoyuan.cn/wx.php?ac=profile&op=query"
#define AC_PROFILE_UPDATE       @"http://test.5xiaoyuan.cn/wx.php?ac=profile&op=update"
#define AC_CONTACT              @"http://test.5xiaoyuan.cn/wx.php?ac=contact"
#define AC_PASSWORD             @"http://test.5xiaoyuan.cn/wx.php?ac=password"
#define AC_FEEDBACK             @"http://test.5xiaoyuan.cn/wx.php?ac=feedback"

#define AC_SCHOOLEVENT          @"http://test.5xiaoyuan.cn/wx.php?ac=event"
#define AC_CP_SCHOOLEVENT       @"http://test.5xiaoyuan.cn/wx.php?ac=cp_event"
#define AC_THREAD               @"http://test.5xiaoyuan.cn/wx.php?ac=thread"

#define AC_HOMEWORK             @"http://test.5xiaoyuan.cn/wx.php?ac=homework"
#define AC_CP_HOMEWORK          @"http://test.5xiaoyuan.cn/wx.php?ac=cp_homework"
#define AC_CP_HOMEWORK_DELETE   @"http://test.5xiaoyuan.cn/wx.php?ac=cp_homework"

#define AC_CLASSTABLE           @"http://test.5xiaoyuan.cn/wx.php?ac=classtable"

#define AC_WIKI                 @"http://test.5xiaoyuan.cn/wx.php?ac=wiki"

#define AC_BINDSERVER           @"http://test.5xiaoyuan.cn/wx.php?ac=push"

#define AC_MYCLASS               @"http://test.5xiaoyuan.cn/wx.php?ac=myclass"//kate

#else
// 服务器api地址
#define REQ_URL                 @"http://api.5xiaoyuan.cn/weixiao/api.php"
#define REQ_PIC_URL             @"http://www.5xiaoyuan.cn/weixiao/pic.php?density=%@&pid=%@"

#define SERVER_URL              @"http://www.5xiaoyuan.cn"
#define Report_URL              @"http://182.92.8.28:8092/log/"

#define AC_HEAR_URL             @"http://www.5xiaoyuan.cn/ucenter/avatar.php?"

#define AC_CLASS                @"http://www.5xiaoyuan.cn/wx.php?ac=class"
#define AC_PROFILE              @"http://www.5xiaoyuan.cn/wx.php?ac=profile&op=query"
#define AC_PROFILE_UPDATE       @"http://www.5xiaoyuan.cn/wx.php?ac=profile&op=update"
#define AC_CONTACT              @"http://www.5xiaoyuan.cn/wx.php?ac=contact"
#define AC_PASSWORD             @"http://www.5xiaoyuan.cn/wx.php?ac=password"
#define AC_FEEDBACK             @"http://www.5xiaoyuan.cn/wx.php?ac=feedback"

#define AC_SCHOOLEVENT          @"http://www.5xiaoyuan.cn/wx.php?ac=event"
#define AC_CP_SCHOOLEVENT       @"http://www.5xiaoyuan.cn/wx.php?ac=cp_event"
#define AC_THREAD               @"http://www.5xiaoyuan.cn/wx.php?ac=thread"

#define AC_HOMEWORK             @"http://www.5xiaoyuan.cn/wx.php?ac=homework"
#define AC_CP_HOMEWORK          @"http://www.5xiaoyuan.cn/wx.php?ac=cp_homework"
#define AC_CP_HOMEWORK_DELETE   @"http://www.5xiaoyuan.cn/wx.php?ac=cp_homework"

#define AC_CLASSTABLE           @"http://www.5xiaoyuan.cn/wx.php?ac=classtable"

#define AC_WIKI                 @"http://www.5xiaoyuan.cn/wx.php?ac=wiki"

#define AC_MYCLASS              @"http://www.5xiaoyuan.cn/wx.php?ac=myclass"
#endif

typedef enum{
    HttpReq_GetSplash = 0,          // 获取闪屏图片                  1
    HttpReq_GetFile,                // 获取文件

    HttpReq_GetCode,                // 获取验证码                    1
    HttpReq_VerifyCode,             // 验证验证码                    1
    HttpReq_Register,               // 注册                         1
    HttpReq_RegisterPersonalStu,    // 注册(完善个人信息, 学生)
    HttpReq_RegisterPersonalTea,    // 注册(完善个人信息, 老师)
    HttpReq_ResendTeacherReq,       // 重新申请老师权限
    
	HttpReq_GetClass,               // 获取班级
	HttpReq_GetClassByUid,          // 获取班级by uid
	HttpReq_GetClassOthers,         // 获取未加入班级
	HttpReq_GetClassTeacher,        // 获取加入班级
	HttpReq_JoinClass,              // 加入班级
	HttpReq_OutClass,               // 退出班级
    HttpReq_GetYeargrade,           // 获取入学年份
	HttpReq_Login,                  // 登录                          1
    HttpReq_ChangePassword,         // 修改密码
    HttpReq_Profile = 16,           // 获取用户信息
    HttpReq_ProfileUpdate,          // 更新用户信息
    HttpReq_Avatar,                 // 头像上传

    HttpReq_UpdateContact,          // 修改联系方式
    HttpReq_Feedback,               // 反馈

	HttpReq_News,                   // 获取新闻列表
	HttpReq_NewsDetail,             // 获取新闻详细
    
    HttpReq_SchoolEvent,            // 校园活动列表
    HttpReq_SchoolEventDetail,      // 校园活动详细
    HttpReq_SchoolEventMember,      // 校园活动成员
    HttpReq_SchoolEventPic,         // 校园活动图片
    HttpReq_SchoolEventThread,      // 校园活动主题
    HttpReq_SchoolEventJoin,        // 是否参与校园活动

    HttpReq_Thread,                 // 讨论区话题列表
    HttpReq_ThreadDetail,           // 讨论区话题详细
    HttpReq_ThreadInitiator,        // 我发起的话题
    HttpReq_ThreadResponse,         // 我参与的话题
    HttpReq_ThreadSubmit,           // 发表话题
    HttpReq_ThreadReply,            // 回复话题 tid=要回复的话题ID
    HttpReq_ThreadReplyPid,         // 回复回复 tid=要回复的话题ID，pid=要回复的回复ID
    HttpReq_ThreadReplyAudio,       // 回复话题 音频
    HttpReq_ThreadReplyPicture,     // 回复话题 图片
    HttpReq_ThreadHistory,          // 详情浏览痕迹

    HttpReq_Homework,               // 作业列表
    HttpReq_HomeworkDetail,         // 作业详情
    HttpReq_HomeworkSubmit,         // 发布作业
    HttpReq_HomeworkReply,          // 回复作业
    HttpReq_HomeworkReplyPid,       // 回复作业的回复
    HttpReq_HomeworkDelete,         // 删除一条作业

    HttpReq_Schedule,               // 课表
    
    HttpReq_WikiMySchool,           // 学校知识库列表
    HttpReq_WikiMySchoolDetail,     // 学校知识库详情
    HttpReq_WikiMySchoolDetailPost, // 学校知识库详情评论列表
    HttpReq_WikiFollowing,          // 关注的人列表
    HttpReq_WikiFollowingWiki,      // 我的订阅列表
    HttpReq_WikiFollow,             // 关注一个用户
    HttpReq_WikiFollowCancel,       // 取消关注一个用户
    HttpReq_WikiFavorite,           // 收藏
    HttpReq_WikiFavoriteCancel,     // 取消收藏
    HttpReq_WikiCollection,         // 我收藏的知识库列表
    HttpReq_WikiSearch,             // 搜索
    HttpReq_WikiComment,            // 写评论
    HttpReq_WikiLikeOrNot,          // 喜欢或者没有帮助

    HttpReq_Version,                // 检查更新
    
    HttpReq_BindServer,             //绑定推送
    HttpReq_Threads,                 // 班级公告话题列表
    HttpReq_ThreadDetails,            // 班级公告讨论详情
    
    HttpReq_ThreadsReply,               // 班级回复话题 tid=要回复的话题ID
    HttpReq_ThreadsReplyPid,            // 班级回复回复 tid=要回复的话题ID，pid=要回复的回复ID
    HttpReq_GetClassesByUid,            // 获取班级by uid

    HttpReq_FriendGet,                  // 好友列表
    HttpReq_FriendAdd,                  // 添加好友申请
    HttpReq_FriendAddAccept,            // 通过好友添加申请
    HttpReq_FriendAddReject,            // 拒绝好友添加申请
    HttpReq_FriendSearch,               // 搜索好友
    HttpReq_FriendDelete,               // 删除好友

    HttpReq_GetbackPasswordCode,        // 找回密码 step1 获取验证码
    HttpReq_GetbackPasswordReset,       // 找回密码 step2 重置密码
    
    HttpReq_DataReportGPS,              // gps上报
    HttpReq_DataReportAction,           // 点击上报                         1

    HttpReq_EduinspectorProfile,        // 督学简介
    HttpReq_EduinspectorInterractions,  // 督学首页
    HttpReq_EduinspectorInformation,    // 督学模块
    HttpReq_EduinspectorDoInterractions,// 督学提问
    
    HttpReq_QuitSchool,                 // 退出学校
    
    HttpReq_ViewFriendProfile,          // 获取个人空间信息
    
    HttpReq_ViewFriendProfileByCode,          // 通过二维码获取个人空间信息 by  kate
    
    HttpReq_BindParenthood,          // 父母绑定孩子 by kate
    
    HttpReq_MessageCenter,              // 消息中心列表
    HttpReq_MessageCenterGetEduAns,     // 获取督学回答信息
    HttpReq_MessageCenterClear,         // 清除一条个人消息
    HttpReq_MessageCenterClearAll,      // 清除全部个人消息

    HttpReq_GetOtherSchoolResult,       // 获取他校风采动态结果
    HttpReq_GetOtherSchoolFavorite,     // 收藏的学校
    
    HttpReq_ClassThread,                // 班级讨论区列表
    HttpReq_ClassThreadDetail,          // 班级讨论区话题详细
    HttpReq_ClassThreadSubmit,          // 班级讨论区发表话题
    HttpReq_ClassThreadReply,            // 回复话题 tid=要回复的话题ID
    HttpReq_ClassThreadReplyPid,         // 回复回复 tid=要回复的话题ID，pid=要回复的回复ID
    HttpReq_ClassThreadReplyAudio,       // 回复话题 音频
    HttpReq_ClassThreadReplyPicture,     // 回复话题 图片
    
    HttpReq_MomentsClassroom,            // 班级动态
    HttpReq_MomentsLike,                 // 动态点赞
    HttpReq_ClassNewPhotoLike,           // 班级相册图片详情点赞

    HttpReq_MomentsDetail,               // 动态详情
    HttpReq_ClassNewPhotoDetail,               // 班级相册图片详情
    HttpReq_MomentsRemovePost,           // 删除动态
    HttpReq_ClassNewPhotoRemovePost,           // 删除班级相册详情
    HttpReq_MomentsRemoveComment,        // 删除评论
    HttpReq_ClassNewPhotoRemoveComment,        // 删除班级相册最新详情评论

    HttpReq_MomentsSetUserBackground,    // 设置个人背景图片
    HttpReq_MomentsComment,              // 评论一条动态
    HttpReq_ClassNewPhotoComment,        // 评论一条相册

    HttpReq_MomentsBlockPost,            // 屏蔽评论

    HttpReq_ThreadMomentsSubmit,           // 发布动态
    Http_ThreadMomentsSubmitVideo,         //发布小视频
    HttpReq_ThreadPhotoSubmit,           // 老师传照片幼儿园
    HttpReq_ThreadPhotoSubmitVideo,           // 老师传小视频幼儿园


    Http_SchoolDiscussDelete, //删除学校讨论区

    HttpReq_BroadcastGetOne,             // 获取一条广播
    HttpReq_BroadcastHistory,            // 获取历史广播

    HttpReq_KnowledgeWikiItems,          // 获取知识库条目列表
    HttpReq_KnowledgeWikiShopItem,       // 知识库查看教师定价
    HttpReq_KnowledgeWikiShopOrder,      // 知识库查看订单
    HttpReq_KnowledgeWikiShopCheck,      // 检查订单是否完成
    HttpReq_KnowledgeWikiItemDeatil,     // 新版知识库详情
    HttpReq_KnowledgeWikiItemComment,    // 新版知识库评论列表
    
    HttpReq_SchoolThreadCommentDelete,      // 讨论区详情评论删除
    HttpReq_ClassThreadCommentDelete,       // 班级公告详情评论删除
    HttpReq_HomeworkCommentDelete,          // 班级作业详情评论删除
    HttpReq_ClassForumCommentDelete,        // 班级风采/讨论区详情评论删除
    HttpReq_deleteWikiComment,              // 知识库详情评论删除
    
    HttpReq_PeopleGet,                  // 教育局成员列表

    HttpReq_DebugLog,                   // 上报debug log
    
    HttpReq_CustomThreadSubmit,           // 发表自定义公告
    
    HttpReq_HomeworkSend, // 作业发布
    HttpReq_HomeworkModify,// 作业修改
    HttpReq_HomeworkStudentUpload, // 学生发布作业回复

    HttpReq_RecipeUpload, // 上传菜谱

    HttpReq_GetCustomizeModule = 998,    // 定制生成模块列表
    HttpReq_End = 999,
} HttpReqType;

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

//
//  FRNetPoolUtils.h
//  FriendNew
//
//  Created by lee lee on 12-6-4.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ChatDetailObject.h"
#import "UserObject.h"
#import "GroupChatDetailObject.h"
#import "MixChatDetailObject.h"

@protocol AsiStatus <NSObject>

- (void)callBackStautsSuccess;
- (void)callBackStautsFailed;

@end

@interface FRNetPoolUtils : NSObject <ASIHTTPRequestDelegate>
{
     id <AsiStatus>   statusDelegate;
}

@property (nonatomic ,retain)  id <AsiStatus> statusDelegate ;
//*******************************Kate*******************************/
// 安装上报
+ (BOOL)uploadInstallationReport:(NSString *)reportString;
// 数据上报
+ (BOOL)uploadDailyReport:(NSString*)type;

// 发送新版聊天消息
//+ (NSString *)sendMsgForMix:(MixChatDetailObject *)chatDetail;

+ (NSDictionary *)sendMsgForMix:(MixChatDetailObject *)chatDetail;

// 发送群聊聊天消息
+ (NSString *)sendMsgForGroup:(GroupChatDetailObject *)chatDetail;

// 获取群聊头像
+(UIImage*)getImage:(NSString*)url;

//  教育局下属单位列表 定制
+(NSDictionary*)getSchoolListForBureau;

//  发现TAB自定义模块列表
+(NSDictionary*)getMoments;

// 教育局下属单位科室列表
+(NSMutableArray*)getSubordinateList;

// 教育局本单位科室列表
+(NSMutableArray*)getDepartmentList;

// 校园订阅 订阅文章详情
+(NSDictionary*)getSubsribeArticleDetail:(NSString*)aid width:(NSString*)width;

// 校园订阅号认证详情
+(NSDictionary*)getCertificateDetail:(NSString*)number;

// 校园订阅文章列表
+(NSMutableArray*)getSubscribeArticles:(NSString*)page size:(NSString*)size number:(NSString*)number;

// 校园订阅号列表
+(NSMutableArray*)getSubscribeNumList:(NSString*)page size:(NSString*)size lasts:(NSString*)lasts;

// 校校通取消收藏学校
+(NSString*)cancelCollectSchool:(NSString*)collectSid;

// 校校通收藏学校
+(NSString*)collectSchool:(NSString*)collectSid;

// 校校通城市选择列表
+(NSMutableArray*)getSToSRegions;

// 校校通其他学校模块列表
+(NSDictionary*)getOtherSchoolModules:(NSString*)otherSid andsSpecial:(NSString *)special;

// 校校通通过城市筛选学校列表
+(NSMutableArray*)getSchool:(NSString*)cid keyword:(NSString*)keyword page:(NSString*)page size:(NSString*)size;

// 转发聊天消息
+(NSString*)transpondMsg:(ChatDetailObject*)chatDetail receivers:(NSString*)receivers;

// 知识库模块取消收藏
+(NSString*)cancelCollection:(NSString*)kid;

// 知识库类别列表每个类别的数量
+(NSDictionary*)getKnowledgeTypeCount:(NSString*)last;

// 我的课程
+(NSMutableArray*)getMySubjects:(NSString*)page size:(NSString*)size;

// 我收藏的文章
+(NSMutableArray*)getMyCollectedArticles:(NSString*)page size:(NSString*)size;

// 我订阅的教师
+(NSMutableArray*)getMySubscribedTeachers:(NSString*)page size:(NSString*)size;

// 我订阅的文章
+(NSMutableArray*)getMySubscribedArticles:(NSString*)page size:(NSString*)size;

// 作者空间/教师详情
+(NSDictionary*)getTeacherDetail:(NSString*)tid page:(NSString*)page size:(NSString*)size;

// 获取学校列表
+(NSMutableArray*)getSchool:(NSString*)rid;

// 获取省份城市
+(NSMutableArray*)getRegions;

// 条目列表/知识点搜索
+(NSDictionary*)getItems:(NSString*)keyword category:(NSString*)category course:(NSString*)course grade:(NSString*)grade page:(NSString*)page size:(NSString*)size;

// 教师列表
+(NSDictionary*)getTeacherList:(NSString*)keyWord ownsid:(NSString*)ownsid page:(NSString*)page size:(NSString*)size;

// 知识库首页列表
+(NSDictionary*)getKnowlegeHomePageList:(NSString*)last;

// 清空我发表的全部动态
+(NSString*)deleteMyMoments:(NSString*)last;

// 删除我的某条动态
+(NSString*)deleteMyMomentsById:(NSString*)tid;

// 自定义标签(tab)
+(NSMutableArray*)getTabTitle;

// 设置某动态的可见范围（权限）
+(NSString*)setMySingleMomentViewType:(NSString*)tid privilege:(NSString*)privilege cids:(NSString*)cids;

// 个人动态查看权限设置
+(NSString*)setMomentsViewType:(NSString*)privilege;

// 获取动态权限类型
+(NSDictionary*)getPrivilege;

// 程序主页menu红点
+(NSMutableArray*)checkNewForSchool:(NSString*)moudles numbers:(NSString*)numbers;

// 点赞的人列表
+(NSMutableArray*)getLikerList:(NSString*)tid;

// 个人动态消息列表
+(NSDictionary*)getSelfNewsList:(NSString*)page size:(NSString*)size;

// 班级主页红点
+(NSMutableArray*)checkNewForClass:(NSString*)cid moudles:(NSString*)moudles;

// 获取班级详情新接口
+(NSDictionary*)getMyclassDetail:(NSString*)cid;

// 我的消息红点检查接口
+(int)checkNewsForMsg:(NSString*)lastId;//add by kate 2014.12.03

// 通过二维码查看个人资料
+(NSMutableDictionary*)getPersonalInfoByCode:(NSString*)code;

// 解除父母有孩子绑定
+(NSString*)UnbindForParenthood:(NSString*)childId;

// 父母绑定孩子
+(NSString*)BindForParenthood:(NSString*)childId;

// 家长的亲子关系绑定列表
+(NSMutableArray*)getParenthoodListForParents;

// 孩子的亲子关系列表
+(NSMutableArray*)getParenthoodListForChild;

// 孩子获取自己的二维码
+(NSString*)getQRCodeForChild;

// 意见与反馈红点拉取接口
+(NSString*)isNewForFeedbackMsg:(NSString*)lastId;

// 发送意见与反馈
+(NSString*)sendFeedback:(NSString*)msg;

// 意见与反馈消息列表
+(NSMutableArray*)getFeedbackMessageList;

// 设置个人隐私
+(NSString*)setPrivacyWay:(NSString*)type subType:(NSString*)subtype way:(NSString*)way;

// 查看个人隐私
+(NSMutableArray*)viewMyPrivacy;

// 督学更新个人资料 “”
//+(NSString*)updateProfile:(NSString*)phone job:(NSString*)job company:(NSString*)company duty:(NSString*)duty photoPath:(NSString*)photo;
+(NSString*)updateProfile:(NSString*)phone job:(NSString*)job company:(NSString*)company duty:(NSString*)duty photoPath:(NSString*)photo email:(NSString*)email;

// 督学回答问题
+(NSString*)answerQ:(NSString*)rid message:(NSString*)message aid:(NSString*)aid;

// 督学登录待回答问题列表
+(NSMutableArray*)getToReplyAnswerList:(NSString*)page size:(NSString*)size;

// 设置/取消管理员
+(NSString*)setAdmin:(NSString*)cid oUid:(NSString*)oUid type:(NSString*)type;

// 获取学校管理员登陆的成员列表-教师列表
+(NSMutableDictionary*)getTeachers:(NSString*)cid role:(NSString*)role page:(NSString*)startIndex size:(NSString*)size;

// 设置好友添加权限
+(NSString*)setFriendJoinPerm:(NSString*)authority;

// 我的班级红点
+(NSMutableDictionary*)checkMyClass:(NSString*)cids;

// 获取编辑资料页的详细
+(NSDictionary*)getClassSetting:(NSString*)cid;

// 编辑资料--设置班级简介
+(NSString*)setClassNote:(NSString*)cid note:(NSString*)note;

// 编辑资料--设置方式
+(NSString*)setClassJoinPerm:(NSString*)cid perm:(NSString*)perm;

// 编辑资料--设置头像
+(NSString*)setClassAvatar:(NSString*)cid;

// 管理员移除成员
+(NSString*)removeMember:(NSString*)rid cid:(NSString*)cid;

// 退出班级
+(NSString*)quitFromClass:(NSString*)cid;

// 管理员班级审批接口 同意或拒绝
+(NSString*)agreeOrReject:(NSString*)approveID type:(NSString*)type;

// 班级成员管理列表
+(NSMutableArray*)getMembers:(NSString*)cid role:(NSString*)role;

// 管理员的班级申请列表
+(NSDictionary*)getClassNotifications:(NSString*)page size:(NSString*)size;

// 加入班级申请接口
+(NSString*)applyAddClass:(NSString*)cid reason:(NSString*)reason;

// 新版加入班级
+(NSDictionary*)addClass:(NSString*)cid reason:(NSString *)reason;

// 获取班级筛选条件列表
+(NSMutableArray*)getFilterList;

// 获取我的班级列表
+(NSDictionary*)getMyClassList;

// 获取该校所有班级
+(NSMutableArray*)getClassList:(NSString*)yeargrade;

// 检查是否被其他用户T出 or 检查是否被管理员T出
+(NSDictionary*)isUnBind;

// 版本new标记
+(int)checkNews:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;

// 版本new标记
+(int)checkCNews:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
// 版本new标记
+(int)checkChatNews:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
//班级公告
+(int)checkClassNews:(NSString*)op sid:(NSString*)sid cid:(NSString*)cid module:(NSString*)module lastId:(NSString*)lastId;
//菜谱
+(int)checkCookMenu:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
//教育资讯
+(int)checkEducation:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
//东方之声
+(int)checkOrientalSound:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
//学生手册
+(int)checkHandbook:(NSString*)op sid:(NSString*)sid module:(NSString*)module lastId:(NSString*)lastId;
// 作业
+(int)checkHomework:(NSString*)op sid:(NSString*)sid cid:(NSString*)cid module:(NSString*)module lastId:(NSString*)lastId;



// 获取我的班级模块同学头像
+ (BOOL)getPicWithUrl:(NSString *)url picType:(NSInteger)type userid:(long long)cid msgid:(long long)msg_id;

// 获取语音
+(BOOL)getAudioFromServer:(NSString*)url userid:(long long)uid msgid:(long long)msg_id;

// 百度推送绑定后台接口
+(BOOL)bindServer:(NSString*)uid sid:(NSString*)sid cid:(NSString*)cid clientId:(NSString*)clientId channelId:(NSString*)channelId type:(NSString*)type token:(NSString*)token;
// 解除推送绑定后台接口
+(BOOL)unBindServer:(NSString*)uid sid:(NSString*)sid cid:(NSString*)cid clientId:(NSString*)clientId channelId:(NSString*)channelId type:(NSString*)type;

// 我的班级同学信息
+(NSDictionary*)getMyClassmateInfo:(NSString*)sid cid:(NSString*)cid uid:(NSString*)uid;

// 获取同学头像
+(UIImage*)getClassmatePic:(NSString*)url;

// 发送聊天消息
+ (NSString *)sendMsg:(ChatDetailObject *)chatDetail;

// 收取聊天消息
+ (NSInteger)getMsg;

// 获取用户个人信息
+ (UserObject *)getSalesmenWithID:(long long)user_id;

// 获取个人信息接口 新 done:新接口
+ (UserObject *)getSalesmenWithID:(long long)user_id sid:(long long)sid;


// 通过Url从服务器获取图片（头像，缩略图，大图）
+ (BOOL)getImgWithUrl:(NSString *)url
              picType:(NSInteger)type
               userid:(long long)user_id
                msgid:(long long)msg_id;

+(NSString *)getFoundConfiguration;

@end

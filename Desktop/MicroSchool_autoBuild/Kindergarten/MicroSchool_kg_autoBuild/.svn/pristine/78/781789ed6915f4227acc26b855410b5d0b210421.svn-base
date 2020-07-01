//
//  Utilities.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-22.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUtility.h"
#import "TSNetworking.h"
#import "DBDao.h"
#import "GlobalSingletonUserInfo.h"
#import "MBProgressHUD.h"
#import "TSProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

#import "pinyin.h"
#import "ChineseString.h"

#import "sys/sysctl.h"

#import "SSKeychain.h"
#import "FileManager.h"//单例模型，用来记录当前的网络状态 add by kate 2015.06.26

//#define MACHINE_VERSION
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1134), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone3gs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS_VERSION_ABOVE_8 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0
#define IOS_VERSION_ABOVE_9 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0

typedef enum{
    DateFormat_YMDHM = 0,          // 年，月，日，小时，分钟
    DateFormat_MDHM,               // 月，日，小时，分钟
    DateFormat_YMD,                // 年，月，日
    DateFormat_MD,                // 月，日
    DateFormat_MS,                 // 分钟，秒
    DateFormat_HM,                 // 小时，分钟

    DateFormat_End = 999,
} DateFormatType;

typedef enum{
    PathType_AmrPath = 0,          // amr
    PathType_PicturePath,          // pic
    PathType_SightPath,             // sight

    PathType_End = 999,
} PathType;

typedef enum{
    UserType_Student = 0,               // 学生
    UserType_Parent,                    // 家长
    UserType_Teacher,                   // 老师
    UserType_Eduinspector,              // 督学
    UserType_Admin,                     // 管理员

    UserType_End = 999,
} UserType;

@class TSNetworking;

@interface Utilities : NSObject

// 幼儿园模块View通用方法
+(UIView*)createmodule:(NSString*)imgName title:(NSString*)moduleTitle count:(NSUInteger)count tag:(NSInteger)tag;

// 过滤数据库中的特殊字符
+(NSString*)sqliteEscape:(NSString*)keyWord;

//判断是否是纯数字
+(BOOL)isPureNumandCharacters:(NSString *)string;

+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect imgName:(NSString*)name;

//验证是不是手机号码
+(BOOL)validateMobile:(NSString *)mobileNum;

// 通过手机状态条获取当前网络
+(int)getNetWorkStates;

//检查当前网络是否连接
+(BOOL)isConnected;

// 用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。
//如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。这是因为我们执行像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0，造成照片内容和imageOrientaion不匹配。

+ (UIImage *)fixOrientation:(UIImage *)aImage;

// 图片预览时，确定图片的位置
+(NSInteger)findStringPositionInArray:(NSArray *)arr andImg:(UIImage *)img;

+ (void)takePhotoFromViewController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>*)controller;

// 动态设置权限
+(int)getType:(NSString *)privilegee;

// 新Url;
+(NSString*)newUrl;

// 添加后台需要的参数
+ (NSString*)appendUrlParams:(NSString *)reqUrl;
+ (NSString*)appendUrlParamsV2:(NSString *)reqUrl;

// 获取手机型号
+ (NSString *)deviceVersion;

+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

// 将linux时间戳的时间转化为可以显示的format格式
-(NSString*)linuxDateToString:(NSString*)date andFormat:(NSString*)format andType:(DateFormatType)type;

// 将nsdate的时间转化为可以显示的format格式
-(NSString*)nsDateToString:(NSDate*)date andFormat:(NSString*)format andType:(DateFormatType)type;

// 通过uid和type拼写头像url，再获取头像
-(NSString*) getAvatarFromUid:(NSString*) uid andType:(NSString*) type;

//字符串转日期
-(NSDate * )NSStringToNSDate: (NSString * )string;

-(NSString*) doDevicePlatform;

+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (NSString *)getHeadImagePath:(long long)cid;

// 获取文件路径
+(NSString *)getFilePath:(PathType)type;

// 去掉服务器返回结果文本中的<null>
+ (NSString *)replaceNull:(NSString *)source;

// 取得本地时间
+ (NSString *)GetCurLocalTime;

// 聊天页用户头像位置
+ (NSString *)getHeadImagePath:(long long)user_id imageName:(NSString *)imageName;

+ (CGFloat)heightForText:(NSString *)aText withFont:(UIFont *)font withWidth:(CGFloat)width;

+ (CGFloat)widthForText:(NSString*)aText withinWidth:(CGFloat)aWidth withFont:(UIFont*)font;

+ (CGSize)getContentSize:(NSString *)inputText withFont:(UIFont *)font;

+ (NSString *)getMyInfoDir;

+ (NSString *)timeIntervalToDate:(long long)timeInterval timeType:(NSInteger)type compareWithToday:(BOOL)bCompare;

+ (NSString *)getChatPicThumbDir:(long long)user_id;

+ (NSString *)getChatPicOriginalDir:(long long)user_id;

+ (BOOL)connectedToNetwork;

+ (long long)GetMsgId;

+(long long)getOthersMsgId:(NSString*)userId;//add by kate 2015.03.27

+ (void)showAlert:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cTitle otherButtonTitle:(NSString *)oTitle;

// 将一个array按照汉字以及英文顺序进行排序
//+(NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort andResultKeys:(NSMutableArray *)arrayHeadsKeys;
+(NSMutableArray *) getChineseStringArr:(NSMutableArray *)arrToSort andResultKeys:(NSMutableArray *)arrayHeadsKeys flag:(NSInteger)flag;

// 缩放图片大小
+(UIImage *)imageByScalingToSize:(CGSize)targetSize andImg:(UIImage *)sourceImg;

// 判断是否包含汉字
+(BOOL)isIncludeChineseInString:(NSString *)str;
// 用户语音位置
+ (NSString *)getChatAudioDir:(long long)user_id;

+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+(UIViewController *)getCurrentRootViewController;

+(NSString *)SystemDir;

+(void)doLogoutAndClean;

+(void)doSaveUserInfoToDefaultAndSingle:(NSDictionary *)infoDic andRole:(NSDictionary *)roleDic;

+(void)doSaveDynamicModule:(NSMutableArray *)arr;

+(void)doSaveSettingUserInfoToDefaultAndSingle:(NSDictionary *)infoDic andRole:(NSDictionary *)roleDic;

// 比较两个图片是否相同
+(BOOL)image:(UIImage *)aImage1 equalsTo:(UIImage *)aImage2;

// 动态获取字符串高度
+(CGSize)getStringHeight:(NSString *)str andFont:(UIFont *)font andSize:(CGSize)size;

// 获取UILabel中适合显示字符的高度
+ (CGSize)getLabelHeight:(UILabel *)label size:(CGSize)s;

// 在一个array中查找一个字符串所在的位置
+(NSInteger)findStringPositionInArray:(NSArray *)arr andStr:(NSString *)str;

+(void)doCancelAllRequest;

// 获取麦克风/录音权限
+ (BOOL)canRecord;

+ (BOOL)isBiggerThan:(float)a number:(float)b;

+ (NSString *)compareFloatA:(float)a floatB:(float)b;

/*
 设备相关.-------------------------
 */

// 获得设备型号
+ (NSString *)getCurrentDeviceModel;

// 获得数据上报设备内容
+ (NSString *)getDataReportStr:(NSString *)actionName;

// 获得设备唯一标识
+ (NSString *)getDeviceUUID;

// 获得app Version
+ (NSString *)getAppVersion;

// 获取当前屏幕的size
+ (CGSize)getScreenSize;

// 获取当前屏幕的size, 去掉了状态栏与导航栏的64高度
+ (CGSize)getScreenSizeWithoutBar;

// 获取当前屏幕无导航条的rect
+ (CGRect)getScreenRectWithoutBar;

// 按照ui给的效果图转换为5s的高度
+ (float)convertPixsH:(float)pixs6;
+ (float)convertPixsW:(float)pixs6;

+ (float)transformationHeight:(float)pixs6;
+ (float)transformationWidth:(float)pixs6;

/*
 hud相关.-------------------------
 */

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV;
+ (void)showSystemProcessingHud:(UIView *)descV;
+ (void)showFirstLoadProcessingHud:(UIView *)descV;


// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV;

// 执行请求成功与否的hud。
// text为显示的文字，传nil则为默认成功与失败。
+ (void)showSuccessedHud:(NSString *)text descView:(UIView *)descV;
+ (void)showFailedHud:(NSString *)text descView:(UIView *)descV;
+ (void)showTextHud:(NSString *)text descView:(UIView *)descV;

// 通用方法处理网络请求错误
+ (void)doHandleTSNetworkingErr:(TSNetworkingErrType)errType descView:(UIView *)descView;

+ (void)addCustomizedHud:(UIImageView *)imgView
                showText:(NSString *)showStr
               hideDelay:(NSInteger)delay
                descView:(UIView *)desV;

// 上滑对话框
+ (void)showPopupView:(NSString *)title items:(NSArray *)items;
+ (void)showPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view;

/*
 uid相关以及用户状态相关.-------------------------
 */

// 获取程序内部唯一uid，uid有问题则直接退出
+ (NSString *)getUniqueUid;

// 获取程序内部唯一uid
+ (NSString *)getUniqueUidWithoutQuit;

// 兼容DISPATCH模式调用
+ (NSString *)getUniqueUid4FRNetPool;
+ (void)doLogout4FRNetPool;

typedef enum{
    IdTypeLegally_NewsCommentReply = 0,                    // 自定义公告是否可回复
    IdTypeLegally_DiscussSubmmit,                          // 讨论区是否能够发表新话题
    IdTypeLegally_DiscussReply,                            // 讨论区是否能够回复
    IdTypeLegally_MomentsSubmmit,                          // 校友圈是否能够发表新话题
    IdTypeLegally_MomentsReply,                            // 校友圈是否能够回复

    IdTypeLegally_End = 999,
} UserIdentityLegallyType;

// 获取当前用户身份是否合法
+ (BOOL)isUserIdLegally:(UserIdentityLegallyType)idType;

// 获取当前用户身份
+ (UserType)getUserType;

/*
 加密相关.-------------------------
 */

// 对字符串进行md5加密
+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5With32:(NSString *)str;

// base64编解码
+ (NSString *)base64Encode:(NSString *)str;
+ (NSString *)base64Decode:(NSString *)str;

// base64编解码  DIY  用于短信验证码
+ (NSString *)encryptionDIY:(NSString *)str;
+ (NSString *)decryptionDIY:(NSString *)str;

// 32位md5加密之后用base64编码
+ (NSString *)md5AndEncodeBase64:(NSString *)str;

// 获取随机数
+ (int)getRandomNumber:(int)from to:(int)to;

/*
 页面显示相关.-------------------------
 */

// 空白页通用
+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect imgName:(NSString*)name textColor:(UIColor*)color startY:(float)start;
+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2;
+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;

// 空白页显示
+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name startY:(float)start;
// 空白页消失
+(void)dismissNodataView:(UIView*)desV;

// 无网络连接通用
+ (UIView*)showNoNetworkView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;

// 通用btn设置
+ (UIButton *)addButton:(UIButton *)btn title:(NSString *)title rect:(CGRect)rect;

// 点击推送栏进入详情页面之后，返回前画面，需要判断前画面是否是需要显示tabbar的。
+ (BOOL)isNeedShowTabbar:(UIViewController *)vc;


// for ffmegp
+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
// 更新主页模块最后一条id 2016.2.19
+(void)updateSchoolRedPoints:(NSString*)last mid:(NSString*)mid;
/// 更新班级模块最后一条id 2015.11.12
+(void)updateClassRedPoints:(NSString*)cid last:(NSString*)last mid:(NSString*)mid;
/// 更新成长空间模块最后一条id 2015.12.17
+(void)updateSpaceRedPoints:(NSString*)cid last:(NSString*)last mid:(NSString*)mid;
// 点击推送栏更新红点通用方法
+(void)updateRedPoint:(NSInteger)type last:(NSString*)last cid:(NSString*)cid mid:(NSString*)mid;
// 更新本地存储的红点字典
+(void)updateLocalData:(NSDictionary*)dic;
// 改变时间显示 传入时间戳 输出字符串判断昨天今天
+ (NSString *)changeDate:(NSString *)string;//Chenth 4.20
@end

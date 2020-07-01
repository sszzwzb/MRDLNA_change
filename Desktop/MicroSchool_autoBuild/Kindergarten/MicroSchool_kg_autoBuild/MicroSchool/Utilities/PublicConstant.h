//
//  PublicConstant.h
//  MicroSchool
//
//  Created by kate on 5/4/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tab 高度
#define HEIGHT_TAB_BAR                                      48.0f

// 共通 画面背景颜色
#define COMMON_BACKGROUND_COLOR [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0]

#pragma mark - ChatList
#define HEIGHT_CHATLIST_CELL                                66.0f

// 显示时间label的间隔
#define MESSAGE_TIME_CLEARANCE                              (2 * 60) // 消息展示时间间隔，2分钟

#define TAG_STATE_BUTTON                                    100102
#define TAG_ACTIONSHEET_RESEND                              100201
#define TAG_ACTIONSHEET_PHOTO                               100202

#define TABLE_SHOWING_COUNT                                 20  // chat最多显示的数目

#define MAX_TEXTLENGTH                                      5000 //聊天输入的最大字符数

#define BTN_KEYBOARD                                        0 //键盘图标按键
#define BTN_EMOTICOM                                        1 //表情图标按键

#pragma mark - table属性
// cell中头像宽度
#define WIDTH_HEAD_CELL_IMAGE                               55.0f
// cell中头像高度
#define HEIGHT_HEAD_CELL_IMAGE                              55.0f

#define LEFT_DISTANCE_CHAT_HEAD                             47//左边表情的头像的距离
#define RIGHT_DISTANCE_CHAT_HEAD                            47//右边表情的头像的距离//update 2016.07.16

#pragma mark - Chat cell
#define TIME_WIDTH                                          160 // 时间label的宽度
#define TIME_HEIGHT                                         20 // 时间label的高度

// 从服务器拉取聊天消息间隔定时泵
#define TIMER_PUMP_SHORT                                    5
#define TIMER_PUMP_LONG                                     15
#define TIMER_PUMP_LONGER                                   30
#define TIMER_PUMP_LONGERR                                  60
#define TIMER_PUMP_LONGEREST                                180


// PNG文件扩展名
#define FILE_PNG_EXTENSION                                  @".PNG"
// JPG文件扩展名
#define FILE_JPG_EXTENSION                                  @".JPG"
// amr文件扩展名
#define FILE_AMR_EXTENSION                                  @".amr"

#pragma mark - 消息收发区分
// 发送消息
#define MSG_IO_FLG_SEND                                     0
// 收到消息
#define MSG_IO_FLG_RECEIVE                                  1

#pragma mark - 消息发送状态
// 发送中
#define MSG_SENDING                                         11
// 发送成功
#define MSG_SEND_SUCCESS                                    12
// 发送失败
#define MSG_SEND_FAIL                                       13

#pragma mark - 消息接收状态
/// 接收中
#define MSG_RECEIVING                                       21
/// 接收成功（未读）
#define MSG_RECEIVED_SUCCESS                                22
/// 接收失败
#define MSG_RECEIVED_FAIL                                   23
/// 已读
#define MSG_READ_FLG_READ                                   24
/// 语音已读
#define MSG_READ_FLG_READ_AUDIO                             25


#define CELL_TYPE_TEXT                                      0
#define CELL_TYPE_PIC                                       1
#define CELL_TYPE_AUDIO                                     2
#define CELL_TYPE_System                                    3 // 邀请
#define CELL_TYPE_Remove                                    4 // 移除
#define CELL_TYPE_Leave                                     5 // 解散


//消息类型
#define MSG_TYPE_TEXT                                       0
#define MSG_TYPE_PIC                                        1
#define MSG_TYPE_Audio                                      2
#define MSG_TYPE_Pop                                        3

#define PIC_TYPE_HEAD                                       1
#define PIC_TYPE_THUMB                                      2
#define PIC_TYPE_ORIGINAL                                   3
#define PIC_TYPE_BUILDING                                   4

#define NOTIFICATION_UI_TOUCH_SELF_HEAD_IMAGE               @"NOTIFICATION_UI_TOUCH_SELF_HEAD_IMAGE" //显示自己资料画面

#define NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE               @"NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE" //显示用户资料画面
#define NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_GROUP         @"NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_GROUP" //显示用户资料画面
#define NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_MIX         @"NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_MIX" //显示用户资料画面

#define NOTIFICATION_UI_PRESSLONG_USER_HEAD_IMAGE_MIX @"NOTIFICATION_UI_PRESSLONG_USER_HEAD_IMAGE_MIX"//长按@某人
#define GETATNAMES_GROUP  @"GETATNAMES_GROUP"//@某人之后的通知
#define GETATNAMES_MIX  @"GETATNAMES_MIX"//@某人之后的通知
#define NOTIFICATION_GOT_CHAT_REFRESH                @"NOTIFICATION_GOT_CHAT_REFRESH"// 下载聊天语音文件成功后刷新一条



#define NOTIFICATION_UI_TOUCH_IMAGE                         @"NOTIFICATION_UI_TOUCH_IMAGE" //显示大图画面
#define NOTIFICATION_UI_TOUCH_IMAGE_GROUP                   @"NOTIFICATION_UI_TOUCH_IMAGE_GROUP" //显示大图画面

#define NOTIFICATION_UI_TOUCH_IMAGE_MIX                   @"NOTIFICATION_UI_TOUCH_IMAGE_MIX" //显示大图画面


#define NOTIFICATION_UI_TOUCH_PLAY_AUDIO                    @"NOTIFICATION_UI_TOUCH_PLAY_AUDIO" //播放语音
#define NOTIFICATION_UI_TOUCH_PLAY_AUDIO_GROUP              @"NOTIFICATION_UI_TOUCH_PLAY_AUDIO_GROUP" //播放语音
#define NOTIFICATION_UI_TOUCH_PLAY_AUDIO_MIX              @"NOTIFICATION_UI_TOUCH_PLAY_AUDIO_MIX" //播放语音

#define NOTIFICATION_UI_DELETE_MSG                         @"NOTIFICATION_UI_DELETE_MSG" // 删除消息
#define NOTIFICATION_UI_DELETE_MSG_GROUP                   @"NOTIFICATION_UI_DELETE_MSG_GROUP" // 删除消息
#define NOTIFICATION_UI_DELETE_MSG_MIX                     @"NOTIFICATION_UI_DELETE_MSG_MIX"//删除消息

#define NOTIFICATION_UI_CHANGE_USER                         @"NOTIFICATION_UI_CHANGE_USER" // 更换聊天对象
#define NOTIFICATION_DB_GET_MORECHATINFODATA                @"NOTIFICATION_DB_GET_MORECHATINFODATA" //获取更多聊天详细数据
#define NOTIFICATION_UI_TANSPOND_MSG                         @"NOTIFICATION_UI_TANSPOND_MSG" // 转发消息



#define LOCAL_DB_CHANGE                                     @"LOCAL_DB_CHANGE"
#define COMMON_TABLEVIEWCELL_SELECTED_COLOR [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define NO_NAME_USER                                        @"无名称"

#define DIR_NAME_CHAT                                       @"chat"
// 聊天保存路径
#define DIR_NAME_USER_INFO                                  @"UserInfo"
// 原始图片文件保存路径
#define DIR_NAME_ORIGINAL_IMAGE                             @"OriginalImage"
// 缩略图片文件保存路径
#define DIR_NAME_THUMB_IMAGE                                @"ThumbImage"
// 语音文件保存路径
#define DIR_NAME_AUDIO_IMAGE                                @"ArmAudio"



#pragma mark - JPG保存的质量
#define JPG_COMPRESSION_QUALITY                             0.50f

#pragma mark - 状态栏属性
// 状态栏 高度
#define HEIGHT_STATUS_BAR                                   20.0f

#pragma mark - 导航条属性
// 导航条 高度
#define HEIGHT_NAVIGATION_BAR                               44.0f

#pragma mark - 文字输入框属性
// 文字输入框高度
#define HEIGHT_INPUT_BAR                                    52.0f
#define HEIGHT_INPUT_BAR                                    44.0f
// 输入栏上按钮高度
#define HEIGHT_INPUT_BAR_BUTTON                             43.0f

#define PROGRAM_ERROR                                       @"PROGRAM_ERROR"//程序出错通知UI

#define NetworkNotConnected  @"网络异常"




//*************************************************************************************************

// 2.7版本获取第一次获取token标志位 1为获取完成 nil为未获取成功
#define IS_NEW_VERSION_2_7_GET_TOKEN_SUCCESS                @"IS_NEW_VERSION_2_7_GET_TOKEN"

// 2.7版本教育页面是否显示
#define IS_NEW_VERSION_2_7_GUIDE_VIEW                @"IS_NEW_VERSION_2_7_GUIDE_VIEW"

// 2.8版本教育页面是否显示
#define IS_NEW_VERSION_2_8_GUIDE_VIEW                @"IS_NEW_VERSION_2_8_GUIDE_VIEW"

// 2.9.2版本教育页面是否显示
#define IS_NEW_VERSION_2_9_2_GUIDE_VIEW                @"IS_NEW_VERSION_2_9_2_GUIDE_VIEW"

// 存储登录token
#define USER_LOGIN_TOKEN                                    @"USER_LOGIN_TOKEN"

// 新版本功能提示宏
// version 2.6
// 更新日志红点
#define IS_NEW_VERSION_2_6_SHOW_FEATURE                     @"IS_NEW_VERSION_2_6_SHOW_FEATURE"


// 自定义公告通知
// 管理员删除自定义公告回复
#define NOTIFICATION_UI_NEWS_DELETE_COMMENT                 @"NOTIFICATION_UI_NEWS_DELETE_COMMENT"

// 校友圈相关通知
// 屏蔽动态通知
#define NOTIFICATION_UI_MOMENTS_CLICKBLOCK                  @"NOTIFICATION_UI_MOMENTS_CLICKBLOCK"
// 点击分享链接通知
#define NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK             @"NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK"
// 点击网址链接
#define NOTIFICATION_UI_MOMENTS_CLICKWEBLINK                @"NOTIFICATION_UI_MOMENTS_CLICKWEBLINK"
// 点击正文复制
#define NOTIFICATION_UI_MOMENTS_CLICKCOPY                   @"NOTIFICATION_UI_MOMENTS_CLICKCOPY"
// 点击自己的评论进行删除
#define NOTIFICATION_UI_MOMENTS_CLICKDELETE                 @"NOTIFICATION_UI_MOMENTS_CLICKDELETE"

// 校校通相关通知
// 收藏学校之后刷新收藏页面
#define NOTIFICATION_UI_SCHOOLEXHI_REFLASHVIEW              @"NOTIFICATION_UI_SCHOOLEXHI_REFLASHVIEW"

// 群组聊天相关通知
// 用户点击成员列表其中一个时通知
#define NOTIFICATION_UI_GROUPCHAT_MEMBERLISTCLICK            @"NOTIFICATION_UI_GROUPCHAT_MEMBERLISTCLICK"
// 用户点击成员列表移除成员时的通知
#define NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST           @"NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST"
// 修改群名字后的通知
#define NOTIFICATION_UI_GROUPCHAT_CHANGEGROUPNAME            @"NOTIFICATION_UI_GROUPCHAT_CHANGEGROUPNAME"
// 增加群成员时的通知
#define NOTIFICATION_UI_GROUPCHAT_ADDMEMBER                  @"NOTIFICATION_UI_GROUPCHAT_ADDMEMBER"

#define TEXT_NONETWORK @"呀，网络好像有点问题"

// 清除聊天记录
#define NOTIFICATION_DB_CLEAR_CHAT_MESSAGES    @"#define NOTIFICATION_DB_CLEAR_CHAT_MESSAGES"//清除聊天记录

// 上一个用户登录的信息，也用于区别注册流程的填写用户详细信息是否完成
// 用户名或者密码为空的话，就认为注册没有完成，就会进入注册中详细信息页面
// 字典包含：username, password, uid
#define G_NSUserDefaults_UserLoginInfo          @"weixiao_dldfsygjzx_userLoginInfo"

// 保存用户登录成功之后的uid，之后所有调用请求的uid都取这个值
// 在用户主动或者被动登出的时候，才去清掉uid。
#define G_NSUserDefaults_UserUniqueUid           @"zhixiao_userUniqueUid"

// 用户登录的详细信息，目前只用于判断用户的注册流程是否完成，后续可以添加其他字段
// 字典包含：用户名
#define G_NSUserDefaults_UserLoginDetailInfo    @"weixiao_dldfsygjzx_userLoginDetailInfo"

// 绑定百度云推送
#define NOTIFICATION_UI_BIND_BAIDU_PUSH         @"NOTIFICATION_UI_BIND_BAIDU_PUSH"

// 解除绑定百度云推送
#define NOTIFICATION_UI_UNBIND_BAIDU_PUSH       @"NOTIFICATION_UI_UNBIND_BAIDU_PUSH"

// 推送开关通知
#define NOTIFICATION_PUSH_Switch                @"NOTIFICATION_PUSH_Switch"

// 从服务器拉取聊天消息间隔定时泵
//#define TIMER_PUMP_SHORT                                    8
//#define TIMER_PUMP_LONG                                     28
#define NOTIFICATION_DB_GET_CHAT_LIST_DATA                  @"NOTIFICATION_DB_GET_CHAT_LIST_DATA"// 从DB取得聊天列表数据
#define NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP            @"NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP"// 从DB取得聊天列表数据
#define NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP_TEACHER            @"NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP_TEACHER"// 从DB取得聊天列表数据


#define NOTIFICATION_DB_GET_CHAT_DETAIL_DATA                @"NOTIFICATION_DB_GET_CHAT_DETAIL_DATA"// 从DB取得聊天数据
#define NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP          @"NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP"// 从DB取得聊天数据

#define NOTIFICATION_UI_MAIN_NEW_MESSAGE                    @"NOTIFICATION_UI_MAIN_NEW_MESSAGE"// 有新消息主画面显示new图标
#define NOTIFICATION_UI_MAIN_NEW_CLASSMSG                    @"NOTIFICATION_UI_MAIN_NEW_CLASSMSG"// 我的班级有新消息主画面显示new图标

#define NOTIFICATION_GET_PROFILE                    @"NOTIFICATION_GET_PROFILE"// 重新获取个人资料
// 通讯录列表类型
typedef enum{
    //    FriendViewType_NewFriend = 0,             // 新的朋友
    FriendViewType_Classmate = 0,             // 我的同学
    FriendViewType_Tacher,                    // 老师
    FriendViewType_Parent,                    // 家长
    
    FriendViewType_End = 999,
} FriendViewType;




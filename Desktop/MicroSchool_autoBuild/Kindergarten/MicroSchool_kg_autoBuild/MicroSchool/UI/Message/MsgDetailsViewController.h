//
//  MsgDetailsViewController.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"
#import "ChatListObject.h"
#import "ChatDetailObject.h"
#import "HPGrowingTextView.h"
#import "MsgDetailCell.h"
#import "MsgTypeSelectTool.h"
#import "BaseViewController.h"
#import "FaceBoard.h"
#import "RecordAudio.h"
#import "FriendProfileViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MsgDetailsViewController  : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HPGrowingTextViewDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate,FaceBoardDelegate,RecordAudioDelegate>
{
    //聊天目标
    UserObject *user;
    //聊天详细列表
    UITableView *chatTableview;
    // 聊天详细数据
    NSMutableArray *chatDetailArray;
    
    //时间显示比较的标准时间
    NSDate *currentShowTime;
    
    //显示以前更多的聊天纪录
    NSInteger earliestRowID;
    UIActivityIndicatorView *waitForLoadMore;
    BOOL isMoreDataLoading;
    
    // 输入工具栏
    UIView *inputBar;
    //聊天方式选择工具条
    MsgTypeSelectTool *selectTool;
    // 输入框
    HPGrowingTextView *inputTextView;
    UIImageView *entryImageView;
    UIImagePickerController *imagePicker;
    
    //表情/键盘按键类型
    UIButton *keyboardBtn;
    UIButton *AudioBtn;
    // 按住说话按钮
    UIButton *audioButn;
    int keyboardButtonType;
    // 普通键盘
    UIView *normalKeyboard;
    // 表情键盘
    FaceBoard *faceBoard;
    
    // 倒计时 判断是否超过60s
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
    
    // 录音lib
    RecordAudio *recordAudio;
    NSData *curAudio;
    BOOL isRecording;
    
    // 录音秒数
    NSInteger recordSec;
    
    // 录音文件路径
    NSString *amrPath;
    
    // cell行数
    NSInteger numOfCellAudioPlaying;
    
    // 点击了多功能菜单或者语聊
    BOOL isActionStart;
    
    // msgid对应数组的索引字典，用于快速定位消息体在数组中的位置进行修改
    NSMutableDictionary *msgIndexDic;
    
    // 要重发的消息
    ChatDetailObject *resendMsg;
    
    BOOL showSelectTool;
    
    CGSize winSize;
    
    NSString *timeFirst;// 第一次进入此页的时间 用于显示第一条默认消息的时间
    
    UIButton *sendButton;
    
    MBProgressHUD *HUD;
    
    UIButton *actionBtnText;
    
    UIImageView *entryBackgroundImageView;//底部的线
    
    NSMutableArray *heightArray;// 高度数组 add 2015.07.25
    
    float tableOffset;//2015.08.26 滑动到屏幕底部时候的offset的y
    
    BOOL isScrollToBottom;//2015.08.26 记录在滑动到屏幕上方时来消息时是否允许自动滚动到屏幕底部
    
    NSString *lastMsgID;//2015.12.23
    
}
@property (nonatomic,strong) NSString *fromName;//从通讯录来/从意见与反馈来
@property (nonatomic, retain) UserObject *user;
@property (nonatomic, retain) NSMutableArray *chatDetailArray;
@property (nonatomic, retain) NSDate *currentShowTime;
@property (nonatomic, retain) UIView *inputBar;
@property (nonatomic, retain) HPGrowingTextView *inputTextView;

// 要重发的消息
@property (nonatomic, retain) ChatDetailObject *resendMsg;
@property (nonatomic, retain) NSString *textBak;

@property (nonatomic, assign) long long msgID;
@property (nonatomic, assign) int chatType;

@property(nonatomic, retain) NSString *frontName;

- (void)setChatDetailObjectTimeLabel:(ChatDetailObject*)entity;

- (void)changeChatTool:(int)chatType;

- (void)getChatDetailData;

- (ChatListObject *)saveMsgToChatList:(ChatDetailObject *)chatDetail;

-(id)initWithFromName:(NSString*)fromName;//意见与反馈

// 增加的多图浏览查看功能
@property(nonatomic, retain) NSMutableArray *pics;

@end
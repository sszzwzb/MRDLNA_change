//
//  MsgDetailsMixViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/19.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserObject.h"
#import "MixChatListObject.h"
#import "MixChatDetailObject.h"
#import "HPGrowingTextView.h"
#import "MsgDetailCell.h"
#import "MsgTypeSelectTool.h"
#import "FaceBoard.h"
#import "RecordAudio.h"
#import "FriendProfileViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MsgDetailsMixViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HPGrowingTextViewDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate,FaceBoardDelegate,RecordAudioDelegate>{
    
    //聊天目标
    //UserObject *user;
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
    
    BOOL isDownloaded;
    
    // 点击了多功能菜单或者语聊
    BOOL isActionStart;
    
    // msgid对应数组的索引字典，用于快速定位消息体在数组中的位置进行修改
    NSMutableDictionary *msgIndexDic;
    
    // 要重发的消息
    MixChatDetailObject *resendMsg;
    
    BOOL showSelectTool;
    
    CGSize winSize;
    
    NSString *timeFirst;// 第一次进入此页的时间 用于显示第一条默认消息的时间
    
    UIButton *sendButton;
    
    MBProgressHUD *HUD;
    
    long long uid;
    
    UIButton *actionBtnText;
    
    UIImageView *entryBackgroundImageView;//底部的线
    
    NSMutableArray *heightArray;// 高度数组 add 2015.07.25
    
    BOOL isReGetChatDetailData; // 调出相册的时候系统方法会自动调用viewWillApear 2015.08.13
    
    float tableOffset;//2015.08.27 滑动到屏幕底部时候的offset的y
    
    BOOL isScrollToBottom;//2015.08.27 记录在滑动到屏幕上方时来消息时是否允许自动滚动到屏幕底部
    
    // 以下四个用于判断滚动方向 2015.08.27
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
    
    int scrollFlag;// 0 drag 1 down 2 up
    
    BOOL isDelete;
    
    NSMutableArray *atArray;//at某些人的数组
    
    NSString *atText;//判断输入的是否是@符号

    
}

@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,assign)long long gid;
@property(nonatomic,assign)long long cid;
@property (nonatomic,strong) NSString *fromName;//从建群来/从列表来
@property (nonatomic, retain) UserObject *user;
@property (nonatomic, retain) NSMutableArray *chatDetailArray;
@property (nonatomic, retain) NSDate *currentShowTime;
@property (nonatomic, retain) UIView *inputBar;
@property (nonatomic, retain) HPGrowingTextView *inputTextView;

// 要重发的消息
@property (nonatomic, retain) MixChatDetailObject *resendMsg;
@property (nonatomic, retain) NSString *textBak;

@property (nonatomic, assign) long long msgID;
@property (nonatomic, assign) int chatType;

@property(nonatomic, retain) NSString *frontName;

// 增加的多图浏览查看功能
@property(nonatomic, retain) NSMutableArray *pics;
@property(nonatomic, assign) NSInteger isViewGroupMember;//是否可以查看群成员

@property(nonatomic, retain) MixChatListObject *groupChatList;
@property(nonatomic, retain) NSString *userNumber;// 群成员数量


- (void)setChatDetailObjectTimeLabel:(MixChatDetailObject *)entity;

- (void)changeChatTool:(int)chatType;

// 获取聊天数据
- (void)getChatDetailData;

- (MixChatListObject *)saveMsgToChatList:(MixChatDetailObject *)chatDetail;

@property(nonatomic, assign) NSInteger chatArrCount;

@property(nonatomic, retain) NSString *sid;

@end

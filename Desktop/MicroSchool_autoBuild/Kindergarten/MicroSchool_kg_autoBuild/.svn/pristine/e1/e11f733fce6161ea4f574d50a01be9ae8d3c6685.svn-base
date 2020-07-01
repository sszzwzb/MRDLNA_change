//
//  DiscussDetailViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-14.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "DiscussDetailCell.h"
#import "DiscussDetailTopCell.h"
#import "DiscussHistoryViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "FaceBoard.h"// add by kate
#import "OHAttributedLabel.h"//add by kate
#import "NSAttributedString+Attributes.h"//add by kate
// audio
#import "RecordAudio.h"

#import "FileViewerViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "UIActivityIndicatorView+AFNetworking.h"
#import "AFNetworking.h"

#import "SingleWebViewController.h"

@class OHAttributedLabel;

@interface DiscussDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate, UIWebViewDelegate, UITextViewDelegate,FaceBoardDelegate, UIImagePickerControllerDelegate, RecordAudioDelegate,OHAttributedLabelDelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSDictionary* threadDic;
    NSMutableArray* discussArray;
    
    NSString *startNum;
    NSString *endNum;
    
    float webHight;
    UIWebView *shopWebViewHiden;
    UIWebView *shopWebView;
    
    NSString *sendText;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    //-----add by kate------//
    UIView *toolBar;
    UIButton *keyboardButton;
    UIButton *AudioButton;
    UITextView *_inputTextView;
    FaceBoard *faceBoard;
    BOOL isFirstShowKeyboard;
    BOOL isButtonClicked;
    BOOL isKeyboardShowing;
    BOOL isSystemBoardShow;
    CGFloat keyboardHeight;
    int clickFlag;//1表情 2图片 3语音
    
    UIView *addImageView;//
    UIView *addAudioView;//
    UIButton *audioButn;

    //----------------------//

    // 回复时语音相关 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    UIButton *pressRecordButton;
    UIButton *playRecordButton;
    UIButton *deleteRecordButton;
    UIImageView *animationImageView;
    UIImageView *playImageView;
    
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
    
    NSString *cellClickedNum;
    
    NSString *isPlayStatus;

    BOOL isCellAudioPlay;
    BOOL isTopCellAudioPlay;

    NSString *numOfCellAudioPlaying;
    
    BOOL isPressAudioButton;
    
    // 回复时语音相关 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    // 回复时图片相关 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    UIButton *photoSelectButton;
    UIButton *photoDeleteButton;

    UIImageView *photoBgImageView;
    UIImageView *photoFlagImageView;

    BOOL isSelectPhoto;
    
    NSString *imagePath;
    // 回复时图片相关 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    // 主题语音相关 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    UIButton *playRecordButtonSubject;
    UIImageView *animationImageViewSubject;
    UIImageView *playImageViewSubject;

    BOOL isAudioSubject;
    UILabel *lodingLabel;

    // 主题语音相关 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    BOOL isReply;
    NSString *replyPid;
    
    NSInteger test;
    
    // 浏览痕迹
    NSDictionary *history;
    
    NSMutableArray* cellHeightArray;// cell高度存储
    
    NSString *lastId;//每次拉取数据后后台返回的最后一条id
    
    
    NSString *pid;// 这条评论的id
    
    UIImageView *entryImageView;

}

@property (retain, nonatomic) NSString *tid;
@property (retain, nonatomic) NSString *cid;

// 1 讨论区 2 班级公告 3作业 4 班级讨论区 5教育局版本校校通tab
@property (assign, nonatomic) int flag;

// 1 讨论区 2 班级公告
@property (assign, nonatomic) NSString* realName;

-(void)reflashTable;

@property (nonatomic, retain) NSDictionary *emojiDic;

@property (retain, nonatomic) NSString *disTitle;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;

// 显示回复xxx的信息
@property (retain, nonatomic) NSString *replyTo;
@property (retain, nonatomic) UILabel *replyToLabel;

// 增加了多图滑动查看,图片数组
@property (retain, nonatomic) NSArray *pics;

- (CGSize)frameSizeForAttributedString:(NSAttributedString *)attributedString;

@property(nonatomic,retain)MarkupParser *textParser;// add by kate

// 类型
// schoolExhi 从教育局版的第二个tab进入
@property (retain, nonatomic) NSString *viewType;

// 校校通tab的sid
@property(nonatomic,strong) NSString *schoolExhiId;

@end

//
//  SubmitViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-13.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "FaceBoard.h"// add by kate
#import "RecordAudio.h"

@interface SubmitViewController : BaseViewController<UITextFieldDelegate, HttpReqCallbackDelegate, UITextViewDelegate, UIAlertViewDelegate,FaceBoardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,RecordAudioDelegate>
{
    // 背景scrollview
    UIScrollView *_scrollerView;
    UITextField *text_title;
    UITextView *text_content;
    UITextView *textViewDisplay;
    //---add by kate----------
    UIView *toolBar;
    UIButton *keyboardButton;
    UIButton *addImageButton;
    UIButton *AudioButton;
    UIButton *commentBtn;// 评 2015.08.20
    FaceBoard *faceBoard;
    BOOL isFirstShowKeyboard;
    BOOL isButtonClicked;
    BOOL isKeyboardShowing;
    BOOL isSystemBoardShow;
    CGFloat keyboardHeight;
    int clickFlag;
    UIButton *audioButn;
    UIView *addAudioView;
    UIView *addImageView;
    BOOL *isClickImg;
    //------------------------
    
    // 回复时图片相关 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    UIButton *photoSelectButton;
    UIButton *photoDeleteButton;
    BOOL isSelectPhoto;
    NSString *imagePath;
    
    UIImageView *photoBgImageView;
    UIImageView *photoFlagImageView;//图片红点
    UIImageView *audioFlagImageView;//语音红点
    UILabel *photoNumLabel;
    UILabel *audioNumLabel;

    NSMutableDictionary *imageArray;
    
    NSInteger pressButtonTag;

    NSInteger totalButtonImgNum;
    NSMutableArray *buttonArray;
    NSMutableArray *buttonFlagViewArray;
    
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
    
    // 主题语音相关 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    UIButton *playRecordButtonSubject;
    UIImageView *animationImageViewSubject;
    UIImageView *playImageViewSubject;
    
    BOOL isAudioSubject;
    UILabel *lodingLabel;
    
    // 主题语音相关 ↑↑↑↑↑↑↑↑↑
    
    UIButton *button_photoMask0;//add by kate 2014.10.09
    
    float contentHeight;//2015.07.08
    
    UIImageView *imgView_line;
    
    
}
@property(nonatomic,assign)int flag;//1主页的 2班级公告 3班级讨论区
@property(nonatomic,assign)NSString *cid;
@property (retain, nonatomic) UIView *viewWhiteBg;

@end

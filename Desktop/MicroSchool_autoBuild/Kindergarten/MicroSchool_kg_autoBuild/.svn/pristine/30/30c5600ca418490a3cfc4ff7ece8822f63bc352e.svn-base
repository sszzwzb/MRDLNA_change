//
//  HomeworkSubmitViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-6.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "FaceBoard.h"// add by kate
#import "RecordAudio.h"

@interface HomeworkSubmitViewController : BaseViewController<UITextFieldDelegate, HttpReqCallbackDelegate, UITextViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate,FaceBoardDelegate,UINavigationControllerDelegate,RecordAudioDelegate>
{
    // 背景scrollview
    UIScrollView *_scrollerView;
    
    UILabel *label_username;

    // 标题
    UITextField *text_title;
    
    // 时间
    UITextField *text_time;

    // 内容
    UITextView *text_content;
    
    //UIImageView *imgView_line3;
    
    // 添加附件图片背景
    //UIImageView *imgView_bg_photo;
    
    NSMutableArray *mutable_photoList;
    
    UIImage *newImage;
    
    //NSMutableDictionary *imageArray;

//    UIButton *button_photoMask1;
//    UIButton *button_photoMask2;
//    UIButton *button_photoMask3;
//    UIButton *button_photoMask4;
//    UIButton *button_photoMask5;
//    UIButton *button_photoMask6;
//    UIButton *button_photoMask7;
//    UIButton *button_photoMask8;
//    UIButton *button_photoMask9;
//
//    NSString *imagePath1;
//    NSString *imagePath2;
//    NSString *imagePath3;
//    NSString *imagePath4;
//    NSString *imagePath5;
//    NSString *imagePath6;
//    NSString *imagePath7;
//    NSString *imagePath8;
//    NSString *imagePath9;
    
   // NSInteger pressButtonTag;
    
    //---add by kate----------
    UIView *toolBar;
    UIButton *keyboardButton;
    UIButton *addImageButton;
    UIButton *AudioButton;
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
    UISwitch *allowSwitch;//switch开关 2015.08.21
    
}
@property(nonatomic,assign)int flag;// 2 自定义公告
@property(nonatomic,strong)NSString *modelName;
@end

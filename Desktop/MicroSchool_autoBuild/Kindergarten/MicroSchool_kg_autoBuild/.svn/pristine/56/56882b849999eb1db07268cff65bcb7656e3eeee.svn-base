//
//  CustomInputBar.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/7/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "CustomInputBar.h"

@implementation CustomInputBar
@synthesize controller;
@synthesize keyboardButton;
@synthesize AudioButton;
@synthesize inputTextView;
@synthesize faceBoard;
@synthesize photoFlagImageView;
@synthesize addImageView;
@synthesize addAudioView;
@synthesize replyToLabel;
@synthesize entryImageView;
@synthesize photoDeleteButton;
@synthesize  photoSelectButton;
@synthesize audioButn;
@synthesize playRecordButtonSubject;
@synthesize playRecordButton;
@synthesize playImageView;
@synthesize animationImageViewSubject;
@synthesize animationImageView;
@synthesize deleteRecordButton;
@synthesize photoNumLabel;
@synthesize audioNumLabel;
@synthesize button_photoMask0;
@synthesize audioFlagImageView;

- (id)initWithFrame:(CGRect)rect type:(NSInteger)barType withController:(id)_controller
{
    self = [super init];
    
    if (self) {
        
        self.controller = _controller;
        self.frame = rect;
        [self showInputBar:barType rect:rect];
        
    }
    
    return self;
}

-(void)showInputBar:(NSInteger)barType rect:(CGRect)rect{
    
    switch (barType) {
            
        case inputBar_msg:
            
            break;
        case inputBar_isPic:{
            
            //表情按钮
            keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
            keyboardButton.tag = 122;
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                            forState:UIControlStateNormal];
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                            forState:UIControlStateHighlighted];
            [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:keyboardButton];
            
            UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addImageButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);
            addImageButton.tag = 123;
            [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_d.png"]
                            forState:UIControlStateNormal];
            [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_p.png"]
                            forState:UIControlStateHighlighted];
            [addImageButton addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addImageButton];
            
            // 选择图片后的红点啊
            photoFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              addImageButton.frame.origin.x + addImageButton.frame.size.width -10,
                                                                              addImageButton.frame.origin.y - 5,
                                                                              12,
                                                                              12)];
            photoFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
            photoFlagImageView.hidden = YES;
            [self addSubview:photoFlagImageView];
            
            inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(80.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33 - 37, 33)];
            inputTextView.delegate = self.controller;
            inputTextView.returnKeyType = UIReturnKeyDone;
            inputTextView.backgroundColor = [UIColor clearColor];
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
            singleTouch.delegate = self.controller;
            [inputTextView addGestureRecognizer:singleTouch];
            
            
            replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
            replyToLabel.enabled = NO;
            replyToLabel.text = @"";
            replyToLabel.font =  [UIFont systemFontOfSize:13];
            replyToLabel.textColor = [UIColor grayColor];
            [inputTextView addSubview:replyToLabel];
            
            
            UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
            UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
            entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
            entryImageView.frame = CGRectMake(80.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33 - 37, 33);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            entryImageView.userInteractionEnabled = YES;
            
            [self addSubview:entryImageView];
            [self addSubview:inputTextView];
            
            
            AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
            AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
            AudioButton.tag = 124;
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                         forState:UIControlStateNormal];
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                         forState:UIControlStateHighlighted];
            [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:AudioButton];
      
            
            //显示图片的键盘view
            addImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
            addImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            photoSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            photoSelectButton.tag = 1;
            photoSelectButton.frame = CGRectMake(20,
                                                 20,
                                                 50,
                                                 50);
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            [photoSelectButton addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            [addImageView addSubview:photoSelectButton];
            
            // 删除图片的button啊
            photoDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            photoDeleteButton.frame = CGRectMake(photoSelectButton.frame.origin.x + photoSelectButton.frame.size.width - 5,
                                                 photoSelectButton.frame.origin.y - 5,
                                                 12,
                                                 12);
            [photoDeleteButton setBackgroundImage:[UIImage imageNamed:@"icon_class_del.png"] forState:UIControlStateNormal] ;
            [photoDeleteButton setBackgroundImage:[UIImage imageNamed:@"icon_class_del.png"] forState:UIControlStateHighlighted] ;
            [photoDeleteButton addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            photoDeleteButton.hidden = YES;
            [addImageView addSubview:photoDeleteButton];
            
            //显示语音的键盘view
            addAudioView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
            addAudioView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            //点击录制语音
            audioButn = [UIButton buttonWithType:UIButtonTypeCustom];
            audioButn.frame = CGRectMake(5.0, 5.0, WIDTH-52, 33);
            audioButn.tag = 126;
            [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
            [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
            [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_d.png"]
                                 forState:UIControlStateNormal];
            [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_p.png"]
                                 forState:UIControlStateHighlighted];
            [audioButn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
            [audioButn addTarget:self action:@selector(recordEnd:) forControlEvents:UIControlEventTouchUpInside];
            [audioButn addTarget:self action:@selector(recordEndOutside:) forControlEvents:UIControlEventTouchUpOutside];
            [audioButn addTarget:self action:@selector(recordDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [audioButn addTarget:self action:@selector(recordDragIn:) forControlEvents:UIControlEventTouchDragEnter];
            
            audioButn.hidden = YES;
            [self addSubview:audioButn];
            
            //--------------------------------audio start------------------------------------------------
            // 初始化audio lib
//            recordAudio = [[RecordAudio alloc]init];//放在各个类中写
//            recordAudio.delegate = self;
            
            // 播放button
            playRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            playRecordButton.frame = CGRectMake((WIDTH-80)/2,
                                                20,
                                                80,
                                                39);
            [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                        forState:UIControlStateNormal];
            [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                        forState:UIControlStateHighlighted];
            
            [playRecordButton addTarget:self action:@selector(recordPlay_btnclick:) forControlEvents:UIControlEventTouchDown];
            [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            playRecordButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            [playRecordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            
            playRecordButton.hidden = YES;
            [addAudioView addSubview:playRecordButton];
            
            // 播放按钮上得播放三角
            playImageView = [[UIImageView alloc]init];
            playImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2 - 5,
                                             playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
            playImageView.image = [UIImage imageNamed:@"amr/icon_media_play.png"];
            playImageView.hidden = YES;
            [addAudioView addSubview:playImageView];
            
            // 播放中的音量动画
            animationImageView = [[UIImageView alloc]init];
            animationImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2,
                                                  playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
            //将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"amr/icon_send_horn_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn01_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn02_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn03_bbs.png"],nil];
            //设置动画时间
            animationImageView.animationDuration = 0.75;
            //设置动画次数 0 表示无限
            animationImageView.animationRepeatCount = 0;
            [addAudioView addSubview:animationImageView];
            
            // 删除音频button
            deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteRecordButton.frame = CGRectMake(playRecordButton.frame.origin.x + playRecordButton.frame.size.width - 5,
                                                  playRecordButton.frame.origin.y - 5, 20, 20);
            [deleteRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/icon_media_cancel.png"]
                                          forState:UIControlStateNormal];
            [deleteRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/icon_media_cancel.png"]
                                          forState:UIControlStateHighlighted];
            
            [deleteRecordButton addTarget:self action:@selector(recordDelete_btnclick:) forControlEvents:UIControlEventTouchDown];
            deleteRecordButton.hidden = YES;
            [addAudioView addSubview:deleteRecordButton];
            //--------------------------------audio end------------------------------------------------
        }
            
            break;
        case inputBar_onlyFace:{
            
            inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
            inputTextView.delegate = self.controller;
            inputTextView.backgroundColor = [UIColor clearColor];
            //textView.returnKeyType = UIReturnKeyDone;
            
            //---update 2015.01.27-----------------------------------------------
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
            singleTouch.delegate = self.controller;
            [inputTextView addGestureRecognizer:singleTouch];
            
            
            UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
            UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
            entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
            entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            entryImageView.userInteractionEnabled = YES;
            [self addSubview:entryImageView];
            [self addSubview:inputTextView];
//            
//            if (!faceBoard) {//定义在各个类中
//                
//                faceBoard = [[FaceBoard alloc] init];
//                faceBoard.delegate = self;
//                faceBoard.maxLength = 500;// 2015.07.21
//                faceBoard.inputTextView = textView;
//            }
//            isFirstShowKeyboard = YES;
//            isClickImg = NO;
//            clickFlag = 0;
//            
            //表情按钮
            keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
            keyboardButton.tag = 122;
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                            forState:UIControlStateNormal];
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                            forState:UIControlStateHighlighted];
            [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:keyboardButton];
            
            AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
            AudioButton.frame = CGRectMake(284.0 - 9, 5.0, 40.0, 33.0);
            AudioButton.tag = 124;
            [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                         forState:UIControlStateNormal];
            [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                         forState:UIControlStateHighlighted];
            [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:AudioButton];

        }
            
            break;
        case inputBar_submit:{
            
            
            //表情按钮
            keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
            keyboardButton.tag = 122;
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                            forState:UIControlStateNormal];
            [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                            forState:UIControlStateHighlighted];
            [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:keyboardButton];
            
            UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addImageButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);
            addImageButton.tag = 123;
            [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_d.png"]
                            forState:UIControlStateNormal];
            [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_p.png"]
                            forState:UIControlStateHighlighted];
            [addImageButton addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addImageButton];
            
            AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
            AudioButton.frame = CGRectMake(75, 5.0, 33.0, 33.0);
            AudioButton.tag = 124;
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                         forState:UIControlStateNormal];
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                         forState:UIControlStateHighlighted];
            [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:AudioButton];
            
            // 选择图片后的红点啊
            photoFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              addImageButton.frame.origin.x + addImageButton.frame.size.width -10,
                                                                              addImageButton.frame.origin.y - 5,
                                                                              14,
                                                                              14)];
            photoFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
            photoFlagImageView.hidden = YES;
            [self addSubview:photoFlagImageView];
            
            // 图片红点上面的数字
            photoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                      addImageButton.frame.origin.x + addImageButton.frame.size.width - 6,
                                                                      addImageButton.frame.origin.y - 4,
                                                                      12,
                                                                      12)];
            photoNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
            photoNumLabel.font = [UIFont boldSystemFontOfSize:10.0f];
            photoNumLabel.textColor = [UIColor whiteColor];
            photoNumLabel.backgroundColor = [UIColor clearColor];
            photoNumLabel.hidden = YES;
            [self addSubview:photoNumLabel];
            
            //语音上的红点
            audioFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              AudioButton.frame.origin.x + AudioButton.frame.size.width -10,
                                                                              AudioButton.frame.origin.y - 5,
                                                                              14,
                                                                              14)];
            audioFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
            audioFlagImageView.hidden = YES;
            [self addSubview:audioFlagImageView];
            
            // 语音红点上面的数字
            audioNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                      AudioButton.frame.origin.x + AudioButton.frame.size.width - 6,
                                                                      AudioButton.frame.origin.y - 4,
                                                                      12,
                                                                      12)];
            audioNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
            audioNumLabel.font = [UIFont boldSystemFontOfSize:10.0f];
            audioNumLabel.textColor = [UIColor whiteColor];
            audioNumLabel.backgroundColor = [UIColor clearColor];
            audioNumLabel.text = @"1";
            
            audioNumLabel.hidden = YES;
            [self addSubview:audioNumLabel];
            
            //显示图片的键盘view
            //    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            addImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
            //    }else {
            //        addImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
            //    }
            addImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            //---update by kate 2014.10.09------------------------------------
            button_photoMask0 = [UIButton buttonWithType:UIButtonTypeCustom];
            button_photoMask0.tag = 1;
            //[buttonArray addObject:button_photoMask0];
            button_photoMask0.frame = CGRectMake(24,
                                                 20,
                                                 50,
                                                 50);
            [button_photoMask0 setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
            [button_photoMask0 setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
            [button_photoMask0 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            [addImageView addSubview:button_photoMask0];
            //----------------------------------------------
            
            //显示语音的键盘view
            addAudioView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
            addAudioView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            //点击录制语音
            audioButn = [UIButton buttonWithType:UIButtonTypeCustom];
            audioButn.frame = CGRectMake(26.0, 23.5, WIDTH-52, 33);
            audioButn.tag = 126;
            [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
            [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
            [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_d.png"]
                                 forState:UIControlStateNormal];
            [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_p.png"]
                                 forState:UIControlStateHighlighted];
            [audioButn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
            [audioButn addTarget:self action:@selector(recordEnd:) forControlEvents:UIControlEventTouchUpInside];
            [audioButn addTarget:self action:@selector(recordEndOutside:) forControlEvents:UIControlEventTouchUpOutside];
            [audioButn addTarget:self action:@selector(recordDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [audioButn addTarget:self action:@selector(recordDragIn:) forControlEvents:UIControlEventTouchDragEnter];
            
            audioButn.hidden = YES;
            [addAudioView addSubview:audioButn];
            
            //--------------------------------audio start------------------------------------------------
//            // 初始化audio lib 定义在各个类中
//            recordAudio = [[RecordAudio alloc]init];
//            recordAudio.delegate = self;
            
            // 播放button
            playRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            playRecordButton.frame = CGRectMake((WIDTH-80)/2,
                                                20,
                                                80,
                                                39);
            [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                        forState:UIControlStateNormal];
            [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                        forState:UIControlStateHighlighted];
            
            [playRecordButton addTarget:self action:@selector(recordPlay_btnclick:) forControlEvents:UIControlEventTouchDown];
            [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            playRecordButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            [playRecordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            
            playRecordButton.hidden = YES;
            [addAudioView addSubview:playRecordButton];
            
            // 播放按钮上得播放三角
            playImageView = [[UIImageView alloc]init];
            playImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2 - 5,
                                             playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
            playImageView.image = [UIImage imageNamed:@"amr/icon_media_play.png"];
            playImageView.hidden = YES;
            [addAudioView addSubview:playImageView];
            
            // 播放中的音量动画
            animationImageView = [[UIImageView alloc]init];
            animationImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2,
                                                  playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
            //将序列帧数组赋给UIImageView的animationImages属性
            animationImageView.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"amr/icon_send_horn_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn01_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn02_bbs.png"],
                                                  [UIImage imageNamed:@"amr/icon_send_horn03_bbs.png"],nil];
            //设置动画时间
            animationImageView.animationDuration = 0.75;
            //设置动画次数 0 表示无限
            animationImageView.animationRepeatCount = 0;
            [addAudioView addSubview:animationImageView];
            
            // 删除音频button
            deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteRecordButton.frame = CGRectMake(playRecordButton.frame.origin.x + playRecordButton.frame.size.width - 5,
                                                  playRecordButton.frame.origin.y - 5, 20, 20);
            [deleteRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/icon_media_cancel.png"]
                                          forState:UIControlStateNormal];
            [deleteRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/icon_media_cancel.png"]
                                          forState:UIControlStateHighlighted];
            
            [deleteRecordButton addTarget:self action:@selector(recordDelete_btnclick:) forControlEvents:UIControlEventTouchDown];
            deleteRecordButton.hidden = YES;
            [addAudioView addSubview:deleteRecordButton];
            //--------------------------------audio end------------
        }
            
            break;
        case inputBar_feedback:
            
            break;
            
        default:
            break;
    }
    
}

-(void)faceBoardClick:(id)sender{
    [self.controller faceBoardClick:sender];
}

-(void)ImageClick:(id)sender{
    [self.controller ImageClick:sender];
}

-(void)AudioClick:(id)sender{
    [self.controller AudioClick:sender];
}

-(void)clickTextView:(id)sender{
    [self.controller clickTextView:sender];
}

-(void)create_btnclick:(id)sender{
    [self.controller create_btnclick:sender];
}

-(void)recordStart:(id)sender{
    [self recordStart:sender];
}

-(void)recordEnd:(id)sender{

    [self recordEnd:sender];
}

-(void)recordEndOutside:(id)sender{
    [self recordEndOutside:sender];
}

-(void)recordDragExit:(id)sender{
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateNormal];
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];
}

-(void)recordDragIn:(id)sender{
    [audioButn setTitle:@"松开结束" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
}

- (void)recordPlay_btnclick:(id)sender{
    [self.controller recordPlay_btnclick:sender];
}

- (void)recordDelete_btnclick:(id)sender{
    [self.controller recordDelete_btnclick:sender];
}

@end

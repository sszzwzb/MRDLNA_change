//
//  DiscussDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-14.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "DiscussDetailViewController.h"

#import "DiscussViewController.h"
#import "OHAttributedLabel.h"
#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"
#import "Toast+UIView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MyTabBarController.h"
#import "SingleWebViewController.h"

@interface DiscussDetailViewController ()
@property(nonatomic,retain) UIImage *picImage;
@end

@implementation DiscussDetailViewController

@synthesize tid,flag,realName;

// audio
static double startRecordTime = 0;
static double endRecordTime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        cellHeightArray =[[NSMutableArray alloc] init];
        _textParser = [[MarkupParser alloc] init];
        
        
        //[super setCustomizeTitle:@"讨论区"];
        [super setCustomizeLeftButton];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        discussArray =[[NSMutableArray alloc] init];
        
        isFirstShowKeyboard = YES;
        clickFlag = 0;
        isReply = NO;
        _isFirstClickReply = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        
        reflashFlag = 1;
        isReflashViewType = 1;
        // 进入画面时候清除掉之前amr临时文件
        NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
        [[NSFileManager defaultManager] removeItemAtPath:amrDocPath error:nil];
        
        test = 0;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [MyTabBarController setTabBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioInCell:) name:@"Weixiao_playAudioInCell" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioInTopCell:) name:@"Weixiao_playAudioInTopCell" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageClickedInCell:) name:@"Weixiao_imageClickedInTCell" object:nil];
    
    //[super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    if (isSelectPhoto) {
        photoFlagImageView.hidden = NO;
        photoDeleteButton.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromDiscussDetailView2ProfileView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToHistoryView:) name:@"Weixiao_fromDiscussDetailView2History" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_playAudioInCell" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_playAudioInTopCell" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_imageClickedInTCell" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromDiscussDetailView2ProfileView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromDiscussDetailView2History" object:nil];
}

-(void)doGoToHistoryView:(NSNotification *)notification
{
    DiscussHistoryViewController *historyViewCtrl = [[DiscussHistoryViewController alloc] init];
    historyViewCtrl.tid = tid;
    historyViewCtrl.cid = _cid;
    [self.navigationController pushViewController:historyViewCtrl animated:YES];
}

-(void)doGoToProfileView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)loadView
{
    if (flag == 2) {
        [super setCustomizeTitle:_disTitle];
    }else if (flag == 3){
        [super setCustomizeTitle:_disTitle];
    }else{
        [super setCustomizeTitle:_disTitle];
    }
    
    self->startNum = @"0";
    //self->endNum = @"500";
    self->endNum = @"20";//加入上拉加载更多 add by kate
    
    lastId = @"0";// add by kate 2014.01.23
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.3];
    
    //    shopWebView = [UIWebView alloc];
#if 0
    shopWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 0)];
#endif
    //    [shopWebView setDelegate:self];
    
    //    shopWebView.delegate = self;
    
    //    shopWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    shopWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0.400, 100.0, WIDTH, 10)];
    
    [self addTapOnWebView];
    
    //---add by kate-------------------
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);
    addImageButton.tag = 123;
    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_d.png"]
                    forState:UIControlStateNormal];
    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_p.png"]
                    forState:UIControlStateHighlighted];
    [addImageButton addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:addImageButton];
    
    // 选择图片后的红点啊
    photoFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                      addImageButton.frame.origin.x + addImageButton.frame.size.width -10,
                                                                      addImageButton.frame.origin.y - 5,
                                                                      12,
                                                                      12)];
    photoFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
    photoFlagImageView.hidden = YES;
    [toolBar addSubview:photoFlagImageView];
    
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(80.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33 - 37, 33)];
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeyDone;
    _inputTextView.backgroundColor = [UIColor clearColor];
    
    //---update 2015.01.27-----------------------------------------------
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
    singleTouch.delegate = self;
    [_inputTextView addGestureRecognizer:singleTouch];
    
    
    _replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _replyToLabel.enabled = NO;
    _replyToLabel.text = @"";
    _replyToLabel.font =  [UIFont systemFontOfSize:13];
    _replyToLabel.textColor = [UIColor grayColor];
    [_inputTextView addSubview:_replyToLabel];
    
    //    UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    touchButton.frame = CGRectMake(0, 0,  205-10, 33);
    //    touchButton.backgroundColor = [UIColor clearColor];
    //    [touchButton addTarget:self action:@selector(clickTextView:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [textView addSubview:touchButton];
    //---------------------------------------------------------------------
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(80.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33 - 37, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    [toolBar addSubview:entryImageView];
    [toolBar addSubview:_inputTextView];
    
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    [self.view addSubview:toolBar];
    
    //    [self createHeaderView];
    
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
    [toolBar addSubview:audioButn];
    
    //--------------------------------------------------------------------------//
    
    //--------------------------------audio start------------------------------------------------
    // 初始化audio lib
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
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
    
    // 20140920 update by ht 如果教师未过批准，学生未加入班级，则不显示回帖bar
//    NSDictionary *user_info = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
    NSDictionary *user_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
    // 2015.05.25 为教育局专版做特殊处理，没有身份的老师和学生可以发评论。
    // 持保留意见
    if (![schoolType isEqualToString:@"bureau"]) {
        // 除了教育局专版之外需要判断身份等信息
        if([@"7"  isEqual: role_id]) {
            if ([@"1"  isEqual: role_checked]) {
            }else {
                toolBar.hidden = YES;
                _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
            }
        }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
            
        }else {
            if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                toolBar.hidden = YES;
                _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);        }else {
                }
        }
    }else {
        if ([@"schoolExhi"  isEqual: _viewType]) {
            toolBar.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
        }else{//2015.10.29 教育局改版 特殊处理去掉
            if([@"7"  isEqual: role_id]) {
                if ([@"1"  isEqual: role_checked]) {
                }else {
                    toolBar.hidden = YES;
                    _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
                }
            }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                
            }else {
                if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                    toolBar.hidden = YES;
                    _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);        }else {
                    }
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    int a=0;
    NSLog(@"aaaa %@", textView.text);
}
//--------add by kate---------------------------------------------
/*
 *Hi~ beck 点击加号图片方法
 *每次只能带一张图片，只能从相册选择，
 *选择回来输入框下落，输入框图片图标右上角有红点标记
 *点击图片可以删除，删除后红点标记消失
 *见效果图
 */
-(void)create_btnclick:(id)sender{
    if (isSelectPhoto) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"要删除图片么？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消"
                                  , nil];
        
        alertView.tag = 8;
        [alertView show];
    } else {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
}

/*
 *Hi~ beck 按住开始录音
 *最长录制一分钟，有倒计时 见效果图
 */
-(void)recordStart:(id)sender{
    if (![Utilities canRecord]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
        return;
    }else {
        isRecording = YES;
        
        [recordAudio stopPlay];
        [recordAudio startRecord];
        startRecordTime = [NSDate timeIntervalSinceReferenceDate];
        
        // 倒计时开始，60秒后自动停止
        secondsCountDown = 60;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        //curAudio=nil;//2015.10.21 这句代码导致 第一次录制超过1秒的语音，第二次再次录制少于1秒的录音，点击发表一直转圈
    }
}

/*
 *Hi~ beck 松开手录音结束
 * addAudioView 对这个view进行add，出现录音结束的条形图片，且可以删除
 * 录音结束后，输入框右侧按钮变成【发送】
 * 删除后输入框右侧按钮图标变成 键盘，点击还原原始输入框
 * 见效果图
 */
-(void)recordEnd:(id)sender{
    
    if (isRecording) {
        [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
        [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
        
        isRecording = NO;
        [countDownTimer invalidate];
        
        NSURL *url = [recordAudio stopRecord];
        
        endRecordTime = [NSDate timeIntervalSinceReferenceDate];
        endRecordTime -= startRecordTime;
        
        recordSec = endRecordTime;
        
        NSInteger time = 59;
        if (secondsCountDown > time) {
            [Utilities showFailedHud:@"时间太短，请重试。" descView:self.view];
        }else {
            if (url != nil) {
                curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
                if (curAudio) {
                    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                    if (nil != amrDocPath) {
                        amrPath = [amrDocPath stringByAppendingPathComponent:@"weixiao_amr.amr"];
                        [curAudio writeToFile: amrPath atomically: NO];
                        
                        [playRecordButton setTitle:[NSString stringWithFormat:@"%ld″", (long)recordSec] forState:UIControlStateNormal];
                        [playRecordButton setTitle:[NSString stringWithFormat:@"%ld″", (long)recordSec] forState:UIControlStateSelected];
                        playRecordButton.hidden = NO;
                        
                        deleteRecordButton.hidden = NO;
                        playImageView.hidden = NO;
                        
                        AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
                        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
                        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
                        
                        //-----------------------------------------------------------
                    }
                }
            }
            
            if (curAudio.length >0) {
                
            } else {
                
            }
        }
        
        
    }
}

-(void)recordEndOutside:(id)sender{
    [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    isRecording = NO;
    [countDownTimer invalidate];
    
    [recordAudio stopRecord];
}

-(void)recordDragExit:(id)sender{
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateNormal];
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];
}

-(void)recordDragIn:(id)sender{
    [audioButn setTitle:@"松开结束" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
}

- (void)faceBoardHide:(id)sender{
    
    //    BOOL needReload = NO;
    //    if ( ![textView.text isEqualToString:@""] ) {
    //
    //        needReload = YES;
    //
    //        NSMutableArray *messageRange = [[NSMutableArray alloc] init];
    //        [self getMessageRange:textView.text :messageRange];
    //        [messageList addObject:messageRange];
    //        [messageRange release];
    //
    //        messageRange = [[NSMutableArray alloc] init];
    //        [self getMessageRange:textView.text :messageRange];
    //        [messageList addObject:messageRange];
    //        [messageRange release];
    //    }
    //
    
    _inputTextView.text = nil;
    [self textViewDidChange:_inputTextView];
    
    [_inputTextView resignFirstResponder];
    
    isFirstShowKeyboard = YES;
    
    isButtonClicked = NO;
    
    _inputTextView.inputView = nil;
    
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    
    //    if ( needReload ) {
    //
    //        [messageListView reloadData];
    //
    //        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count - 1
    //                                                                   inSection:0]
    //                               atScrollPosition:UITableViewScrollPositionBottom
    //                                       animated:NO];
    //    }
    
    
}

-(void)faceBoardClick:(id)sender{
    
    clickFlag = 1;
    audioButn.hidden = YES;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [_inputTextView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            _inputTextView.inputView = faceBoard;
        }
        
        [_inputTextView becomeFirstResponder];
    }
    
}

-(void)ImageClick:(id)sender{
    
    clickFlag = 2;
    audioButn.hidden = YES;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [_inputTextView resignFirstResponder];
    }else{
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            _inputTextView.inputView = addImageView;
        }
        
        [_inputTextView becomeFirstResponder];
    }
}

-(void)AudioClick:(id)sender{
    
    UIImage *image = [UIImage imageNamed:@"faceImages/faceBoard/send_press.png"];
    //    if ([AudioButton.imageView.image isEqual: image]) {
    if ([Utilities image:AudioButton.imageView.image equalsTo:image]) {
        
        //Hi~ beck在这里写 发送方法 发送成功后将右侧发送按钮变回语音图标
        // add your code
        [Utilities showProcessingHud:self.view];
        
        //        NSDictionary *detailDic = [g_userInfo getUserDetailInfo];
        //        NSString *cid = [detailDic objectForKey:@"cid"];
        // 获取当前用户的cid
        
        if (3 == clickFlag) {
            if (nil != curAudio) {
                //发布语音
                if (isReply) {
                    if (flag == 1) {
                        //讨论区
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"SchoolThread", @"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              replyPid, @"pid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }else if (flag == 2){
                        //班级公告
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"ClassThread",@"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              replyPid, @"pid",
                                              _inputTextView.text, @"message",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }else if (flag == 4){
                        // 班级讨论区
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"ClassForumThread", @"ac",
                                              @"1",@"v",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              replyPid, @"pid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ClassThreadReplyAudio andData:data];
                    }else{
                        //作业
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"Homework", @"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              tid, @"tid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              replyPid, @"pid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }
                } else {
                    if (flag == 1) {
                        //讨论区
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"SchoolThread", @"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }else if (flag == 2){
                        //班级公告
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"ClassThread",@"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              _inputTextView.text, @"message",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }else if (flag == 4){
                        // 班级讨论区
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"ClassForumThread", @"ac",
                                              @"1",@"v",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ClassThreadReplyAudio andData:data];
                    }
                    else{
                        //作业
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              @"Homework", @"ac",
                                              @"comment", @"op",
                                              _cid, @"cid",
                                              tid, @"tid",
                                              [threadDic objectForKey:@"tid"], @"tid",
                                              @"", @"message",
                                              amrPath, @"amr0",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadReplyAudio andData:data];
                    }
                }
            } else {
                // no need todo sth.
            }
        } else {
            // 发布文字和图片
            if (isReply) {
                if (flag == 1) {
                    //讨论区
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"SchoolThread", @"ac",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          replyPid, @"pid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }else if (flag == 2){
                    //班级公告
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassThread",@"ac",
                                          @"comment", @"op",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          replyPid, @"pid",
                                          _inputTextView.text, @"message",
                                          _cid, @"cid",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }else if (flag == 4){
                    // 班级讨论区
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassForumThread", @"ac",
                                          @"1",@"v",
                                          @"comment", @"op",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          replyPid, @"pid",
                                          _inputTextView.text, @"message",
                                          _cid, @"cid",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ClassThreadReplyPicture andData:data];
                    
                }else{
                    //作业
                    NSDictionary *user = [g_userInfo getUserDetailInfo];
                    NSString* g_uid= [user objectForKey:@"uid"];
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Homework", @"ac",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          tid, @"tid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          replyPid, @"pid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }
            } else {
                if (flag == 1) {
                    //讨论区
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"SchoolThread", @"ac",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }else if (flag == 2){
                    //班级公告
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassThread",@"ac",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }else if (flag == 4){
                    // 班级讨论区
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassForumThread", @"ac",
                                          @"1",@"v",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ClassThreadReplyPicture andData:data];
                    
                }else{
                    //作业
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Homework", @"ac",
                                          @"comment", @"op",
                                          _cid, @"cid",
                                          tid, @"tid",
                                          [threadDic objectForKey:@"tid"], @"tid",
                                          _inputTextView.text, @"message",
                                          imagePath, @"png0",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
                }
            }
        }
        
        isButtonClicked = NO;
        _inputTextView.inputView = nil;
        //        isSystemBoardShow = YES;
        isSystemBoardShow = NO;// update by kate 2014.12.02
        audioButn.hidden = YES;
        _inputTextView.text = @"";
        _inputTextView.frame = CGRectMake(80.0, 5.0, 205-15, 33);
        clickFlag = 0;
        [_inputTextView resignFirstResponder];
        toolBar.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44);
        AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                     forState:UIControlStateNormal];
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                     forState:UIControlStateHighlighted];
        //------update by kate 2014.12.02--------------------------------------------------------
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
        //-----------------------------------------------------------------------------------------
        
        
    }else{
        clickFlag = 3;
        
        audioButn.hidden = NO;
        
        isButtonClicked = YES;
        
        if ( isKeyboardShowing ) {
            
            [_inputTextView resignFirstResponder];
        }
        else {
            
            if ( isFirstShowKeyboard ) {
                
                isFirstShowKeyboard = NO;
                
                isSystemBoardShow = NO;
            }
            
            if ( !isSystemBoardShow ) {
                
                _inputTextView.inputView = addAudioView;
            }
            
            [_inputTextView becomeFirstResponder];
        }
        
    }
    
}


-(void)clickTextView:(id)sender{
    
    if (_inputTextView.inputView!=nil) {
        isButtonClicked = YES;
        _inputTextView.inputView = nil;
        isSystemBoardShow = YES;
        clickFlag = 0;
        [_inputTextView resignFirstResponder];
    }else{
        [_inputTextView becomeFirstResponder];
    }
}

#pragma UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    int a =nil;
//
//}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
        //        if ( range.length > 1 ) {
        //
        //            return YES;
        //        }
        //        else {
        //
        //            [faceBoard backFace];
        //
        //            if ([textView.text length] == 0 && photoFlagImageView.hidden == YES) {
        //                AudioButton.frame = CGRectMake(284.0 - 7 , 5.0, 33.0, 33.0);
        //                [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
        //                [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
        //            }
        //
        //            return NO;
        //        }
        
        return YES;
    }
    else {
        textView.textColor = [UIColor blackColor];
        
        if (range.location >= 500){// 校园讨论区/班级作业/班级公告/班级风采/回帖 500 2015.07.21
            return NO;
        }else{
            if ([text isEqualToString:@"\n"]){
                isButtonClicked = NO;
                
                [textView resignFirstResponder];
                
                // bug 2504
                isReply = NO;
                replyPid = @"";
                
                return NO;
            }else{
                if (_isFirstClickReply) {
                    textView.text = @"";
                    _isFirstClickReply = false;
                }
                
                return YES;
            }
        }
        
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    _replyToLabel.text = _replyTo;
    
    if ([_textView.text length] == 0) {
        [_replyToLabel setHidden:NO];
    }else{
        [_replyToLabel setHidden:YES];
    }
    
    if ([_textView.text length] > 0) {
        
        AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
    }else{
        
        AudioButton.frame = CGRectMake(284.0 - 7 , 5.0, 33.0, 33.0);
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    }
    
    CGSize size = _inputTextView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != _inputTextView.frame.size.height ) {
        
        CGFloat span = size.height - _inputTextView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = _inputTextView.frame;
        frame.size = size;
        _inputTextView.frame = frame;
        
        CGPoint center = _inputTextView.center;
        center.y = centerY;
        _inputTextView.center = center;
        
        //        center = keyboardButton.center;
        //        center.y = centerY;
        //        keyboardButton.center = center;
        
        //        center = sendButton.center;
        //        center.y = centerY;
        //        sendButton.center = center;
    }
}
//-----------------------------------------------------

-(void)selectLeftAction:(id)sender
{
    // 设置刷新标志位，在下拉或者上拉刷新的时候，先判断是否需要网络请求，
    // 如不需要，则不请求
    reflashFlag = 0;
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    //DiscussListData *listData = DiscussListData.sharedDiscussListDataSingleton;
    //NSMutableArray *list = [listData getDiscussArray];
    
    //    for (int i=0; i<[list count]; i++) {
    //        for (int j=0; j<[[list objectAtIndex:i] count]; j++) {
    //            if (tid == [[list objectAtIndex:i] objectForKey:@"tid"]) {
    //                NSString *viewnum =  [[list objectAtIndex:i] objectForKey:@"viewnum"];
    //                NSString *viewnum_new = [NSString stringWithFormat:@"%ld", (viewnum.integerValue + 1)];
    //
    //                [[list objectAtIndex:i] setValue:viewnum_new forKey:@"viewnum"];
    //            }
    //        }
    //
    //    }
    ////    NSArray *viewArray = [self.navigationController viewControllers];
    //    for (NSObject *object in viewArray)
    //    {
    //        DiscussViewController *aaa;
    //        if (aaa == (DiscussViewController *)object) {
    //            aaa->mythreads = [NSString stringWithFormat:@"@d", (aaa->mythreads.integerValue + 1)];
    //        }
    //DiscussViewController *discussView = (DiscussViewController *)object;
    
    //    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
        
        [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [_inputTextView resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [super setCustomizeTitle:@"讨论区"];
    
    if ( !faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = _inputTextView;
    }
    
    if (![Utilities isConnected]){//2015.06.30
        return;
    }
    
    [Utilities showProcessingHud:self.view];
    
    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
    _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
}

-(void)playAudioInCell:(NSNotification *)notification
{
    NSLog(@"playAudioInCell");
    NSDictionary *dic = [notification userInfo];
    NSString *cellNum = [dic objectForKey:@"cellNum"];
    NSString *isPlayStatusP = [dic objectForKey:@"isPlayStatus"];
    
    isPlayStatus = isPlayStatusP;
    
    if ([@"1"  isEqual: isPlayStatus]) {
        // 关闭其他cell的播放效果
        for (int i=1; i<[_tableView numberOfRowsInSection:0]; i++) {
            NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
            DiscussDetailCell *cellAll = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPathAll];
            
            [cellAll.animationImageView stopAnimating];
            
            //NSLog(@"cellAll.pic %@",cellAll.pic);
            
            if ([@"amr"  isEqual: cellAll.ext]) {
                cellAll.playImageView.hidden = NO;
            }
            //            cellAll.playImageView.hidden = NO;
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        [cell.animationImageViewSubject stopAnimating];
        cell.playImageViewSubject.hidden = NO;
        
        isCellAudioPlay = YES;
        isTopCellAudioPlay = NO;
        numOfCellAudioPlaying = cellNum;
        
        // 播放三角取消
        playImageView.hidden = YES;
        [animationImageView stopAnimating];
        
        NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
        if (nil != amrDocPath) {
            // 取出点击cell所属的amr文件
            NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",cellNum]];
            NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
            
            if(fileData.length>0){
                
                [recordAudio handleNotification:YES];//2015.11.16
                [recordAudio play:fileData];
            }
        }
    } else if([@"2"  isEqual: isPlayStatus]) {
        isCellAudioPlay = YES;
        isTopCellAudioPlay = NO;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying.integerValue inSection:0];
        DiscussDetailCell *cell = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        [cell.animationImageView stopAnimating];
        
        [recordAudio stopPlay];
    }
}

-(void)playAudioInTopCell:(NSNotification *)notification
{
    NSLog(@"playAudioInTopCell");
    NSDictionary *dic = [notification userInfo];
    NSString *isPlayStatusP = [dic objectForKey:@"isPlayStatus"];
    
    isPlayStatus = isPlayStatusP;
    
    if ([@"1"  isEqual: isPlayStatus]) {
        
        isCellAudioPlay = YES;
        isTopCellAudioPlay = YES;
        
        NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
        if (nil != amrDocPath) {
            // 取出点击cell所属的amr文件
            NSString *imagePathCell0 = [amrDocPath stringByAppendingPathComponent:@"weixiao_amrCell0.amr"];
            NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell0];
            
            for (int i=1; i<[_tableView numberOfRowsInSection:0]; i++) {
                NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
                DiscussDetailCell *cellAll = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPathAll];
                
                [cellAll.animationImageView stopAnimating];
                
                if (![@""  isEqual: cellAll.pic]) {
                    cellAll.playImageView.hidden = NO;
                }
            }
            
            if(fileData.length>0){
                
                [recordAudio handleNotification:YES];//2015.11.16
                [recordAudio play:fileData];
            }
        }
    } else if([@"2"  isEqual: isPlayStatus]) {
        isCellAudioPlay = YES;
        isTopCellAudioPlay = YES;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        [cell.animationImageViewSubject stopAnimating];
        
        [recordAudio stopPlay];
    }
}

-(void) imageClickedInCell:(NSNotification *)notification
{
    NSLog(@"imageClickedInCell");
    
    [_inputTextView resignFirstResponder];
    
    NSDictionary *dic = [notification userInfo];
    NSString *cellNum = [dic objectForKey:@"cellNum"];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:cellNum.integerValue inSection:0];
    DiscussDetailCell *cell = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPath];
    
    CGPoint a;
    [self showImageURL:cell.pic point:a];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [discussArray count] + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        int historyHeight = 0;
        if (1 != flag && 5!= flag) {
            historyHeight = 70;
        }
        
        //NSLog(@"webHeight:%f",webHight);
        
        if (isAudioSubject) {
            //return webHight+120 + 60 + 100 + historyHeight;
            return webHight+120 + 60 + historyHeight;//update by kate 2015.02.02
        } else {
            return webHight+120 + historyHeight;
        }
        
    }else{
        
        NSDictionary *list_dic = [discussArray objectAtIndex:[indexPath row]-1];
        NSString *ext= [list_dic objectForKey:@"ext"];
        if ([@"amr"  isEqual: ext]) {
            //return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 62.0 + 10 + 19;//update by kate
       
#if 1
            NSLog(@"cellHeightArray:%@",cellHeightArray);
            NSLog(@"index:%d",indexPath.row);
            
            float height = [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 61.0 + 10 + 40;
            //float height = [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue];
            NSString* message= [list_dic objectForKey:@"message"];
            // 以/div为标识，分割字符串
            NSArray *array = [message componentsSeparatedByString:@"</div>"];
            
            NSRange range;
            NSString *citeStr = @"";
            NSString *nameStr1 = @"";
            NSString *nameStr2 = @"";

            for(NSObject *temp in array)
            {
                NSString *str = (NSString *)temp;
                
                if ([@"</span>"  isEqual: str]) {
                    continue;
                }

                NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                NSUInteger len = foundOB.location - foundB.location;
                
                if (0 != len) {
                    nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                }
                
                NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                
                if (0 != lenSpan) {
                    nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                    str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
                    citeStr = str;
                    break;
                }
            }
            
            CGSize b = [DiscussDetailCell heightForEmojiText:citeStr];
            
            if ([@""  isEqual: citeStr]) {
                return   height-3;
            }else {
                return  b.height + 61.0 + 10 + 20 +7;
            }
#endif

            return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue];
            
        }else if ([@"png"  isEqual: ext]) {
            //return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 180.0 + 19;
            return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 178 + 20 - 42;//2015.09.19
        }else {
            //return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] +50 +30-2 + 19;//update by kate
            return [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 60.0;//update by kate
        }
    }
    
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";
    static NSString *CellTableIdentifier2 = @"CellTableIdentifier2";
    static NSString *CellTableIdentifier3 = @"CellTableIdentifier3";
    
    NSUInteger row = [indexPath row];
    
    Utilities *util = [Utilities alloc];
    
    if(row == 0)
    {
        DiscussDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[DiscussDetailTopCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        
        if (nil != threadDic) {
            NSString* subject= [threadDic objectForKey:@"subject"];
            //            NSString* username= [threadDic objectForKey:@"username"];
            //
            //            if(flag == 2){
            //                username= realName;
            //            }
            
            NSString* sbj_uid= [threadDic objectForKey:@"uid"];
            NSString* dateline= [threadDic objectForKey:@"dateline"];
            NSString *viewnum = [threadDic objectForKey:@"viewnum"];
            //NSString *replynum = [threadDic objectForKey:@"replynum"];
//            NSString *pic = @"";
//            pic= [threadDic objectForKey:@"pic"];
            
            NSString *pic = @"";
            NSArray *picArr = [threadDic objectForKey:@"pic"];
            
            pic= [threadDic objectForKey:@"pic"];

            
            
            NSString *content = nil;
            if (flag == 1) {
                content= [threadDic objectForKey:@"message"];
            }else{
                content= [threadDic objectForKey:@"message"];
            }
            NSString *replynum = [threadDic objectForKey:@"replynum"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.subject = subject;
            //cell.replynum = replynum;
            //cell.viewnum = viewnum;
            cell.uid = sbj_uid;
            
            cell.username = [threadDic objectForKey:@"username"];
            cell.dateline = [util linuxDateToString:dateline andFormat:@"%@-%@-%@" andType:DateFormat_YMDHM];
            
            cell.label_viewnum.text = viewnum;
            cell.label_replynum.text = replynum;
            
            CGSize viewNumSize = [Utilities getStringHeight:viewnum andFont:[UIFont systemFontOfSize:12.0] andSize:CGSizeMake(0, 20.0)];
            cell.label_viewnum.frame = CGRectMake(cell.label_viewnum.frame.origin.x, cell.label_viewnum.frame.origin.y, viewNumSize.width, cell.label_viewnum.frame.size.height);
            cell.imgView_message.frame = CGRectMake(cell.label_viewnum.frame.origin.x+viewNumSize.width+5.0, cell.label_viewnum.frame.origin.y, cell.imgView_message.frame.size.width, cell.imgView_message.frame.size.height);
            cell.label_replynum.frame = CGRectMake(cell.imgView_message.frame.origin.x+cell.imgView_message.frame.size.width+5.0, cell.label_replynum.frame.origin.y, cell.label_replynum.frame.size.width, cell.label_replynum.frame.size.height);
            
            
            // 作业改版都不要时间了 2015.11.24
#if 0
            if (flag == 3) {
                NSString* expectedtime= [threadDic objectForKey:@"expectedtime"];
                if (nil == expectedtime) {
                    expectedtime = @"0";
                }
                
                cell.expectedtime = [NSString stringWithFormat:@"%@分钟", expectedtime];
                cell.imgView_bg_clock.hidden = NO;
                
            }else{
                cell.imgView_bg_clock.hidden = YES;
            }
#else 
            cell.imgView_bg_clock.hidden = YES;
            cell.label_expectedtime.hidden = YES;
            
            //---时间又加回来了 2015.12.28 吴宁确认--------------------------------------
            if (flag == 3) {
                NSString* expectedtime= [threadDic objectForKey:@"expectedtime"];
                if (nil == expectedtime) {
                    expectedtime = @"0";
                }
                cell.timeLabel.hidden = NO;
                cell.timeTitleLabel.hidden = NO;
                cell.timeTitleLabel.text = @"预计完成时间：";
                cell.timeLabel.text = [NSString stringWithFormat:@"%@分钟", expectedtime];
                cell.label_replynum.hidden = YES;
                cell.label_viewnum.hidden = YES;
            }else{
                cell.timeLabel.hidden = YES;
                cell.timeTitleLabel.hidden = YES;
                cell.label_replynum.hidden = NO;
                cell.label_viewnum.hidden = NO;
            }
            //---------------------------------------------------------------------------

#endif
            //-----update by kate 2014.11.14-----------------------------------
            NSString *head_url = [threadDic objectForKey:@"avatar"];
            //NSString* head_url = [util getAvatarFromUid:sbj_uid andType:@"1"];
            //------------------------------------------------------------------
            
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            
            [shopWebView setFrame:CGRectMake(6, cell.label_dateline.frame.origin.y+cell.label_dateline.frame.size.height+10.7, WIDTH-20, webHight)];
            shopWebView.backgroundColor = [UIColor clearColor];
            shopWebView.opaque = NO;
            [(UIScrollView *)[[shopWebView subviews] objectAtIndex:0] setBounces:NO];
            [shopWebView setScalesPageToFit:NO];
            [shopWebView loadHTMLString:content baseURL:nil];
            [cell.contentView addSubview:shopWebView];
            
            int audioHeight = 0;
            
            if (![@"" isEqual: pic]) {
                NSURL *url = [NSURL URLWithString:pic];
                if (nil != url) {
                    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
                    audioHeight = 60;
                    
                    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                    if (nil != amrDocPath) {
                        NSString *imagePathCell0 = [amrDocPath stringByAppendingPathComponent:@"weixiao_amrCell0.amr"];
                        
                        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:imagePathCell0]) {
                            [_request setDownloadDestinationPath :imagePathCell0];
                            
                            [_request setCompletionBlock :^{
                                // 请求成功
                                lodingLabel.hidden = YES;
                                //---update by kate--------------------------------
                                //                                cell.playRecordButtonSubject.frame = CGRectMake(20,
                                //                                                                                130 + webHight + 100,
                                //                                                                                60,
                                //                                                                                28);
                                
                                cell.playRecordButtonSubject.frame = CGRectMake(20,
                                                                                130 + webHight,
                                                                                60,
                                                                                28);
                                //------------------------------------------------
                                
                                cell.playRecordButtonSubject.hidden = NO;
                                
                                cell.playImageViewSubject.frame = CGRectMake(cell.playRecordButtonSubject.frame.origin.x + (cell.playRecordButtonSubject.frame.size.width/2 - 10)/2 + cell.playRecordButtonSubject.frame.size.width/2 - 5,
                                                                             cell.playRecordButtonSubject.frame.origin.y + (cell.playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
                                cell.playImageViewSubject.hidden = NO;
                                
                                cell.animationImageViewSubject.frame = CGRectMake(cell.playRecordButtonSubject.frame.origin.x + (cell.playRecordButtonSubject.frame.size.width/2 - 10)/2 + cell.playRecordButtonSubject.frame.size.width/2,
                                                                                  cell.playRecordButtonSubject.frame.origin.y + (cell.playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
                                cell.animationImageViewSubject.hidden = NO;
                                
                                NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell0];
                                NSString *dur = [NSString stringWithFormat:@"%d″", [recordAudio dataDuration:fileData]] ;
                                
                                [cell.playRecordButtonSubject setTitle:dur forState:UIControlStateNormal];
                                [cell.playRecordButtonSubject setTitle:dur forState:UIControlStateSelected];
                            }];
                            [_request setFailedBlock :^{
                                // 请求失败，返回错误信息
                                //                            lodingLabel.text = @"音频加载失败";
                            }];
                            
                            // 开始异步请求
                            [_request startAsynchronous];
                        } else {
                            //---update by kate--------------------------------
                            //                            cell.playRecordButtonSubject.frame = CGRectMake(20,
                            //                                                                            130 + webHight + 100,
                            //                                                                            60,
                            //                                                                            28);
                            
                            cell.playRecordButtonSubject.frame = CGRectMake(20,
                                                                            130 + webHight,
                                                                            60,
                                                                            28);
                            //----------------------------------------------------
                            
                            cell.playRecordButtonSubject.hidden = NO;
                            
                            cell.playImageViewSubject.frame = CGRectMake(cell.playRecordButtonSubject.frame.origin.x + (cell.playRecordButtonSubject.frame.size.width/2 - 10)/2 + cell.playRecordButtonSubject.frame.size.width/2 - 5,
                                                                         cell.playRecordButtonSubject.frame.origin.y + (cell.playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
                            cell.playImageViewSubject.hidden = NO;
                            
                            cell.animationImageViewSubject.frame = CGRectMake(cell.playRecordButtonSubject.frame.origin.x + (cell.playRecordButtonSubject.frame.size.width/2 - 10)/2 + cell.playRecordButtonSubject.frame.size.width/2,
                                                                              cell.playRecordButtonSubject.frame.origin.y + (cell.playRecordButtonSubject.frame.size.height - 10)/2, 10, 10);
                            cell.animationImageViewSubject.hidden = NO;
                        }
                    }
                    
                    // loading标签
                    //                lodingLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,
                    //                                                                        109 + webHight,
                    //                                                                        104,
                    //                                                                        44)];
                    //                lodingLabel.font = [UIFont systemFontOfSize:14.0f];
                    //                lodingLabel.text = @"音频加载中...";
                    //                lodingLabel.numberOfLines = 2;
                    //                lodingLabel.textColor = [UIColor blackColor];
                    //                lodingLabel.backgroundColor = [UIColor clearColor];
                    //                lodingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    //                lodingLabel.hidden = NO;
                    //                [cell.contentView addSubview:lodingLabel];
                    
                }
            }
            
            if (1 != flag && 5!= flag) {//谁谁谁查看过的显示条
                if (isAudioSubject) {
                    //----update by kate 2015.02.02-------------------
                    //                    cell.imgView_historyBg.frame = CGRectMake(
                    //                                                              10,
                    //                                                              webHight + 130 + audioHeight + 100,
                    //                                                              300,
                    //                                                              50);
                    //
                    //                    cell.btn_history.frame = CGRectMake(
                    //                                                        10,
                    //                                                        webHight + 130 + audioHeight + 100,
                    //                                                        300,
                    //                                                        50);
                    
                    cell.imgView_historyBg.frame = CGRectMake(
                                                              0,
                                                              webHight + 130 + audioHeight,
                                                              WIDTH,
                                                              45.0);
                    
                    cell.btn_history.frame = CGRectMake(
                                                        0,
                                                        webHight + 130 + audioHeight,
                                                        WIDTH,
                                                        45);
                    //-----------------------------------------------------
                }else {
                    cell.imgView_historyBg.frame = CGRectMake(
                                                              0,
                                                              webHight + 130 + audioHeight,
                                                              WIDTH,
                                                              45);
                    
                    cell.btn_history.frame = CGRectMake(
                                                        0,
                                                        webHight + 130 + audioHeight,
                                                        WIDTH,
                                                        45);
                }
                
                int countPos = 0;
                for (int i=0; i<[(NSArray *)[history objectForKey:@"list"] count]; i++) {
                    NSDictionary *dic = [[history objectForKey:@"list"] objectAtIndex:i];
                    if (0 == i) {
                        cell.imgView_headImg1.frame = CGRectMake(5, cell.imgView_historyBg.frame.origin.y + (45-30)/2.0, 30.0, 30);
                        [cell.imgView_headImg1 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        countPos = cell.imgView_headImg1.frame.origin.x + 40;
                    }else if (1 == i) {
                        cell.imgView_headImg2.frame = CGRectMake(5 + 30*i + 5*i, cell.imgView_historyBg.frame.origin.y + (45-30)/2.0, 30, 30);
                        [cell.imgView_headImg2 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        countPos = cell.imgView_headImg2.frame.origin.x + 40;
                    }else if (2 == i) {
                        cell.imgView_headImg3.frame = CGRectMake(5 + 30*i + 5*i, cell.imgView_historyBg.frame.origin.y + (45-30)/2.0, 30, 30);
                        [cell.imgView_headImg3 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        countPos = cell.imgView_headImg3.frame.origin.x + 40;
                    }else if (3 == i) {
                        cell.imgView_headImg4.frame = CGRectMake(5 + 30*i + 5*i, cell.imgView_historyBg.frame.origin.y + (45-30)/2.0, 30, 30);
                        [cell.imgView_headImg4 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        countPos = cell.imgView_headImg4.frame.origin.x + 40;
                    }
                    else if (4 == i) {
                        cell.imgView_headImg5.frame = CGRectMake(5 + 30*i + 5*i, cell.imgView_historyBg.frame.origin.y + (45-30)/2.0, 30, 30);
                        [cell.imgView_headImg5 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        countPos = cell.imgView_headImg5.frame.origin.x + 40;
                        
                    }
                }
                
                if (0 != [(NSArray *)[history objectForKey:@"list"] count]) {
                    cell.label_historyCount.frame = CGRectMake(countPos, cell.imgView_historyBg.frame.origin.y + (cell.imgView_historyBg.frame.size.height-30)/2, WIDTH-countPos-10, 30);
                    cell.label_historyCount.text = [history objectForKey:@"count"];
                }else {
                    cell.imgView_historyBg.hidden = YES;
                    cell.btn_history.hidden = YES;
                }
            }
        }
        
        return cell;
    }
    else
    {
        NSDictionary *list_dic = [discussArray objectAtIndex:row-1];
        
        NSString* pid= [list_dic objectForKey:@"pid"];
        NSString* sbj_uid= [list_dic objectForKey:@"uid"];
        NSString* username= [list_dic objectForKey:@"username"];
        NSString* dateline= [list_dic objectForKey:@"dateline"];
        NSString* message= [list_dic objectForKey:@"message"];
        
        // 判断是否有语音，如有语音，固定高度以及设置播放button
        NSString* ext= [list_dic objectForKey:@"ext"];
        if ([@"amr"  isEqual: ext]) {
            DiscussDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier2];
//            if (indexPath.row%2 == 0) {
//              cell.backgroundColor = [UIColor redColor];
//            }else{
//                cell.backgroundColor = [UIColor greenColor];
//            }
            
            if(cell == nil) {
                cell = [[DiscussDetailCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier2];
                
                UIView *view = [[UIView alloc] init];
                view.tag = 201;
                [cell.contentView addSubview:view];
                [cell bringSubviewToFront:view];
            }
            
            cell.pid = pid;
            cell.uid = sbj_uid;
            cell.cellNum = [NSString stringWithFormat:@"%d",row];
            
            // 名字，时间
            cell.label_username.text = username;
            cell.label_dateline.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            // 头像
            //-----update by kate 2014.11.14-----------------------------------
            NSString *head_url = [list_dic objectForKey:@"avatar"];
            // NSString* head_url = [util getAvatarFromUid:sbj_uid andType:@"1"];
            //------------------------------------------------------------------
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            
            cell.label_leftNum.text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
            
            cell.ext = ext;
            NSString *pic = @"";
            pic= [list_dic objectForKey:@"pic"];
            
            cell.pic = pic;
           

            
            CGRect rect = cell.frame;
//            rect.size.height = 110;
//            cell.frame = rect;
            
            
            if (![@""  isEqual: pic]) {
                NSURL *url = [NSURL URLWithString:pic];
                __weak ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
                
                NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                //                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"下载目标目录为：%@", amrDocPath] toView:nil];
                
                if (nil != amrDocPath) {
                    NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
                    
                    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:imagePathCell]) {
                        //                        [MBProgressHUD showSuccess:@"下载文件不存在" toView:nil];
                        
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        
                        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
                        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:imagePathCell append:NO];
                        
                        //已完成下载
                        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            NSData *audioData = [NSData dataWithContentsOfFile:imagePathCell];
                            cell.playRecordButton.hidden = NO;
                            cell.playImageView.hidden = NO;
                            
                            NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                            NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
                            
                            NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
                            
                            NSString *dur = [NSString stringWithFormat:@"%ld″", (long)[recordAudio dataDuration:fileData]] ;
                            
                            if([dur integerValue] > 60){//2015.11.13
                                dur = @"60";
                            }
                            
                            [cell.playRecordButton setTitle:dur forState:UIControlStateNormal];
                            [cell.playRecordButton setTitle:dur forState:UIControlStateSelected];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        }];
                        
                        [operation start];
                        
                    } else {
                        cell.playRecordButton.hidden = NO;
                        cell.playImageView.hidden = NO;
                        
                        NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                        if (nil != amrDocPath) {
                            NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
                            
                            NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
                            //
                            NSString *dur = [NSString stringWithFormat:@"%ld″", (long)[recordAudio dataDuration:fileData]] ;
                            if([dur integerValue] > 60){//2015.11.13
                                dur = @"60";
                            }
                            
                            [cell.playRecordButton setTitle:dur forState:UIControlStateNormal];
                            [cell.playRecordButton setTitle:dur forState:UIControlStateSelected];
                        }
                        
                        isPlayStatus = nil;
                    }
                }
                
                //----add 2015.09.21-----------------------------------------------------------------------------------
                // 以/div为标识，分割字符串
                NSArray *array = [message componentsSeparatedByString:@"</div>"];
                
                NSRange range;
                NSString *citedStr = @"";
                
                NSString *resultStr = @"";
                NSString *nameStr1;
                NSString *nameStr2;

                for(NSObject *temp in array)
                {
                    NSString *str = (NSString *)temp;
                    
                    if ([@"</span>"  isEqual: str]) {
                        continue;
                    }

                    NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                    NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                    NSUInteger len = foundOB.location - foundB.location;
                    
                    if (0 != len) {
                        nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                        nameStr1 = [NSString stringWithFormat:@"%@:", nameStr1];
                    }
                    
                    NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                    NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                    
                    if (0 != lenSpan) {
                        nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                        str = [NSString stringWithFormat:@"%@\n%@\n",nameStr1, nameStr2];
                        
                    }
                    
                    str = [str stringByAppendingString:@"\n"];
                    resultStr = [resultStr stringByAppendingString:str];
                }
                
                [cell.textParser.images removeAllObjects];
                
                
                NSString *displayStr = [self transformString:resultStr];
                NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
                
                MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
                
                NSAttributedString* attString1 = [resultStr expressionAttributedStringWithExpression:exp];
                NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString1];
                
                unsigned long len = 0;
                if (nil != nameStr1) {
                    len = [nameStr1 length] +1;
                }
                
                [mutableAttStr addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1]
                                      range:NSMakeRange(0,len)];
                
                cell.label.attributedText = mutableAttStr;

                CGSize a = [DiscussDetailCell heightForEmojiText:resultStr];

                
                float hei = a.height;// 2015.09.18
                if (hei > 450) {
                    hei = hei - 10;
                }else if(hei > 225 && hei <450) {
                    hei = hei - 5;
                }
                
                cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height, cell.contentView.frame.size.width-70,
                                              hei);

                
                NSString *citeStr = @"";
                
                
                if ([array count] == 1) {
                    cell.citeLabel.hidden = YES;
                    
                    
                    //                cell.citeLabel.frame = cell.label.frame;
                    
                    NSLog(@"cell.citeLabel.frame  ------  %f",cell.citeLabel.frame.size.height);
                    cell.button_copy.pasteboardStr = message;//2015.09.15
                    
                    
                    cell.playRecordButton.frame = CGRectMake(50,
                                                             70,
                                                             60,
                                                             28);
                    cell.playImageView.frame = CGRectMake(cell.playRecordButton.frame.origin.x + (cell.playRecordButton.frame.size.width/2 - 10)/2 + cell.playRecordButton.frame.size.width/2 - 5,
                                                          cell.playRecordButton.frame.origin.y + (cell.playRecordButton.frame.size.height - 10)/2, 10, 10);
                    //add 2016.07.27
                    cell.animationImageView.frame = CGRectMake(cell.playRecordButton.frame.origin.x + (cell.playRecordButton.frame.size.width/2 - 10)/2 + cell.playRecordButton.frame.size.width/2 - 5,
                                                               cell.playRecordButton.frame.origin.y + (cell.playRecordButton.frame.size.height - 10)/2, 10, 10);

                }else{
                    
                    cell.citeLabel.hidden = NO;
                    citeStr = [array objectAtIndex:1];
                    cell.button_copy.pasteboardStr = citeStr;//2015.09.15
                    
                    for(NSObject *temp in array)
                    {
                        NSString *str = (NSString *)temp;
                        
                        if ([@"</span>"  isEqual: str]) {
                            continue;
                        }

                        NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                        NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                        NSUInteger len = foundOB.location - foundB.location;
                        
                        if (0 != len) {
                            nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                        }
                        
                        NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                        NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                        
                        if (0 != lenSpan) {
                            nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                            str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
                            citeStr = str;
                            break;
                        }
                    }
                    
                    CGSize b = [DiscussDetailCell heightForEmojiText:citeStr];
                    
                    //CGFloat height = b.height + 2;
                    CGFloat height = b.height - 12.0 ;// 2015.09.18
                    NSLog(@"%f",cell.label.frame.size.height);
                    NSLog(@"%f",height);
                    
                    float y = cell.label.frame.origin.y + 5.0;
                    cell.citeLabel.frame = CGRectMake(cell.label_username.frame.origin.x - 10.0, y, cell.contentView.frame.size.width-60,
                                                      height);
                    
                    
                    cell.playRecordButton.frame = CGRectMake(cell.citeLabel.frame.origin.x, cell.citeLabel.frame.origin.y+cell.citeLabel.frame.size.height+20, 60.0, 28.0);
                    cell.playImageView.frame = CGRectMake(cell.playRecordButton.frame.origin.x + (cell.playRecordButton.frame.size.width/2 - 10)/2 + cell.playRecordButton.frame.size.width/2 - 5,
                                                          cell.playRecordButton.frame.origin.y + (cell.playRecordButton.frame.size.height - 10)/2, 10, 10);
                    //add 2016.07.27
                    cell.animationImageView.frame = CGRectMake(cell.playRecordButton.frame.origin.x + (cell.playRecordButton.frame.size.width/2 - 10)/2 + cell.playRecordButton.frame.size.width/2 - 5,
                                                               cell.playRecordButton.frame.origin.y + (cell.playRecordButton.frame.size.height - 10)/2, 10, 10);
                    cell.label.hidden = NO;

                }

                
//                CGRect rect = cell.frame;
//                rect.size.height = 110;
//                cell.frame = rect;
                rect.size.height = (cell.label.frame.origin.y+cell.label.frame.size.height+5);//2015.09.19

                cell.frame = rect;
                
                [cell.imgView_leftLine setImage:[UIImage imageNamed:@"tlq_lvxian.png"]];
                [cell.imgView_leftLine setFrame:CGRectMake(28,
                                                           70,
                                                           2,
                                                           rect.size.height-70)];
                
                if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
                {
                    // 动态计算分割线位置，set到cell中
                    cell.imgView_line.frame =CGRectMake(
                                                        cell.label_username.frame.origin.x,
                                                        cell.frame.size.height - 2,
                                                        250,
                                                        1);
                }
                else
                {
                    // 动态计算分割线位置，set到cell中
                    cell.imgView_line.frame =CGRectMake(
                                                        cell.label_username.frame.origin.x,
                                                        108,
                                                        250,
                                                        1);
                }
            }
            
            return cell;
            
        }else if([@"png"  isEqual: ext]) {
            DiscussDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier3];
//            if (indexPath.row%2 == 0) {
//                cell.backgroundColor = [UIColor yellowColor];
//            }else{
//                cell.backgroundColor = [UIColor purpleColor];
//            }
            if(cell == nil) {
                cell = [[DiscussDetailCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier3];
                
                UIView *view = [[UIView alloc] init];
                view.tag = 201;
                [cell.contentView addSubview:view];
                [cell bringSubviewToFront:view];
            }
            
            cell.pid = pid;
            cell.uid = sbj_uid;
            cell.uid = sbj_uid;
            cell.cellNum = [NSString stringWithFormat:@"%d",row];
            
            // 名字，时间
            cell.label_username.text = username;
            cell.label_dateline.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            // 头像
            NSString *head_url = [list_dic objectForKey:@"avatar"];
            
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            
            cell.label_leftNum.text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
            
            cell.ext = ext;
            NSString *pic = @"";
            pic= [list_dic objectForKey:@"pic"];
            
            cell.pic = pic;
            
            // 动态计算label高度，set到cell中
            CGRect rect = cell.frame;
            //        NSRange range = [message rangeOfString:@"/div"];
            //
            //        //range=[string5 rangeOfString:@"Mac OS"];
            //        if (range.location!=NSNotFound)
            //        {
            //            //得到字符串的位置和长度
            //            NSLog(@"%d,%d",range.location,range.length);
            //            NSString *nstr3=[message substringWithRange:NSMakeRange(range.location,range.length)];
            //        }
            
            // 以/div为标识，分割字符串
            NSArray *array = [message componentsSeparatedByString:@"</div>"];
            
            NSRange range;
            NSString *citedStr = @"";
            
            NSString *resultStr = @"";
            NSString *nameStr1;
            NSString *nameStr2;
            
            for(NSObject *temp in array)
            {
                NSString *str = (NSString *)temp;
                
                if ([@"</span>"  isEqual: str]) {
                    continue;
                }

                NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                NSUInteger len = foundOB.location - foundB.location;
                
                if (0 != len) {
                    nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                    nameStr1 = [NSString stringWithFormat:@"%@:", nameStr1];
                }
                
                NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                
                if (0 != lenSpan) {
                    nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                    str = [NSString stringWithFormat:@"%@\n%@\n",nameStr1, nameStr2];
                }
                
                str = [str stringByAppendingString:@"\n"];
                resultStr = [resultStr stringByAppendingString:str];
            }
            
            [cell.textParser.images removeAllObjects];
            resultStr = [resultStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            
            NSString *displayStr = [self transformString:resultStr];
            NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
            
            MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
            
            NSAttributedString* attString1 = [resultStr expressionAttributedStringWithExpression:exp];
            NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString1];
            
            unsigned long len = 0;
            if (nil != nameStr1) {
                len = [nameStr1 length] +1;
            }
            
            [mutableAttStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1]
                                  range:NSMakeRange(0,len)];
            
            cell.label.attributedText = mutableAttStr;
            
            //---update 2015.09.18------------------------------------------------------------------
            /*[cell.textParser.images removeAllObjects];
            
            
            NSString *displayStr = [self transformString:resultStr];
            NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
            
            attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
            [attString setFont:[UIFont systemFontOfSize:16]];
            
            [cell.label resetAttributedText];
            
            //NSLog(@"images:%@",textParser.images);
            //NSLog(@"attString:%@",attString);
            [cell.label setAttString:attString withImages:cell.textParser.images];
            cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-70,
                                          [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue]);*/
//            [cell setMLLabelText:resultStr];
            
            
            
            CGSize a = [DiscussDetailCell heightForEmojiText:resultStr];
            //----------------------------------------------------------------------------------
            
            float hei = a.height;// 2015.09.18
            if (hei > 450) {
                hei = hei - 10;
            }else if(hei > 225 && hei <450) {
                hei = hei - 5;
            }
//
//            cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-70,
//                                          hei);

            
//            CGSize b = [DiscussDetailCell heightForEmojiText:resultStr];

            
            cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height, cell.contentView.frame.size.width-60,
                                          hei);
            //-------------------------------------------------------------------------------------------
            
            //----2015.09.15--------------------------------------
            if ([message length]>0) {
                cell.button_copy.hidden = NO;
            }else{
                cell.button_copy.hidden = YES;
            }
            
            if ([array count] == 1) {
                
                cell.button_copy.pasteboardStr = message;
                
            }else{
                
                cell.button_copy.pasteboardStr = [array objectAtIndex:1];
                
            }
            //------------------------------------------------------
            
            //[cell.label.layer display];
            //----------------------------------------
            /*OHAttributedLabel *attributeLabel =  [self creatLabelArr:resultStr];
             // NSLog(@"attributeLabelhight:%f",attributeLabel.frame.size.height);
             
             //重用Cell的时候移除label
             UIView *view = (UIView *)[cell viewWithTag:201];
             view.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-70, attributeLabel.frame.size.height+20);
             //重用Cell的时候移除label
             for (UIView *subView in [view subviews]) {
             if ([subView isKindOfClass:[OHAttributedLabel class]]) {
             [subView removeFromSuperview];
             }
             }
             //attributeLabel.center = view.center;
             [view addSubview:attributeLabel];
             */

            // rect.size.height = (view.frame.origin.y + view.frame.size.height);
            rect.size.height = (cell.label.frame.origin.y + cell.label.frame.size.height);
            // image button
            if ([@"png"  isEqual: ext]) {
                //                rect.size.height = (view.frame.origin.y + view.frame.size.height + 100);
                rect.size.height = (cell.label.frame.origin.y + cell.label.frame.size.height+120);
                
                if (![@""  isEqual: resultStr]) {
                    rect.size.height = rect.size.height - 10;
                }

                if (![@""  isEqual: pic]) {
                    NSURL *url = [NSURL URLWithString:pic];
                    //                    cell.imageButton.frame = CGRectMake(view.frame.origin.x,
                    //                                                        view.frame.origin.y + view.frame.size.height,
                    //                                                        90, 90);
                    cell.imageButton.frame = CGRectMake(cell.label.frame.origin.x, cell.label.frame.origin.y+cell.label.frame.size.height, 90.0, 90.0);
                    [cell.imageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                    cell.imageButton.hidden = NO;
                    
                    //---2015.09.18--------------------------------------------------------------
                    
                    if ([array count] > 0) {
                        
                        NSString *str = [array objectAtIndex:0];
                        
                        NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                        NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                        NSUInteger len = foundOB.location - foundB.location;
                        
                        if (0 != len) {
                            nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                        }
                        
                        NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                        NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                        
                        if (0 != lenSpan) {
                            nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                            str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
                            citedStr = str;
                        }
                        
                        cell.citeLabel.hidden = YES;
                        
                        if ([citedStr length] > 0) {
                            cell.citeLabel.hidden = NO;
                            float height = [DiscussDetailCell heightForEmojiText:citedStr].height -17.0;
                            float y = cell.label.frame.origin.y + 7.0;
                            cell.citeLabel.frame = CGRectMake(cell.label_username.frame.origin.x - 10.0, y, cell.contentView.frame.size.width-60,height);
                            
                        }
                        
                        if ([array count] == 2) {
                            NSString *commentStr = [array objectAtIndex:1];
                            if ([commentStr length] == 0) {
                                cell.button_copy.hidden = YES;
                            }else{
                                cell.button_copy.hidden = NO;
                            }
                        }
                       
                    }
                    //----------------------------------------------------------------------------

                }
            }
            
            if ([array count] == 1) {
                
                cell.citeLabel.hidden = YES;
            }else{
                cell.citeLabel.hidden = NO;
                
            }

            cell.frame = rect;
            
            [cell.imgView_leftLine setImage:[UIImage imageNamed:@"tlq_lvxian.png"]];
            [cell.imgView_leftLine setFrame:CGRectMake(28,
                                                       70,
                                                       2,
                                                       rect.size.height-70)];
            
            
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
               
                cell.imgView_line.frame =CGRectMake(
                                                    cell.label_username.frame.origin.x,
                                                    cell.frame.size.height - 2,
                                                    250,
                                                    1);
//
//                cell.imgView_line.frame =CGRectMake(
//                                                    cell.label_username.frame.origin.x,
//                                                    cell.imageButton.frame.origin.y+90.0+20.0,
//                                                    250,
//                                                    1);
            }
            else
            {
                // 动态计算分割线位置，set到cell中
                cell.imgView_line.frame =CGRectMake(
                                                    cell.label_username.frame.origin.x,
                                                    cell.label_message.frame.origin.y + cell.label_message.frame.size.height + 10,
                                                    250,
                                                    1);
            }
            return cell;
        }else {
            DiscussDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
            if(cell == nil) {
                cell = [[DiscussDetailCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier1];
            }
            
            cell.pid = pid;
            cell.uid = sbj_uid;
            cell.cellNum = [NSString stringWithFormat:@"%d",row];
            
            // 名字，时间
            cell.label_username.text = username;
            cell.label_dateline.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            // 头像
            NSString *head_url = [list_dic objectForKey:@"avatar"];
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
            
            cell.label_leftNum.text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
            
            cell.ext = ext;
            NSString *pic = @"";
            pic= [list_dic objectForKey:@"pic"];
            
            cell.pic = pic;
            
            // 动态计算label高度，set到cell中
            CGRect rect = cell.frame;

            // 以/div为标识，分割字符串
            NSArray * array = [message componentsSeparatedByString:@"</div>"];
            //NSLog(@"array:%@",array);
            //NSLog(@"count:%d",[array count]);
            
            NSString *resultStr = @"";
            NSRange range;
            
            //------add by kate 2015.04.01-----
            NSString *citeStr = @"";
            //            NSString *tempStr = @"";
            //            NSString *tempStr1 = @"";
            //            NSString *lineStr0 = @"";
            
            NSString *nameStr1;
            NSString *nameStr2;

            for(NSObject *temp in array)
            {
                NSString *str = (NSString *)temp;
                
                if ([@"</span>"  isEqual: str]) {
                    continue;
                }

                NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                NSUInteger len = foundOB.location - foundB.location;
                
                if (0 != len) {
                    nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                    nameStr1 = [NSString stringWithFormat:@"%@:", nameStr1];
                }

                NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                
                if (0 != lenSpan) {
                    nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                    str = [NSString stringWithFormat:@"%@\n%@\n",nameStr1, nameStr2];

                }
                
                str = [str stringByAppendingString:@"\n"];
                resultStr = [resultStr stringByAppendingString:str];
            }

            [cell.textParser.images removeAllObjects];
            
            
            NSString *displayStr = [self transformString:resultStr];
            NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
            
            MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改

            NSAttributedString* attString1 = [resultStr expressionAttributedStringWithExpression:exp];
            NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString1];
            
            unsigned long len = 0;
            if (nil != nameStr1) {
                len = [nameStr1 length] +1;
            }
            
            [mutableAttStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1]
                                  range:NSMakeRange(0,len)];
            
            cell.label.attributedText = mutableAttStr;

            CGSize a = [DiscussDetailCell heightForEmojiText:resultStr];
            //----------------------------------------------------------------------------------

            float hei = a.height;// 2015.09.18
            if (hei > 450) {
                hei = hei - 10;
            }else if(hei > 225 && hei <450) {
                hei = hei - 5;
            }
            
            cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height, cell.contentView.frame.size.width-70,
                                          hei);
            
            NSLog(@"cell.label.frame  ------  %f",cell.label.frame.size.height);
            
            //---add by kate 2015.04.01-------------------------------
            if ([array count] == 1) {
                cell.citeLabel.hidden = YES;
                
                
                //                cell.citeLabel.frame = cell.label.frame;
                
                NSLog(@"cell.citeLabel.frame  ------  %f",cell.citeLabel.frame.size.height);
                cell.button_copy.pasteboardStr = message;//2015.09.15
                
            }else{
                
                cell.citeLabel.hidden = NO;
                citeStr = [array objectAtIndex:1];
                cell.button_copy.pasteboardStr = citeStr;//2015.09.15
                
                for(NSObject *temp in array)
                {
                    NSString *str = (NSString *)temp;
                    
                    if ([@"</span>"  isEqual: str]) {
                        continue;
                    }

                    NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
                    NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
                    NSUInteger len = foundOB.location - foundB.location;
                    
                    if (0 != len) {
                        nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
                    }
                    
                    NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
                    NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
                    
                    if (0 != lenSpan) {
                        nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                        str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
                        citeStr = str;
                        break;
                    }
                }
                
                CGSize b = [DiscussDetailCell heightForEmojiText:citeStr];
                
                //CGFloat height = b.height + 2;
                  CGFloat height = b.height - 13.0 ;// 2015.09.18
                NSLog(@"%f",cell.label.frame.size.height);
                NSLog(@"%f",height);
                
                float y = cell.label.frame.origin.y + 7.0;
                cell.citeLabel.frame = CGRectMake(cell.label_username.frame.origin.x - 10.0, y, cell.contentView.frame.size.width-60,
                                                  height);
            }
            
            rect.size.height = (cell.label.frame.origin.y+cell.label.frame.size.height+5);//2015.09.19
            cell.frame = rect;
            //---------------------------------------------------
            
            [cell.imgView_leftLine setImage:[UIImage imageNamed:@"tlq_lvxian.png"]];
            [cell.imgView_leftLine setFrame:CGRectMake(28,
                                                       70,
                                                       2,
                                                       rect.size.height-70)];
            
            
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
//                cell.imgView_line.frame =CGRectMake(
//                                                    cell.label_username.frame.origin.x,
//                                                    [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 100.0 - 50+30-2 + 19 - 2,
//                                                    250,
//                                                    1);
                cell.imgView_line.frame =CGRectMake(
                                                    cell.label_username.frame.origin.x,
                                                    [[cellHeightArray objectAtIndex:[indexPath row]-1] floatValue] + 60 - 2,
                                                    250,
                                                    1);
                
            }
            else
            {
                // 动态计算分割线位置，set到cell中
                cell.imgView_line.frame =CGRectMake(
                                                    cell.label_username.frame.origin.x,
                                                    cell.label_message.frame.origin.y + cell.label_message.frame.size.height + 10,
                                                    250,
                                                    1);
            }
            if ([message length] >0) {
                cell.button_copy.hidden = NO;//2015.09.14
            }
            
            return cell;
        }
    }
}

- (CGSize)frameSizeForAttributedString:(NSAttributedString *)attributedString
{
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 70.0;
    
    CFIndex offset = 0, length;
    CGFloat y = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));
        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        CFRelease(line);
        
        offset += length;
        y += ascent + descent + leading;
    } while (offset < [attributedString length]);
    
    CFRelease(typesetter);
    
    return CGSizeMake(width, ceil(y));
}

- (void)cellRequestDidSuccess:(ASIHTTPRequest *)request
{
    
    //    NSString *downloadPath = request.downloadDestinationPath;
    //
    //    NSArray *tempArray = [downloadPath componentsSeparatedByString:@"/"];
    //    NSInteger maxCount = [tempArray count] - 1;
    //
    //    NSString *needReflashCellNum = [tempArray objectAtIndex:maxCount];
    //
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:needReflashCellNum.integerValue inSection:0];
    //    DiscussDetailCell *detailCell = (DiscussDetailCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    
    //    detailCell.playRecordButton.hidden = NO;
    //    detailCell.playImageView.hidden = NO;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    // 20140920 update by ht 如果教师未过批准，学生未加入班级，则不显示回帖bar
    NSDictionary *user_info = [g_userInfo getUserDetailInfo];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];
    
    //------add by kate 2015.03.23----------------------------------------
    if (0 != indexPath.row) {
        NSDictionary* list_dic = [discussArray objectAtIndex:indexPath.row-1];
        NSString* sbj_uid= [list_dic objectForKey:@"uid"];
        if ([[Utilities getUniqueUid] isEqualToString:sbj_uid]) {
            if (indexPath.row != 0) {
                
                pid = [list_dic objectForKey:@"pid"];
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除这条评论？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
                alerV.tag = 305;
                [alerV show];
                
            }
            //-------------------------------------------------------------------
        }else{
            if([@"7"  isEqual: role_id] || [@"9" isEqual:role_id] || [@"2" isEqual:role_id]) {//update 2015.09.15
                if ([@"1"  isEqual: role_checked]) {
                    if (indexPath.row != 0) {
                        //        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        //            [((UIView*)obj) resignFirstResponder];
                        //        }];    [text_name becomeFirstResponder];
                        
                        DiscussDetailCell *detailCell = (DiscussDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                        
                        if (![[Utilities getUniqueUid] isEqual: detailCell.uid]) {
                            [_inputTextView becomeFirstResponder];
                            
                            //                        _inputTextView.text = [NSString stringWithFormat:@"回复%@:", detailCell.label_username.text];
                            _replyTo = [NSString stringWithFormat:@"回复%@: ", detailCell.label_username.text];
                            _isFirstClickReply = true;
                            _inputTextView.textColor = [UIColor blackColor];
                            
                            _replyToLabel.text = _replyTo;
                            [_replyToLabel setHidden:NO];
                            
                            isReply = YES;
                            replyPid = detailCell.pid;
                        }
                    }
                }else {
                }
            }else {
                if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                }else {
                    if (indexPath.row != 0) {
                        //        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        //            [((UIView*)obj) resignFirstResponder];
                        //        }];    [text_name becomeFirstResponder];
                        
                        DiscussDetailCell *detailCell = (DiscussDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                        
                        if (![[Utilities getUniqueUid] isEqual: detailCell.uid]) {
                            [_inputTextView becomeFirstResponder];
                            
                            //                        _inputTextView.text = [NSString stringWithFormat:@"回复%@:", detailCell.label_username.text];
                            _replyTo = [NSString stringWithFormat:@"回复%@: ", detailCell.label_username.text];
                            _isFirstClickReply = true;
                            _inputTextView.textColor = [UIColor blackColor];
                            
                            _replyToLabel.text = _replyTo;
                            [_replyToLabel setHidden:NO];
                            
                            isReply = YES;
                            replyPid = detailCell.pid;
                        }
                    }
                }
            }
        }
    }
    
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGSize actualSize = [webView sizeThatFits:CGSizeMake(WIDTH, 9990)];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    NSString*output =[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    NSLog(@"height: %@", output);
    
    NSString *a = [Utilities replaceNull:[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]];
    NSLog(@"%@",a);
    
    //    if ([@"100"  isEqual: [Utilities replaceNull:string]]) {
    //        webHight = 50;
    //    }else {
    //        webHight = [string floatValue];
    //    }
    
    //    shopWebView = [UIWebView alloc];
    webHight = [string floatValue];
    
    //---update by kate 2015.02.02---------
    // webView如果想复制，那么最小高度要超过100
    if (webHight <= 100) {
        
        webHight = 101;
        
    }
    //-------------------------------------
    
    shopWebViewHiden.hidden = true;
    [shopWebViewHiden removeFromSuperview];
    
    
//    [_tableView reloadData];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.5];// add by kate 2015.01.23
    
    //    [Utilities dismissProcessingHud:self.view];
    
    
    
    //-------add by kate-----------------
    
    //    CGPoint pt = [sender locationInView:shopWebView];
    //    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    //    NSString *urlToSave = [shopWebView stringByEvaluatingJavaScriptFromString:imgURL];
    //    if (urlToSave.length > 0) {
    //
    //        if([urlToSave rangeOfString:@"face"].location == NSNotFound )//非表情图片
    //        {
    //            [self showImageURL:urlToSave point:pt];
    //        }
    //
    //    }
    
    //------------------------
    
    
    //[self.tableView reloadData]; //这里就一直刷新
    //[self reflashTable];
    
    //    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];//刷新第一个section的第二行
    //    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationMiddle];
    
    
    //[self performSelector:@selector(reflashTable) withObject:nil afterDelay:0.1];
    
    if (test <= 1) {
        [_tableView reloadData];
    }
    
    test = test + 1;
    //[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView// update by kate 2015.01.23
{
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    //     NSDictionary *userD = [g_userInfo getUserDetailInfo];
    //     NSString *cid  = [userD objectForKey:@"cid"];
    
    // 新接口增加参数last 返回参数增加order hasNext last 2015.01.23
    
    if ((2 == flag) || (4 == flag)) {
    
    }else {
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"2"  isEqual: usertype] || [@"9"  isEqual: usertype])
        {
            _cid = [userDetailInfo objectForKey:@"role_cid"];
        }
        else
        {
            _cid = [userDetailInfo objectForKey:@"role_cid"];
        }
        
        if (nil == _cid) {
            _cid = @"0";
        }
    }
    

    
    if (flag == 1) {
        //讨论区
        
        [ReportObject event:ID_OPEN_THREAD_DETAIL];// 2015.06.24
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"SchoolThread",@"ac",
                              @"view", @"op",
                              self.tid, @"tid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              @"300",@"width",
                              _cid, @"cid",
                              lastId,@"lastId",
                              nil];
        
        [network sendHttpReq:HttpReq_ThreadDetail andData:data];
    }else if(flag == 2){
        //班机公告
        
        [ReportObject event:ID_OPEN_CLASS_NEWS];// 2015.06.24
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"ClassThread",@"ac",
                              @"view", @"op",
                              self.tid, @"tid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              @"300",@"width",
                              lastId,@"lastId",
                              _cid, @"cid",
                              nil];
        
        [network sendHttpReq:HttpReq_ThreadDetails andData:data];
    }else if (flag == 4){
        // 班级讨论区
        
        [ReportObject event:ID_OPEN_CLASS_THREAD];//2015.06.24
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"ClassForumThread",@"ac",
                              @"1",@"v",
                              @"view", @"op",
                              self.tid, @"tid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              @"300",@"width",
                              _cid, @"cid",
                              lastId,@"lastId",
                              nil];
        
        [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
    }else if (flag == 5){
        // 教育局版本校校通tab
        [ReportObject event:ID_OPEN_CLASS_THREAD];//2015.06.24
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"ClassForumThread",@"ac",
                              @"1",@"v",
                              @"view", @"op",
                              self.tid, @"tid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              @"300",@"width",
                              _cid, @"cid",
                              lastId,@"lastId",
                              _schoolExhiId, @"sid",
                              nil];
        
        [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
    }else{//作业
        
        [ReportObject event:ID_OPEN_HOMEWORK_DETAIL];// 2015.06.24
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Homework", @"ac",
                              self.tid, @"tid",
                              @"view", @"op",
                              @"300", @"width",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              _cid, @"cid",
                              lastId,@"lastId",
                              nil];
        [network sendHttpReq:HttpReq_HomeworkDetail andData:data];
    }
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];//加入上拉加载更多
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    NSLog(@"1bounds.height:%f",self->_tableView.bounds.size.height);//460
    NSLog(@"1contensize.height:%f",self->_tableView.contentSize.height);//2710 2810
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self->_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.3];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.3];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    NSLog(@"刷新完成");
    //    NSDictionary *userD = [g_userInfo getUserDetailInfo];
    //    NSString *cid  = [userD objectForKey:@"cid"];
    
    
    // tset 111111
    //    [discussArray removeAllObjects];
    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
    [[NSFileManager defaultManager] removeItemAtPath:amrDocPath error:nil];
    
    if (reflashFlag == 1) {
        self->startNum = @"0";
        //self->endNum = @"500";
        self->endNum = @"20";////加入上拉加载更多 add by kate
        lastId = @"0";
        
        if (flag == 1) {
            //讨论区
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"SchoolThread",@"ac",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadDetail andData:data];
        }else if(flag == 2){
            //班机公告
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"ClassThread",@"ac",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadDetails andData:data];
            
        }else if (flag == 4){
            // 班级讨论区
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  nil];
            
            [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
        }else if (flag == 5){
            // 教育局版本校校通tab
            [ReportObject event:ID_OPEN_CLASS_THREAD];//2015.06.24
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  _schoolExhiId, @"sid",
                                  nil];
            
            [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
        }else{
            //作业
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Homework", @"ac",
                                  _cid, @"cid",
                                  self.tid, @"tid",
                                  @"view", @"op",
                                  @"300", @"width",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  lastId,@"lastId",
                                  nil];
            
            [network sendHttpReq:HttpReq_HomeworkDetail andData:data];
        }
    }
}

//加载更多
-(void)getNextPageView
{
    // add code if necessary
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        
        if (flag == 1) {
            //讨论区
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"SchoolThread",@"ac",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadDetail andData:data];
            
        }else if(flag == 2){
            //班机公告
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"ClassThread",@"ac",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadDetails andData:data];
        }else if (flag == 4){
            // 班级讨论区 add by kate 2014.12.02
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  nil];
            
            [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
        }else if (flag == 5){
            // 教育局版本校校通tab
            [ReportObject event:ID_OPEN_CLASS_THREAD];//2015.06.24
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"ClassForumThread",@"ac",
                                  @"1",@"v",
                                  @"view", @"op",
                                  self.tid, @"tid",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  @"300",@"width",
                                  _cid, @"cid",
                                  lastId,@"lastId",
                                  _schoolExhiId, @"sid",
                                  nil];
            
            [network sendHttpReq:HttpReq_ClassThreadDetail andData:data];
        }else{
            //作业
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Homework", @"ac",
                                  _cid, @"cid",
                                  self.tid, @"tid",
                                  @"view", @"op",
                                  @"300", @"width",
                                  self->startNum, @"page",
                                  self->endNum, @"size",
                                  nil];
            
            [network sendHttpReq:HttpReq_HomeworkDetail andData:data];
        }
        
    }
    
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

// cell高度
-(void)calcCellHeight:(NSString *)str andRow:(int)row
{
    NSDictionary* list_dic = [discussArray objectAtIndex:row];
    
    NSString* message= [list_dic objectForKey:@"message"];
    
    // 以/div为标识，分割字符串
    NSArray * array = [message componentsSeparatedByString:@"</div>"];
    
    //NSString *citeStr = @"";
    NSString *resultStr = @"";
    NSString *nameStr1 = @"";
    NSString *nameStr2 = @"";

    NSRange range;
    
    for(NSObject *temp in array)
    {
        NSString *str = (NSString *)temp;
        
        if ([@"</span>"  isEqual: str]) {
            continue;
        }

        NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
        NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
        NSUInteger len = foundOB.location - foundB.location;
        
        if (0 != len) {
            nameStr1 = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
            nameStr1 = [NSString stringWithFormat:@"%@:", nameStr1];
        }
        
        NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
        NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
        
        if (0 != lenSpan) {
            nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
            str = [NSString stringWithFormat:@"%@\n%@\n",nameStr1, nameStr2];
           
        }
        
        str = [str stringByAppendingString:@"\n"];
        resultStr = [resultStr stringByAppendingString:str];
    }
    
//    [cell.textParser.images removeAllObjects];
//    
//    
//    NSString *displayStr = [self transformString:resultStr];
//    NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
//    
//    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
//    
//    NSAttributedString* attString1 = [resultStr expressionAttributedStringWithExpression:exp];
//    NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString1];
//    
//    unsigned long len = 0;
//    if (nil != nameStr1) {
//        len = [nameStr1 length] +1;
//    }
//    
//    [mutableAttStr addAttribute:NSForegroundColorAttributeName
//                          value:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0]
//                          range:NSMakeRange(0,len)];
//    
//    cell.label.attributedText = mutableAttStr;
//    
//    CGSize a = [DiscussDetailCell heightForEmojiText:resultStr];
    
    
    //    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    resultStr = [resultStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    //---update by kate---------------------------------------
    /*NSString *displayStr = [self transformString:resultStr];
     
     [textParser.images removeAllObjects];
     
     NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
     
     attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
     [attString setFont:[UIFont systemFontOfSize:14]];
     
     [currentLabel setAttString:attString withImages:textParser.images];
     
     CGRect labelRect = currentLabel.frame;
     labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
     labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;*/
    
    /*----------update 2015.09.18-------------------------------------------------------------------------
     
     NSString *newString = [self textFromEmoji:resultStr];
     //    CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont systemFontOfSize:16.0]  withWidth:[UIScreen mainScreen].bounds.size.width - 70.0];
     
     NSMutableAttributedString* attString = [_textParser attrStringFromMarkup:newString];
     attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
     [attString setFont:[UIFont systemFontOfSize:16]];
     
     CGSize b = [self frameSizeForAttributedString:attString];
     
     //   CGSize size = [Utilities getStringHeight:newString andFont:[UIFont systemFontOfSize:16.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70.0, 0)];
     
     
     //    CGSize a = [self frameSizeForAttributedString:attString];*/
    
    CGSize b =[DiscussDetailCell heightForEmojiText:resultStr];
    
    //float hei = b.height;
    float hei = b.height;//2015.09.18
    //-----------------------------------------------------------------------------------------------------------------
    if (hei >= 450) {
        hei = hei - 10;
    }else if(hei > 225 && hei <450) {
        hei = hei - 3;
    }
    
    
    CGFloat contentHeight = hei + 2;
    
  
    [cellHeightArray addObject:[NSString stringWithFormat:@"%f",contentHeight]];
    
    //-------------------------------------------------------------------------
}

- (NSString *)textFromEmoji:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"怒"];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"protocol:%@",[resultJSON objectForKey:@"protocol"]);
    NSString *protocol = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"protocol"]];
    NSString *result = [resultJSON objectForKey:@"result"];
    if((HttpReq_ThreadReply == type) ||
       (HttpReq_ThreadsReply == type) ||
       ((HttpReq_HomeworkReply == type)) || HttpReq_ClassThreadReply == type)
    {
        [Utilities dismissProcessingHud:self.view];
        
        if(true == [result intValue])
        {
            if(flag == 1){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewForDiscussView" object:nil];
                
            }
            
            imagePath = nil;
            
            isReply = NO;
            replyPid = @"";
            
#if 0
            // Bug 2848
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];;
            
            NSString *delete = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"delete"]];
            
            if ([delete integerValue] == 1) {
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"error"]]
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 333;
                [alert show];
                return;
            }
#endif
            
            [Utilities showSuccessedHud:@"回复成功" descView:self.view];
            
            //reflashFlag = 1;
            [self refreshView];
            
            // 回复成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            if ((HttpReq_ThreadReply == type)) {
                [dr dataReportGPStype:DataReport_Act_Discuss_Reply];
                [ReportObject event:ID_REPLY_THREAD];//2015.06.24
            }else if (HttpReq_ThreadsReply == type) {
                [dr dataReportGPStype:DataReport_Act_Class_ReplyNews];
                [ReportObject event:ID_REPLY_CLASS_NEWS];//2015.06.24
            }else if (HttpReq_HomeworkReply == type) {
                [dr dataReportGPStype:DataReport_Act_Class_ReplyHonework];
                [ReportObject event:ID_REPLY_HOMEWORK_DETAIL];//2015.06.24
            }else{
                [ReportObject event:ID_REPLY_CLASS_THREAD];//2015.06.24
            }
        }
        else
        {
            
            //            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
            //                                                           message:@"回复失败，请稍候再试"
            //                                                          delegate:nil
            //                                                 cancelButtonTitle:@"确定"
            //                                                 otherButtonTitles:nil];
            //            [alert show];
            
            [Utilities showFailedHud:@"回复失败，请稍候再试" descView:self.view];
            
        }
    }else if ([@"SchoolThreadAction.deletePost" isEqualToString: protocol]|| [@"ClassThreadAction.deletePost" isEqualToString: protocol] || [@"ClassForumThreadAction.deletePost" isEqualToString: protocol] || [@"HomeworkAction.deletePost" isEqualToString: protocol]) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if(true == [result intValue]){
            
            [self refreshView];
            if(flag == 1){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewForDiscussView" object:nil];
                
            }
            
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"删除失败，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }else
    {
        [Utilities dismissProcessingHud:self.view];
        
        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];;
            NSLog(@"message_info:%@",message_info);
            
            NSString *delete = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"delete"]];
            
            if ([delete integerValue] == 1) {
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"error"]]
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 333;
                [alert show];
                return;
            }
            
            NSDictionary *thread = [message_info objectForKey:@"thread"];;
            NSMutableArray *list = nil;
            NSDictionary *posts = [message_info objectForKey:@"posts"];
            list = [posts objectForKey:@"list"];
            
            history = [message_info objectForKey:@"history"];
            //            NSArray *his = [history objectForKey:@"list"];
            //            NSString *count = [history objectForKey:@"count"];
            
            //discussArray = list;
            threadDic = thread;
            _pics = [thread objectForKey:@"pics"];
            
            lastId = [Utilities replaceNull:[posts objectForKey:@"last"]];// 每次返回新数据的lastId
            
            if (isReflashViewType == 1) {
                [discussArray removeAllObjects];
                
            }
            
            for (NSObject *object in list)
            {
                [discussArray addObject:object];
                
            }
            
            
            //            if([startNum intValue] == 0){
            
            [cellHeightArray removeAllObjects];
            
            //            }
            
            for (int i=0; i<[discussArray count]; i++) {
                //                if (i != 0) {
                [self calcCellHeight:@"" andRow:i];
                //                }
            }
            
            [self removeFooterView];
            
            //----add by kate 2015.01.23---------------------------------------
            if(webHight > 0){
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            }
            //---------------------------------------------------------------
            
            NSString* content= [threadDic objectForKey:@"message"];
            
            NSString* pic= [threadDic objectForKey:@"pic"];
            
            if ((![@""  isEqual: pic]) && nil != pic) {
                isAudioSubject = YES;
            }
#if 0
            // 先显示在一个隐藏的webview中，可以先计算webview的高度
            shopWebViewHiden = [[UIWebView alloc]initWithFrame:CGRectMake(10, 120.0, WIDTH-20, 10)];
            shopWebViewHiden.backgroundColor = [UIColor clearColor];
            shopWebViewHiden.opaque = NO;
            shopWebViewHiden.delegate = self;
            [(UIScrollView *)[[shopWebViewHiden subviews] objectAtIndex:0] setBounces:NO];
            //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
            [shopWebViewHiden setScalesPageToFit:NO];
            [shopWebViewHiden loadHTMLString:content baseURL:nil];
#else
            // 先显示在一个隐藏的webview中，可以先计算webview的高度
            shopWebView.backgroundColor = [UIColor clearColor];
            shopWebView.opaque = NO;
            shopWebView.delegate = self;
            [(UIScrollView *)[[shopWebView subviews] objectAtIndex:0] setBounces:NO];
            //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
            [shopWebView setScalesPageToFit:NO];
            [shopWebView loadHTMLString:content baseURL:nil];
#endif
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 20)];
            
            // 这里先不刷新tabview，等待hiden的webview计算出高度后再刷新table
            //刷新表格内容
            //[_tableView reloadData];
            
            //-------发表成功后键盘下落 变回标准样式-----------------
            // 输入框置空
            _inputTextView.text = @"";
            
            // 去掉红点
            photoFlagImageView.hidden = YES;
            
            // 去掉语音
            curAudio = nil;
            
            playRecordButton.hidden = YES;
            deleteRecordButton.hidden = YES;
            playImageView.hidden = YES;
            
            // 去掉图片
            isSelectPhoto = NO;
            photoFlagImageView.hidden = YES;
            photoDeleteButton.hidden = YES;
            
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            
            //isButtonClicked = NO;
            //textView.inputView = nil;
            //isSystemBoardShow = YES;
            //clickFlag = 0;
            //audioButn.hidden = YES;
            //[textView resignFirstResponder];
            //	        AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
            //            [AudioButton setImage:[UIImage imageNamed:@"/faceImages/faceBoard/audio_normal"]
            //                         forState:UIControlStateNormal];
            //            [AudioButton setImage:[UIImage imageNamed:@"/faceImages/faceBoard/audio_press"]
            //                         forState:UIControlStateHighlighted];
            /*Hi~ beck 如果键盘显示部分上有图片请去掉图片，如果有语音，请去掉语音，
             *如果输入框图片带红点，请去掉红点
             为的是再次点击恢复第一次操作样式*/
            // add your code
            //---------------------------------
            
            [_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"发表回复错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)reflashTable
{
    //[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    
    [self->_tableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UIView*)obj) resignFirstResponder];
    }];
}

/** #########add by kate UIKeyboardNotification #################### **/

- (void)keyboardWillShow:(NSNotification *)notification {
    
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         _tableView.frame = frame;
                         
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        switch (clickFlag) {
            case 1:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                
                break;
            case 2:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                if (photoFlagImageView.hidden == NO) {
                    
                    AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
                    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                                 forState:UIControlStateNormal];
                    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                                 forState:UIControlStateHighlighted];
                    
                }else{
                    AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
                    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                                 forState:UIControlStateNormal];
                    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                                 forState:UIControlStateHighlighted];
                }            }
                break;
            case 3:{
                
                audioButn.hidden = YES;
                AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
                [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                             forState:UIControlStateNormal];
                [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                             forState:UIControlStateHighlighted];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
                
            default:
                break;
        }
        
    }
    else {
        
        switch (clickFlag) {
            case 1:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
            case 2:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
                if (photoFlagImageView.hidden == NO) {
                    
                    AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
                    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                                 forState:UIControlStateNormal];
                    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                                 forState:UIControlStateHighlighted];
                    
                }else{
                    AudioButton.frame = CGRectMake(284.0 - 7, 5.0, 33.0, 33.0);
                    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
                                 forState:UIControlStateNormal];
                    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
                                 forState:UIControlStateHighlighted];
                }
                
            }
                break;
            case 3:{
                
                if(playRecordButton.hidden){
                    
                    [AudioButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                 forState:UIControlStateNormal];
                    [AudioButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                 forState:UIControlStateHighlighted];
                }
                
               
            }
                break;
                
            default:
                break;
        }
    }
    // 现在又不需要滚到最后一条了。。。
    //    if ( discussArray.count ) {
    //
    //        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:discussArray.count - 1
    //                                                                   inSection:0]
    //                               atScrollPosition:UITableViewScrollPositionBottom
    //                                       animated:NO];
    //    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
//    isReply = NO;
//    replyPid = @"";

    _replyToLabel.text = @"";
    _replyTo = @"";
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         _tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        //        if ( ![textView.inputView isEqual:faceBoard] ) {
        //
        //            isSystemBoardShow = NO;
        //
        //            textView.inputView = faceBoard;
        //
        //        }
        //        else {
        //
        //            isSystemBoardShow = YES;
        //
        //            textView.inputView = nil;
        //        }
        
        
        
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [_inputTextView.inputView isEqual:faceBoard] || [_inputTextView.inputView isEqual:addImageView] || [_inputTextView.inputView isEqual:addAudioView]) {
                    
                    isSystemBoardShow = YES;
                    _inputTextView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        _inputTextView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        _inputTextView.inputView = faceBoard;
                        
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    _inputTextView.inputView = faceBoard;
                    
                }
            }
                
                break;
            case 2:{
                
                //                if ( ![textView.inputView isEqual:addImageView] ) {
                //
                //                    isSystemBoardShow = NO;
                //                }else{
                //
                //                    isSystemBoardShow = YES;
                //
                //                    textView.inputView = nil;
                //
                //                }
                
                isSystemBoardShow = NO;
                _inputTextView.inputView = addImageView;
                
            }
                break;
            case 3:{
                
                if ( [_inputTextView.inputView isEqual:faceBoard] || [_inputTextView.inputView isEqual:addImageView] || [_inputTextView.inputView isEqual:addAudioView] ) {
                    
                    isSystemBoardShow = YES;
                    _inputTextView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    //                    if (AudioButton.imageView.image == img) {
                    if ([Utilities image:AudioButton.imageView.image equalsTo:img]) {
                        isSystemBoardShow = YES;
                        _inputTextView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        _inputTextView.inputView = addAudioView;
                        
                    }
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    _inputTextView.inputView = addAudioView;
                    
                }
            }
                
                break;
                
            default:
                break;
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSArray *childArray = [window.rootViewController childViewControllers];
        
        if ([childArray count] > 0) {
            if ([[childArray objectAtIndex:[childArray count]-1] isKindOfClass:[MJPhotoBrowser class]]) {
                
            }else{
                [_inputTextView becomeFirstResponder];
            }
        }else{
            [_inputTextView becomeFirstResponder];
        }
        
    }
}

/*图文混排的自定义Label*/
//- (OHAttributedLabel*)creatLabelArr:(NSString*)text
//{
//        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
//        [self creatAttributedLabel:text Label:label];
//        [self drawImage:label];
//        return label;
//}

- (NSString *)escapedString:(NSString *)oldString
{
    NSString *escapedString_lt = [oldString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    NSString *escapedString = [escapedString_lt stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];
    return escapedString;
}

/*Label过滤*/
- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    
    NSString *text = [self transformString:o_text];
    /*text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];*/
    MarkupParser* p = [[MarkupParser alloc] init] ;
    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
    
    NSRange allRange = [text rangeOfString:text];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:16.0]
                      range:allRange];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor]
                      range:allRange];
    
    //    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    label.backgroundColor = [UIColor clearColor];
    [label setAttString:attString withImages:p.images];
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(260, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    
    
    //    label.onlyCatchTouchesOnLinks = NO;
    //label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
    // 调用这个方法立即触发label的|drawTextInRect:|方法，
    // |setNeedsDisplay|方法有滞后，因为这个需要画面稳定后才调用|drawTextInRect:|方法
    // 这里我们创建的时候就需要调用|drawTextInRect:|方法，所以用|display|方法，这个我找了很久才发现的
}

/*画表情,将表情的imageview加到自定义label上*/
- (void)drawImage:(OHAttributedLabel *)label
{
    for (NSArray *info in label.imageInfoArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[info objectAtIndex:0] ofType:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            NSLog(@"存在");
        }else{
            NSLog(@"不存在");
        }
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
        //UIImage* image = [UIImage imageWithData:data];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectFromString([info objectAtIndex:2]);
        [label addSubview:imageView];//label内添加图片层
        [label bringSubviewToFront:imageView];
        
    }
}

- (NSString *)transformString:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

/** ################################ add by kate ################################ **/



- (IBAction)recordPlay_btnclick:(id)sender
{
    isTopCellAudioPlay = NO;
    isCellAudioPlay = NO;
    
    if(curAudio.length>0){
        
        [recordAudio handleNotification:YES];//2015.11.16
        [recordAudio play:curAudio];
    }
}

- (IBAction)recordPlayCell0_btnclick:(id)sender
{
    isTopCellAudioPlay = YES;
    isCellAudioPlay = YES;
    
    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
    if (nil != amrDocPath) {
        NSString *imagePathCell0 = [amrDocPath stringByAppendingPathComponent:@"weixiao_amrCell0.amr"];
        NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell0];
        
        if(fileData.length>0){
            [recordAudio stopPlay];
            [recordAudio play:fileData];
        }
    }
}

- (IBAction)recordDelete_btnclick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"真的要删除么？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消"
                              , nil];
    
    alertView.tag = 9;
    [alertView show];
}

-(void)RecordStatus:(int)status
{
    // 播放状态cb
    // 0-播放中 1-播放完成 2-播放错误
    if (0 == status) {
        if (isCellAudioPlay) {
            if (isTopCellAudioPlay) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
                
                [cell.animationImageViewSubject startAnimating];
                cell.playImageViewSubject.hidden = YES;
                
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                
                if (nil != curAudio) {
                    playImageView.hidden = NO;
                } else {
                    playImageView.hidden = YES;
                }
                [animationImageView stopAnimating];
            } else {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying.integerValue inSection:0];
                DiscussDetailCell *cell = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPath];
                
                // 开始点击cell的播放效果
                [cell.animationImageView startAnimating];
                cell.playImageView.hidden = YES;
                
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                
                if (nil != curAudio) {
                    playImageView.hidden = NO;
                } else {
                    playImageView.hidden = YES;
                }
                [animationImageView stopAnimating];
            }
        } else {
            for (int i=1; i<[_tableView numberOfRowsInSection:0]; i++) {
                NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
                DiscussDetailCell *cellAll = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPathAll];
                
                [cellAll.animationImageView stopAnimating];
                
                if ([@"amr"  isEqual: cellAll.ext]) {
                    cellAll.playImageView.hidden = NO;
                }
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
            
            [cell.animationImageViewSubject stopAnimating];
            cell.playImageViewSubject.hidden = NO;
            
            //            [playRecordButton setTitle:@"" forState:UIControlStateNormal];
            //            [playRecordButton setTitle:@"" forState:UIControlStateSelected];
            
            playImageView.hidden = YES;
            
            [animationImageView startAnimating];
        }
    } else if (1 == status) {
        if (isCellAudioPlay) {
            if (isTopCellAudioPlay) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
                
                [cell.animationImageViewSubject stopAnimating];
                cell.playImageViewSubject.hidden = NO;
                
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                
                if (nil != curAudio) {
                    playImageView.hidden = NO;
                } else {
                    playImageView.hidden = YES;
                }
                [animationImageView stopAnimating];
                
            } else {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying.integerValue inSection:0];
                DiscussDetailCell *cell = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPath];
                
                [cell.animationImageView stopAnimating];
                cell.playImageView.hidden = NO;
                
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                
                if (nil != curAudio) {
                    playImageView.hidden = NO;
                } else {
                    playImageView.hidden = YES;
                }
                [animationImageView stopAnimating];
                
            }
        } else {
            for (int i=1; i<[_tableView numberOfRowsInSection:0]; i++) {
                NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
                DiscussDetailCell *cellAll = (DiscussDetailCell*)[_tableView cellForRowAtIndexPath:indexPathAll];
                
                [cellAll.animationImageView stopAnimating];
                
                if ([@"amr"  isEqual: cellAll.ext]) {
                    cellAll.playImageView.hidden = NO;
                }
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            DiscussDetailTopCell *cell = (DiscussDetailTopCell*)[_tableView cellForRowAtIndexPath:indexPath];
            
            [cell.animationImageViewSubject stopAnimating];
            cell.playImageViewSubject.hidden = NO;
            
            [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
            [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
            
            playImageView.hidden = NO;
            [animationImageView stopAnimating];
        }
    } else if (2 == status) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"播放失败，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (void)timeFireMethod
{
    secondsCountDown--;
    
    if(secondsCountDown==0){
        NSURL *url = [recordAudio stopRecord];
        isRecording = NO;
        
        if (url != nil) {
            curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
            if (curAudio) {
                NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                if (nil != amrDocPath) {
                    amrPath = [amrDocPath stringByAppendingPathComponent:@"weixiao_amr.amr"];
                    [curAudio writeToFile: amrPath atomically: NO];
                    
                    endRecordTime = [NSDate timeIntervalSinceReferenceDate];
                    endRecordTime -= startRecordTime;
                    
                    recordSec = endRecordTime;
                    
                    [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                    [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                    playRecordButton.hidden = NO;
                    
                    deleteRecordButton.hidden = NO;
                    playImageView.hidden = NO;
                    
                    
                    //---------录制到60秒 自定义输入框的键盘变成发表 2015.11.13------------------------------------------
                        
                        AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
                        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
                        [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
                        
                    //-----------------------------------------------------------------------------------------------
                    
                    
                }
            }
        }
        [countDownTimer invalidate];
    }
}

// 修改从UIImagePickerController 返回后statusbar消失问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

- (IBAction)photo_btnclick:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        UIImage *scaledImage;
        UIImage *updateImage;
        
        // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
        if (image.size.width >= 480) {
            float scaleRate = 480/image.size.width;
            
            float w = 480;
            float h = image.size.height * scaleRate;
            
            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
        }
        
        if (scaledImage != Nil) {
            updateImage = scaledImage;
        } else {
            updateImage = image;
        }
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //保存图片的路径
        [photoSelectButton setBackgroundImage:updateImage forState:UIControlStateNormal] ;
        [photoSelectButton setBackgroundImage:updateImage forState:UIControlStateHighlighted];
        isSelectPhoto = YES;
        self->imagePath = [imageDocPath stringByAppendingPathComponent:@"image.jpg"];
        
        //---add 2015.11.03--------------------------------------------------------
        UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
        image = [Utilities fixOrientation:tempImage];//相机拍的照直接发送在安卓上是倒置的，修正
        //----------------------------------------------------------------------------
        
        //以下是保存文件到沙盒路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        //        data = UIImagePNGRepresentation(image);
        //        if (data) {
        //            //返回为png图像。
        //            data = UIImagePNGRepresentation(image);
        //        }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 0.3);
        //        }
        
        //保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath contents:data attributes:nil];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    
    //选完图片将右侧语音按钮换成发送按钮
    AudioButton.frame = CGRectMake(284.0 - 12, 5.0, 47.0, 33.0);
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
    
    [_inputTextView becomeFirstResponder];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (9 == alertView.tag) {
            // 是否删除语音
            [recordAudio stopPlay];
            [animationImageView stopAnimating];
            
            playRecordButton.hidden = YES;
            deleteRecordButton.hidden = YES;
            playImageView.hidden = YES;
            
            // beck 删除语音后请将右侧发送按钮换成键盘图片
            // add your code update by kate
            AudioButton.frame = CGRectMake(284.0 - 7 , 5.0, 33.0, 33.0);
            [AudioButton setImage:[UIImage imageNamed:@"btn_sr_d.png"] forState:UIControlStateNormal];
            [AudioButton setImage:[UIImage imageNamed:@"btn_sr_p.png"] forState:UIControlStateHighlighted];
            
            curAudio=nil;
        } else if (8 == alertView.tag) {
            // 是否删除图片
            isSelectPhoto = NO;
            photoFlagImageView.hidden = YES;
            photoDeleteButton.hidden = YES;
            
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            
            // beck 删除图片后请将右侧发送按钮换成键盘图片
            // add your code update by kate
            AudioButton.frame = CGRectMake(284.0 - 7 , 5.0, 33.0, 33.0);
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
            [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
        }else if (333 == alertView.tag){
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //----add by kate 2015.03.23---------------------------------------------
        
        /*
         HttpReq_SchoolThreadCommentDelete,      // 讨论区详情评论删除
         HttpReq_ClassThreadCommentDelete,       // 班级公告详情评论删除
         HttpReq_HomeworkCommentDelete,          // 班级作业详情评论删除
         HttpReq_ClassForumCommentDelete,        // 班级风采/讨论区详情评论删除
         */
        [Utilities showProcessingHud:self.view];
        
        if (alertView.tag == 305) {
            if (buttonIndex == 1) {//讨论区（班级公告、班级讨论区、作业）删除本人的回复内容
                if (flag == 1) {//讨论区
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"SchoolThread",@"ac",
                                          @"deletePost", @"op",
                                          pid, @"pid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_SchoolThreadCommentDelete andData:data];
                    
                }else if (flag == 2){//班级公告
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassThread",@"ac",
                                          @"deletePost", @"op",
                                          pid, @"pid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ClassThreadCommentDelete andData:data];
                    
                }else if (flag == 4){//班级风采/班级讨论区
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"ClassForumThread",@"ac",
                                          @"deletePost", @"op",
                                          pid, @"pid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ClassForumCommentDelete andData:data];
                    
                    
                }else{//班级作业
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Homework",@"ac",
                                          @"deletePost", @"op",
                                          pid, @"pid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_HomeworkCommentDelete andData:data];
                    
                }
            }
        }
        //-------------------------------------------------------------------------
    }
}

//-----add by kate 获取webView中图片 点击查看大图-------------------------------

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self.showWebView addGestureRecognizer:singleTap];
    [shopWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
   
    [_inputTextView resignFirstResponder];// 键盘下落 避免点击大图键盘遮挡
    
   
    isReply = NO;
    replyPid = @"";
    
    _replyToLabel.text = @"";
    _replyTo = @"";

    
    //CGPoint pt = [sender locationInView:self.showWebView];
    CGPoint pt = [sender locationInView:shopWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *fileURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", pt.x, pt.y];
    
    NSString *imgUrlToSave = [shopWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSString *fileUrlToSave = [shopWebView stringByEvaluatingJavaScriptFromString:fileURL];
    
    //    NSURL *aaaurl=[NSURL URLWithString:fileUrlToSave];
    
    //NSLog(@"image url=%@", urlToSave);
    if (imgUrlToSave.length > 0) {
        
        if([imgUrlToSave rangeOfString:@"face"].location == NSNotFound )//非表情图片
        {
            //[self showImageURL:urlToSave point:pt];
            NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:imgUrlToSave];
            
            //            NSString *imgUrl = imgUrlToSave;
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor clearColor];
            if(IS_IPHONE_5){
                imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
            }else{
                imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
            }
            
            if (-1 != pos) {
                
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                // 弹出相册时显示的第一张图片是点击的图片
                browser.currentPhotoIndex = pos;
                // 设置所有的图片。photos是一个包含所有图片的数组。
                
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_pics count]];
                
                for (int i = 0; i<[_pics count]; i++) {
                    // 拼字符串，去服务器获取原图
                    NSString *pic_url = [_pics objectAtIndex:i];
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.save = NO;
                    photo.url = [NSURL URLWithString:pic_url]; // 图片路径
                    photo.srcImageView = imageView; // 来源于哪个UIImageView
                    [photos addObject:photo];
                }
                
                // 1.封装图片数据
                //设置所有的图片。photos是一个包含所有图片的数组。
                //            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                //            NSMutableArray *photos = [NSMutableArray arrayWithArray:_pics];
                
                //            MJPhoto *photo = [[MJPhoto alloc] init];
                //            photo.save = NO;
                //            photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
                //            photo.srcImageView = imageView; // 来源于哪个UIImageView
                //            [photos addObject:photo];
                
                browser.photos = photos;
                [browser show];
                
            }
            
            
            // 2.显示相册
            //            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            //            browser.currentPhotoIndex = pos; // 弹出相册时显示的第一张图片是？
            //            browser.photos = photos; // 设置所有的图片
            //            [browser show];
        }
    }else if (fileUrlToSave.length > 0){
        //        FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
        //        fileViewer.requestURL = aaaurl;
        //        fileViewer.titlea = @"内容";
        //        [self.navigationController pushViewController:fileViewer animated:YES];
    }
}

//呈现图片
-(void)showImageURL:(NSString *)url point:(CGPoint)point
{
    
    /*self.view.backgroundColor = [UIColor clearColor];
     
     UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,568)];
     showView.contentMode = UIViewContentModeScaleAspectFit;
     
     if (!IS_IPHONE_5) {
     
     showView.frame = CGRectMake(0, 0, 320, 480);
     }
     
     //    showView.center = point;
     //    [UIView animateWithDuration:0.5f animations:^{
     //        CGPoint newPoint = self.view.center;
     //        newPoint.y += 20;
     //        showView.center = newPoint;
     //    }];
     
     showView.backgroundColor = [UIColor blackColor];
     //showView.alpha = 0.9;
     showView.userInteractionEnabled = YES;
     [self.view addSubview:showView];
     
     [showView setImageWithURL:[NSURL URLWithString:url]];
     
     self.picImage = showView.image;
     
     if (showView.image == nil) {
     NSLog(@"0");
     }else{
     NSLog(@"1");
     }
     
     self.picImage = showView.image;
     
     
     UIButton *saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     saveImageBtn.frame = CGRectMake(267.0,showView.frame.size.height - 38, 33.0, 33.0);
     [saveImageBtn setImage:[UIImage imageNamed:@"icon_account_save1"]
     forState:UIControlStateNormal];
     [saveImageBtn addTarget:self action:@selector(saveImageToPhoto:) forControlEvents:UIControlEventTouchUpInside];
     [showView addSubview:saveImageBtn];
     
     
     UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
     [showView addGestureRecognizer:singleTap];
     
     [self.navigationController setNavigationBarHidden:YES animated:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];*/
    
    [_inputTextView resignFirstResponder];// 键盘下落 避免点击大图键盘遮挡

    NSString *imgUrl = url;
    /* MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
     // 弹出相册时显示的第一张图片是点击的图片
     browser.currentPhotoIndex = 0;
     // 设置所有的图片。photos是一个包含所有图片的数组。
     
     //NSArray *photo1 = [[NSArray alloc] initWithObjects:imgUrl,nil];;
     NSMutableArray *photos = [[NSMutableArray alloc] init];
     
     MJPhoto *photo = [[MJPhoto alloc] init];
     photo.save = NO;
     photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
     [photos addObject:photo];
     browser.photos = photos;
     [browser show];*/
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    }
    // 1.封装图片数据
    //设置所有的图片。photos是一个包含所有图片的数组。
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.save = NO;
    photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
    photo.srcImageView = imageView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    
    
}


//移除图片查看视图
-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

//图片保存到相册
- (void)saveImageToPhoto:(id)sender
{
    
    UIImageWriteToSavedPhotosAlbum(self.picImage, self, @selector(imageSave:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self.view makeToast:@"保存图片失败，请稍后再试" duration:1.5 position:@"center" image:nil];
    } else {
        if (image == nil) {
            [self.view makeToast:@"保存图片失败，请稍后再试" duration:1.5 position:@"center" image:nil];
        }else{
            [self.view makeToast:@"图片已保存到相册" duration:1.5 position:@"center" image:nil];
        }
    }
}

//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//    return NO;
//}
//---------------------------------------------------------------------------
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		return NO;
//	}
//	return YES;
//}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    
    NSString *urlStr = [requestURL resourceSpecifier];
    NSArray *arrayDot = [urlStr componentsSeparatedByString:@"."];
    NSString *type = [arrayDot objectAtIndex:[arrayDot count]-1];
    
    //    NSString *scheme = [requestURL scheme];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        if (([@"rar"  isEqual: type]) ||
            ([@"zip"  isEqual: type]))
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"不支持此格式，无法打开。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else if (([@"txt"  isEqual: type]) ||
                  ([@"doc"  isEqual: type]) ||
                  ([@"docx"  isEqual: type]) ||
                  ([@"xls"  isEqual: type]) ||
                  ([@"xlsx"  isEqual: type]) ||
                  ([@"pptx"  isEqual: type]) ||
                  ([@"ppt"  isEqual: type]) ||
                  ([@"pdf"  isEqual: type]) ||
                  ([@"png"  isEqual: type]) ||
                  ([@"jpg"  isEqual: type]) ||
                  ([@"gif"  isEqual: type])) {
#if 0
            // 为了使iOS 7以及以下可以在app内部打开文件，这里再做个判断
            FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
            fileViewer.requestURL = requestURL;
            fileViewer.titlea = @"内容";
#endif
            // 2015.09.23
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            fileViewer.webType = SWFile;
            fileViewer.url = requestURL;
            fileViewer.titleName = @"内容";
            [self.navigationController pushViewController:fileViewer animated:YES];
            
        }else {
            // 网页的话，iOS 8以上就可以内部打开，以下去safari
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"message";
                fileViewer.url = requestURL;
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadURl;
                fileViewer.url = requestURL;
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }else {
                [[UIApplication sharedApplication] openURL:requestURL];
            }
        }
        
        return NO;
    }else {
        return YES;
    }
}

@end

//
//  SubmitViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-13.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SubmitViewController.h"
#import "MicroSchoolAppDelegate.h"

#import "CTAssetsPickerController.h"// add by kate 2014.10.08


@interface SubmitViewController ()<CTAssetsPickerControllerDelegate,UIPopoverControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIPopoverController *popover;
@end

@implementation SubmitViewController
@synthesize flag;

// audio
static double startRecordTime = 0;
static double endRecordTime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[super setCustomizeTitle:@"发表新话题"];
        [super setCustomizeLeftButton];

        network = [NetworkUtility alloc];
        network.delegate = self;

        imageArray = [[NSMutableDictionary alloc] init];
        buttonArray = [[NSMutableArray alloc] init];
        buttonFlagViewArray = [[NSMutableArray alloc] init];

        amrPath = @"";

        // 导航右菜单，提交
        /*UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundColor:[UIColor clearColor]];
        rightButton.frame = CGRectMake(280, 0, 40, 40);
        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;*/
    }
    return self;
}

- (void)loadView
{
    if (flag == 2) {
        [super setCustomizeTitle:@"发表班级公告"];
    }else{
        [super setCustomizeTitle:@"发表新话题"];
    }
    
    [super setCustomizeTitle:@"编辑"];
    [self setCustomizeRightButtonWithName:@"发布"];
    
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    //    UIImageView *imgView_bg_down =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[Utilities getScreenSize].width,[UIScreen mainScreen].applicationFrame.size.height -44)];
    //    [imgView_bg_down setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //    [self.view addSubview:imgView_bg_down];
    
    //--------add by kate 2014.09.26------------------------------
    CGRect rect;
    // 设置背景scrollView
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        rect = CGRectMake(0, 0, [Utilities getScreenSize].width , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        rect = CGRectMake(0, 0, [Utilities getScreenSize].width , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
#if 0
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
#endif
    
    _scrollerView = [UIScrollView new];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollerView];
    
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为0
        make.top.equalTo(self.view.mas_top).with.offset(0);
        
        // 距离屏幕左边距为20
        make.left.equalTo(self.view.mas_left).with.offset(0);
        
        //make.bottom.equalTo(self.view).with.offset(0);
        
        //make.right.equalTo(self.view.mas_right).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, [Utilities getScreenSize].height - 64));
    }];
    
    _viewWhiteBg = [UIView new];
    _viewWhiteBg.backgroundColor = [UIColor whiteColor];
    [_scrollerView addSubview:_viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(_scrollViewBg);
        make.edges.equalTo(_scrollerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
        make.width.equalTo(_scrollerView);
    }];
    
    //--------------------------------------
    
    UIColor *color =[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    text_title = [UITextField new];
    text_title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题(必填)" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    text_title.font = [UIFont systemFontOfSize:16.0];
    text_title.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    text_title.clearButtonMode = UITextFieldViewModeAlways;
    text_title.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    //text_title.backgroundColor = [UIColor redColor];
    //    [text_title becomeFirstResponder];
    [_scrollerView addSubview:text_title];
    
    [text_title mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(_viewWhiteBg.mas_top).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(_viewWhiteBg.mas_left).with.offset(12);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 34));
    }];
    //[self.view addSubview:text_title];
    [text_title becomeFirstResponder];
    
    imgView_line = [UIImageView new];
    imgView_line.image = [UIImage imageNamed:@"lineSystem.png"];
    [_scrollerView addSubview:imgView_line];
    
    [imgView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.bottom.equalTo(text_title.mas_bottom).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(text_title).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 0.5));
    }];
    
    //初始化
#if 0
    if (IS_IPHONE_4) {
        
        contentHeight = 90.0;
        
    }else{
        contentHeight = 120+70;
        
    }
#endif
    
    contentHeight = [Utilities getScreenSizeWithoutBar].height - 44.0 - keyboardHeight;
    
    //text_content = [[UITextView alloc] initWithFrame:CGRectMake(8, imgView_line.frame.origin.y+0.5+6.0, [UIScreen mainScreen].bounds.size.width-16.0, contentHeight)];
    text_content = [UITextView new];;
    
    text_content.backgroundColor = [UIColor clearColor];
    text_content.text = @"内容";
    text_content.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    // 如果用masonry写的话 此处设置为NO 键盘弹起时 它后边的scrollview才会自动上移
    text_content.scrollEnabled = NO;
    text_content.userInteractionEnabled = YES;
    
    //获得焦点
    //[text_content becomeFirstResponder];
    
    //    UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    touchButton.frame = CGRectMake(0, 0, 300, 120);
    //    touchButton.backgroundColor = [UIColor clearColor];
    //    [touchButton addTarget:self action:@selector(clickTextView:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [text_content addSubview:touchButton];
    //text_content.returnKeyType = UIReturnKeyDone;
    //[self.view addSubview:text_content];
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
    singleTouch.numberOfTapsRequired = 1;
    singleTouch.delegate = self;
    //    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[text_content gestureRecognizers]];
    //    for (int i = 0; i < [arr count]; i++) {
    //        if ([[arr objectAtIndex:i] isKindOfClass:[UITapGestureRecognizer class] ]) {
    //            [arr removeObject:[arr objectAtIndex:i]];
    //        }
    //    }
    [text_content addGestureRecognizer:singleTouch];
    
    [_scrollerView addSubview:text_content];
    //[_viewWhiteBg addSubview:text_content];
    
    [text_content mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(imgView_line).with.offset(6.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(imgView_line).with.offset(-4.0);
        
        //make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 30));
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, contentHeight));
        
        
    }];
    
    
    
    //    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(text_content.mas_bottom);
    //    }];
    
    //textview的scrollEnabled属性 结合这句话 才能实现 键盘弹起 打字打到键盘上方时候 scrollview自动上移
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(text_content.mas_bottom).with.offset(0);
    }];
    
    //_scrollerView.contentSize = CGSizeMake([Utilities getScreenSize].width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, [Utilities getScreenSize].width, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    //keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);//调整顺序
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_un.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_un.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //addImageButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);
    addImageButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    addImageButton.tag = 123;
    [addImageButton setImage:[UIImage imageNamed:@"icon_send_pic_un.png"]
                    forState:UIControlStateNormal];
    [addImageButton setImage:[UIImage imageNamed:@"icon_send_pic_un.png"]
                    forState:UIControlStateHighlighted];
    [addImageButton addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:addImageButton];
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(75, 5.0, 33.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    
    // 选择图片后的红点啊
    photoFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                      addImageButton.frame.origin.x + addImageButton.frame.size.width -10,
                                                                      addImageButton.frame.origin.y - 5,
                                                                      14,
                                                                      14)];
    photoFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
    photoFlagImageView.hidden = YES;
    [toolBar addSubview:photoFlagImageView];
    
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
    [toolBar addSubview:photoNumLabel];
    
    //语音上的红点
    audioFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                      AudioButton.frame.origin.x + AudioButton.frame.size.width -10,
                                                                      AudioButton.frame.origin.y - 5,
                                                                      14,
                                                                      14)];
    audioFlagImageView.image = [UIImage imageNamed:@"icon_notice"];
    audioFlagImageView.hidden = YES;
    [toolBar addSubview:audioFlagImageView];
    [self.view addSubview:toolBar];
    
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
    [toolBar addSubview:audioNumLabel];

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
    //--------------------------------audio end------------
}

-(void)selectRightAction:(id)sender{
    
    [self submitAction:sender];
}

// 点击评
-(void)commentClick:(id)sender{
    
    //默认禁止评论
    UIImage *image = [UIImage imageNamed:@"btn_comment_d.png"];
    if ([Utilities image:commentBtn.imageView.image equalsTo:image]){
         [commentBtn setImage:[UIImage imageNamed:@"btn_comment_p.png"] forState:UIControlStateNormal];
    }else{
         [commentBtn setImage:[UIImage imageNamed:@"btn_comment_d.png"] forState:UIControlStateNormal];
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

-(void)faceBoardClick:(id)sender{
    
//    CGRect frame;
//    
//    if (IS_IPHONE_5) {
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 120)];
//        
//       frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 120);
//        
//    }else{
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 60)];
//        
//      frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 60);
//    }
//
//    text_content.frame = frame;
    
    
    clickFlag = 1;
    audioButn.hidden = YES;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [text_content resignFirstResponder];
        
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
           
            text_content.inputView = faceBoard;
        }
        
        [text_content becomeFirstResponder];
    }
    
}

-(void)ImageClick:(id)sender{
    
//    CGRect frame;
//    
//    if (IS_IPHONE_5) {
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 120)];
//        
//        frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 120*2);
//        
//    }else{
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 60)];
//        
//        frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 60*3+30);
//    }
//    
//    text_content.frame = frame;
//
    
    if (text_content.inputView == addImageView) {
        return;
    }
    
    // add 2015.07.08
    // 键盘高度 文字：252 表情：216 图片：140 语音：80
    text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight +(252.0-140.0));
    
    clickFlag = 2;
    audioButn.hidden = YES;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [text_content resignFirstResponder];
    }else{
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            text_content.inputView = addImageView;
        }
        
        [text_content becomeFirstResponder];
    }
}

-(void)AudioClick:(id)sender{
    
//    CGRect frame;
//    
//    if (IS_IPHONE_5) {
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 120)];
//        
//        frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 120*2);
//        
//    }else{
//        
//        //text_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 60)];
//        
//        frame = CGRectMake( text_content.frame.origin.x,  text_content.frame.origin.y,  text_content.frame.size.width, 60*3+30);
//    }
//    
//    text_content.frame = frame;
    

    
    if (text_content.inputView == addAudioView) {
        return;
    }
    
        clickFlag = 3;
    
    if (nil != curAudio) {
        audioButn.hidden = YES;
    } else {
        audioButn.hidden = NO;
    }

    
        isButtonClicked = YES;
        
        if ( isKeyboardShowing ) {
            
            [text_content resignFirstResponder];
        }
        else {
            
            if ( isFirstShowKeyboard ) {
                
                isFirstShowKeyboard = NO;
                
                isSystemBoardShow = NO;
            }
            
            if ( !isSystemBoardShow ) {
                
                text_content.inputView = addAudioView;
            }
            
            [text_content becomeFirstResponder];
        }
}

-(void)clickTextView:(id)sender{
    
    if (text_content.inputView!=nil) {
        isButtonClicked = YES;
        text_content.inputView = nil;
        isSystemBoardShow = YES;
        clickFlag = 0;
        [text_content resignFirstResponder];
    }else{
        [text_content becomeFirstResponder];
    }
}

/*
 *Hi~ beck 点击加号图片方法
 *每次只能带一张图片，只能从相册选择，
 *选择回来输入框下落，输入框图片图标右上角有红点标记
 *点击图片可以删除，删除后红点标记消失
 *见效果图
 */
-(void)create_btnclick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    pressButtonTag = button.tag;
   
    UIImage *img = [UIImage imageNamed:@"icon_add_photo_p.png"];
    
    if (![Utilities image:button.imageView.image equalsTo:img]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"要删除图片么？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消"
                                  , nil];
        
        alertView.tag = 8;
        [alertView show];
    } else {
        
        //-----add by kate 2014.10.08--------------------------------------------------------------
        /*UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];*/
        
       /* if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 9 - [self.assets count];
        //picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        
        NSLog(@"assetsCount:%d",[self.assets count]);
        
        [self presentViewController:picker animated:YES completion:NULL];*/
        //----------------------------------------------------------------
            //---update by kate 2014.11.6
            if (!self.assets)
                self.assets = [[NSMutableArray alloc] init];
            
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.assetsFilter         = [ALAssetsFilter allPhotos];
            picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
            picker.delegate             = self;
            picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
            
            // iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popover.delegate = self;
                
                [self.popover presentPopoverFromBarButtonItem:sender
                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                     animated:YES];
            }
            else
            {
                [self presentViewController:picker animated:YES completion:nil];
            }
        
        //}
        
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
        
        curAudio=nil;
    }
}


/*
 *Hi~ beck 松开手录音结束
 * addAudioView 对这个view进行add，出现录音结束的条形图片，且可以删除
 * 录音结束后，语音图标加红点
 * 删除后语音图标红点消失
 * 见效果图
 */
-(void)recordEnd:(id)sender{
    if (isRecording) {
        [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
        [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];

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
                        
                        [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
                        [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
                        
                        audioButn.hidden = YES;
                        playRecordButton.hidden = NO;
                        
                        deleteRecordButton.hidden = NO;
                        playImageView.hidden = NO;
                        
                        //---Hi~ beck 录音结束后，语音图片上加红点标记,语音删除后，红点标记消失
                        // add your code update by kate
                        audioFlagImageView.hidden = NO;
                        audioNumLabel.hidden = NO;
                        //-----------------------------------------------------------
                    }
                }
            }
        }
        
        if (curAudio.length >0) {
            
        } else {
            
        }
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
                }
            }
        }
        [countDownTimer invalidate];
	}
}

- (void)recordDelete_btnclick:(id)sender
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

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    /*//当图片不为空时显示图片并保存图片
    if (image != nil) {
        UIImage *scaledImage;
        UIImage *updateImage;
        
        CGSize imageSize = image.size;
        
        // 如果宽度超过720，则按照比例进行缩放，把宽度固定在720
        if (image.size.width >= 720) {
            float scaleRate = 720/image.size.width;
            
            float w = 720;
            float h = image.size.height * scaleRate;
            
            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
        }
        
        if (scaledImage != Nil) {
            updateImage = scaledImage;
        } else {
            updateImage = image;
        }
        
        CGSize imageSize1 = updateImage.size;
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // 为当前点击的button设置用户选择的图片
        [[buttonArray objectAtIndex:pressButtonTag-1] setImage:updateImage forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:pressButtonTag-1] setImage:updateImage forState:UIControlStateHighlighted];
        
        UIImageView *photoImageView = [[UIImageView alloc]init];
        photoImageView.image = [UIImage imageNamed:@"icon_notice"];
        [buttonFlagViewArray addObject:photoImageView];

//        if (9 != [buttonArray count]) {
            // 设置下一个button，并插入到array中
            UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            
            [buttonArray addObject:button_photoMask];
//        }
        
        [self showButtonArray];
    }
    
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    
    [text_content becomeFirstResponder];*/
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

            audioButn.hidden = NO; //add by kate
            audioFlagImageView.hidden = YES;
            audioNumLabel.hidden = YES;

            curAudio=nil;
        } else if (8 == alertView.tag) {
            // 是否删除图片
            for (int i=pressButtonTag; i<[buttonArray count]; i++) {
                // 把点击的button之后的每个button的图片设置为这个button后面button的图片 草
                [(UIButton*)[buttonArray objectAtIndex:i-1] setImage:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image forState:UIControlStateNormal] ;
                [(UIButton*)[buttonArray objectAtIndex:i-1] setImage:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image forState:UIControlStateHighlighted] ;
            }
            
            // 把最后面的一个button从父view中移除
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] removeFromSuperview];
            NSLog(@"viewWithTag:%d",pressButtonTag);
            UIButton *button = (UIButton*)[addImageView viewWithTag:pressButtonTag];
            NSLog(@"lastTag:%d",button.tag);
            if (button) {
                NSLog(@"Y");
            }else{
                NSLog(@"N");
            }
            [button removeFromSuperview];
            // 移除array最后的button
            [buttonArray removeLastObject];
            
        
//            NSInteger lastObj = [buttonFlagViewArray count]-1;
//            [[buttonFlagViewArray objectAtIndex:lastObj] removeFromSuperview];
            for (int i=0; i<[buttonFlagViewArray count]; i++) {
                [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
            }
            
            // 当有第九张图片的时候，需要再多remove出去一个
//            if (9 == [buttonFlagViewArray count]) {
//                [buttonFlagViewArray removeLastObject];
//            }

            [buttonFlagViewArray removeLastObject];

             NSLog(@"delete count:%d",[buttonArray count]);
            
            // 设置显示加号的button的图片
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;

            //-----update by kate 2014.10.09-------------
            // 重新按顺序显示array中所有button
            
            [self showImageButtonArray];
            if ([buttonArray count] == 1) {
                [self.assets removeAllObjects];
            }else{
               
                [self.assets removeObjectAtIndex:pressButtonTag-1];
            }
            
           
            
//            if ([buttonFlagViewArray count] > 0) {
//                photoFlagImageView.hidden = NO;
//                photoNumLabel.hidden = NO;
//                photoNumLabel.text = [NSString stringWithFormat:@"%d", [buttonFlagViewArray count]];
//            }
//
//            if (0 == [buttonFlagViewArray count]) {
//                photoFlagImageView.hidden = YES;
//                photoNumLabel.hidden = YES;
//            }
             //----------------------------------------------------------------------------------

            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
            

        }else{
        
            /*(＞﹏＜) 经过无数次的尝试,发现在iOS8.0以上，popView方法的animated参数要传NO才不会有键盘划过现象
             Bug 1359 update by kate 2015.07.04
             */
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
                [self.navigationController popViewControllerAnimated:NO];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
           
        }
    }
    else {
        // nothing
    }
}

//---add by kate 2015.07.04 还是不好用--------------------------------
/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
     [self.view endEditing:YES];
     [text_title resignFirstResponder];
     [text_content resignFirstResponder];
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
//-----------------------------------------------------------

-(void)submitAction:(id)sender
{
    // 防止多次快速提交
    self.navigationItem.rightBarButtonItem.enabled = NO;
 
    if ([text_content isFirstResponder]) {
        NSLog(@"content");
    }else if ([text_title isFirstResponder]){
        NSLog(@"title");
    }
    [text_content resignFirstResponder];
    [text_title resignFirstResponder];
    [self.view endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    //if(text_title.text.length <= 2)
    if(text_title.text.length < 1)
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                       message:@"标题不能为空，请重新输入"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"请输入标题"
                    duration:0.5
                    position:@"center"
                       title:nil];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    //else if((text_content.text.length <= 2) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
    else if((text_content.text.length < 1) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                       message:@"内容不能为空，请重新输入"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"请输入内容文字或添加图片、语音。"
                    duration:0.5
                    position:@"center"
                       title:nil];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }else if(([@"内容" isEqual:text_content.text]) && (text_content.textColor == [UIColor lightGrayColor]) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES) )
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                       message:@"内容不能为空，请重新输入"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"请输入内容文字或添加图片、语音。"
                    duration:0.5
                    position:@"center"
                       title:nil];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        [self hideKeyBoard];
        
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *detailDic = [g_userInfo getUserDetailInfo];
        NSString *cid = nil;
        
        NSString *usertype = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"role_id"]];
        
        if([@"7"  isEqual: usertype] || [@"9"  isEqual: usertype] || [@"2"  isEqual: usertype])
        {
            cid = [g_userInfo getUserCid];
            if (nil == cid) {
                cid = @"0";
            }
        }
        else
        {
            //update by kate 2015.05.21 教育局专版
            NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
            if ([@"bureau" isEqualToString:schoolType]){
               
                cid = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"role_cid"]];
                if (cid == nil || [cid length] == 0) {
                     cid = @"0";
                }
                
            }else{
                 cid = [detailDic objectForKey:@"role_cid"];
            }
           
        }
        
        switch (flag) {
            case 1:{
                
                UIColor *color = [UIColor lightGrayColor];
                if (text_content.textColor == color) {
                    text_content.text= @"";
                }
                
                [self saveButtonImageToFile];

                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"SchoolThread", @"ac",
                                      @"post", @"op",
                                      cid, @"cid",
                                      text_title.text, @"subject",
                                      text_content.text, @"message",
                                      amrPath, @"amr0",
                                      imageArray, @"imageArray",
                                      nil];

                [network sendHttpReq:HttpReq_ThreadSubmit andData:data];
            }
                break;
            case 2:{
                
                UIColor *color = [UIColor lightGrayColor];
                if (text_content.textColor == color) {
                    text_content.text= @"";
                }
                
                [self saveButtonImageToFile];

                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"ClassThread",@"ac",
                                      @"post", @"op",
                                      _cid,@"cid",
                                      text_title.text, @"subject",
                                      text_content.text, @"message",
                                      amrPath, @"amr0",
                                      imageArray, @"imageArray",
                                      nil];
                
                [network sendHttpReq:HttpReq_ThreadSubmit andData:data];
            }
                break;
                
            case 3:{
                
                // ac=ClassForumThread&v=1 op=post&sid=&cid=&uid=&subject=&message=
                
                UIColor *color = [UIColor lightGrayColor];
                if (text_content.textColor == color) {
                    text_content.text= @"";
                }
                
                [self saveButtonImageToFile];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"ClassForumThread",@"ac",
                                      @"1",@"v",
                                      @"post", @"op",
                                      _cid,@"cid",
                                      text_title.text, @"subject",
                                      text_content.text, @"message",
                                      amrPath, @"amr0",
                                      imageArray, @"imageArray",
                                      nil];
                
                [network sendHttpReq:HttpReq_ClassThreadSubmit andData:data];
            }
                break;
            default:
                break;
        }
    }
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ( !faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 10000;// 2015.07.21
        faceBoard.inputTextView = text_content;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //注册通知,监听键盘弹出事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    //注册通知,监听键盘消失事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

/** #########add by kate UIKeyboardNotification #################### **/

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
//        if (range.length > 1 ) {
//            
//            return YES;
//        }
//        else {
//            
//            [faceBoard backFace];
//            
//            return NO;
//        }
        return YES;//update by kate 2015.01.26 解决光标定在中间删除不了的问题，但是这样表情就不能按一次退格键删除,修改backFace方法还是不能二者兼得。
    }
    else {
        
        if (range.location >= 10000) {// 校园讨论区/班级公告/班级风采发帖 10000 2015.07.21
            return NO;
        }
        
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // update by kate 2014.09.26
//    if (IS_IPHONE_5) {
//         textView.frame = CGRectMake(10,70,300.0,120);
//    }else {
//      textView.frame = CGRectMake(10,70,300.0,60);
//    }
    
    NSLog(@"");
    
}

//-----------------------------------------------------

- (void)keyboardWillShow:(NSNotification *)notification {
   
    textViewDisplay.hidden = YES;
    toolBar.hidden = NO;
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         
//                         CGRect frame = toolBar.frame;
//                         frame.origin.y += keyboardHeight;
//                         frame.origin.y -= keyboardRect.size.height;
//                         toolBar.frame = frame;
//                         
//                         keyboardHeight = keyboardRect.size.height;
                         
                         CGRect containerFrame = toolBar.frame;
                         containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
                         
                         // 调整输入栏的位置
                         toolBar.frame = containerFrame;
                         
                     }];
    
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight-toolBar.frame.size.height - 5.0);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
    
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        switch (clickFlag) {
            case 1:{
                
                UIImage *image = [UIImage imageNamed:@"btn_bq_un.png"];
                if ([Utilities image:keyboardButton.imageView.image equalsTo:image]) {
                    
                }else{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
                }
                
            }
                
                break;
            case 2:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                break;
            case 3:{
                
              
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
                
                UIImage *image = [UIImage imageNamed:@"btn_sr_un.png"];
                if ([Utilities image:keyboardButton.imageView.image equalsTo:image]) {
                    
                }else{
                
                 [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                forState:UIControlStateNormal];
                 [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                forState:UIControlStateHighlighted];
                }
            }
                break;
            case 2:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                break;
            case 3:{
                
                           }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    toolBar.hidden = YES;
    
#if 0
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                        
                         CGRect frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
#endif
    
    NSDictionary *userInfo = [notification userInfo];
    //    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];

    
}

#if 0
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //[self moveView:-60];
    
    CGRect scRect = _scrollerView.frame;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        if (iPhone5) {
            scRect.size.height = scRect.size.height + 90 ;
        } else {
            scRect.size.height = scRect.size.height + 170;
        }
    }
    else
    {
        scRect.size.height = scRect.size.height + 170;
    }
    
    scRect.origin.y = 0;
    
    //[_scrollerView setFrame:scRect];
    _scrollerView.contentSize = scRect.size;
    //_scrollerView.contentOffset = CGPointMake(0, 90 );
    
    
    
    
    float fHeight = [self heightForTextView:text_content WithText:text_content.text];
    
    CGRect g = text_content.frame;
    g.size.height = fHeight;
    
    
    
}


//键盘消失时
-(void)keyboardDidHidden
{
    CGRect scRect = _scrollerView.frame;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        if (iPhone5) {
            scRect.size.height = scRect.size.height - 80;
        } else {
            scRect.size.height = scRect.size.height - 170;
        }
        
        scRect.size.height = scRect.size.height - 30;
    }
    else
    {
        scRect.size.height = scRect.size.height - 170;
    }
    scRect.origin.y = 0;
    
    //[_scrollerView setFrame:scRect];
    _scrollerView.contentSize = scRect.size;
    
    //_scrollerView.contentSize = CGSizeMake(320, imgView_bg_photo.frame.origin.y + imgView_bg_photo.frame.size.height);
}
#endif


- (void)keyboardDidHide:(NSNotification *)notification {
    
    
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [text_content.inputView isEqual:faceBoard] || [text_content.inputView isEqual:addImageView] || [text_content.inputView isEqual:addAudioView]) {
                    
                    isSystemBoardShow = YES;
                    text_content.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
//                    if (keyboardButton.imageView.image == img) {
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {

                        isSystemBoardShow = YES;
                        text_content.inputView = nil;
                        
                        // add 2015.07.08
                        text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight);
                            
                        
                        
                    }else{
                        isSystemBoardShow = NO;
                        text_content.inputView = faceBoard;
                        // 键盘高度 文字：252 表情：216 图片：140 语音：80
                        text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight +(252.0-216.0));
                        text_content.inputView = faceBoard;
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    text_content.inputView = faceBoard;
                    // 键盘高度 文字：252 表情：216 图片：140 语音：80
                    text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight +(252.0-216.0));
                    text_content.inputView = faceBoard;
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
                text_content.inputView = addImageView;
                
            }
   
                break;
            case 3:{
                
                if ( [text_content.inputView isEqual:faceBoard] || [text_content.inputView isEqual:addImageView] || [text_content.inputView isEqual:addAudioView] ) {
                    
                    isSystemBoardShow = YES;
                    text_content.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
//                    if (AudioButton.imageView.image == img) {
                    if ([Utilities image:AudioButton.imageView.image equalsTo:img]) {

                        isSystemBoardShow = YES;
                        text_content.inputView = nil;
                        // add 2015.07.08
                        text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight);
                        
                    }else{
                        isSystemBoardShow = NO;
                        text_content.inputView = addAudioView;
                        // add 2015.07.08
                        // 键盘高度 文字：252 表情：216 图片：140 语音：80
                        text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight +(252.0-80.0));
                        text_content.inputView = addAudioView;
                        
                    }
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    text_content.inputView = addAudioView;
                    
                    // add 2015.07.08
                    // 键盘高度 文字：252 表情：216 图片：140 语音：80
                    text_content.frame = CGRectMake(text_content.frame.origin.x, text_content.frame.origin.y, text_content.frame.size.width, contentHeight +(252.0-80.0));
                    text_content.inputView = addAudioView;
                    
                }
            }
                
                break;
                
            default:
                break;
        }
        
        [text_content becomeFirstResponder];
    }
}

/** #########add by kate ########################################### **/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    self.navigationItem.rightBarButtonItem.enabled = YES;

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    [Utilities dismissProcessingHud:self.view];
    
    if(true == [result intValue])
    {
        
        //NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        NSString *protocol = [resultJSON objectForKey:@"protocol"];
        
        if ([protocol isEqualToString:@"ClassThreadAction.post"] || [protocol isEqualToString:@"ClassForumThreadAction.post"]) {
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshClassDiscussView" object:self userInfo:nil];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewForDiscussView" object:self userInfo:nil];
        }
       //Chenth 8.6
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
//                                                       message:@"发布成功"
//                                                      delegate:self
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        [Utilities showTextHud:@"发布成功" descView:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pop) userInfo:nil repeats:NO];

        // 发帖成功，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        if (flag == 2) {
//            [super setCustomizeTitle:@"发表班级公告"];
            [dr dataReportGPStype:DataReport_Act_Class_CreateNews];
        }else{
//            [super setCustomizeTitle:@"发表新话题"];
            [dr dataReportGPStype:DataReport_Act_Discuss_Create];
        }
        
        //------2015.06.24--------------------
        if (flag == 1) {
            [ReportObject event:ID_POST_THREAD];
        }else if (flag == 2){
            [ReportObject event:ID_POST_CLASS_NEWS];
        }else{
            //发表班级讨论区帖子 
            [ReportObject event:ID_POST_CLASS_THREAD];
        }
        //--------------------------------------

    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"发布失败，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reciveHttpDataError:(NSError*)err
{
    self.navigationItem.rightBarButtonItem.enabled = YES;

    [Utilities dismissProcessingHud:self.view];

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if (text_content == textField)
//    {
//        //这里默认是最多输入120位
//        if (range.location >= 120)
//            return NO; // return NO to not change text
//        return YES;
//    }
//    else
//    {
    
        if (range.location >= 50)// 校园讨论区/班级公告/班级风采 50 2015.07.21
            return NO; // return NO to not change text
        return YES;
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (IS_IPHONE_5) {
         text_content.frame = CGRectMake(10, 70, 300.0, 568-60-70);
    }else{
         text_content.frame = CGRectMake(10, 70, 300.0, 480-60-70);
    }
   
    return YES;
}

// 2015.08.21
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self unEnabledBtn];//2015.08.21
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText
{
    float fHeight = textView.contentSize.height;
    return fHeight;
}

- (void)textViewDidChange:(UITextView *)textView {
    
#if 0
    float fHeight = [self heightForTextView:text_content WithText:text_content.text];
    
    if (IS_IPHONE_4) {
      fHeight = [self heightForTextView:text_content WithText:text_content.text] - 90;
    }else{
      fHeight = [self heightForTextView:text_content WithText:text_content.text] - 60;
    }
    
    CGRect g = text_content.frame;
    g.size.height = fHeight;
    
    //---add by kate 2016.03.26-----
    
    if (IS_IPHONE_4){
        
        if (g.size.height > 100) {
            g.size.height = 100;
        }
        
    }else{
        
        if (g.size.height > 190) {
            g.size.height = 190;
        }
    }
   
    //-------------------------------
    
    if (IS_IPHONE_4) {
        
        if (fHeight > 120.0) {
            [text_content setFrame:g];
            _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
            //_scrollerView.contentOffset = CGPointMake(0, fHeight);//update by kate 2015.03.03
            
        }
        
    }else{
        
        if (fHeight > 120.0+30) {
            
            [text_content setFrame:g];
            _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
            //_scrollerView.contentOffset = CGPointMake(0, fHeight);//update by kate 2015.03.03
            
        }
    }
#endif
    
    {
        
        //
        //    if ([textView.text length] == 0) {
        //        [_textViewCommentPlaceholder setHidden:NO];
        //    }else{
        //        [_textViewCommentPlaceholder setHidden:YES];
        //    }
        
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > 10000)
        {
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:10000];
            
            [textView setText:s];
            
        }else {
            
            CGSize constraintSize;
            constraintSize.width = textView.frame.size.width;
            constraintSize.height = MAXFLOAT;
            
            CGSize sizeFrame = [textView sizeThatFits:constraintSize];
            
            // 修改下边距约束
            [text_content mas_updateConstraints:^(MASConstraintMaker *make) {
                
                if (sizeFrame.height < contentHeight) {
                    make.size.mas_equalTo(CGSizeMake(textView.frame.size.width,contentHeight));
                }else{
                    make.size.mas_equalTo(CGSizeMake(textView.frame.size.width,sizeFrame.height));
                }
                              //make.bottom.equalTo(_scrollerView.mas_bottom).with.offset(0);
            }];
            // 当黏贴一段文字时 刚更新完text_content的约束立即更新contentView的约束不能生效 需要延时处理 正常输入没问题
            //[self performSelector:@selector(updateContentView) withObject:nil afterDelay:0.2];
            
            // 先取得光标位置
            NSRange cursorTextRange = [text_content selectedRange];
            
            // 获取光标位置之前的所有文字text
            NSString *cursorText = [text_content.text substringToIndex:cursorTextRange.location];
            
            // 接着获取此光标之前的文字在该textView中的高度
            UITextView *tv = [[UITextView alloc] init];
            tv.textAlignment = NSTextAlignmentLeft;
            tv.font = [UIFont systemFontOfSize:17.0f];
            tv.text = cursorText;
            CGSize sizeToFit = [tv sizeThatFits:CGSizeMake(text_content.frame.size.width, MAXFLOAT)];
            int cursorHeight = sizeToFit.height;
            //    NSLog(@"cursorHeight = %d", cursorHeight);
            
            // 整个textView的高度
            int textViewTotalHeight = sizeFrame.height;
            
            // textView的y坐标到屏幕底部的高度
            int r = [Utilities getScreenSize].height - text_content.frame.origin.y-64;
            
            // 为了防止光标点击在整个textView中间时候修改后，scrollView的偏移问题，这里计算一下textView整个的高度距离光标的高度
            int ooo = textViewTotalHeight - cursorHeight;
            //    NSLog(@"ooo = %d", ooo);
            
            // 首先，如果整个textView的高度超出了textView的y坐标到屏幕底部的高度的话，就认为已经超出了屏幕的绘制范围，需要将scrollView的offset设置为输入的文字超出的高度。
            if (textViewTotalHeight > r) {
                // 如果textView整个的高度距离光标的高度小于一行的高度，就认为在整个textView的最下面，需要更改scrollView的offset，并设置偏移。
                if (ooo < 20) {
                    // 最后多加的20是为了多偏移一些，露出一些余白，好看一点。。用于键盘一起开启的情况下
#if 0
                    [_scrollerView setContentOffset:CGPointMake(0, textViewTotalHeight-r+20+10) animated:YES];
#endif
                }else {
                    //            [_scrollViewBg setContentOffset:CGPointMake(0, ooo+10) animated:YES];
                }
            }
            
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.view layoutIfNeeded]; }];
        }
        
    }

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationDuration:0.20];
    if (iPhone5) {
        _scrollerView.contentOffset = CGPointMake(0, 60 );
    } else {
        _scrollerView.contentOffset = CGPointMake(0, 60 );
    }
    [UIView commitAnimations];
    if ([text_content.text isEqualToString:@"内容"]) {
        text_content.text = @"";
        text_content.textColor = [UIColor blackColor];
    }
    [self enableBtn];//add 2015.08.21
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationDuration:0.20];
    _scrollerView.contentOffset = CGPointMake(0, 0 );
    [UIView commitAnimations];

    if ([text_content.text isEqualToString:@""]) {
        text_content.text = @"内容";
        text_content.textColor = [UIColor lightGrayColor];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    if ([buttonFlagViewArray count] > 0) {
        photoFlagImageView.hidden = NO;
        photoNumLabel.hidden = NO;
        photoNumLabel.text = [NSString stringWithFormat:@"%d", [buttonFlagViewArray count]];
    }
}

-(void)saveButtonImageToFile
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];

//    NSLog(@"[buttonArray count] = %d", [buttonArray count]);

//    if (buttonArray.count > 1) {
//      for (int i=0; i<[buttonArray count]-1; i++) {
//        NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
//                
//        [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image] attributes:nil];
//        
//        [imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
//      }
//    }
    
    if(buttonArray.count > 1){
        
        for (int i=0; i<[self.assets count]; i++) {
            
            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
            
            ALAsset *asset = [self.assets objectAtIndex:i];
            //获取资源图片的详细资源信息
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            //获取资源图片的高清图
            //[representation fullResolutionImage];
            //获取资源图片的全屏图
            //[representation fullScreenImage];
            
            UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
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
            
            NSData *data;
            data = UIImageJPEGRepresentation(image, 0.1);
            
            UIImage *img = [UIImage imageWithData:data];
            
            [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
            
            [imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
        }
    }
}

-(NSData *)imageToNsdata:(UIImage*)img
{
#if 0
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(img)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(img);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(img, 0.3);
    }
    return data;
#else
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    
    return data = UIImageJPEGRepresentation(img, 0.3);
#endif
}

-(void)removeButtonWithTag:(NSInteger)tag
{
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
}

-(void)showButtonArray
{
    for (int i=0; i<[buttonFlagViewArray count]; i++) {
        [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
    }
    

    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [addImageView addSubview:((UIButton*)[buttonArray objectAtIndex:i])];

        if (i<=3) {
            addImageView.frame = CGRectMake(0, 0, WIDTH, 100);

            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1)+50*i,
                                                                          20,
                                                                          50,
                                                                          50);
        } else if (i>3 && i<=7) {
            addImageView.frame = CGRectMake(0, 0, WIDTH, 160);

            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-4)+50*(i-4),
                                                                          20+50+12,
                                                                          50,
                                                                          50);
        } else if (i>7 && i <9) {
//            addImageView.frame = CGRectMake(0, 0, 320, 220);
//
//            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-8)+50*(i-8),
//                                                                          20+50+12+50+12,  //cao
//                                                                          50,
//                                                                          50);
        }
    }
    
 
    
    // 先不显示红点了
//    for (int i=0; i<[buttonFlagViewArray count]; i++) {
//
//        ((UIImageView *)[buttonFlagViewArray objectAtIndex:i]).frame = CGRectMake(
//                                                                                  ((UIButton*)[buttonArray objectAtIndex:i]).frame.origin.x + ((UIButton*)[buttonArray objectAtIndex:i]).frame.size.width -10,
//                                                                                  ((UIButton*)[buttonArray objectAtIndex:i]).frame.origin.y - 5,
//                                                                                  12,
//                                                                                  12);
//        [addImageView addSubview:[buttonFlagViewArray objectAtIndex:i]];
//    }
}

- (IBAction)recordPlay_btnclick:(id)sender
{
    if(curAudio.length>0){
        
        [recordAudio handleNotification:YES];//2015.11.16
        [recordAudio play:curAudio];
    }
}

-(void)RecordStatus:(int)status
{
    // 播放状态cb
    // 0-播放中 1-播放完成 2-播放错误
    if (0 == status) {
        
            playImageView.hidden = YES;
            
            [animationImageView startAnimating];
    } else if (1 == status) {
        
            [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateNormal];
            [playRecordButton setTitle:[NSString stringWithFormat:@"%d″", recordSec] forState:UIControlStateSelected];
            
            playImageView.hidden = NO;
            [animationImageView stopAnimating];
    } else if (2 == status) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"播放失败，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

//---add by kate 2014.10.08-----------------------------------------------------------------------------

-(void)showImageButtonArray
{
    for (int i=0; i<[buttonFlagViewArray count]; i++) {
        [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
    }
    
    
    NSLog(@"show array count:%d",[buttonArray count]);
    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%d",i,((UIButton*)[buttonArray objectAtIndex:i]).tag);
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        //[((UIButton*)[buttonArray objectAtIndex:i]) removeFromSuperview];
        //[self removeButtonWithTag:((UIButton*)[buttonArray objectAtIndex:i]).tag];
        [addImageView addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        if (i<=3) {
            addImageView.frame = CGRectMake(0, 0, WIDTH, 100);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1)+50*i,
                                                                          20,
                                                                          50,
                                                                          50);
        } else if (i>3 && i<=7) {
            addImageView.frame = CGRectMake(0, 0, WIDTH, 160);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-4)+50*(i-4),
                                                                          20+50+12,
                                                                          50,
                                                                          50);
        } else if (i>7 && i <9) {
//            addImageView.frame = CGRectMake(0, 0, 320, 220);
//            
//            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-8)+50*(i-8),
//                                                                          20+50+12+50+12,  //cao
//                                                                          50,
//                                                                          50);
        }
    }
    
    if ([buttonArray count] -1 >0) {
        
        photoFlagImageView.hidden = NO;
        photoNumLabel.hidden = NO;
        photoNumLabel.text = [NSString stringWithFormat:@"%d", ([buttonArray count]-1)];
        
    }else{
        photoFlagImageView.hidden = YES;
        photoNumLabel.hidden = YES;
    }
    
}

#pragma mark - Assets Picker Delegate

/*- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [self.assets addObjectsFromArray:assets];
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    for (int i=0; i<[self.assets count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        ALAsset *asset = [self.assets objectAtIndex:i];
        
        //获取资源图片的详细资源信息
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        //获取资源图片的高清图
        [representation fullResolutionImage];
        //获取资源图片的全屏图
        [representation fullScreenImage];
        
        UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]];

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

        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.1);
        
        UIImage *img = [UIImage imageWithData:data];
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];

    [self showImageButtonArray];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];
}*/


#pragma mark - Popover Controller Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    for (int i=0; i<[self.assets count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        ALAsset *asset = [self.assets objectAtIndex:i];
        UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];
    
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    
    [text_content becomeFirstResponder];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 8)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"最多选择8张图片"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"您的资源尚未下载到您的设备"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < 8 && asset.defaultRepresentation != nil);
}
//--------------------------------------------------------------------------------------
// 按钮们灰显
-(void)unEnabledBtn{
    
    UIImage *image = [UIImage imageNamed:@"btn_bq_d.png"];
    UIImage *image_un = [UIImage imageNamed:@"btn_sr_un.png"];
    UIImage *image_bqun = [UIImage imageNamed:@"btn_bq_un.png"];

    if ([Utilities image:keyboardButton.imageView.image equalsTo:image]) {
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_un.png"]
                        forState:UIControlStateNormal];
        
    }else if ([Utilities image:keyboardButton.imageView.image equalsTo:image_un]){
        NSLog(@"");
    }else if ([Utilities image:keyboardButton.imageView.image equalsTo:image_bqun]){
        NSLog(@"");
    }else{
        
        [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_un.png"]
                        forState:UIControlStateNormal];
        
    }
    
    [addImageButton setImage:[UIImage imageNamed:@"icon_send_pic_un.png"] forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"] forState:UIControlStateNormal];
    
//    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_un.png"] forState:UIControlStateHighlighted];
//    [addImageButton setImage:[UIImage imageNamed:@"icon_send_pic_un.png"] forState:UIControlStateHighlighted];
//    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"] forState:UIControlStateHighlighted];
    keyboardButton.userInteractionEnabled = NO;
    addImageButton.userInteractionEnabled = NO;
    AudioButton.userInteractionEnabled = NO;
    
    
}
// 取消灰显
-(void)enableBtn{
    
    UIImage *image = [UIImage imageNamed:@"btn_sr_un.png"];
    if ([Utilities image:keyboardButton.imageView.image equalsTo:image]) {
        [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                        forState:UIControlStateHighlighted];
    }else{
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }
    
    
    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_d.png"] forState:UIControlStateNormal];
    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_p.png"] forState:UIControlStateHighlighted];
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    
    keyboardButton.userInteractionEnabled = YES;
    addImageButton.userInteractionEnabled = YES;
    AudioButton.userInteractionEnabled = YES;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 键盘下落
    [text_content resignFirstResponder];
    [text_title resignFirstResponder];
    NSLog(@"scrollViewDidEndDragging");
}


@end

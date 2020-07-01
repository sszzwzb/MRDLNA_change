//
//  PublishMomentsViewController.m
//  MicroSchool
//  发布个人动态
//  Created by Kate on 14-12-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PublishMomentsViewController.h"

#import "Utilities.h"
#import "Toast+UIView.h"
#import "WhoCanViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "FullImageViewController.h"
#import "SetPersonalViewController.h"
#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "ChoosePhotoAlbumViewController.h"

@interface PublishMomentsViewController ()<CTAssetsPickerControllerDelegate,UIPopoverControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsAndImgs;
@property (nonatomic, strong) UIPopoverController *popover;

@end
NSString *privilege;//权限

@implementation PublishMomentsViewController

- (void)viewDidLoad {
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeTitle:@"发动态"];
    
    _tagsArray = [[NSMutableArray alloc] init];

    //-----获取动态的ac参数-----------------------------------------------------------------
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
   
    switch ([usertype integerValue]) {
        case 0:
            ac = @"CircleStudent";
            break;
        case 6:
            ac = @"CircleParent";
            break;
        case 7:
            ac = @"CircleTeacher";
            break;
        case 9:
            ac = @"CircleTeacher";
            break;
            
        default:
            break;
    }
    //-------------------------------------------------------------------------------------
    
    if (_flag == 1) {
        [self setCustomizeTitle:@"分享链接"];
    }else if (_flag == 0){
        
        if ([@"classPhotoList" isEqualToString:_fromName]) {
            [self setCustomizeTitle:@"传照片"];
        }else{
            [self setCustomizeTitle:@"发布动态"];
        }
        
    }
    
    //[self setCustomizeRightButton:@"icon_send.png"];
    [self setCustomizeTitle:@"编辑"];
    [self setCustomizeRightButtonWithName:@"发布"];
    
    if ([@"classPhotoList" isEqualToString:_fromName]) {
        [self setCustomizeTitle:@"传照片"];
    }
    
    [self setCustomizeLeftButton];
    
    // 获取成长空间状态，确认是否可以添加到我的足迹
    [self doGetGrowingPathStatus];
    
    [self doGetMomentsTags:YES];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    imageArray = [[NSMutableDictionary alloc] init];
    buttonArray = [[NSMutableArray alloc] init];
    buttonFlagViewArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLoadPublishGrowingStatus)
                                                 name:@"reLoadPublishGrowingStatus"
                                               object:nil];//add by kate 2016.01.06
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePhoto:)
                                                 name:@"deletePhoto"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePhotoAlbum:)
                                                 name:@"ChangePhotoAlbum"
                                               object:nil];

    
    //-----------------------------------------------------------------------
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    // 设置背景scrollView
   CGRect rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 64);
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    //--------------------------------------
    
    text_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 88)];
//    text_content.backgroundColor = [UIColor clearColor];
    //text_content.text = @"这一刻想说的...";
    text_content.textColor = [UIColor blackColor];
    //text_content.returnKeyType = UIReturnKeyDone;//2015.11.02志伟确认 完成变成换行
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont systemFontOfSize:15.0f];
    
    //是否可以滚动
    text_content.scrollEnabled = YES;
    //获得焦点
    //[text_content becomeFirstResponder];
    
    placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 6, 160.0, 20.0)];
    placeHoderLabel.text = @"这一刻的想法...";
    placeHoderLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0  alpha:1];
    placeHoderLabel.font = [UIFont systemFontOfSize:15.0];
    placeHoderLabel.hidden = NO;
    [text_content addSubview:placeHoderLabel];
    
    [_scrollerView addSubview:text_content];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 64);
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 5000;// 2015.07.21
        faceBoard.inputTextView = text_content;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    
    //显示图片的view
    addImageView = [[UIView alloc]initWithFrame:CGRectMake(12.0, text_content.frame.origin.y+text_content.frame.size.height, [UIScreen mainScreen].bounds.size.width - 24.0, 70.0 + 19.0)];
     //addImageView = [[UIView alloc]initWithFrame:CGRectMake(0, text_content.frame.origin.y+text_content.frame.size.height, [UIScreen mainScreen].bounds.size.width - 24.0, 70.0 + 19.0)];
  
    addImageView.backgroundColor = [UIColor whiteColor];
    
    //-------update by kate 2015.04.20--------------------------------------
    if (_flag == 0) {//图片
        // 加图片button
        button_photoMask0 = [UIButton buttonWithType:UIButtonTypeCustom];
        button_photoMask0.tag = 1;
        //[buttonArray addObject:button_photoMask0];
#if 0
        button_photoMask0.frame = CGRectMake(10,
                                             10,
                                             50,
                                             50);
#endif
        button_photoMask0.frame = CGRectMake(0,
                                             0,
                                             70,
                                             70);
        
        [button_photoMask0 setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
        [button_photoMask0 setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
        [button_photoMask0 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [addImageView addSubview:button_photoMask0];
        
    }else if(_flag == 1){//链接
        
        //--------------add by kate 2015.04.21------------------------------------------------------------------
        
        //addImageView.backgroundColor = [UIColor grayColor];
        addImageView.hidden = YES;
        
//        UIView *shareUrlView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 50.0)];
        
        UIView *shareUrlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100.0)];
        //shareUrlView.backgroundColor = [UIColor purpleColor];
#if 0
        UILabel *urlTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 80.0, 20.0)];
        urlTitleLabel.text = @"热文分享";
        
        [shareUrlView addSubview:urlTitleLabel];
#endif
        
        urlTextF = [[UITextView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 99.0)];
        //urlTextF.placeholder = @"请将外部链接粘贴到此处...";
        //[urlTextF setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        //urlTextF.placeholder = @"请粘贴或输入网址到此处";
        //UIColor *color = [UIColor lightGrayColor];
       // urlTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请粘贴或输入网址到此处" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
        urlTextF.font = [UIFont systemFontOfSize:15.0];
        urlTextF.textColor = [UIColor blueColor];//用颜色突出网址
        urlTextF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        urlTextF.returnKeyType = UIReturnKeyDone;
        urlTextF.delegate = self;
        //urlTextF.backgroundColor = [UIColor yellowColor];
        
        placeHoderUrlLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 12.0, 160.0, 20.0)];
        placeHoderUrlLabel.text = @"请粘贴或输入网址到此处";
        placeHoderUrlLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0  alpha:1];
        placeHoderUrlLabel.font = [UIFont systemFontOfSize:15.0];
        placeHoderUrlLabel.hidden = NO;
        [urlTextF addSubview:placeHoderUrlLabel];
        
        [shareUrlView addSubview:urlTextF];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, shareUrlView.frame.origin.y+shareUrlView.frame.size.height-0.7, [UIScreen mainScreen].bounds.size.width, 0.7)];
        lineV.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [shareUrlView addSubview:lineV];
        
        text_content.frame = CGRectMake(0,shareUrlView.frame.origin.y+shareUrlView.frame.size.height+5, [UIScreen mainScreen].applicationFrame.size.width , 95.0);
        //text_content.backgroundColor = [UIColor yellowColor];

        
        //[addImageView addSubview:shareUrlView];
        [_scrollerView addSubview:shareUrlView];
        //--------------------------------------------------------------------------------------------------------
    }else if(_flag == 2){//从webView来分享链接
        
        NSString *_foundModuleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"foundModule"];
        
        if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
            _foundModuleName = @"校友圈";
#endif
            _foundModuleName = @"师生圈";//2016.01.05
        }
        
        [self setCustomizeTitle:[NSString stringWithFormat:@"分享到%@",_foundModuleName]];
        
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width-30, 50.0)];
        shareView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40.0, 40.0)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:_shareImgUrl] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link.png"]];
        
//        if (_headImg!=nil) {
//            [imgV setImage:_headImg];
//        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, (50-20)/2.0, [UIScreen mainScreen].bounds.size.width - 60.0 - 15.0 - 10, 20.0)];
        titleLabel.text = _shareTitle;
        
        [shareView addSubview:imgV];
        [shareView addSubview:titleLabel];
        
        [addImageView addSubview:shareView];
        
    }else if (_flag == 3){//小视频
        
        addImageView.hidden = YES;
        text_content.frame = CGRectMake(0,text_content.frame.origin.y, 189.0 , addImageView.frame.size.height+addImageView.frame.origin.y);
        text_content.showsVerticalScrollIndicator = NO;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(text_content.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width - text_content.frame.size.width, text_content.frame.size.height)];
        rightView.backgroundColor = [UIColor whiteColor];
        [_scrollerView addSubview:rightView];
        
//        UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        videoBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-14.0-105.0, 14.0, 105.0, 79.0);
//        videoBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//        [videoBtn setTitle:@"等待小视频控件" forState:UIControlStateNormal];
//        videoBtn.backgroundColor = [UIColor grayColor];
        
        UIImageView *thumbImgImgV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-14.0-105.0, 14.0, 105.0, 79.0)];
        thumbImgImgV.userInteractionEnabled = YES;
        [thumbImgImgV setClipsToBounds:YES];
        thumbImgImgV.contentMode = UIViewContentModeScaleAspectFill;
        
        if (_thumbImg == nil) {
            
            thumbImgImgV.image = [UIImage imageNamed:@"loading_gray.png"];
            
        }else{
            
            thumbImgImgV.image = _thumbImg;
            UIImageView *videoMarkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, thumbImgImgV.frame.size.height-13.0-5.0, 13.0, 13.0)];
            videoMarkImgV.image = [UIImage imageNamed:@"videoMark.png"];
            [thumbImgImgV addSubview:videoMarkImgV];
            
        }
        
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPlayVideo)];
        singleTouch.delegate = self;
        [thumbImgImgV addGestureRecognizer:singleTouch];
        
        [_scrollerView addSubview:thumbImgImgV];
        
    }
     //---------------------------------------------------------------------------------------------------------
    
    if (_flag == 0 || _flag == 2) {
        
        seprateLine = [[UIView alloc] initWithFrame:CGRectMake(0, addImageView.frame.size.height+addImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 0.7)];
        seprateLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        
        [_scrollerView addSubview:seprateLine];
        
        whoCanViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        whoCanViewBtn.frame = CGRectMake(0, seprateLine.frame.origin.y+0.7+20.0, [UIScreen mainScreen].bounds.size.width, 45.0);
        [whoCanViewBtn setBackgroundColor:[UIColor whiteColor]];
        //[whoCanViewBtn setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
        [whoCanViewBtn addTarget:self action:@selector(goToWhoCanViewPage) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 45.0)];
        titleLabel.text = @"谁可以看";
        titleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        //titleLabel.backgroundColor = [UIColor yellowColor];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width/2.0  - 25.0, 0, [UIScreen mainScreen].bounds.size.width/2.0 - 5, 45.0)];
        typeLabel.text = @"公开";
        typeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        typeLabel.textAlignment = NSTextAlignmentRight;
        typeLabel.font = [UIFont systemFontOfSize:16.0];
        //typeLabel.backgroundColor = [UIColor redColor];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 25, (45.0-12.0)/2.0, 12.0, 12.0)];
        imgV.image = [UIImage imageNamed:@"accessory.png"];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(button_photoMask0.frame.origin.x, 0, [UIScreen mainScreen].bounds.size.width - button_photoMask0.frame.origin.x, 0.7)];
        lineV.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45.0 - 0.7, [UIScreen mainScreen].bounds.size.width, 0.7)];
        lineV2.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];

       
        [whoCanViewBtn addSubview:lineV];
        [whoCanViewBtn addSubview:lineV2];
        
        [whoCanViewBtn addSubview:titleLabel];
        [whoCanViewBtn addSubview:typeLabel];
        [whoCanViewBtn addSubview:imgV];
    
        whiteViewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, addImageView.frame.origin.y, 12.0, addImageView.frame.size.height)];
        whiteViewLeft.backgroundColor = [UIColor whiteColor];
        whiteViewRight = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-12.0, addImageView.frame.origin.y, 12.0, addImageView.frame.size.height)];
        whiteViewRight.backgroundColor = [UIColor whiteColor];
        
        if ([@"classPhotoList" isEqualToString:_fromName]) {
            
            selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake((35.0-20.0)/2.0, (45.0-20.0)/2.0, 20.0, 20.0);
            [selectBtn addTarget:self action:@selector(selectPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"unSelect.png"] forState:UIControlStateNormal];
            
            // UIControlStateSelected ｜ UIControlStateHighlighted 和 UIControlStateSelected 是两种不同的状态, 在isSelected状态时再点击按钮就变成了UIControlStateSelected ｜ UIControlStateHighlighted的状态
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
            
            titleLabel.frame = CGRectMake(35.0, 0.0, 85.0, 45.0);
            titleLabel.text = @"同时上传到";
            
            if (_isFromAlbum) {
                
                typeLabel.text = _photoAlbumTitle;
                selectBtn.selected = YES;
                
            }else{
                
                selectBtn.selected = NO;
                typeLabel.text = @"选择相册";
            }
           
            [whoCanViewBtn addSubview:selectBtn];
        }
        
        [_scrollerView addSubview:addImageView];
        [_scrollerView addSubview:whiteViewLeft];
        [_scrollerView addSubview:whiteViewRight];
        
       
        [_scrollerView addSubview:whoCanViewBtn];
        
       
    }else{
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, text_content.frame.size.height +text_content.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 0.7)];
        sepLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        
        [_scrollerView addSubview:sepLine];
        
        whoCanViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        whoCanViewBtn.frame = CGRectMake(0, sepLine.frame.size.height +sepLine.frame.origin.y+20.0, [UIScreen mainScreen].bounds.size.width, 40.0);
        [whoCanViewBtn setBackgroundColor:[UIColor whiteColor]];
//        [whoCanViewBtn setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
        [whoCanViewBtn addTarget:self action:@selector(goToWhoCanViewPage) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 45.0)];
        titleLabel.text = @"谁可以看";
        titleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width/2.0  - 25.0, 0, [UIScreen mainScreen].bounds.size.width/2.0 - 5, 45.0)];
        typeLabel.text = @"公开";
        typeLabel.textColor = [UIColor grayColor];
        typeLabel.textAlignment = NSTextAlignmentRight;
        typeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        typeLabel.font = [UIFont systemFontOfSize:16.0];
        //typeLabel.backgroundColor = [UIColor redColor];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 25, (45.0 - 12.0)/2.0, 12.0, 12.0)];
        imgV.image = [UIImage imageNamed:@"accessory.png"];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(button_photoMask0.frame.origin.x, 0, [UIScreen mainScreen].bounds.size.width - button_photoMask0.frame.origin.x, 0.7)];
        lineV.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 41.0 , [UIScreen mainScreen].bounds.size.width, 0.7)];
        lineV2.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        
        
        [whoCanViewBtn addSubview:lineV];
        [whoCanViewBtn addSubview:lineV2];
        
        [whoCanViewBtn addSubview:titleLabel];
        [whoCanViewBtn addSubview:typeLabel];
        [whoCanViewBtn addSubview:imgV];
        
        //[addImageView addSubview:whoCanViewBtn];
        if ([@"PhotoHome" isEqualToString:_fromName]) {//从相册的小视频来 没有谁可以看这条
            
        }else{
           [_scrollerView addSubview:whoCanViewBtn];
        }
        
        
    }
    
//    whoCanViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    whoCanViewBtn.frame = CGRectMake(0, addImageView.frame.size.height - 50.0, [UIScreen mainScreen].bounds.size.width, 50.0);
//    //whoCanViewBtn.backgroundColor = [UIColor redColor];
//    [whoCanViewBtn setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
//    [whoCanViewBtn addTarget:self action:@selector(goToWhoCanViewPage) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 50.0)];
//    titleLabel.text = @"谁可以看";
//    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width/2.0  - 25.0, 0, [UIScreen mainScreen].bounds.size.width/2.0 - 5, 40.0 + 10)];
//    typeLabel.text = @"公开";
//    typeLabel.textColor = [UIColor grayColor];
//    typeLabel.textAlignment = NSTextAlignmentRight;
//    //typeLabel.backgroundColor = [UIColor redColor];
//    
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 25, (50.0-12.0)/2.0, 12.0, 12.0)];
//    imgV.image = [UIImage imageNamed:@"accessory.png"];
//    
//    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(button_photoMask0.frame.origin.x, 0, [UIScreen mainScreen].bounds.size.width - button_photoMask0.frame.origin.x, 0.7)];
//    lineV.backgroundColor = [UIColor lightGrayColor];
//    
//    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 50.0 - 0.7, [UIScreen mainScreen].bounds.size.width, 0.7)];
//    lineV2.backgroundColor = [UIColor lightGrayColor];
//
//    
//    [whoCanViewBtn addSubview:lineV];
//    [whoCanViewBtn addSubview:lineV2];
//    
//    [whoCanViewBtn addSubview:titleLabel];
//    [whoCanViewBtn addSubview:typeLabel];
//    [whoCanViewBtn addSubview:imgV];
//    
//    [addImageView addSubview:whoCanViewBtn];
//    
//    [_scrollerView addSubview:addImageView];
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolBar.hidden = YES;
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
    
    [self.view addSubview:toolBar];
    
    if([_fromName isEqualToString:@"class"]){
        
        NSLog(@"cname:%@",_cName);
        privilege = @"32";
//        typeLabel.text = _cName;
        typeLabel.text = @"公开";
        
    }else{
        
        privilege = @"32";
    }
    
    //-----add by kate-----------------------------------
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"classListCheckArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"classListCheckArray2"];
    //---------------------------------------------------

}

-(void)selectPhotoAlbum:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    if (btn.selected) {
        
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
}

//通知 选择相册后回到这个方法改变相册id和title
-(void)ChangePhotoAlbum:(NSNotification*)notify{
    
    NSDictionary *dic = [notify userInfo];
    
    _photoAlbumID = [dic objectForKey:@"aid"];
    _photoAlbumTitle = [dic objectForKey:@"title"];
    
    typeLabel.text = _photoAlbumTitle;
    
     selectBtn.selected = YES;
    
}

// 从支付页或者成长空间开通页或者绑定页回来刷新状态然后判断是否弹出标签页
-(void)reLoadPublishGrowingStatus{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"module", @"op",
                          _cid, @"cid",
                          nil];
    
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *dic = [respDic objectForKey:@"message"];
            _growingPathStatusSchool = [NSString stringWithFormat:@"%@", [dic objectForKey:@"school"]];//学校是否开通成长空间
            _growingPathStatusSpace = [NSString stringWithFormat:@"%@", [dic objectForKey:@"space"]];//成长空间状态
            _growingPathStatusNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"number"]];//是否绑定成长空间
            _growingPathStatusUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"url"]];//点我了解什么是成长空间
            _trial = [NSString stringWithFormat:@"%@", [dic objectForKey:@"trial"]];//
            
        } else {
            
            _growingPathStatusSchool = nil;
            _growingPathStatusSpace = nil;
            _growingPathStatusNumber = nil;
            //            [Utilities showTextHud:@"获取标签失败，请稍后再试。" descView:self.view];
        }
        
        [self isDirectTo];
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //        [Utilities showTextHud:@"获取标签失败，请稍后再试。" descView:self.view];
    }];

    
}

// 去视频播放页
-(void)gotoPlayVideo{
    
    SightPlayerViewController *vc = [[SightPlayerViewController alloc]init];
    vc.videoURL = [NSURL fileURLWithPath:_videoPath];
    vc.isLocalUrl = YES;
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated: YES completion:nil];
    
}

-(void)doGetGrowingPathStatus
{
    /**
     * 成长空间模块状态，学校是否有成长空间，班级是否有血迹，个人是否缴费
     * @author luke
     * @date 2015.12.29
     * @args
     *   v=3, ac=GrowingPath, op=module, sid=, cid=, uid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"module", @"op",
                          _cid, @"cid",
                          nil];
    
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *dic = [respDic objectForKey:@"message"];
            _growingPathStatusSchool = [NSString stringWithFormat:@"%@", [dic objectForKey:@"school"]];//学校是否开通成长空间
            _growingPathStatusSpace = [NSString stringWithFormat:@"%@", [dic objectForKey:@"space"]];//成长空间状态
            _growingPathStatusNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"number"]];//是否绑定成长空间
            _growingPathStatusUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"url"]];//点我了解什么是成长空间
            _trial = [NSString stringWithFormat:@"%@", [dic objectForKey:@"trial"]];//
            
        } else {
            _growingPathStatusSchool = nil;
            _growingPathStatusSpace = nil;
            _growingPathStatusNumber = nil;
//            [Utilities showTextHud:@"获取标签失败，请稍后再试。" descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
//        [Utilities showTextHud:@"获取标签失败，请稍后再试。" descView:self.view];
    }];
}

//去[谁可以看]页
-(void)goToWhoCanViewPage{
    
    [text_content resignFirstResponder];
    [urlTextF resignFirstResponder];
    
    if ([_fromName isEqualToString:@"classPhotoList"]) {
        
        ChoosePhotoAlbumViewController *ccvc = [[ChoosePhotoAlbumViewController alloc] init];
        ccvc.cid = _cid;
        [self.navigationController pushViewController:ccvc animated:YES];
        
        
    }else{
        
        if ([typeLabel.text isEqualToString:@"公开"] || [typeLabel.text isEqualToString:@"私密"]) {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"classListCheckArray"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else{
            
        }
        
        WhoCanViewController *wcv = [[WhoCanViewController alloc]init];
        wcv.fromName = @"setPublishM";
        if([_fromName isEqualToString:@"class"]){
            wcv.isClass = YES;
            wcv.cid = _cid;
            wcv.cName = _cName;
        }
        [self.navigationController pushViewController:wcv animated:YES];
    }
    
}


-(void)selectLeftAction:(id)sender{
    
    
    if ([text_content.text isEqualToString:@""] && [imageArray count] == 0) {
        
        
        [text_content resignFirstResponder];
        [urlTextF resignFirstResponder];
        
        //cidsForPublish
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cidsForPublish"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [network cancelCurrentRequest];
        
        if (_flag == 3) {
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                [self disablesAutomaticKeyboardDismissal];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }

        
    }else{
        
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出本次编辑?" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
        alerV.tag = 222;
        [alerV show];
        
    }
    
   
}

-(void)selectRightAction:(id)sender{
    
    [self submitAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)faceBoardClick:(id)sender{
    
    clickFlag = 1;
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


-(void)submitAction:(id)sender
{
//   if(([@"这一刻想说的..." isEqual:text_content.text]
//             ) && text_content.textColor == [UIColor lightGrayColor])
//    {
//        text_content.text = @"";
//    }
//    
//    UIColor *color = [UIColor lightGrayColor];
//    if (text_content.textColor == color) {
//        text_content.text= @"";
//    }
    
    //---updat by kate 2016.04.12--------------------------------------------
    
    // 发布接口的ac参数采用身份不同动态变化 防止不同角色要附加不同的业务逻辑 luke说 2016.04.12
    
    [text_content resignFirstResponder];
    
    if (_flag == 0) {
        // 图片或文字
        [self saveButtonImageToFile];
        
//        NSLog(@"content:%@",text_content.text);
//        NSLog(@"[imageArray count]:%d",[imageArray count]);
        
        if ([text_content.text isEqualToString:@""] && [imageArray count] == 0) {
            
            [self.view makeToast:@"请添加内容文字或图片"
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
        else {
            
            if([@"classPhotoList" isEqualToString:_fromName]){//班级相册上传
               
                /**
                 * 班级相册上传
                 * @author luke
                 * @date 2016.03.17
                 * @args
                 *  v=3 ac=Kindergarten op=addClassTopic sid= cid= uid= aid=相册ID app= title=说点什么 png0..png9
                 */
                
                if([imageArray count] == 0){//文字变成选填 图片必填
                    
                    [self.view makeToast:@"请添加图片"
                                duration:0.5
                                position:@"center"
                                   title:nil];
                    
                }else{
                    
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [self hideKeyBoard];
                    
                    // [ReportObject event:ID_CIRCLE_POST];
                    [Utilities showProcessingHud:self.view];
                    
                    NSString *aid = @"0";
                    
                    if (selectBtn.selected && _photoAlbumID!=nil) {//选中了
                        
                        aid = _photoAlbumID;
                        
                    }
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Kindergarten", @"ac",
                                          @"3",@"v",
                                          @"addClassTopic", @"op",
                                          text_content.text, @"title",
                                          _cid,@"cid",
                                          aid,@"aid",
                                          imageArray, @"imageArray",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadPhotoSubmit andData:data];
                }
               
            }else{//动态
                
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
                
                if([@"0" isEqualToString:userType] || [@"6" isEqualToString:userType]) {
                    // 如果学生或者家长选择了图片，就弹出选择标签页面
                    if (0 != [imageArray count]) {
                        // 先判断该学校是否开通了成长空间 to do
                        [self isDirectTo];
                        
                    }else {
                        // 只有文字部分
                        // 防止多次快速提交
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                        [self hideKeyBoard];
                        
                        [ReportObject event:ID_CIRCLE_POST];
                        [Utilities showProcessingHud:self.view];
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              ac, @"ac",
                                              @"3",@"v",
                                              @"post", @"op",
                                              text_content.text, @"message",
                                              imageArray, @"imageArray",
                                              privilege,@"privilege",
                                              @"",@"shareUrl",
                                              cids,@"cids",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
                    }
                }else {
                    // 防止多次快速提交
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [self hideKeyBoard];
                    
                    [ReportObject event:ID_CIRCLE_POST];
                    [Utilities showProcessingHud:self.view];
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          ac, @"ac",
                                          @"3",@"v",
                                          @"post", @"op",
                                          text_content.text, @"message",
                                          imageArray, @"imageArray",
                                          privilege,@"privilege",
                                          @"",@"shareUrl",
                                          cids,@"cids",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
                }
                
            }
            
           
        }
    }else if(_flag == 1){//链接
        
        
        if ([text_content.text isEqualToString:@""] && [urlTextF.text length] == 0) {
            
            [self.view makeToast:@"请添加内容文字或链接网址"
                        duration:0.5
                        position:@"center"
                           title:nil];
            
        }else if ([urlTextF.text length] >0 && [self isUrl:urlTextF.text] == NO){
            
//            [self.view makeToast:@"请输入或粘贴标准网址"
//                        duration:0.5
//                        position:@"center"
//                           title:nil];
//            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入标准格式网址\n 例：http://www.5xiaoyuan.cn" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            // 防止多次快速提交
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self hideKeyBoard];
            
            /*
             * 发布个人动态
             * @author luke
             * @date 2014.12.13
             * @args
             *  op=post, sid=, uid=, message=, [png0..png9]=
             * @example:
             *
             */
            
            [ReportObject event:ID_CIRCLE_SHARE_URL];//2015.06.25
            [Utilities showProcessingHud:self.view];// 2015.05.12
            /*
              op=post, sid=, uid=, message=, [png0..png9]=, privilege=, cids=, shareUrl=            
             */
            
            NSLog(@"text:%@",urlTextF.text);
            //NSString *encodedString=[urlTextF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"encodedString:%@",encodedString);
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  ac, @"ac",
                                  @"3",@"v",
                                  @"post", @"op",
                                  text_content.text, @"message",
                                  imageArray, @"imageArray",
                                  privilege,@"privilege",
                                  urlTextF.text,@"shareUrl",
                                  cids,@"cids",
                                  nil];
             NSLog(@"data:%@",data);
            
            [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
        }
        
        
    }else if(_flag == 2){//从webView来分享
        
        // 防止多次快速提交
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self hideKeyBoard];
        
        [ReportObject event:ID_CIRCLE_SHARE_TO_CIRCLE];//2015.06.25
        [Utilities showProcessingHud:self.view];// 2015.05.12
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              ac, @"ac",
                              @"3",@"v",
                              @"post", @"op",
                              text_content.text, @"message",
                              imageArray, @"imageArray",
                              privilege,@"privilege",
                              _shareUrl,@"shareUrl",
                              cids,@"cids",
                              nil];
        
        
        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];

    }else if (_flag == 3){//小视频发布接口
        
        /**
         * 发布个人动态
         * 2016.04.11 添加视频文件上传,  参数: mp0, type
         * @author luke
         * @date 2015.12.25
         * @args
         *  v=3, ac=CircleTeacher op=post, sid=, uid=, message=, [png0..png9]=, privilege=, cids=, shareUrl=, tags=标签ID
         *      mp0=视频文件 type=picture|video
         */
        
         // 文字部分选填
 
            // 防止多次快速提交
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self hideKeyBoard];
            
            [Utilities showProcessingHud:self.view];
        
             if (_thumbImgPath == nil) {
            
                 _thumbImgPath = @"";
              }
        
        
        
            if ([@"PhotoHome" isEqualToString:_fromName]) {
                
                NSString *aid = @"";
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Kindergarten", @"ac",
                                      @"3",@"v",
                                      @"addClassTopic", @"op",
                                      text_content.text, @"title",
                                      _cid,@"cid",
                                      aid,@"aid",
                                      @"video",@"type",
                                      _videoPath,@"mp0",
                                      _thumbImgPath, @"png0",
                                      nil];
                
                [network sendHttpReq:HttpReq_ThreadPhotoSubmitVideo andData:data];
                
            }else{
               
                if (cids == nil) {
                    cids = @"";
                }
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      ac, @"ac",
                                      @"3",@"v",
                                      @"post", @"op",
                                      text_content.text, @"message",
                                      privilege,@"privilege",
                                      cids,@"cids",
                                      @"video",@"type",
                                      _videoPath,@"mp0",
                                      _thumbImgPath, @"png0",
                                      nil];
                
                
                [network sendHttpReq:Http_ThreadMomentsSubmitVideo andData:data];
            }
        
    }
    //--------------------------------------------------------------------------------------------------
    
}

// 判断逻辑
-(void)isDirectTo{
    
    if ([@"1"  isEqual: _growingPathStatusSchool]) {
        // 学校开通了成长空间
        if (nil != _growingPathStatusNumber) {
            if ([@"0"  isEqual: _growingPathStatusNumber]) {
                // 学生并没有绑定成长空间，点击添加至个人成长弹出弹窗提示“绑定身份信息后方可添加至成长足迹”
                TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户，在您开通成长空间后可为自己的动态添加标签，让老师更方便的看到丰富的你。"];
                
                [alert addBtnTitle:@"直接发布" action:^{
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          ac, @"ac",
                                          @"3",@"v",
                                          @"post", @"op",
                                          text_content.text, @"message",
                                          imageArray, @"imageArray",
                                          privilege,@"privilege",
                                          @"",@"shareUrl",
                                          cids,@"cids",
                                          _tagId, @"tags",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
                    
                }];
                [alert addBtnTitle:@"绑定" action:^{
                    NSDictionary *user = [g_userInfo getUserDetailInfo];
                    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
                    NSString *iden;
                    
                    switch ([usertype integerValue]) {
                        case 0:
                            iden = @"student";
                            break;
                        case 6:
                            iden = @"parent";
                            break;
                        case 7:
                            iden = @"teacher";
                            break;
                        case 9:
                            iden = @"admin";
                            break;
                            
                        default:
                            break;
                    }
                    
                    SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
                    setPVC.viewType = @"growthSpace";
                    setPVC.growingPathStatusUrl = _growingPathStatusUrl;
                    setPVC.publish = 1;
                    setPVC.cId = _cid;
                    setPVC.iden = iden;
                    [self.navigationController pushViewController:setPVC animated:YES];
                }];
                
                [alert showAlertWithSender:self];
            }else {
                // 学生绑定了成长空间
                // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
                if ([@"0"  isEqual: _growingPathStatusSpace]) {
                    // 未开通
                    TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户，在您开通成长空间后可为自己的动态添加标签，让老师更方便的看到丰富的你。"];
                    
                    [alert addBtnTitle:@"直接发布" action:^{
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              ac, @"ac",
                                              @"3",@"v",
                                              @"post", @"op",
                                              text_content.text, @"message",
                                              imageArray, @"imageArray",
                                              privilege,@"privilege",
                                              @"",@"shareUrl",
                                              cids,@"cids",
                                              _tagId, @"tags",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
                        
                    }];
                    [alert addBtnTitle:@"去开通" action:^{
                        
                        // to do:trial
                        if ([_growingPathStatusSpace integerValue] == 0 && [_trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
                            
                            PayViewController *growVC = [[PayViewController alloc] init];
                            growVC.fromName = @"publish";
                            growVC.cId = _cid;
                            growVC.spaceStatus = _growingPathStatusSpace;
                            growVC.isTrial = _trial;
                            [self.navigationController pushViewController:growVC animated:YES];
                            
                        }else{
                            
                            GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
                            growVC.fromName = @"publish";
                            growVC.cId = _cid;
                            growVC.urlStr = _growingPathStatusUrl;
                            growVC.spaceStatus = _growingPathStatusSpace;
                            growVC.isBind = _growingPathStatusNumber;
                            growVC.isTrial = _trial;
                            [self.navigationController pushViewController:growVC animated:YES];
                            
                        }
                        
                    }];
                    
                    [alert showAlertWithSender:self];
                    
                }else if (([@"3"  isEqual: _growingPathStatusSpace]) || ([@"4"  isEqual: _growingPathStatusSpace])) {
                    // 到期欠费了
                    TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户，在您开通成长空间后可为自己的动态添加标签，让老师更方便的看到丰富的你。"];
                    
                    [alert addBtnTitle:@"直接发布" action:^{
                        
                        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              REQ_URL, @"url",
                                              ac, @"ac",
                                              @"3",@"v",
                                              @"post", @"op",
                                              text_content.text, @"message",
                                              imageArray, @"imageArray",
                                              privilege,@"privilege",
                                              @"",@"shareUrl",
                                              cids,@"cids",
                                              _tagId, @"tags",
                                              nil];
                        
                        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
                        
                    }];
                    [alert addBtnTitle:@"立即续费" action:^{
                        
                        PayViewController *pvc = [[PayViewController alloc] init];
                        pvc.fromName = @"publish";
                        pvc.cId = _cid;
                        [self.navigationController pushViewController:pvc animated:YES];
                        
                    }];
                    
                    [alert showAlertWithSender:self];
                    
                }else {
                    
                    // 已经获取到了标签
                    if (nil != _tagsArray) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{//要放在主线程里才能立即执行 2015.11.05
                            
                            NSMutableArray *array = [[NSMutableArray alloc]init];
                            
                            for (NSInteger i = 0; i < [_tagsArray count]; i++) {
                                NSString *string = [[_tagsArray objectAtIndex:i] objectForKey:@"pic"];
                                JKPopMenuItem *item = [JKPopMenuItem itemWithTitle:string image:string];
                                [array addObject:item];
                            }
                            
                            JKPopMenuView *jkpop = [JKPopMenuView menuViewWithItems:_tagsArray];
                            jkpop.delegate = self;
                            [jkpop show2];
                            
                        });
                        
                       
                    }else {
                        // 没有获取到标签，需要重新获取
                        [self doGetMomentsTags:NO];
                    }
                    
                }
            }
        }else {
            // 重新获取开通成长空间状态
            [self doGetGrowingPathStatus];
            
        }
        
    }else{
        // 学校未开通直接发布
        // 防止多次快速提交
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self hideKeyBoard];
        
        [ReportObject event:ID_CIRCLE_POST];
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              ac, @"ac",
                              @"3",@"v",
                              @"post", @"op",
                              text_content.text, @"message",
                              imageArray, @"imageArray",
                              privilege,@"privilege",
                              @"",@"shareUrl",
                              cids,@"cids",
                              nil];
        
        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
        
    }
}

- (void)retrySubmit
{
    
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if([touch.view isMemberOfClass:[TSTouchImageView class]]) {
//        //放过以上事件的点击拦截
//
//        return NO;
//    }else{
//
//        UIView* v=[touch.view superview];
//
//        // 特殊放过tableViewCell的点击事件
//        //        if([v isMemberOfClass:[Test1TableViewCell class]]) {
//        //            return NO;
//        //        }
//
//        return YES;
//    }
//}

#pragma mark App JKPopMenuViewSelectDelegate
- (void)popMenuViewSelectIndex:(NSInteger)index
{
    NSLog(@"%s",__func__);
    
    if (-1 != index) {
        NSDictionary *dic = [_tagsArray objectAtIndex:index];
        _tagId = [dic objectForKey:@"id"];
    }else {
        _tagId = nil;
    }
    
    if ([text_content.text isEqualToString:@""] && [imageArray count] == 0) {
        
        [self.view makeToast:@"请添加内容文字或图片"
                    duration:0.5
                    position:@"center"
                       title:nil];
    }else {
        // 防止多次快速提交
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self hideKeyBoard];
        
        [ReportObject event:ID_CIRCLE_POST];
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              ac, @"ac",
                              @"3",@"v",
                              @"post", @"op",
                              text_content.text, @"message",
                              imageArray, @"imageArray",
                              privilege,@"privilege",
                              @"",@"shareUrl",
                              cids,@"cids",
                              _tagId, @"tags",
                              nil];
        
        [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
    }
    
}

-(void)viewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic
{
    NSLog(@"%s",__func__);
    
    NSDictionary *dic1 = [_tagsArray objectAtIndex:index];
    NSString *tag = [dic1 objectForKey:@"tag"];

}

- (BOOL)isUrl:(NSString*)url
{
    //NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    
    //NSString *regex = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(?=/|$)";
    
    NSString *regex = @"(([^\\.]+)\\.)+[^\\.]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:url];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       
    NSString *result = [resultJSON objectForKey:@"result"];
    
   
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    if(true == [result intValue])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                       message:[resultJSON objectForKey:@"message"]
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        if ([@"classPhotoList" isEqualToString:_fromName]) {
            //刷新班级最新相册列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassNewPhoto" object:nil];
            //刷新相册tab列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
            
            if (_isFromAlbum) {//刷新相册详情
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollectionDetail" object:nil];
            }
            
        }else if ([@"PhotoHome" isEqualToString:_fromName]){
            
            //刷新班级最新相册列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassNewPhoto" object:nil];
            
        }
       

    }else{
        
        [Utilities showAlert:@"错误" message:[resultJSON objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }

}

-(void)reciveHttpDataError:(NSError*)err
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    [Utilities showAlert:@"错误" message:@"网络连接错误，请稍候再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    
}



// 点击+号添加图片
-(void)create_btnclick:(id)sender{
    
    sender_btn = sender;
    
    UIButton *button = (UIButton *)sender;
    pressButtonTag = button.tag;
    
    UIImage *img = [UIImage imageNamed:@"addImg_press.png"];
    
    if (![Utilities image:button.imageView.image equalsTo:img]) {
        
        //---update 2015.06.12--------------------------------------------------------
        /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"要删除图片吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消"
                                  , nil];
        
        alertView.tag = 8;
        [alertView show];*/
        
        [text_content resignFirstResponder];
        pics = [[NSMutableArray alloc] init];
        for (int i =0; i<[self.assetsAndImgs count]; i++) {
            
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                
                ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                [pics addObject:image];
            }else{
                
                UIImage *image = [self.assetsAndImgs objectAtIndex:i];
                [pics addObject:image];
            }
        }
        
       
        UIImage *image = nil;
        if ([[self.assetsAndImgs objectAtIndex:pressButtonTag-1] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:pressButtonTag-1];
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            image = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
        }else{
            
            image = [self.assetsAndImgs objectAtIndex:pressButtonTag-1];
        }
        
        //NSInteger pos = [Utilities findStringPositionInArray:pics andImg:image];
        NSInteger pos = pressButtonTag - 1;
        
        FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
        fullImageViewController.assetsArray = self.assetsAndImgs;
        fullImageViewController.currentIndex = pos;
        [self.navigationController pushViewController:fullImageViewController animated:YES];
        
        
    } else {
        
        /*//---update by kate 2014.11.6
         //---移动到actionsheet中
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
        }*/
        
        //-------------------------------------------------------------------------------------
        //done:加入拍照选择图片功能，弹出UIActionSheet 文言:“拍照，从手机相册选择，取消” 2015.04.10
        
        if (!self.assetsAndImgs) {
            self.assetsAndImgs = [[NSMutableArray alloc]init];
        }
        
        [text_content resignFirstResponder];
        if (!alertSheet) {
             alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        }
        [alertSheet showInView:self.view];
        
    }
}

// add 2015.04.10
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
//        //拍照
//        if (nil == imagePickerController) {
//            imagePickerController = [[UIImagePickerController alloc] init];
//            
//        }
//        imagePickerController.delegate = self;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePickerController.allowsEditing = NO;
        
        //[self performSelector:@selector(showCamera) withObject:nil afterDelay:1.0];
        [Utilities takePhotoFromViewController:self];
        
    }else if (buttonIndex == 1){
        //从手机相册选择
        if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
        [self.assets removeAllObjects];
        
        photoNum = 0;
        
        for (int i=0; i<[self.assetsAndImgs count]; i++) {
            
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                photoNum ++;
            }
            
        }
        
        //if (!picker) {
          CTAssetsPickerController  *picker = [[CTAssetsPickerController alloc] init];
        //}
       
        picker.assetsFilter         = [ALAssetsFilter allPhotos];
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
        
        
        // iPad
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.popover.delegate = self;
            
            [self.popover presentPopoverFromBarButtonItem:sender_btn
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
        }
        else
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

-(void)showCamera{
    
   
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }
    [self presentViewController:imagePickerController animated:YES completion:^{
        NSLog(@"打开照相机");
       [imagePickerController setShowsCameraControls:YES];
    }];
    
//    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
//        [imagePickerController setShowsCameraControls:NO];
//        [self presentViewController:imagePickerController animated:YES completion:^{
//            [imagePickerController setShowsCameraControls:YES];
//        }];
//    } else {
//        [imagePickerController setShowsCameraControls:YES];
//        [self presentModalViewController:imagePickerController animated:YES];
//    }
    
  
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
      if (8 == alertView.tag) {
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
            
          
            for (int i=0; i<[buttonFlagViewArray count]; i++) {
                [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
            }
            
          
            
            [buttonFlagViewArray removeLastObject];
            
            NSLog(@"delete count:%d",[buttonArray count]);
            
            // 设置显示加号的button的图片
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
            
            //-----update by kate 2014.10.09-------------
            // 重新按顺序显示array中所有button
            
            [self showImageButtonArray];
            if ([buttonArray count] == 1) {
                [self.assets removeAllObjects];
                [self.assetsAndImgs removeAllObjects];//--update 2015.04.13------
                cameraNum = 0;
                photoNum = 0;
            }else{
                
                //--update 2015.04.13---------------------------------
                //[self.assets removeObjectAtIndex:pressButtonTag-1];//如果是asset类型，这里需要知道在self.assets中的index
                if ([[self.assetsAndImgs objectAtIndex:pressButtonTag -1] isKindOfClass:ALAsset.class]) {
                   
                    photoNum --;
                    
                }else{
                    cameraNum--;
                   
                }
                [self.assetsAndImgs removeObjectAtIndex:pressButtonTag -1];
                //-----------------------------------------------------------
            }
            
            
            
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
            
            
      }else if(222 == alertView.tag){
          
          [text_content resignFirstResponder];
          [urlTextF resignFirstResponder];
          
          //cidsForPublish
          [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cidsForPublish"];
          [[NSUserDefaults standardUserDefaults]synchronize];
          
          [network cancelCurrentRequest];
          
          if (_flag == 3) {
              
              if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                  
                  [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
                  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:NO];
                  
              }else{
                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
              }
              
          }else{
          
              if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                  
                  [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
                  [self.navigationController popViewControllerAnimated:NO];
              }else{
                  [self.navigationController popViewControllerAnimated:YES];
              }
              
          }
          
         
          
      }else{
          
            [text_content resignFirstResponder];
            [urlTextF resignFirstResponder];
          
           [self disablesAutomaticKeyboardDismissal];//iOS9
          
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.4];

//            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView1" object:nil];
//
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        // nothing
    }
}

-(void)testFinishedLoadData{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView1" object:nil];
    
    if (_flag == 3) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
   
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [text_content resignFirstResponder];
    [urlTextF resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}

//---add by kate 2014.10.08-----------------------------------------------------------------------------

-(void)showImageButtonArray
{
    for (int i=0; i<[buttonFlagViewArray count]; i++) {
        [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
    }
    
    
    NSLog(@"show array count:%d",[buttonArray count]);
    /*for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%d",i,((UIButton*)[buttonArray objectAtIndex:i]).tag);
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        //[((UIButton*)[buttonArray objectAtIndex:i]) removeFromSuperview];
        //[self removeButtonWithTag:((UIButton*)[buttonArray objectAtIndex:i]).tag];
        [addImageView addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        if (i<=3) {
            addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, 320, 110 + 10);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1)+50*i,
                                                                          20,
                                                                          50,
                                                                          50);
        } else if (i>3 && i<=7) {
            addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, 320, 160+20 + 10);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-4)+50*(i-4),
                                                                          20+50+12,
                                                                          50,
                                                                          50);
        } else if (i>7 && i <9) {
                        addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, 320, 220+20 + 10);
            
                        ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(24*(i+1-8)+50*(i-8),
                                                                                      20+50+12+50+12,  //cao
                                                                                      50,
                                                                                      50);
        }
    }*/
    
    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%ld",i,(long)((UIButton*)[buttonArray objectAtIndex:i]).tag);
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        //[((UIButton*)[buttonArray objectAtIndex:i]) removeFromSuperview];
        //[self removeButtonWithTag:((UIButton*)[buttonArray objectAtIndex:i]).tag];
       [addImageView addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        if (i<=3) {
            
            addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, WIDTH, 70.0+19.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i)+70*i,
                                                                          0,
                                                                          70,
                                                                          70);
        } else if (i>3 && i<=7) {
            
            addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, WIDTH, 140.0+19.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-4)+70*(i-4),
                                                                          0+70+5,
                                                                          70,
                                                                          70);
        } else if (i>7 && i <9) {
            
            addImageView.frame = CGRectMake(addImageView.frame.origin.x, addImageView.frame.origin.y, WIDTH, 210.0+19.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-8)+70*(i-8),
                                                                          0+70+5+70+5,  //cao
                                                                          70,
                                                                          70);
        }
    }
    
     //whoCanViewBtn.frame = CGRectMake(0, addImageView.frame.size.height - 40.0, [UIScreen mainScreen].bounds.size.width, 40.0);
    whiteViewLeft.frame = CGRectMake(0, addImageView.frame.origin.y, 12.0, addImageView.frame.size.height);
    whiteViewRight.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-12.0, addImageView.frame.origin.y, 12.0, addImageView.frame.size.height);
    
   seprateLine.frame = CGRectMake(0, addImageView.frame.size.height+addImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 0.7);
   
    whoCanViewBtn.frame = CGRectMake(0, seprateLine.frame.origin.y+0.7+20.0, [UIScreen mainScreen].bounds.size.width, 45.0);
    
    if ([buttonArray count] -1 >0) {
        
        photoFlagImageView.hidden = NO;
       
        
    }else{
        photoFlagImageView.hidden = YES;
       
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
    
    if(buttonArray.count > 1){
        
//        for (int i=0; i<[self.assets count]; i++) {
        UIImage *image = nil;
        for (int i=0; i<[self.assetsAndImgs count]; i++) {// update 2015.04.13

            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
            
//            ALAsset *asset = [self.assets objectAtIndex:i];
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                
                ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                //获取资源图片的详细资源信息
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                //获取资源图片的高清图
                //[representation fullResolutionImage];
                //获取资源图片的全屏图
                //[representation fullScreenImage];
                
                image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
            }else{
                image = [self.assetsAndImgs objectAtIndex:i];
                UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                image = [Utilities fixOrientation:tempImage];

            }
           
           
            
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
            data = UIImageJPEGRepresentation(image, 0.3);
            
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
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
}



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
    
    /*self.assets = [NSMutableArray arrayWithArray:assets];
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    for (int i=0; i<[self.assets count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"moments/tj.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"moments/tj_p.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        ALAsset *asset = [self.assets objectAtIndex:i];
        UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"moments/tj.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"moments/tj_p.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];*/
    
    //-----update 2015.04.13 加入拍照功能----------------
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
//    if ([self.assetsAndImgs count] > 0) {
        
//        for (int i=0; i<[self.assets count]; i++) {
//            
//            ALAsset *assetNew = [self.assets objectAtIndex:i];
//            UIImage *imgNew = [UIImage imageWithCGImage:assetNew.thumbnail];
//            
//            for (int j=0; j<[self.assetsAndImgs count]; j++) {
//                
//                if ([[self.assetsAndImgs objectAtIndex:j] isKindOfClass:ALAsset.class]) {
//                    
//                    
//                    ALAsset *assetOld = [self.assetsAndImgs objectAtIndex:j];
//                    UIImage *imgOld = [UIImage imageWithCGImage:assetOld.thumbnail];
//                    
//                    if ([Utilities image:imgNew equalsTo:imgOld]) {
//                        NSLog(@"一致");
//                        
//                    }else{
//                        
//                        [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
//                    }
// 
//                }
//                
//            }
//            
//        }
        
//    }else{
//        
//        for (int i=0; i<[self.assets count]; i++) {
//            [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
//        }
//        
//    }
        for (int i=0; i<[self.assets count]; i++) {
            [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
        }

  
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    UIImage *img = nil;
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];
    //--------------------------------------------------

    
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
    BOOL selectPhoto = NO;
    
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
    //if (picker.selectedAssets.count >= 9)
    //else if ((picker.selectedAssets.count + cameraNum) >= 9)// update 2015.04.13
    else
    {
        if ((photoNum+cameraNum) >= 9){// update 2015.04.13
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)picker.selectedAssets.count]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
            
        selectPhoto = NO;
            
        }else{
        
           photoNum ++;
            selectPhoto = YES;
         }
    }
    
    //return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
    return (selectPhoto && asset.defaultRepresentation != nil);// update 2015.04.13
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(ALAsset *)asset{
    
    photoNum -- ;
    return YES;
}

// add 2015.04.10
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
    //NSLog(@"拍照成功后放入图片数组");
    [self.assetsAndImgs addObject:image];
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    UIImage *img = nil;
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
     [picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];

    cameraNum++;
    
}

//--------------------------------------------------------------------------------------

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 键盘下落
    [text_content resignFirstResponder];
    NSLog(@"scrollViewDidEndDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 键盘下落
    NSLog(@"scrollViewDidScroll");
}


//-----------------------------------------------------

- (void)keyboardWillShow:(NSNotification *)notification {
    
    if ([text_content isFirstResponder]) {
        
        toolBar.hidden = NO;
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
                         
                         
                         CGRect frame = toolBar.frame;
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
                
            default:
                break;
        }
    }
    }else{
        
        toolBar.hidden = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if ([text_content isFirstResponder]){
    
        toolBar.hidden = YES;
        
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
    }else{
        
        toolBar.hidden = YES;
    }
   
}

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



- (void)keyboardDidHide:(NSNotification *)notification {
    
    
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [text_content.inputView isEqual:faceBoard]) {
                    
                    isSystemBoardShow = YES;
                    text_content.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    //                    if (keyboardButton.imageView.image == img) {
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        text_content.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        text_content.inputView = faceBoard;
                        
                    }
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    text_content.inputView = faceBoard;
                    
                }
            }
                
                break;
                
            default:
                break;
        }
        
        [text_content becomeFirstResponder];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText
{
    float fHeight = textView.contentSize.height;
    return fHeight;
}

- (void)textViewDidChange:(UITextView *)_textView {
    
    //_textView.textColor = [UIColor blackColor];
    if (_textView == text_content){
        
        if ([_textView.text length] == 0) {
            placeHoderLabel.hidden = NO;
        }else{
            placeHoderLabel.hidden = YES;
        }
        
    }else{
        
        if ([_textView.text length] == 0) {
            placeHoderUrlLabel.hidden = NO;
        }else{
            placeHoderUrlLabel.hidden = YES;
        }
    }
    
    
   /* float fHeight = [self heightForTextView:text_content WithText:text_content.text];
    
    if (IS_IPHONE_5) {
        fHeight = [self heightForTextView:text_content WithText:text_content.text] - 90;
    }else{
        fHeight = [self heightForTextView:text_content WithText:text_content.text] - 60;
    }
    
    CGRect g = text_content.frame;
    g.size.height = fHeight;
    
    if (IS_IPHONE_5) {
        
        if (fHeight > 120.0+30) {
            
            [text_content setFrame:g];
            _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
            _scrollerView.contentOffset = CGPointMake(0, fHeight);
            
        }
        
    }else{
        
        if (fHeight > 120.0) {
            [text_content setFrame:g];
            _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
            _scrollerView.contentOffset = CGPointMake(0, fHeight);
            
        }
    }*/
    
}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
#if 0
    //2015.11.02志伟确认 完成变成换行
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
#endif
    
    if (textView == text_content) {
        placeHoderLabel.hidden = YES;
    }else{
        placeHoderUrlLabel.hidden = YES;
    }
    
    
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
//            return NO;
//        }
        
        return YES; //update by kate 2015.01.26 解决光标定在中间删除不了的问题，但是这样表情就不能按一次退格键删除,修改backFace方法还是不能二者兼得。
    }
    else {
        
        if (range.location >= 5000) {// 校友圈发帖 5000 2015.07.21
                    return NO;
        }
        
        return YES;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
//    [UIView setAnimationDuration:0.20];
//    if (iPhone5) {
//        _scrollerView.contentOffset = CGPointMake(0, 60 );
//    } else {
//        _scrollerView.contentOffset = CGPointMake(0, 60 );
//    }
//    [UIView commitAnimations];
//    if ([text_content.text isEqualToString:@"这一刻想说的..."]) {
//        text_content.text = @"";
//        text_content.textColor = [UIColor blackColor];
//    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationDuration:0.20];
    _scrollerView.contentOffset = CGPointMake(0, 0 );
    [UIView commitAnimations];
    
//    if ([text_content.text isEqualToString:@""]) {
//        text_content.text = @"";
//        text_content.textColor = [UIColor lightGrayColor];
//    }
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if([_fromName isEqualToString:@"class"]){
       
        if ([privilege intValue] == 32) {
            typeLabel.text = @"公开";
            cids = _cid;
        }else if ([privilege intValue] == 1){
            typeLabel.text = @"私密";
        }else if ([privilege intValue] == 16){
            
//            typeLabel.text = _cName;
            typeLabel.text = @"公开";

            cids = _cid;
            
            NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray2"];
            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
            NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
            //NSLog(@"userType:%@",userType);
            
            if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
            {
            
                if([array count] > 0){
                    NSString *str = @"";
                    NSString *cidForTeacher = @"";
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        NSString *isChecked = [[array objectAtIndex:i]objectForKey:@"isChecked"];
                        NSString *cName = [[array objectAtIndex:i]objectForKey:@"cName"];
                        NSString *cid = [[array objectAtIndex:i] objectForKey:@"cid"];
                        
                        
                        if ([isChecked intValue] == 1) {
                            
                            if([str length] == 0){
                                str = cName;
                            }else{
                                str = [str stringByAppendingFormat:@",%@",cName];
                            }
                            if([cidForTeacher length] == 0){
                                cidForTeacher = cid;
                            }else{
                                cidForTeacher = [cidForTeacher stringByAppendingFormat:@",%@",cid];
                            }
                            
                        }
                    }
                    typeLabel.text = str;
                    if ([cidForTeacher length]>0) {
                        cids = cidForTeacher;
                    }
                }
                
                
            }
            
        }
    
    }else if ([@"classPhotoList" isEqualToString:_fromName]){
       
        
        
    }else{
        
        NSString *cidsForPublish = [[NSUserDefaults standardUserDefaults]objectForKey:@"cidsForPublish"];
        NSString *cNamesForPublish = [[NSUserDefaults standardUserDefaults]objectForKey:@"cNamesForPublish"];
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray2"];
        
        if(privilege == nil){
            
            typeLabel.text = @"公开";
            
        }else{
            if ([privilege intValue] == 32) {
                typeLabel.text = @"公开";
            }else if ([privilege intValue] == 1){
                typeLabel.text = @"私密";
            }else if ([privilege intValue] == 16){
                
                typeLabel.text = cNamesForPublish;
                
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
                //NSLog(@"userType:%@",userType);
                
                if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
                {
                    if ([privilege intValue] == 16) {
                        
                        NSString *str = @"";
                        NSString *cidForTeacher = @"";
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            
                            NSString *isChecked = [[array objectAtIndex:i]objectForKey:@"isChecked"];
                            NSString *cName = [[array objectAtIndex:i]objectForKey:@"cName"];
                            NSString *cid = [[array objectAtIndex:i] objectForKey:@"cid"];
                            
                            
                            if ([isChecked intValue] == 1) {
                                
                                if([str length] == 0){
                                    str = cName;
                                }else{
                                    str = [str stringByAppendingFormat:@",%@",cName];
                                }
                                if([cidForTeacher length] == 0){
                                    cidForTeacher = cid;
                                }else{
                                    cidForTeacher = [cidForTeacher stringByAppendingFormat:@",%@",cid];
                                }
                                
                            }
                        }
                        typeLabel.text = str;
                        if ([cidForTeacher length]>0) {
                            cids = cidForTeacher;
                        }
                    }
                }else{
                    
                    if ([cidsForPublish length] >0) {
                        cids = cidsForPublish;
                    }
                }
                
            }
        }
        
    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

// 删除照片
-(void)deletePhoto:(NSNotification*)notification{
    
    // done: 在查看大图页点击删除走回这个方法,将index传回来
    NSString *currentIndex = (NSString*)[notification object];
    pressButtonTag = [currentIndex integerValue]+1;
    
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
    
    
    for (int i=0; i<[buttonFlagViewArray count]; i++) {
        [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
    }
    
    [buttonFlagViewArray removeLastObject];
    
    NSLog(@"delete count:%d",[buttonArray count]);
    
    // 设置显示加号的button的图片
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    
    //-----update by kate 2014.10.09-------------
    // 重新按顺序显示array中所有button
    
    [self showImageButtonArray];
    if ([buttonArray count] == 1) {
        [self.assets removeAllObjects];
        [self.assetsAndImgs removeAllObjects];//--update 2015.04.13------
        cameraNum = 0;
        photoNum = 0;
    }else{
        
        //--update 2015.04.13---------------------------------
        //[self.assets removeObjectAtIndex:pressButtonTag-1];//如果是asset类型，这里需要知道在self.assets中的index
        if ([[self.assetsAndImgs objectAtIndex:pressButtonTag -1] isKindOfClass:ALAsset.class]) {
            
            photoNum --;
            
        }else{
            cameraNum--;
            
        }
        [self.assetsAndImgs removeObjectAtIndex:pressButtonTag -1];
        //-----------------------------------------------------------
    }
    
    [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;

    
}

- (void)doGetMomentsTags:(BOOL)isFirstGet
{
    /**
     * 校友圈标签列表
     * @author luke
     * @date 2015.12.20
     * @args
     *  v=3, ac=Circle, op=tags, sid=, cid=, uid=, number=
     */

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Circle",@"ac",
                          @"3",@"v",
                          @"tags", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSArray *tags = [respDic objectForKey:@"message"];
            
            _tagsArray = [NSMutableArray arrayWithArray:tags];
            
            if (!isFirstGet) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                
                for (NSInteger i = 0; i < [_tagsArray count]; i++) {
                    NSString *string = [[_tagsArray objectAtIndex:i] objectForKey:@"pic"];
                    JKPopMenuItem *item = [JKPopMenuItem itemWithTitle:string image:string];
                    [array addObject:item];
                }
                
                JKPopMenuView *jkpop = [JKPopMenuView menuViewWithItems:_tagsArray];
                jkpop.delegate = self;
                [jkpop show2];
            }
        } else {
            if (!isFirstGet) {
                [Utilities showTextHud:@"获取标签失败，请稍后再试" descView:self.view];
            }
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        if (!isFirstGet) {
            [Utilities showTextHud:@"获取标签失败，请稍后再试" descView:self.view];
        }
    }];

}



@end

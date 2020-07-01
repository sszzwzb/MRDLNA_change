
//
//  HomeworkSubmitViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-6.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeworkSubmitViewController.h"
#import "CTAssetsPickerController.h"// add by kate 2014.10.08
#import "Toast+UIView.h"

@interface HomeworkSubmitViewController ()<CTAssetsPickerControllerDelegate,UIPopoverControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIPopoverController *popover;
@end

@implementation HomeworkSubmitViewController

// audio
static double startRecordTime = 0;
static double endRecordTime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [super setCustomizeTitle:@"发表新作业"];
        [super setCustomizeTitle:@"编辑"];
        [super setCustomizeLeftButton];
        [super setCustomizeRightButtonWithName:@"发布"];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        //mutable_photoList =[[NSMutableArray alloc] init];
        //imageArray =[[NSMutableDictionary alloc] init];

//        pressButtonTag = 1;
//        imagePath1 = @"";
//        imagePath2 = @"";
//        imagePath3 = @"";
        
        imageArray = [[NSMutableDictionary alloc] init];
        buttonArray = [[NSMutableArray alloc] init];
        buttonFlagViewArray = [[NSMutableArray alloc] init];
        
        amrPath = @"";

        // 导航右菜单，提交
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightButton setBackgroundColor:[UIColor clearColor]];
//        rightButton.frame = CGRectMake(280, 0, 40, 40);
//        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
//        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateSelected];
//        [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
//        //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
//        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem = rightBarButton;
        
        //注册通知,监听键盘弹出事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        
        //注册通知,监听键盘消失事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

-(void)selectRightAction:(id)sender
{
    // 防止多次快速提交
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self hideKeyBoard];
    
    if (_flag == 2) {//管理员发布公告
        
        if(text_title.text.length == 0)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                           message:@"标题不能为空，请重新输入"
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            [alert show];
            [self.view makeToast:@"请输入标题"
                        duration:0.5
                        position:@"center"
                           title:nil];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else if(([@"内容" isEqual:text_content.text]) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                           message:@"内容不能为空，请重新输入"
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            [alert show];
            [self.view makeToast:@"请输入内容文字或添加图片"
                        duration:0.5
                        position:@"center"
                           title:nil];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else
        {
            [Utilities showProcessingHud:self.view];
            
            UIColor *color = [UIColor lightGrayColor];
            if (text_content.textColor == color) {
                text_content.text= @"";
            }
            
            /*管理员发布公告接口
             调用url:
             /weixiao/api.php
             调用参数:
             ac:'News',op:'postNews',v:'2',sid:'3151',uid:'63228',type:'1',name:' 校园公告',subject:'终端发表公告标题',message:'终端发表公告内容 ',png0:TestUtils.getFile('images/2012100413195471481.jpg'),png1:TestUtils.getFile('images/2012100413195471481.jpg')
             iscomment 0:NO, 1:YES
             成功返回:
             {
             "protocol": "NewsAction.postNews",
             "result": true,
             "message": ""
             }*/
            
            [self saveButtonImageToFile];
            NSString *iscomment = @"0";
            if(allowSwitch.isOn){
                iscomment = @"1";
            }
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"postNews", @"op",
                                  @"2",@"v",
                                  @"1", @"type",
                                  _modelName, @"name",
                                  text_title.text, @"subject",
                                  text_content.text, @"message",
                                  iscomment, @"iscomment",
                                  imageArray, @"imageArray",
                                  nil];
            
            [network sendHttpReq:HttpReq_CustomThreadSubmit andData:data];
            
        }
        
    }else{
        if(text_title.text.length == 0)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
//                                                           message:@"标题不能为空，请重新输入"
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            [alert show];
            [self.view makeToast:@"请输入标题"
                        duration:0.5
                        position:@"center"
                           title:nil];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        /*//update by kate 2015.07.03 Bug 1502
         else if((text_title.text.length <= 2) && (text_title.text.length != 0))
         {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
         message:@"标题太短，请重新输入"
         delegate:nil
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil];
         [alert show];
         self.navigationItem.rightBarButtonItem.enabled = YES;
         }*/
        // 作业改版去掉了时间
#if 1 // 发布作业只输入标题又不行了还要输入时间 志伟确认 boss需求 2015.01.08
        else if(text_time.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"时间不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
#endif
        /* 发布作业只输入标题就行 志伟确认 2015.12.07
         else if(([@"请输入作业内容" isEqual:text_content.text]) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"内容不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }*/
        else
        {
            [Utilities showProcessingHud:self.view];
            
            NSString *cid = [g_userInfo getUserCid];
            
            NSDictionary *detailDic = [g_userInfo getUserDetailInfo];
            NSString* name= [detailDic objectForKey:@"name"];
            
            //[op=postthread&threadtype=1&topicid=0&sid=3074&cid=5078&uid=51987&username=大卫黄瓜丝&subject=lukelu&message=test ]
            
            /*
             1.输入标题 2。输入分钟 3.点击语音录音 4.点击图片加图 5.点击表情加表情 6.发送
             */
            
            UIColor *color = [UIColor lightGrayColor];
            if (text_content.textColor == color) {
                text_content.text= @"";
            }
            [self saveButtonImageToFile];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Homework", @"ac",
                                  @"post", @"op",
                                  cid, @"cid",
                                  text_title.text, @"subject",
                                  text_content.text, @"message",
                                  text_time.text, @"time",
                                  amrPath, @"amr0",
                                  imageArray, @"imageArray",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadSubmit andData:data];
        }
    }
    
    
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    UIImageView *imgView_bg_down =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height -44)];
    [imgView_bg_down setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bg_down];
    
    
    CGRect rect;
    // 设置背景scrollView
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//    {
//        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
//    }
//    else
//    {
//        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 20);
//    }
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    // 标题
    text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, 310, 30)];
    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkTitle"];
    if (2 != _flag) {
        if (nil == value) {
            text_title.placeholder = @"标题(必填)";
        }else {
            text_title.text = value;
        }
    }else {
        text_title.placeholder = @"标题(必填)";
    }
    
    text_title.font = [UIFont fontWithName:@"Arial" size:18.0f];
    text_title.textColor = [UIColor blackColor];
    text_title.clearButtonMode = UITextFieldViewModeAlways;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    [text_title becomeFirstResponder];
    [_scrollerView addSubview:text_title];
    
    // 线
    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                            text_title.frame.origin.y + text_title.frame.size.height + 10,
                                                                            [UIScreen mainScreen].bounds.size.width,
                                                                            1)];
    imgView_line.image=[UIImage imageNamed:@"lineSystem.png"];
    [_scrollerView addSubview:imgView_line];
    
    // 预计时间文字
    label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               text_title.frame.origin.x,
                                                               imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
                                                               130,
                                                               15)];
   
    if (_flag == 2) {//自定义公告
        label_username.text = @"是否允许用户评论";
    }else{
       label_username.text = @"预计完成时间(分钟):";
    }
    
    label_username.lineBreakMode = NSLineBreakByWordWrapping;
    label_username.font = [UIFont systemFontOfSize:14.0f];
    label_username.numberOfLines = 0;
    label_username.textColor = [UIColor grayColor];
    label_username.backgroundColor = [UIColor clearColor];
    label_username.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_username];

    if (_flag == 2) {//自定义公告
        
        allowSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60.0,
                                                                 imgView_line.frame.origin.y + imgView_line.frame.size.height+2,
                                                              100.0, 20.0)];
        allowSwitch.onTintColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        [_scrollerView addSubview:allowSwitch];
        
    }else{
        // 预计时间
        text_time = [[UITextField alloc]initWithFrame:CGRectMake(label_username.frame.origin.x + label_username.frame.size.width + 3,
                                                                 imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
                                                                 310, 15)];
        text_time.borderStyle = UITextBorderStyleNone;
        text_time.backgroundColor = [UIColor clearColor];
        text_time.placeholder = @"";
        text_time.font = [UIFont fontWithName:@"Arial" size:14.0f];
        text_time.textColor = [UIColor blackColor];
        text_time.clearButtonMode = UITextFieldViewModeAlways;
        text_time.textAlignment = NSTextAlignmentLeft;
        text_time.keyboardType=UIKeyboardTypeNumberPad;
        text_time.returnKeyType =UIReturnKeyDone;
        text_time.delegate = self;
        [_scrollerView addSubview:text_time];
    }
    
    // 线
    UIImageView *imgView_line2 =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                             label_username.frame.origin.y + label_username.frame.size.height + 10,
                                                                             [UIScreen mainScreen].bounds.size.width,
                                                                             1)];
    imgView_line2.image=[UIImage imageNamed:@"lineSystem.png"];
    [_scrollerView addSubview:imgView_line2];

    // 初始化
    if (IS_IPHONE_5) {
        // 作业改版，预计完成时间不要了 2015.11.24
        // 作业又改版，预计时间又回来了 2015.12.28
        text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                    imgView_line2.frame.origin.y + imgView_line2.frame.size.height + 10, 300, 120+70)];
#if 0
        if (2 != _flag) {
            label_username.hidden = YES;
            imgView_line2.hidden = YES;
            
            text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                        imgView_line.frame.origin.y + imgView_line.frame.size.height + 10, 300, 120+70)];
        }else {
            text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                        imgView_line2.frame.origin.y + imgView_line2.frame.size.height + 10, 300, 120+70)];
        }
#endif
    }else{
        text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                    imgView_line2.frame.origin.y + imgView_line2.frame.size.height + 10, 300, 90)];
#if 0
        if (2 != _flag) {
//            label_username.hidden = YES;
//            imgView_line2.hidden = YES;
            
            text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                        imgView_line.frame.origin.y + imgView_line.frame.size.height + 10, 300, 90)];
        }else {
            text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x,
                                                                        imgView_line2.frame.origin.y + imgView_line2.frame.size.height + 10, 300, 90)];
        }
#endif
    }
    
    NSLog(@"y:%f",text_content.frame.origin.y);
    
    //text_content.contentSize = CGRectMake(10, 0, 300, 130).size ;

    text_content.backgroundColor = [UIColor clearColor];
    
    if (_flag == 2) {
        // 自定义公告
        text_content.text = @"内容";
    }else {
        text_content.text = @"输入作业内容";
    }
    
    text_content.textColor = [UIColor lightGrayColor];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    //是否可以滚动
    text_content.scrollEnabled = YES;
    //[text_content sizeToFit];
    
    //获得焦点
    //[text_content becomeFirstResponder];
    [_scrollerView addSubview:text_content];
    
    // 线
    //imgView_line3 =[[UIImageView alloc]initWithFrame:CGRectMake(0,
    //                                                                         text_content.frame.origin.y + text_content.frame.size.height + 10,
      //                                                                       320,
      //                                                                       1)];
    //imgView_line3.image=[UIImage imageNamed:@"hengxian.jpg"];
    //[_scrollerView addSubview:imgView_line3];

    //    text_content = [[UITextField alloc]initWithFrame:CGRectMake(10, 60, 310, 30)];
    //    text_content.borderStyle = UITextBorderStyleNone;
    //    text_content.backgroundColor = [UIColor clearColor];
    //    text_content.placeholder = @"内容";
    //    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    //    text_content.textColor = [UIColor blackColor];
    //    text_content.clearButtonMode = UITextFieldViewModeAlways;
    //    text_content.textAlignment = NSTextAlignmentLeft;
    //    text_content.keyboardType=UIKeyboardTypeDefault;
    //    text_content.returnKeyType =UIReturnKeyDone;
    //    text_content.delegate = self;
    //    text_content.clearButtonMode = UITextFieldViewModeNever;
    //    [self.view addSubview:text_content];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);

    
    
    
    
    
    
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    
    // 默认状态图片
    UIImage *image_d = [UIImage imageNamed:@"bg_task_photo.png"];
    image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    
    // 添加附件图片背景
//   imgView_bg_photo =[[UIImageView alloc]initWithFrame:CGRectMake(10,
//                                                                             imgView_line3.frame.origin.y + imgView_line3.frame.size.height + 10,
//                                                                             300,
//                                                                             100)];
    //imgView_bg_photo.image = image_d;
    //[_scrollerView addSubview:imgView_bg_photo];
    
    
    
    
    
    
    CGSize buttonSize = {90,90};

    
    UIImage *image_1 = [UIImage imageNamed:@"img_photo_mask.png"];
    UIImage *image_2 = [UIImage imageNamed:@"icon_add_photo.png"];
    
    
    UIGraphicsBeginImageContext(buttonSize);
    [image_1 drawInRect:CGRectMake(0,0,90,90)];
    [image_2 drawInRect:CGRectMake(0,0,90,90)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    
    /*button_photoMask1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button_photoMask1.tag = 1;
    button_photoMask1.frame = CGRectMake(imgView_bg_photo.frame.origin.x + 5,
                              imgView_bg_photo.frame.origin.y + 5,
                              90,
                              90);
    button_photoMask1.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_photoMask1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button_photoMask1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_photoMask1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_photoMask1.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [button_photoMask1 setBackgroundImage:newImage forState:UIControlStateNormal] ;
    [button_photoMask1 setBackgroundImage:newImage forState:UIControlStateHighlighted] ;
    [button_photoMask1 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [_scrollerView addSubview:button_photoMask1];*/


//    button_addPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//    button_addPhoto.frame = CGRectMake(imgView_bg_photo.frame.origin.x + 5,
//                                        5,
//                                        90,
//                                        90);
//    button_addPhoto.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button_addPhoto.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [button_addPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button_addPhoto setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    button_addPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    [button_addPhoto setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
//    [button_addPhoto setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateHighlighted] ;
//    [button_addPhoto addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//    [imgView_bg_photo addSubview:button_addPhoto];
    
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    //keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.frame = CGRectMake(40.0, 5.0, 33.0, 33.0);
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
//    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_d.png"]
//                    forState:UIControlStateNormal];
//    [addImageButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/icon_send_pic_p.png"]
//                    forState:UIControlStateHighlighted];
    [addImageButton addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:addImageButton];
    
    if (_flag == 2) {//自定义公告没有语音
        
    }else{
        AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        AudioButton.frame = CGRectMake(75, 5.0, 33.0, 33.0);
        AudioButton.tag = 124;
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"]
                     forState:UIControlStateNormal];
        [AudioButton setImage:[UIImage imageNamed:@"btn_yy_un.png"]
                     forState:UIControlStateHighlighted];
        //    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_d.png"]
        //                           forState:UIControlStateNormal];
        //    [AudioButton setImage:[UIImage imageNamed:@"btn_yy_p.png"]
        //                           forState:UIControlStateHighlighted];
        [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:AudioButton];
    }
    
    
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
//------------2014.04.24------------------------------------------------

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
    
    
    if (text_content.inputView == addImageView) {
        return;
    }
    
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
        
        //----update by kate 2014.10.10-------------------------------------
        /*UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];*/
        
        /*if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
       // picker.maximumNumberOfSelection = 9 - [self.assets count];
        //picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:NULL];
        //--------------------------------------------------------------------*/
        
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
//------------------------------------------------------------------

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

//-----------------------------------------------------------------------------------
#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        UIImage *scaledImage;
        UIImage *updateImage;
        
        CGSize imageSize = image.size;
        
        // 如果宽度超过720，则按照比例进行缩放，把宽度固定在720
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
        
//        CGSize imageSize1 = updateImage.size;
        
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
    
    [text_content becomeFirstResponder];
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
            [[buttonArray objectAtIndex:([buttonArray count]-1)] removeFromSuperview];
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
            
            // 设置显示加号的button的图片
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            
            //-----update by kate 2014.10.09-----------------------------------------------
            // 重新按顺序显示array中所有button
            //[self showButtonArray];
            [self showImageButtonArray];
            if ([buttonArray count] == 1) {
                [self.assets removeAllObjects];
            }else{
                
                [self.assets removeObjectAtIndex:pressButtonTag-1];
            }
            
            
            
//            if ([buttonFlagViewArray count] > 0) {
//                photoFlagImageView.hidden = NO;
//                photoNumLabel.hidden = NO;
//                photoNumLabel.text = [NSString stringWithFormat:@"%d", ([buttonArray count]-1)];
//            }
//            
//            if (0 == [buttonFlagViewArray count]) {
//                photoFlagImageView.hidden = YES;
//                photoNumLabel.hidden = YES;
//            }
            
            //------------------------------------------------------------------------------------
            
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
            [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
            
            
        }else{
            
            [g_userInfo setIsHomeworkSubmit:@"1"];
            
            // update by kate 2015.07.04
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
//-------------------------------------------------------------------------------------

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
     [self.view endEditing:YES];
     [text_title resignFirstResponder];
     [text_content resignFirstResponder];
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
     
    
    return NO;
}


-(void)submitAction:(id)sender
{
    // 防止多次快速提交
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [self hideKeyBoard];
    
    if (_flag == 2) {//管理员发布公告
        
        if(text_title.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"标题不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else if(([@"内容" isEqual:text_content.text]) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"内容不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else
        {
            [Utilities showProcessingHud:self.view];
            
            UIColor *color = [UIColor lightGrayColor];
            if (text_content.textColor == color) {
                text_content.text= @"";
            }
            
            /*管理员发布公告接口
            调用url:
            /weixiao/api.php
            调用参数:
        ac:'News',op:'postNews',v:'2',sid:'3151',uid:'63228',type:'1',name:' 校园公告',subject:'终端发表公告标题',message:'终端发表公告内容 ',png0:TestUtils.getFile('images/2012100413195471481.jpg'),png1:TestUtils.getFile('images/2012100413195471481.jpg')
             iscomment 0:NO, 1:YES
            成功返回:
            {
                "protocol": "NewsAction.postNews",
                "result": true,
                "message": ""
            }*/
            
            [self saveButtonImageToFile];
            NSString *iscomment = @"0";
            if(allowSwitch.isOn){
                iscomment = @"1";
            }
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"postNews", @"op",
                                  @"2",@"v",
                                  @"1", @"type",
                                  _modelName, @"name",
                                  text_title.text, @"subject",
                                  text_content.text, @"message",
                                  iscomment, @"iscomment",
                                  imageArray, @"imageArray",
                                  nil];
            
            [network sendHttpReq:HttpReq_CustomThreadSubmit andData:data];
            
        }
        
    }else{
        if(text_title.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"标题不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        /*//update by kate 2015.07.03 Bug 1502
         else if((text_title.text.length <= 2) && (text_title.text.length != 0))
         {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
         message:@"标题太短，请重新输入"
         delegate:nil
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil];
         [alert show];
         self.navigationItem.rightBarButtonItem.enabled = YES;
         }*/
        // 作业改版去掉了时间
        // 时间又回来了 yeah！
#if 9
        else if(text_time.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"时间不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
#endif
        else if(([@"请输入作业内容" isEqual:text_content.text]) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"内容不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        /*//update by kate 2015.07.03 Bug 1502
         else if((text_content.text.length <= 2) && (photoNumLabel.hidden == YES) && (audioNumLabel.hidden == YES))
         {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
         message:@"内容太短，请重新输入"
         delegate:nil
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil];
         [alert show];
         self.navigationItem.rightBarButtonItem.enabled = YES;
         }*/
        else
        {
            [Utilities showProcessingHud:self.view];
            
            NSString *cid = [g_userInfo getUserCid];
            
            NSDictionary *detailDic = [g_userInfo getUserDetailInfo];
            NSString* name= [detailDic objectForKey:@"name"];
            
            //[op=postthread&threadtype=1&topicid=0&sid=3074&cid=5078&uid=51987&username=大卫黄瓜丝&subject=lukelu&message=test ]
            
            /*
             1.输入标题 2。输入分钟 3.点击语音录音 4.点击图片加图 5.点击表情加表情 6.发送
             */
            
            UIColor *color = [UIColor lightGrayColor];
            if (text_content.textColor == color) {
                text_content.text= @"";
            }
            [self saveButtonImageToFile];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Homework", @"ac",
                                  @"post", @"op",
                                  cid, @"cid",
                                  text_title.text, @"subject",
                                  text_content.text, @"message",
                                  text_time.text, @"time",
                                  amrPath, @"amr0",
                                  imageArray, @"imageArray",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadSubmit andData:data];
        }
    }
    
  
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

//-------------------------------------------------------------------------------------
#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
////        if (range.location >= 100) {
////            return NO;
////        }
//        
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
        return YES;//update by kate 2015.01.26 解决光标定在中间删除不了的问题，但是这样表情就不能按一次退格键删除,修改backFace方法还是不能二者兼得。
    }
    else {
        
        if (range.location >= 10000) {//班级作业发帖内容 10000
            return NO;
        }
        
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if (IS_IPHONE_5) {
//        textView.frame = CGRectMake(10,textView.frame.origin.y,300.0,130);
//    }else {
//        textView.frame = CGRectMake(10,textView.frame.origin.y,300.0,50);
//    }
    
    
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    
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
                
                if ( [text_content.inputView isEqual:faceBoard] || [text_content.inputView isEqual:addImageView] || [text_content.inputView isEqual:addAudioView]) {
                    
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
                    }else{
                        isSystemBoardShow = NO;
                        text_content.inputView = addAudioView;
                        
                    }
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
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
//---------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;

    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    NSLog(@"resultJSON:%@",resultJSON);
    
    [Utilities dismissProcessingHud:self.view];
    
    [text_content resignFirstResponder];
    [text_time resignFirstResponder];
    [text_content resignFirstResponder];
    
    if(true == [result intValue])
    {
      
        NSString *title = text_title.text;
        
        if (2 != _flag) {
            [[NSUserDefaults standardUserDefaults] setObject:title forKey:[NSString stringWithFormat:@"homeworkTitle"]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                       message:@"发布成功"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        if (_flag == 2) {//刷新新闻列表

            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewsView" object:nil];
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyHomework" object:nil];
            
            // 发作业成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:DataReport_Act_Class_CreateHonework];
            
            [ReportObject event:ID_POST_HOMEWORK];//2015.06.24
        }
        
      
    }
    else
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [g_userInfo setIsHomeworkSubmit:@"1"];//Hi~ beck 不知这句话注释掉是否影响
    
    [self.navigationController popViewControllerAnimated:YES];
}*/

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
    
}


- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText
{
    float fHeight = textView.contentSize.height;
    return fHeight;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
   /* CGRect line = [textView caretRectForPosition:
                   
                   textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height
    
    - ( textView.contentOffset.y + textView.bounds.size.height
       
       - textView.contentInset.bottom - textView.contentInset.top );
    
    if ( overflow > 0 ) {
        
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        
        // Scroll caret to visible area
        
        CGPoint offset = textView.contentOffset;
        
        offset.y += overflow + 7; // leave 7 pixels margin
        
        // Cannot animate with setContentOffset:animated: or caret will not appear
        
        [UIView animateWithDuration:.2 animations:^{
            
            [textView setContentOffset:offset];
            
        }];
        
    }*/
    
    float fHeight = [self heightForTextView:text_content WithText:text_content.text];
    
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
            _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
            //_scrollerView.contentOffset = CGPointMake(0, fHeight);//2015.10.19
            
        }
        
    }else{
    
     if (fHeight > 90.0) {
         
         [text_content setFrame:g];//2015.10.19
        _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight/21 + text_content.frame.size.height+10);
        // _scrollerView.contentOffset = CGPointMake(0, fHeight);//2015.10.19
     }
    
    }
    
    //    //设置动画
    //    [UIView beginAnimations:nil context:nil];
    //
    //    //定义动画时间
    //    [UIView setAnimationDuration:0.3];
    //
    //    #define kViewHeight 56
    //    //设置view的frame，往上平移
    //    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-fHeight-kViewHeight, 320, self.view.frame.size.height + fHeight)];
    //    
    //    [UIView commitAnimations];
    
    
    
}


//- (void)textViewDidChange:(UITextView *)textView
//{
//    float fHeight = [self heightForTextView:text_content WithText:text_content.text];
//    
//    CGRect g = text_content.frame;
//    g.size.height = fHeight;
//    
//    [text_content setFrame:g];
//    
//    [imgView_line3 setFrame:CGRectMake(0,
//                                       text_content.frame.origin.y + text_content.frame.size.height + 10,
//                                       320,
//                                       1)];
//    
//    [imgView_bg_photo setFrame:CGRectMake(10,
//                                          imgView_line3.frame.origin.y + imgView_line3.frame.size.height + 10,
//                                          300,
//                                          90)];
//
//    _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44 + fHeight + imgView_bg_photo.frame.size.height);
//    _scrollerView.contentOffset = CGPointMake(0, fHeight);
    
//    //设置动画
//    [UIView beginAnimations:nil context:nil];
//    
//    //定义动画时间
//    [UIView setAnimationDuration:0.3];
//    
//    #define kViewHeight 56
//    //设置view的frame，往上平移
//    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-fHeight-kViewHeight, 320, self.view.frame.size.height + fHeight)];
//    
//    [UIView commitAnimations];
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (text_time == textField)
    {
        //这里默认是最多输入120位
        if (range.location >= 3)
            return NO; // return NO to not change text
        return YES;
    }
    else if(text_title == textField)
    {
        if (range.location >= 50) {//班级作业发帖标题 50
            return NO;
        }
        return YES;
    }
    return YES;
}

//--------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
//    if (IS_IPHONE_5) {
//        text_content.frame = CGRectMake(10, 70, 300.0, 568-60-70);
//    }else{
//        text_content.frame = CGRectMake(10, 70, 300.0, 480-60-70);
//    }
    
     //text_content.frame = CGRectMake(10, 70, 300.0, 480-60-70);
    
    return YES;
}
// 2015.08.21
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self unEnabledBtn];//2015.08.21
}

//- (void)textViewDidChange:(UITextView *)_textView {
//    
//    int a;
//}
//---------------------------------------------------------

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationDuration:0.20];
    
    if (2 == _flag) {
        _scrollerView.contentOffset = CGPointMake(0, 90 );
    } else {
        _scrollerView.contentOffset = CGPointMake(0, 30 );
    }
    [UIView commitAnimations];
    
    if (2 == _flag) {
        if ([text_content.text isEqualToString:@"内容"]) {
            text_content.text = @"";
            text_content.textColor = [UIColor blackColor];
        }
    }else {
        if ([text_content.text isEqualToString:@"输入作业内容"]) {
            text_content.text = @"";
            text_content.textColor = [UIColor blackColor];
        }
    }

    
    [self enableBtn];//add 2015.08.215
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationDuration:0.20];
    _scrollerView.contentOffset = CGPointMake(0, 0 );
    [UIView commitAnimations];

    if (2 == _flag) {
        if ([text_content.text isEqualToString:@""]) {
            text_content.text = @"内容";
            text_content.textColor = [UIColor lightGrayColor];
        }
    }else {
        if ([text_content.text isEqualToString:@""]) {
            text_content.text = @"输入作业内容";
            text_content.textColor = [UIColor lightGrayColor];
        }
    }

    
}

/*-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if (range.location>=100)
//    {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                       message:@"超出最大输入限制"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
//        
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
    
//    CGFloat height = text_content.contentSize.height;
//    CGRect rect = text_content.frame;
//    
//    rect.size.height = height;
//    
//    [text_content setFrame:rect];
    return YES;
}*/

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //[self moveView:-60];

    CGRect scRect = _scrollerView.frame;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        if (iPhone5) {
            scRect.size.height = scRect.size.height + 90;
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
    
//    text_content.contentSize = g.size;
    
//    [imgView_line3 setFrame:CGRectMake(0,
//                                       text_content.frame.origin.y + text_content.frame.size.height + 10,
//                                       320,
//                                       1)];
//    
//    [imgView_bg_photo setFrame:CGRectMake(10,
//                                          imgView_line3.frame.origin.y + imgView_line3.frame.size.height + 10,
//                                          300,
//                                          90)];
//
//    _scrollerView.contentOffset = CGPointMake(0, fHeight );

    
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

-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.50f;
    CGRect frame = _scrollerView.frame;
    frame.origin.y +=move;//view的X轴上移
    _scrollerView.frame = frame;
    [UIScrollView beginAnimations:@"ResizeView" context:nil];
    [UIScrollView setAnimationDuration:animationDuration];
    _scrollerView.frame = frame;
    [UIScrollView commitAnimations];//设置调整界面的动画效果
}

//----------------------------------------------------------

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
    
//    if(buttonArray.count > 1){
//        for (int i=0; i<[buttonArray count]-1; i++) {
//            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
//            
//            [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image] attributes:nil];
//            
//            [imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
//        }
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
        data = UIImageJPEGRepresentation(img, 0.75);
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
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal] ;
    [(UIButton*)[buttonArray objectAtIndex:tag] setImage:[UIImage imageNamed:@"icon_add_photo_p"] forState:UIControlStateHighlighted] ;
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
//----------------------------------------------------------

//---add by kate 2014.10.08-----------------------------------------------------------------------------

-(void)showImageButtonArray
{
    for (int i=0; i<[buttonFlagViewArray count]; i++) {
        [[buttonFlagViewArray objectAtIndex:i] removeFromSuperview];
    }
    
    //NSLog(@"show array count:%d",[buttonArray count]);
    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        //NSLog(@"["@"%d"@"].tag="@"%d",i,((UIButton*)[buttonArray objectAtIndex:i]).tag);
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
       
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    //NSLog(@"tag:%d",button_photoMask.tag);
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
    
    //UIImage *image = [UIImage imageNamed:@"btn_sr_d.png"];
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
   
    UIImage *image = [UIImage imageNamed:@"btn_bq_un.png"];
    //UIImage *image = [UIImage imageNamed:@"btn_sr_un.png"];
    if ([Utilities image:keyboardButton.imageView.image equalsTo:image]) {
        
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }else{
       
        [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                               forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
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

@end

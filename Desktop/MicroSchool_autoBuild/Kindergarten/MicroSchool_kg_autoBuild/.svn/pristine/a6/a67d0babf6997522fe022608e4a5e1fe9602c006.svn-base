//
//  ScanViewController.m
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ScanViewController.h"
#import "FRNetPoolUtils.h"
#import "BindByTextViewController.h"
#import "FriendProfileViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

BOOL isScan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
//          [self scanButtonTapped];
//    }
    isScan = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        
        if (isScan) {
            [self scanButtonTapped];
            isScan = NO;
        }
        
    }else{
    
        [self scanButtonTapped];
    
    }
    
    if ([@"scanView"  isEqual: _viewType]) {
        [MyTabBarController setTabBarHidden:YES];
        [ReportObject event:ID_CAMERA_OPEN_INFO];//2015.06.25
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authorizationStatus == AVAuthorizationStatusRestricted
                || authorizationStatus == AVAuthorizationStatusDenied) {
                
                // 没有权限
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[NSString stringWithFormat:@"请打开相机开关(设置 > 隐私 > 相机 > %@)",appName]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                return;
            }
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ADD: bring up the reader when the scan button is tapped
- (void) scanButtonTapped
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"publish"];
     CGSize winSize = [UIScreen mainScreen].bounds.size;
    // use this to scan from the camera feed:
    //ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
    if(reader) // first check `self.ZBarReaderVC` is created or not?
    {
        [reader.readerView stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
        for(UIView *subViews in reader.view.subviews) // remove all subviews
            [subViews removeFromSuperview];
        //[reader.view removeFromSuperview];
        //reader.view = nil;
    }
    
    reader = [ZBarReaderViewController new];
    // (optional) to scan from images, replace with:
    //ZBarReaderController *reader = [ZBarReaderController new];
    reader.readerView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    reader.showsHelpOnFail = NO;
    reader.readerDelegate = self;
    reader.wantsFullScreenLayout = NO;
    reader.supportedOrientationsMask=ZBarOrientationMask(UIInterfaceOrientationPortrait);
    [reader setShowsZBarControls:NO];
    
    ZBarImageScanner *scanner = reader.scanner;
    
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
   
    // 移除自带的Cancel 与 信息按钮
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
                
            }
        }
    }
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, winSize.width, winSize.height - 64.0)];
    
    if (IS_IPHONE_4) {
        [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_bgSmall.png"]]];
    }else{
        [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_bgBig.png"]]];
    }
    [reader.view addSubview:backView];
    //[backView release];
    
    //掃描界面標題
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [labelTitle setBackgroundColor:[UIColor blackColor]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0+16, 20, winSize.width, 44)];
    labelTitle2.font = [UIFont boldSystemFontOfSize:17];
    
    //[labelTitle2 setBackgroundColor:[UIColor clearColor]];
    [labelTitle2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_img.png"]]];
    [labelTitle2 setTextColor:[UIColor whiteColor]];
    [labelTitle2 setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(30, 20+(44-33)/2.0, 33, 33);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(-16, 0, winSize.width, 64)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:labelTitle];
    [toolBar setItems:[NSArray arrayWithObject:toolBarTitle]];
    
    [toolBar addSubview:labelTitle2];
    [toolBar addSubview:leftButton];
    [reader.view addSubview:toolBar];
    
    
    UIButton *textBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textBindBtn.frame = CGRectMake(15, winSize.height - 44 - 40,winSize.width-30 , 44);
    [textBindBtn setTitle:@"使用文本绑定码绑定" forState:UIControlStateNormal];
    [textBindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [textBindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
//    [textBindBtn setBackgroundImage:[UIImage imageNamed:@"bg_only_d.png"] forState:UIControlStateNormal];
//    [textBindBtn setBackgroundImage:[UIImage imageNamed:@"bg_only_p.png"] forState:UIControlStateHighlighted];
    
    [textBindBtn setBackgroundImage:[UIImage imageNamed:@"btn_scan_d.png"] forState:UIControlStateNormal];
    [textBindBtn setBackgroundImage:[UIImage imageNamed:@"btn_scan_p.png"] forState:UIControlStateHighlighted];
    
    //[textBindBtn setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
    [textBindBtn addTarget:self action:@selector(gotoBindPageByText) forControlEvents:UIControlEventTouchUpInside];
    textBindBtn.layer.cornerRadius = 2.0;
    textBindBtn.layer.masksToBounds = YES;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(winSize.width - 15 - 15 - 35, (44 - 15)/2.0, 15, 15)];
    imgV.image = [UIImage imageNamed:@"icon_right_white.png"];
    
    [textBindBtn addSubview:imgV];
    
    [reader.view addSubview:textBindBtn];
  
    UIImageView *modelView = [[UIImageView alloc]initWithFrame:CGRectMake(44.75, winSize.height/2.0-160, 220.5,220.5)];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, modelView.frame.origin.y+220, WIDTH, 40)];
    if (IS_IPHONE_5) {
        
    }else{
        titleLabel.frame = CGRectMake(0.0, modelView.frame.origin.y+220+10, winSize.width, 40);
    }
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"扫描子女的二维码即可绑定亲子关系";
    [reader.view addSubview:titleLabel];
   
    scrollView = [[UIScrollView alloc]init];
    
    if (IS_IPHONE_4) {
        
        scrollView.frame = CGRectMake(0.0, winSize.height - 64 -65, 320, 60.0);
       
    }else{
        
         scrollView.frame = CGRectMake(0.0, winSize.height - 64 - 44 -10-10-54, WIDTH, 60.0);
        
    }
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(winSize.width, 65.0);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [reader.view addSubview:scrollView];
    
    // present and release the controller

//    [self.navigationController pushViewController:reader animated:NO];
//    reader.navigationController.navigationBarHidden = YES;
    
   
    
     if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
         //[self.parentViewController presentViewController:reader animated:NO completion:nil];
         
     }else{
          //[self presentViewController:reader animated:NO completion:nil];// iOS7
     }
    
    if ([self isKindOfClass:[ScanViewController class]]) {
        NSLog(@"Y");
    }
    
    //[self presentViewController:reader animated:NO completion:nil];// iOS7
    //[self.navigationController.topViewController presentViewController:reader animated:NO completion:nil];//iOS8
    
    //-----update by kate 2015.05.08---------------------------------------------------------
    //解决 Warning :-Presenting view controllers on detached view controllers is discouraged
    [self addChildViewController:reader];
    [self.view addSubview:reader.view];
    [reader didMoveToParentViewController:self];
    //----------------------------------------------------------------------------------------
    
    //[self showViewController:reader sender:nil];
    //self.view = reader.readerView;
    
    if ([@"scanView"  isEqual: _viewType]) {
        [labelTitle2 setText:@"扫一扫"];
        textBindBtn.hidden = YES;
        titleLabel.text = @"将二维码放入框内即可自动扫描";

    }else {
        [labelTitle2 setText:@"亲子关系绑定"];
    }

}

// ADD: do something with decoded barcode data
- (void) imagePickerController: (UIImagePickerController*)picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    id <NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
   	
    codeResult= nil;
    codeResult=symbol.data;
    NSLog(@"codeResult:%@",codeResult);
    //scanlinkLabel.text = codeResult;
    if ([codeResult length] == 0) {
        //扫描失败
        
        [Utilities showAlert:@"提示" message:@"扫描失败，请重试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }else{
        
        
        // 去个人资料页，调用 通过二维码获取个人资料接口
//        if(reader) // first check `self.ZBarReaderVC` is created or not?
//        {
//            [reader.readerView stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
//            for(UIView *subViews in reader.view.subviews) // remove all subviews
//                [subViews removeFromSuperview];
//            //[reader.view removeFromSuperview];
//            //reader.view = nil;
//        }
        
//        [reader dismissViewControllerAnimated:NO completion:nil];
        
//        FriendProfileViewController *fpV = [[FriendProfileViewController alloc]init];
//        fpV.code = codeResult;
//        fpV.fromName = @"scan";
//        [self.navigationController pushViewController:fpV animated:YES];
        if ([@"scanView"  isEqual: _viewType]) {
            _qrCode = codeResult;
            [self doCheckScanResult];

//            NSString *str = [codeResult substringToIndex:7];
//            if ([@"content"  isEqual: str]) {
//                _qrCode = codeResult;
//                [self doCheckScanResult];
//            }else {
//                NSURL *webUrl = [NSURL URLWithString:codeResult];
//                
//                if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {
//                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
//                    //fileViewer.requestURL = shareUrl;
//                    //                fileViewer.fromName = @"message";
//                    fileViewer.fromName = @"message";
//                    fileViewer.url = webUrl;
//                    fileViewer.currentHeadImgUrl = nil;
//                    
//                    [self.navigationController pushViewController:fileViewer animated:YES];
//                }
//
//            }
            
        }else {
            if (!isSubmit) {
                [self submit:codeResult];
            }
        }
        
        
    }
    
}

- (void)doCheckScanResult
{
    long long a = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%lld", a];
    NSString *code = [NSString stringWithFormat:@"code=%@&sid=%@&timestamp=%@&uid=%@", _qrCode, G_SCHOOL_ID, timestamp, [Utilities getUniqueUid]];
    
    _qrCodeMd5 = [Utilities md5With32:code];
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"QRCode",@"ac",
                          @"2",@"v",
                          @"parse", @"op",
                          _qrCode, @"code",
                          _qrCodeMd5, @"sign",
                          timestamp, @"timestamp",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *msg = [respDic objectForKey:@"message"];
            NSString *type = [NSString stringWithFormat:@"%@", [msg objectForKey:@"type"]];
            if ([@"2"  isEqual: type]) {
                // 获取好友信息，添加好友
                NSDictionary *dic = [msg objectForKey:@"body"];
                
                NSString *uid = [dic objectForKey:@"uid"];
                
                FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
                friendProfileViewCtrl.fuid = uid;
                [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
                
                [ReportObject event:ID_CAMERA_OPEN_PROFILE_INFO];//2015.06.25
                
            }else if ([@"1"  isEqual: type]) {//扫一扫打开网站页面
                NSDictionary *dic = [msg objectForKey:@"body"];
                
                NSString *url = [dic objectForKey:@"url"];
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"message";
                fileViewer.url = [NSURL URLWithString:url];
                fileViewer.currentHeadImgUrl = nil;
#endif
                
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadURl;
                fileViewer.url = [NSURL URLWithString:url];
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
                [ReportObject event:ID_CAMERA_OPEN_URL_INFO];//2015.06.25
            }
        } else {
            NSURL *webUrl = [NSURL URLWithString:codeResult];
            
            if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {//扫一扫打开网站页面
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"message";
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadURl;
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
                 [ReportObject event:ID_CAMERA_OPEN_URL_INFO];//2015.06.25
                
            }else {//扫一扫打开文字页面
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"scan";
                fileViewer.loadHtmlStr = codeResult;
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadHtml;
                fileViewer.loadHtmlStr = codeResult;
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
               [ReportObject event:ID_CAMERA_OPEN_TEXT_INFO];//2015.06.25
            }
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    //[reader.view removeFromSuperview];
    
    // update by kate 2015.07.04
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    /*当以下这些语句都不好用时用此方法使键盘消失 iOS8.3
     [self.view endEditing:YES];
     [text_title resignFirstResponder];
     [text_content resignFirstResponder];
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
     */
    
    return NO;
}

-(void)selectLeftAction:(id)sender{
    
    /*if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        
    }else{
    
    if(reader) // first check `self.ZBarReaderVC` is created or not?
    {
        [reader.readerView stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
        for(UIView *subViews in reader.view.subviews) // remove all subviews
            [subViews removeFromSuperview];
        
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        //[self.parentViewController dismissViewControllerAnimated:NO completion:nil];// ios8
        //isScan = YES;
        //[self.navigationController popViewControllerAnimated:YES];// ios8
        
        
    }else{
        
//        [reader dismissViewControllerAnimated:NO completion:nil];// iOS7
//        
//        [self.navigationController popViewControllerAnimated:YES];// iOS7
    }
    
      [reader dismissViewControllerAnimated:NO completion:nil];// iOS7
    }*/
    
    // update by kate 2015.07.04
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

//    [self.navigationController popViewControllerAnimated:YES];// iOS7
    
}

-(void)gotoBindPageByText{
    
    /*if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        
    }else{
        if(reader) // first check `self.ZBarReaderVC` is created or not?
        {
            [reader.readerView stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
            for(UIView *subViews in reader.view.subviews) // remove all subviews
                [subViews removeFromSuperview];
            //[reader.view removeFromSuperview];
            //reader.view = nil;
        }
        
        [reader dismissViewControllerAnimated:NO completion:nil];// ios7
        //[self.parentViewController dismissViewControllerAnimated:NO completion:nil];// iOS8

    }*/
    
    // 去绑定页
    BindByTextViewController *bindV = [[BindByTextViewController alloc]init];
    [self.navigationController pushViewController:bindV animated:YES];
    
}

-(void)submit:(NSString*)code{
    
    [Utilities showProcessingHud:self.view];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Friend", @"ac",
                          @"1",@"v",
                          @"viewByCode", @"op",
                          code, @"code",
                          nil];
    
    [network sendHttpReq:HttpReq_ViewFriendProfileByCode andData:data];

}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue]) {
        
        if(reader) // first check `self.ZBarReaderVC` is created or not?
        {
            [reader.readerView stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
            for(UIView *subViews in reader.view.subviews) // remove all subviews
                [subViews removeFromSuperview];
            //[reader.view removeFromSuperview];
            //reader.view = nil;
        }
//        [reader dismissViewControllerAnimated:NO completion:nil];
        
        NSDictionary *message_info = [resultJSON objectForKey:@"message"];
        // 把秘钥带到下一页，调用获取个人资料接口
        FriendProfileViewController *fpV = [[FriendProfileViewController alloc]init];
        fpV.infoDic = message_info;
        fpV.fromName = @"scan";
        fpV.code = codeResult;//---add by kate 2014.12.03------------------
        [self.navigationController pushViewController:fpV animated:YES];
        
    }else{
        
        isSubmit = YES;
        NSString* message_info = [resultJSON objectForKey:@"message"];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        alert.tag = 223;
        [alert show];
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 223) {
        if (buttonIndex == 0) {
            isSubmit = NO;
        }
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
//
// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end

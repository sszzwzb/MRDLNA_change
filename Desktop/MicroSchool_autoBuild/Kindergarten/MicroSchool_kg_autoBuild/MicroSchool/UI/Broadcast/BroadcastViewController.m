//
//  BroadcastViewController.m
//  MicroSchool
//
//  Created by jojo on 15/1/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BroadcastViewController.h"


@interface BroadcastViewController ()

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:_moduleName];//update by kate 2015.04.23
    [super setCustomizeLeftButton];
    
    // 判断如果是从模块直接进入，则显示历史记录，如果从历史记录进，则不显示。
    if (nil == _nid) {
        //[self setCustomizeRightButton:@"icon_broadcast_history.png"];
        [self setCustomizeRightButtonWithName:@"历史"];// 局长需求，我赶脚很难看
    }

    // 没有加载完之前，禁用rightbtn
    self.navigationItem.rightBarButtonItem.enabled = NO;

    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [ReportObject event:ID_SCHOOL_RADIO];//2015.06.25
    
#if 9
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"SchoolRadio",@"ac",
                          @"2",@"v",
                          @"play", @"op",
                          _otherSid, @"sid",
                          _nid,@"nid",
                          nil];
    
    [network sendHttpReq:HttpReq_BroadcastGetOne andData:data];
#else
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = @"加载中...";

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"SchoolRadio",@"ac",
                          @"2",@"v",
                          @"play", @"op",
                          _otherSid, @"sid",
                          _nid,@"nid",
                          nil];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSError *error;
            
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[BroadcastModel class]
                               fromJSONDictionary:respDic
                                            error:&error];
            
            if(nil != _moduleName) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", _model.nid] forKey:_moduleName];
            }
            
            // 控件的初始化
            [self initContent];
            
            _playUrl = [NSURL URLWithString:[Utilities replaceNull:_model.radio]];
            
            // 先加载音频，因为加载需要时间，通过cb来获取加载完的通知。
            if ((nil == _playUrl) || ([@""  isEqual: _model.radio])) {
                [progressHud hide:YES];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"广播播放地址异常。" msg2:@"如有问题，请联系管理员" andRect:rect];
                [self.view addSubview:noDataView];
            }else {
                //后台播放音频设置
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setActive:YES error:nil];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setDelegate:self];
                
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                
//                _movie_content = [[MPMoviePlayerController alloc] initWithContentURL:_playUrl];
//
//                _movie_content.shouldAutoplay = NO;
//                [_movie_content prepareToPlay];
                [self settingPlayer];
                // 注册一个播放结束的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:_movie_content];
                
                // 注册一个准备好播放的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieAvailableCallback:)
                                                             name:MPMovieDurationAvailableNotification
                                                           object:_movie_content];
            }
        }else {
            [progressHud hide:YES];
            
            CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
            noDataView = [Utilities showNodataView:[respDic objectForKey:@"message"] msg2:@"" andRect:rect];
            [self.view addSubview:noDataView];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];


#endif

    
    
    
    
#if 0
//    [self doGetInfo];

    
    
    
    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    
    NSDictionary *data;
    
    
    
    
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSLog(@"333333");
        NSLog(@"333333 %@", responseObject);
        
        NSDictionary *a = (NSDictionary*)responseObject;
        NSString *b = [a objectForKey:@"message"];
        NSLog(@"333333 %@", b);
        
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"333333 failed");
        int a =0;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //        progressHud.hidden = YES;
        
    }];
    // test for sleep
//    data = [[NSDictionary alloc] initWithObjectsAndKeys:
//            REQ_URL, @"url",
//            @"Test",@"ac",
//            @"2",@"v",
//            @"sleep", @"op",
//            @"1", @"time",
//            nil];

    // test for sql err
//    data = [[NSDictionary alloc] initWithObjectsAndKeys:
//            REQ_URL, @"url",
//            @"Test",@"ac",
//            @"2",@"v",
//            @"sql", @"op",
//            nil];

    // test for upload file
    data = [[NSDictionary alloc] initWithObjectsAndKeys:
            @"spl_640_960.png",@"avatar",
            nil];
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = @"加载中...";
    
    [[TSNetworking sharedClient] requestFileWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSLog(@"333333");
        NSLog(@"333333 %@", responseObject);
        
        NSDictionary *a = (NSDictionary*)responseObject;
        NSString *b = [a objectForKey:@"message"];
        NSLog(@"333333 %@", b);

        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"333333 failed");
        int a =0;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //        progressHud.hidden = YES;
        
    }];

    
    
    
#if 0

    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = @"加载中...";
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"333333");
        NSLog(@"333333 %@", responseObject);
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        int a =9;
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"333333 failed");
        int a =0;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        progressHud.hidden = YES;
        
    }];

    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSLog(@"444444");
        NSLog(@"444444 %@", responseObject);
        
        int a =9;
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
//        request
        
        NSLog(@"444444 failed");
        NSLog(@"444444 failed %d", error);

        int a =0;
        
    }];
    
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSLog(@"111111");
        NSLog(@"111111 %@", responseObject);
        
        int a =9;
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"111111 failed");
        int a =0;
        
    }];
#endif

//    [[TSNetworking shared] fetchNews:^(NSArray *news, NSError *error) {
//        if (!error) {
//            NSLog(@"333333");
//            NSLog(@"333333 %@", responseObject);
//        } else {
//            // 何らかのエラー処理!!
//        }
//    }];
    
#if 0
    [TSNetworking requestWithBaseURLStr:REQ_URL params:data httpMethod:HttpMethodPost successBlock:^(TSNetworking *request, id responseObject) {
        
        NSLog(@"333333");
        NSLog(@"333333 %@", responseObject);
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];

        int a =9;
    } failedBlock:^(TSNetworking *request, NSError *error) {
        NSLog(@"333333 failed");
        int a =0;

    }];
#endif
    
    
    
    
    
    
#if 0
    [TSNetworking requestWithBaseURLStr:REQ_URL params:data httpMethod:HttpMethodPost successBlock:^(TSNetworking *request, id responseObject) {
        
            NSLog(@"111111");
            NSLog(@"111111 %@", responseObject);
    } failedBlock:^(TSNetworking *request, NSError *error) {
        
    }];

    
    
    
    [TSNetworking requestWithBaseURLStr:REQ_URL params:data httpMethod:HttpMethodPost successBlock:^(TSNetworking *request, id responseObject) {
        
        NSLog(@"444444");
        NSLog(@"444444 %@", responseObject);
    } failedBlock:^(TSNetworking *request, NSError *error) {
        
    }];
#endif
    
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
 // 2.9.4迭代2 需求 去掉红点
//    // 更新主画面new图标 2015.11.12
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:_newsDic];
    
    // 返回前画面，暂停播放
    [_movie_content pause];
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;

    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[TSNetworking sharedClient] cancelAll];
}

/**
 * 右键去历史记录那一页
 * 并且暂停当前页面的语音播放
 */
- (void)selectRightAction:(id)sender
{
    // 到历史页面先暂停播放
//    [_movie_content pause];
    
    //    [_movie_content stop];
//    [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
    
    BroadcastHistoryViewController *histViewCtrl = [[BroadcastHistoryViewController alloc] init];
    histViewCtrl.otherSid = _otherSid;
    histViewCtrl.moduleName = _moduleName;
    [self.navigationController pushViewController:histViewCtrl animated:YES];
    
    _label_errMsg.hidden = YES;
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
}


#if 0
- (void)doGetInfo
{
    
    NSDictionary *data;
    data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"SchoolRadio",@"ac",
            @"2",@"v",
            @"play", @"op",
            _nid,@"nid",
            nil];
    
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = @"加载中...";
    
    [TSNetworking requestWithBaseURLStr:REQ_URL params:data httpMethod:HttpMethodPost successBlock:^(TSNetworking *request, id responseObject) {
        
        if(true == [[responseObject objectForKey:@"result"] intValue])
        {
            NSLog(@"222222");
            NSLog(@"222222 %@", responseObject);

            NSError *error;
            
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[BroadcastModel class]
                               fromJSONDictionary:responseObject
                                            error:&error];
            
            if(nil != _moduleName) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", _model.nid] forKey:_moduleName];
            }
            
            // 控件的初始化
            [self initContent];
            
            _playUrl = [NSURL URLWithString:[Utilities replaceNull:_model.radio]];
            
            // 先加载音频，因为加载需要时间，通过cb来获取加载完的通知。
            if ((nil == _playUrl) || ([@""  isEqual: _model.radio])) {
                [progressHud hide:YES];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"广播播放地址异常。" msg2:@"如有问题，请联系管理员" andRect:rect];
                [self.view addSubview:noDataView];
            }else {
                //后台播放音频设置
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setActive:YES error:nil];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setDelegate:self];
                
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                
                
                //                UIBackgroundTaskIdentifier bgTask = 0;
                //
                //                UIApplication*app = [UIApplication sharedApplication];
                //
                //                UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
                //
                //                if(bgTask!= UIBackgroundTaskInvalid) {
                //
                //                    [app endBackgroundTask: bgTask];
                //
                //                }
                
                
                
                
//                _movie_content = [[MPMoviePlayerController alloc] initWithContentURL:_playUrl];
//
//                _movie_content.shouldAutoplay = NO;
//                [_movie_content prepareToPlay];
                [self settingPlayer];
                // 注册一个播放结束的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:_movie_content];
                
                // 注册一个准备好播放的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieAvailableCallback:)
                                                             name:MPMovieDurationAvailableNotification
                                                           object:_movie_content];
            }
        }else {
            [progressHud hide:YES];
            
            CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
            noDataView = [Utilities showNodataView:[responseObject objectForKey:@"message"] msg2:@"" andRect:rect];
            [self.view addSubview:noDataView];
        }
        
    } failedBlock:^(TSNetworking *request, NSError *error) {
        NSLog(@"POST error: %@",error);
        [progressHud hide:YES];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"网络连接错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }];
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"broadcastDic"];
    
    if (dic != nil) {
        // 为了避免黑框，先从superview中移除
//        [_movie_content.view removeFromSuperview];

        [Utilities showProcessingHud:self.view];// 2015.05.12
        
        _imgView_bg.hidden = YES;
        _label_title.hidden = YES;
        _label_creater.hidden = YES;
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"SchoolRadio",@"ac",
                              @"2",@"v",
                              @"play", @"op",
                              [dic objectForKey:@"otherSid"], @"sid",
                              [dic objectForKey:@"nid"],@"nid",
                              nil];
        
        [network sendHttpReq:HttpReq_BroadcastGetOne andData:data];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"broadcastDic"];
        [userDefaults synchronize];

    }else {
#if 0
        // 因为在别的页面多次调用movieplayer，再回到前画面，会有黑丝残留，无法继续播放，这里需要重新加载。
        if (nil != _playUrl) {
            //        progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //        progressHud.labelText = @"重新载入中...";
            [Utilities showProcessingHud:self.view];//2015.05.12
            
            // 没有加载完之前，禁用rightbtn
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            _imgView_bg.hidden = YES;
            _label_title.hidden = YES;
            _label_creater.hidden = YES;
            
//            _movie_content = [[MPMoviePlayerController alloc] initWithContentURL:_playUrl];
//
//            _movie_content.shouldAutoplay = NO;
//            [_movie_content prepareToPlay];
            [self settingPlayer];
            secondsCountDown = 10;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            // 注册一个播放结束的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(myMovieFinishedCallback:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:_movie_content];
            
            // 注册一个准备好播放的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(myMovieAvailableCallback:)
                                                         name:MPMovieDurationAvailableNotification
                                                       object:_movie_content];
        }
#endif
    }
}


- (void)initContent
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];

    // 广播背景图
    _imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                              [UIScreen mainScreen].applicationFrame.size.width,
                                                              300)];
    _imgView_bg.contentMode = UIViewContentModeScaleAspectFill;
    _imgView_bg.clipsToBounds = YES;

    [_scrollView addSubview:_imgView_bg];

    // 广播标题
    _label_title = [[UILabel alloc] initWithFrame:CGRectZero];
    _label_title.lineBreakMode = NSLineBreakByWordWrapping;
    _label_title.numberOfLines = 0;
    _label_title.font = [UIFont boldSystemFontOfSize:17.0f];
    _label_title.textAlignment = NSTextAlignmentLeft;
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.textColor = [UIColor blackColor];
    [_scrollView addSubview:_label_title];

    // 广播人
    _label_creater = [[UILabel alloc] initWithFrame:CGRectZero];
    _label_creater.font = [UIFont systemFontOfSize:14.0f];
    _label_creater.textAlignment = NSTextAlignmentLeft;
    _label_creater.backgroundColor = [UIColor clearColor];
    _label_creater.textColor = [UIColor blackColor];
    [_scrollView addSubview:_label_creater];
    
    // 错误提示
    _label_errMsg = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 280, 200)];
    
    if (iPhone4) {
        _label_errMsg.frame = CGRectMake(20, 100, 280, 200);
    }
    
    _label_errMsg.text = @"音频文件有误，无法播放，请稍后再试或联系管理员。";
    _label_errMsg.lineBreakMode = NSLineBreakByWordWrapping;
    _label_errMsg.numberOfLines = 0;
    _label_errMsg.font = [UIFont boldSystemFontOfSize:17.0f];
    _label_errMsg.textAlignment = NSTextAlignmentLeft;
    _label_errMsg.backgroundColor = [UIColor clearColor];
    _label_errMsg.textColor = [UIColor blackColor];
    _label_errMsg.hidden = YES;
    [_scrollView addSubview:_label_errMsg];
    
    _isInit = @"1";
}

/**
 * 当语音播放完成后的回调方法，
 * 回调之后进行支援的销毁
 */
- (void)myMovieFinishedCallback:(NSNotification*)notify
{
    [countDownTimer invalidate];

    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    NSInteger duration =  theMovie.duration;

    if (10 < duration) {
#if 0
//        _movie_content = [[MPMoviePlayerController alloc] initWithContentURL:_playUrl];
//
//        _movie_content.shouldAutoplay = NO;
//        [_movie_content prepareToPlay];
        [self settingPlayer];
        // 注册一个播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_movie_content];
        
        // 注册一个准备好播放的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieAvailableCallback:)
                                                     name:MPMovieDurationAvailableNotification
                                                   object:_movie_content];
#endif
        
#if 0
        //销毁播放通知
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:theMovie];
        
        [ [ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
#endif
        
    }

//    [_movie_content play];
    
    [self handleNotification:NO];//播放结束


}

- (void)myMovieAvailableCallback:(NSNotification*)notify
{
    
    [countDownTimer invalidate];

    [Utilities dismissProcessingHud:self.view];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    MPMoviePlayerController* theMovie = [notify object];
    NSTimeInterval duration =  theMovie.duration;
    
    
    MPMovieMediaTypeMask movieMediaTypes = theMovie.movieMediaTypes;
    MPMovieSourceType movieSourceType = theMovie.movieSourceType;

    if (10 < duration) {
        _label_errMsg.hidden = YES;

        [self showInfo];
        
        [self configNowPlayingInfoCenter];
        
        [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
    }else {
        _label_errMsg.hidden = YES;
    }
    
    //[self handleNotification:YES];// 监听听筒or扬声器 add by kate 2015.11.16
    
}

- (void)showInfo
{
    // 背景图片
    _imgView_bg.hidden = NO;
    NSString *pic = [Utilities replaceNull:_model.background];
    if ([@""  isEqual: pic]) {
        [_imgView_bg setImage:[UIImage imageNamed:@"img_broadcast_bg.jpg"]];
    }else {
        [_imgView_bg sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"broadcast_bg_img.png"]];
    }
    
    // 标题
    _label_title.hidden = NO;
    _label_title.text = [Utilities replaceNull:_model.title];
    CGSize strSize = [Utilities getStringHeight:_model.title andFont:[UIFont systemFontOfSize:17] andSize:CGSizeMake(280, 0)];
    _label_title.frame = CGRectMake(
                                    20,
                                    _imgView_bg.frame.origin.y + _imgView_bg.frame.size.height + 10,
                                    280,
                                    strSize.height);
    
    // 广播人
    _label_creater.hidden = NO;
    _label_creater.text = [Utilities replaceNull:_model.broadcaster];
    _label_creater.frame = CGRectMake(
                                      20,
                                      _label_title.frame.origin.y + _label_title.frame.size.height + 10,
                                      280,
                                      20);
    
    // 设置播放器的frame
    CGRect aFrame = [[UIScreen mainScreen] applicationFrame];
    aFrame = CGRectMake(0,
                        _label_creater.frame.origin.y + _label_creater.frame.size.height + 20,
                        WIDTH, 38);
//    [_movie_content.view setFrame:aFrame];
//
//    _movie_content.controlStyle = MPMovieControlStyleEmbedded;
//    [_scrollView addSubview:_movie_content.view];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
      [playButton setImage:[UIImage imageNamed:@"icon_stop"] forState:UIControlStateSelected];
      [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [_scrollView addSubview:playButton];
//      [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.center.equalTo(imageView);
//      }];
    
      self.playButton = playButton;
    playButton.frame = CGRectMake(self.view.frame.size.width/2 -20, _label_creater.frame.origin.y + _label_creater.frame.size.height + 20, 40, 38);
       CGFloat imageViewWidth = 375 * .6;
      
      UISlider *slider = [[UISlider alloc]init];
      slider.minimumTrackTintColor = [UIColor colorWithHexString:@"37ccff"];
      slider.maximumTrackTintColor = [UIColor colorWithHexString:@"484848"];
      [slider setThumbImage:[UIImage imageNamed:@"icon_sliderButton"] forState:UIControlStateNormal];
      slider.minimumValue = 0;
      slider.maximumValue = 1;
      slider.continuous = YES;
      [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
      [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
      [_scrollView addSubview:slider];
   
        slider.frame = CGRectMake(50, playButton.frame.origin.y + playButton.frame.size.height + 20, imageViewWidth, 38);
      self.progressSlider = slider;
      
      UILabel *leftTimeLabel = [[UILabel alloc]init];
      leftTimeLabel.text = @"00:00";
      leftTimeLabel.textColor = [UIColor grayColor];
      leftTimeLabel.font = [UIFont systemFontOfSize:12.f];
      [_scrollView addSubview:leftTimeLabel];
      [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(slider.mas_left).offset(-8);
          make.centerY.equalTo(slider);
      }];
      self.beginTimeLabel = leftTimeLabel;
      
      UILabel *rightTimeLabel = [[UILabel alloc]init];
      rightTimeLabel.text = @"00:00";
      rightTimeLabel.textColor = [UIColor grayColor];
      rightTimeLabel.font = [UIFont systemFontOfSize:12.f];
      [_scrollView addSubview:rightTimeLabel];
      [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(slider.mas_right).offset(8);
          make.centerY.equalTo(slider);
      }];
      self.endTimeLabel = rightTimeLabel;
    
//      [self settingPlayer];
    
    // 判断是否为wifi环境，除了wifi环境外提示用户是否进行播放。
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if (ReachableViaWiFi != [r currentReachabilityStatus]) {
        if (_model.limit) {
            NSString *msg = [NSString stringWithFormat:@"您正在使用手机网络，继续收听可能产生超额流量（%@M），建议转到WIFI环境下收听。", [Utilities replaceNull:_model.fileSize]];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"确认"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }

//        if ([[Utilities replaceNull:[_broadcastDic objectForKey:@"fileSize"]] floatValue] > 5) {
//            NSString *msg = [NSString stringWithFormat:@"您正在使用手机网络，继续收听可能产生超额流量（%@M），建议转到WIFI环境下收听。", [Utilities replaceNull:[_broadcastDic objectForKey:@"fileSize"]]];
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                           message:msg
//                                                          delegate:self
//                                                 cancelButtonTitle:@"确认"
//                                                 otherButtonTitles:nil,nil];
//            [alert show];
//        }
    }
    
    // 重新设置下scrollview的size
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, slider.frame.origin.y + 70);
}

- (void)settingPlayer{
    //NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"A-Lin-无人知晓的我" withExtension:@".mp3"];
//    NSURL *fileURL = [NSURL URLWithString:_playUrl];
    
    self.playerItem = [[AVPlayerItem alloc]initWithURL:_playUrl];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    
    CMTime duration = self.player.currentItem.asset.duration;
    NSTimeInterval total = CMTimeGetSeconds(duration);
    self.endTimeLabel.text = [self timeIntervalToMMSSFormat:total];
    
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

        //更新时间和进度条
        float current = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        _total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.beginTimeLabel.text = [weakSelf timeIntervalToMMSSFormat:CMTimeGetSeconds(time)];
        if (!weakSelf.isSliderTouch) {
            //拖动slider的时候不更新进度条
            weakSelf.progressSlider.value = current / _total;
        }
        
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playToEnd{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01* NSEC_PER_SEC)); dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.progressSlider.value = 0;
        self.playButton.selected = NO;
        self.beginTimeLabel.text = @"00:00";
        [self stopLayer:self.musicImageView.layer];
        _isPlaying = NO;
        self.player = nil;
        self.playerItem = nil;
    });
  
}

#pragma mark - 进度条状态改变
- (void)sliderTouchDown:(UISlider *)slider{
    _isSliderTouch = YES;
}

- (void)sliderValueChange:(UISlider *)slider{
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value * _total, self.player.currentItem.currentTime.timescale)];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.03* NSEC_PER_SEC)); dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //不延迟执行会造成slider瞬间回弹
        _isSliderTouch = NO;
    });
    
}

#pragma mark - 图片旋转动画
//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

//停止动画
- (void)stopLayer:(CALayer *)layer{
    [layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark - Action
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (!self.player) {
        [self settingPlayer];
    }
    if (button.selected) {
      [self.player play];
       _isPlaying == YES ? [self resumeLayer:self.musicImageView.layer] : [self startAnimate];
        _isPlaying = YES;
   }else{
        [self.player pause];
        [self pauseLayer:self.musicImageView.layer];
    }
}

- (void)startAnimate{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.speed = 1;
    rotationAnimation.duration = 25;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999999;
    rotationAnimation.removedOnCompletion = NO;
    [self.musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - 设置时间数据
- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    self.beginTimeLabel.text = [self timeIntervalToMMSSFormat:currentTime];
    self.endTimeLabel.text = [self timeIntervalToMMSSFormat:duration];
   [self.progressSlider setValue:currentTime / duration animated:YES];
 
}

#pragma mark - 时间转化
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"viewDidAppear!!!");
    
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"viewWillDisappear!!!");
    
    [super viewWillDisappear:animated];
    
    //End recieving events
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self resignFirstResponder];
    //2019.11.15 by zhenguo 
    [_player pause];
    [self.playButton removeFromSuperview];
    [self.progressSlider removeFromSuperview];
    [self.beginTimeLabel removeFromSuperview];
    [self.endTimeLabel removeFromSuperview];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        
        if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause!!!");
            [self pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            NSLog(@"UIEventSubtypeRemoteControlNextTrack!!!");
        } else if (event.subtype == UIEventSubtypeRemoteControlPause){
            NSLog(@"UIEventSubtypeRemoteControlPause!!!");
            [self pause];
//            [self configNowPlayingInfoCenter];
        } else if (event.subtype == UIEventSubtypeRemoteControlPlay){
            NSLog(@"UIEventSubtypeRemoteControlPlay!!!");
            [self play];
//            [self configNowPlayingInfoCenter];
        }
    }
}

- (void)pause
{
    [_movie_content pause];
}

- (void)play
{
    [_movie_content play];
}

- (void)configNowPlayingInfoCenter {
    
//    NSDictionary *albumDic=[currentParserSongArray objectAtIndex:songIndex];
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[Utilities replaceNull:_model.title] forKey:MPMediaItemPropertyTitle];
        
        [dict setObject:[Utilities replaceNull:_model.broadcaster] forKey:MPMediaItemPropertyArtist];
        
        [dict setObject:@"" forKey:MPMediaItemPropertyAlbumTitle];
        
        //音乐剩余时长
//        [dict setObject:[NSNumber numberWithDouble:_movie_content.duration] forKey:MPMediaItemPropertyPlaybackDuration];

//        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"img_broadcast_bg.jpg"]];
        
//        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        
//        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

//Make sure we can recieve remote control events

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"SchoolRadioAction.play"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        
        if (![Utilities isConnected]) {//2015.06.30
            
            noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
            [self.view addSubview:noNetworkV];
            
        }else{
            
            [noNetworkV removeFromSuperview];
        }
        
        if(true == [result intValue])
        {
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[BroadcastModel class]
                                             fromJSONDictionary:resultJSON
                                                          error:&error];
            
            //int a = _model.viewnum;
            
            if ([G_SCHOOL_ID isEqual:_otherSid]) {//从其他学校进入不记录id
            
                if(nil != _moduleName) {
                    
                    if (nil == _nid){
                        
                        NSString *nidStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:_moduleName]]];
                        
#if 0
                        
                        if ([nidStr length] == 0) {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", _model.nid] forKey:_moduleName];
                        }else if ([_model.nid integerValue] > [nidStr integerValue]){
                            
                            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", _model.nid] forKey:_moduleName];
                        }
#endif
                        //------------2015.11.12----------------------------------------------------------------------
                        // 更新校园广播最后一条id
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                        
                        if (defaultsDic) {
                            
                            NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithArray:[defaultsDic objectForKey:@"school"]];
                            
                            if ([filteredArray count]>0) {
                                
                                for (int i=0; i<[filteredArray count]; i++) {
                                    
                                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[filteredArray objectAtIndex:i]];
                                    
                                    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"mid"]] integerValue] == [_mid integerValue]) {
                                        
                                        NSString *last = [dic objectForKey:@"last"];
                                        
                                        if ([[NSString stringWithFormat:@"%@", _model.nid] integerValue] > [last integerValue]) {
                                            
                                            [dic setObject:[NSString stringWithFormat:@"%@", _model.nid] forKey:@"last"];
                                            
                                            [filteredArray replaceObjectAtIndex:i withObject:dic];
 
                                        }
                                       
                                        
                                    }
                                    
                                }
                                
                                [defaultsDic setObject:filteredArray forKey:@"school"];
                                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                                [userDefaults synchronize];
                            }
                            
                        }
                        //-------------------------------------------------------------------------------------------------
                        
                       
                    }
                    
                }
            }
     
            if (![@"1"  isEqual: _isInit]) {
                // 控件的初始化
                [self initContent];
            }
            
            // 由于url的初始化不用urtf8转换下，带中文的url就会返回null，这里都需要转换为utf8.
            NSString *radioUrl = [Utilities replaceNull:_model.radio];
            radioUrl = [radioUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _playUrl = [NSURL URLWithString:radioUrl];
            
            // 先加载音频，因为加载需要时间，通过cb来获取加载完的通知。
            if ((nil == _playUrl) || ([@""  isEqual: _model.radio])) {
                
                //[progressHud hide:YES];
                [Utilities dismissProcessingHud:self.view];// 2015.05.12
                self.navigationItem.rightBarButtonItem.enabled = YES;

                CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"广播播放地址异常。" msg2:@"如有问题，请联系管理员" andRect:rect];
                [self.view addSubview:noDataView];
            }else {
                
                //---add by kate 2015.07.01--------------------------------
                if ([_model.fileSize floatValue] == 0) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;

                    [Utilities dismissProcessingHud:self.view];// 2015.05.12
                    _label_errMsg.hidden = NO;
                    return;
                    
                }
                //-----------------------------------------------------------
                
                //后台播放音频设置
                AVAudioSession *session = [AVAudioSession sharedInstance];
                
                //------add by kate 2015.11.27--------------------------------------------
                UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
                AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                                         sizeof (audioRouteOverride),
                                         &audioRouteOverride);// 耳机 扬声器切换
                //--------------------------------------------------------------------------------
                
                
                [session setActive:YES error:nil];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setDelegate:self];

                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

                
//                UIBackgroundTaskIdentifier bgTask = 0;
//
//                UIApplication*app = [UIApplication sharedApplication];
//
//                UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
//
//                if(bgTask!= UIBackgroundTaskInvalid) {
//
//                    [app endBackgroundTask: bgTask];
//
//                }
                
//                _movie_content = nil;
                
                UIGraphicsBeginImageContext(CGSizeMake(1,1));

//                _movie_content = [[MPMoviePlayerController alloc] initWithContentURL:_playUrl];
//
//                UIGraphicsEndImageContext();
//
//                _movie_content.shouldAutoplay = NO;
//                [_movie_content prepareToPlay];
                [self showInfo];
                [self settingPlayer];
                secondsCountDown = 10;
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

                // 注册一个播放结束的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:_movie_content];
                
                // 注册一个准备好播放的通知
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(myMovieAvailableCallback:)
                                                             name:MPMovieDurationAvailableNotification
                                                           object:_movie_content];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
                
                

            }
        }else {
            
            //[progressHud hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
            noDataView = [Utilities showNodataView:[resultJSON objectForKey:@"message"] msg2:@"" andRect:rect];
            [self.view addSubview:noDataView];
        }
    }
}

- (void)timeFireMethod
{
    secondsCountDown--;
    
    if(secondsCountDown==0){
        [Utilities dismissProcessingHud:self.view];
        _label_errMsg.hidden = YES;

//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                       message:@"广播文件无法播放，请联系管理员。"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        
        [countDownTimer invalidate];
    }
}

-(void)playDidChangeNotification:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playState = moviePlayer.playbackState;
    
    if (playState == MPMoviePlaybackStateStopped) {
        NSLog(@"停止");
        [self handleNotification:NO];
    } else if(playState == MPMoviePlaybackStatePlaying) {
        NSLog(@"播放");
        [self handleNotification:YES];
    } else if(playState == MPMoviePlaybackStatePaused) {
        NSLog(@"暂停");
        [self handleNotification:NO];
    } else if(playState == MPMoviePlaybackStateSeekingForward) {
        NSLog(@"22222222");
    }
    
}

- (void)reciveHttpDataError:(NSError*)err
{
    //[progressHud hide:YES];
    [Utilities dismissProcessingHud:self.view];
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
    if (![Utilities isConnected]) {//2015.06.30
        
        noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        
    }else{
        
        [noNetworkV removeFromSuperview];
    }
}

//---add by Kate 2015.11.16------------------------------------------------------------------------------------------
#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
//------------------------------------------------------------------------------------------------------------

@end

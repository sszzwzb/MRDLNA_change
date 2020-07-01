//
//  Camera360ViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 24/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "Camera360ViewController.h"
#import "Camera360View.h"

#import "CameraTestViewController.h"
#import "Camera360TableViewCell.h"
#import "CameraInfoModel.h"
#import "CameraSettingViewController.h"

#import "QHCamSDK.h"
#import "TSTapGestureRecognizer.h"
#import "Reachability.h"

@interface Camera360ViewController ()
#if DEVICE_IPHONE
<QHCamPlayerDelegate>

@property(nonatomic, strong) QHCamLivePlayer *player;
@property(nonatomic, strong) QHCameraSettingService *settingService;

@property(nonatomic, strong) UIView *playerHolderView;
@property(nonatomic, assign) BOOL isPlayingState;

@property(nonatomic, strong) NSMutableArray *textLabelArray;
#endif

@end

@implementation Camera360ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view.backgroundColor = [UIColor blackColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToCamera360Setting:)
                                                 name:@"goToCamera360Setting"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refleshCameraListInfo)
                                                 name:@"refleshCameraListInfo"
                                               object:nil];
    
#if DEVICE_IPHONE
    _camera360Model = [[CameraInfoModel alloc] init];
    _cameraOpenIndexArray = [[NSMutableArray alloc] init];
    self.settingService = [[QHCameraSettingService alloc] init];

    _selectCameraIndex = -1;
    
    [self performSelector:@selector(cameraList) withObject:nil afterDelay:0.2];
    
    
    _maskView = [[Camera360View alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _maskView.delegate = self;
    _maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_maskView];
    
//    [self cameraList];
#endif
    
//    [ReportObject event:ID_CLICK_TO_SEE_NOW_PICTURE];//28002

}



#if DEVICE_IPHONE

- (void)refleshCameraListInfo {
    //[Utilities showSystemProcessingHud:self.view];
    //[self maskViewAndMenu];
    
    [Utilities showProcessingHud:self.view];
    
    /**
     * 摄像头列表
     * @author luke
     * @date 2016.10.24
     * @args
     *  v=3 ac=Camera op=lists sid= uid= cid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Camera",@"ac",
                          @"3",@"v",
                          @"lists", @"op",
                          _cId, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        //[self maskViewAndMenu];
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            _cameraErrorLabel.hidden = YES;
            _cameraErrorButton.hidden = YES;
            
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            NSArray *list = [message objectForKey:@"cameras"];
            _dataArr = [NSMutableArray arrayWithArray:list];
            
            // 如果只有一个摄像头的时候，需要把上一个以及下一个置为不可点击
            if (1 == [_dataArr count]) {
                [_previousButton setUserInteractionEnabled:NO];
                [_nextButton setUserInteractionEnabled:NO];
                
                [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_p"] forState:UIControlStateNormal];
                [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_p"] forState:UIControlStateNormal];
            }
            
            // 学生与家长如果可用的摄像头只有一个，也需要置为不可点击
            if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
                int openCameraCount = 0;
                for (int i=0; i<[_dataArr count]; i++) {
                    NSDictionary *infoDic = [_dataArr objectAtIndex:i];
                    
                    NSString *open = [infoDic objectForKey:@"open"];
                    if(true == [open intValue]) {
                        openCameraCount = openCameraCount + 1;
                    }
                }
                
                if (openCameraCount <= 1) {
                    [_previousButton setUserInteractionEnabled:NO];
                    [_nextButton setUserInteractionEnabled:NO];
                    
                    [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_p"] forState:UIControlStateNormal];
                    [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_p"] forState:UIControlStateNormal];
                }
            }
            
            [_tableView reloadData];
        }else {

        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities dismissProcessingHud:self.view];
    }];
}

-(void)goToCamera360Setting:(NSNotification*)notify {
    NSDictionary *dic = [notify object];
    NSString *cameraId = [dic objectForKey:@"cameraId"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    CameraSettingViewController *csvc = [[CameraSettingViewController alloc] init];
    csvc.cId  = _cId;
    csvc.cameraId = cameraId;
    [self presentViewController:csvc animated:YES completion:nil];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rightDarkGreyView.alpha = 0;
                         _rightDarkGreyView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         _showDarkGreyView = 0;
                     }];
}

- (void)cameraList {
//    [Utilities showSystemProcessingHud:self.view];
    //[self maskViewAndMenu];

    [Utilities showProcessingHud:self.view];
    
    /**
     * 摄像头列表
     * @author luke
     * @date 2016.10.24
     * @args
     *  v=3 ac=Camera op=lists sid= uid= cid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Camera",@"ac",
                          @"3",@"v",
                          @"lists", @"op",
                          _cId, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        //[self maskViewAndMenu];
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            _cameraErrorLabel.hidden = YES;
            _cameraErrorButton.hidden = YES;
            
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            NSArray *list = [message objectForKey:@"cameras"];
            _dataArr = [NSMutableArray arrayWithArray:list];
            
            // 如果只有一个摄像头的时候，需要把上一个以及下一个置为不可点击
            if (1 == [_dataArr count]) {
                [_previousButton setUserInteractionEnabled:NO];
                [_nextButton setUserInteractionEnabled:NO];

                [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_p"] forState:UIControlStateNormal];
                [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_p"] forState:UIControlStateNormal];
            }
            
            // 学生与家长如果可用的摄像头只有一个，也需要置为不可点击
            if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
                int openCameraCount = 0;
                for (int i=0; i<[_dataArr count]; i++) {
                    NSDictionary *infoDic = [_dataArr objectAtIndex:i];
                    
                    NSString *open = [infoDic objectForKey:@"open"];
                    if(true == [open intValue]) {
                        openCameraCount = openCameraCount + 1;
                    }
                }
                
                if (openCameraCount <= 1) {
                    [_previousButton setUserInteractionEnabled:NO];
                    [_nextButton setUserInteractionEnabled:NO];
                    
                    [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_p"] forState:UIControlStateNormal];
                    [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_p"] forState:UIControlStateNormal];
                }
            }
            
            NSDictionary *loginDic = [message objectForKey:@"login"];
            if (nil != loginDic) {
                _camera360Model.pushKey = [loginDic objectForKey:@"pushKey"];
                
                NSString *usid = [loginDic objectForKey:@"usid"];
                NSString *encodedValue = [usid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                _camera360Model.usid = encodedValue;
            }
            [self prepareForCamera360];
        }else {
            _cameraErrorLabel.hidden = NO;
            _cameraErrorLabel.text = @"摄像头列表获取失败。";
            
            _cameraErrorButton.hidden = NO;
            [_cameraErrorButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [_cameraErrorButton setTitle:@"重新获取" forState:UIControlStateHighlighted];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        _cameraErrorLabel.hidden = NO;
        _cameraErrorLabel.text = @"摄像头列表获取失败。网络错误";
        
        _cameraErrorButton.hidden = NO;
        [_cameraErrorButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_cameraErrorButton setTitle:@"重新获取" forState:UIControlStateHighlighted];
        
        [Utilities dismissProcessingHud:self.view];
    }];
}

- (void)upView_maskViewAndMenu {
    NSLog(@"显示");
    
    _maskView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
//    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _maskView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_maskView];
    
    TSTapGestureRecognizer *myTapGesture9 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(camera360ScreenTouch:)];
    myTapGesture9.infoStr = @"8";
    myTapGesture9.delegate = self;
    [_maskView addGestureRecognizer:myTapGesture9];

//    [_maskView addGestureRecognizer:[[TSTapGestureRecognizer alloc]initWithTarget:self action:@selector(camera360ScreenTouch)]];

    [self darkGreyView];
    
    // 默认进入时为隐藏的
    _topDarkGreyView.alpha = 0;
    _topDarkGreyView.hidden = YES;
    
    _bottomDarkGreyView.alpha = 0;
    _bottomDarkGreyView.hidden = YES;
    _rightDarkGreyView.alpha = 0;
    _rightDarkGreyView.hidden = YES;
    
    _showDarkGreyView = false;
}

- (void)playSelectCamera {
//    [Utilities showSystemProcessingHud:self.view];
    [Utilities showProcessingHud:self.view];
    
    [self.player stop];
    
//    [self.playerHolderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.playerHolderView removeFromSuperview];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rightDarkGreyView.alpha = 0;
                         _rightDarkGreyView.hidden = YES;
                         
                         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                     }
                     completion:^(BOOL finished) {
                         _showDarkGreyView = 0;
                     }];
    
    [self performSelector:@selector(aaaaa) withObject:nil afterDelay:0.2];
}

- (void)aaaaa {
    self.player.camInfo = self.camInfo;
//    [self.player relayoutPlayerView];
    
//    [self.player relayoutPlayerView];
    [self.player startWithCameraInfo:self.camInfo];
}

- (void)prepareForCamera360 {
#if DEVICE_IPHONE
    if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
        // 学生家长需要判断摄像头是否开启。
        for (int i=0; i<[_dataArr count]; i++) {
            NSDictionary *infoDic = [_dataArr objectAtIndex:i];
            
            NSString *open = [infoDic objectForKey:@"open"];
            BOOL fetchOpenCamera = NO;
            if(true == [open intValue]) {
                // 找到第一个可用的摄像头
                _camera360Model.sn = [infoDic objectForKey:@"sn"];
                _camera360Model.snToken = [infoDic objectForKey:@"token"];
                _camera360Model.userInfo = [Utilities getUniqueUid];
                
                _titleLabel.text = [infoDic objectForKey:@"title"];
                
                if (!fetchOpenCamera) {
                    // 只记录第一个可用摄像头
                    _selectCameraIndex = i;
                }
                
                [_cameraOpenIndexArray addObject:infoDic];
                break;
            }
        }
    }else {
        // 其他身份都可以看
        if (0 != [_dataArr count]) {
            _cameraOpenIndexArray = [NSMutableArray arrayWithArray:_dataArr];
            
            _selectCameraIndex = 0;
            
            NSDictionary *infoDic = [_dataArr objectAtIndex:0];
            _camera360Model.sn = [infoDic objectForKey:@"sn"];
            _camera360Model.snToken = [infoDic objectForKey:@"token"];
            _camera360Model.userInfo = [Utilities getUniqueUid];
            
            _titleLabel.text = [infoDic objectForKey:@"title"];
        }
    }
    
    if (-1 == _selectCameraIndex) {
        [Utilities dismissProcessingHud:self.view];
        
        _cameraErrorLabel.hidden = NO;
        _cameraErrorLabel.text = @"当前时间没有开启的摄像头。";

        _cameraErrorButton.hidden = NO;
        [_cameraErrorButton setTitle:@"返回上一页" forState:UIControlStateNormal];
        [_cameraErrorButton setTitle:@"返回上一页" forState:UIControlStateHighlighted];

        [_tableView reloadData];
        return;
    }else {
        _cameraErrorLabel.hidden = YES;
        _cameraErrorButton.hidden = YES;
    }
    
    [QHCamSDK configStringAppID:_camera360Model.appId appKey:_camera360Model.appSdkKey];
    [QHCamSDK configUserInfo:_camera360Model.userInfo pushKey:_camera360Model.pushKey usid:_camera360Model.usid];
    
    QHCamBaseInfo *camInfo = [[QHCamBaseInfo alloc] init];
    camInfo.sn = _camera360Model.sn;
    camInfo.sn_token = _camera360Model.snToken;
    self.camInfo = camInfo;
    
    self.playerHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:self.playerHolderView];
    [self createPlayer];
    
//    [self.playerHolderView addSubview:_maskView];
    [self.view addSubview:_maskView];
    
    [_tableView reloadData];

    // 判断是否为wifi环境，除了wifi环境外提示用户是否进行播放。
#if 0
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if (ReachableViaWiFi != [r currentReachabilityStatus]) {
        _cameraErrorLabel.hidden = NO;
        _cameraErrorLabel.text = @"您正在使用非wifi网络，播放将产生流量费用。";
        
        _cameraErrorButton.hidden = NO;
        [_cameraErrorButton setTitle:@"继续播放" forState:UIControlStateNormal];
        [_cameraErrorButton setTitle:@"继续播放" forState:UIControlStateHighlighted];
    }else {
        _cameraErrorLabel.hidden = YES;
        _cameraErrorButton.hidden = YES;
        
        [self.player start];
    }
#else
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
             case AFNetworkReachabilityStatusUnknown:
                 NSLog(@"未知");
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 NSLog(@"没有网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                [Utilities dismissProcessingHud:self.view];
                
                _cameraErrorLabel.hidden = NO;
                _cameraErrorLabel.text = @"您正在使用非wifi网络，播放将产生流量费用。";
                
                _cameraErrorButton.hidden = NO;
                [_cameraErrorButton setTitle:@"继续播放" forState:UIControlStateNormal];
                [_cameraErrorButton setTitle:@"继续播放" forState:UIControlStateHighlighted];
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                _cameraErrorLabel.hidden = YES;
                _cameraErrorButton.hidden = YES;
                
                [self.player start];

                 break;
             default:
                 break;
         }
     }];
#endif
    
//    [self.player start];

    
    

    
    
#endif

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.player stop];
}

- (void)createPlayer {
    self.player = [[QHCamLivePlayer alloc] initWithCamInfo:self.camInfo parentView:self.playerHolderView];
    self.player.playerDelegate = self;
//    [self.player setAudioOn:YES];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)timerFunc {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [_currentTime setText:timestamp];
}

-(IBAction)camera360ScreenTouch:(id)sender{
    float alpha = 1;
    
    if (_showDarkGreyView) {
        alpha = 0;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }else {
        alpha = 1;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _topDarkGreyView.alpha = alpha;

                         _bottomDarkGreyView.alpha = alpha;
                         
                         if (alpha == 1) {
                             _topDarkGreyView.hidden = NO;
                             _bottomDarkGreyView.hidden = NO;
                         } else {
                             _topDarkGreyView.hidden = YES;
                             _bottomDarkGreyView.hidden = YES;
                         }
                         
                         
                         _rightDarkGreyView.alpha = 0;
                         _rightDarkGreyView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         _showDarkGreyView = alpha;
                     }];
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    NSLog(@"asjflajdal;kdjflajdfal;kjfla;sdkfjaldskjfas;dlfj");
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //放过以上事件的点击拦截
        return NO;
    }else{
        return YES;
    }
}

-(void)cameraErrorButtonClicked {
    if ([_cameraErrorButton.titleLabel.text isEqualToString:@"返回上一页"]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([_cameraErrorButton.titleLabel.text isEqualToString:@"重新加载"]) {
        [self.player start];

        _cameraErrorButton.hidden = YES;
        _cameraErrorLabel.hidden = YES;
    }else if ([_cameraErrorButton.titleLabel.text isEqualToString:@"继续播放"]) {
        [self.player start];
    }else if ([_cameraErrorButton.titleLabel.text isEqualToString:@"确认"]) {
        
    }else if ([_cameraErrorButton.titleLabel.text isEqualToString:@"重新获取"]) {
        [self cameraList];
        
        _cameraErrorButton.hidden = YES;
        _cameraErrorLabel.hidden = YES;
    }
}

-(void)goBackward {
    [self.player stop];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showRightMenu {

//    [self.settingService getCameraSetting:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        int a=1;
//    }];
//    
//    
//    [self.settingService getCameraSoundSwitch:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        int a=1;
//    }];
//    
//    
//    [self.settingService getCameraVolume:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        int a=1;
//    }];
//    
//    
//    bool b = self.player.currentAudioSwitch;
//    
//    
//    int z = 0;
//    [self.settingService getCameraSoundSwitch:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        NSLog(@"%@", log);
//    }];
    
    
    
//    [self.settingService setCameraSoundSwitch:YES sn:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        NSLog(@"%@", log);
//    }];
//    
//    [self.settingService setCameraVolume:100 sn:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        NSLog(@"%@", log);
//    }];
//    
//    [self.settingService setCameraLightSwitch:YES sn:self.camInfo.sn sn_token:self.camInfo.sn_token callback:^(id value, NSError *err) {
//        NSString *log = [NSString stringWithFormat:@"value = %@, error = %@", value, err];
//        NSLog(@"%@", log);
//        
//    }];
    
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _topDarkGreyView.alpha = 0;
                         _topDarkGreyView.hidden = YES;
                         
                         _bottomDarkGreyView.alpha = 0;
                         _bottomDarkGreyView.hidden = YES;
                         
                         _rightDarkGreyView.alpha = 1;
                         _rightDarkGreyView.hidden = NO;
                         
                         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                     }
                     completion:^(BOOL finished) {
                     }];
    
//    [ReportObject event:ID_ENTER_CAMERA_LIST];//28001
}

-(void)pushactionaa  {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //    CameraTestViewController *vc = [[CameraTestViewController alloc] init];
    ////    [self.navigationController pushViewController:vc animated:YES];
    //    [self presentViewController:vc animated:YES completion:nil];
}

//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}





- (void)darkGreyView {
    if (!_topDarkGreyView) {
        
        
        // 屏幕上方灰色条
        _topDarkGreyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width+20, 64)];
        
        // 灰色背景
        UIImageView *darkGrey = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_topDarkGreyView.frame.size.width, _topDarkGreyView.frame.size.height)];
        darkGrey.image = [UIImage imageNamed:@"Camera360/camera360_bg_darkGrey.png"];
        [_topDarkGreyView addSubview:darkGrey];
        
        // 返回button
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.frame = CGRectMake(10, 25, 33, 33);
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(goBackward) forControlEvents:UIControlEventTouchUpInside];
        [_topDarkGreyView addSubview:leftButton];
        
        // 班级摄像头名称
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                160,
                                                                32,
                                                                [UIScreen mainScreen].bounds.size.width-160*2,
                                                                20)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.text = @"";
        [_topDarkGreyView addSubview:_titleLabel];
        
        // 时间
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
        
        _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 [UIScreen mainScreen].bounds.size.width-160-15,
                                                                 32,
                                                                 160,
                                                                 20)];
        _currentTime.textColor = [UIColor whiteColor];
        _currentTime.backgroundColor = [UIColor clearColor];
        _currentTime.textAlignment = NSTextAlignmentRight;
        _currentTime.font = [UIFont systemFontOfSize:13];
        [_topDarkGreyView addSubview:_currentTime];
        
        [self.maskView addSubview:_topDarkGreyView];
        
        
        // 下方灰色条
        _bottomDarkGreyView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width+20, 44)];
        [self.maskView addSubview:_bottomDarkGreyView];
        
        // 灰色背景
        UIImageView *bottomDarkGrey = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_bottomDarkGreyView.frame.size.width, _bottomDarkGreyView.frame.size.height)];
        bottomDarkGrey.image = [UIImage imageNamed:@"Camera360/camera360_bg_darkGrey.png"];
        [_bottomDarkGreyView addSubview:bottomDarkGrey];
        
        
        // 上一个与下一个摄像头
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousButton.frame = CGRectMake(25, (45-24)/2, 24, 24);
        [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_d"] forState:UIControlStateNormal];
        [_previousButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_previous_p"] forState:UIControlStateSelected];
        [_previousButton addTarget:self action:@selector(previousCamera) forControlEvents:UIControlEventTouchUpInside];
        [_bottomDarkGreyView addSubview:_previousButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(_previousButton.frame.origin.x+25+20, _previousButton.frame.origin.y, 24, 24);
        [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_d"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"Camera360/camera360_button_next_p"] forState:UIControlStateSelected];
        [_nextButton addTarget:self action:@selector(nextCamera) forControlEvents:UIControlEventTouchUpInside];
        [_bottomDarkGreyView addSubview:_nextButton];
        
        // 切换摄像头
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchCameraButton.frame = CGRectMake(
                                               [UIScreen mainScreen].bounds.size.width-20-80,
                                               12,
                                               80,
                                               20);
        _switchCameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _switchCameraButton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        
        // 设置颜色和字体
        [_switchCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_switchCameraButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _switchCameraButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [_switchCameraButton addTarget:self action:@selector(showRightMenu) forControlEvents: UIControlEventTouchUpInside];
        
        //设置title
        [_switchCameraButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
        [_switchCameraButton setTitle:@"切换摄像头" forState:UIControlStateHighlighted];
        
        [_bottomDarkGreyView addSubview:_switchCameraButton];
        
        // 右方灰色条
        _rightDarkGreyView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-200, 0, 200, self.view.bounds.size.height)];
        [self.maskView addSubview:_rightDarkGreyView];
        
        // 灰色背景
        UIImageView *rightDarkGrey = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_rightDarkGreyView.frame.size.width, _rightDarkGreyView.frame.size.height)];
        rightDarkGrey.image = [UIImage imageNamed:@"Camera360/camera360_bg_darkGrey.png"];
        [_rightDarkGreyView addSubview:rightDarkGrey];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _rightDarkGreyView.frame.size.width, _rightDarkGreyView.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_rightDarkGreyView addSubview:_tableView];
        
        _cameraErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                      0,
                                                                      163,
                                                                      [UIScreen mainScreen].bounds.size.width,
                                                                      20)];
        _cameraErrorLabel.textColor = [UIColor whiteColor];
        _cameraErrorLabel.backgroundColor = [UIColor clearColor];
        _cameraErrorLabel.textAlignment = NSTextAlignmentCenter;
        _cameraErrorLabel.font = [UIFont systemFontOfSize:16];
        _cameraErrorLabel.hidden = YES;
        [self.maskView addSubview:_cameraErrorLabel];
        
        // 切换摄像头
        _cameraErrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraErrorButton.frame = CGRectMake(
                                              ([UIScreen mainScreen].bounds.size.width-150)/2,
                                              _cameraErrorLabel.frame.origin.y + _cameraErrorLabel.frame.size.height+20,
                                              150,
                                              20);
        _cameraErrorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _cameraErrorButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        
        // 设置颜色和字体
        [_cameraErrorButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cameraErrorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _cameraErrorButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [_cameraErrorButton addTarget:self action:@selector(cameraErrorButtonClicked) forControlEvents: UIControlEventTouchUpInside];
        
        //设置title
        [_cameraErrorButton setTitle:@"" forState:UIControlStateNormal];
        [_cameraErrorButton setTitle:@"" forState:UIControlStateHighlighted];
        
        _cameraErrorButton.hidden = YES;
        [self.maskView addSubview:_cameraErrorButton];
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    NSDictionary* dic = [_dataArr objectAtIndex:row];
    
    Camera360TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[Camera360TableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.cameraNameLabel.text = [dic objectForKey:@"title"];
    cell.cameraId = [dic objectForKey:@"id"];
    
    // 选中的为蓝色
    if (_selectCameraIndex == row) {
        cell.cameraIconImageView.hidden = NO;
        cell.cameraNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1];
    }else {
        cell.cameraIconImageView.hidden = YES;
        cell.cameraNameLabel.textColor = [UIColor whiteColor];
    }
    
    // 只有班管才显示设置button
    if (!_isAdmin) {
        cell.cameraIconButton.hidden = YES;
    }else {
        cell.cameraIconButton.hidden = NO;
    }

    // 学生与家长不可看的摄像头为灰色
    if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
        NSString *open = [dic objectForKey:@"open"];
        if(true == [open intValue]) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        }else {
            cell.cameraNameLabel.textColor = [UIColor grayColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    
    cell.cameraOpenTimeLabel.text = [dic objectForKey:@"open_time"];
    
    return  cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUInteger row = [indexPath row];
    NSDictionary* dic = [_dataArr objectAtIndex:row];
 
    if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
        NSString *open = [dic objectForKey:@"open"];

        if(true == [open intValue]) {
            [self resetCameraInfo:dic];
            
            _titleLabel.text = [dic objectForKey:@"title"];
            _selectCameraIndex = row;
            
            [_tableView reloadData];
            
            [self playSelectCamera];
        }
    }else {
        [self resetCameraInfo:dic];
        
        _titleLabel.text = [dic objectForKey:@"title"];
        _selectCameraIndex = row;
        
        [_tableView reloadData];
        
        [self playSelectCamera];
    }
}

- (void)nextCamera {
    for (int i=0; i<([_dataArr count]-1); i++) {
        // 遍历数组中除了自己之外的元素
        // 为当前数组中选择的index加1
        _selectCameraIndex -= 1;
        
        if (_selectCameraIndex < 0) {
            // 如果增了index之后超出了数组的最大元素的范围，将index赋值为[_dataArr count]-1，从最后的元素往前遍历
            _selectCameraIndex = ([_dataArr count]-1);
        }
        
        NSDictionary *infoDic = [_dataArr objectAtIndex:_selectCameraIndex];
        
        if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
            NSString *open = [infoDic objectForKey:@"open"];
            
            if(true == [open intValue]) {
                _camera360Model.sn = [infoDic objectForKey:@"sn"];
                _camera360Model.snToken = [infoDic objectForKey:@"token"];
                _camera360Model.userInfo = [Utilities getUniqueUid];
                
                self.camInfo.sn = _camera360Model.sn;
                self.camInfo.sn_token = _camera360Model.snToken;
                
                _titleLabel.text = [infoDic objectForKey:@"title"];
                
                break;
            }
        }else {
            _camera360Model.sn = [infoDic objectForKey:@"sn"];
            _camera360Model.snToken = [infoDic objectForKey:@"token"];
            _camera360Model.userInfo = [Utilities getUniqueUid];
            
            self.camInfo.sn = _camera360Model.sn;
            self.camInfo.sn_token = _camera360Model.snToken;
            
            _titleLabel.text = [infoDic objectForKey:@"title"];
        }
    }
    
    [_tableView reloadData];
    [self playSelectCamera];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _topDarkGreyView.alpha = 0;
                         _topDarkGreyView.hidden = YES;
                         
                         _bottomDarkGreyView.alpha = 0;
                         _bottomDarkGreyView.hidden = YES;
                         
                         _rightDarkGreyView.alpha = 0;
                         _rightDarkGreyView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         _showDarkGreyView = 0;
                     }];
}

- (void)previousCamera {
    for (int i=0; i<([_dataArr count]-1); i++) {
        // 遍历数组中除了自己之外的元素
        // 为当前数组中选择的index加1
        _selectCameraIndex += 1;
        
        if (_selectCameraIndex > ([_dataArr count]-1)) {
            // 如果增了index之后超出了数组的最大元素的范围，将index赋值为0，从头开始遍历
            _selectCameraIndex = 0;
        }
        
        NSDictionary *infoDic = [_dataArr objectAtIndex:_selectCameraIndex];
        if ((UserType_Student == [Utilities getUserType]) || (UserType_Parent == [Utilities getUserType])) {
            NSString *open = [infoDic objectForKey:@"open"];
            
            if(true == [open intValue]) {
                _camera360Model.sn = [infoDic objectForKey:@"sn"];
                _camera360Model.snToken = [infoDic objectForKey:@"token"];
                _camera360Model.userInfo = [Utilities getUniqueUid];
                
                self.camInfo.sn = _camera360Model.sn;
                self.camInfo.sn_token = _camera360Model.snToken;
                
                _titleLabel.text = [infoDic objectForKey:@"title"];
                
                break;
            }
        }else {
            _camera360Model.sn = [infoDic objectForKey:@"sn"];
            _camera360Model.snToken = [infoDic objectForKey:@"token"];
            _camera360Model.userInfo = [Utilities getUniqueUid];
            
            self.camInfo.sn = _camera360Model.sn;
            self.camInfo.sn_token = _camera360Model.snToken;
            
            _titleLabel.text = [infoDic objectForKey:@"title"];
        }
    }
    
    [_tableView reloadData];
    [self playSelectCamera];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _topDarkGreyView.alpha = 0;
                         _topDarkGreyView.hidden = YES;
                         
                         _bottomDarkGreyView.alpha = 0;
                         _bottomDarkGreyView.hidden = YES;
                         
                         _rightDarkGreyView.alpha = 0;
                         _rightDarkGreyView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         _showDarkGreyView = 0;
                     }];
}

- (void)resetCameraInfo:(NSDictionary *)dic {
    _camera360Model.sn = [dic objectForKey:@"sn"];
    _camera360Model.snToken = [dic objectForKey:@"token"];
    _camera360Model.userInfo = [Utilities getUniqueUid];
    
    self.camInfo.sn = _camera360Model.sn;
    self.camInfo.sn_token = _camera360Model.snToken;
}

#pragma mark - 播放回调
- (void)onGetRelayInfoResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg {
    [Utilities dismissProcessingHud:self.view];
    
    if (0 == code) {
        [self.playerHolderView removeFromSuperview];
        
        _cameraErrorLabel.hidden = NO;
        _cameraErrorLabel.text = msg;
        
        _cameraErrorButton.hidden = NO;
        [_cameraErrorButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_cameraErrorButton setTitle:@"重新加载" forState:UIControlStateHighlighted];
    }else {
        [self.view insertSubview:self.playerHolderView belowSubview:_maskView];

        _cameraErrorLabel.hidden = YES;
        _cameraErrorButton.hidden = YES;
    }
    
    NSLog(@"onGetRelayInfoResultWithEvent-----------code is = %d, msg = %@", code, msg);
}


- (void)onOpenPlayResultWithEvent:(VideoPlayEvent)code msg:(NSString*)msg {
    if (code == VPM_OPEN_PLAYER_SUCCESS) {
        self.isPlayingState = YES;
    }else{
        self.isPlayingState = NO;
    }
    
    [self.player setAudioOn:YES];

    NSLog(@"onOpenPlayResultWithEvent-----------------code is = %d, msg = %@", code, msg);
}


- (void)onClosePlayResultWithEvent:(VideoPlayEvent)code msg:(NSString*)msg{
    NSLog(@"onClosePlayResultWithEvent-----------------code is = %d, msg = %@", code, msg);
}


#pragma mark - 播放状态相关回调
//buffering
- (void)onPlayerStateBuffering {
    NSLog(@"onPlayerStateBuffering is called");
}

//buffering timeout
- (void)onPlayerStateBufferingTimeout {
    NSLog(@"onPlayerStateBufferingTimeout is called");
}

//buffered
- (void)onPlayerStateBuffered{
    NSLog(@"onPlayerStateBuffered is called");
}

//play error
- (void)onPlayerStateError {
    NSLog(@"onPlayerStateError is called");
}

//play over
- (void)onPlayerStatePlayEnd {
    NSLog(@"onPlayerStatePlayEnd is called");
}



//play progress
- (BOOL)onVideoDateSeconds:(long long)mseconds{
    [Utilities dismissProcessingHud:self.view];
    
    NSLog(@"onVideoDateSeconds-------------cmsecondsode is = %lld", mseconds);
    
    return YES;
}


#pragma mark - 摄像机设置相关回调
//snap screen
- (void)onSnapScreenResult:(UIImage *)image err:(VideoSnapEvent)event
{
    NSLog(@"image = %@, event = %d", image, event);

    //    QHCSDKDEMO_LOG(@"image = %@, event = %d", image, event);
}


//close/open player audio
- (void)onAudioStateSwitch:(BOOL)isOn
{
    NSLog(@"audio state = %d", isOn);

    //    QHCSDKDEMO_LOG(@"audio state = %d", isOn);
}


//video resolution change callback
- (void)onSwitchVideoResolution:(VedioResolution)nowVr withMsg:(VideoResolutionEvent)resolutionMsg
{
    NSLog(@"video resolution = %d, event = %d", nowVr, resolutionMsg);

    //    QHCSDKDEMO_LOG(@"video resolution = %d, event = %d", nowVr, resolutionMsg);
}


//upload speed/download speed
- (void)onSpeed:(int)upSpeed withDownSpeed:(int)downSpeed
{
    //    QHCSDKDEMO_LOG(@"upSpeed = %d, downSpeed = %d", upSpeed, downSpeed);
}


#pragma mark - 录像相关
- (void)onRecordTime:(long long)recordedSeconds
{
    //    QHCSDKDEMO_LOG(@"time = %llu", recordedSeconds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#endif


@end

//
//  SightRecordViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 4/14/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "SightRecordViewController.h"

@interface SightRecordViewController ()

@end

@implementation SightRecordViewController

#define TIMER_INTERVAL 0.05
#define PREVIEW_HEIGHT 416
#define PROCESS_HEIGHT 0

#define UP_CANCEL 270

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomizeLeftButtonWithName:@"取消"];
    [super setCustomizeTitle:@""];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    
    _totalTime = 6;
    _progressStep = 320*TIMER_INTERVAL/_totalTime;
    
    _preLayerWidth = 320;
    _preLayerHeight = PREVIEW_HEIGHT;
    _preLayerHWRate =_preLayerHeight/_preLayerWidth;
    
    
//        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
//            AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            if (authorizationStatus == AVAuthorizationStatusRestricted
//                || authorizationStatus == AVAuthorizationStatusDenied) {
//                
//                // 没有权限
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                               message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                              delegate:self
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                alert.tag = 483;
//                [alert show];
//            }
//        }else {
//            [self initCapture];
//            
//        }
    
    
//    // 先获取摄像头的状态
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    BOOL audioStatus = [Utilities canRecord];
//        
//    if ((authStatus != AVAuthorizationStatusAuthorized) || !audioStatus) {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                       message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                      delegate:self
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        alert.tag = 483;
//        [alert show];
//    }else {
//        [self initCapture];
//
//    }

    
    // 先判断音频
    BOOL audioStatus = [Utilities canRecord];

    if (audioStatus) {
        // 音频权限开的
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
        {
            case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
            {
                NSLog(@"授权摄像头使用成功");
                [self initCapture];
                [super setCustomizeBackgroundImg:@"title_bgImage_black.png"];

                break;
            }
            case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
            {
                //则再次请求授权
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(granted){    //用户授权成功
                            
                            //                        [self performSelector:@selector(initCapture) withObject:nil afterDelay:0.3];
                            
                            [self initCapture];
                            
                            
                            
                            
                            
                            
                            
                            
                            [super setCustomizeBackgroundImg:@"title_bgImage_black.png"];
                            
                            return;
                            
                        } else {        //用户拒绝授权
                            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                           message:@"请在设置里面打开相机与麦克风对知校的权限。"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
                            alert.tag = 483;
                            [alert show];
                            return;
                        }
                    });
                }];
                break;
            }
            default:                                    //用户拒绝授权/未授权
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"请在设置里面打开相机与麦克风对知校的权限。"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                alert.tag = 483;
                [alert show];
                break;
            }
        }

    }else {
        // 没有音频权限
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"请在设置里面打开相机与麦克风对知校的权限。"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        alert.tag = 483;
        [alert show];
        return;

    }
    
    
    
    
    
//    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
//    {
//        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
//        {
//            NSLog(@"授权摄像头使用成功");
//            
//            BOOL audioStatus = [Utilities canRecord];
//            if (!audioStatus) {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                               message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                              delegate:self
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                alert.tag = 483;
//                [alert show];
//
//            }else {
//                [self initCapture];
//                break;
//            }
//        }
//        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
//        {
//            //则再次请求授权
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if(granted){    //用户授权成功
//                    
//                    BOOL audioStatus = [Utilities canRecord];
//                    if (!audioStatus) {
//                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                                       message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"确定"
//                                                             otherButtonTitles:nil];
//                        alert.tag = 483;
//                        [alert show];
//                        
//                    }else {
//                        [self initCapture];
//                        
//                        [super setCustomizeBackgroundImg:@"title_bgImage_black.png"];
//                        
//                        return;
//                    }
//
//                } else {        //用户拒绝授权
//                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                                   message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                                  delegate:self
//                                                         cancelButtonTitle:@"确定"
//                                                         otherButtonTitles:nil];
//                    alert.tag = 483;
//                    [alert show];
//                    return;
//                }
//            }];
//            break;
//        }
//        default:                                    //用户拒绝授权/未授权
//        {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                           message:@"请在设置里面打开相机与麦克风对知校的权限。"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            alert.tag = 483;
//            [alert show];
//            break;
//        }
//    }
//
//    
//    [super setCustomizeBackgroundImg:@"title_bgImage_black.png"];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 483) {
        [super setCustomizeBackgroundImg:@"title_bgImage.png"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [super setCustomizeBackgroundImg:@"title_bgImage_black.png"];

//    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    
    [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, 0, 4)];
    [_startButton appearAnimation];
    [_tipsLabel removeFromSuperview];


}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [super setCustomizeBackgroundImg:@"title_bgImage.png"];

    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)initCapture{
    

    //视频高度加进度条（10）高度
    //    self.viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320 , PREVIEW_HEIGHT)];
    //    [self.view addSubview:self.viewContainer];
    
#if 9
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    
    [_captureSession beginConfiguration];

    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
#else
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    
    
#endif
    
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer= self.view.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=  CGRectMake(0, 0, WIDTH, PREVIEW_HEIGHT);
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //    [layer insertSublayer:_captureVideoPreviewLayer above:self.view.layer];
    [layer addSublayer:_captureVideoPreviewLayer];
    
    //    [self addGenstureRecognizer];
    
    [_captureSession commitConfiguration];

    //进度条
    _progressPreView = [[UIView alloc]initWithFrame:CGRectMake(0, PROCESS_HEIGHT, 0, 4)];
    _progressPreView.backgroundColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:169/255.0 alpha:1.0];
    //    _progressPreView.layer.borderWidth = 0;
    //    _progressPreView.layer.cornerRadius = 2;
    //    _progressPreView.layer.masksToBounds = YES;
    
    [self.view addSubview:_progressPreView];
    
//    CABasicAnimation *countTime = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//    countTime.toValue = @6;
//    countTime.duration = _currentTime;
//    countTime.removedOnCompletion = NO;
//    countTime.fillMode = kCAFillModeForwards;
//    [_progressPreView.layer addAnimation:countTime forKey:@"progressAni"];
    
    
    _startButton = [[RecordSightStartButton alloc]initWithFrame:CGRectMake((320-125)/2, PREVIEW_HEIGHT-150, 125, 125)];
    //    [self.view insertSubview:_startButton atIndex:0];
    [self.view addSubview:_startButton];
    
    
    //拍摄手势
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [_startButton addGestureRecognizer:panGesture];
    UILongPressGestureRecognizer *longPressGeture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startAction:)];
    longPressGeture.delegate = self;
    longPressGeture.minimumPressDuration = 0.1;
    [_startButton addGestureRecognizer:longPressGeture];
    
    [self.captureSession startRunning];

    
}

//-(void) orientationChanged {
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    if (deviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
//
//    else if (deviceOrientation == UIInterfaceOrientationPortrait)
//        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
//
//    else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft)
//        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
//
//    else
//        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
//}


#pragma mark - 私有方法
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}



#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
    [self startTimer];
}



-(void)startTimer{
    
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [_countTimer fire];
}

- (void)onTimer:(NSTimer *)timer
{
    float progressWidth = _progressPreView.frame.size.width+_progressStep;

    [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, progressWidth, 4)];

    _currentTime += TIMER_INTERVAL;
//    float progressWidth = _progressPreView.frame.size.width+_progressStep;
    
    NSLog(@"progressWidth %f", progressWidth);
    NSLog(@"_currentTime %f", _currentTime);
    
//    [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, progressWidth, 4)];
    if (_currentTime>2) {
        //        finishBt.hidden = NO;
    }
    
    //时间到了停止录制视频
    if (_currentTime>=_totalTime) {

        _isCancel = NO;
        [_countTimer invalidate];
        _countTimer = nil;
        [_captureMovieFileOutput stopRecording];
    }
    
}

-(void)panAction:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (point.y < UP_CANCEL) {
        _isCancel = YES;
        _tipsLabel.text = @"松手取消";
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor redColor];
    }
    else{
        _isCancel = NO;
        _tipsLabel.text = @"上移取消";
        _tipsLabel.textColor = [UIColor greenColor];
        _tipsLabel.backgroundColor = [UIColor clearColor];
    }
}

-(void)startAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _currentTime = 0;
        _isCancel = NO;
        
        [_startButton disappearAnimation];
        
        
        
        //根据设备输出获得连接
        AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        //        captureConnection.videoOrientation=AVCaptureVideoOrientationLandscapeLeft;
        
        NSLog(@"准备录制，路径为：%@", [self getVideoMergeFilePathString]);
        
        
        //        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoSaveFilePathString]] recordingDelegate:self];
        
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoSaveFilePathString]] recordingDelegate:self];
        
        //        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoMergeFilePathString]]outputFileType: recordingDelegate:self];
        
        //        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoMergeFilePathString]] recordingDelegate:self];
        
        
        
        
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-42, PROCESS_HEIGHT+30, 84, 20)];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor greenColor];
        _tipsLabel.text = @"上移取消";
        [self.view addSubview:_tipsLabel];
        
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (_isCancel) {
            // 上移取消录制
            [_countTimer invalidate];
            [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, 0, 4)];
            [_startButton appearAnimation];
            [_tipsLabel removeFromSuperview];
            
            [_captureMovieFileOutput stopRecording];
            
            
            return;
            
        }else {
            if (_currentTime < 1) {
                
                
                [_countTimer invalidate];
                //                _progressPreView.hidden = YES;
                [_startButton appearAnimation];
                [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, 0, 4)];
                
                [_captureMovieFileOutput stopRecording];
                
                _tipsLabel.hidden = NO;
                _tipsLabel.alpha = 1;
                _tipsLabel.text = @"录制时间太短";
                _tipsLabel.textColor = [UIColor whiteColor];
                _tipsLabel.backgroundColor = [UIColor redColor];
                [UIView animateWithDuration:0.9 animations:^{
                    _tipsLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    if ([@"_tipsLabel.text"  isEqual: _tipsLabel.text]) {
                        [_tipsLabel removeFromSuperview];
                    }
                }];
                return;
            }
            else if(_currentTime >=1 && _currentTime < 6){
                [_countTimer invalidate];
                
                _tipsLabel.hidden = YES;
                
                [_progressPreView setFrame:CGRectMake(0, PROCESS_HEIGHT, 0, 4)];
                [_startButton appearAnimation];
                
                [_captureMovieFileOutput stopRecording];
                
                //                [self finishCamera];
            }
            
        }
        
        
        
    }
    
    
    
    
}

#define VIDEO_FOLDER @"videoFolder"

//录制保存的时候要保存为 mov
- (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mov"];
    
    return fileName;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}




//最后合成为 mp4
- (NSString *)getVideoMergeFilePathString
{
    //    NSLog(@"%@", path11);
    
    //    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path11];
    //    for (NSString *fileName in enumerator)
    //    {
    //        NSLog(@"%@", fileName);
    //    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
//    NSString *sightDocPath = [Utilities getFilePath:PathType_SightPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager removeItemAtPath:path error:nil];

    NSArray *pathaaa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [pathaaa objectAtIndex:0];
    
    NSString *amrDocPath = [documentPath stringByAppendingPathComponent:VIDEO_FOLDER];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:amrDocPath]) {
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:amrDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path11 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"sightTemp";
    //    formatter.dateFormat = @"1";
    
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"Merge.mp4"];
    
    return fileName;
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    NSLog(@"录制结束...");
    
    //    NSLog(@"开始压缩,压缩前大小 %f MB",[self getfileSize:outputFileURL]);
    
    //    [urlArray addObject:outputFileURL];
    
    //    [urlArray addObject:outputFileURL];
    //    //时间到了
    if (_currentTime>=1) {
        
        if (!_isCancel) {
            NSMutableArray *a = [NSMutableArray arrayWithObject:outputFileURL];
            [self mergeAndExportVideosAtFileURLs:a];

        }
        //
        
        //        [self compressVideo:a];
        //        //        [self compressVideo];
    }
}

- (IBAction)compressVideo:(NSMutableArray *)fileURLArray
{
    NSString *path = [self getVideoSaveFilePathString];
    
    NSLog(@"开始压缩,压缩前大小 %f MB",[self getfileSize:path]);
    
    ShowSightViewController* view = [[ShowSightViewController alloc]init];
    view.url = [NSURL fileURLWithPath:path];
    [self.navigationController pushViewController:view animated:YES];
    
    
    //    NSURL *a;
    //    a.absoluteString
    
#if 0
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:[fileURLArray objectAtIndex:0] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = [fileURLArray objectAtIndex:0];
        //优化网络
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                NSLog(@"压缩完毕,压缩后大小 %f MB",[self getfileSize:path]);
                //                [self saveVideo:[self compressedURL]];
            }else{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            }
            
            //            self.saveBtn.enabled = YES;
        }];
    }
#endif
}

- (void)mergeAndExportVideosAtFileURLs:(NSMutableArray *)fileURLArray
{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    CMTime totalDuration = kCMTimeZero;
    
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    for (NSURL *fileURL in fileURLArray) {
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        [assetArray addObject:asset];
        
        NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
        if (tmpAry.count>0) {
            AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
            [assetTrackArray addObject:assetTrack];
            
            CGSize a = assetTrack.naturalSize;
            renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
            renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        }
    }
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    //    CGFloat renderW = MIN(200, 200)、
    
    NSLog(@"---------start------------");
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSArray*dataSourceArray= [asset tracksWithMediaType:AVMediaTypeAudio];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:([dataSourceArray count]>0)?[dataSourceArray objectAtIndex:0]:nil
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0+_preLayerHWRate*(_preLayerHeight-_preLayerWidth)/2));
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    NSLog(@"---------end------------");
    
    NSString *path = [self getVideoMergeFilePathString];
    NSURL *mergeFileURL = [NSURL fileURLWithPath:path];
    
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 100);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW*_preLayerHWRate);
    
    
    
    
#if 9
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.videoSize.text = [NSString stringWithFormat:@"%f MB",[self getfileSize:outPutPath]];
            
            //            float a = [self getfileSize:path];
            
            NSMutableArray *ary = [[NSMutableArray alloc] init];
            
            //            for (int i=1; i<2; i++) {
            //                NSString *url = [NSString  stringWithFormat:@"/var/mobile/Containers/Data/Application/4E722D47-549D-40F2-A1E4-853C70D09204/Documents/videoFolder/%dmerge.mp4",i];
            //                NSURL *mergeFileURL1 = [NSURL fileURLWithPath:url];
            //
            //                [ary addObject:mergeFileURL1];
            //            }
            
            
#if 0
            NSString *path11 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path11];
            for (NSString *fileName in enumerator)
            {
                if (![@"videoFolder"  isEqual: fileName]) {
                    NSString *url = [NSString stringWithFormat:@"%@/%@", path11, fileName];
                    float a = [self getfileSize:url];
                    NSLog(@"file url=%@", url);
                    NSLog(@"file size=%f MB", a);
                    
                    NSURL *mergeFileURL1 = [NSURL fileURLWithPath:url];
                    
                    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:
                                        mergeFileURL1, @"fileUrl",
                                        fileName, @"fileName",
                                        nil];
                    
                    [ary addObject:dic];
                    
                }
                
                
            }
#endif
            
            float a = [self getfileSize:mergeFileURL.absoluteString];
            float b = [self getfileSize:path];
            
            
            //            [self saveVideo:mergeFileURL];
            
            //            ShowSightViewController* view = [[ShowSightViewController alloc]init];
            //            view.url = mergeFileURL;
            //            [self.navigationController pushViewController:view animated:YES];
            
            
            
            
            
            
            AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:mergeFileURL options:nil];
            
            //    [movieAsset ];
            
            NSError *error;
            
            AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:movieAsset error:&error];
            
            UIImage *image;

            if (nil != reader) {
                NSArray* videoTracks = [movieAsset tracksWithMediaType:AVMediaTypeVideo];
                AVAssetTrack* videoTrack = [videoTracks objectAtIndex:0];
                // 视频播放时，m_pixelFormatType=kCVPixelFormatType_32BGRA
                // 其他用途，如视频压缩，m_pixelFormatType=kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
                
                int m_pixelFormatType;
                m_pixelFormatType = kCVPixelFormatType_32BGRA;
                
                NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                            (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
                AVAssetReaderTrackOutput* videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                                               initWithTrack:videoTrack outputSettings:options];
                [reader addOutput:videoReaderOutput];
                [reader startReading];
                
                
                
                
                AVAssetReaderStatus a = [reader status];
                
                NSError *aaaa = reader.error;
                int bbbb = aaaa.code;
                
                int b= videoTrack.nominalFrameRate;
                NSLog(@"---------start---------- %ld", (long)a);
                
                CMSampleBufferRef videoBuffer;
                //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
                
                    // 读取video sample
                    videoBuffer = [videoReaderOutput copyNextSampleBuffer];
                
                CVImageBufferRef buffer;
                buffer = CMSampleBufferGetImageBuffer(videoBuffer);
                CVPixelBufferLockBaseAddress(buffer, 0);
                
                //从 CVImageBufferRef 取得影像的细部信息
                uint8_t *base;
                size_t width, height, bytesPerRow;
                base = CVPixelBufferGetBaseAddress(buffer);
                width = CVPixelBufferGetWidth(buffer);
                height = CVPixelBufferGetHeight(buffer);
                bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
                
                //利用取得影像细部信息格式化 CGContextRef
                CGColorSpaceRef colorSpace;
                CGContextRef cgContext;
                colorSpace = CGColorSpaceCreateDeviceRGB();
                cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                
                //透过 CGImageRef 将 CGContextRef 转换成 UIImage
                CGImageRef cgImage;
                cgImage = CGBitmapContextCreateImage(cgContext);
                image = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
                CGContextRelease(cgContext);
                
                CVPixelBufferUnlockBaseAddress(buffer, 0);
                
                //成功转换成 UIImage
                //[myImageView setImage:image];
            }
            
//            [_aaa removeFromSuperview];
//            _aaa = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//            [_aaa setImage:image];
//            [self.view addSubview:_aaa];
            
            
            
            
            //png格式
            NSData *imagedata=UIImagePNGRepresentation(image);
            //JEPG格式
            //NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);
            
            NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documentsDirectory=[paths objectAtIndex:0];
            
            
            NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"SightThumb.png"];
            
            BOOL qq = [imagedata writeToFile:savedImagePath atomically:YES];
            
            

            
            [super setCustomizeBackgroundImg:@"title_bgImage.png"];

            
    
            if ([@"PhotoHome" isEqualToString:_fromName]) {
                
                //------ 小视频发布页--------------------------------------------
                PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
                publish.flag = 3;
                publish.fromName = _fromName;
                publish.videoPath = path;
                publish.thumbImg = image;
                publish.cid = _cid;
                if (qq) {
                    publish.thumbImgPath = savedImagePath;
                }
                //            @property(nonnull,strong)NSString *thumbImgPath;//小视频缩略图本地path
                //            publish
                [self.navigationController pushViewController:publish animated:YES];
                //---------------------------------------------------------------------
                
            }else if ([@"myMoment" isEqualToString:_fromName]){
                
                PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
                publish.cid = _cid;
                publish.flag = 3;
                publish.videoPath = path;
                publish.thumbImg = image;
                
                if (qq) {
                    publish.thumbImgPath = savedImagePath;
                }
                //            @property(nonnull,strong)NSString *thumbImgPath;//小视频缩略图本地path
                //            publish
                [self.navigationController pushViewController:publish animated:YES];
                
            }else{
                
                PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
                publish.fromName = @"class";
                publish.cid = _cid;
                publish.flag = 3;
                publish.videoPath = path;
                publish.thumbImg = image;
                
                if (qq) {
                    publish.thumbImgPath = savedImagePath;
                }
                //            @property(nonnull,strong)NSString *thumbImgPath;//小视频缩略图本地path
                //            publish
                [self.navigationController pushViewController:publish animated:YES];
            }
            
            
           

            
            
            
        
//            // Create paths to output images
//            NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
//            
//            // Write a UIImage to JPEG with minimum compression (best quality)
//            // The value 'image' must be a UIImage object
//            // The value '1.0' represents image compression quality as value from 0.0 to 1.0
//            [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
//            
//            // Write image to PNG
//            [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
//            
//            // Let's check to see if files were successfully written...
//            
//            // Create file manager
//            NSFileManager *fileMgr = [NSFileManager defaultManager];
//            
//            // Point to Document directory
//            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//            
//            // Write out the contents of home directory to console  
//            NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirect]
            
                                               
            
            
//            SightPlayerViewController* view = [[SightPlayerViewController alloc]init];
//            view.videoURL = mergeFileURL;
//            [self.navigationController pushViewController:view animated:YES];
            
            //            SightPlayer* view = [[SightPlayer alloc]initWithFrame:CGRectMake(0, 0, 640, 1136)];
            //            view.backgroundColor = [UIColor blackColor];
            //            view.videoURL = mergeFileURL;
            //            [view showPlayer];
            //            [self.view addSubview:view];
            
            //            [self.navigationController pushViewController:view animated:YES];
            
            
            
            //                        PlayVideoViewController* view = [[PlayVideoViewController alloc]init];
            //                        view.videoURL =mergeFileURL;
            //                        [self.navigationController pushViewController:view animated:YES];
            
        });
    }];
#else
    
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:mergeFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.videoSize.text = [NSString stringWithFormat:@"%f MB",[self getfileSize:outPutPath]];
            
            //            float a = [self getfileSize:path];
            
            NSMutableArray *ary = [[NSMutableArray alloc] init];
            
            //            for (int i=1; i<2; i++) {
            //                NSString *url = [NSString  stringWithFormat:@"/var/mobile/Containers/Data/Application/4E722D47-549D-40F2-A1E4-853C70D09204/Documents/videoFolder/%dmerge.mp4",i];
            //                NSURL *mergeFileURL1 = [NSURL fileURLWithPath:url];
            //
            //                [ary addObject:mergeFileURL1];
            //            }
            
            
#if 0
            NSString *path11 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path11];
            for (NSString *fileName in enumerator)
            {
                if (![@"videoFolder"  isEqual: fileName]) {
                    NSString *url = [NSString stringWithFormat:@"%@/%@", path11, fileName];
                    float a = [self getfileSize:url];
                    NSLog(@"file url=%@", url);
                    NSLog(@"file size=%f MB", a);
                    
                    NSURL *mergeFileURL1 = [NSURL fileURLWithPath:url];
                    
                    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:
                                        mergeFileURL1, @"fileUrl",
                                        fileName, @"fileName",
                                        nil];
                    
                    [ary addObject:dic];
                    
                }
                
                
            }
#endif
            
            float a = [self getfileSize:mergeFileURL.absoluteString];
            float b = [self getfileSize:path];
            
            ShowSightViewController* view = [[ShowSightViewController alloc]init];
            view.url = mergeFileURL;
            [self.navigationController pushViewController:view animated:YES];
            
            //            SightPlayerViewController* view = [[SightPlayerViewController alloc]init];
            //            view.videoURL = mergeFileURL;
            //            [self.navigationController pushViewController:view animated:YES];
            
            //            SightPlayer* view = [[SightPlayer alloc]initWithFrame:CGRectMake(0, 0, 640, 1136)];
            //            view.backgroundColor = [UIColor blackColor];
            //            view.videoURL = mergeFileURL;
            //            [view showPlayer];
            //            [self.view addSubview:view];
            
            //            [self.navigationController pushViewController:view animated:YES];
            
            
            
            //            PlayVideoViewController* view = [[PlayVideoViewController alloc]init];
            //            view.videoURL =mergeFileURL;
            //            [self.navigationController pushViewController:view animated:YES];
            
        });
    }];
    
    
    
    
    
    
    
    
    
    
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:mergeFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = [self compressedURL];
        //优化网络
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            
            int a=[exportSession status];
            
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                //                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
                [self saveVideo:[self compressedURL]];
            }else{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            }
            
            //            self.saveBtn.enabled = YES;
        }];
        
        
        
    }
    
    
#endif
    
}

- (void)saveVideo:(NSURL *)outputFileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"保存视频失败:%@",error);
                                    } else {
                                        NSLog(@"保存视频到相册成功");
                                    }
                                }];
}

#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"compressed.mp4"]]];
}


- (CGFloat)getfileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    //    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00 /1024.00);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
}

@end

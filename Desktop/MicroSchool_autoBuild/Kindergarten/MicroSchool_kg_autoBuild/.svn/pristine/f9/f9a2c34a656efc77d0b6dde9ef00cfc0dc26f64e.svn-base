//
//  CCTVViewController.m
//  MicroSchool
//
//  Created by jojo on 15/8/24.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "CCTVViewController.h"

@interface CCTVViewController ()

@end

@implementation CCTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 268)];
    [self.view addSubview:_imageView];
    
    [Utilities showProcessingHud:self.view];
    [self performSelector:@selector(doPreareCCTV) withObject:nil afterDelay:0.3];
    
    self.view.backgroundColor = [UIColor blackColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCCTV)
                                                 name:@"closeCCTV"
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cctvEnterBackground)
                                                 name:@"cctvEnterBackground"
                                               object:nil];

}

-(void)cctvEnterBackground{
    // 切到后台再恢复回来后，ffMepg的库无法再次播放，而且此时释放资源的话会导致内存泄露
    // 无法修改库，只能在切后台时候，把资源release掉，才可以退出
    [self.nextFrameTimer invalidate];

//    [_rtspPlayer closeAudio];
//    
//    if (_rtspPlayer) {
//        _rtspPlayer = nil;
//    }
}

- (void)closeCCTV
{
    [self.navigationController popViewControllerAnimated:YES];
//    [_rtspPlayer closeAudio];
//    
//    _isReadyPlay = @"1";
//    
//    if (_rtspPlayer) {
//        _rtspPlayer = nil;
//    }
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
}

- (void)doPreareCCTV
{
//    // 需要把ffMpeg的init工作放到线程里，不然就会阻塞ui主线程。
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _rtspPlayer = [[RTSPPlayer alloc] initWithVideo:_playUrl usesTcp:YES];
//          dispatch_async(dispatch_get_main_queue(), ^{
//            [self performSelector:@selector(showPlayer) withObject:nil afterDelay:0.1];
//        });
//    });
}

- (void)showPlayer
{
//    if (![@"1"  isEqual: _isReadyPlay]) {
//        _rtspPlayer.outputWidth = 320;
//        _rtspPlayer.outputHeight = 268;
//        
//        NSLog(@"video duration: %f",_rtspPlayer.duration);
//        NSLog(@"video size: %d x %d", _rtspPlayer.sourceWidth, _rtspPlayer.sourceHeight);
//        
//        // seek to 0.0 seconds
//        [_rtspPlayer seekTime:0.0];
//        
//        [_nextFrameTimer invalidate];
//        
//        self.nextFrameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/20
//                                                               target:self
//                                                             selector:@selector(displayNextFrame:)
//                                                             userInfo:nil
//                                                              repeats:YES];
//        
//        [self performSelector:@selector(dismissHud) withObject:nil afterDelay:0.3];
//    }
}

- (void)dismissHud
{
    [Utilities dismissProcessingHud:self.view];
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

-(void)selectLeftAction:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
//    [_rtspPlayer closeAudio];
//
//    _isReadyPlay = @"1";
//    
//    if (_rtspPlayer) {
//        _rtspPlayer = nil;
//    }
}


//- (IBAction)showTime:(id)sender
//{
//    NSLog(@"current time: %f s", _rtspPlayer.currentTime);
//}
//
//#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)
//
//-(void)displayNextFrame:(NSTimer *)timer
//{
//    BOOL isConnect = [Utilities connectedToNetwork];
//    if (isConnect) {
//        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
//        if (![_rtspPlayer stepFrame]) {
//            [timer invalidate];
//            
//            [_rtspPlayer closeAudio];
//
//            return;
//        }
//        
//        _imageView.image = _rtspPlayer.currentImage;
//        float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
//        if (lastFrameTime<0) {
//            lastFrameTime = frameTime;
//        } else {
//            lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
//        }
//    }else {
//        [self.nextFrameTimer invalidate];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        if (_rtspPlayer) {
//            _rtspPlayer = nil;
//        }
//    }
//}

@end

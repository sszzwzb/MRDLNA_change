//
//  SightPlayerViewController.m
//  VideoRecord
//
//  Created by CheungStephen on 4/7/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "SightPlayerViewController.h"
#import "KKProgressTimer.h"

@interface SightPlayerViewController ()<KKProgressTimerDelegate>
@property (nonatomic, strong) KKProgressTimer *timer1;
@end

@implementation SightPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:@"小视频"];
    self.timer1 = [[KKProgressTimer alloc] init];
    self.timer1.frame = CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 60) / 2, ([UIScreen mainScreen].applicationFrame.size.height - 60) / 2, 60, 60);
    self.timer1.delegate = self;
    self.timer1.tag = 1;
    [self.view addSubview:self.timer1];
    self.view.backgroundColor = [UIColor blackColor];
    
    //    [Utilities showSystemProcessingHud:self.view];
    
    if (_isLocalUrl) {
        // 本地的直接播放
        [self performSelector:@selector(playLocalUrl) withObject:nil afterDelay:0.1];
    }else {
        // 网络的先看本地是否保存，如果有播放，没有则下载
        [self performSelector:@selector(playUrl) withObject:nil afterDelay:0.1];
    }
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause:)];
    [self.view addGestureRecognizer:playTap];
}

- (void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)playOrPause:(NSNotification *)notification
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [ self dismissViewControllerAnimated: YES completion: nil ];
    [_player pause];
    
}

- (void)playingEnd:(NSNotification *)notification
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)playLocalUrl {
    
    [Utilities dismissProcessingHud:self.view];
    
    AVAsset *asset = [AVAsset assetWithURL:_videoURL];
    
    NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
    
    AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
    
    CGSize a = assetTrack.naturalSize;
    //    float naturalSizeRate = a.width/a.height;
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    if (a.width >[UIScreen mainScreen].bounds.size.width) {
        
        //        float rate = 320/a.width;
        
        a.width = [UIScreen mainScreen].bounds.size.width;
        //                a.height = a.height * rate;
    }else {
        a.width = [UIScreen mainScreen].bounds.size.width;
    }
    _playerLayer.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-a.height)/2, a.width, a.height);
    
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)playUrl {
    NSURL *url = _videoURL;
    //    __weak ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    
#if 0
    // Create NSData object
    NSData *nsdata = [_videoURL.absoluteString
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    
    // Let's go the other way...
    
    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:base64Encoded options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    NSLog(@"Decoded: %@", base64Decoded);
#endif
    
    NSString *base64Encoded = [Utilities base64Encode:_videoURL.absoluteString];
    
    NSString *amrDocPath = [Utilities getFilePath:PathType_SightPath];
    
    if (nil != amrDocPath) {
        NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",base64Encoded]];
        
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:imagePathCell]) {
            //                        [MBProgressHUD showSuccess:@"下载文件不存在" toView:nil];
            
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.inputStream   = [NSInputStream inputStreamWithURL:url];
            operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:imagePathCell append:NO];
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                float p = (float)totalBytesRead / totalBytesExpectedToRead;
                [self.timer1 startWithBlock:^CGFloat {
                    return p;
                }];
                
            }];
            //已完成下载
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                [Utilities dismissProcessingHud:self.view];
                
                AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:imagePathCell]];
                
                NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
                [self.timer1 removeFromSuperview];
                
                if (0 != [tmpAry count]) {
                    
                    AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
                    
                    CGSize a = assetTrack.naturalSize;
                    //                    float naturalSizeRate = a.width/a.height;
                    
                    
                    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:imagePathCell] options:nil];
                    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
                    _player = [AVPlayer playerWithPlayerItem:_playerItem];
                    
                    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                    
                    if (a.width >[UIScreen mainScreen].bounds.size.width) {
                        
                        //                        float rate = 320/a.width;
                        
                        a.width = [UIScreen mainScreen].bounds.size.width;
                        //                a.height = a.height * rate;
                    }
                    
                    _playerLayer.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-a.height)/2, a.width, a.height);
                    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                    [self.view.layer addSublayer:_playerLayer];
                    
                    //    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
                    //    [self.view addGestureRecognizer:playTap];
                    
                    //    [self pressPlayButton];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
                    
                    //    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                    //    playImg.center = CGPointMake(videoWidth/2, videoWidth/2);
                    //    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
                    //    [playerLayer addSublayer:playImg.layer];
                    //    playImg.hidden = YES;
                    
                    [_playerItem seekToTime:kCMTimeZero];
                    [_player play];
                    
                    
                    
                    //                NSData *audioData = [NSData dataWithContentsOfFile:imagePathCell];
                    //
                    //                NSString *amrDocPath = [Utilities getFilePath:PathType_SightPath];
                    //                NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:base64Encoded];
                    //
                    //                NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
                }else {
                    [Utilities showFailedHud:@"视频解析失败。" descView:nil];
                }
                
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            
            [operation start];
            
        } else {
            
            [Utilities dismissProcessingHud:self.view];
            
            
            AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:imagePathCell]];
            
            NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
            
            if (0 != [tmpAry count]) {
                AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
                
                CGSize a = assetTrack.naturalSize;
                //                float naturalSizeRate = a.width/a.height;
                
                //                renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
                //                renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
                
                
                
                
                
                AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:imagePathCell] options:nil];
                _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
                _player = [AVPlayer playerWithPlayerItem:_playerItem];
                
                _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                
                
                //            _playerLayer.frame = CGRectMake(0, (568-a.height)/2, a.width, a.height);
                
                
                if (a.width >[UIScreen mainScreen].bounds.size.width) {
                    
                    //                    float rate = 320/a.width;
                    
                    a.width = [UIScreen mainScreen].bounds.size.width;
                    //                a.height = a.height * rate;
                }
                
                _playerLayer.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-a.height)/2, a.width, a.height);
                
                _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.view.layer addSublayer:_playerLayer];
                
                //    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
                //    [self.view addGestureRecognizer:playTap];
                
                //    [self pressPlayButton];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
                
                //    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                //    playImg.center = CGPointMake(videoWidth/2, videoWidth/2);
                //    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
                //    [playerLayer addSublayer:playImg.layer];
                //    playImg.hidden = YES;
                
                [_playerItem seekToTime:kCMTimeZero];
                [_player play];
                
                //            cell.playRecordButton.hidden = NO;
                //            cell.playImageView.hidden = NO;
                //
                //            NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                //            if (nil != amrDocPath) {
                //                NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
                //
                //                NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
                //                //
                //                NSString *dur = [NSString stringWithFormat:@"%ld″", (long)[recordAudio dataDuration:fileData]] ;
                //                if([dur integerValue] > 60){//2015.11.13
                //                    dur = @"60";
                //                }
                //
                //                [cell.playRecordButton setTitle:dur forState:UIControlStateNormal];
                //                [cell.playRecordButton setTitle:dur forState:UIControlStateSelected];
                //            }
                //
                //            isPlayStatus = nil;
                //        }
            }else {
                [Utilities showFailedHud:@"视频解析失败。" descView:nil];
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
}
#pragma mark KKProgressTimerDelegate Method
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    switch (progressTimer.tag) {
        case 1:
            if (percentage >= 1) {
                [progressTimer stop];
            }
            break;
        case 2:
            if (percentage >= .6) {
                [progressTimer stop];
            }
        default:
            break;
    }
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    NSLog(@"%s %f", __PRETTY_FUNCTION__, percentage);
}


- (BOOL)shouldAutorotate
{
    //return [self.topViewController shouldAutorotate];
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //return [self.topViewController supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskPortrait;
}

@end

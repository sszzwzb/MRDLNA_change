//
//  KYVideViewController.m
//  player_Drag
//
//  Created by kaiyi on 2021/8/11.
//

#import "KYVideViewController.h"

#import "ZFPlayer.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerConst.h>
#import "KYPlayerControlView.h"

#import "AppDelegate.h"

#import "SDWebImage.h"

@interface KYVideViewController ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) KYPlayerControlView *controlView;

@end

@implementation KYVideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPlayer];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

-(void)setupPlayer
{
    _containerView = [[UIImageView alloc]initWithFrame:
                      CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*9/16)];
    [_containerView sd_setImageWithURL:[NSURL URLWithString:_videoCover]];
    [self.view addSubview:_containerView];
    
    
    
    
    _controlView = [KYPlayerControlView new];
    _controlView.fastViewAnimated = YES;
    _controlView.autoHiddenTimeInterval = 5;
    _controlView.autoFadeTimeInterval = 0.5;
    _controlView.prepareShowLoading = YES;
    _controlView.prepareShowControlView = NO;
    
    // 上次播放记录最长时间，禁止手动滑动超过这个时间
    _controlView.curLastVideoTime = _curLastVideoTime;
    
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.shouldAutoPlay = YES;
    
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = _controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    self.player.resumePlayRecord = YES;
    
    @zf_weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowOrentitaionRotation = isFullScreen;
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
        if (!self.player.isLastAssetURL) {
            [self.player playTheNext];
            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            [self.controlView showTitle:title coverURLString:self.videoCover fullScreenMode:ZFFullScreenModeLandscape];
        } else {
            // 上次播放记录最长时间，禁止手动滑动超过这个时间
            self.controlView.curLastVideoTime = self.curLastVideoTime;
            
            [self.player playTheIndex:0];
        }
    };
    
    self.player.assetURLs = @[
        [NSURL URLWithString:_videoUrl]
    ];
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"iPhone X" coverURLString:_videoCover fullScreenMode:ZFFullScreenModeAutomatic];
    
    
}




- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

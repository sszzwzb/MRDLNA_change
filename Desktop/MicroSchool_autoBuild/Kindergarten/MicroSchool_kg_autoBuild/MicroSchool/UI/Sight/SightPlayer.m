//
//  SightPlayer.m
//  VideoRecord
//
//  Created by CheungStephen on 4/12/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "SightPlayer.h"

@implementation SightPlayer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.translucent = NO;

}


- (void)showPlayer {
//    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    
    _playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
//    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 164, WIDTH, 280);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self addGestureRecognizer:playTap];
    
    //    [self pressPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    playImg.center = CGPointMake(videoWidth/2, videoWidth/2);
    //    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
    //    [playerLayer addSublayer:playImg.layer];
    //    playImg.hidden = YES;
    
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];

}

- (void)playingEnd:(NSNotification *)notification
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

-(void)playOrPause{
    [_player pause];

    [self removeFromSuperview];
}

@end

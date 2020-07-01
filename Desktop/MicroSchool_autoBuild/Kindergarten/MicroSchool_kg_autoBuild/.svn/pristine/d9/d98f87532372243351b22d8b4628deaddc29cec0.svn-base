//
//  PlayVedioViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PlayVedioViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayVedioViewController ()
@property MPMoviePlayerController *movie;
@end

@implementation PlayVedioViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarHidden = NO;
    //    NSString *string = @"http://121.42.24.74/anime/j36/1.mp4";
    //    NSString *string = @"http://test.5xiaoyuan.cn/yuyin/20150119/14216493329055.amr";
    //    NSString *string = @"http://music.baidu.com/data/music/file?link=http://yinyueshiting.baidu.com/data2/music/3574670/347877893600128.mp3?xcode=17030f618405fe2729ea9b0ea7eafa63ffa62b1ec2e03ef6&song_id=3478778";
    NSString *string = @"http://test.5xiaoyuan.cn/weixiao/rain.mp3";
    
    NSURL *url = [NSURL URLWithString:string];
    CGRect aFrame = [[UIScreen mainScreen] applicationFrame];
    //aFrame = CGRectMake(0.0f, 0.0f, aFrame.size.width, aFrame.size.height);
    aFrame = CGRectMake(20, 100, 220, 38);
    _movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [_movie.view setFrame:aFrame];
    
    
    
    
    
    _movie.controlStyle = MPMovieControlStyleEmbedded;
    _movie.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    //    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    //    [_movie.view setTransform:transform];
    _movie.initialPlaybackTime = -1;
    [self.view addSubview:_movie.view];
    
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_movie];
    [_movie play];
}

-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    //    [self dismissViewControllerAnimated:NO completion:nil];
    //    [UIApplication sharedApplication].statusBarHidden = YES;
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

@end




#if 0
//
//  PlayVedioViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PlayVedioViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayVedioViewController ()
@property MPMoviePlayerController *movie;
@end

@implementation PlayVedioViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarHidden = YES;
    NSString *string = @"http://121.42.24.74/anime/j36/1.mp4";
    NSURL *url = [NSURL URLWithString:string];
    
    CGRect aFrame = [[UIScreen mainScreen] applicationFrame];
    //aFrame = CGRectMake(0.0f, 0.0f, aFrame.size.width, aFrame.size.height);
    aFrame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    _movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [_movie.view setFrame:aFrame];
    _movie.controlStyle = MPMovieControlStyleFullscreen;
    _movie.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    [_movie.view setTransform:transform];
    _movie.initialPlaybackTime = -1;
    [self.view addSubview:_movie.view];
   
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_movie];
    [_movie play];
}

-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIApplication sharedApplication].statusBarHidden = YES;
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

@end
#endif

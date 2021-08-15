//
//  ViewController.m
//  player_Drag
//
//  Created by kaiyi on 2021/8/3.
//

#import "ViewController.h"

#import "KYVideViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *but = ({
        UIButton *but = [UIButton buttonWithType:(UIButtonTypeSystem)];
        but.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100);
        [self.view addSubview:but];
        but.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        
        [but setTitle:@"视频" forState:(UIControlStateNormal)];
        but.tag = 200;
        [but addTarget:self action:@selector(butAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        but;
    });
    
    
}

-(void)butAction
{
    
    KYVideViewController *vc = [[KYVideViewController alloc]init];
    
    vc.videoUrl = @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4";
    vc.videoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
    vc.curLastVideoTime = 25;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end

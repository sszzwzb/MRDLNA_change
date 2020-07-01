//
//  ShowSightViewController.m
//  VideoRecord
//
//  Created by CheungStephen on 4/12/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "ShowSightViewController.h"

@interface ShowSightViewController ()

@end

@implementation ShowSightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ssp = [[SightSilentPlayer alloc] initWithFrame:CGRectMake(50, 100, 220, 160)];
    [_ssp initParm];
    [self.view addSubview:_ssp];

    _ssp.videoURL = _url;
    [_ssp prepareForPlayVideoInSilent:@""];
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSightPlayer)];
    [self.view addGestureRecognizer:playTap];

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

-(void)openSightPlayer{
    SightPlayer* view = [[SightPlayer alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 640)];
    view.backgroundColor = [UIColor blackColor];
    view.videoURL = _url;
    [view showPlayer];
    [self.view addSubview:view];
}

@end

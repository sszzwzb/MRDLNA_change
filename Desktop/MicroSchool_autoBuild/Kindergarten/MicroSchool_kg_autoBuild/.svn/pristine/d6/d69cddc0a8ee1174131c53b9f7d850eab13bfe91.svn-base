//
//  CameraTestViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 24/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "CameraTestViewController.h"

@interface CameraTestViewController ()

@end

@implementation CameraTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:@"title"];

    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(80, 180, 80, 80)];
    [bt setBackgroundColor:[UIColor yellowColor]];
    [bt setTitle:@"push" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(pushactionaa) forControlEvents:UIControlEventTouchUpInside];;
    [self.view addSubview:bt];
    
    UIView *view_top = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.height+20, 64)];
    [view_top setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:view_top];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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

-(void)selectLeftAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)pushactionaa{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}
//
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end

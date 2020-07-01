//
//  SubUINavigationController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SubUINavigationController.h"

@interface SubUINavigationController ()

@end

@implementation SubUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    CGRect frame = self.navigationBar.frame;
//    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
//    _alphaView.backgroundColor = [UIColor blueColor];
//    [self.view insertSubview:_alphaView belowSubview:self.navigationBar];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//    self.navigationBar.layer.masksToBounds = YES;

}

//-(void)setAlph{
//    if (_alphaView.alpha == 0.0 ) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _alphaView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            _alphaView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}
//
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
// 重写UINavigationController 使某些页面禁止横屏
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

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [self.topViewController preferredInterfaceOrientationForPresentation];
//}


@end

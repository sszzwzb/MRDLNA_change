//
//  BaseNavigationController.m
//  MicroSchool
//
//  Created by Kate on 16/7/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL enableRightGesture;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableRightGesture = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count == 1){
        
        self.enableRightGesture = NO;
    }else{
        if ([self.topViewController isKindOfClass:[BaseViewController class]]) {
            if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                
                NSLog(@"count:%lu",(unsigned long)self.viewControllers.count);
                
                BaseViewController *vc = (BaseViewController *)self.topViewController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        }
    }
    
    return self.enableRightGesture;
}



- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

//- (void)deviceOrientationDidChange
//{
//    NSLog(@"NAV deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        [self orientationChange:NO];
//        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//        [self orientationChange:YES];
//    }
//}
//
//- (void)orientationChange:(BOOL)landscapeRight
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    if (landscapeRight) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, width, height);
//        }];
//    } else {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 0, width, height);
//        }];
//    }
//}


@end

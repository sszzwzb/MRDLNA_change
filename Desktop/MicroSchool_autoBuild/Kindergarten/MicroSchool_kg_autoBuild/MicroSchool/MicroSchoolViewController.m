//
//  MicroSchoolViewController.m
//  MicroSchool
//
//  Created by jojo on 13-10-29.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MicroSchoolViewController.h"

@interface MicroSchoolViewController ()

@end

@implementation MicroSchoolViewController

#define degreesToRadian(x) (M_PI * (x) / 180.0)

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    //[ view release] ;

#if 0
    // test
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, WIDTH, 100)];
    label.text = @"HelloWorld";
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
#endif
}

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_DEPRECATED_IOS(2_0,8_0, "Implement viewWillTransitionToSize:withTransitionCoordinator: instead"){
//    NSLog(@"willRotateToInterfaceOrientation");
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    int i = 0;
//    //float number = 0;
//  
//
//    
//    for (UIView *view in window.subviews) {
//        if (i != 0) {
////            number = number+90.0;
//            //CGAffineTransform transform = view.transform;
//            //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
//            //transform = CGAffineTransformRotate(transform,  number  * M_PI/ 180.0);
//            view.transform = CGAffineTransformMakeRotation([self orientationChanged]*M_PI/180.0);;
//            //NSLog(@"number:%f",number);
//            CGPoint center = self.view.window.center;
//            [view setCenter:center];
//           
//        }
//        i++;
//    }
// 
//}
//
//-(float)orientationChanged
//{
//    UIDeviceOrientation orientaiton = [[UIDevice currentDevice] orientation];
//    float n = 0.0;
//    switch (orientaiton) {
//        case UIDeviceOrientationPortrait:
//            n = 0.0;
//            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            n = 90.0*2;
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//            n = 90.0*3;
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            n = 90.0;
//            break;
//        default:
//            break;
//    }
//    NSLog(@"n:%f",n);
//    return n;
//}


@end

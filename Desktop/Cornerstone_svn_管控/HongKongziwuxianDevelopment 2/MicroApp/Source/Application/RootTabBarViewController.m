//
//  RootTabBarViewController.m
//  CarHome
//
//  Created by kaiyi on 2017/12/7.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "RootTabBarViewController.h"

#import "BaseNavigationController.h"
#import "BaseViewController.h"


#import "MessageListViewController.h"
#import "ToolsPageViewController.h"
#import "OutsideReimbursementListViewController.h"


#define kClassKey       @"rootVCClassString"
#define kTitleKey       @"title"
#define kNavTitleKey    @"NavTitle"
#define kImgKey         @"imageName"
#define kSelImgKey      @"selectedImageName"

@interface RootTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *childItemsArray = @[
                                 @{kClassKey    : @"OutsideReimbursementListViewController",
                                   kTitleKey    : @"外采报销",
                                   kNavTitleKey : @"外采报销",
                                   kImgKey      : @"TabOutsideReimbursement_normal",
                                   kSelImgKey   : @"TabOutsideReimbursement_activice"},
                                 
                                 @{kClassKey    : @"OnlyEditViewController",
                                   kTitleKey    : @"起飞凭证",
                                   kNavTitleKey : @"起飞凭证",
                                   kImgKey      : @"TabTakeOff_normal",
                                   kSelImgKey   : @"TabTakeOff_activice"},
                                 
                                 @{kClassKey    : @"OutsideReimbursementListViewController",
                                   kTitleKey    : @"剩余油量",
                                   kNavTitleKey : @"剩余油量",
                                   kImgKey      : @"TabTakeOil_normal",
                                   kSelImgKey   : @"TabTakeOil_activice"},
                                 
                                 ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        BaseViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        vc.navigationItem.title = dict[kNavTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : color_black } forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    
    self.selectedIndex = 1;
    
    
    //  解决iOS12 tab返回错位问题   2018.11.29
    [[UITabBar appearance] setTranslucent:NO];
    
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

/* 设置tabBar是否隐藏 */
+ (void)setTabBarHidden:(BOOL)bHide
{
    
    int normalY = [[UIScreen mainScreen] bounds].size.height - KScreenTabBarHeight;
    int normalLabelY = [[UIScreen mainScreen] bounds].size.height - KScreenTabBarHeight + 35;
    
    if (bHide) {
        normalY = [[UIScreen mainScreen] bounds].size.height;
        normalLabelY = [[UIScreen mainScreen] bounds].size.height + 35;
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    
    [UIView commitAnimations];
}

- (void)hideRealTabBar
{
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
    
}

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}



@end

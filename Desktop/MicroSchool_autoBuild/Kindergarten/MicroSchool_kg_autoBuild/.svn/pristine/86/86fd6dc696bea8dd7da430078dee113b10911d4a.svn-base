//
//  KnowledgeHotWikiBaseViewController.m
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeHotWikiBaseViewController.h"

#import "KnowledgeHotWikiViewController.h"
#import "KnowledgeHotWikiFilterViewController.h"

@interface KnowledgeHotWikiBaseViewController ()

@end

@implementation KnowledgeHotWikiBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KnowledgeHotWikiViewController *hot = [[KnowledgeHotWikiViewController alloc]init];
    KnowledgeHotWikiFilterViewController *hotFilter = [[KnowledgeHotWikiFilterViewController alloc]init];
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:hot];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        UINavigationController * rightSideNavController = [[MMNavigationController alloc] initWithRootViewController:hotFilter];
        [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:hot
                                 leftDrawerViewController:nil
                                 rightDrawerViewController:hotFilter];
//        self.drawerController = [[MMDrawerController alloc]
//                                 initWithCenterViewController:hot
//                                 leftDrawerViewController:nil
//                                 rightDrawerViewController:hotFilter];

                    [self.drawerController setShowsShadow:NO];
    }
    else{
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:hot
                                 leftDrawerViewController:nil
                                 rightDrawerViewController:hotFilter];
    }
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:220.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.view addSubview:self.drawerController.view];

//    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//
////    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
//    
//    [appDelegate.window setRootViewController:self.drawerController];
//    [appDelegate.window makeKeyAndVisible];
    
    
//    [self.view addSubview:self.drawerController.view];
//    [self addChildViewController:self.drawerController];
//    _parentViewController = self.drawerController;
    
    
    //        MMDrawerController * drawerController = [[MMDrawerController alloc]
    //                                                 initWithCenterViewController:hot
    //                                                 leftDrawerViewController:nil
    //                                                 rightDrawerViewController:hotFilter];
    
//    [self.navigationController pushViewController:self.drawerController animated:YES];
    
    
    //        [self.drawerController
    //         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
    //             MMDrawerControllerDrawerVisualStateBlock block;
    //             block = [[MMExampleDrawerVisualStateManager sharedManager]
    //                      drawerVisualStateBlockForDrawerSide:drawerSide];
    //             if(block){
    //                 block(drawerController, drawerSide, percentVisible);
    //             }
    //         }];
    //        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //        if(OSVersionIsAtLeastiOS7()){
    //            UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
    //                                                  green:173.0/255.0
    //                                                   blue:234.0/255.0
    //                                                  alpha:1.0];
    //            [self.window setTintColor:tintColor];
    //        }
    //        [self.view setRootViewController:self.drawerController];

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

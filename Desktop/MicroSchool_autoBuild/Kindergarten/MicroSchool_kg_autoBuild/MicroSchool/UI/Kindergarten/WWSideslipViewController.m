
//
//  WWSideslipViewController.m
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "WWSideslipViewController.h"

@interface WWSideslipViewController (){
    NSString *str;
}

@end

@implementation WWSideslipViewController
@synthesize speedf,sideslipTapGes;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi5" object:nil];
    // Do any additional setup after loading the view.
}
//#4.1 现在所有的显示左页面&主页面操作都通过通知在WWS进行处理，显示主页面后scalef重置为0，解决了滑动异常问题。
- (void)tongzhi:(NSNotification *)select{
    NSLog(@"%@",select.userInfo[@"num"]);
    NSLog(@"－－－－－接收到通知------");
    if ([select.userInfo[@"num"]isEqualToString:@"1"]) {
          [self showLeftView];
    }else if([select.userInfo[@"num"]isEqualToString:@"2"]){
        [self showMainView];
         scalef = 0;
    }
   

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
                        andBackgroundImage:(UIImage *)image;
{
    if(self){
        speedf = 0.5;
        
        leftControl = LeftView;
        mainControl = MainView;
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imgview setImage:image];
        [self.view addSubview:imgview];
        
        //滑动手势
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        _pan.delegate = self;
        [mainControl.view addGestureRecognizer:_pan];
        
//        _pan.enabled=NO;
        //单击手势
//        sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
//        [sideslipTapGes setNumberOfTapsRequired:1];
        
//        [mainControl.view addGestureRecognizer:sideslipTapGes];
        
        leftControl.view.hidden = NO;
        [self.view addSubview:leftControl.view];
        [self.view addSubview:mainControl.view];
        
    }
    return self;
}
#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    scalef = (point.x*speedf+scalef);
    //根据视图位置判断是左滑还是右边滑动
    if (rec.view.frame.origin.x>=0){
        rec.view.center = CGPointMake(rec.view.center.x + point.x*speedf,rec.view.center.y);
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        leftControl.view.hidden = NO;
    }
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (scalef>140*speedf){
            [self showLeftView];
        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [pan translationInView:self.view];
    
    if (point.y > 0) {//scrollview的下拉刷新与右滑手势冲突
        return NO;
    }else{
        return YES;
    }

}

#pragma mark - 单击手势
//-(void)handeTap:(UITapGestureRecognizer *)tap{
//    
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        [UIView beginAnimations:nil context:nil];
//        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
//        [UIView commitAnimations];
//        scalef = 0;
//
//    }
//
//}

#pragma mark - 修改视图位置
//恢复位置
-(void)showMainView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
//#4.1 此处通知是为了解决滑动一次后，需要点击两次左上角头像才会产生效果的问题。在4个可以侧滑的页面重置myTapGesture7的值。
    str =@"1";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
    //创建通知
    NSNotification *select =[NSNotification notificationWithName:@"select" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:select];
    
    NSDictionary *dicta =[[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"status", nil];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"schoolHomeAddNoTouchView" object:nil userInfo:dicta]];

}

//显示左视图
-(void)showLeftView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    mainControl.view.center = CGPointMake(380,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
//#4.1 此处通知是为了解决滑动一次后，需要点击两次左上角头像才会产生效果的问题。在4个可以侧滑的页面重置myTapGesture7的值。
    str =@"2";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
    //创建通知
    NSNotification *select =[NSNotification notificationWithName:@"select" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:select];

    NSDictionary *dicta =[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"status", nil];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"schoolHomeAddNoTouchView" object:nil userInfo:dicta]];



}
//备注：删除右划显示代码。

//#warning 为了界面美观，所以隐藏了状态栏。如果需要显示则去掉此代码
- (BOOL)prefersStatusBarHidden
{
    return NO; //返回NO表示要显示，返回YES将hiden
}

-(UIViewController *)getMainControl {
    return mainControl;

}

@end

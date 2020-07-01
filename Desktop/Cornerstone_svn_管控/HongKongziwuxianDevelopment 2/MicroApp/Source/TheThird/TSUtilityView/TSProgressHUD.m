//
//  TSProgressHUD.m
//  MicroSchool
//
//  Created by jojo on 15/4/16.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TSProgressHUD.h"

#import "AddImageUtilities.h"

@implementation TSProgressHUD

+ (instancetype)sharedClient
{
    static TSProgressHUD *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (void)doShowProcessingHud:(UIView *)descV
//{
//    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
//    
//#if 9
//    MBProgressHUD *hudExist = [MBProgressHUD HUDForView:descV];
//    if (hudExist == nil) {
//        // 先判断一下当前view上是否已经有hud了，如果有就不进行描画。
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:descV];
//        hud.removeFromSuperViewOnHide = YES;
//        
//        hud.yOffset = -[Utilities transformationHeight:30];
//        hud.opacity = 1;
//        hud.square = YES;
//        hud.activityIndicatorColor = [UIColor darkGrayColor];
//        hud.color = [UIColor clearColor];
//        //    hud.labelText = @"加载中..";
//        
//        [descV addSubview:hud];
//        [hud show:YES];
//    }
//#else
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
//
////    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:descV];
//
//    hud.offset = CGPointMake(0, -[Utilities transformationHeight:8]);
//    hud.bezelView.color = [UIColor clearColor];
////    hud.bezelView.backgroundColor = [UIColor redColor];
//    
//    
////    hud.bezelView.alpha = 0;
////    hud.color = [UIColor clearColor];
////    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
//    hud.bezelView.opaque = YES;
//
////    hud.backgroundColor = [UIColor clearColor];
//
////    [hud showAnimated:YES];
//    
//
//#endif
//    
//    
//    
////    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest.gif"];
////    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
////    gifview.image=image;
////    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
////    
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
////    hud.removeFromSuperViewOnHide = YES;
////    hud.yOffset = -30;
////    hud.opacity = 1;
////    hud.square = YES;
////    hud.activityIndicatorColor = [UIColor darkGrayColor];
////    hud.color = [UIColor clearColor];
////    hud.mode = MBProgressHUDModeCustomView;
////    hud.labelText = @"加载中...";
////    hud.customView=gifview;
////    hud.graceTime = 0.5;
////    [descV addSubview:hud];
////    [hud show:YES];
//
//    
//    
//    
////    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest.gif"];
////    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
////    gifview.image=image;
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
////    hud.color=[UIColor grayColor];//默认颜色太深了
////    hud.mode = MBProgressHUDModeCustomView;
////    hud.labelText = @"加载中...";
////    hud.customView=gifview;
////
////    [hud show:YES];
//    
//    
//    
////    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest"];
////    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
////    gifview.image=image;
////    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
////    
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:NO];
////    hud.removeFromSuperViewOnHide = YES;
////    hud.yOffset = -30;
////    hud.opacity = 1;
////    hud.square = YES;
////    hud.activityIndicatorColor = [UIColor darkGrayColor];
////    hud.color = [UIColor clearColor];
////    hud.mode = MBProgressHUDModeCustomView;
////    hud.labelText = @"加载中...";
////    hud.customView=gifview;
////    hud.graceTime = 0;
////    [descV addSubview:hud];
////    [hud show:NO];
//
//}
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    UIImage  *image;
    if (iPhone6p) {
        image =[UIImage sd_animatedGIFNamed:@"loadingTestFor6P"];
    }else{
        image =[UIImage sd_animatedGIFNamed:@"loadingTest"];
    }
    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    gifview.image=image;
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:NO];
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -30;
    hud.opacity = 1;
    hud.square = YES;
//    hud.activityIndicatorColor = [UIColor darkGrayColor];
    hud.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView=gifview;
    hud.graceTime = 0;
    
    hud.tag = 9988;
    [descV addSubview:hud];
    [hud show:YES];
}

- (void)doShowSystemProcessingHud:(UIView *)descV {
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
#if 9
    MBProgressHUD *hudExist = [MBProgressHUD HUDForView:descV];
    if (hudExist == nil) {
        // 先判断一下当前view上是否已经有hud了，如果有就不进行描画。
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:descV];
        hud.removeFromSuperViewOnHide = YES;
        
        hud.yOffset = -[AddImageUtilities transformationHeight:30];
        hud.opacity = 1;
        hud.square = YES;
//        hud.activityIndicatorColor = [UIColor darkGrayColor];
        hud.color = [UIColor clearColor];
        //    hud.labelText = @"加载中..";
        
        [descV addSubview:hud];
        [hud show:YES];
    }
#else
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
    
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:descV];
    
    hud.offset = CGPointMake(0, -[Utilities transformationHeight:8]);
    hud.bezelView.color = [UIColor clearColor];
    //    hud.bezelView.backgroundColor = [UIColor redColor];
    
    
    //    hud.bezelView.alpha = 0;
    //    hud.color = [UIColor clearColor];
    //    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    hud.bezelView.opaque = YES;
    
    //    hud.backgroundColor = [UIColor clearColor];
    
    //    [hud showAnimated:YES];
    
    
#endif
    
    
    
    //    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest.gif"];
    //    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    //    gifview.image=image;
    //    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    //
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.yOffset = -30;
    //    hud.opacity = 1;
    //    hud.square = YES;
    //    hud.activityIndicatorColor = [UIColor darkGrayColor];
    //    hud.color = [UIColor clearColor];
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = @"加载中...";
    //    hud.customView=gifview;
    //    hud.graceTime = 0.5;
    //    [descV addSubview:hud];
    //    [hud show:YES];
    
    
    
    
    //    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest.gif"];
    //    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    //    gifview.image=image;
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
    //    hud.color=[UIColor grayColor];//默认颜色太深了
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = @"加载中...";
    //    hud.customView=gifview;
    //
    //    [hud show:YES];
    
    
    
    //    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loadingTest"];
    //    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    //    gifview.image=image;
    //    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    //
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:NO];
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.yOffset = -30;
    //    hud.opacity = 1;
    //    hud.square = YES;
    //    hud.activityIndicatorColor = [UIColor darkGrayColor];
    //    hud.color = [UIColor clearColor];
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = @"加载中...";
    //    hud.customView=gifview;
    //    hud.graceTime = 0;
    //    [descV addSubview:hud];
    //    [hud show:NO];
    
}


- (void)doShowFirstLoadProcessingHud:(UIView *)descV {
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;

    UIImage  *image;
    if (iPhone6p) {
    image =[UIImage sd_animatedGIFNamed:@"loadingTestFor6P"];    
    }else{
    image =[UIImage sd_animatedGIFNamed:@"loadingTest"];
    }
    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    gifview.image=image;
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:NO];
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -30;
    hud.opacity = 1;
    hud.square = YES;
//    hud.activityIndicatorColor = [UIColor darkGrayColor];
    hud.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView=gifview;
    hud.graceTime = 0;
    
    hud.tag = 9988;
    [descV addSubview:hud];
    [hud show:YES];
}

- (void)doDismissProcessingHud:(UIView *)descV
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hud = [MBProgressHUD HUDForView:descV];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        if (9988 == hud.tag) {
            [hud hide:NO];
        }else {
            [hud hide:YES];
        }
    }
}

- (void)doShowSuccessedHud:(NSString *)text descView:(UIView *)descV;
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;

#if 9
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:HUD];
    
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    HUD.customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 50) ];
    
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 30, 30)];
    [imgView setImage:image];
    
    [HUD.customView addSubview:imgView];
    
    
    if (nil == text) {
        text = @"请求成功";
    }
    HUD.labelText = text;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = -[AddImageUtilities transformationHeight:8];
    HUD.opacity = 0;
    HUD.cornerRadius = 3;

    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
#else
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:descV animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    // 背景颜色
    [hud.bezelView setColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
    
    // label属性
    hud.label.font = [UIFont systemFontOfSize:14];
    [hud.label setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    hud.label.text = NSLocalizedString(text, @"HUD done title");

    hud.minSize = CGSizeMake([Utilities transformationWidth:150], [Utilities transformationHeight:110]);
    hud.offset = CGPointMake(0, -[Utilities transformationHeight:8]);
    
    [hud hideAnimated:YES afterDelay:1.f];
#endif
}

- (void)doShowFailedHud:(NSString *)text descView:(UIView *)descV
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    if ([text isKindOfClass:[NSDictionary class]] ||
        [text isKindOfClass:[NSArray class]] ||
        (nil == text)) {
        // 做一下容错处理
        text = @"请求失败，请稍后再试。";
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:HUD];
    
    HUD.labelText = text;
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.yOffset = -[AddImageUtilities transformationHeight:30];
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (void)doShowTextHud:(NSString *)text descView:(UIView *)descV {
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    if ([text isKindOfClass:[NSDictionary class]] ||
        [text isKindOfClass:[NSArray class]] ||
        (nil == text)) {
        // 做一下容错处理
        text = @"请求失败，请稍后再试。";
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:HUD];

    HUD.labelText = text;
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.yOffset = -[AddImageUtilities transformationHeight:30];
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (void)doShowMultiLineTextHud:(NSString *)title content:(NSString *)text descView:(UIView *)descV  {
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    if ([text isKindOfClass:[NSDictionary class]] ||
        [text isKindOfClass:[NSArray class]] ||
        (nil == text)) {
        // 做一下容错处理
        text = @"请求失败，请稍后再试。";
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:HUD];
    
    HUD.labelText = title;
    
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = text;
    
    HUD.yOffset = -[AddImageUtilities transformationHeight:30];
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}


//- (void)doShowTSNetworkingErr:(TSNetworkingErrType)errType descView:(UIView *)descV
//{
//    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
//
//    // 提示网络错误前，先消除之前的加载中。
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:descV];
//    if (hud != nil) {
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES];
//    }
//
//    NSString *errStr;
//    
//    if (ReqErrorTimeOut == errType) {
//        errStr = @"网络请求超时，请稍后再试。";
//    }else if (ReqErrorNotConnectedToInternet == errType){
//        errStr = @"没有网络连接，请稍后再试。";
//    }else if (ReqErrorCannotDecodeContentData == errType){
//        errStr = @"无法解析服务器数据，请稍后再试。";
//    }else if (ReqErrorBadServerResponse == errType){
//        errStr = @"网络请求参数错误，请稍后再试。";
//    }else {
//        errStr = @"无法获取数据，请稍后再试";
//    }
//
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
//    [descV addSubview:HUD];
//    
//    HUD.labelText = errStr;
//    
//    HUD.mode = MBProgressHUDModeCustomView;
//    
//    HUD.yOffset = -[Utilities transformationHeight:30];
//    HUD.opacity = 0;
//    HUD.cornerRadius = 3;
//    
//    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
//    
//    HUD.labelFont = [UIFont systemFontOfSize:14];
//    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:1];
//    
////    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
////    [descV addSubview:HUD];
////    
////    HUD.labelText = errStr;
////    HUD.labelFont = [UIFont systemFontOfSize:15.0f];
////    
////    HUD.mode = MBProgressHUDModeText;
////    HUD.yOffset = -30;
////    HUD.opacity = 0.75f;
////    
////    HUD.removeFromSuperViewOnHide = YES;
////    // YES代表需要蒙版效果
////    //HUD.dimBackground = YES;
////    
////    [HUD show:YES];
////    [HUD hide:YES afterDelay:0.8];
//}

#if 0
- (TSProgressHUD *)init;
{
    return self;
}

- (void)doShowProcessingHud:(UIView *)descV
{
    _processingHud = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:_processingHud];
    
    _processingHud.yOffset = -30;
    _processingHud.opacity = 0.7;
    _processingHud.square = YES;
    
    _processingHud.labelText = @"加载中..";
    
    [_processingHud show:YES];
}

- (void)doRemoveProcessingHud:(UIView *)descV
{
    [_processingHud hide:YES];
}
#endif

@end

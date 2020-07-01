	//
//  Utilities.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-22.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "Utilities.h"
#import "PublicConstant.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "MicroSchoolAppDelegate.h"
#import "MicroSchoolMainMenuViewController.h"
#import "ClassDetailViewController.h"
#import "MyClassListViewController.h"
#import "MomentsEntranceTableViewController.h"
#import "MomentsEntranceForTeacherController.h"
#import "SchoolListForBureauViewController.h"
#import "MyInfoCenterViewController.h"

@implementation Utilities

#define FILE_NAME_HEAD_IMAGE                                @"HeadImage.jpg"


+(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    return keyWord;
}


+(BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

// 幼儿园模块View通用方法
+(UIView*)createmodule:(NSString*)imgName title:(NSString*)moduleTitle count:(NSUInteger)count tag:(NSInteger)tag{
    
    float width = [UIScreen mainScreen].bounds.size.width/count;
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, width, 40+21.0)];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((width-40)/2.0, 0, 40, 40)];
    imgV.tag = tag;
    [imgV sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    imgV.userInteractionEnabled = YES;
    
    //    imgV.image = [UIImage imageNamed:imgName];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 40+5, width, 21.0)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = moduleTitle;
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    label.userInteractionEnabled = YES;
    
    [view addSubview:imgV];
    [view addSubview:label];
    
    return view;
}

// 更新本地存储的红点字典 用于首次加入班级
+(void)updateLocalData:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    // 如果模块增加 更新本地原有数据 增加新模块的数据 如果模块减少 不做处理 因为页面上看不见不影响红点
    NSArray *classArray = [dic objectForKey:@"classes"];
    NSArray *spacesArray = [dic objectForKey:@"spaces"];
   
    NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
    NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
    
    if ([classArray count] > [classLastDicDefault count]) {
        
        for (int i = 0 ; i<[classArray count]; i++) {
            
            //if (i > [classLastDicDefault count] -1 || [classLastDicDefault count] == 0) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
            
            if ([classLastDicDefault objectForKey:keyStr]) {
                
            }else{
                [classLastDicDefault setObject:last forKey:keyStr];
            }
            
            //}
            
        }
        
        [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
        [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
        [userDefaults synchronize];
        
    }
    
    if ([spacesArray count] > [spaceLastDicDefault count]) {
        
        for (int i = 0 ; i<[spacesArray count]; i++) {
            
            //if (i > [spaceLastDicDefault count] -1 || [spaceLastDicDefault count] == 0) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
                NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
            
            if ([spaceLastDicDefault objectForKey:keyStr]) {
                
            }else{
               [spaceLastDicDefault setObject:last forKey:keyStr];
            }
            
                
            //}
            
        }
        
        [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
        [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
        [userDefaults synchronize];
        
    }
    
}

// 点击推送栏更新红点通用方法
+(void)updateRedPoint:(NSInteger)type last:(NSString*)last cid:(NSString*)cid mid:(NSString*)mid{
    
    switch (type) {
        case 0://school
            [self updateSchoolRedPoints:last mid:mid];
            break;
        case 1://class
            [self updateClassRedPoints:cid last:last mid:mid];
            break;
            
        case 2://space
            [self updateSpaceRedPoints:cid last:last mid:mid];
            break;
            
        default: 
            break;
    }
    
}

// 更新主页模块最后一条id 2016.2.19
+(void)updateSchoolRedPoints:(NSString*)last mid:(NSString*)mid{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    NSMutableDictionary *schoolLastDicDefault = [[NSMutableDictionary alloc]initWithDictionary:[defaultsDic objectForKey:@"schoolLastDicDefault"]];
    
    if (schoolLastDicDefault) {
        
        NSString *cid = @"0";
        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
        NSString *lastDefault = [schoolLastDicDefault objectForKey:keyStr];
        if ([last integerValue] > [lastDefault integerValue]) {
            [schoolLastDicDefault setObject:last forKey:keyStr];
            [defaultsDic setObject:schoolLastDicDefault forKey:@"schoolLastDicDefault"];
            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
            [userDefaults synchronize];
        }
        
    }
}


/// 更新班级模块最后一条id 2015.11.13
+(void)updateClassRedPoints:(NSString*)cid last:(NSString*)last mid:(NSString*)mid{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc]initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
    
    if (classLastDicDefault) {
        
        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
        NSString *lastDefault = [classLastDicDefault objectForKey:keyStr];
        if ([last integerValue] > [lastDefault integerValue]) {
            [classLastDicDefault setObject:last forKey:keyStr];
            [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];
            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
            [userDefaults synchronize];
        }
        
    }
  
}

/// 更新成长空间模块最后一条id 2015.12.17
+(void)updateSpaceRedPoints:(NSString*)cid last:(NSString*)last mid:(NSString*)mid{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc]initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
    
    if (spaceLastDicDefault) {
        
        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
        NSString *lastDefault = [spaceLastDicDefault objectForKey:keyStr];
        if ([last integerValue] > [lastDefault integerValue]) {
            [spaceLastDicDefault setObject:last forKey:keyStr];
            [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];
            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
            [userDefaults synchronize];
        }
    }
    
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9]|4[7])$";
    NSString * MOBILE = @"^1(3|5|8|4|7)\\d$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
        //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        //        || ([regextestct evaluateWithObject:mobileNum] == YES)
        //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


// 通过手机状态条获取当前网络
// 此方法用于非国产iPhone用AFNetworking监测手机网络监测不出的补丁
// add by kate 2015.08.06
+(int)getNetWorkStates{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    //NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
//            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    //无网模式
//                    break;
//                case 1:
//                    state = @"2G";
//                    break;
//                case 2:
//                    state = @"3G";
//                    break;
//                case 3:
//                    state = @"4G";
//                    break;
//                case 5:
//                {
//                    state = @"WIFI";
//                }
//                    break;
//                default:
//                    break;
//            }
        }
    }
    //根据状态选择
    return netType;
}

//----add by  kate 2015.06.30----------------------------------
+(BOOL)isConnected{
    
    BOOL flag = YES;
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        flag = NO;
        
    }
    
    return flag;
    
}
//----------------------------------------------------------------

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(NSInteger)findStringPositionInArray:(NSArray *)arr andImg:(UIImage *)img
{
    NSInteger pos = -1;
    
    for (int i=0; i<[arr count]; i++) {
        
        UIImage *arrImg = [arr objectAtIndex:i];
        
        if ([Utilities image:arrImg equalsTo:img]) {
            pos = i;
            break;
        }
        
    }
    return pos;
}


+ (void)takePhotoFromViewController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>*)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authorizationStatus == AVAuthorizationStatusRestricted
                || authorizationStatus == AVAuthorizationStatusDenied) {
                
                // 没有权限
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[NSString stringWithFormat:@"请打开相机开关(设置 > 隐私 > 相机 > %@)",appName]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                return;
            }
        }
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        pickerController.delegate = controller;
        
        [controller presentViewController:pickerController animated:YES completion:nil];
    }
    else {
        // throw exception
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The Device not support Camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(NSString*)linuxDateToString:(NSString*)date andFormat:(NSString*)format andType:(DateFormatType)type
{
    // 将linux时间戳转化为ios识别的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date.integerValue];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:confromTimesp];
    
    NSInteger second = [components second];
    NSString *second_str;
    if (second < 10)
    {
        second_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)second]];
    }
    else
    {
        second_str = [NSString stringWithFormat: @"%ld", (long)second];
    }
    
    NSInteger minute = [components minute];
    NSString *minute_str;
    if (minute < 10)
    {
        minute_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)minute]];
    }
    else
    {
        minute_str = [NSString stringWithFormat: @"%ld", (long)minute];
    }
    
    NSInteger hour = [components hour];
    NSString *hour_str;
    if (hour < 10)
    {
        hour_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)hour]];
    }
    else
    {
        hour_str = [NSString stringWithFormat: @"%ld", (long)hour];
    }
    
    NSInteger day = [components day];
    NSString *day_str;
    if (day < 10)
    {
        day_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)day]];
    }
    else
    {
        day_str = [NSString stringWithFormat: @"%ld", (long)day];
    }
    
    NSInteger month= [components month];
    NSString *month_str;
    if (month < 10)
    {
        month_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)month]];
    }
    else
    {
        month_str = [NSString stringWithFormat: @"%ld", (long)month];
    }

    NSInteger year= [components year];
    NSString *year_str;
    year_str = [NSString stringWithFormat: @"%ld", (long)year];
    
    if (DateFormat_YMDHM == type) {
        return [NSString stringWithFormat:format, year_str, month_str, day_str, hour_str, minute_str];
    }
    else if (DateFormat_MDHM == type){
        return [NSString stringWithFormat:format, month_str, day_str, hour_str, minute_str];
    }
    else if (DateFormat_YMD == type){
        return [NSString stringWithFormat:format, year_str, month_str, day_str];
    }
    else if (DateFormat_MD == type){
        return [NSString stringWithFormat:format, month_str, day_str];
    }
    else if (DateFormat_MS == type){
        return [NSString stringWithFormat:format, hour_str, minute_str];
    }
    else if (DateFormat_HM == type){
        return [NSString stringWithFormat:format, hour_str, minute_str];
    }

    return 0;
}

// 将nsdate的时间转化为可以显示的format格式
-(NSString*)nsDateToString:(NSDate*)date andFormat:(NSString*)format andType:(DateFormatType)type
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    
    NSInteger second = [components second];
    NSString *second_str;
    if (second < 10)
    {
        second_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)second]];
    }
    else
    {
        second_str = [NSString stringWithFormat: @"%ld", (long)second];
    }
    
    NSInteger minute = [components minute];
    NSString *minute_str;
    if (minute < 10)
    {
        minute_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)minute]];
    }
    else
    {
        minute_str = [NSString stringWithFormat: @"%ld", (long)minute];
    }
    
    NSInteger hour = [components hour];
    NSString *hour_str;
    if (hour < 10)
    {
        hour_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)hour]];
    }
    else
    {
        hour_str = [NSString stringWithFormat: @"%ld", (long)hour];
    }
    
    NSInteger day = [components day];
    NSString *day_str;
    if (day < 10)
    {
        day_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)day]];
    }
    else
    {
        day_str = [NSString stringWithFormat: @"%ld", (long)day];
    }
    
    NSInteger month= [components month];
    NSString *month_str;
    if (month < 10)
    {
        month_str = [@"0" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)month]];
    }
    else
    {
        month_str = [NSString stringWithFormat: @"%ld", (long)month];
    }
    
    NSInteger year= [components year];
    NSString *year_str;
    year_str = [NSString stringWithFormat: @"%ld", (long)year];
    
    if (DateFormat_YMDHM == type) {
        return [NSString stringWithFormat:format, year_str, month_str, day_str, hour_str, minute_str];
    }
    else if (DateFormat_MDHM == type){
        return [NSString stringWithFormat:format, month_str, day_str, hour_str, minute_str];
    }
    else if (DateFormat_YMD == type){
        return [NSString stringWithFormat:format, year_str, month_str, day_str];
    }
    else if (DateFormat_MS == type){
        return [NSString stringWithFormat:format, minute_str, second_str];
    }
    
    return 0;
}

-(NSString*) getAvatarFromUid:(NSString*) uid andType:(NSString*) type
{
    NSString* url = AC_HEAR_URL;
    
    if ([type  isEqual: @"0"])
    {
        url = [url stringByAppendingString:@"size=small&type=&uid="];
    }
    else if ([type  isEqual: @"1"])
    {
        url = [url stringByAppendingString:@"size=middle&type=&uid="];
    }
    else
    {
        url = [url stringByAppendingString:@"size=big&type=&uid="];
    }
    
    if(Nil != uid)
    {
        url = [url stringByAppendingString:uid];
    }
    
    return url;
}

#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd")

//字符串转日期
-(NSDate * )NSStringToNSDate: (NSString * )string
{
    if ([@"0-0-0"  isEqual: string]) {
        time_t now;
        time(&now);
        
        return [NSDate dateWithTimeIntervalSince1970:now];;
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date = [formatter dateFromString :string];
    return date;
}

-(NSString*) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]) {
        platform = @"iPhone 5";
    } else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod touch 4";
    } else if ([platform isEqualToString:@"iPad3,2"]) {
        platform = @"iPad 3 3G";
    } else if ([platform isEqualToString:@"iPad3,1"]) {
        platform = @"iPad 3 WiFi";
    } else if ([platform isEqualToString:@"iPad2,2"]) {
        platform = @"iPad 2 3G";
    } else if ([platform isEqualToString:@"iPad2,1"]) {
        platform = @"iPad 2 WiFi";
    }
    
    //MACHINE_VERSION = platform;
    return platform;
}

+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


/// <summary>
/// 取得系统路径位置
/// </summary>
+ (NSString *)SystemDir
{
    NSString *documentsDirectory;
    
#if TARGET_IPHONE_SIMULATOR
    // 模拟器环境 DB保存路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [path objectAtIndex:0];
#else
    // 真机环境 DB保存路径
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
#endif
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}

/// <summary>
/// 取得登陆用户位置
/// </summary>
+ (NSString *)getMyInfoDir
{
 
    //NSString *cid = nil;
    
    // 获取当前用户的cid
    GlobalSingletonUserInfo* g_userInfo = [GlobalSingletonUserInfo sharedGlobalSingleton];
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *uid = [userDetailInfo objectForKey:@"uid"];
    
    if (!uid) {
        uid = [Utilities getUniqueUidWithoutQuit];
    }
    
    NSString *userDir = [[Utilities SystemDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", uid]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userDir]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userDir;
}

/// <summary>
/// 取得其他用户位置
/// </summary>
+ (NSString *)getUserInfoDir:(long long)uid
{
    NSString *userDir = [[Utilities getMyInfoDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lli", uid]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userDir]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userDir;
}

/// <summary>
/// 取得用户头像位置
/// </summary>
+ (NSString *)getHeadImagePath:(long long)cid
{
    NSString *headImagePath = nil;
    
    // 存放图片的文件夹
    NSString *imageDir = [Utilities getUserInfoDir:cid];
    
    // 图片路径
    headImagePath = [imageDir stringByAppendingPathComponent:FILE_NAME_HEAD_IMAGE];
    
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    // 创建文件夹路径
    //    if (![fileManager fileExistsAtPath:headImagePath]) {
    //        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    //    }
    return headImagePath;
}

// 获取文件路径
+(NSString *)getFilePath:(PathType)type;
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    
    if (PathType_AmrPath == type) {
        //指定新建文件夹路径
        NSString *amrDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoAmrFile"];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:amrDocPath]) {
            //创建ImageFile文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:amrDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return amrDocPath;
    }
    else if (PathType_PicturePath == type){
        //指定新建文件夹路径
        NSString *picDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoPicFile"];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:picDocPath]) {
            //创建ImageFile文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:picDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return picDocPath;
    }
    else if (PathType_SightPath == type){
        //指定新建文件夹路径
        NSString *picDocPath = [documentPath stringByAppendingPathComponent:@"zhixiaoSightFile"];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:picDocPath]) {
            //创建ImageFile文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:picDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return picDocPath;
    }

    
    return nil;
}

/*
 * 去掉服务器返回结果文本中的<null>
 */
+ (NSString *)replaceNull:(NSString *)source
{
    NSString *result = [NSString stringWithFormat:@"%@", source];
    if (result != nil && (NSNull *)result != [NSNull null]) {
        if ([result isEqualToString:@"<null>"]) {
            return @"";
        } else if ([result isEqualToString:@"(null)"]) {
            return @"";
        } else {
            return result;
        }
    } else {
        return @"";
    }
}

/// <summary>
/// 取得本地时间
/// returns: 格式：yyyy-MM-dd hh:mm:ss
/// </summary>
+ (NSString *)GetCurLocalTime
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //alloc后对不使用的对象别忘了release
    //[dateFormatter release];
    
    return currentDateStr;
}

/// <summary>
/// 取得用户头像位置
/// </summary>
+ (NSString *)getHeadImagePath:(long long)user_id imageName:(NSString *)imageName
{
    // 存放图片的文件夹
    NSString *imageDir = [Utilities getUserInfoDir:user_id];
    
    // 图片路径
    //return [imageDir stringByAppendingPathComponent:FILE_NAME_HEAD_IMAGE];
    if ([imageName length] > 0) {
        return [imageDir stringByAppendingPathComponent:imageName];
    } else {
        return @"";
    }
}

+ (CGSize)getContentSize:(NSString *)inputText withFont:(UIFont *)font
{
	if (inputText == nil) {
		return CGSizeZero;
	}
    
    NSString *str = [NSString stringWithString:inputText];
    CGFloat aHeight = [self heightForText:str withFont:font withWidth:200];
    CGFloat aWidth = [self widthForText:str withinWidth:200 withFont:font];
    
    return CGSizeMake(aWidth, aHeight);
}

+ (CGFloat)heightForText:(NSString *)aText withFont:(UIFont *)font withWidth:(CGFloat)width
{
	//计算正常最大宽度时候，需要的高度
    CGFloat aHeight = 0;
	CGSize strSize  = [aText sizeWithFont:font constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    aHeight = strSize.height;
	
    //一行最小高度是28
    if (aHeight < 28) {
        aHeight = 28;
    }
    
	return aHeight;
}

+ (CGFloat)widthForText:(NSString*)aText withinWidth:(CGFloat)aWidth withFont:(UIFont*)font
{
	CGFloat iWidth = 0;
	for (NSString *text in [aText componentsSeparatedByString:@"\n"]){
		CGFloat iCurWidth = 0.0f;
		CGSize strSize  = [text sizeWithFont:font
                           constrainedToSize:CGSizeMake(aWidth, [[UIScreen mainScreen] bounds].size.width)
                               lineBreakMode:NSLineBreakByWordWrapping];
		if (strSize.width + iCurWidth > aWidth) {
			if (iCurWidth > iWidth)
				iWidth = iCurWidth;
			iCurWidth = strSize.width;
		} else {
			iCurWidth += strSize.width;
		}
		
		if (iCurWidth > iWidth)
			iWidth = iCurWidth;
	}
	
	if (iWidth > aWidth)
		iWidth = aWidth;
	
	return iWidth;
}

/*
 * 转换秒数为日期
 * timeType 1:yyyy-MM-dd HH:mm   2:yyyy-MM-dd EEEE   3:MM-dd HH:mm   4:MM-dd   5:HH:mm   6:EEEE(代表完整的星期几)
 *          7:yyyy-MM-dd HH:mm:ss   8:yyyy年MM月dd日 HH:mm
 * compareWithToday 和今天比较，是今天则只返回 HH:mm，不是今天:如果是今年则返回 MM-dd，如果不是今年则返回 yyyy-MM-dd 9:今天/昨天
 */
+ (NSString *)timeIntervalToDate:(long long)timeInterval timeType:(NSInteger)type compareWithToday:(BOOL)bCompare
{
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *beforeDate = [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateNow = [cal components:unitFlags fromDate:now];
    NSDateComponents *dateMsg = [cal components:unitFlags fromDate:msgDate];
    NSDateComponents *dateBefore = [cal components:unitFlags fromDate:beforeDate];
    
    if (bCompare) {
        if ([dateBefore year] == [dateMsg year] && [dateBefore month] == [dateMsg month] && [dateBefore day] == [dateMsg day]) {
            if (type == 1 || type == 3) {
                [dateFormat setDateFormat:@"HH:mm"];
                return [NSString stringWithFormat:@"昨天 %@",[dateFormat stringFromDate:msgDate]];
            } else {
                return @"昨天";
            }
        }
        
        if ([dateNow year] == [dateMsg year]) {
            if ([dateNow month] == [dateMsg month] && [dateNow day] == [dateMsg day]) {
                
                if (type == 9) {
                    
                    return @"今天";
                }else{
                    [dateFormat setDateFormat:@"HH:mm"];
                    return [dateFormat stringFromDate:msgDate];
                }
              
            } else {
                if (type == 1) {
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    return [dateFormat stringFromDate:msgDate];
                } else if (type == 3) {
                    [dateFormat setDateFormat:@"MM-dd HH:mm"];
                    return [dateFormat stringFromDate:msgDate];
                } else {
                    [dateFormat setDateFormat:@"MM-dd"];
                    return [dateFormat stringFromDate:msgDate];
                }
            }
        } else {
            if (type == 1) {
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                return [dateFormat stringFromDate:msgDate];
            } else if (type == 3) {
                [dateFormat setDateFormat:@"MM-dd HH:mm"];
                return [dateFormat stringFromDate:msgDate];
            } else {
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                return [dateFormat stringFromDate:msgDate];
            }
        }
    } else {
        switch (type) {
            case 1:
                if ([dateBefore year] == [dateMsg year] && [dateBefore month] == [dateMsg month] && [dateBefore day] == [dateMsg day]) {
                    [dateFormat setDateFormat:@"HH:mm"];
                    return [NSString stringWithFormat:@"昨天 %@",[dateFormat stringFromDate:msgDate]];
                } else {
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    return [dateFormat stringFromDate:msgDate];
                }
                
                break;
                
            case 2:
                if ([dateBefore year] == [dateMsg year] && [dateBefore month] == [dateMsg month] && [dateBefore day] == [dateMsg day]) {
                    [dateFormat setDateFormat:@"EEEE"];
                    return [NSString stringWithFormat:@"昨天 %@",[dateFormat stringFromDate:msgDate]];
                } else {
                    [dateFormat setDateFormat:@"yyyy-MM-dd EEEE"];
                    return [dateFormat stringFromDate:msgDate];
                }
                
                break;
                
            case 3:
                if ([dateBefore year] == [dateMsg year] && [dateBefore month] == [dateMsg month] && [dateBefore day] == [dateMsg day]) {
                    [dateFormat setDateFormat:@"HH:mm"];
                    return [NSString stringWithFormat:@"昨天 %@",[dateFormat stringFromDate:msgDate]];
                } else {
                    [dateFormat setDateFormat:@"MM-dd HH:mm"];
                    return [dateFormat stringFromDate:msgDate];
                }
                
                break;
                
            case 4:
                if ([dateBefore year] == [dateMsg year] && [dateBefore month] == [dateMsg month] && [dateBefore day] == [dateMsg day]) {
                    return @"昨天";
                } else {
                    [dateFormat setDateFormat:@"MM-dd"];
                    return [dateFormat stringFromDate:msgDate];
                }
                
                break;
                
            case 5:
                [dateFormat setDateFormat:@"HH:mm"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
                
            case 6:
                [dateFormat setDateFormat:@"EEEE"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
                
            case 7:
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
                
            case 8:
                [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
                
            case 9:
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
            case 10:
                [dateFormat setDateFormat:@"yyyy年MM月dd日"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
                
                case 11:
                
                [dateFormat setDateFormat:@"MM-dd"];
                return [dateFormat stringFromDate:msgDate];
                
            default:
                [dateFormat setDateFormat:@"HH:mm"];
                return [dateFormat stringFromDate:msgDate];
                
                break;
        }
    }
}

/// <summary>
/// 取得聊天信息中缩略图目录位置
/// </summary>
+ (NSString *)getChatPicThumbDir:(long long)user_id
{
    // 取得路径名
    NSString *imageDir = [[self getUserInfoDir:user_id] stringByAppendingPathComponent:DIR_NAME_CHAT];
    // 此路径保存缩略图
    NSString *thumbImageDir = [imageDir stringByAppendingPathComponent:DIR_NAME_THUMB_IMAGE];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:thumbImageDir]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:thumbImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return thumbImageDir;
}

/// <summary>
/// 取得聊天信息中原始大图目录位置
/// </summary>
+ (NSString *)getChatPicOriginalDir:(long long)user_id
{
    // 取得路径名
    NSString *imageDir = [[self getUserInfoDir:user_id] stringByAppendingPathComponent:DIR_NAME_CHAT];
    // 此路径保存缩略图
    NSString *originalImageDir = [imageDir stringByAppendingPathComponent:DIR_NAME_ORIGINAL_IMAGE];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:originalImageDir]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:originalImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return originalImageDir;
}

/// <summary>
/// 取得聊天信息中原始语音目录位置
/// </summary>
+ (NSString *)getChatAudioDir:(long long)user_id
{
    // 取得路径名
    NSString *imageDir = [[self getUserInfoDir:user_id] stringByAppendingPathComponent:DIR_NAME_CHAT];
    // 此路径保存缩略图
    NSString *originalImageDir = [imageDir stringByAppendingPathComponent:DIR_NAME_AUDIO_IMAGE];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:originalImageDir]) {
        // 创建文件夹路径
        [fileManager createDirectoryAtPath:originalImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return originalImageDir;
}

/*
 * 联网判断
 */
+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

/// <summary>
/// 得到消息ID
/// 客户端生成，(同一个流ptt的多个分片的msgid一样，表示同一条消息)
/// 客户端生成MsgId的规则:MsgId(8bytes)=发送方User尾数(4bytes)+秒级时间戳尾数(3bytes)+循环递增(0-255)(1bytes)
/// </summary>
+ (long long)GetMsgId
{
    static int msgIdCount = -1;
    long long msgId = 0;
    
    //发送方UserID尾数(4bytes)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    long long myUserID = [[userDefaults stringForKey:@"MyUserID"] longLongValue];
    long long uuid = 4294967295 & myUserID;
    msgId = uuid << 32;
    
    //秒级时间戳尾数(3bytes)
    long long dateTimeNow = [[NSDate date] timeIntervalSince1970];
    dateTimeNow = 16777215 & dateTimeNow;
    msgId = msgId | (dateTimeNow << 8);
    
    //循环递增(0-255)(1bytes)
    msgIdCount = (msgIdCount == 255) ? 0 : ++msgIdCount;
    msgId = msgId | msgIdCount;
    
    return msgId;
}

+(long long)getOthersMsgId:(NSString*)userId{
    
    static int msgIdCount = -1;
    long long msgId = 0;
    
    //发送方UserID尾数(4bytes)
    long long myUserID = [userId longLongValue];
    long long uuid = 4294967295 & myUserID;
    msgId = uuid << 32;
    
    //秒级时间戳尾数(3bytes)
    long long dateTimeNow = [[NSDate date] timeIntervalSince1970];
    dateTimeNow = 16777215 & dateTimeNow;
    msgId = msgId | (dateTimeNow << 8);
    
    //循环递增(0-255)(1bytes)
    msgIdCount = (msgIdCount == 255) ? 0 : ++msgIdCount;
    msgId = msgId | msgIdCount;
    
    return msgId;

}

//-----------------------------------------
//* action: 弹出提示框
//* add date: 2014.01.21
//* update date:
//* author: kate
//------------------------------------------
+ (void)showAlert:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cTitle otherButtonTitle:(NSString *)oTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cTitle otherButtonTitles:oTitle, nil];
        [alert show];
    });
}

// update by kate 2015.06.18
+(NSMutableArray *) getChineseStringArr:(NSMutableArray *)arrToSort andResultKeys:(NSMutableArray *)arrayHeadsKeys flag:(NSInteger)flag{
    
    // flag:1 显示职务后缀 flag:0 不显示职务后缀
    
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        if (flag == 1) {
            
            NSString *duty = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[arrToSort objectAtIndex:i] objectForKey:@"title"]]];//职务
            NSString *name = [NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"name"]];
            
            // 防止name为空，设置为" "
            if ([@"" isEqual: [NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"name"]]]) {
                chineseString.string = @" ";
            }else {
                
                if ([duty length] > 0) {
                     chineseString.string= [NSString stringWithFormat:@"%@|%@",name,duty];
                }else{
                     chineseString.string= name;
                }
               
            }
            
        }else{
            
            // 防止name为空，设置为" "
            if ([@"" isEqual: [NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"name"]]]) {
                chineseString.string = @" ";
            } else {
                chineseString.string=[NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"name"]];
            }
        }
        
        chineseString.uid=[NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"uid"]];
        if ([[arrToSort objectAtIndex:i] objectForKey:@"title"]) {
            chineseString.title= [NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"title"]];
        }
        if ([[arrToSort objectAtIndex:i] objectForKey:@"friend"]) {
            chineseString.isFriend=[NSString stringWithString:[NSString stringWithFormat:@"%@", [[arrToSort objectAtIndex:i] objectForKey:@"friend"]]];
        }
        
        if ([[arrToSort objectAtIndex:i] objectForKey:@"avatar"]) {
            
            chineseString.avatar=[NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"avatar"]];
            
        }
        // 防止authority为空，设置为" "
//        if (nil == [NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"authority"]]) {
//            chineseString.authority = @"";
//        } else {
//            chineseString.authority=[NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"authority"]];
//        }

        if ([[arrToSort objectAtIndex:i] objectForKey:@"authority"]) {
            chineseString.authority=[NSString stringWithString:[[arrToSort objectAtIndex:i] objectForKey:@"authority"]];
        }else{
            chineseString.authority = @"";
            
        }
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];

                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
//        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![arrayHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [arrayHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([arrayHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

+(UIImage *)imageByScalingToSize:(CGSize)targetSize andImg:(UIImage *)sourceImg
{
    UIImage *sourceImage = sourceImg;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

+(BOOL)isIncludeChineseInString:(NSString *)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    [color set];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();
    
    return image;
}

// 获取当前的ViewController
+(UIViewController *)getCurrentRootViewController {
    
    
    UIViewController *result;
    
    
    // Try to find the root view controller programmically
    
    
    // Find the top window (that is not an alert view or other window)
    
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
        
        
    {
        
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        
        for(topWindow in windows)
            
            
        {
            
            
            if (topWindow.windowLevel == UIWindowLevelNormal)
                
                
                break;
            
            
        }
        
        
    }
    
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    
    id nextResponder = [rootView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        
        result = nextResponder;
    
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        
        
        result = topWindow.rootViewController;
    
    
    else
        
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    
    return result;    
    
    
}

+(void)doLogoutAndClean
{
    // 清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:G_NSUserDefaults_UserLoginInfo];
    [defaults removeObjectForKey:G_NSUserDefaults_UserUniqueUid];
    [defaults removeObjectForKey:@"lastId_cnews"];
    [defaults removeObjectForKey:@"lastId_news"];
    [defaults removeObjectForKey:@"lastHomeIdDic"];
    [defaults removeObjectForKey:@"lastDisIdDic"];
    [defaults removeObjectForKey:@"lastId_chat"];
    [defaults setObject:@"1" forKey:@"MessageSwitch"];
    [defaults removeObjectForKey:@"lastId_Education"];
    [defaults removeObjectForKey:@"lastId_CookMenu"];
    [defaults removeObjectForKey:@"lastId_OrientalSound"];
    [defaults removeObjectForKey:@"lastId_StudentHandbook"];
    [defaults setBool:NO forKey:@"DB_DONE"];
    [defaults synchronize];
    
    // 清除发布作业保存之前的标题
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"homeworkTitle"]];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 清空标记名字的变量，不自动登录
    NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:nil, @"name", nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // add by ht 20140915 如果注册完毕并且登录成功后，清空用户信息，以便下一次直接进入主界面，增加userDefaults变量
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 清除登录时候的个人信息
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userSettingDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"zhixiao_autoLogin_"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSString *dbFileStr = [[Utilities getMyInfoDir] stringByAppendingPathComponent:@"WeixiaoChat.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:dbFileStr error:nil]){
        NSLog(@"1");
    }else{
        NSLog(@"0");
    }
    
    [[DBDao getDaoInstance] releaseDB];
}

+(void)doSaveUserInfoToDefaultAndSingle:(NSDictionary *)infoDic andRole:(NSDictionary *)roleDic
{
    // 容错处理
    NSString *classes = [roleDic objectForKey:@"classes"];
    if (nil == classes) {
        classes = @"";
    }
    
    NSString *cid = [NSString stringWithFormat:@"%@",[roleDic objectForKey:@"cid"]];
    if (nil == cid) {
        cid = @"";
    }

    NSString *classname = [roleDic objectForKey:@"classname"];
    if (nil == classname) {
        classname = @"";
    }
    
    NSString *birthyear = [self replaceNull:[infoDic objectForKey:@"birthyear"]];
    if ([@""  isEqual: birthyear]) {
        birthyear = @"1995";
    }
    
    NSString *birthmonth = [self replaceNull:[infoDic objectForKey:@"birthmonth"]];
    if ([@""  isEqual: birthmonth]) {
        birthmonth = @"01";
    }
    
    NSString *birthday = [self replaceNull:[infoDic objectForKey:@"birthday"]];
    if ([@""  isEqual: birthday]) {
        birthday = @"01";
    }

    NSMutableDictionary *user_info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [self replaceNull:[infoDic objectForKey:@"uid"]], @"uid",
                                      [self replaceNull:[infoDic objectForKey:@"username"]], @"username",
                                      [self replaceNull:[infoDic objectForKey:@"name"]], @"name",
                                      [self replaceNull:[infoDic objectForKey:@"sex"]], @"sex",
                                      [self replaceNull:[infoDic objectForKey:@"email"]], @"email",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"mobile"]], @"mobile",
                                      [self replaceNull:[infoDic objectForKey:@"qq"]], @"qq",
                                      [self replaceNull:[infoDic objectForKey:@"msn"]], @"msn",
                                      birthyear, @"birthyear",
                                      birthmonth, @"birthmonth",
                                      
                                      birthday, @"birthday",
                                      [self replaceNull:[infoDic objectForKey:@"blood"]], @"blood",
                                      [self replaceNull:[infoDic objectForKey:@"birthprovince"]], @"birthprovince",
                                      [self replaceNull:[infoDic objectForKey:@"birthcity"]], @"birthcity",
                                      [self replaceNull:[infoDic objectForKey:@"residecity"]], @"residecity",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"resideprovince"]], @"resideprovince",
                                      [self replaceNull:[infoDic objectForKey:@"spacenote"]], @"spacenote",
                                      [self replaceNull:[infoDic objectForKey:@"studentid"]], @"studentid",
                                      [self replaceNull:[infoDic objectForKey:@"avatar"]], @"avatar",
                                      // 容错处理，待定
                                      @"", @"cid",

                                      [NSString stringWithFormat:@"%@",[roleDic objectForKey:@"id"]], @"role_id",
                                      [Utilities replaceNull:[NSString stringWithFormat:@"%@",[roleDic objectForKey:@"name"]]], @"role_name",
                                      [roleDic objectForKey:@"flag"], @"role_flag",
                                      [Utilities replaceNull:[NSString stringWithFormat:@"%@",[roleDic objectForKey:@"checked"]]], @"role_checked",
                                      [Utilities replaceNull:[roleDic objectForKey:@"reason"]], @"role_reason",
                                      classes, @"role_classes",
                                      cid, @"role_cid",
                                      classname, @"role_classname",
                                      [self replaceNull:[infoDic objectForKey:@"authority"]], @"authority",
                                      [self replaceNull:[infoDic objectForKey:@"school_job"]],@"duty",
                                      [self replaceNull:[infoDic objectForKey:@"school_course"]],@"subject",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"student_name"]],@"student_name",
                                      [self replaceNull:[infoDic objectForKey:@"student_number"]],@"student_number",
                                      [self replaceNull:[infoDic objectForKey:@"student_number_id"]],@"student_number_id",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"vip_opened"]],@"vip_opened",
                                      [self replaceNull:[infoDic objectForKey:@"vip_schoolEnabled"]],@"vip_schoolEnabled",

                                      nil];
    
    // 去NSUserDefaults里面存储一个字典数据，
    // 保存当前用户的所有详细信息，
    // 1.首次登录成功并获取个人信息时候更新
    // 2.登录后再次进入程序，获取个人信息时更新
    
    NSLog(@"user_info:%@",user_info);
    
    [[NSUserDefaults standardUserDefaults] setObject:user_info forKey:@"weixiao_userDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 把当前用户详细信息保存到单例当中，程序中所有取用户基本信息的地方获取此单例内容即可
    GlobalSingletonUserInfo *g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    [g_userInfo setUserDetailInfo:user_info];

}

//-----------------------------------------
//* action: 保存图片至沙盒
//* add date: 2014.09.22
//* update date:
//* author: kate
//------------------------------------------
+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.3);
    
    // 获取沙盒目录
    NSString *fullPath = [[Utilities SystemDir] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

+(void)doSaveDynamicModule:(NSMutableArray *)arr
{
    // 保存动态列表内容，以便下次进入首页时直接显示
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"weixiao_userDynamicModule"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)doSaveSettingUserInfoToDefaultAndSingle:(NSDictionary *)infoDic andRole:(NSDictionary *)roleDic
{
    // 容错处理
    NSString *classes = [roleDic objectForKey:@"classes"];
    if (nil == classes) {
        classes = @"";
    }
    
    NSString *cid = [roleDic objectForKey:@"cid"];
    if (nil == cid) {
        cid = @"";
    }
    
    NSString *classname = [roleDic objectForKey:@"classname"];
    if (nil == classname) {
        classname = @"";
    }
    
    NSString *birthyear = [self replaceNull:[infoDic objectForKey:@"birthyear"]];
    if ([@""  isEqual: birthyear]) {
        birthyear = @"1995";
    }

    NSString *birthmonth = [self replaceNull:[infoDic objectForKey:@"birthmonth"]];
    if ([@""  isEqual: birthmonth]) {
        birthmonth = @"01";
    }

    NSString *birthday = [self replaceNull:[infoDic objectForKey:@"birthday"]];
    if ([@""  isEqual: birthday]) {
        birthday = @"01";
    }

    NSMutableDictionary *user_info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [self replaceNull:[infoDic objectForKey:@"uid"]], @"uid",
                                      [self replaceNull:[infoDic objectForKey:@"username"]], @"username",
                                      [self replaceNull:[infoDic objectForKey:@"name"]], @"name",
                                      [self replaceNull:[infoDic objectForKey:@"sex"]], @"sex",
                                      [self replaceNull:[infoDic objectForKey:@"email"]], @"email",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"mobile"]], @"mobile",
                                      [self replaceNull:[infoDic objectForKey:@"qq"]], @"qq",
                                      [self replaceNull:[infoDic objectForKey:@"msn"]], @"msn",
                                      birthyear, @"birthyear",
                                      birthmonth, @"birthmonth",
                                      
                                      birthday, @"birthday",
                                      [self replaceNull:[infoDic objectForKey:@"blood"]], @"blood",
                                      [self replaceNull:[infoDic objectForKey:@"birthprovince"]], @"birthprovince",
                                      [self replaceNull:[infoDic objectForKey:@"birthcity"]], @"birthcity",
                                      [self replaceNull:[infoDic objectForKey:@"residecity"]], @"residecity",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"resideprovince"]], @"resideprovince",
                                      [self replaceNull:[infoDic objectForKey:@"spacenote"]], @"spacenote",
                                      [self replaceNull:[infoDic objectForKey:@"studentid"]], @"studentid",
                                      [self replaceNull:[infoDic objectForKey:@"avatar"]], @"avatar",
                                      // 容错处理，待定
                                      @"", @"cid",
                                      
                                      [roleDic objectForKey:@"id"], @"role_id",
                                      [roleDic objectForKey:@"name"], @"role_name",
                                      [roleDic objectForKey:@"flag"], @"role_flag",
                                      [roleDic objectForKey:@"checked"], @"role_checked",
                                      [Utilities replaceNull:[roleDic objectForKey:@"reason"]], @"role_reason",
                                      classes, @"role_classes",
                                      cid, @"role_cid",
                                      classname, @"role_classname",
                                      [self replaceNull:[infoDic objectForKey:@"authority"]], @"authority",
                                      
                                      [self replaceNull:[infoDic objectForKey:@"vip_opened"]],@"vip_opened",
                                      [self replaceNull:[infoDic objectForKey:@"vip_schoolEnabled"]],@"vip_schoolEnabled",

                                      nil];
    
    // 去NSUserDefaults里面存储一个字典数据，
    // 保存当前用户的所有详细信息，
    // 1.首次登录成功并获取个人信息时候更新
    // 2.登录后再次进入程序，获取个人信息时更新
    [[NSUserDefaults standardUserDefaults] setObject:user_info forKey:@"weixiao_userSettingDetailInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)image:(UIImage *)aImage1 equalsTo:(UIImage *)aImage2
{
    NSData *img1Data = UIImageJPEGRepresentation(aImage1, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation(aImage2, 1.0);
    return [img1Data isEqualToData:img2Data];
}

//获得设备型号
+(NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
    //    //手机别名： 用户定义的名称
    //    NSString* userPhoneName = [[UIDevice currentDevice] name];
    //    NSLog(@"手机别名: %@", userPhoneName);
    //    //设备名称
    //    NSString* deviceName = [[UIDevice currentDevice] systemName];
    //    NSLog(@"设备名称: %@",deviceName );
    //    //手机系统版本
    //    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"手机系统版本: %@", phoneVersion);
    //    //手机型号
    //    NSString* phoneModel = [[UIDevice currentDevice] model];
    //    NSLog(@"手机型号: %@",phoneModel );
    //    //地方型号  （国际化区域名称）
    //    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    //    NSLog(@"国际化区域名称: %@",localPhoneModel );
    //
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    // 当前应用名称
    //    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    //    NSLog(@"当前应用名称：%@",appCurName);
    //    // 当前应用软件版本  比如：1.0.1
    //    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"当前应用软件版本:%@",appCurVersion);
    //    // 当前应用版本号码   int类型
    //    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    //    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    //
    //
    //    NSString *device = [Utilities getCurrentDeviceModel:self.viewController];
    //    NSLog(@"device：%@",device);
    
}

+(NSString *)getDataReportStr:(NSString *)actionName;
{
    NSString *reportStr;
    
    // protocol_version
    NSString *protocol_version = @"10";
    
    // uid
    NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
    NSString* uid= [uI objectForKey:@"uid"];

    // app_id
    NSString *app_id = @"4";

    // app_code
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];

    // app_version
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    // 设备种类 eg:iPhone
    NSString *mobile_brand = [[UIDevice currentDevice] model];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [self getCurrentDeviceModel];
    
    // 软件型号 eg:iOS
    NSString *os_name = @"iOS";

    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];

    // 设备唯一标识
    NSString *deviceUUID = [self getDeviceUUID];
    
    // 格式
    // protocol_version|action|sid|uid|app_id|app_code|app_version|mobile_brand|mobile_model|os_name|os_version|IMEI

    reportStr = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",
                 protocol_version,
                 actionName,
                 G_SCHOOL_ID,
                 uid,
                 app_id,
                 app_code,
                 app_version,
                 mobile_brand,
                 mobile_model,
                 os_name,
                 os_version,
                 deviceUUID
                 ];
    
    return reportStr;
}

// 获得app Version
+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    return app_code;
}

+(NSString *)getDeviceUUID
{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.etaishuo.weixiao"account:@"zhixiao"];
    
    if (retrieveuuid.length == 0) {
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", myUUIDStr]
                     forService:@"com.etaishuo.weixiao"account:@"zhixiao"];
    }
    return retrieveuuid;
}

+(CGSize)getStringHeight:(NSString *)str andFont:(UIFont *)font andSize:(CGSize)size
{
    // 由于获取类似@"\n"开头的字符串时候，返回高度不正确，这里容错一下，在\n前面加一个空格
    // 就可以正常返回高度了。
    NSString *a = str;

    if (0 != [str length]) {
        NSString *b = [a substringToIndex:1];
        
        if ([@"\n"  isEqual: b]) {
            a = [NSString stringWithFormat:@"%@%@",@" ",a];
            NSLog(@"a = %@",a);
        }
    }
    
    CGSize strSize;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        NSDictionary *attributeMessage = @{NSFontAttributeName:font};
        NSLog(@"a = %@",a);

        strSize = [a boundingRectWithSize:size options:
                                       NSStringDrawingTruncatesLastVisibleLine |
                                       NSStringDrawingUsesLineFragmentOrigin |
                                       NSStringDrawingUsesFontLeading
                                                              attributes:attributeMessage context:nil].size;
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
            // 不知道为什么，8.0之后返回的值和7.0的值差了19，这里加个判断。
            // 原因有空调查一下。cao...
            strSize.height = strSize.height + 19;
        }
    } else {
        UIFont *nameFont=font;
        strSize=[a sizeWithFont:nameFont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return strSize;
}

+ (CGSize)getLabelHeight:(UILabel *)label size:(CGSize)s {
    return [label sizeThatFits:s];
}


//-----------------------------------------
//* action: 获取设备类型
//* add date: 2014.11.21
//* update date:
//* author: kate
//------------------------------------------
+ (NSString *)deviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform;
    if(machine == NULL){
        platform = @"i386";
    }else {
        platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    }
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C GSM";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C CDMA";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S GSM";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S CDMA";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod touch 5G";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 GSM";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 WiFi+rev_a";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad mini WiFi";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad mini GSM";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad mini CDMA";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 WiFi";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 GSM";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 CDMA";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"i386"])		 return @"iPhone simulator";
    
    return platform;
}

+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2{
    
    //_backgroundImgV 124 174
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 124, 174)];
    imgV.image = [UIImage imageNamed:@"icon_jxw.png"];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    //label2.backgroundColor = [UIColor grayColor];
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
    
}


+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect imgName:(NSString*)name textColor:(UIColor*)color startY:(float)start
{
    
    //_backgroundImgV 124 174
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 120.0)/2.0, start, 120.0, 120.0)];
    imgV.image = [UIImage imageNamed:name];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:15.0];
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:15.0];
    //label2.backgroundColor = [UIColor grayColor];
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
    
}

+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect imgName:(NSString*)name
{
    
    //_backgroundImgV 124 174
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 120.0)/2.0, 100.0, 120.0, 120.0)];
    imgV.image = [UIImage imageNamed:name];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor grayColor];
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    label2.textColor = [UIColor grayColor];
    //label2.backgroundColor = [UIColor grayColor];
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
    
}

//空白页显示
+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name startY:(float)start
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.tag = 2222;
    view.backgroundColor = [UIColor clearColor];
    
    if (start == 0) {
        start = (rect.size.height - 110.0)/3.0;
    }
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 110.0)/2.0, start, 110.0, 110.0)];
    if (name) {
        imgV.image = [UIImage imageNamed:name];
    }else{
        imgV.image = [UIImage imageNamed:@"icon_noData.png"];
    }
        
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+5, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    label2.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    label2.font = [UIFont systemFontOfSize:15.0];
    
    [view addSubview:label];
    [view addSubview:label2];
    
    UIView *nodataV = [desV viewWithTag:2222];
    if (!nodataV) {
        [desV addSubview:view];
    }
}

//空白页消失
+(void)dismissNodataView:(UIView*)desV{
    
    UIView *nodataV = [desV viewWithTag:2222];
    
    if (nodataV) {
        [nodataV removeFromSuperview];
    }
}

+(UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect
{
    
    //_backgroundImgV 124 174
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 124, 174)];
    imgV.image = [UIImage imageNamed:@"icon_jxw.png"];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    //label2.backgroundColor = [UIColor grayColor];
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
    
}

// add by kate 2015.06.29
+(UIView*)showNoNetworkView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect
{
    
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 115.0)/2.0, 100.0, 115.0, 115.0)];
    imgV.image = [UIImage imageNamed:@"CommonIconsAndPics/noNetworkFace.png"];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor colorWithRed:241.0/255.0 green:64.0/255.0 blue:48.0/255.0 alpha:1];
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    label.textColor = [UIColor colorWithRed:241.0/255.0 green:64.0/255.0 blue:48.0/255.0 alpha:1];
    //label2.backgroundColor = [UIColor grayColor];
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
    
}

+(NSString*)newUrl{
    // uid
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    if (nil == uid) {
        uid = @"";
    }
    
    // app_code
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [Utilities getCurrentDeviceModel];
    // 去掉型号里面的空格
    mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];

    NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
    if (nil == token) {
        token = @"";
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
    key = [Utilities md5:key];
    
    NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
    
    NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@",REQ_URL, api, love, key];

//    NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@_%@_%@_%@_%@_%@_%@_%@",REQ_URL,G_SCHOOL_ID,uid,@"4", app_code, mobile_model, os_version, love, key];
    
    return newUrl;
}

// 添加后台需要的参数
+ (NSString*)appendUrlParams:(NSString *)reqUrl
{
    // 写到请求url里面的uid，默认为""
    NSString *uid = @"";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    if (nil != userInfo) {
        // 单例里面有值的话，用单例里的值。
        uid = [userInfo objectForKey:@"uid"];
        if (nil == uid) {
            // 单例里值为空的话，把uid置""
            uid = @"";
        }
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 运行版本号
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [Utilities getCurrentDeviceModel];
    // 去掉型号里面的空格
    mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    
    NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
    if (nil == token) {
        token = @"";
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
    key = [Utilities md5:key];
    
    NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
    
    NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@",reqUrl, api, love, key];
    
    return newUrl;
}

+ (NSString*)appendUrlParamsV2:(NSString *)reqUrl {
    // 写到请求url里面的uid，默认为""
    NSString *uid = @"";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    if (nil != userInfo) {
        // 单例里面有值的话，用单例里的值。
        uid = [userInfo objectForKey:@"uid"];
        if (nil == uid) {
            // 单例里值为空的话，把uid置""
            uid = @"";
        }
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 运行版本号
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [Utilities getCurrentDeviceModel];
    // 去掉型号里面的空格
    mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    
    NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
    if (nil == token) {
        token = @"";
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
    key = [Utilities md5:key];
    
    NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version, [Utilities getAppVersion]];
    
    NSString *newUrl = [NSString stringWithFormat:@"%@&__api=%@&love=%@&key=%@",reqUrl, api, love, key];
    
    return newUrl;
    
}

+(int)getType:(NSString *)privilegee{
    
    int privilege = [privilegee intValue];
    int type = 32;
    if ((privilege & 32) == 32) {
        type = 32;
    }else if ((privilege & 16) == 16){
        type = 16;
    }else if ((privilege & 1) == 1){
        type = 1;
    }
    
    return type;
}

+(NSInteger)findStringPositionInArray:(NSArray *)arr andStr:(NSString *)str
{
    NSInteger pos = -1;
    for (int i=0; i<[arr count]; i++) {
        NSString *arrStr = [arr objectAtIndex:i];
        if ([arrStr isEqual:str]) {
            pos = i;
            break;
        }
    }
    return pos;
}

+(void)doHandleTSNetworkingErr:(TSNetworkingErrType )errType descView:(UIView *)descView
{
    [[[TSProgressHUD sharedClient] init] doShowTSNetworkingErr:errType descView:descView];

//    if (NSURLErrorTimedOut == errType) {
//        // req timeout
//        
//    }else if (NSURLErrorNotConnectedToInternet == errType){
//        // network issue, could not connect server.
//    }else if (ReqErrorCannotDecodeContentData == errType){
        // the data from server can not be analyze,
        // eg: server sql error.
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
        
#if 0
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
        
        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tontacts_jz.png"]];
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.yOffset = -40;
        HUD.opacity = 0.7;
        
//        HUD.delegate = self;
        HUD.labelText = @"Completed";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.33];
#endif  
        
        
        
//        [self addSuccessedHud:YES descView:view];

#if 9
//        UIView *showView = [[UIView alloc] initWithFrame:<#(CGRect)#>]
        
        
#if 0
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CommonIconsAndPics/failure_"]];
        CGSize a = imageView.frame.size;
        
        UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, a.width + a.width*0.3, a.height + a.height*0.3)];
        imageView.frame = CGRectMake((a.width*0.3)/2, 0, a.width, a.height);
        
        
        
        
        UILabel *_label_noLike = [[UILabel alloc] initWithFrame:CGRectMake((a.width*0.3)/2-a.width*0.2, a.height + a.height*0.1, a.width+a.width*0.1, a.height+a.height*0.1)];
        //设置title自适应对齐
        _label_noLike.font = [UIFont systemFontOfSize:14.0f];
        _label_noLike.lineBreakMode = NSLineBreakByWordWrapping;
        _label_noLike.numberOfLines = 0;
        _label_noLike.textAlignment = NSTextAlignmentCenter;
        _label_noLike.backgroundColor = [UIColor clearColor];
        _label_noLike.textColor = [UIColor blackColor];
        _label_noLike.text = @"无法解析服务器数据，请稍后再试。";
//        _label_noLike.hidden = YES;
        
        
        [showView addSubview:_label_noLike];

        
        
        [showView addSubview:imageView];
        
#endif
        
        
        
        
#if 0
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
        
//        HUD.customView = showView;
        HUD.labelText = @"无法解析服务器数据，请稍后再试。";
        HUD.labelFont = [UIFont systemFontOfSize:15.0f];
        
        HUD.mode = MBProgressHUDModeText;
        HUD.yOffset = -40;
        HUD.opacity = 0.7;
        //    HUD.square = YES;
        
        // 隐藏时候从父控件中移除
        HUD.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        //    HUD.dimBackground = YES;
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:5];
#endif
#endif
}

+ (void)showSuccessedHud:(NSString *)text descView:(UIView *)desV
{
    [[[TSProgressHUD sharedClient] init] doShowSuccessedHud:text descView:desV];
}

+ (void)showFailedHud:(NSString *)text descView:(UIView *)desV
{
    [[[TSProgressHUD sharedClient] init] doShowFailedHud:text descView:desV];
}

+ (void)showTextHud:(NSString *)text descView:(UIView *)descV
{
    [[[TSProgressHUD sharedClient] init] doShowTextHud:text descView:descV];
}

+ (void)addCustomizedHud:(UIImageView *)imgView
               showText:(NSString *)showStr
              hideDelay:(NSInteger)delay
               descView:(UIView *)desV
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:desV];
    [desV addSubview:HUD];
    
    HUD.customView = imgView;
    HUD.labelText = showStr;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = -40;
    HUD.opacity = 0.7;
//    HUD.square = YES;
    
    // 隐藏时候从父控件中移除
    HUD.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    HUD.dimBackground = YES;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}

/** 获取View所在的控制器对象 */
+(UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV
{
    
    [[[TSProgressHUD sharedClient] init] doShowProcessingHud:descV];
}

+ (void)showSystemProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowSystemProcessingHud:descV];
}

+ (void)showFirstLoadProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowFirstLoadProcessingHud:descV];
}


// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV
{
    [[[TSProgressHUD sharedClient] init] doDismissProcessingHud:descV];
}

// 底部弹出的对话框。
+ (void)showPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view {
    [[[TSPopupView sharedClient] init] doShowPopupView:title items:items view:(UIView *)view];
}

+ (void)showPopupView:(NSString *)title items:(NSArray *)items {
    [[[TSPopupView sharedClient] init] doShowPopupView:title items:items];
}

// 获取程序内部唯一uid
+ (NSString *)getUniqueUid
{
    NSString *userLoginUid = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserUniqueUid];

    // 由于第一次升级版本，之前没有存uniqueUid，所以要先判断一下
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *newVersion = [currentVersion substringToIndex:3];
    
    if (newVersion.floatValue >= 2.6) {
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];

        if ((nil != uid) && (![@""  isEqual: uid]) && (![@"0"  isEqual: uid])) {
            userLoginUid = uid;
        }
    }
    
    // test code
    //    userLoginUid = nil;
    
    // 如果获取uid时候出问题，则提示用户并登出。
    if ((nil == userLoginUid) || ([@""  isEqual: userLoginUid])) {
        // 延迟0.2秒进行所有网络请求的cancel。
        [self performSelector:@selector(doCancelAllRequest) withObject:nil afterDelay:0.2];
        
        MicroSchoolAppDelegate* appdele = (MicroSchoolAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appdele doLogOut:@"网络连接异常，请检查网络后重新登录试试。"];
    }
    
    return [NSString stringWithFormat:@"%@", userLoginUid];
}

+ (NSString *)getUniqueUidWithoutQuit
{
    NSString *userLoginUid = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserUniqueUid];
    
    // 由于第一次升级版本，之前没有存uniqueUid，所以要先判断一下
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *newVersion = [currentVersion substringToIndex:3];
    
    if (newVersion.floatValue >= 2.6) {
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        
        if ((nil != uid) && (![@""  isEqual: uid]) && (![@"0"  isEqual: uid])) {
            userLoginUid = uid;
        }
    }

    if (nil == userLoginUid) {
        return userLoginUid;
    }else {
        userLoginUid = [NSString stringWithFormat:@"%@",userLoginUid];
        return userLoginUid;
    }
}

+ (void)doCancelAllRequest
{
    [[TSNetworking sharedClient] cancelAll];
}

// 获取程序内部唯一uid
+ (NSString *)getUniqueUid4FRNetPool
{
    NSString *userLoginUid = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserUniqueUid];
    
    // test code
//    userLoginUid = nil;
    
    // 由于第一次升级版本，之前没有存uniqueUid，所以要先判断一下
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *newVersion = [currentVersion substringToIndex:3];
    if (newVersion.floatValue >= 2.6) {
        NSDictionary *uI = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
        NSString* uid= [uI objectForKey:@"uid"];
        
        if ((nil != uid) && (![@""  isEqual: uid]) && (![@"0"  isEqual: uid])) {
            userLoginUid = uid;
        }
    }
    
    // 如果获取uid时候出问题，则提示用户并登出。
    if ((nil == userLoginUid) || ([@""  isEqual: userLoginUid])) {
        [self performSelectorOnMainThread:@selector(doLogout4FRNetPool) withObject:nil waitUntilDone:YES];
    }
    
    return [NSString stringWithFormat:@"%@", userLoginUid];
}

+ (void)doLogout4FRNetPool
{
    MicroSchoolAppDelegate* appdele = (MicroSchoolAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdele doLogOut:@"网络连接异常，请检查网络后重新登录试试。"];
}

+ (NSString *)md5:(NSString *)str;
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *md5Str = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
    NSString *md5 = [[md5Str substringWithRange:NSMakeRange(8,16)] uppercaseString];
    
    return md5;
}

+ (NSString *)md5With32:(NSString *)str;
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    
    return md5Str;
}

+ (NSString *)md5AndEncodeBase64:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    NSData *encryptData = [[NSData alloc] initWithBytes:result length:16];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [encryptData base64EncodedStringWithOptions:0];
    
    return base64Encoded;
}

+ (NSString *)encryptionDIY:(NSString *)str
{
    NSString *test1 = [self getRandomWithNum:5];
    NSString *test2 = [self getRandomStringWithNum:5];
    
    str = [NSString stringWithFormat:@"%@%@",str,test1];
    
    str = [self base64Encode:str];
    
    str = [NSString stringWithFormat:@"%@%@",test2,str];
    
    return str;
}

+ (NSString *)decryptionDIY:(NSString *)str
{
    str = [str substringFromIndex:5];
    
    str = [self base64Decode:str];
    
    str = [str substringWithRange:NSMakeRange(0, [str length] - 5)];
    
    return str;
}

//  随机数
+ (NSString *)getRandomWithNum:(NSInteger)num
{
    NSString *string = @"";
    for (int i = 0; i < num; i++) {
        string = [NSString stringWithFormat:@"%@%d",string, [self getRandomNumber:0 to:9]];
    }
    return string;
}


//  0-9 A-Z a-z 的 num 个随机数
+ (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = @"";
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 61;
        if (number < 10)
        {
            string = [NSString stringWithFormat:@"%@%d",string,number];
        }
        else if (number >= 10 && number <= 36)
        {
            string = [NSString stringWithFormat:@"%@%c",string,number + 55];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@%c",string,number + 60];
        }
    }
    return string;
}

+ (NSString *)base64Encode:(NSString *)str {
    NSData *nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    return base64Encoded;	
}

+ (NSString *)base64Decode:(NSString *)str {
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:str options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}

// 获取麦克风/录音权限
+ (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}

+ (BOOL)isUserIdLegally:(UserIdentityLegallyType)idType
{
    BOOL ret = YES;
    
    
    
    
    return ret;
}

+ (UserType)getUserType
{
    NSDictionary *userInfo = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];

    if ([@"0"  isEqual: userType]) {
        return UserType_Student;
    }else if ([@"6"  isEqual: userType]) {
        return UserType_Parent;
    }else if ([@"7"  isEqual: userType]) {
        return UserType_Teacher;
    }else if ([@"9"  isEqual: userType]) {
        return UserType_Eduinspector;
    }else if ([@"2"  isEqual: userType]) {
        return UserType_Admin;
    }else {
        return UserType_End;
    }
}

+ (int)getRandomNumber:(int)from to:(int)to;
{
    return (int)(from + (arc4random() % (to-from + 1)));
}

+(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (UIButton *)addButton:(UIButton *)btn title:(NSString *)title rect:(CGRect)rect{
    btn.frame = rect;
    
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
//    [btn addTarget:self action:@selector(action) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];

    return btn;
}

+ (CGSize)getScreenSize {
    CGSize size;
    
    if (IOS_VERSION_ABOVE_9){
        size = [UIScreen mainScreen].bounds.size;
    }else {
        size = [UIScreen mainScreen].applicationFrame.size;
    }
    
    return size;
}

+ (CGSize)getScreenSizeWithoutBar {
    CGSize size;
    
    if (IOS_VERSION_ABOVE_9){
        size = [UIScreen mainScreen].bounds.size;
        
        // 去掉状态栏的20，导航栏的44
        size.height = size.height - 64;
    }else {
        size = [UIScreen mainScreen].applicationFrame.size;
        
        size.height = size.height - 44;
    }
    
    return size;
}

+ (CGRect)getScreenRectWithoutBar{
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, [self getScreenSizeWithoutBar].width, [self getScreenSizeWithoutBar].height);
    
    return rect;
}

+ (float)convertPixsH:(float)pixs6 {
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    return (pixs6/667.0)*size.height;
}

+ (float)convertPixsW:(float)pixs6 {
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    return (pixs6/375.0)*size.width;
}

+ (float)transformationHeight:(float)pixs6 {
    if (iPhone6p) {
        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        return (pixs6/667.0)*size.height;
    }else {
        return pixs6;
    }
}

+ (float)transformationWidth:(float)pixs6 {
    if (iPhone6p) {
        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        return (pixs6/375.0)*size.width;
    }else {
        return pixs6;
    }
}

+ (NSString *)compareFloatA:(float)a floatB:(float)b;
{
    NSNumber *f1 = [NSNumber numberWithFloat:a];
    NSNumber *f2 = [NSNumber numberWithFloat:b];
    
    if ([f1 compare:f2] == NSOrderedAscending) {
        return @"less";
    }else if ([f1 compare:f2] == NSOrderedSame) {
        return @"same";
    }else if ([f1 compare:f2] == NSOrderedDescending) {
        return @"greater";
    }
    return @"unknow";
}

+ (BOOL)isBiggerThan:(float)a number:(float)b
{
    NSNumber *f1 = [NSNumber numberWithFloat:a];
    NSNumber *f2 = [NSNumber numberWithFloat:b];
    
    if ([f1 compare:f2] == NSOrderedAscending) {
        return NO;
    }else {
        return YES;
    }
}

+ (BOOL)isNeedShowTabbar:(UIViewController *)vc {
    BOOL ret = false;
    
    if ([vc isKindOfClass:[MicroSchoolMainMenuViewController class]] ||
        [vc isKindOfClass:[ClassDetailViewController class]] ||
        [vc isKindOfClass:[MyClassListViewController class]] ||
        [vc isKindOfClass:[MomentsEntranceTableViewController class]] ||
        [vc isKindOfClass:[MomentsEntranceForTeacherController class]] ||
        [vc isKindOfClass:[SchoolListForBureauViewController class]] ||
        [vc isKindOfClass:[MyInfoCenterViewController class]]) {
        
        ret = true;
    }
    
    return ret;
}
//-------------------------------Chenth 2016-04-20
+ (NSString *)changeDate:(NSString *)string
{
    Utilities *util = [[Utilities alloc] init];
    NSString *tempString = [NSString stringWithString:string];
    tempString = [util linuxDateToString:string andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    NSString *outString = [NSString string];
    //修改时间格式
    //获取当前日期 + 时间
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormater stringFromDate:currentDate];
    NSLog(@"dateString:%@", dateString);
    
    //获取昨天的日
    NSDateFormatter *yesterdaydate = [[NSDateFormatter alloc] init];
    [yesterdaydate setDateFormat:@"dd"];
    NSString *yesterdayString = [yesterdaydate stringFromDate:currentDate];
    yesterdayString = [NSString stringWithFormat:@"%ld", yesterdayString.integerValue - 1];
    NSLog(@"yesterdayString:%@", yesterdayString);
    
    //获取昨天的年月日
    NSString *ymd = [NSString stringWithString:[NSString stringWithFormat:@"%@%@", [dateString substringToIndex:8], yesterdayString]];
    NSLog(@"ymd:%@", ymd);
    NSLog(@"dateString:%@", dateString);
    NSLog(@"tempString:%@", tempString);
    if ([tempString containsString:dateString]) {
        outString = [NSString stringWithFormat:@"%@ %@", @"今天", [tempString substringFromIndex:10]];
    }
    else if ([tempString containsString:ymd]){
        outString = [NSString stringWithFormat:@"%@ %@", @"昨天", [tempString substringFromIndex:10]];
    }
    else{
        outString = tempString;
        
    }
    return outString;
}
//------------------------------
@end
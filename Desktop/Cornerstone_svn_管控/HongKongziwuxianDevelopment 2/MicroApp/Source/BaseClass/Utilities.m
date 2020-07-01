//
//  Utilities.m
//  CarHome
//
//  Created by kaiyi on 2017/12/19.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "Utilities.h"

#import "UIImage+GIF.h"

#import <AVFoundation/AVFoundation.h>


//  判断手机型号
//1.引入utsname文件
#import <sys/utsname.h>




#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)



@implementation Utilities


+(BOOL)isConnected
{
    //  网络判断
    return [Utility isNetAvilible];
}


/*
 hud相关.-------------------------
 */

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
//    //   判断 descV 上是否有
//    MBProgressHUD *hudExist = [MBProgressHUD HUDForView:descV];
//    if (hudExist == nil) {
    
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
        hud.activityIndicatorColor = [UIColor darkGrayColor];
        hud.color = [UIColor clearColor];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView=gifview;
        hud.graceTime = 0;
        
        hud.tag = 9988;
        [descV addSubview:hud];
        [hud showAnimated:YES];
//    }
//    else
//    {
//        MBProgressHUD *hud = [descV viewWithTag:9988];
//        [hud hideAnimated:NO];
//        [hud showAnimated:YES];
//
//    }
}

// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:descV];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        if (9988 == hud.tag) {
            [hud hideAnimated:NO];
        }else {
            [hud hideAnimated:YES];
        }
    }
}


// 执行请求成功与否的hud。
// text为显示的文字，传nil则为默认成功与失败。
+ (void)showSuccessedHud:(NSString *)text descView:(UIView *)descV
{
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:descV];
    [descV addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 50) ];
    
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 30, 30)];
    [imgView setImage:image];
    
    [HUD.customView addSubview:imgView];
    
    
    if (nil == text) {
        text = @"请求成功";
    }
    HUD.label.text = text;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = -8;
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];

}

+ (void)showFailedHud:(NSString *)text descView:(UIView *)descV
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
    
    HUD.label.text = text;
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.yOffset = -30;
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}

+ (void)showTextHud:(NSString *)text descView:(UIView *)descV
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
    
    HUD.label.text = text;
    
    HUD.mode = MBProgressHUDModeCustomView; //  MBProgressHUDModeText
    
    HUD.yOffset = -30;
//    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.label.font = [UIFont systemFontOfSize:14.f];
    HUD.label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}

+ (void)showMultiLineTextHud:(NSString *)title content:(NSString *)text descView:(UIView *)descV
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
    
    HUD.label.text = title;
    
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = text;
    
    HUD.yOffset = -30;
    HUD.opacity = 0;
    HUD.cornerRadius = 3;
    
    HUD.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    HUD.labelFont = [UIFont systemFontOfSize:14];
    HUD.labelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:2];
}


///*
// 页面显示相关.-------------------------
// */

//// 空白页通用
//+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2;
//+ (UIView*)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect;
//
//
//// 空白页显示
//+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name startY:(float)start;
//+(void)showNodataView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect descView:(UIView*)desV imgName:(NSString*)name imgW:(float)imgWidth textColor:(UIColor*)textColor startY:(float)start;
//// 空白页消失
//+(void)dismissNodataView:(UIView*)desV;
//


// 无网络连接通用
+(UIView*)showNoNetworkView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect
{
    
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    float start = (rect.size.height - 110.0)/3.0;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 110.0)/2.0, start, 110.0, 110.0)];
    imgV.image = [UIImage imageNamed:@"icon_noNetworkImg"];
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
    
    return view;
    
}

//  飞机列表页没有数据显示
+ (UIView*)showNoListView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    float start = (rect.size.height - 110.0)/3.0;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 110.0)/2.0, start, 110.0, 110.0)];
    imgV.image = [UIImage imageNamed:@"icon_noNoListImg"];
    [view addSubview:imgV];
    
    if ([[Utilities replaceNull:msg] isEqualToString:@""]) {
        msg = @"暂时没有新消息哦~";
    }
    
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
    
    return view;
}


+ (void)showNoListView:(NSString*)msg msg2:(NSString*)msg2 descView:(UIView *)descV isShow:(BOOL)isShow
{
    
    if (descV == nil) descV = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [descV viewWithTag:30000];
    
    if (isShow == YES) {
        
        if (!view) {
           
            UIView *view = [[UIView alloc]initWithFrame:descV.frame];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = 30000;
            [descV addSubview:view];
            
            float start = (descV.bounds.size.height - 110.0)/3.0;
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 110.0)/2.0, start, 110.0, 110.0)];
            imgV.image = [UIImage imageNamed:@"icon_noNoListImg"];
            [view addSubview:imgV];
            
            if ([[Utilities replaceNull:msg] isEqualToString:@""]) {
                msg = @"暂时没有新消息哦~";
            }
            
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
        }
    } else {
        
        if (view) {
            [view removeFromSuperview];
        }
    }
}

//   最后 7个子变成红色
+(NSAttributedString *)last7_RedWithString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger temp = [str length];
    
    if (temp >= 7) {
        //   改变颜色
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(temp - 7,7)];
    }
    
    //    [str addAttribute:NSFontAttributeName
    //                value:[UIFont fontWithName:@"Arial" size:13.f]
    //                range:NSMakeRange(temp - 1,1)];
    return str;
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

/*
 * 去掉服务器返回结果文本中的<null>  数组
 */
+ (NSArray *)replaceArrNull:(NSArray *)arr
{
    if (arr != nil && ![arr isKindOfClass:[NSNull class]] && arr.count != 0){
        //执行array不为空时的操作
        return arr;
    } else {
        return @[];
    }
}

//  转json
+(NSString *)objectToJsonWithObject:(NSObject *)object
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//  转json str，去掉格式的str
+(NSString *)objectToJsonStringWithObject:(NSObject *)object
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@" "withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    
    return str;
}

// 将JSON串转化为字典或者数组
+ (id)JsonStrtoArrayOrNSDictionary:(id)jsonData{
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}


//将string字符串转换为array数组
+(NSArray *)strChangeArrWithStr:(NSString *)str
{
    return [str componentsSeparatedByString:@","]; // --分隔符
}


//将array数组转换为string字符串
+(NSString *)arrChangestrWithArr:(NSArray *)array
{
    return [array componentsJoinedByString:@","]; //  --分隔符
}



//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到秒
    return timeStr;
}


//  NSDate时间转时间戳
+ (NSString *)getCurrentTimeStampWithNsDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = date;//现在时间
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    return [NSString stringWithFormat:@"%ld",timeSp];
}

//  当前时间的时间戳
+ (NSString *)getCurrentTimeStampStr
{
    return [Utilities getCurrentTimeStampWithNsDate:[NSDate date]];
}



// 获取本地视频数据
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

//   UIlable,自适应宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

//   UIlable,自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

//   判断手机格式
+ (BOOL)isValidPhoneNumber:(NSString *)mobile {
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:mobile];
}



//获得设备型号
+(NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
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
    //add by lyp
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    //add by kaiyi
    if ([platform isEqualToString:@"iPhone10,1"])   return @"(A1863)(A1906)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"(Global/A1905)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"(A1864)(A1898)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"(Global/A1897)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"(A1865)(A1902)iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"(Global/A1901)iPhone X";
    
    
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

@end

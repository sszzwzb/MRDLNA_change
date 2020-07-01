//
//  AddImageUtilities.h
//  ImgTool
//
//  Created by banana on 2017/8/3.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone3gs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS_VERSION_ABOVE_8 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0
#define IOS_VERSION_ABOVE_9 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0
#define IOS_VERSION_ABOVE_10 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0
#define IOS_VERSION_BELOW_10 [[[UIDevice currentDevice] systemVersion] doubleValue] < 10.0





@interface AddImageUtilities : NSObject


// 用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。
//如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。这是因为我们执行像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0，造成照片内容和imageOrientaion不匹配。
+ (UIImage *)fixOrientation:(UIImage *)aImage;


+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



// 比较两个图片是否相同
+(BOOL)image:(UIImage *)aImage1 equalsTo:(UIImage *)aImage2;







// 最新适配方法
+ (float)transformationHeight:(float)pixs6;
+ (float)transformationWidth:(float)pixs6;

/*
 hud相关.-------------------------
 */

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV;
+ (void)showSystemProcessingHud:(UIView *)descV;
+ (void)showFirstLoadProcessingHud:(UIView *)descV;

// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV;
//
//// 执行请求成功与否的hud。
//// text为显示的文字，传nil则为默认成功与失败。
+ (void)showSuccessedHud:(NSString *)text descView:(UIView *)descV;
//+ (void)showFailedHud:(NSString *)text descView:(UIView *)descV;
//+ (void)showTextHud:(NSString *)text descView:(UIView *)descV;
//+ (void)showMultiLineTextHud:(NSString *)title content:(NSString *)text descView:(UIView *)descV;
//
//// 通用方法处理网络请求错误
////+ (void)doHandleTSNetworkingErr:(TSNetworkingErrType)errType descView:(UIView *)descView;
//
//+ (void)addCustomizedHud:(UIImageView *)imgView
//                showText:(NSString *)showStr
//               hideDelay:(NSInteger)delay
//                descView:(UIView *)desV;
//
//// 上滑对话框
//+ (void)showPopupView:(NSString *)title items:(NSArray *)items;
//+ (void)showPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view;




@end

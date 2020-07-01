//
//  AddImageUtilities.m
//  ImgTool
//
//  Created by banana on 2017/8/3.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "AddImageUtilities.h"

#import "TSProgressHUD.h"
//#import "TSPopupView.h"

@implementation AddImageUtilities


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


+(BOOL)image:(UIImage *)aImage1 equalsTo:(UIImage *)aImage2
{
    NSData *img1Data = UIImageJPEGRepresentation(aImage1, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation(aImage2, 1.0);
    return [img1Data isEqualToData:img2Data];
}






+ (float)transformationHeight:(float)pixs6 {
    if (iPhone6p) {
        //        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        //        return (pixs6/667.0)*size.height;
        
        return pixs6;
        
        //        pixs6 = pixs6*1.5;
        //        return pixs6;
    }else {
        return pixs6;
    }
}

+ (float)transformationWidth:(float)pixs6 {
    if (iPhone6p) {
        //        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        //        return (pixs6/375.0)*size.width;
        
        return pixs6;
        
        //        pixs6 = pixs6*1.5;
        //        return pixs6;
    }else {
//        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        
        return pixs6;
    }
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

+ (void)showMultiLineTextHud:(NSString *)title content:(NSString *)text descView:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowMultiLineTextHud:title content:text descView:descV];
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

// 加载中hud。
+ (void)showProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowProcessingHud:descV];
}

+ (void)showSystemProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowSystemProcessingHud:descV];
}
+ (void)showFirstLoadProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doShowFirstLoadProcessingHud:descV];
}

// 消除加载中hud。
+ (void)dismissProcessingHud:(UIView *)descV {
    [[[TSProgressHUD sharedClient] init] doDismissProcessingHud:descV];
}



//// 底部弹出的对话框。
//+ (void)showPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view {
//    [[[TSPopupView sharedClient] init] doShowPopupView:title items:items view:(UIView *)view];
//}
//
//+ (void)showPopupView:(NSString *)title items:(NSArray *)items {
//    [[[TSPopupView sharedClient] init] doShowPopupView:title items:items];
//}


@end

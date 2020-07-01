//
//  @interface UIImage(UIImageScale)  -(UIImage*)getSubImage:(CGRect)rect;  UIImage(UIImageScale).m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "UIImage+UIImageScale.h"


@implementation UIImage(UIImageScale)


-(UIImage*)getSubImage:(CGRect)rect

{
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    
    
    return smallImage;
    
}

@end

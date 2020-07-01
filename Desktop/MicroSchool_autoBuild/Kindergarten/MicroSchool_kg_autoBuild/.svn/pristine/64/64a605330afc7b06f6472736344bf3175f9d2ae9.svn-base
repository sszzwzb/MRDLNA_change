//
//  ImageResourceLoader.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResourceLoader : NSObject

//读取图片资源
+ (UIImage *)ImageForName:(NSString *)name;

//做成圆角的Image
//+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
//+ (id)createRoundedRectImage:(UIImage*)image radius:(NSInteger)r;

//获取图片中间的正方形
+ (UIImage*)createImage:(UIImage *)image centerInSize:(CGSize)viewSize;

//按照等比例缩放后的图片
+ (UIImage*)CompressImage:(UIImage*)bigImg withHeight:(float)height withWidth:(float)width;

//将图片缩放到指定的大小
+ (UIImage*)resizeImage:(UIImage *)image toSize:(CGSize)newSize;

@end

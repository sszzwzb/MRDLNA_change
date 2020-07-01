//
//  UIImage+wiRoundedRectImage.h
//  MicroSchool
//
//  Created by jojo on 15/6/2.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wiRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
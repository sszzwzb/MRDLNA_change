//
//  Camera360View.m
//  东方幼儿园测试
//
//  Created by kaiyi on 2017/10/12.
//  Copyright © 2017年 jiaminnet. All rights reserved.
//

#import "Camera360View.h"

@implementation Camera360View


-(void)layoutSubviews{
    [super layoutSubviews];
    UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
//        [self maskViewAndMenu];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(upView_maskViewAndMenu)]) {
            [self.delegate upView_maskViewAndMenu];
        }
        
        NSLog(@"横屏  ");
    }
}

@end

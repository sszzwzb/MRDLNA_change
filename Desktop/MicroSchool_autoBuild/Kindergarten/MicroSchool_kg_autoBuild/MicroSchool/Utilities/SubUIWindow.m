//
//  SubUIWindow.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SubUIWindow.h"

@implementation SubUIWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
   
    return UIInterfaceOrientationMaskPortrait;
}

@end

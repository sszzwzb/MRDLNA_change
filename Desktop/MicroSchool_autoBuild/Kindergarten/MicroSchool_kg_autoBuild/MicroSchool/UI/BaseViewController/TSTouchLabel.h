//
//  TSTouchLabel.h
//  MicroSchool
//
//  Created by jojo on 15/1/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PublicConstant.h"

@interface TSTouchLabel : UILabel

@property(nonatomic, assign) int msgWidth;
@property(nonatomic, assign) int msgHeight;
@property(nonatomic, retain) UIImageView *imgViewMsg;

@property(nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSString *tid;
@property(nonatomic, retain) NSString *cellNum;
@property(nonatomic, retain) NSString *touchType;
@property (nonatomic, retain) NSString *pasteboardStr;//2015.09.15
@end

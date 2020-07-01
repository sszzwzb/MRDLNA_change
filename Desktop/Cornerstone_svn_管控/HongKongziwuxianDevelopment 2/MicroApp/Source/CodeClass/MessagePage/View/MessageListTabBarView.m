//
//  MessageListTabBarView.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessageListTabBarView.h"

@implementation MessageListTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upDIYNarTab];
    }
    return self;
}


-(void)upDIYNarTab
{
    
//    self.layer.contents = (id)[UIImage imageNamed:@"MessageHomeBG"].CGImage;
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:
                          CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.frame))];
    [self addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"MessageHomeBG"];
    [imgBG setContentMode:UIViewContentModeScaleAspectFill];
    imgBG.clipsToBounds = YES;
    
    imgBG.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat minY = iPhoneX ? 0 : 22;
    
    UILabel *labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(0, STATUS_BAR_HEIGHT + minY, KScreenWidth, 44)];
    [self addSubview:labTitle];
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = FONT(17.f);
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.text = @"消息";
    
    
}

@end

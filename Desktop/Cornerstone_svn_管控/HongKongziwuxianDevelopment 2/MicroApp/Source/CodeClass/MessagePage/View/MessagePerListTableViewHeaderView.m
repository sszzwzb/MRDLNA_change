//
//  MessagePerListTableViewHeaderView.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessagePerListTableViewHeaderView.h"



#define height_headerHeight  40

@interface MessagePerListTableViewHeaderView ()

@property (nonatomic,strong) UILabel *labTime;

@end

@implementation MessagePerListTableViewHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self upHeadView];
    }
    return self;
}


-(void)upHeadView
{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    _labTime = [[UILabel alloc]init];
    _labTime.frame = CGRectMake(0, (height_headerHeight - 20)/2, 0, 20);
    [self addSubview:_labTime];
    _labTime.textColor = [UIColor whiteColor];
    _labTime.backgroundColor = color_gray2;
    _labTime.layer.masksToBounds = YES;
    _labTime.layer.cornerRadius = CGRectGetHeight(_labTime.frame)/2;
    _labTime.font = FONT(12.f);
    _labTime.textAlignment = NSTextAlignmentCenter;
    
}

-(void)setTimeStr:(NSString *)timeStr
{
    _timeStr = timeStr;
    
    CGFloat width = [Utilities getWidthWithTitle:timeStr font:FONT(12.f)] + 18;
    
    _labTime.frame = CGRectMake((KScreenWidth - width)/2, (height_headerHeight - 20)/2, width, 20);
    _labTime.text = timeStr;
    
}

+(CGFloat)headerHeight
{
    return height_headerHeight;
}


@end

//
//  ToolsPageView.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/19.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "ToolsPageView.h"

@interface ToolsPageView ()

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ToolsPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self up_view];
    }
    return self;
}

-(void)up_view
{
    
//    self.layer.contents = (id)[UIImage imageNamed:@"ToolsHomeBackGround"].CGImage;
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"ToolsHomeBackGround"];
    [imgBG setContentMode:UIViewContentModeScaleAspectFill];
    imgBG.clipsToBounds = YES;
    
    
    
    _dataArr = @[
                 @{@"title":@"老板端" , @"tag":@"0" , @"url":@"http://h5.meridianjet.vip/html5/OperationControl8-25/views/boss.html"},
                 @{@"title":@"航务管理" , @"tag":@"1" , @"url":@"http://h5.meridianjet.vip/OperationControl/views/Operatingsystem.html"},
                 @{@"title":@"运行控制" , @"tag":@"2" , @"url":@"http://h5.meridianjet.vip/OperationControl/views/Operationalcontrol.html"},
                 @{@"title":@"飞行管理" , @"tag":@"3" , @"url":@"http://h5.meridianjet.vip/OperationControl/views/Managementsystem.html"},
                 @{@"title":@"外采报销" , @"tag":@"4" , @"url":@"http://ms.meridianjet.vip/Tem/OperationControl/views/Flightattendant.html"},
                 @{@"title":@"交通机票补助" , @"tag":@"5" , @"url":@"http://ms.meridianjet.vip/Tem/OperationControl/views/Trafficticketsubsidy.html"},
                 ];
    
    CGFloat minY = (KScreenHeight - 80 * [_dataArr count] ) /2;
    
    for (int i = 0; i < [_dataArr count]; i++) {
        NSDictionary *dic = _dataArr[i];
        
        
        UIButton *but = [UIButton buttonWithType:(UIButtonTypeSystem)];
        but.frame = CGRectMake(KScreenWidth/5, minY + 80 * i, KScreenWidth/5*3, 50);
        [self addSubview:but];
        but.backgroundColor = [UIColor clearColor];
        
        [but setTitle:dic[@"title"] forState:(UIControlStateNormal)];
        [but setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        but.titleLabel.font = FONT_B(17.f);
        
        but.layer.cornerRadius = CGRectGetHeight(but.frame)/2;
        but.layer.borderColor = [UIColor whiteColor].CGColor;
        but.layer.borderWidth = 2;
        
        
        but.tag = 200 + i;
        [but addTarget:self action:@selector(butAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    
}

-(void)butAction:(UIButton *)button
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButWithTag:title:url:)]) {
        [self.delegate selectButWithTag:button.tag - 200 title:_dataArr[button.tag - 200][@"title"] url:_dataArr[button.tag - 200][@"url"]];
    }
    
}

@end

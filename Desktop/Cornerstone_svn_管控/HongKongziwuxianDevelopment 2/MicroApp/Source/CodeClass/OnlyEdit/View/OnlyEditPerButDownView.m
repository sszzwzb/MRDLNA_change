
//
//  OnlyEditPerButDownView.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditPerButDownView.h"

@interface OnlyEditPerButDownView ()

@property (nonatomic,strong) UIButton *butL;
@property (nonatomic,strong) UIButton *butR;

@end

@implementation OnlyEditPerButDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

-(void)upView
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _butL = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butL];
    _butL.frame = CGRectMake(10, 5, KScreenWidth - 20, 49-10);
    
    _butL.layer.masksToBounds = YES;
    _butL.layer.cornerRadius = CGRectGetHeight(_butL.frame)/2;
    
    _butL.backgroundColor = color_blue;
    [_butL setTitle:@"新建" forState:(UIControlStateNormal)];
    [_butL setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _butL.titleLabel.font = FONT(16.5f);
    [_butL setBackgroundImage:[UIImage imageNamed:@"nav14"] forState:(UIControlStateNormal)];
    _butL.tag = 1101;
    [_butL addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    _butR = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butR];
    _butR.frame = CGRectMake(KScreenWidth/2 + 5, 5, (KScreenWidth - 30)/2, 49-10);
    
    _butR.layer.masksToBounds = YES;
    _butR.layer.cornerRadius = CGRectGetHeight(_butR.frame)/2;
    
    _butR.backgroundColor = [UIColor whiteColor];
    [_butR setTitle:@"保存草稿" forState:(UIControlStateNormal)];
    [_butR setTitleColor:color_blue forState:(UIControlStateNormal)];
    _butR.titleLabel.font = FONT(16.5f);
    _butR.layer.borderWidth = 1.f;
    _butR.layer.borderColor = color_blue.CGColor;
    _butR.tag = 1100;
    [_butR addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _butR.hidden = YES;
}

- (void)setTypeInt:(NSInteger)typeInt
{
    
    if (typeInt == 0) {
        _butR.hidden = YES;
    } else if (typeInt == 1) {
        
        _butL.frame = CGRectMake(10, 5, (KScreenWidth - 30)/2, 49-10);
        [_butL setTitle:@"保存完成" forState:(UIControlStateNormal)];
        
        _butR.hidden = NO;
        
    }
    
    
}

-(void)buttonAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButDownViewWithTag:)]) {
        [self.delegate selectButDownViewWithTag:button.tag - 1100];
    }
}

@end

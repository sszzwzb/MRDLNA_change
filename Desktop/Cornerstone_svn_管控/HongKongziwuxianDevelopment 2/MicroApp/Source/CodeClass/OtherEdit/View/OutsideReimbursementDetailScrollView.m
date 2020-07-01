//
//  OutsideReimbursementDetailScrollView.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/16.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementDetailScrollView.h"

#import "OutsideReimbursementListModel.h"



@interface OutsideReimbursementDetailScrollView ()

@property (nonatomic,strong) UIView *bgView0;

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labDate;

@property (nonatomic,strong) UILabel *labFocus;
@property (nonatomic,strong) UILabel *labContent;


@property (nonatomic,strong) UIView *bgView1;

@end

@implementation OutsideReimbursementDetailScrollView

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
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    _bgView0 = [[UIView alloc]initWithFrame:
                CGRectMake(0, 0, KScreenWidth, 140)];
    [self addSubview:_bgView0];
    _bgView0.backgroundColor = [UIColor whiteColor];
    
    _bgView1 = [[UIView alloc]initWithFrame:
                CGRectMake(0, CGRectGetMaxY(_bgView0.frame) + 15, KScreenWidth, 140)];
    [self addSubview:_bgView1];
    _bgView1.backgroundColor = [UIColor whiteColor];
    
    
    
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake(20, 10, KScreenWidth - 40, 20)];
    [self addSubview:_labTitle];
    _labTitle.textColor = color_black;
    _labTitle.font = FONT(17.f);
    
    
    
    _labDate = [[UILabel alloc]initWithFrame:
                CGRectMake(20, CGRectGetMaxY(_labTitle.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labDate];
    _labDate.textColor = color_gray2;
    _labDate.font = FONT(15.f);
    
    
    //  线
    UIImageView *viewXian = [[UIImageView alloc]initWithFrame:
                             CGRectMake(20, CGRectGetMaxY(_labDate.frame) + 10 - 0.5, KScreenWidth, 0.5)];
    [self addSubview:viewXian];
    viewXian.image = [UIImage imageNamed:@"lineSystem"];
    
    
    
    //   报销价格
    _labFocus = [[UILabel alloc]initWithFrame:
                 CGRectMake(20, CGRectGetMaxY(viewXian.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labFocus];
    _labFocus.textColor = color_blue2;
    _labFocus.font = FONT(16.5f);
    
    
    
    //   备注
    _labContent = [[UILabel alloc]initWithFrame:
                   CGRectMake(20, CGRectGetMaxY(_labFocus.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labContent];
    _labContent.textColor = color_gray2;
    _labContent.font = FONT(15.f);
    _labContent.numberOfLines = 0;
    
    self.contentSize = CGSizeMake(KScreenWidth, CGRectGetHeight(self.frame) + 1);
    
}


-(void)setModel:(OutsideReimbursementListModel *)model
{
    _model = model;
    
    
    if (model) {
        _labTitle.text = [NSString stringWithFormat:@"%@  %@",_model.airplaneType,_model.orderName];
        _labDate.text = [Utilities replaceNull:_model.departureDate];
        
        if (model.subsidiesamount) {
            NSString *subsidiesamount = [[Utilities replaceNull:model.subsidiesamount] isEqualToString:@""] ? @"0" : [Utilities replaceNull:model.subsidiesamount];
            _labFocus.text = [NSString stringWithFormat:@"报销价格：%@",subsidiesamount];
        }
        if (model.oilnum) {
            NSString *oilNum = [[Utilities replaceNull:model.oilnum] isEqualToString:@""] ? @"0" : [Utilities replaceNull:model.oilnum];
            _labFocus.text = [NSString stringWithFormat:@"剩余油量：%@ kg",oilNum];
        }
        
        NSString *Memo = [[Utilities replaceNull:_model.Memo] isEqualToString:@""] ? @"无" : [Utilities replaceNull:model.Memo];
        _labContent.text = [NSString stringWithFormat:@"备注：%@",Memo];
        CGFloat MemoHeight = [Utilities getHeightByWidth:CGRectGetWidth(_labContent.frame) title:Memo font:FONT(15.f)] + 20;
        _labContent.frame = CGRectMake(CGRectGetMinX(_labContent.frame), CGRectGetMinY(_labContent.frame), CGRectGetWidth(_labContent.frame), MemoHeight);
        
        
        _bgView0.frame = CGRectMake(0, 0, KScreenWidth, 120 + MemoHeight);
        
        
        
        
        
        
        
        //   图片
        CGFloat imgsWidth = (KScreenWidth - 40) / 3 ;
        
        NSArray *imgSArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:[Utilities replaceNull:model.PicUrl]]];
        
        _bgView1.frame = CGRectMake(0,
                                    CGRectGetMaxY(_bgView0.frame) + 15,
                                    KScreenWidth,
                                    (([imgSArr count] / 3) + (([imgSArr count] % 3)>0?1:0)) * (imgsWidth + 10) + 10);
        
        _bgView1.hidden = [imgSArr count] == 0 ? YES : NO;
        
        for (int i = 0; i < [imgSArr count]; i++) {
            
            UIButton *but = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [_bgView1 addSubview:but];
            but.frame  =CGRectMake(10 + (imgsWidth + 10) * (i % 3),
                                   10 + (imgsWidth + 10) * (i / 3), imgsWidth, imgsWidth);
            
            if (model.subsidiesamount) {
                [but sd_setBackgroundImageWithURL:[NSURL URLWithString:imgSArr[i][@"Column1"]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
            } else {
                [but sd_setBackgroundImageWithURL:[NSURL URLWithString:imgSArr[i][@"urlpath"]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
            }
            
            but.tag = 200 + i;
            [but addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }
        
        
        CGFloat allHeight = 160 + MemoHeight + (([imgSArr count] / 3) + (([imgSArr count] % 3)>0?1:0)) * (imgsWidth + 10) + 10  + 50;
        self.contentSize = CGSizeMake(KScreenWidth, allHeight > CGRectGetHeight(self.frame) ? allHeight : CGRectGetHeight(self.frame)  +1);
        
        
        
    }
    
}



-(void)buttonAction:(UIButton *)button
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(selectButtonForImg:)]) {
        [self.myDelegate selectButtonForImg:button.currentBackgroundImage];
    }
}


@end

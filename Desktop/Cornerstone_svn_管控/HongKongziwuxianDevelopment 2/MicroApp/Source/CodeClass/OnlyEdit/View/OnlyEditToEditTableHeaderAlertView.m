//
//  OnlyEditToEditTableHeaderAlertView.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditToEditTableHeaderAlertView.h"

#import "OnlyEditPerSQLModel.h"


@interface OnlyEditToEditTableHeaderAlertView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation OnlyEditToEditTableHeaderAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self up_view];
    }
    return self;
}


-(void)up_view
{
    
    
    //   整体的按键
    UIButton *pickerView_bg_gray = [UIButton buttonWithType:(UIButtonTypeSystem)];
    pickerView_bg_gray.frame = [UIScreen mainScreen].bounds;
    pickerView_bg_gray.backgroundColor = color_blackAlpha;
    //  取消
    [pickerView_bg_gray addTarget:self action:@selector(btnCancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:pickerView_bg_gray];
    
    
    
    
    //  白色弹窗
    UIView *rootViewBackGround = [[UIView alloc]initWithFrame:
                                  CGRectMake((KScreenWidth-280)/2, (KScreenHeight - 380)/2, 280 , 380)];
    [self addSubview:rootViewBackGround];
    rootViewBackGround.backgroundColor = [UIColor whiteColor];
    
    
    //   选择机型
    UILabel *labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(0, 0, CGRectGetWidth(rootViewBackGround.frame), 50)];
    [rootViewBackGround addSubview:labTitle];
    labTitle.text = @"选择机型";
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.textColor = color_black;
    
    
    //  线
    UIImageView *viewXian = [[UIImageView alloc]initWithFrame:
                             CGRectMake(0, 50 - 0.5, CGRectGetWidth(rootViewBackGround.frame), 0.5)];
    [rootViewBackGround addSubview:viewXian];
    viewXian.image = [UIImage imageNamed:@"lineSystem"];
    
    
    
    //  关闭
    UIButton *butClose = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rootViewBackGround addSubview:butClose];
    butClose.frame = CGRectMake(0, 0, 60, CGRectGetHeight(labTitle.frame));
    [butClose setTitle:@"关闭" forState:(UIControlStateNormal)];
    [butClose setTitleColor:color_black forState:(UIControlStateNormal)];
    butClose.titleLabel.font = FONT(14.f);
    [butClose addTarget:self action:@selector(btnCancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:
                   CGRectMake(0, 50, CGRectGetWidth(rootViewBackGround.frame), CGRectGetHeight(rootViewBackGround.frame) - 100)];
    [rootViewBackGround addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
    //  确定
    UIButton *butOK = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rootViewBackGround addSubview:butOK];
    butOK.frame = CGRectMake(20, CGRectGetMaxY(_scrollView.frame) + (50 - 32)/2, CGRectGetWidth(rootViewBackGround.frame) - 40, 32);
    butOK.layer.masksToBounds = YES;
    butOK.layer.cornerRadius = CGRectGetHeight(butOK.frame)/2;
    [butOK setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [butOK setTitle:@"确定" forState:(UIControlStateNormal)];
    [butOK addTarget:self action:@selector(btnSureAction) forControlEvents:(UIControlEventTouchUpInside)];
    [butOK setBackgroundImage:[UIImage imageNamed:@"nav14"] forState:(UIControlStateNormal)];
    
    
    //  线
    UIImageView *viewXian1 = [[UIImageView alloc]initWithFrame:
                             CGRectMake(0, CGRectGetHeight(rootViewBackGround.frame) - 50 - 0.5, CGRectGetWidth(rootViewBackGround.frame), 0.5)];
    [rootViewBackGround addSubview:viewXian1];
    viewXian1.image = [UIImage imageNamed:@"lineSystem"];
    
    [self showKyTypePicker];
    
}

-(void)reloadData
{
    if ([_dataArr count] > 0) {
        
        CGFloat width = CGRectGetWidth(_scrollView.frame)/2;
        CGFloat height = 44;
        
        for (int i = 0 ; i < [_dataArr count]; i++) {
            OnlyEditPerSQLModel *model = _dataArr[i];
            
            OnlyEditToEditTableHeaderAlertViewButton *but = [OnlyEditToEditTableHeaderAlertViewButton buttonWithType:(UIButtonTypeCustom)];
            [_scrollView addSubview:but];
            but.frame = CGRectMake((i%2)*width, i/2*height, width, height);
            
            [but setImage:[[UIImage imageNamed:@"OnlyEditToEditRNormal"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
            [but setImage:[[UIImage imageNamed:@"OnlyEditToEditRSelect"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateSelected)];
            
            [but setTitle:[Utilities replaceNull:model.airplaneType] forState:(UIControlStateNormal)];
            [but setTitleColor:color_gray2 forState:(UIControlStateNormal)];
            [but setTitleColor:color_blue forState:(UIControlStateSelected)];
            but.titleLabel.font = FONT(14.f);
            
            but.tag = 300 + i;
            [but addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            but.selected = NO;
            if (_curentModel) {
                if ([[Utilities replaceNull:_curentModel.airplaneType] isEqualToString:[Utilities replaceNull:model.airplaneType]]) {
                    but.selected = YES;
                }
            }
            
        }
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), height * ([_dataArr count]/2 + [_dataArr count]%2));
    }
}


-(void)buttonAction:(UIButton *)button
{
    OnlyEditPerSQLModel *model = _dataArr[button.tag - 300];
    
    _curentModel = model;
    
    for (int i = 0 ; i < [_dataArr count]; i++) {
        UIButton *but = [_scrollView viewWithTag:300 + i];
        but.selected = NO;
    }
    button.selected = YES;
    
}

-(void)selectSelectairplaneType:(getSelectairplaneType)getSelectairplaneType
{
    _getSelectairplaneType = getSelectairplaneType;
}

//   取消按键
- (void)btnCancelAction{
    [self disMissTypePicker];
}

//   确认按键
- (void)btnSureAction{
    
    NSLog(@"选择机型 = %@",_curentModel.airplaneType);
    
    if (_getSelectairplaneType && _curentModel) {
        _getSelectairplaneType(_curentModel);
    }
    
    [self disMissTypePicker];
}

//    让这个界面为主
- (void)showKyTypePicker{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
}

//   确认，或者退出的时候，清空这个页面
-(void)disMissTypePicker{
    [self removeFromSuperview];
}

@end


@implementation OnlyEditToEditTableHeaderAlertViewButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(40, 0, contentRect.size.width - 40, contentRect.size.height);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10, (contentRect.size.height - 20)/2, 20, 20);
}

@end


//
//  OnlyEditToEditTableHeaderView.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditToEditTableHeaderView.h"

#import "DIYSystemDatePickerView.h"
#import "OnlyEditToEditTableHeaderAlertView.h"
#import "OnlyEditPerSQLModel.h"



#define Height_haederHeight  110


@interface OnlyEditToEditTableHeaderView ()

@property (nonatomic,strong) OnlyEditToEditTableHeaderButton *butDate;
@property (nonatomic,strong) OnlyEditToEditTableHeaderButton *butType;

@property (nonatomic,strong) DIYSystemDatePickerView *datePickerView;

@end

@implementation OnlyEditToEditTableHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self up_headerView];
    }
    return self;
}

-(void)up_headerView
{
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:
                      CGRectMake(0, 0, KScreenWidth, Height_haederHeight - 10)];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    
    //  选择日期
    _butDate = [OnlyEditToEditTableHeaderButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butDate];
    _butDate.frame = CGRectMake(20, 15, KScreenWidth - 40, 32);
//    _butDate.layer.masksToBounds = YES;
    _butDate.layer.cornerRadius = CGRectGetHeight(_butDate.frame)/2;
    _butDate.layer.borderWidth = 0.8f;
    _butDate.layer.borderColor = color_gray2.CGColor;
    [_butDate setTitle:@"选择日期" forState:(UIControlStateNormal)];
    [_butDate setTitleColor:color_gray2 forState:(UIControlStateNormal)];
    _butDate.titleLabel.font = FONT(14.f);
    [_butDate setImage:[[UIImage imageNamed:@"OnlyEditToEditDate"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    _butDate.tag = 200;
    [_butDate addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    //  选择机型
    _butType = [OnlyEditToEditTableHeaderButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butType];
    _butType.frame = CGRectMake(20, CGRectGetMaxY(_butDate.frame) + 10, KScreenWidth - 40, 32);
    _butType.layer.cornerRadius = CGRectGetHeight(_butDate.frame)/2;
    _butType.layer.borderWidth = 0.8f;
    _butType.layer.borderColor = color_gray2.CGColor;
    [_butType setTitle:@"选择机型" forState:(UIControlStateNormal)];
    [_butType setTitleColor:color_gray2 forState:(UIControlStateNormal)];
    _butType.titleLabel.font = FONT(14.f);
    [_butType setImage:[[UIImage imageNamed:@"OnlyEditToEditType"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    _butType.tag = 201;
    [_butType addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    //  选择日期
    _datePickerView = [[DIYSystemDatePickerView alloc]initWithType:DIYSystemDatePickerENUMOnly
                                                                        getSelectBeginTime:^(NSString *beginTimeStr) {
                                                                            
                                                                            [_butDate setTitle:[Utilities replaceNull:beginTimeStr] forState:(UIControlStateNormal)];
                                                                            
                                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeaderDate:)]) {
                                                                                [self.delegate selectHeaderDate:beginTimeStr];
                                                                            }
                                                                            
                                                                        }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_datePickerView];
    
    
    
    
    
}

-(void)buttonAction:(UIButton *)button
{
    
    if (_curTableView) {
        [_curTableView endEditing:YES];
    }
    
    
    if (button.tag == 200) {
        NSLog(@"选择日期");
        
        [_datePickerView showBeginTimePicker];
    }
    
    if (button.tag == 201) {
        NSLog(@"选择机型");
        
        if ([[Utilities replaceArrNull:_dataArr] count] > 0) {
            //  选择航班
            OnlyEditToEditTableHeaderAlertView *alertView = [[OnlyEditToEditTableHeaderAlertView alloc] init];
            
            alertView.dataArr = _dataArr;
            
            OnlyEditPerSQLModel *curModel = [OnlyEditPerSQLModel new];
            curModel.airplaneType = _butType.titleLabel.text;
            alertView.curentModel = curModel;
            [alertView reloadData];
            
            [alertView selectSelectairplaneType:^(OnlyEditPerSQLModel * _Nonnull model) {
                [_butType setTitle:[Utilities replaceNull:model.airplaneType] forState:(UIControlStateNormal)];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeaderType:InfoId:)]) {
                    [self.delegate selectHeaderType:[Utilities replaceNull:model.airplaneType] InfoId:[Utilities replaceNull:model.InfoID]];
                }
            }];
            
        } else {
            [Utilities showTextHud:@"请检查网络" descView:nil];
        }
        
    }
}


-(void)reloadData
{
    if (![[Utilities replaceNull:_selectDateStr] isEqualToString:@""]) {
        [_butDate setTitle:[Utilities replaceNull:_selectDateStr] forState:(UIControlStateNormal)];
    } else {
        [_butDate setTitle:@"选择日期" forState:(UIControlStateNormal)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeaderDate:)]) {
            [self.delegate selectHeaderDate:currentDateStr];
        }
        
        [_butDate setTitle:currentDateStr forState:(UIControlStateNormal)];
        
    }
    
    if (![[Utilities replaceNull:_selectAirPlaneType] isEqualToString:@""]) {
        [_butType setTitle:[Utilities replaceNull:_selectAirPlaneType] forState:(UIControlStateNormal)];
    } else {
        [_butType setTitle:@"选择机型" forState:(UIControlStateNormal)];
    }
}

+(CGFloat)haederHeight
{
    return Height_haederHeight;
}



@end


@implementation OnlyEditToEditTableHeaderButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width - 18 - (contentRect.size.height/2), (contentRect.size.height-18)/2, 18, 18);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.height/2, 0, contentRect.size.width - 100, contentRect.size.height);
}

@end


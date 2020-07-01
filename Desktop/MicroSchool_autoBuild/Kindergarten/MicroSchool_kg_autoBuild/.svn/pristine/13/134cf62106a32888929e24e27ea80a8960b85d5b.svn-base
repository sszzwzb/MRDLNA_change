//
//  CCPPickerView.m
//  CCPPickerView
//
//  Created by Kate on 16/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "TSPickerView.h"
#import "Utilities.h"
//#import "UIView+MTExtension.h"
//#import "UIAlertView+XDExtension.h"

#define CCPWIDTH [UIScreen mainScreen].bounds.size.width
#define CCPHEIGHT [UIScreen mainScreen].bounds.size.height

@interface TSPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

//toolBar
@property (nonatomic,strong)UIToolbar *toolBarOne;
//组合view
@property (nonatomic,strong) UIView *containerView;
//贷款额度 拼接字符串
@property (copy,nonatomic) NSString *string3;
@property (copy,nonatomic) NSString *string4;
@property (copy,nonatomic) NSString *string5;
@property (copy,nonatomic) NSString *string6;

@property (assign,nonatomic)NSInteger index3;
@property (assign,nonatomic)NSInteger index4;
@property (assign,nonatomic)NSInteger index5;
@property (assign,nonatomic)NSInteger index6;

//左侧两列
@property (strong, nonatomic) NSMutableArray *numberArray;
//@property (strong, nonatomic) NSMutableArray *numberArray1;
//右侧两列
@property (strong, nonatomic) NSMutableArray *numberArray2;
//@property (strong, nonatomic) NSMutableArray *numberArray3;


@property (copy,nonatomic)NSString *titleString;
@property (copy,nonatomic)NSString *leftString;
@property (copy,nonatomic)NSString *rightString;

@end

@implementation TSPickerView

//懒加载控件
- (UIPickerView *)pickerViewLoanMoney {
    
    if (_pickerViewLoanMoney == nil) {
        _pickerViewLoanMoney = [[UIPickerView alloc] init];
        _pickerViewLoanMoney.backgroundColor=[UIColor whiteColor];
        _pickerViewLoanMoney.delegate = self;
        _pickerViewLoanMoney.dataSource = self;
        _pickerViewLoanMoney.frame = CGRectMake(0.0, 40, CCPWIDTH, 216);
    }
    
    return _pickerViewLoanMoney;
}

- (UIToolbar *)toolBarOne {
    
    if (_toolBarOne == nil) {
        
        _toolBarOne = [self setToolbarStyle:self.titleString andCancel:self.leftString andSure:self.rightString];
        }
    
    return _toolBarOne;
}


- (UIView *)containerView {
    
    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CCPHEIGHT - 256, CCPWIDTH, 256)];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        [_containerView addSubview:self.toolBarOne];
        [_containerView addSubview:self.pickerViewLoanMoney];
        
    }
    return _containerView;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (NSMutableArray *)numberArray2 {
    
    if (_numberArray2 == nil) {
        //_numberArray2 = [NSMutableArray arrayWithObjects:@"万",@"十万",@"百万" ,nil];
        _numberArray2 = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            NSString *motnthDate = [NSString stringWithFormat:@"%02d",i];
            [_numberArray2 addObject:motnthDate];
        }
    }
    
    return _numberArray2;
}


- (NSMutableArray *)numberArray {
    
    if (_numberArray == nil) {
        _numberArray = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            NSString *motnthDate = [NSString stringWithFormat:@"%02d",i];
            [_numberArray addObject:motnthDate];
        }
    }
    return _numberArray;
}

-  (UIToolbar *)setToolbarStyle:(NSString *)titleString andCancel:(NSString *)cancelString andSure:(NSString *)sureString{
    
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, CCPWIDTH, 40);
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CCPWIDTH , 40)];
    lable.backgroundColor = [UIColor clearColor]
;
    lable.text = titleString;
    lable.textAlignment = 1;
    lable.textColor = [UIColor whiteColor];
    lable.numberOfLines = 1;
    lable.font = [UIFont systemFontOfSize:18];
    [toolbar addSubview:lable];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.frame = CGRectMake(0, 5, 60, 35);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.cornerRadius = 2;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitleColor:[UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1]
 forState:UIControlStateNormal];
    [cancelBtn setTitle:cancelString forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.backgroundColor = [UIColor clearColor];
    chooseBtn.frame = CGRectMake(0, 5, 60, 35);
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseBtn.layer.cornerRadius = 2;
    chooseBtn.layer.masksToBounds = YES;
    [chooseBtn setTitleColor:[UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1] forState:UIControlStateNormal];
    [chooseBtn setTitle:sureString forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(doneItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    centerSpace.width = 70;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    
    toolbar.items=@[leftItem,centerSpace,rightItem];
    toolbar.backgroundColor = [UIColor whiteColor];

    return toolbar;
}

//点击取消按钮
- (void)remove:(UIButton *) btn {
    
    [self dissMissView];
    
    if (self.clickCancelBtn) {
        
        self.clickCancelBtn();
        
    }
    
}

//点击确定按钮
- (void)doneItemClick:(UIButton *) btn {
    
    /*NSString *leftString = nil;
    NSString *rightString = nil;
    NSString *leftAndRightString = nil;
    
        //贷款范围
        int intStr3 = [self.string3 intValue];
        int intStr4 = 0;
        
        int intStrBefore = 0;
        
        if ([self.string4 isEqualToString:@"万"]) {
            
            intStr4 = 10000;
            
        } else if ([self.string4 isEqualToString:@"十万"]) {
            
            intStr4 = 100000;
        } else {
            
            intStr4 = 1000000;
        }
        
        intStrBefore = intStr3 * intStr4;
        
        int intStr5 = [self.string5 intValue];
        int intStr6 = 0;
        
        int intStrLater = 0;
        
        if ([self.string6 isEqualToString:@"万"]) {
            
            intStr6 = 10000;
            
        } else if ([self.string6 isEqualToString:@"十万"]) {
            
            intStr6 = 100000;
        } else {
            
            intStr6 = 1000000;
        }
        
        intStrLater = intStr5 * intStr6;
        
        
        if (intStrBefore > intStrLater) {
            
            //[UIAlertView alert3:@"请选择正确的区间"];
            
        } else if (intStrBefore == intStrLater) {
            
            leftAndRightString = [NSString stringWithFormat:@"%@%@",self.string3,self.string4] ;
     
            int maxMoney = intStr3 * (intStr4 / 10000);
            leftString = rightString = [NSString stringWithFormat:@"%d",maxMoney];
            
        } else {
            
             leftAndRightString = [NSString stringWithFormat:@"%@%@~%@%@",self.string3,self.string4,self.string5,self.string6];
     
            int minMoney = intStr3 *(intStr4 / 10000);
            int maxMoney = intStr5 *(intStr6 / 10000);
            leftString = [NSString stringWithFormat:@"%d",minMoney];
            rightString = [NSString stringWithFormat:@"%d",maxMoney];
            
        }*/

    NSString *leftStr = [NSString stringWithFormat:@"%@%@",self.string3,self.string4];
    NSString *rightStr = [NSString stringWithFormat:@"%@%@",self.string5,self.string6];
    
    if ([leftStr integerValue] >= [rightStr integerValue]) {
    
        [Utilities showTextHud:@"结束时间必须大于开始时间" descView:self];
        return;
        
    }
    
        
    if (self.clickSureBtn) {
        
        self.clickSureBtn(self.string3,self.string4,self.string5,self.string6);
        
    }
    
    [self dissMissView];
}

- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure rowArray:(NSMutableArray*)rowArray {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
       
        self.string3 = self.numberArray[[[rowArray objectAtIndex:0] integerValue]];
        self.string4 = self.numberArray2[[[rowArray objectAtIndex:1] integerValue]];
        self.string5 = self.numberArray[[[rowArray objectAtIndex:2] integerValue]];
        self.string6 = self.numberArray2[[[rowArray objectAtIndex:3] integerValue]];
        
        self.titleString = title;
        self.leftString = cancel;
        self.rightString = sure;
        [self addSubview:self.containerView];
        [_pickerViewLoanMoney selectRow:[[rowArray objectAtIndex:0] integerValue] inComponent:0 animated:NO];
        [_pickerViewLoanMoney selectRow:[[rowArray objectAtIndex:1] integerValue] inComponent:1 animated:NO];
        [_pickerViewLoanMoney selectRow:[[rowArray objectAtIndex:2] integerValue] inComponent:3 animated:NO];
        [_pickerViewLoanMoney selectRow:[[rowArray objectAtIndex:3] integerValue] inComponent:4 animated:NO];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [currentWindows addSubview:self];
    }
    
    return self;
}

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock {
    
    self.clickCancelBtn = cancelBlock;
    
    self.clickSureBtn = sureBlock;
    
}



- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure andClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                                      sureBtClcik:(clickSureBtn)sureBlock {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.string3 = @"0";
        self.string4 = @"万";
        self.string5 = @"0";
        self.string6 = @"万";
        self.titleString = title;
        self.leftString = cancel;
        self.rightString = sure;
        [self addSubview:self.containerView];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [currentWindows addSubview:self];
        
        self.clickCancelBtn = cancelBlock;
        
        self.clickSureBtn = sureBlock;
        
    }
    
    return self;
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMissView];
}

- (void)dissMissView{
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.containerView.frame = CGRectMake(0, CCPHEIGHT, CCPWIDTH, 256);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}





#pragma pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.numberArray.count;
        
    } else if (component == 1) {
        
        return self.numberArray2.count;
        
    } else if (component == 2){
        
        return 1;
        
    } else if (component == 3) {
        
        return self.numberArray.count;
        
    } else {
        
        return self.numberArray2.count;
        
    }
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            
            return  self.numberArray[row];
            
            break;
            
        case 1:
            
            return  self.numberArray2[row];
            
            break;
        case 2:
            
            return  @"至";
            
            break;
            
        case 3:
            
            return  self.numberArray[row];
            
            break;
            
        case 4:
            
            return  self.numberArray2[row];
            
            break;
            
        default:
            return nil;
    }
    
}


// 选中某一组中的某一行时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    /*if (component == 0 || component == 3) {
        
        NSString *selStrNum = self.numberArray[row];
        
        switch (component) {
            case 0:
                self.string3 = selStrNum;
                
                self.index3 = [self.numberArray indexOfObject:selStrNum];
                
                if (self.index3 < self.index5 || self.index4 < self.index6) {
                    
                } else {
                    
                    [self.pickerViewLoanMoney selectRow:row inComponent:3 animated:YES];
                    self.string5 = self.string3;
                    self.index5 = self.index3;
                }
                
                break;
                
            case 3:
                
                self.string5 = selStrNum;
                
                self.index5 = [self.numberArray indexOfObject:selStrNum];
                if (self.index5 < self.index3 && self.index4 >= self.index6) {
                    
                    [self.pickerViewLoanMoney selectRow:self.index3 inComponent:3 animated:YES];
                    
                    self.string5 = self.numberArray[self.index3];
                    
                    self.index5 = self.index3;
                    
                } else {
                    
                    self.string5 = self.numberArray[self.index5];
                    
                }
                
                break;
            default:
                break;
        }
        
    } else {
        
        NSString *selStrNum2 = self.numberArray2[row];
        
        switch (component) {
            case 1:
                self.string4 = selStrNum2;
                self.index4 = [self.numberArray2 indexOfObject:selStrNum2];
                
                if (self.index4 < self.index6) {
                    
                } else {
                    
                    [self.pickerViewLoanMoney selectRow:row inComponent:4 animated:YES];
                    self.index6 = self.index4;
                    self.string6 = self.string4;
                }
                
                break;
            case 4:
                self.string6 = selStrNum2;
                self.index6 = [self.numberArray2 indexOfObject:selStrNum2];
                if (self.index6 < self.index4) {
                    
                    [self.pickerViewLoanMoney selectRow:self.index4 inComponent:4 animated:YES];
                    
                    self.string6 = self.numberArray2[self.index4];
                    
                    self.index6 = self.index4;
                    
                } else {
                    
                    self.string6 = self.numberArray2[self.index6];
                    
                }
                
                break;
            default:
                break;
        }
        
    }*/
    
    if (component == 0){
        
        self.string3 = self.numberArray[row];
        
    }else if (component == 3){
        
         self.string5 = self.numberArray[row];
        
    }else if (component == 1){
        
         self.string4 = self.numberArray2[row];
        
    }else if(component == 4){
        
         self.string6 = self.numberArray2[row];
    }
    
    NSLog(@"%@----%@-----%@----%@",self.string3,self.string4,self.string5,self.string6);
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        if (component == 0 || component == 1) {
            [pickerLabel setTextAlignment:NSTextAlignmentRight];

        }else if (component == 3 || component == 4){
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];

        }else{
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
  
        }
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end

//
//  CCPPickerView.h
//  CCPPickerView
//
//  Created by Kate on 16/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCancelBtn)();

typedef void(^clickSureBtn)(NSString *leftString,NSString *leftString2,NSString *rightString,NSString *rightString2);

@interface TSPickerView : UIView

//选择器
@property (nonatomic,strong)UIPickerView *pickerViewLoanMoney;
@property (copy,nonatomic) void(^clickCancelBtn)();
@property (copy,nonatomic) void (^clickSureBtn)(NSString *leftString,NSString *leftString2,NSString *rightString,NSString *rightString2);

- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure rowArray:(NSMutableArray*)rowArray;

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock;


@end

//
//  TSAlertView.h
//  MicroSchool
//
//  Created by CheungStephen on 15/12/1.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ClickAction)();

typedef enum{
    ALERT_CancelAndConfirm          = 0,     // 两个btn的确认框，取消在左面并且加粗，默认即为该种模式
    ALERT_Confirm                   = 1,     // 一个btn的确认框
} AlertType;

@interface TSAlertView : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

/**
 * @param title    标题
 * @param message  提示内容
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setTitle:(NSString *)title message:(NSString *)message;

/**
 * @brief 添加按钮及事件，多个按钮便多次调用，按钮按照添加顺序显示
 */
- (void)addBtnTitle:(NSString *)title action:(ClickAction)action;

/**
 * @brief 显示提示框
 */
- (void)showAlertWithSender:(UIViewController *)sender;

@property(nonatomic, assign) AlertType *alert;

@end

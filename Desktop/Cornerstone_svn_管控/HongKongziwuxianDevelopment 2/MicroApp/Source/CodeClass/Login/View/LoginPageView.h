//
//  LoginPageView.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginPageViewDelegate <NSObject>

-(void) slectButDetermineWithName:(NSString *)name pwd:(NSString *)pwd;

@end

@interface LoginPageView : UIView

@property (nonatomic,strong) id <LoginPageViewDelegate> delegate;

@end


@interface LoginPageTextField : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imgName secureTextEntry:(BOOL)secureTextEntry TextFieldDelegate:(id<UITextFieldDelegate>)TextFieldDelegate;

@property (nonatomic,strong) UITextField *textField;

@end

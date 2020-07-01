//
//  LoginPageView.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "LoginPageView.h"


@interface LoginPageView () <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *logoImgV;

@end

@implementation LoginPageView

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
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"loginBackImg"];
    [imgBG setContentMode:UIViewContentModeScaleAspectFill];
    imgBG.clipsToBounds = YES;
    
    imgBG.userInteractionEnabled = YES;
    
    //  点击手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [imgBG addGestureRecognizer:singleTap];
    
    //   滑动手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];  //  上滑手势
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];  //  笑话手势
    [imgBG addGestureRecognizer:recognizer];
    
    
    
    
    _logoImgV = [[UIImageView alloc]initWithFrame:
                 CGRectMake((KScreenWidth - 140)/2, KScreenNavigationBarHeight + 20, 140, 140)];
    [self addSubview:_logoImgV];
    _logoImgV.image = [UIImage imageNamed:@"login_logo"];
    
    
    
    
    LoginPageTextField *textName = [[LoginPageTextField alloc]initWithFrame:
                                    CGRectMake(0, KScreenHeight/2 - 20, KScreenWidth, 60)
                                                                      title:@"账号"
                                                                    imgName:@"loginName_normal"
                                                            secureTextEntry:NO
                                                          TextFieldDelegate:self];
    textName.tag = 200;
    [self addSubview:textName];
    
    
    LoginPageTextField *textPWD = [[LoginPageTextField alloc]initWithFrame:
                                   CGRectMake(0, CGRectGetMaxY(textName.frame) + 40, KScreenWidth, 60)
                                                                     title:@"密码"
                                                                   imgName:@"loginPassword_normal"
                                                           secureTextEntry:YES
                                                         TextFieldDelegate:self];
    textPWD.tag = 201;
    [self addSubview:textPWD];
    
    
    
    
    UIButton *butDetermine = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:butDetermine];
    butDetermine.frame = CGRectMake(20, KScreenHeight - KScreenTabBarIndicatorHeight - 100, KScreenWidth - 40, 45);
    butDetermine.backgroundColor = [UIColor whiteColor];
    butDetermine.layer.masksToBounds = YES;
    butDetermine.layer.cornerRadius = CGRectGetHeight(butDetermine.frame)/2;
    [butDetermine setTitle:@"登录" forState:(UIControlStateNormal)];
    [butDetermine setTitleColor:color_black forState:(UIControlStateNormal)];
    butDetermine.titleLabel.font = FONT(17.5f);
    butDetermine.tag = 300;
    [butDetermine addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

/**
 *  键盘弹出
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    /* 获取键盘的高度 */
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    
    [UIView animateWithDuration:0.5 animations:^ {
        
        self.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height/2);
        
    }];
}

/**
 *  键盘退出
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    /* 输入框下移 */
    [UIView animateWithDuration:0.5 animations:^ {
        
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        
    }];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self endEditing:YES];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    [self endEditing:YES];
}


-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 300) {
        
        LoginPageTextField *nameT = [self viewWithTag:200];
        NSString *nameStr = nameT.textField.text;
        
        LoginPageTextField *pwdT = [self viewWithTag:201];
        NSString *pwdStr = pwdT.textField.text;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(slectButDetermineWithName:pwd:)]) {
            [self.delegate slectButDetermineWithName:nameStr pwd:pwdStr];
            
            
            [self endEditing:YES];
        }
        
    }
}

@end



@interface LoginPageTextField ()

@end

@implementation LoginPageTextField

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imgName secureTextEntry:(BOOL)secureTextEntry TextFieldDelegate:(id<UITextFieldDelegate>)TextFieldDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upViewWithTitle:title imgName:imgName secureTextEntry:secureTextEntry TextFieldDelegate:TextFieldDelegate];
    }
    return self;
}

-(void)upViewWithTitle:(NSString *)title imgName:(NSString *)imgName secureTextEntry:(BOOL)secureTextEntry TextFieldDelegate:(id<UITextFieldDelegate>)TextFieldDelegate
{
    
    self.backgroundColor = [UIColor clearColor];
    
    //  账号
    UILabel *labTitel = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, 0, 50, 20)];
    [self addSubview:labTitel];
    labTitel.text = title;
    labTitel.textColor = [UIColor whiteColor];
    labTitel.font = FONT(11.f);
    
    
    //  图片
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:
                         CGRectMake(20, CGRectGetMaxY(labTitel.frame) + 10, 20, 20)];
    [self addSubview:imgV];
    imgV.image = [UIImage imageNamed:imgName];
    
    
    //
    _textField = [[UITextField alloc]initWithFrame:
                          CGRectMake(50, 20, CGRectGetWidth(self.frame) - 40 - 30, 40)];
    [self addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.placeholder = [@"请输入" stringByAppendingString:title];
    _textField.textColor = [UIColor whiteColor];
    _textField.font = FONT(15.f);
    [_textField setValue:rgba(255, 255, 255, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:FONT(15.f) forKeyPath:@"_placeholderLabel.font"];
    _textField.secureTextEntry = secureTextEntry;
    _textField.delegate = TextFieldDelegate;
    
    
    //  白线
    UIView *viewX = [[UIView alloc]initWithFrame:
                     CGRectMake(20, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 40, 1)];
    [self addSubview:viewX];
    viewX.backgroundColor = [UIColor whiteColor];
    
    
}

@end

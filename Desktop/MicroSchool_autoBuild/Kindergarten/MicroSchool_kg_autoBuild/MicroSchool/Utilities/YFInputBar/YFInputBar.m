//
//  YFInputBar.m
//  test
//
//  Created by 杨峰 on 13-11-10.
//  Copyright (c) 2013年 杨峰. All rights reserved.
//

#import "YFInputBar.h"
#import "MicroSchoolAppDelegate.h"
@implementation YFInputBar


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        self.frame = CGRectMake(0, CGRectGetMinY(frame), WIDTH, CGRectGetHeight(frame));
        
        self.textField.tag = 10000;
        self.sendBtn.tag = 10001;
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"reply", @"type",
                             @"", @"pid",
                             nil];

        replyDic = dic;

        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _originalFrame = frame;
}
//_originalFrame的set方法  因为会调用setFrame  所以就不在此做赋值；
-(void)setOriginalFrame:(CGRect)originalFrame
{
    self.frame = CGRectMake(0, CGRectGetMinY(originalFrame), WIDTH, CGRectGetHeight(originalFrame));
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark get方法实例化输入框／btn
-(UITextView *)textField
{
    if (!_textField) {
        _textField = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 250, 24)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.clipsToBounds = NO;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType=UIKeyboardTypeDefault;
//        _textField.scrollEnabled = NO;

        _textField.contentInset = UIEdgeInsetsMake(-4,8,0,0);
        _textField.textAlignment = NSTextAlignmentLeft;
        
//        _textField.textContainer.lineFragmentPadding = 0;
//        _textField.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_textField.layer setCornerRadius:10];
        _textField.font = [UIFont fontWithName:@"Arial" size:16.0f];
//        _textField.text = @"内容";
        _textField.delegate = self;

        [self addSubview:_textField];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    }
    return _textField;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
    CGRect line = [textView caretRectForPosition:
                   
                   textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height
    
    - ( textView.contentOffset.y + textView.bounds.size.height
       
       - textView.contentInset.bottom - textView.contentInset.top );
    
    if ( overflow > 0 ) {
        
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        
        // Scroll caret to visible area
        
        CGPoint offset = textView.contentOffset;
        
        offset.y += overflow + 7; // leave 7 pixels margin
        
        // Cannot animate with setContentOffset:animated: or caret will not appear
        
        [UIView animateWithDuration:.2 animations:^{
            
            [textView setContentOffset:offset];
            
        }];
        
    }
    
}

-(UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发表" forState:UIControlStateNormal];
//        [_sendBtn setBackgroundColor:[UIColor whiteColor]];
        [_sendBtn setFrame:CGRectMake(270, 10, 40, 24)];
        [_sendBtn addTarget:self action:@selector(sendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}
#pragma mark selfDelegate method

-(void)sendBtnPress:(UIButton*)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inputBar:sendBtnPress:withInputString:withDic:)]) {
        [self.delegate inputBar:self sendBtnPress:sender withInputString:self.textField.text withDic:replyDic];
    }
    if (self.clearInputWhenSend) {
        self.textField.text = @"";
    }
    if (self.resignFirstResponderWhenSend) {
        [self resignFirstResponder];
    }
}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f-%f-%f-%f",_keyboardRect.origin.y,_keyboardRect.size.height,[self getHeighOfWindow]-CGRectGetMaxY(self.frame),CGRectGetMinY(self.frame));
    
    //如果self在键盘之下 才做偏移
    if ([self convertYToWindow:CGRectGetMaxY(self.originalFrame)]>=_keyboardRect.origin.y)
    {
        //没有偏移 就说明键盘没出来，使用动画
        if (self.frame.origin.y== self.originalFrame.origin.y) {

            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.transform = CGAffineTransformMakeTranslation(0, -_keyboardRect.size.height+[self getHeighOfWindow]-CGRectGetMaxY(self.originalFrame));
                             } completion:nil];
        }
        else
        {
            self.transform = CGAffineTransformMakeTranslation(0, -_keyboardRect.size.height+[self getHeighOfWindow]-CGRectGetMaxY(self.originalFrame));
        }
    }
    else
    {
        
    }
    
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    //_textField.text = @"回复";

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, 0);
                     } completion:nil];
}
#pragma  mark ConvertPoint
//将坐标点y 在window和superview转化  方便和键盘的坐标比对
-(float)convertYFromWindow:(float)Y
{
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [appDelegate.window convertPoint:CGPointMake(0, Y) toView:self.superview];
    return o.y;
    
}
-(float)convertYToWindow:(float)Y
{
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [self.superview convertPoint:CGPointMake(0, Y) toView:appDelegate.window];
    return o.y;
    
}
-(float)getHeighOfWindow
{
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.window.frame.size.height -44-20;
}



-(BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

-(void)popKeyboard
{
    [_textField becomeFirstResponder];
}

-(void)setTextViewText:(NSString*) text
{
    _textField.text = text;
}

-(void)setReplyDic:(NSDictionary*) dic
{
    replyDic = dic;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder]; return NO;
    }
    return YES;
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//	//size of content, so we can set the frame of self
//	NSInteger newSizeH = _textField.contentSize.height;
//    
//    CGRect rect = _textField.frame;
//    
//    rect.size.height = newSizeH;
//
//    [_textField setFrame:rect];
//}

//+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
//    float fPadding = 16.0; // 8.0px x 2
//    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
//    
//    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    
//    float fHeight = size.height + 16.0;
//    
//    return fHeight;
//}
@end

//
//  AnswerQuestionViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "FRNetPoolUtils.h"
#import "Utilities.h"

@interface AnswerQuestionViewController ()

@end

@implementation AnswerQuestionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"责任督学"];
    
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width , [UIScreen mainScreen].applicationFrame.size.height - 64)];
    scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 54);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(2+18, 10, 40.0, 22.0);
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = @"问:";
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(label.frame.origin.x+label.frame.size.width, 10, 160.0, 22.0);
    dateLabel.font = [UIFont systemFontOfSize:14.0];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.text = _date;
    
    QTextView = [[UITextView alloc]init];
    QTextView.font = [UIFont systemFontOfSize:15.0];
    QTextView.backgroundColor = [UIColor clearColor];
    QTextView.editable = NO;
    QTextView.scrollEnabled = NO;
    QTextView.text = _qustionText;
    CGSize strSize = [Utilities getStringHeight:_qustionText andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - label.frame.origin.x - label.frame.size.width - 10, 0)];
   
    float height = strSize.height;
        
        if (height < 35) {
            height = 35;
        }
        
    // 重新设置frame
    QTextView.frame = CGRectMake(label.frame.origin.x+label.frame.size.width - 7,
                                      dateLabel.frame.origin.y+dateLabel.frame.size.height,
                                      [UIScreen mainScreen].bounds.size.width - label.frame.origin.x - label.frame.size.width - 10,
                                      height+16);
    
    scrollerView.contentSize = CGSizeMake(QTextView.frame.size.width, QTextView.frame.size.height+label.frame.size.height + dateLabel.frame.size.height + 10 + 5);

    // 督学人下面的线
    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(20,QTextView.frame.origin.y+QTextView.frame.size.height - 1,280,1)];
    [imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [imgView_line setTag:999];
    imgView_line.hidden = NO;
    [scrollerView addSubview:imgView_line];
    
//    [self.view addSubview:label];
//    [self.view addSubview:dateLabel];
//    [self.view addSubview:QTextView];
    
    [scrollerView addSubview:label];
    [scrollerView addSubview:dateLabel];
    [scrollerView addSubview:QTextView];
    
    [self.view addSubview:scrollerView];
    
    // 自定义输入框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(5.0, 5.0, [UIScreen mainScreen].applicationFrame.size.width - 10 - 33 -10 - 10, 33)];
    textView.delegate = self;
    [textView.layer setCornerRadius:6];
    [textView.layer setMasksToBounds:YES];
    textView.returnKeyType = UIReturnKeyDefault;
    textView.font = [UIFont systemFontOfSize:15];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 33 -10-7, 5.0, 43.0, 33.0);
    sendButton.tag = 124;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTitle:@"回答" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_common_2-p.png"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:sendButton];
    [toolBar addSubview:textView];
    [self.view addSubview:toolBar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


// 发送
-(void)sendMsg:(id)sender{
    
    if ([textView.text length] == 0) {
        
        [Utilities showAlert:@"提示" message:@"请输入回答内容" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    
    }else{
        
        [ReportObject event:ID_ANSWER_EDU];//2015.06.24
        
        [Utilities showProcessingHud:self.view];// 2015.05.12
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 督学回答提问接口
            NSString *msg = [FRNetPoolUtils answerQ:_rid message:textView.text aid:_aid];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities dismissProcessingHud:self.view];// 2015.05.12
                
                if (msg!=nil) {
                    
                    [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    

                }else{
                    
                    
                    textView.text = @"";
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if (nil != _msgCenterMid) {
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             _msgCenterMid, @"mid",
                                             @"inspector_question", @"msg",
                                             nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
                    }
                }
                
            });
        });
        
        [textView resignFirstResponder];
    }
    
}

// 返回
-(void)selectLeftAction:(id)sender{

    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)_textView {

    CGSize size = textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location >= 2000) {// 责任督学 回帖 2000 2015.07.21
        return NO;
    }
    
    return YES;
}

// 键盘监听
- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         
                         CGRect frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];

}

- (void)keyboardWillHide:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----add by kate--------------------------------------------------
/*-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, 320, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolBar.hidden = YES;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
  
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    [toolBar addSubview:entryImageView];
    [toolBar addSubview:textView];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    clickFlag = 0;
    
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(284.0 - 9, 5.0, 40.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    
    [self.view addSubview:toolBar];
}*/

@end

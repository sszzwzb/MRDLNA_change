//
//  AnswerQuestionViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FaceBoard.h"

@interface AnswerQuestionViewController : BaseViewController<UITextViewDelegate,FaceBoardDelegate>{
    
    UITextView *QTextView;// 问题内容
    UILabel *titleLabel;// 问字
    
    // 自定义输入框
    UIView *toolBar;
    UITextView *textView;
    CGFloat keyboardHeight;
    
    UIButton *sendButton;
    
    MBProgressHUD *HUD;
    
    UIScrollView* scrollerView;
    
    /*//2015.08.20
    UIImageView *entryImageView;
    FaceBoard *faceBoard;
    UIButton *keyboardButton;
    BOOL isFirstShowKeyboard;
    int clickFlag;
    BOOL *isClickImg;
    UIButton *AudioButton;*/

}

@property(nonatomic,strong)NSString *qustionText;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *rid;// 问题id
@property(nonatomic,strong)NSString *aid;// 提问者的userid

// 从消息中心来的mid
@property(nonatomic,strong)NSString *msgCenterMid;

@end

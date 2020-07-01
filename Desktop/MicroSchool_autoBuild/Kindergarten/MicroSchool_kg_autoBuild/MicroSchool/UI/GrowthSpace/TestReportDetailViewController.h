//
//  TestReportDetailViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/4.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SingleWebViewController.h"
#import "FaceBoard.h"
#import "MomentsDetailTableViewCell.h"

@interface TestReportDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MomentsCommentsCellDelegate,FaceBoardDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>{
    
    NSDictionary *dict;
    CGSize winSize;
    
    NSMutableArray *commentsArray;//评论数组
    NSMutableArray *commentHeightArr;//单条评论高度数组
    NSString *usertype;
    BOOL isCommentComment;// 是不是评论评论的评论
    NSString *likeCellNum;
    
    /******自定义输入框************************/
    UITextView *textView;
    FaceBoard *faceBoard;
    UIView *toolBar;
    UIButton *keyboardButton;
    BOOL isFirstShowKeyboard;
    BOOL isButtonClicked;
    BOOL isKeyboardShowing;
    BOOL isSystemBoardShow;
    CGFloat keyboardHeight;
    int clickFlag;
    UIButton *AudioButton;
    UIImageView *entryImageView;
    /************************************************/
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *BodyTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *AdviceTxv;
@property (strong, nonatomic) IBOutlet UIView *subjectView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *RankLabel;
@property (strong, nonatomic) IBOutlet UIView *adviceV;

@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *pid;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;
// 显示回复xxx的信息
@property (retain, nonatomic) NSString *replyTo;
@property (retain, nonatomic) UILabel *replyToLabel;
// 评论动态时的那条tid
@property (nonatomic,retain) NSString *commentTid;
@property (nonatomic, strong) NSString *deleteTid;
@property (nonatomic, strong) NSString *deletePid;
@property (nonatomic, strong) NSString *deletePidPos;
@property (nonatomic, strong) NSString *deleteCellNum;
@property (nonatomic, strong) NSString *nunmber;//用于评论
@property (nonatomic, strong) NSString *fromName;//是否是从消息列表来
@end

//
//  HomeworkDetailViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "HomeworkDetailHead.h"
#import "HomeworkDetailInfo.h"
#import "HomeworkStateListViewController.h"
#import "SubmitHWViewController.h"
#import "HomeworkDetailUploadViewController.h"
#import "HomeworkReadHistory.h"
#import "MomentsDetailTableViewCell.h"
#import "FriendProfileViewController.h"
#import "DiscussHistoryViewController.h"

#import "FullImageViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "FaceBoard.h"

@interface HomeworkDetailViewController : BaseViewController <HomeworkDetailHeadDelegate, HomeworkDetailInfoDelegate,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    
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

@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *tid;
// 从列表页面传来的index
@property (nonatomic, retain) NSString *homeworkListIndex;
// 是否从发布页面进入详情，如果是则返回pop两级。
@property (nonatomic, retain) NSString *submitToDetail;
// 学生，家长是否注册了学籍信息。
@property (nonatomic, retain) NSString *number;

// 用户类型
// teacher              老师查看作业
// sutudent             学生查看作业
// submitTeacher        老师从发布页到详情
@property (nonatomic, retain) NSString *viewType;
@property (retain, nonatomic) NSString *disTitle;

@property (nonatomic, retain) NSMutableDictionary *detailInfo;
@property (nonatomic, retain) NSMutableDictionary *questions;
@property (nonatomic, retain) NSMutableArray *questionsPicsArray;

@property (nonatomic, retain) NSMutableDictionary *answers;
@property (nonatomic, retain) NSMutableArray *answersPicsArray;

@property (nonatomic, retain) NSMutableDictionary *firstAnswers;
@property (nonatomic, retain) NSMutableArray *firstAnswersPicsArray;

@property (nonatomic, retain) NSMutableDictionary *secondAnswers;
@property (nonatomic, retain) NSMutableArray *secondAnswersPicsArray;

// 作业的评论
@property (nonatomic, retain) NSMutableArray *commentArray;
@property (nonatomic, retain) NSMutableDictionary *historyDic;

@property (nonatomic, retain) NSMutableDictionary *statistics;

// 蒙版页面
@property (nonatomic, retain) UIView *viewMasking;

// 背景scrollView
@property (nonatomic, retain) UIScrollView *scrollViewBg;
@property (nonatomic, retain) UIView *viewWhiteBg;

// 作业详情的头部信息
@property (nonatomic, retain) HomeworkDetailHead *headInfo;

// 作业内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkContent;

// 答案内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkAnswer;

// 学生第一次回答内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkFirstAnswer;

// 学生第二次回答内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkSecondAnswer;

// 底部三个button todo. 这个最好封装成view，后续弄一下。
@property (nonatomic, retain) UIView *viewLine;

// 未完成
@property (nonatomic, retain) UIButton *buttonNotDone;
// 未批改
@property (nonatomic, retain) UIButton *buttonNotComment;
// 已完成
@property (nonatomic, retain) UIButton *buttonDone;

// 上传作业照片
@property (nonatomic, retain) UIButton *buttonAnswerUpload;
// 上传批改之后的作业照片
@property (nonatomic, retain) UIButton *buttonSecondAnswerUpload;
// 全部答对
@property (nonatomic, retain) UIButton *buttonAllCorrect;


// 浏览痕迹相关
@property (nonatomic, retain) UIButton *btn_history;
@property (nonatomic, retain) UIImageView *imgView_historyBg;
@property (nonatomic, retain) UIImageView *imgView_headImg1;
@property (nonatomic, retain) UIImageView *imgView_headImg2;
@property (nonatomic, retain) UIImageView *imgView_headImg3;
@property (nonatomic, retain) UIImageView *imgView_headImg4;
@property (nonatomic, retain) UIImageView *imgView_headImg5;
@property (nonatomic, retain) UILabel *label_historyCount;

@property (nonatomic, retain) UITableView *tableView;

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

@property(nonatomic,strong) NSString *spaceForClass;//班级是否有学籍 add by kate 2016.03.07

@end

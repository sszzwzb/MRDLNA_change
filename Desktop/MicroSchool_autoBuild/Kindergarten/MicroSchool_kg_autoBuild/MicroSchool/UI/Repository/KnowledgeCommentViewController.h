//
//  KnowledgeCommentViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "KnowledgeCommentTableViewCell.h"
#import "KnowledgeCommentTopTableViewCell.h"
#import "FriendProfileViewController.h"
#import "KnowledgeDetailModel.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "UIImageView+WebCache.h"
#import "YFInputBar.h"

#import "OHAttributedLabel.h"//add by kate
#import "NSAttributedString+Attributes.h"//add by kate
#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"

@interface KnowledgeCommentViewController : BaseViewController<UIScrollViewDelegate, HttpReqCallbackDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate,UITextViewDelegate,FaceBoardDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UIScrollView* _scrollerView;
    UITableView* _tableView;

    UILabel *label_title;
    UILabel *label_message;
    UILabel *label_name;
    UILabel *label_time;
    UILabel *label_school;
    
    UIImageView *imgView_gender;
    UIImageView *imgView;
    
    UIButton *button_collect;
    UIWebView *webViewContent;
    UIWebView *webViewContentHiden;
    float webHight;
    
    UIImageView *imgView_line2;
    
    UIButton *button_thanks;
    UIButton *button_noHelp;
    UIButton *button_collection;
    UIButton *button_comment;
    
    UIImageView *imgView_line1;
    UIImageView *imgView_line_1;
    
    NSMutableDictionary *detailInfo;
    
   // YFInputBar *inputBar;
    NSString *sendText;
    
    NSInteger likeFlag;
    
    NSMutableArray* dataArray;
    
    // 上下刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;
    
    NSDictionary *threadDic;
    NSString *totalComment;
    
    // 是不是评论评论的评论
    BOOL isCommentComment;
    /******自定义输入框 add by kate************************/
    UITextView *textView;
    UIView *addImageView;
    UIButton *photoSelectButton;
    UIButton *photoDeleteButton;
    BOOL isSelectPhoto;
    NSString *imagePath;
    
    UIImageView *photoBgImageView;
    UIImageView *photoFlagImageView;//图片红点
    UIButton *button_photoMask0;//add by kate 2014.10.09
    
    NSMutableDictionary *imageArray;
    NSInteger pressButtonTag;
    
    NSInteger totalButtonImgNum;
    NSMutableArray *buttonArray;
    NSMutableArray *buttonFlagViewArray;
    
    FaceBoard *faceBoard;
    UIView *toolBar;
    UIButton *keyboardButton;
    BOOL isFirstShowKeyboard;
    BOOL isButtonClicked;
    BOOL isKeyboardShowing;
    BOOL isSystemBoardShow;
    CGFloat keyboardHeight;
    int clickFlag;
    BOOL *isClickImg;
    UIButton *AudioButton;
    /************************************************/

    NSMutableArray* cellHeightArray;// cell高度存储
    
    NSString *pid;//该条评论id
    
    UIImageView *entryImageView;

}

@property (retain, nonatomic) NSMutableDictionary *data;

// knowledge id
@property (retain, nonatomic) NSString *kid;

@property (retain, nonatomic) NSString *replyPid;


// 知识库详细过来的数据model
@property (nonatomic,retain) KnowledgeDetailModel *detail_model;

// 点击喜欢或者不喜欢
@property (retain, nonatomic) NSString *goodOrBadClicked;

@property (nonatomic, retain) NSDictionary *emojiDic;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;

@end

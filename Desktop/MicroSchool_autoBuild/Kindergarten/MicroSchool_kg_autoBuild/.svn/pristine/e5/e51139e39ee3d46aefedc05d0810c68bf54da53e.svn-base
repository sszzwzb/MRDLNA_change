//
//  NewsCommentViewController.h
//  MicroSchool
//
//  Created by jojo on 15/6/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "FaceBoard.h"// add by kate
#import "OHAttributedLabel.h"//add by kate
#import "NSAttributedString+Attributes.h"//add by kate

#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"

#import "DiscussDetailCell.h"

@interface NewsCommentViewController2 : BaseViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, UITextViewDelegate,FaceBoardDelegate,UIGestureRecognizerDelegate>
{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    NSString *startNum;
    NSString *endNum;
    
    NSInteger reflashFlag;
    NSInteger isReflashViewType;
    
    /******自定义输入框 add by kate************************/
    UITextView *_inputTextView;
    
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
    
    //---add by kate--------------------
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    // 选项菜单3个button
    UIButton *button_search;
    UIButton *button_multiSend;
    UIButton *button_setAdmin;
    UIButton *button_addFriend;
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    NSDictionary *DB_Dic;// 2015.05.15
    NSInteger page;// 2015.05.15
    //----------------------------------
    /************************************************/
    
    UIImageView *entryImageView;
    UIView *noDataView; //add 2015.09.01
    
}

// tableview
@property (retain, nonatomic) UITableView *tableView;

// 返回的数据arr
@property (retain, nonatomic) NSMutableArray *commentDataArr;

// 提前计算好的高度
@property (retain, nonatomic) NSMutableArray* cellHeightArray;

// newsId
@property (retain, nonatomic) NSString* newsId;

@property(nonatomic,retain)MarkupParser *textParser;
@property (nonatomic, retain) NSDictionary *emojiDic;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;

// 显示回复xxx的信息
@property (retain, nonatomic) NSString *replyTo;
@property (retain, nonatomic) UILabel *replyToLabel;

// 删除自己帖子的pid以及行数
@property (retain, nonatomic) NSString *myPostPid;
@property (retain, nonatomic) NSString *myPostCellNum;

// 回复别人帖子的cid
@property (retain, nonatomic) NSString *otherPid;

// 获取评论的学校的sid
@property (retain, nonatomic) NSString *cmtSid;

@end

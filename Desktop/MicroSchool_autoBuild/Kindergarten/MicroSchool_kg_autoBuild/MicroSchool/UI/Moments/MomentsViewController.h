//
//  MomentsViewController.h
//  MicroSchool
//
//  Created by jojo on 14/12/15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "MomentsTableViewCell.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"

#import "FriendProfileViewController.h"
#import "MomentsDetailViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "TSTouchImageView.h"
#import "SingleWebViewController.h"

#import "MomentsListObject.h"
#import "MomentsListDBDao.h"

#import "SightRecordViewController.h"

//#import "UITableViewCellContentView.h"


@interface MomentsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,FaceBoardDelegate,UIGestureRecognizerDelegate>
{
    
    // 数据
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayR;

    // tableviewHeader的信息
    NSMutableDictionary *headerDic;
    
    // 每一个cell的高度，显示table前set好
    NSMutableArray *cellHeightArray;
    NSMutableArray *cellHeightArrayR;

    // 每一个cell的message的高度
    NSMutableArray *cellMessageHeightArray;
    NSMutableArray *cellMessageHeightArrayR;

    // 记录赞btn的位置
    int likePosY;
    int yOffset;
    CGPoint offset;

    NSString *startNum;
    NSString *endNum; 

    NSString *startNumR;
    NSString *endNumR;

    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    EGORefreshTableHeaderView *_refreshHeaderViewR;
    EGORefreshTableFooterView *_refreshFooterViewR;

    BOOL _reloading;
    BOOL _reloadingR;

    NSInteger reflashFlag;

    NSString *likeCellNum;
    
    UIImageView *noticeImgVForMsg;//发现tab红点
    UIImageView *myNoticeImgVForMsg;//我的动态右上角红点
    
    // headerView包含内容
    UIView *headerView;
    UIImageView *imgView_headBg;
    UIButton *btn_thumb;
    UIImage *defaultImg;
    UILabel *label_name;
    UIImageView *_imgView_line;
    UIButton *btn_submitMoments;
    UIImageView *_imgView_submitMoments;

    UIView *headerViewR;
    UIImageView *imgView_headBgR;
    UIButton *btn_thumbR;
    UIImage *defaultImgR;
    UILabel *label_nameR;
    UIImageView *_imgView_lineR;
    UIButton *btn_submitMomentsR;
    UIImageView *_imgView_submitMomentsR;

    // 是不是评论评论的评论
    BOOL isCommentComment;

    // 为了显示大图暂时添加的imgView，后续需要优化
    UIImageView *imageView;

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
    
    NSDictionary *DB_Dic;// 2015.05.14
    NSInteger page;// 2015.05.14
    /************************************************/
    UIImageView *entryImageView;
    
    MarkupParser* textParser;
    OHAttributedLabel *currentLabel;
    
}

@property(nonatomic,retain) NSString *titleName;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *tableViewR;

@property (nonatomic, retain) NSDictionary *emojiDic;

// 发现：school
// 班级动态：class
// 我的动态：mine
// 其他人动态：other
@property (nonatomic, strong) NSString *fromName;

@property (nonatomic, strong) NSString *preView;

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *cName;//add by kate 2015.01.21
@property (nonatomic, strong) NSString *deleteTid;
@property (nonatomic, strong) NSString *deletePid;
@property (nonatomic, strong) NSString *deletePidPos;
@property (nonatomic, strong) NSString *deleteCellNum;

@property (nonatomic,strong) NSString *fuid;//从个人信息页来的uid

// 动态背景图片
@property (nonatomic,retain) UIImage *img_bgImg;
@property (nonatomic,retain) NSString *imagePath;

// 动态背景图片
@property (nonatomic,retain) TSTouchImageView *tsTouchImg_momentsBg;
@property (nonatomic,retain) TSTouchImageView *tsTouchImg_momentsBgR;

// 班级动态时，是否为班级管理员
@property (assign, nonatomic) BOOL isAdmin;

// 新消息提示btn
@property (nonatomic,retain) UIButton *btn_msg;
@property (nonatomic,retain) UIImageView *img_msg;

// 评论动态时的那条tid
@property (nonatomic,retain) NSString *commentTid;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;

// 显示回复xxx的信息
@property (retain, nonatomic) NSString *replyTo;
@property (retain, nonatomic) UILabel *replyToLabel;
@property (retain, nonatomic) NSString *mid;
@property(nonatomic,retain) NSDictionary *newsDic;//2015.11.12

@property (retain, nonatomic) NSString *userType;

@property (retain, nonatomic) UISegmentedControl *segmentControl;
@property (retain, nonatomic) NSString *lastMsgId;//动态消息id

// 是否可以添加到我的足迹判断条件
// 学校是否开通
@property (retain, nonatomic) NSString *growingPathStatusSchool;
// 成长空间开通状态
@property (retain, nonatomic) NSString *growingPathStatusSpace;
// 是否绑定了成长空间
@property (retain, nonatomic) NSString *growingPathStatusNumber;

@property (retain, nonatomic) NSMutableDictionary *growingPathStatusDic;

// 点我了解什么是成长空间的url
@property (retain, nonatomic) NSString *growingPathStatusUrl;//2016.01.06 add by kate
@property (nonatomic,strong) NSString *trial;
// 记录一下从班级进入的那个班级的cid。
@property (nonatomic, strong) NSString *classCid;
// 空白页
@property (nonatomic,strong) UIView *blankView;
@property (nonatomic,strong) UIView *blankViewR;

@end

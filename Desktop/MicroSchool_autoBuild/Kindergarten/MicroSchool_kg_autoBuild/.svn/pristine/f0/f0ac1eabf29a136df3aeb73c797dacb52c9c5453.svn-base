//
//  MomentsDetailViewController.h
//  MicroSchool
//
//  Created by jojo on 14/12/29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "UIButton+WebCache.h"

#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MomentsDetailTableViewCell.h"

//#import "OHAttributedLabel.h"
//#import "NSAttributedString+Attributes.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "FriendProfileViewController.h"
#import "LikerListViewController.h"// add by kate

#import "TSTouchLabel.h"
#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

#import "MomentsSharedLink.h"
#import "SingleWebViewController.h"

#import "TSAttributedLabel.h"

@interface MomentsDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, EGORefreshTableDelegate,UITextViewDelegate,FaceBoardDelegate,UIGestureRecognizerDelegate>
{
    // 数据
//    NSMutableArray *dataArray;
    
    // tableview的header
    UIView *headerView;
    
    NSMutableArray *commentsArr;
    
    UIButton *_btn_more;
    UIButton *_btn_thumb;
    TSTouchLabel *_label_username;
    UILabel *_label_dateline;
    
    float headerMsgHeight;
    // header中y的偏移量，用来记录从信息内容下面的坐标
    int yOffset;
    
    NSMutableDictionary *dataDic;
    
    // tableviewHeader的信息
    NSDictionary *headerDic;
    
    NSString *startNum;
    NSString *endNum;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    NSInteger reflashFlag;
    
    MarkupParser *_textParser;
    
    TSAttributedLabel *_ohAttributeLabel;
    
    // 每一个cell的高度，显示table前set好
    NSMutableArray *cellHeightArray;

    // 为了显示大图暂时添加的imgView，后续需要优化
    UIImageView *imageView;
    
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
    
    MarkupParser* textParser1;
    OHAttributedLabel *currentLabel;
}

@property(nonatomic,retain) NSString *tid;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSDictionary *emojiDic;

@property (nonatomic, strong) NSString *fromName;

// 9张图片
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img1;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img2;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img3;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img4;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img5;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img6;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img7;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img8;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img9;
@property (nonatomic, retain) NSMutableArray *ary_imgThumb;

// 赞btn
@property (nonatomic, retain) UIButton *btn_like;
@property (nonatomic, retain) UIImageView *btn_likeIcon;

// 评论btn
@property (nonatomic, retain) UIButton *btn_comment;
@property (nonatomic, retain) UIImageView *btn_commentIcon;

// 添加到我的足迹btn
@property (nonatomic, retain) UIButton *btn_addToPath;
@property (nonatomic, retain) UIImageView *btn_pathIcon;

// 喜欢的人
@property (nonatomic, retain) UIButton *btn_likeNum;
@property (nonatomic, retain) UIImageView *imgView_likeBg;
@property (nonatomic, retain) UIImageView *imgView_headImg1;
@property (nonatomic, retain) UIImageView *imgView_headImg2;
@property (nonatomic, retain) UIImageView *imgView_headImg3;
@property (nonatomic, retain) UIImageView *imgView_headImg4;
@property (nonatomic, retain) UIImageView *imgView_headImg5;
@property (nonatomic, retain) UILabel *label_likeCount;

// 需要删除的评论信息
@property (nonatomic, strong) NSString *deletePid;
@property (nonatomic, strong) NSString *deleteTid;
@property (nonatomic, strong) NSString *deletePidPos;
@property (nonatomic, strong) NSString *deleteCellNum;

// 删除label
@property (nonatomic, retain) TSTouchLabel *tsLabel_delete;

// 是否需要显示回复xxx的信息，显示后当用户输入时消失
@property (assign, nonatomic) BOOL isFirstClickReply;

// 分享链接
@property (nonatomic, retain) MomentsSharedLink *sharedLink;

@property (nonatomic, retain) TSAttributedLabel *ohAttributeLabel;

// 显示回复xxx的信息
@property (retain, nonatomic) NSString *replyTo;
@property (retain, nonatomic) UILabel *replyToLabel;
@property (retain, nonatomic) NSString *cid;
@property (retain, nonatomic) NSString *path;//足迹id

// 是否可以添加到我的足迹判断条件
//@property (retain, nonatomic) NSString *growingPathStatus;
@property (retain, nonatomic) NSString *growingPathStatusSchool;

// 成长空间开通状态
@property (retain, nonatomic) NSString *growingPathStatusSpace;
// 是否绑定了成长空间
@property (retain, nonatomic) NSString *growingPathStatusNumber;
// 班级是否有学籍
@property (retain, nonatomic) NSString *growingPathStatusClass;

// 点我了解什么是成长空间的url
@property (retain, nonatomic) NSString *growingPathStatusUrl;//2016.01.06 add by kate
@property (nonatomic,strong) NSString *trial;

@property (nonatomic, retain) UIView *bgGrayView;//灰色
@property (nonatomic, retain) UILabel *lovesStrLabel;//字
@property (nonatomic, retain) UIImageView *lovesStrImageView;//心

@end

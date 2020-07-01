//
//  PublishMomentsViewController.h
//  MicroSchool
//  发布个人动态
//  Created by Kate on 14-12-19.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FaceBoard.h"
#import "CTAssetsPickerController.h"
#import "JKPopMenuView.h"


@interface PublishMomentsViewController : BaseViewController<UITextFieldDelegate, HttpReqCallbackDelegate, UITextViewDelegate, UIAlertViewDelegate,FaceBoardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, JKPopMenuViewSelectDelegate,UIGestureRecognizerDelegate>{
    
    // 回复时图片相关 
    UIScrollView *_scrollerView;
    UITextView *text_content;
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

    UILabel *typeLabel;//谁可以看
    UIButton *whoCanViewBtn;
    UIView *seprateLine;
    
    NSString *cids;//班级们
    
    //---update 2015.04.13 新增拍照功能-----
    id sender_btn;//add 2015.04.10
    UIActionSheet *alertSheet;// add 2015.04.10
    UIImagePickerController *imagePickerController;//add 2015.04.10
    //CTAssetsPickerController *picker;
    int cameraNum;
    int photoNum;
    
    //UITextField *urlTextF;// add 2015.04.20
    
    UITextView *urlTextF;// add 2015.04.20
    
    UILabel *placeHoderLabel;
    
    UILabel *placeHoderUrlLabel;
    
    NSMutableArray *pics;
    
    UIView *whiteViewLeft;
    UIView *whiteViewRight;
    
    UIButton *selectBtn;//传照片页前边的check
    
    NSString *ac;//ac的动态参数
    
}

@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *cName;
@property(nonatomic,strong)NSString *fromName;// 班级动态列表/发现列表/相册列表
@property(nonatomic,assign)NSUInteger flag;// 1 2发链接/0发图片/3发小视频
@property(nonatomic,strong)NSString *shareUrl;// 被分享的链接 从校友圈链接查看的webview来
@property(nonatomic,strong)NSString *shareImgUrl;// 被分享的链接提取的图片 从校友圈链接查看的webview来
@property(nonatomic,strong)NSString *shareTitle;// 被分享的链接的title
@property(nonatomic,strong)UIImage *headImg;// 本地截屏缩略图

@property(nonatomic,strong)NSString *photoAlbumTitle;//从相册详情的添加照片来的title
@property(nonatomic,strong)NSString *photoAlbumID;//从相册详情的添加照片来的相册id
@property(nonatomic,assign)BOOL isFromAlbum;//是否是从相册详情的添加照片来

@property(nonnull,strong)NSString *videoPath;//小视频本地path
@property(nonnull,strong)NSString *thumbImgPath;//小视频缩略图本地path
@property(nonnull,strong)UIImage *thumbImg;//小视频缩略图本地img

// 标签数量以及种类
@property(nonatomic,retain)NSMutableArray *tagsArray;
@property(nonatomic,retain)NSString *tagId;

// 是否可以添加到我的足迹判断条件
// 学校是否开通
@property (retain, nonatomic) NSString *growingPathStatusSchool;
// 空间是否开通
@property (retain, nonatomic) NSString *growingPathStatusSpace;

// 是否绑定了成长空间
@property (retain, nonatomic) NSString *growingPathStatusNumber;

// 点我了解什么是成长空间的url
@property (retain, nonatomic) NSString *growingPathStatusUrl;//2016.01.06 add by kate

@property (nonatomic,strong) NSString *trial;

@end

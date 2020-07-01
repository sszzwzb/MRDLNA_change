//
//  HealthSubmitViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 15/12/1.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "TSImageSelectView.h"
#import "CTAssetsPickerController.h"
#import "FullImageViewController.h"

// 此view为了试验masonry适配所用，并没有按照模块进行画面构建，除了TSImageSelectView之外，完全是用约束。

@interface HealthSubmitViewController : BaseViewController<UITextViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate, HttpReqCallbackDelegate, UITextFieldDelegate>

// submitHealth 为添加记录
// editHealth 为编辑记录
@property (retain, nonatomic) NSString *viewType;
@property (retain, nonatomic) NSDictionary *editDic;

@property (retain, nonatomic) UIScrollView *scrollViewBg;
@property (retain, nonatomic) UIView *viewWhiteBg;
@property (retain, nonatomic) NSString *cid;
@property (retain, nonatomic) NSMutableDictionary *imageArray;

// 编辑模式中添加的本地图片
@property (retain, nonatomic) NSMutableArray *editImageArray;
@property (retain, nonatomic) NSMutableArray *editLoacalImageIdArray;

// 编辑模式中删除url图片的id
@property (retain, nonatomic) NSMutableArray *editDeleteImageIdArray;

// 身高
@property (retain, nonatomic) UILabel *labelHeight;
@property (retain, nonatomic) UITextField *textFieldHeight;
@property (retain, nonatomic) UILabel *labelCM;

// 体重
@property (retain, nonatomic) UILabel *labelWeight;
@property (retain, nonatomic) UITextField *textFieldWeight;
@property (retain, nonatomic) UILabel *labelKG;

// 视力
@property (retain, nonatomic) UILabel *labelSight;
@property (retain, nonatomic) UILabel *labelSightLeft;
@property (retain, nonatomic) UITextField *textFieldSightLeft;

@property (retain, nonatomic) UILabel *labelSightRight;
@property (retain, nonatomic) UITextField *textFieldSightRight;

// 寄语
@property (retain, nonatomic) UILabel *labelComment;
@property (retain, nonatomic) UITextView *textViewComment;
@property (retain, nonatomic) UILabel *textViewCommentPlaceholder;

// 图片选择
@property (retain, nonatomic) TSImageSelectView *imageSelectView;

@property (assign, nonatomic) CGFloat keyboardHeight;


@property (retain, nonatomic) UIActionSheet *alertSheet;
@property (retain, nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsAndImgs;

// 存放所有的已经选择的图片
@property (retain, nonatomic) NSMutableArray *selectedImages;
@property (assign, nonatomic) NSInteger selectedImageNumber;
@property (assign, nonatomic) NSInteger selectedImageNumber1;

@property (assign, nonatomic) bool isHaveDian;
@property (assign, nonatomic) bool isOutOfRange;

@end

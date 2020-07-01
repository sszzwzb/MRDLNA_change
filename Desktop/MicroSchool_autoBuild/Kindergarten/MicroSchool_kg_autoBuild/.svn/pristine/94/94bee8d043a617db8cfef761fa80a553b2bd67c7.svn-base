//
//  SetPersonalViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-12.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "MicroSchoolMainMenuViewController.h"

#import "NameViewController.h"
#import "IdentityViewController.h"
#import "GenderViewController.h"
#import "BirthdayViewController.h"
#import "SchoolYearViewController.h"
#import "ClassViewController.h"
#import "NumberViewController.h"
#import "IdNumberViewController.h"
#import "ReasonViewController.h"

#import "SetHeadImgViewController.h"
#import "SetRelationsViewController.h"
#import "ClassListViewController.h"

#import "MicroSchoolAppDelegate.h"
#import "MyInfoCenterViewController.h"
#import "MyClassListViewController.h"

@interface SetPersonalViewController : BaseViewController <HttpReqCallbackDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UITableView *tableViewIns;

    NSMutableDictionary *personalInfo;
    
    // 添加附件图片背景
    UIImageView *imgView_bg_photo;
    UIButton *button_photoMask;
    NSString *imagePath1;
    UIImage *photo;
    UILabel *label_photo;
    
    CGFloat keyboardHeight;
    
    UIButton *btn_changeProfile;//切换账号


}

@property (retain, nonatomic) NSString *iden;
@property (retain, nonatomic) NSString *type;

@property (retain, nonatomic) UIButton *button_next;

// tableview显示数据源
@property(nonatomic,strong) NSMutableArray *itemsArr;

@property(nonatomic,strong) NSArray *sectionNameAndSex;
@property(nonatomic,strong) NSArray *sectionClassAndNumber;
@property(nonatomic,strong) NSArray *sectionNumber;
@property(nonatomic,strong) NSArray *sectionClass;

@property(nonatomic,strong) NSArray *sectionParentNameAndSex;
@property(nonatomic,strong) NSArray *sectionParentNumber;
@property(nonatomic,strong) NSArray *sectionParentClassAndNumber;

@property(nonatomic,strong) NSDictionary *classInfoDic;

@property(nonatomic,strong) NSString *cId;

// 身份审核类型
// classApply 发起班级审核
@property(nonatomic,strong) NSString *viewType;

// 姓名输入textfield
@property(nonatomic,strong) UITextField *textField_name;

// @"身份证号"textfield
@property(nonatomic,strong) UITextField *textField_number;

// 照片选择框
@property(nonatomic,strong) UIImageView *imgView_photoSelect;

// 理由填写框
@property(nonatomic,strong) UIImageView *imgView_reason;

// 提示文案
@property(nonatomic,strong) UILabel *label_tips;

// 教师申请理由
@property(nonatomic,strong) UITextView *textView_content;

// 是否需要隐藏申请说明的placeholder
@property (assign, nonatomic) BOOL isFirstClickComment;

// 申请说明的placeholder
@property (retain, nonatomic) UILabel *label_comment;
@property (nonatomic,assign) NSInteger publish;

// 点我了解什么是成长空间的url
@property (retain, nonatomic) NSString *growingPathStatusUrl;//2016.01.06 add by kate
//判断如果从重新注册进入，就不显示切换账号
@property (retain,nonatomic) NSString * perNum;
@property(nonatomic,strong)NSDictionary *regNamePwd;
@end

//
//  SubmitHWViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AddImagesTool.h"

@interface SubmitHWViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,HttpReqCallbackDelegate>{
    
    
    // 背景scrollview
    UIScrollView *_scrollerView;
    
    UILabel *label_username;
    
    UILabel *label_timeTitle;// "分钟"
    
    // 标题
    UITextField *text_title;
    
    // 时间
    UITextField *text_time;
    
    // 内容
    UITextView *text_content;
    
    // 答案
    UITextView *text_answer;
    
    NSMutableArray *mutable_photoList;
    
    UIImage *newImage;
    
    AddImagesTool *imageToolForHomework;//作业内容
    
    AddImagesTool *imageToolForAnswer;//作业答案
    
    UIView *contentView;//作业内容
    UIView *answerView;//作业答案
    
    UIImageView *imgView_line3;
    NSString *_qngs;//删除作业内容图片id
    NSString *_angs;//删除答案图片id
    
    NSString *contentStr;
    
}

@property(nonatomic,assign)int flag;// 1.作业修改页 不传默然是发布页
@property(nonatomic,strong) NSString *modelName;
@property(nonatomic,strong) NSMutableDictionary *dic;//从详情页带过来的数据 标题 时间 内容 答案等
@property (nonatomic,strong) UITextView *text_content;
@property (nonatomic,strong) UITextView *text_answer;
@property(nonatomic,strong) UITextField *text_title;// 标题
@property(nonatomic,strong) UITextField *text_time;// 时间
@property (nonatomic,strong) NSMutableDictionary *imageArray;//本地作业内容图片数组
@property (nonatomic,strong) NSMutableDictionary *imageArray_answer;//本地作业答案图片数组
-(void)updateSize:(UIView*)view;
@property (retain, nonatomic) UIView *viewWhiteBg;
@property (nonatomic,strong)NSString *cid;
@property (nonatomic,strong)NSString *tid;
@property(nonatomic,strong)NSString *titleName;

// 蒙版页面
@property (nonatomic, retain) UIView *viewMasking;
@property(nonatomic,strong) NSString *spaceForClass;//班级是否有学籍 add by kate 2016.03.07
@end

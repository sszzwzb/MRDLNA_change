//
//  KnowledgePayItemViewController.h
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "KnowledgePayItemModel.h"
#import "KnowledgeOrderItemViewController.h"

#import "MBProgressHUD+Add.h"
#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

@interface KnowledgePayItemViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate>
{
    MBProgressHUD *progressHud;
    
    UIView *noDataView;
}

// 教师id
@property (nonatomic,retain) NSString *tid;

// 数据model
@property (nonatomic,retain) KnowledgePayItemModel *model;

// 背景scrollview
@property (nonatomic,retain) UIScrollView *scrollView;

// title
@property (nonatomic, retain) UILabel *label_title;

// description
@property (nonatomic, retain) UILabel *label_description;

@end

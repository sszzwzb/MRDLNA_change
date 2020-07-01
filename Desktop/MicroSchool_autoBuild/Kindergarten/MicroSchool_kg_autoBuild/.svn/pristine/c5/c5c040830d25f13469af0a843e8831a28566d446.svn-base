//
//  SetPersonalTeacherViewController.h
//  MicroSchool
//
//  Created by jojo on 14-1-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "ReasonViewController.h"
#import "IdNumberViewController.h"


@interface SetPersonalTeacherViewController : BaseViewController<HttpReqCallbackDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>
{
    UITableView *tableViewIns;
        
    UIButton *button_create;
    
    NSMutableDictionary *personalInfo;

    // 添加附件图片背景
    UIImageView *imgView_bg_photo;
    UIButton *button_photoMask;
    NSString *imagePath1;
    UIImage *photo;
    UILabel *label_photo;
    
    UIScrollView *_scrollerView;
}

@property (retain, nonatomic) NSString *reason;

@end

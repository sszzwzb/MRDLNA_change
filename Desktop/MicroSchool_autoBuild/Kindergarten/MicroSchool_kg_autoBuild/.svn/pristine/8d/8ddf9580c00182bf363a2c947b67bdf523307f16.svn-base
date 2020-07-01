//
//  InfoCenterForInspectorViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"

@interface InfoCenterForInspectorViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate,HttpReqCallbackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    MBProgressHUD *HUD;
    
    UITableView *_tableView;
    
    UIImageView *imgView_head;
    UIImage *image_head;
    UIImage *image_head_pre;
    
    NSString *imagePath;
    NSMutableDictionary *settingPersonalInfo;
    
    NSMutableDictionary *infoDic;// 网络返回的数据
}
@property (nonatomic, retain) NSString *insUid;

@end

//
//  SetPersonalInfoViewController.h
//  MicroSchool
//
//  Created by jojo on 13-12-29.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "UIImageView+WebCache.h"

#import "BaseViewController.h"

#import "SettingPhotoViewController.h"
#import "SettingNameViewController.h"
#import "SettingGenderViewController.h"
#import "SettingSpacenoteViewController.h"
#import "SettingBirthViewController.h"
#import "SettingHomeViewController.h"
#import "SettingResideViewController.h"
#import "SettingBloodViewController.h"

#import "SettingSchoolYearViewController.h"
#import "SettingClassViewController.h"
#import "SettingNumberViewController.h"

#import "SetPersonalInfoTableViewCell.h"

@interface SetPersonalInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *user;
    UIImageView *imgView_head;
    UIImage *image_head;
    UIImage *image_head_pre;
    
    NSString *imagePath;
    NSMutableDictionary *settingPersonalInfo;
    
    UIImageView *imgNewDuty;
    UIImageView *imgNewSubject;
    
    
}
@property(nonatomic,strong)NSString *fromName;//用于判断从哪个页面来 好判断回到哪个页面
@end

//
//  SettingNameViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingNameViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HttpReqCallbackDelegate>
{
    UITableView *_tableView;
    UITextField *text_title;
    
}
@property(nonatomic,retain)NSString *fromName;//从设置真实姓名来/设置QQ来/设置班级名称

@property(nonatomic,retain)NSString *groupChatName;
// 设置群聊名字时候的gid
@property(nonatomic,retain)NSString *gid;

@property(nonatomic,retain)NSString *className;

@property(nonatomic,retain)NSString *cid;

@end

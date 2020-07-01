//
//  NoCardViewController.h
//  MicroSchool
//
//  Created by Kate on 16/9/13.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NoCardViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *tableView;
    UITextField *_textField_name;
    UIButton *submitBtn;
    
}

@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,assign)NSUInteger isStudent;//学生家长 1 其他身份 不为1
@property(nonatomic,strong)NSString *cid;
@end

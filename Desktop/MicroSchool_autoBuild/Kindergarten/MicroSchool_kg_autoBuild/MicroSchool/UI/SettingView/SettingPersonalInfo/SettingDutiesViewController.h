//
//  SettingDutiesViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SettingDutiesViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *listArray;
    
}

@property(nonatomic,strong) NSString *titleID;//职务ID
@property(nonatomic,strong) NSString *dutyName;//职务名称

@end

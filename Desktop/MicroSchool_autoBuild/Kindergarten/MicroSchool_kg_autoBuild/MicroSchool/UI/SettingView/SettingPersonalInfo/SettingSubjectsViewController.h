//
//  SettingSubjectsViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SettingSubjectsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listArray;
    NSMutableArray *checkList;
    NSMutableArray *tagIdArray;
    NSMutableArray *tagNameArray;
}

@end

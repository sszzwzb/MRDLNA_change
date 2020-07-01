//
//  GraduateViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/9/16.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GraduateViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *listArray;
    
    NSString *schoolType;//学校类型 教育局 幼儿园 其他 add 2015.05.05
    
    UIView *noDataView;
}

// add by ht 2015.10.10 注册流程中添加班级选择
@property(nonatomic,retain) NSString *viewType;

@end

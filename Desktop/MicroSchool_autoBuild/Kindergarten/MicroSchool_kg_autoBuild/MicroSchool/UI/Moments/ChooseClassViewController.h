//
//  ChooseClassViewController.h
//  MicroSchool
//
//  Created by Kate on 15-1-15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"

@interface ChooseClassViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *listArray;
    MBProgressHUD *HUD;
    BOOL isAll;
    NSMutableArray *listCheckArray;
    
}
@property(nonatomic,strong)NSString *fromName;//发动态页，动态详情页
@property(nonatomic,assign)BOOL isClass;// 发动态中的发班级动态
@property(nonatomic,strong)NSString* cid;
@property(nonatomic,strong)NSString *fmid;//动态id
@property(nonatomic,strong)NSMutableArray *classList;//从我的班级详情来的班级列表
@end

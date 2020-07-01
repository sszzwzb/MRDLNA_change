//
//  WhoCanViewController.h
//  MicroSchool
//
//  Created by Kate on 15-1-13.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface WhoCanViewController : BaseViewController{
    
    MBProgressHUD *HUD;
    UIView *noDataView;
    
    NSString *cids;
    
}

@property(nonatomic,strong)NSString *fromName;//发动态，动态查看设置,某条动态详情设置
@property(nonatomic,assign)BOOL isClass;// 发动态中的发班级动态
@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *cName;
@property(nonatomic,strong)NSString *privilege;//权限
@property(nonatomic,assign)int privilegeFromSet;//设置页权限
@property(nonatomic,assign)int privilegeFromMyMoment;//从我的某条动态详情来
@property(nonatomic,strong)NSString *fmid;//从我的动态详情页传来的动态id
@property(nonatomic,strong)NSMutableArray *classList;//从我的班级详情来的班级列表
@property(nonatomic,strong)NSString *cidsFromDetail;//从我的班级详情来的班级ids
@end

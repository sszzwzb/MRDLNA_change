//
//  MyPointsViewController.h
//  MicroSchool
//  我的积分
//  Created by Kate's macmini on 15/8/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyPointsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *listArray;//积分规则列表
    NSString *note;// 积分介绍
    UIImage *progressImg;
    NSString *shopUrl;//积分商城url
}

@property(nonatomic,strong) NSDictionary *dic; // 积分字典
@property(nonatomic,strong) NSString *titleName;
@end

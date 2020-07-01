//
//  SettingResideCityViewController.h
//  MicroSchool
//
//  Created by jojo on 14-1-1.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingResideCityViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,HttpReqCallbackDelegate>
{
    UITableView *_tableView;
    
    NSArray *_cities;
    
    NSString *cityStr;
    
    
    NSUInteger currentRow;
}

@property (copy, nonatomic) NSArray *cities;
@property (strong,nonatomic) NSString *resideProvince;
@property(nonatomic,strong)NSString *fromName;//用于判断从哪个页面来 好判断回到哪个页面
@end

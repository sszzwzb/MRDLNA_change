//
//  SettingHomeViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "SettingHomeCityViewController.h"

@interface SettingHomeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;

    NSArray *provinces;
}

@property(nonatomic,strong)NSString *fromName;//用于判断从哪个页面来 好判断回到哪个页面
@end

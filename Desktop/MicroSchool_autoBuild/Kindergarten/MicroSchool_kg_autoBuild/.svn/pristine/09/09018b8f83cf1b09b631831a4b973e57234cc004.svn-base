//
//  AtListViewController.h
//  MicroSchool
//
//  Created by Kate on 16/7/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AtListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listArray;
    NSMutableArray *mutableArrayOrign;
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchDisplayController *searchDisplayController;
}

@property(nonatomic,assign) NSUInteger type;//0 管理组, 1 普通群聊, 2 班级群聊
@property(nonatomic,assign) long long gid;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
@property (nonatomic, retain) NSMutableArray *sortedArrForArraysFilter;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeysFilter;
@end

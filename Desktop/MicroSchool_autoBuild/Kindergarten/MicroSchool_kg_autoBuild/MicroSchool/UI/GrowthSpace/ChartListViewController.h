//
//  ChartListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChartListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listArray;
    UIView *noDataView;
}

@property(nonatomic,strong)NSString *cId;
@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *titleName;
@end

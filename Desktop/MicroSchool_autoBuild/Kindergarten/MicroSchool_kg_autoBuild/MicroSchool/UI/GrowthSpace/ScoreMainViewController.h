//
//  ScoreMainViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/8.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScoreMainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    CGSize winSize;
    NSMutableArray *courses;
    UIView *noDataView;

}

@property(nonatomic,strong)NSString *cId;
@property(nonatomic,strong)NSString *number;

// 蒙版页面
@property (nonatomic, retain) UIView *viewMasking;

@end

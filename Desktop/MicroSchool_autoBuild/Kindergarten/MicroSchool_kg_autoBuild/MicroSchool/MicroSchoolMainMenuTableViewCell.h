//
//  MicroSchoolMainMenuTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface MicroSchoolMainMenuTableViewCell : UITableViewCell
{
    // 名称
    UILabel *label_name;
    
    // 介绍
    UILabel *label_comment;

    // icon
    UIImageView *imgView_icon;
    
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *comment;

@property (nonatomic, retain) UIImageView *imgView_icon;
@property (nonatomic ,retain) UIImageView *videoNewImg;//new 标记 视频监控 2015.09.10
@end

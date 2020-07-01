//
//  SetPersonalInfoTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-3.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface SetPersonalInfoTableViewCell : UITableViewCell
{
    UILabel *label_name;
    UILabel *userNameLab;// add by kate 2014.10.16
    UILabel *realNameLab;// add by kate 2014.10.28
    UILabel *userNameTitleLab;// add by kate 2014.10.28
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userName;// add by kate 2014.10.16
@property (copy, nonatomic) NSString *realName;// add by kate 2014.10.28
@property (copy, nonatomic) NSString *userTitleName;// add by kate 2014.10.28
@property (nonatomic, retain) UIImageView *imgView_thumb;

@end

//
//  PasswordTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-30.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordTableViewCell : UITableViewCell
{
    UILabel *label_pwd;
}

@property (copy, nonatomic) NSString *pwd;

@end

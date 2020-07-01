//
//  FriendTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-24.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface FriendTableViewCell : UITableViewCell
{
    UILabel *label_name;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *isFriend;
@property (nonatomic, retain) UIButton *btn_thumb;

@property (nonatomic, retain) UIButton *button_addFriend;
@property (copy, nonatomic) NSString *viewName;
@property (copy, nonatomic) NSString *authority;

@end

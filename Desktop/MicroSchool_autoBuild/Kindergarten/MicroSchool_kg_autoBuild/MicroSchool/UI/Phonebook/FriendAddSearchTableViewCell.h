//
//  FriendSearchTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface FriendAddSearchTableViewCell : UITableViewCell
{
    UILabel *label_name;
    UILabel *label_shcool;
    UILabel *label_spacenote;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *shcool;
@property (copy, nonatomic) NSString *spacenote;

@property (nonatomic, retain) UIImageView *imgView_thumb;
@property (nonatomic, retain) UIButton *button_addFriend;

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *isFriend;

@end

//
//  FriendNewFriendTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 5/8/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface FriendNewFriendTableViewCell : UITableViewCell
{
    UILabel *label_name;
    UILabel *label_content;
    UILabel *label_time;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *uid;
@property (nonatomic, retain) UIImageView *imgView_thumb;

@property (nonatomic, retain) UIButton *button_addFriend;

@end

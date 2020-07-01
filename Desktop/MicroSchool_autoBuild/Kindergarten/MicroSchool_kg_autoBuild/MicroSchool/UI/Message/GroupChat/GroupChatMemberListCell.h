//
//  GroupChatMemberListCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "Utilities.h"

@interface GroupChatMemberListCell : UITableViewCell{
    
    UILabel *label_shcool;
    UILabel *label_spacenote;
    
    BOOL m_checked;
}
@property (nonatomic, retain) UILabel *label_name;
@property (nonatomic, retain) UILabel *label_comment;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *shcool;
@property (copy, nonatomic) NSString *spacenote;

@property (nonatomic, retain) UIImageView *imgView_thumb;
@property (nonatomic, retain) UIButton *button_addFriend;

@property (nonatomic, retain) UIImageView *m_checkImageView;

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *isFriend;
@property (copy, nonatomic) NSString *cellIndex;

- (void) setChecked:(NSInteger)checked;
@end

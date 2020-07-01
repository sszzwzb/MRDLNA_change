//
//  GroupChatSettingMemberTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 15/5/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupChatSettingMemberList.h"

@interface GroupChatSettingMemberTableViewCell : UITableViewCell

@property (nonatomic, retain) GroupChatSettingMemberList *memberList;
@property (nonatomic, assign) BOOL hiddenMomentsList;

- (void)setMemberListFrame:(CGRect)frame andArr:(NSArray *)arr;
- (void)setMemberListFrame:(CGRect)frame andArr:(NSArray *)arr showRemoveIcon:(BOOL)isShow;

- (void)setMemberListDelete;

- (void)setRemoveIconHidden:(BOOL)isHidden;

- (void)removeAllMember;
- (void)removeMemberAtIndex:(NSInteger)pos;

@end

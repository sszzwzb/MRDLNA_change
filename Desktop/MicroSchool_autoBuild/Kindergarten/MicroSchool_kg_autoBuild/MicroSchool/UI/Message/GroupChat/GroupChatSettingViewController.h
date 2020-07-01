//
//  GroupChatSettingViewController.h
//  MicroSchool
//
//  Created by jojo on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "GroupChatSettingMemberTableViewCell.h"

#import "FriendProfileViewController.h"
#import "SettingNameViewController.h"
#import "LaunchGroupChatViewController.h"
#import "SubUINavigationController.h"
#import "GroupChatList.h"
#import "MixChatListObject.h"

#import "ContactsViewController.h"

@interface GroupChatSettingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

// tableview header包含内容
@property (nonatomic, retain) UIView *tableViewHeader;

// 计算成员列表的高度
@property (nonatomic, assign) NSInteger headerViewHeight;

@property (nonatomic, assign) BOOL isShowRemoveIcon;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *groupChatAlert;

// 当前群聊的gid
@property (nonatomic, retain) NSString *gid;

@property(nonatomic,assign)long long cid;

// 当前群聊的profile
@property (nonatomic, retain) NSMutableDictionary *gProfile;

// 当前群聊的成员列表
@property (nonatomic, retain) NSMutableArray *memberArr;

@property (nonatomic, retain) NSMutableArray *uidArray;
@property (nonatomic, retain) NSMutableArray *sidArray;

// 当前群聊的成员列表包含了增加与删除
@property (nonatomic, retain) NSMutableArray *memberWithAddArr;

@property (nonatomic,retain) GroupChatList *groupChatList;// 不再使用 2016.01.19

@property (nonatomic,retain) MixChatListObject *chatList;//新 add 2016.01.19

// 单聊传过来的user信息
@property (nonatomic, retain) UserObject *userObj;

// hiddenMomentsList 不看ta的师生圈的人列表
// 默认为群聊和单聊
@property (nonatomic, retain) NSString *viewType;

// 屏蔽师生圈人的列表
@property (nonatomic, retain) NSMutableArray *hiddenMomentsArr;

@end

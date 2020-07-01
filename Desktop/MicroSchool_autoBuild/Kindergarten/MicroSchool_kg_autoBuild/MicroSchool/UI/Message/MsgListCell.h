//
//  MsgListCell.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeadImage.h"
#import "MsgListCell.h"
#import "ChatListObject.h"
#import "GroupChatList.h"
#import "MixChatListObject.h"

@interface MsgListCell : UITableViewCell <HeadImageDelegate>
{
    UILabel *nameLabel;//显示聊天者名称
    UILabel *timeLabel;//显示聊天时间
    UIHeadImage *headImageView;//聊天对象的头像
    UILabel *detailLabel;//显示最后一条聊天纪录
    int unReadCnt;//未读消息的个数
    UILabel *unReadLabel;//未读消息
    ChatListObject *chatListObject;
    UIImageView *unReadBadgeView;
    UIImageView *sendFailed;
    
    GroupChatList *groupChatListObject;//add by kate 2015.05.27
    UIImageView *headImageViewForGroup;//聊天对象的头像 add 2015.05.30
    
    UIImageView *botherImgV;//消息免打扰图片

}

@property (nonatomic, retain) UILabel *nameLabel;;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIHeadImage *headImageView;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, assign) int unReadCnt;
@property (nonatomic, retain) UILabel *unReadLabel;
@property (nonatomic, retain) ChatListObject *chatListObject;
@property (nonatomic, retain) GroupChatList *groupChatListObject;
@property (nonatomic, retain) UIImageView *unReadBadgeView;
@property (nonatomic, retain) UIImageView *sendFailed;
@property (nonatomic, retain) UILabel *isAtLabel;//是否有人@我 [有人@我]红色
@property (nonatomic, retain) MixChatListObject *mixChatListObject;//add by kate 2015.05.27
@property (nonatomic, retain) UIImageView *headImageViewForGroup;//add 2015.05.30
@property (nonatomic, retain) UIImageView *botherImgV;// 消息免打扰

// 设置时间，根据time长度调整title的长度
- (void)setTime:(NSString *)time;

// 设置title
-(void)setName:(NSString *)nameStr;

//设置显示的最后一条消息内容
- (void)setDetail:(NSString *)detailText;

//设置显示的头像
- (void)setHeadImage:(long long)user_id;

@end

//
//  MyGroupMsgListViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GroupChatList.h"
#import "FRNetPoolUtils.h"

@interface MyGroupMsgListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *chatListArray;
    GroupChatList *groupChatList;
    CGSize winSize;
    UIView *noDataView;
    NSMutableArray *headArray;//放组合完头像的群聊头像
    
}

@property(nonatomic,strong)NSString *cid;// 班级id
@property(nonatomic,strong)NSString *titleName;
@property (nonatomic, retain) NSMutableArray *chatListArray;
@end

//
//  MsgListViewController.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDetailsViewController.h"
#import "MsgListCell.h"
#import "BaseViewController.h"

@interface MsgListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    // 聊天列表
    UITableView *chatsListTableView; 
    // 聊天列表数据
    NSMutableArray *chatListArray;
    //聊天详细画面
//    MsgDetailsViewController *chatDeatilController;
    
    CGSize winSize;
    
    UIView *noDataView;
    
    NSMutableDictionary *unReadMsgDic;//2015.11.18
    UIView *_baseView;
    UIButton *_deleteBtn;
    NSMutableArray *deleteArr;// 删除数组
    
}

@property (nonatomic, retain) UITableView *chatsListTableView;
@property (nonatomic, retain) NSMutableArray *chatListArray;
//@property (nonatomic, retain) MsgDetailsViewController *chatDeatilController;
@end

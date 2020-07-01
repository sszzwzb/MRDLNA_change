//
//  MsgListMixViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/18.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDetailsViewController.h"
#import "MsgListCell.h"
#import "BaseViewController.h"

@interface MsgListMixViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
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
    
    NSMutableArray *headArray;//放组合完头像的群聊头像
    NSMutableDictionary *headDiction;//放组合完头像的群聊头像
    
    UIButton *selectAllBtn;

}
@property (nonatomic, retain) UITableView *chatsListTableView;
@property (nonatomic, retain) NSMutableArray *chatListArray;
//@property (nonatomic, retain) MsgDetailsViewController *chatDeatilController;
- (void)clickDeleteMsg;
@end

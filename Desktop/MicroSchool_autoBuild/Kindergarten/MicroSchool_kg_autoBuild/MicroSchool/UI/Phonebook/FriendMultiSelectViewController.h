//
//  FriendMultiSelectViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 6/6/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendMultiSelectTableViewCell.h"
#import "ChatDetailObject.h"
#import "MBProgressHUD+Add.h"

@interface FriendMultiSelectViewController : BaseViewController<UITableViewDelegate, HttpReqCallbackDelegate, UITextFieldDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSString* cid;
    
    NSMutableArray* listDataArray;
//    NSDictionary *dataArray;
    
    UITextField *textField_search;
    NSString *searchText;
    
    // 添加好友前面的加号图片
    UIImage *buttonImg_d;
    UIImage *buttonImg_p;
    
    // 记录每一个组的标题在数组中的位置
    NSInteger p1;
    NSInteger p2;
    NSInteger p3;
    NSInteger p4;
    NSInteger p5;

    NSMutableArray* sendMsgUids;
    NSMutableArray* sendMsgUserName;
    
    MBProgressHUD *HUD;
}

@property (retain, nonatomic) NSString *classid;
@property (retain, nonatomic) NSString *friendType;

@property (retain, nonatomic) NSMutableArray *items;
@property (retain, nonatomic) NSString *fromName;// 2015.03.25
@property (nonatomic, strong) ChatDetailObject *entity;// 2015.03.26
@property (nonatomic,strong) NSString *flag;// 本单位 下属单位

@property (retain, nonatomic) NSString *gid;

@end

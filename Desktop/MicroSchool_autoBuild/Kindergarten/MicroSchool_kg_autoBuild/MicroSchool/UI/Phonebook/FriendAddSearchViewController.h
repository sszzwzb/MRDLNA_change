//
//  FriendSearchViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "FriendAddSearchTableViewCell.h"
#import "FriendAddReqViewController.h"

@interface FriendAddSearchViewController : BaseViewController<UITableViewDelegate, HttpReqCallbackDelegate, UITextFieldDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSString* cid;
    
    NSMutableArray* listDataArray;
    
    UITextField *textField_search;
    NSString *searchText;
    
    // 添加好友前面的加号图片
    UIImage *buttonImg_d;
    UIImage *buttonImg_p;
}

@end

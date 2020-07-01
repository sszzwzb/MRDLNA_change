//
//  ContactsViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 16/1/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "DBDao.h"
#import "MsgDetailsViewController.h"
#import "GroupChatList.h"
#import "GroupChatListHeadObject.h"

#import "MixChatListObject.h"
#import "FRNetPoolUtils.h"

#import "pinyin.h"
#import "ChineseString.h"
#import "PinYinForObjc.h"

#import "MySearchDisplayController.h"

@interface ContactsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>{
    
    NSMutableDictionary *headDiction;//放组合完头像的群聊头像

    //搜索
    NSMutableArray *searchResults;
    UISearchDisplayController *searchDisplayController;
    MySearchDisplayController *mySearchDisplayController;
    UISearchBar *mySearchBar;
    
}

// contactsList 通讯录列表
// chatMemberSelect 创建群聊添加成员
@property(nonatomic,retain) NSString *viewType;

// 是否是从单聊设置页面转变为群聊
@property(nonatomic,retain) NSString *addToGroupChat;

// 数据源
@property(nonatomic,retain) NSMutableArray *data;

@property(nonatomic,retain) NSString *cid;

// 创建新群聊时候的成员uid列表，uid之间用“,”分割
@property(nonatomic,retain) NSString *selectedMembersStr;
@property(nonatomic,retain) NSMutableArray *selectedMembersArray;

// 从群聊设置页面传递过来的uid列表
@property(nonatomic,retain) NSMutableArray *settingMembersArray;

// 显示头像的滑动view
@property(nonatomic,retain) UIScrollView *headScrollView;
@property(nonatomic,retain) NSMutableArray *headViewArray;

// 最上面显示的scrollView上的头像的个数
@property(nonatomic,assign) NSInteger selectedCount;

@property (nonatomic,strong) NSMutableArray *positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray *positionFor9ModeImage;
//---2017.03.08
@property (nonatomic, strong) NSMutableArray *selectedSidArray;
@property (nonatomic, strong) NSMutableArray *settingSidArray;
//-----------------------
@end

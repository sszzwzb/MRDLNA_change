//
//  LaunchGroupChatViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "PinYinForObjc.h"

@interface LaunchGroupChatViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>{
    
    NSMutableArray *listDataArray;// 获取数据array
    
    NSMutableArray *checkListArray;// 选择array 存row的选中情况
    
    NSMutableArray *checkSectionArray;// 存section的选中情况
    
    int rowCount;// 总行数
    
    int count;
    
    NSMutableArray *headArray;//头像数组
    
    // 搜索
    //NSMutableArray *mutableArrayOrign;
    NSMutableArray *searchResults;
    UISearchDisplayController *searchDisplayController;
    

}

@property(nonatomic,strong)NSString *cid;// 班级id

// groupChatSetting 为从群聊设置页面进去
@property(nonatomic,retain)NSString *viewType;

// 已加入的成员列表，从群聊设置进入列表页才会有值
@property(nonatomic,retain)NSArray *memberUidArr;
- (IBAction)finishSelectAction:(id)sender;

@end

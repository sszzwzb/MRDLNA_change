//
//  ClassListViewController.h
//  MicroSchool
//
//  Created by Kate on 14-9-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ClassListTableViewCell.h"

@interface ClassListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,ClassListTableViewCellDelegate>{
    
    NSMutableArray *listArray;
    
    NSString *schoolType;//学校类型 教育局 幼儿园 其他 add 2015.05.05
    
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
    UIButton *button_search;
    UIButton *button_multiSend;
    NSString *joinperm;//加入班级方式
    
    NSString *resultCid;// 用于判断是否刷新班级 非0就刷新
    NSString *cId;
    NSString *className;

}

// add by ht 2015.10.10 注册流程中添加班级选择
@property(nonatomic,retain) NSString *viewType;
@property(nonatomic,retain) NSDictionary *userInfoDic;//从用户信息完善页来
@property(nonatomic,assign)NSInteger flag;//点击添加新子女/继续创建 1 家长身份绑定的子女cell/重名cell 2 切换子女列表添加新子女 3
@end

//
//  SwitchChildViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 6/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "SwitchChildViewController.h"
#import "SwitchChildTableViewCell.h"
#import "AddClassApplyViewController.h"
#import "MyClassListViewController.h"
#import "MicroSchoolAppDelegate.h"

@interface SwitchChildViewController ()

@end

@implementation SwitchChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [super setCustomizeTitle:_titleName];
    
    if ([@"switchChild"  isEqual: _viewType]) {
        [super setCustomizeLeftButton];
        [super setCustomizeRightButtonWithName:@"管理"];
    }else if ([@"managerChild"  isEqual: _viewType]) {
        self.navigationItem.hidesBackButton =YES;
        [super setCustomizeRightButtonWithName:@"完成"];
    }
    
    if ([@"switchChild"  isEqual: _viewType]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refleshSwitchChildView)
                                                     name:@"zhixiao_refleshSwitchChildView"
                                                   object:nil];
    }

    _dataAry = [[NSMutableArray alloc] init];
    _isSwitchingChild = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
     NSLog(@"SwitchChild");
    [Utilities showProcessingHud:self.view];
    [self doGetChild];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchChildSelectChild:)
                                                 name:@"zhixiao_switchChildSelectChild"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchChildUnbindChild:)
                                                 name:@"zhixiao_switchChildUnbindChild"
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhixiao_switchChildSelectChild" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhixiao_switchChildUnbindChild" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectLeftAction:(id)sender {
    if ([@"switchChild"  isEqual: _viewType]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

////右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
//- (BOOL)gestureRecognizerShouldBegin{
//    
//    if ([@"switchChild"  isEqual: _viewType]) {
//        return YES;
//    }
//    
//    return NO;
//}

-(void)selectRightAction:(id)sender {
    if ([@"switchChild"  isEqual: _viewType]) {
        // 到管理页面
//        self.navigationItem.hidesBackButton = YES;
        [super setCustomizeTitle:@"管理"];

        [super setCustomizeLeftButtonWithName:@""];
        [super setCustomizeRightButtonWithName:@"完成"];

        _viewType = @"managerChild";
        
        [_tableView reloadData];
//        SwitchChildViewController *vc = [[SwitchChildViewController alloc] init];
//        vc.titleName = @"管理";
//        vc.viewType = @"managerChild";
//        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"managerChild"  isEqual: _viewType]) {
        // 完成
        [super setCustomizeTitle:_titleName];

        [super setCustomizeLeftButton];
        [super setCustomizeRightButtonWithName:@"管理"];
        
        _viewType = @"switchChild";
        [_tableView reloadData];

        
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)refleshSwitchChildView {
    [_dataAry removeAllObjects];
    
    [self doGetChild];
}

-(void)switchChildSelectChild:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
//    NSLog(@"switchChildSelectChild --- %@", dic);
    
    if ([@"switchChild"  isEqual: _viewType]) {
        if (nil == dic) {
            // 为添加新子女，页面跳转
            AddClassApplyViewController *vc = [[AddClassApplyViewController alloc] init];
            vc.titleName = @"用户信息完善";
            vc.iden = @"parent";
            vc.flag = 3;
            vc.viewType = @"changeChild";
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSString *a = [NSString stringWithFormat:@"%@", [dic objectForKey:@"rowId"]];
            if (_selectedChild != [a integerValue]) {
                // 切换子女
                if (!_isSwitchingChild) {
                    [self doSwitchChild:dic];
                }
            }
        }
    }else if ([@"managerChild"  isEqual: _viewType]) {
        // nothing to do.
    }
}

-(void)switchChildUnbindChild:(NSNotification *)notification {
    
    UnbindChildDic = [notification userInfo];
//    NSLog(@"switchChildUnbindChild --- %@", dic);
    
    // 解绑
#if 0
    TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
        [self doUnbindChild:dic];
    };
    
    NSArray *itemsArr =
    @[TSItemMake(@"确定", TSItemTypeNormal, handlerTest)];
    [Utilities showPopupView:@"解除绑定后会退出当前班级，是否确定解绑？" items:itemsArr];
#endif
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"解除绑定后会退出当前班级，是否确定解绑？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    alert.tag = 200;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 200) {
        
        if (buttonIndex == 1) {
            [self doUnbindChild:UnbindChildDic];

        }
        
    }
}

- (void)doUpdateProfile:(NSDictionary *)dic {
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"view", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSString *uid1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            // 清空注册完毕信息
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid1]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存是否是注册登录流程完成，设置为no，则为完成了
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid1]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            NSDictionary *profile = [message_info objectForKey:@"profile"];
            NSDictionary *role = [message_info objectForKey:@"role"];
            
            NSLog(@"profile:%@",profile);
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[message_info objectForKey:@"profile"]];
            
            NSDictionary *vip = [message_info objectForKey:@"vip"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
            
            [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[message_info objectForKey:@"role"]];

//            [Utilities doSaveUserInfoToDefaultAndSingle:profile andRole:role];
        } else {
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}


- (void)doUnbindChild:(NSDictionary *)dic {
    /**
     * 家长删除绑定
     * @auth yangzc
     * @date 16/6/16
     * @args v=4 ac=StudentIdBind op=delRecord sid= cid= uid=  childNumberId=(要解绑的子女ID学籍)
     */
     NSLog(@"doUnbindChild");
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *userD = [g_userInfo getUserDetailInfo];
    NSString *cid = [userD objectForKey:@"role_cid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"StudentIdBind", @"ac",
                          @"4", @"v",
                          @"delRecord", @"op",
                          cid, @"cid",
                          [dic objectForKey:@"student_number_id"], @"childNumberId",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            [self dismissRedPoint];
            
            // 解绑成功返回并刷新前画面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_refleshSwitchChildView" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];

            [_dataAry removeAllObjects];

            [self doGetChild];

            // 清除通知栏消息
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

//            [self.navigationController popViewControllerAnimated:YES];
        } else {
           
            [Utilities showTextHud:[Utilities replaceNull:[respDic objectForKey:@"message"]] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

-(void)dismissRedPoint {
    
//    MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
//    myClass.hidesBottomBarWhenPushed = YES;
//    UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
//    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
//    [array replaceObjectAtIndex:1 withObject:customizationNavi];
//    [appDelegate.tabBarController setViewControllers:array];
    
    //            [noticeImgVForMsg removeFromSuperview];
    //            [noticeImgVForMsg removeFromSuperview];
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
    UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
    UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
    
    [detailImg removeFromSuperview];
    [listImg removeFromSuperview];
    [detailImg removeFromSuperview];
    [listImg removeFromSuperview];
    //
    
    
    /*//--退出班级将原来班级详情页/班级列表页现有未读红点全部清空 赵经纬 李昌明 张昊天 确认 kate被迫修改 2016.02.26-----------
    
    //[self deleteTableForGroupMsg:_cId];//清空群聊红点消息
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *alwaysNewsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"alwaysNewsDic"]];
    NSArray *classArray = [alwaysNewsDic objectForKey:@"classes"];
    
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
    
    for (int i = 0 ; i<[classArray count]; i++) {
        
        NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
        NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
        NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
        
        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
        [classLastDicDefault setObject:last forKey:keyStr];
        
    }
    
    [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
    [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
    [userDefaults synchronize];
    
    NSArray *spacesArray = [alwaysNewsDic objectForKey:@"spaces"];
    NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
    
    for (int i = 0 ; i<[spacesArray count]; i++) {
        
        NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
        NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
        NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
        
        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
        [spaceLastDicDefault setObject:last forKey:keyStr];
        
        
    }
    
    [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
    [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
    [userDefaults synchronize];
    
    //-------------------------------------------------------------------------------------------------------
    */

}

// 退出班级清空群聊红点 不管已读未读都删除群聊相关表 2016.02.26
-(void)deleteTableForGroupMsg:(NSString*)cid{
    
    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[cid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    
    NSInteger count = [chatsListDict.allKeys count];
    
    for (int listCnt = 0; listCnt < count; listCnt++) {
        
//        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
//        long long gid =[[chatObjectDict objectForKey:@"gid"] longLongValue];
        
//        NSString *sql = [NSString stringWithFormat:@"delete from msgInfoForGroup_%lli ", gid];
//        BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
        
    }
    
//    NSString *deleteListsql =  [NSString stringWithFormat:@"delete from msgListForGroup_%lli",[cid longLongValue]];
//    BOOL retList = [[DBDao getDaoInstance] executeSql:deleteListsql];
    
}

- (void)doSwitchChild:(NSDictionary *)dic {
    /**
     * 切换当前绑定的子女
     * @auth yangzc
     * @date 16/6/16
     * @args v=4 ac=StudentIdBind op=changeChild sid= cid= uid=  childNumberId=(要切换的子女ID学籍)
     */
    NSLog(@"doSwitchChild");
    [Utilities showProcessingHud:self.view];
    _isSwitchingChild = YES;

    NSDictionary *userD = [g_userInfo getUserDetailInfo];
    NSString *cid = [userD objectForKey:@"role_cid"];
    
//    NSMutableDictionary *recipesDic = [NSMutableDictionary dictionaryWithDictionary:[_dataAry objectAtIndex:_selectedChild]];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"StudentIdBind", @"ac",
                          @"4", @"v",
                          @"changeChild", @"op",
                          cid, @"cid",
                          [dic objectForKey:@"student_number_id"], @"childNumberId",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
            [self doUpdateProfile:nil];
            
            // 消除之前班级的红点通知
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reBuildRedArray" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
            
            [self dismissRedPoint];

            _selectedChild = ((NSString *)[dic objectForKey:@"rowId"]).integerValue;
            
            [_tableView reloadData];
            _isSwitchingChild = NO;

            // 清除通知栏消息
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else {
            _isSwitchingChild = NO;
            [Utilities showTextHud:[Utilities replaceNull:[respDic objectForKey:@"message"]] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)doGetChild {
    /**
     * 获取家长在当前学校的绑定的子女列表
     * @auth yangzc
     * @date 16/6/16
     * @args
     *  v=4 ac=StudentIdBind op=findRecord sid= cid= uid=
     */
    
    NSDictionary *userD = [g_userInfo getUserDetailInfo];
    NSString *cid = [userD objectForKey:@"role_cid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"StudentIdBind", @"ac",
                          @"4", @"v",
                          @"findRecord", @"op",
                          cid, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
           
            NSMutableArray *list = [NSMutableArray arrayWithArray:[respDic objectForKey:@"message"]];
            
            if (0 != [list count]) {
                _blankView.hidden = YES;
                
                //---add by kate 2016.06.30------------------------------------------
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *classArray = [[NSMutableArray alloc] init];
                //--------------------------------------------------------------------
                
                for (int i=0; i<[list count]; i++) {
                    NSMutableDictionary *listDic = [list objectAtIndex:i];
                    
                    if (1 == [[listDic objectForKey:@"subscribe"] intValue]) {
                        _selectedChild = i;
                    }

                    [_dataAry addObject:listDic];
                    
                    //---add by kate 2016.06.30----------------------
                    //存储家长加入的多个班级cid 用户更新师生圈红点
                    
                    NSString *class_id = [[list objectAtIndex:i] objectForKey:@"class_id"];
                    [classArray addObject:class_id];
                    
                    [userDefaults setObject:classArray forKey:@"cids_parent"];
                    [userDefaults synchronize];
                    //-----------------------------------------------

                }
                
            }
            
            NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"添加新子女", @"type",
                                  nil];
            [_dataAry addObject:data1];
                        
            if (0 == [_dataAry count]) {
                [_dataAry removeAllObjects];
                _blankView.hidden = NO;
            }
            
            [_tableView reloadData];
        } else {
            
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }else {
        return 3.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ([_dataAry count]-1)) {
        return 3.5;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([@"switchChild"  isEqual: _viewType]) {
        return [_dataAry count];

    }else {
        if ([_dataAry count] == 0) {
            return 0;
        }else {
            return [_dataAry count]-1;
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";

    NSUInteger row = [indexPath section];
    NSMutableDictionary *recipesDic = [NSMutableDictionary dictionaryWithDictionary:[_dataAry objectAtIndex:row]];
    
    if ([indexPath section] == ([_dataAry count]-1)) {
        if ([@"switchChild"  isEqual: _viewType]) {
            // 只有切换子女页面有添加新子女选项
            // 最后一个section
            SwitchChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
            
            if (cell == nil) {
                cell = [[SwitchChildTableViewCell alloc]
                        initWithStyle:UITableViewCellStyleValue1
                        reuseIdentifier:CellTableIdentifier1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.addChildLabel.hidden = NO;
            cell.addChildImageView.hidden = NO;
            cell.unbindButton.hidden = YES;
            
            cell.backgroundColor = [UIColor clearColor];
            cell.addChildLabel.text = @"添加新子女";
            
            cell.touchedBgImageView.layer.cornerRadius = 5;

            return cell;
        }else {
            SwitchChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
            
            if (cell == nil) {
                cell = [[SwitchChildTableViewCell alloc]
                        initWithStyle:UITableViewCellStyleValue1
                        reuseIdentifier:CellTableIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            return cell;
        }
    }else {
        SwitchChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            cell = [[SwitchChildTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:CellTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.addChildLabel.hidden = YES;
        
        cell.backgroundColor = [UIColor clearColor];
        
        //    @"学生ID：1212983", @"studentID",
        //    @"之前所属学校：298349284", @"school",
        
        cell.nameLabel.text = [recipesDic objectForKey:@"student_name"];
        CGSize nameSize = [Utilities getLabelHeight:cell.nameLabel size:CGSizeMake(0, 18)];
        
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (nameSize.width > [Utilities getScreenSizeWithoutBar].width-12*2-53) {
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-12*2-53, 20));
            }else {
                make.size.mas_equalTo(CGSizeMake(nameSize.width, 20));
            }
        }];
        
        cell.studentIdLabel.text = [NSString stringWithFormat:@"学生ID：%@", [Utilities replaceNull:[recipesDic objectForKey:@"student_number"]]];
        cell.studentSchoolLabel.text = [NSString stringWithFormat:@"所在班级：%@", [Utilities replaceNull:[recipesDic objectForKey:@"class_name"]]];
        
        if ([@"1" isEqualToString:[recipesDic objectForKey:@"sex"]]) {
            [cell.genderImageView setImage:[UIImage imageNamed:@"SwitchChild/icon_male"]];
        }else {
            [cell.genderImageView setImage:[UIImage imageNamed:@"SwitchChild/icon_female"]];
        }
        
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:recipesDic copyItems:YES];
        [info setObject:[NSString stringWithFormat:@"%lu", (unsigned long)row] forKey:@"rowId"];
        
        cell.presenceInfo = info;
        
        cell.touchedBgImageView.layer.cornerRadius = 4;

        // 如果是切换子女页面，隐藏解绑按钮，管理页面显示解绑按钮
        if ([@"switchChild"  isEqual: _viewType]) {
            cell.unbindButton.hidden = YES;
            
            [cell.studentIdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-50, 14));
            }];
            
            // 如果该孩子是当前选择的
            if (_selectedChild == row) {
//                cell.touchedBgImageView.backgroundColor = [[UIColor alloc] initWithRed:51/255.0f green:153/255.0f blue:255/255.0f alpha:1.0];
                cell.touchedBgImageView.backgroundColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
                
                cell.touchedBgImageView.layer.shadowOffset = CGSizeMake(0, 0);
                cell.touchedBgImageView.layer.shadowRadius = 5;
                cell.touchedBgImageView.layer.shadowColor = [[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] CGColor]; //设置阴影的颜色为黑色
                cell.touchedBgImageView.layer.shadowOpacity = 1.0; //设置阴影的不透明度

                cell.studentIdLabel.textColor = [UIColor whiteColor];
                cell.studentSchoolLabel.textColor = [UIColor whiteColor];
                cell.nameLabel.textColor = [UIColor whiteColor];
            }else {
                cell.touchedBgImageView.backgroundColor = [UIColor whiteColor];
                cell.touchedBgImageView.layer.shadowOpacity = 0.0; //设置阴影的不透明度

                cell.studentIdLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
                cell.studentSchoolLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
                cell.nameLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
            }
        }else if ([@"managerChild"  isEqual: _viewType]) {
            cell.unbindButton.hidden = NO;
            
            cell.touchedBgImageView.backgroundColor = [UIColor whiteColor];
            cell.touchedBgImageView.layer.shadowOpacity = 0.0; //设置阴影的不透明度
            
            cell.studentIdLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
            cell.studentSchoolLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
            cell.nameLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];

            [cell.studentIdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-100, 14));
            }];
        }
        
        return cell;
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

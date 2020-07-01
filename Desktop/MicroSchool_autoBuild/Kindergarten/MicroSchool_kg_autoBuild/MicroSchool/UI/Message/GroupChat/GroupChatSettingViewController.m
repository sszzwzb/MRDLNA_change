//
//  GroupChatSettingViewController.m
//  MicroSchool
//
//  Created by jojo on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatSettingViewController.h"
#import "GroupChatListHeadObject.h"

@interface GroupChatSettingViewController ()

@end

@implementation GroupChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 运行版本号
    //    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
        [super setCustomizeTitle:@"不看Ta的师生圈"];
        
        [super setCustomizeRightButtonWithName:@"完成" color:[UIColor colorWithRed:174.0 / 255 green:211.0 / 255 blue:215.0 / 255 alpha:1]];
        [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = NO;
    }else {
        [super setCustomizeTitle:@""];
    }
    
    [super setCustomizeLeftButton];
    
    _isShowRemoveIcon = YES;
    
    _memberArr = [[NSMutableArray alloc] init];
    _memberWithAddArr = [[NSMutableArray alloc] init];
    _gProfile = [[NSMutableDictionary alloc] init];
    _hiddenMomentsArr = [[NSMutableArray alloc] init];
    
    _uidArray = [[NSMutableArray alloc] init];
    _sidArray = [[NSMutableArray alloc] init];
    
#if 0
    // 先取出群消息设置里面的值
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *groupChatAlert = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"GroupChatAlert"]];
    
    if (groupChatAlert) {
        _groupChatAlert = groupChatAlert;
    }else {
        _groupChatAlert = @"0";
    }
#endif
    
    if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
        [self doGetHiddenMomentsList];
    }else {
        if ([@"0" isEqualToString:_gid]) {
            ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"聊天设置"];
            
            // 单聊
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%lld", _userObj.user_id],@"uid",
                                 _userObj.headimgurl,@"avatar",
                                 _userObj.name, @"name",
                                 nil];
            
            [_memberWithAddArr addObject:dic];
            
            // 为数组加上添加成员的加号btn
            NSDictionary *dicAdd = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"", @"name",
                                    @"add", @"type",
                                    @"btn_yq_p", @"localPic", nil];
            [_memberWithAddArr addObject:dicAdd];
            
            _headerViewHeight = 1*(90+16) + 16;
            
            [self showTableView];
            [_tableView reloadData];
        }else {
            // 群聊
            [self doGetGroupProfile];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMemberAction:) name:NOTIFICATION_UI_GROUPCHAT_ADDMEMBER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGroupName:) name:NOTIFICATION_UI_GROUPCHAT_CHANGEGROUPNAME object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChatToGroupChat:) name:@"settingChatToGroupChat" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRightAction:(id)sender{
    /**
     * 解除对某些人的屏蔽,
     * friends=uid,... 多用户逗号分隔
     * @author luke
     * @date 2016.12.01
     * @args
     *  v=3 ac=Circle op=unblock sid=5303 uid=49439 friends=1,2,3.....
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSString *uidsStr = [_hiddenMomentsArr componentsJoinedByString:@","];
    [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = NO;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Circle",@"ac",
                          @"3",@"v",
                          @"unblock", @"op",
                          uidsStr, @"friends",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        [Utilities dismissProcessingHud:self.view];
        
        if(true == [result intValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = YES;
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = YES;
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

-(void)selectLeftAction:(id)sender
{
    if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
        if (0 != [_hiddenMomentsArr count]) {
            TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            NSArray *itemsArr =
            @[TSItemMake(@"确认", TSItemTypeNormal, handlerTest)];
            [Utilities showPopupView:@"确定放弃修改?" items:itemsArr];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"GroupChat",@"ac",
                              @"2",@"v",
                              @"setGroupAlert", @"op",
                              _gid, @"gid",
                              [_gProfile objectForKey:@"alert"], @"alert",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                //---udpate by kate 2016.01.25-----------------------------
                //done: 更新数据库的消息免打扰标实
                NSString *isBother = [_gProfile objectForKey:@"alert"];
                // 1：开 0：关
                _chatList.bother = [isBother integerValue];
                if ([_chatList noBother]) {//更新数据库
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitle" object:nil];
                }
                //------------------------------------------------------
            } else {
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memBerListClickAction:) name:NOTIFICATION_UI_GROUPCHAT_MEMBERLISTCLICK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMemBerListClickAction:) name:NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_GROUPCHAT_MEMBERLISTCLICK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST object:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)doGetHiddenMomentsList {
    [Utilities showProcessingHud:self.view];
    
    /**
     * 我屏蔽的列表，不看他们的师生圈
     * @author luke
     * @date 2016.12.01
     * @args
     *  v=3 ac=Circle op=blocks sid=5303 uid=49439
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Circle",@"ac",
                          @"3",@"v",
                          @"blocks", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSArray *members = [respDic objectForKey:@"message"];
            
            if (0 != [members count]) {
                for (id obj in members) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    
                    [_memberWithAddArr addObject:dic];
                    [_memberArr addObject:dic];
                }
                
                //((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"不看Ta的师生圈(%lu)", (unsigned long)[_memberArr count]];
                [super setCustomizeTitle:[NSString stringWithFormat:@"不看Ta的师生圈(%lu)", (unsigned long)[_memberArr count]]];
                
                NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"", @"name",
                                      @"remove", @"type",
                                      @"btn_sc_p", @"localPic", nil];
                [_memberWithAddArr addObject:dic1];
                
                if (iPhone6p || iPhone6) {
                    // 计算群成员个数，计算出headerview的高度
                    NSInteger row = 0;
                    if ([_memberWithAddArr count]%5 != 0) {
                        row = [_memberWithAddArr count]/5 + 1;
                    }else {
                        row = [_memberWithAddArr count]/5;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }else {
                    // 计算群成员个数，计算出headerview的高度
                    NSInteger row = 0;
                    if ([_memberWithAddArr count]%4 != 0) {
                        row = [_memberWithAddArr count]/4 + 1;
                    }else {
                        row = [_memberWithAddArr count]/4;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }
                
                [self showTableView];
                
                [_tableView reloadData];
            }else {
                //((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"不看Ta的师生圈(0)"];
                [super setCustomizeTitle:[NSString stringWithFormat:@"不看Ta的师生圈(0)"]];
                
                [Utilities showNodataView:@"这里还没有内容" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }
        } else {
            [Utilities showFailedHud:@"获取群信息错误，请稍后再试。" descView:self.view];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

- (void)doGetGroupProfile {
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupProfile", @"op",
                          _gid, @"gid",
                          nil];
    
#if 0
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Test",@"ac",
                          @"2",@"v",
                          @"sleep", @"op",
                          @"1", @"time",
                          nil];
#endif
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            [_gProfile setDictionary:[msg objectForKey:@"profile"]];
            
            NSArray *members = [msg objectForKey:@"members"];
            
            if (0 != [members count]) {
                for (id obj in members) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    
                    [_memberWithAddArr addObject:dic];
                    [_memberArr addObject:dic];
                }
                
                if ([@"0"  isEqual: [_gProfile objectForKey:@"alert"]]) {
                    ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"聊天设置(%lu)", (unsigned long)[_memberArr count]];
                }else {
                    ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"聊天设置(%lu)🔕", (unsigned long)[_memberArr count]];
                }
                
                
#if 0
                // test code
                for (int i=0; i<6; i++) {
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"测试", @"name",
                                         @"6308", @"uid",
                                         @"picUrl", @"avatar", nil];
                    
                    [_memberArr addObject:dic];
                }
#endif
                // 普通成员也可以加人进群 2.12迭代三 侯丽娜确认 2016.08.03
                // 为数组加上添加成员的加号btn
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"", @"name",
                                     @"add", @"type",
                                     @"btn_yq_p", @"localPic", nil];
                [_memberWithAddArr addObject:dic];
                
                if ([[_gProfile objectForKey:@"uid"] isEqualToString: [Utilities getUniqueUid]]) {
                    
                    //                    // 为数组加上添加成员的加号btn
                    //                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                    //                                         @"", @"name",
                    //                                         @"add", @"type",
                    //                                         @"btn_yq_p", @"localPic", nil];
                    //                    [_memberWithAddArr addObject:dic];
                    
                    // 判断是否是创建人，如果是则添加减号btn
                    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          @"", @"name",
                                          @"remove", @"type",
                                          @"btn_sc_p", @"localPic", nil];
                    [_memberWithAddArr addObject:dic1];
                }
                
                if (iPhone6p || iPhone6) {
                    // 计算群成员个数，计算出headerview的高度
                    NSInteger row = 0;
                    if ([_memberWithAddArr count]%5 != 0) {
                        row = [_memberWithAddArr count]/5 + 1;
                    }else {
                        row = [_memberWithAddArr count]/5;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }else {
                    // 计算群成员个数，计算出headerview的高度
                    NSInteger row = 0;
                    if ([_memberWithAddArr count]%4 != 0) {
                        row = [_memberWithAddArr count]/4 + 1;
                    }else {
                        row = [_memberWithAddArr count]/4;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }
                
                [self showTableView];
                
                [_tableView reloadData];
            }else {
                [Utilities showFailedHud:@"获取群成员错误，请稍后再试。" descView:self.view];
            }
        } else {
            [Utilities showFailedHud:@"获取群信息错误，请稍后再试。" descView:self.view];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)showTableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 和微信一样，隐藏掉headerview，但是又不能直接hidden，就设置为0.1吧，哈哈
        _tableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH,
                                                                   0.1)];
        
        _tableView.tableHeaderView = _tableViewHeader;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:_tableView];
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
        if(0 == section) {
            return 1;
        }else {
            return 0;
        }
    }else {
        if(0 == section) {
            return 1;
        }else if(1 == section) {
            if ([@"0" isEqualToString:_gid]) {
                return 1;
            }else {
                //                if (1 == _chatList.type) {
                return 3;
                //                }else {
                //                    return 2;
                //                }
            }
        }else {
            return 1;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([@"0" isEqualToString:_gid]) {
        return 2;
    }else {
        return 3;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == [indexPath section]) {
        return _headerViewHeight;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    
    
    if ([@"0" isEqualToString:_gid]) {
        // 单聊
        if(0 == [indexPath section] && 0 == [indexPath row]){
            // 成员列表
            static NSString *GroupedTableIdentifierMember = @"GroupedTableIdentifierMember";
            GroupChatSettingMemberTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifierMember];
            if (cell1 == nil) {
                cell1 = [[GroupChatSettingMemberTableViewCell alloc]
                         initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:GroupedTableIdentifierMember];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell1.textLabel.font = [UIFont systemFontOfSize:17.0];
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell1.frame = CGRectMake(0, 0, WIDTH, _headerViewHeight);
            [cell1 removeAllMember];
            
            [cell1 setMemberListFrame:CGRectMake(0, 0, WIDTH, _headerViewHeight) andArr:_memberWithAddArr showRemoveIcon:_isShowRemoveIcon];
            
            return cell1;
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"清空聊天记录";
            
            cell.detailTextLabel.text = [_gProfile objectForKey:@"name"];
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }else {
        // 群聊
        if(0 == [indexPath section] && 0 == [indexPath row]){
            // 成员列表
            static NSString *GroupedTableIdentifierMember = @"GroupedTableIdentifierMember";
            GroupChatSettingMemberTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifierMember];
            if (cell1 == nil) {
                cell1 = [[GroupChatSettingMemberTableViewCell alloc]
                         initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:GroupedTableIdentifierMember];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
                cell1.hiddenMomentsList = YES;
            }else {
                cell1.hiddenMomentsList = NO;
            }
            
            cell1.textLabel.font = [UIFont systemFontOfSize:17.0];
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell1.frame = CGRectMake(0, 0, WIDTH, _headerViewHeight);
            [cell1 removeAllMember];
            
            [cell1 setMemberListFrame:CGRectMake(0, 0, WIDTH, _headerViewHeight) andArr:_memberWithAddArr showRemoveIcon:_isShowRemoveIcon];
            
            return cell1;
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"群聊名称";
            
            cell.detailTextLabel.text = [_gProfile objectForKey:@"name"];
            cell.accessoryView = nil;
            
            if ([[_gProfile objectForKey:@"uid"] isEqualToString: [Utilities getUniqueUid]]) {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if (1 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"消息免打扰";
            cell.detailTextLabel.text = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UISwitch *push = [[UISwitch alloc] init];
            
#if 0
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *groupChatAlert = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"GroupChatAlert"]];
            if (([groupChatAlert isEqualToString:@"0"]) || (nil == groupChatAlert)) {
                push.on = NO;
                _groupChatAlert = @"0";
            } else {
                push.on = YES;
                _groupChatAlert = @"1";
            }
#endif
            
            if ([@"0"  isEqual: [_gProfile objectForKey:@"alert"]]) {
                push.on = NO;
            }else {
                push.on = YES;
                //            ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"聊天设置(%lu)🔕", (unsigned long)[_memberArr count]];
            }
            
            [push addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = push;
        }else if (1 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"保存到通讯录";
            cell.detailTextLabel.text = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *push = [[UISwitch alloc] init];
            
            if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [_gProfile objectForKey:@"contact"]]]) {
                push.on = NO;
            }else {
                push.on = YES;
            }
            
            [push addTarget:self action:@selector(switchActionContacts:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = push;
        }else if (2 == [indexPath section] && 0 == [indexPath row]){
            static NSString *GroupedTableIdentifier1 = @"GroupedTableIdentifier1";
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
            if (cell1 == nil) {
                cell1 = [[UITableViewCell alloc]
                         initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:GroupedTableIdentifier1];
                cell1.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            if ([[_gProfile objectForKey:@"uid"] isEqualToString: [Utilities getUniqueUid]]) {
                cell1.textLabel.text = @"解散并退出";
            }else {
                cell1.textLabel.text = @"删除并退出";
            }
            
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            
            // tbd.
            cell1.backgroundColor = [[UIColor alloc] initWithRed:229/255.0f green:51/255.0f blue:81/255.0f alpha:1.0];
            cell1.textLabel.textColor = [UIColor whiteColor];
            
            return cell1;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section = %ld, row = %ld", (long)[indexPath section], (long)[indexPath row]);
    
    if (1 == [indexPath section] && 0 == [indexPath row]){
        if ([@"0" isEqualToString:_gid]) {
            // 单聊
            TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"是否清除聊天记录？"];
            
            [alert addBtnTitle:@"取消" action:^{
                // nothing to do
            }];
            [alert addBtnTitle:@"确定清除" action:^{
                // done
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_CLEAR_CHAT_MESSAGES object:nil];//add by kate
                
                
            }];
            
            [alert showAlertWithSender:self];
            
        }else {
            // 群聊
            if ([[_gProfile objectForKey:@"uid"] isEqualToString: [Utilities getUniqueUid]]) {
                SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
                nameViewCtrl.gid = _gid;
                nameViewCtrl.fromName = @"groupChatSettingName";
                
                if ([@"未命名"  isEqual: [_gProfile objectForKey:@"name"]]) {
                    nameViewCtrl.groupChatName = @"";
                }else {
                    nameViewCtrl.groupChatName = [_gProfile objectForKey:@"name"];
                }
                
                [self.navigationController pushViewController:nameViewCtrl animated:YES];
            }
        }
    }else if (2 == [indexPath section] && 0 == [indexPath row]) {
        if ([[_gProfile objectForKey:@"uid"] isEqualToString: [Utilities getUniqueUid]]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"由于您是群主，退出后当前群聊将同时被解散，请慎重操作。"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定解散", nil];
            [alert show];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"退出后，将不再接收此群聊消息。"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定退出", nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"GroupChat",@"ac",
                              @"2",@"v",
                              @"leave", @"op",
                              _gid, @"gid",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                [Utilities showSuccessedHud:@"退出成功" descView:self.view];
                
                // Done :发消息通知群聊列表页，自己退出群更新数据库，群列表删除
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteGroupListCell" object:_gid];
                
                // 更新通讯录列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashContactsListView" object:nil];
                
                NSInteger type;
                //                if (nil != _chatList) {
                //                    type = _chatList.type;//add by kate 2016.07.11
                //                }else {
                type = 1;
                //                }
                
                if (0 == type) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteGroupListCellForTeacher" object:_gid];
                }
                
                // 退回到上个画面
                //[self.navigationController popViewControllerAnimated:YES];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                
            } else {
                NSString *msg = [respDic objectForKey:@"message"];
                [Utilities showFailedHud:msg descView:self.view];
            }
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }else{
        
        
    }
}

- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        // 打开
        NSLog(@"open");
#if 0
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"GroupChatAlert"];
#endif
        
        [_gProfile setValue:@"1" forKey:@"alert"];
        
        [super setCustomizeTitle:[NSString stringWithFormat:@"聊天设置(%@)🔕", [NSString stringWithFormat:@"%lu", (unsigned long)[_memberArr count]]]];
        
#if 0
        
        NSString *a = [NSString stringWithFormat:@"聊天设置(%@)🔕", [NSString stringWithFormat:@"%lu", (unsigned long)[_memberArr count]]];
        
        CGRect rect = ((UILabel *)self.navigationItem.titleView).frame;
        rect.size.width = rect.size.width;
        
        [((UILabel *)self.navigationItem.titleView) setFrame:rect];
        ((UILabel *)self.navigationItem.titleView).text = a;
        
#endif
    } else {
        // 关闭
        NSLog(@"close");
#if 0
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"0" forKey:@"GroupChatAlert"];
#endif
        
        [_gProfile setValue:@"0" forKey:@"alert"];
        
        [super setCustomizeTitle:[NSString stringWithFormat:@"聊天设置(%@)", [NSString stringWithFormat:@"%lu", (unsigned long)[_memberArr count]]]];
        
        //        ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"聊天设置(%lu)", (unsigned long)[_memberArr count]];
    }
}

- (void)switchActionContacts:(id)sender
{
    /**
     * 保存群聊为联系人
     * @author luke
     * @date 2016.01.15
     * @args
     *  v=2, ac=Contact, op=saveGroup, sid=, cid=, uid=, gid=群ID
     */
    
    /**
     * 删除群聊联系人
     * @author luke
     * @date 2016.01.15
     * @args
     *  v=2, ac=Contact, op=removeGroup, sid=, cid=, uid=, gid=群ID
     */
    
    // 保存到通讯录
    //    [Utilities showProcessingHud:self.view];
    
    NSString *op = @"";
    
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        // 打开
        op = @"saveGroup";
    } else {
        // 关闭
        op = @"removeGroup";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Contact",@"ac",
                          @"2",@"v",
                          op, @"op",
                          _gid, @"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            // 发通知更新通讯录列表页面
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteGroupListCell" object:_gid];
            
            if (isButtonOn) {
                // 打开
                [_gProfile setValue:@"1" forKey:@"contact"];
            } else {
                // 关闭
                [_gProfile setValue:@"0" forKey:@"alert"];
            }
            
            // 刷新ContactsListView
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashContactsListView" object:nil];
        } else {
            [Utilities showFailedHud:[respDic objectForKey:@"message"] descView:self.view];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
    
    
    
}

- (void)memBerListClickAction:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *tag = [dic objectForKey:@"tag"];
    
    NSDictionary *memberDic = [_memberWithAddArr objectAtIndex:[tag integerValue]];
    NSString *type = [memberDic objectForKey:@"type"];
    
    if (nil != type) {
        if ([@"add"  isEqual: type]) {
            // 到添加成员页面
#if 0
            LaunchGroupChatViewController *launchGroup = [[LaunchGroupChatViewController alloc] init];
            launchGroup.viewType = @"groupChatSetting";
            launchGroup.cid = [_gProfile objectForKey:@"cid"];
            
            NSMutableArray *uidArr = [[NSMutableArray alloc] init];
            for (id obj in _memberArr) {
                NSDictionary *dic = (NSDictionary *)obj;
                
                [uidArr addObject:[dic objectForKey:@"uid"]];
            }
            
            launchGroup.memberUidArr = uidArr;
            
            SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:launchGroup];
            [self presentViewController:nav animated:YES completion:nil];
#endif
            
            if (!_isShowRemoveIcon) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                GroupChatSettingMemberTableViewCell *cell = (GroupChatSettingMemberTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
                [cell setRemoveIconHidden:!_isShowRemoveIcon];
                _isShowRemoveIcon = !_isShowRemoveIcon;
            }
            
            ContactsViewController *vc = [[ContactsViewController alloc] init];
            vc.viewType = @"chatMemberSelect";
            
            //            if (nil != _chatList) {
            //                vc.type = _chatList.type;//add by kate 2016.07.11
            //            }else {
            //                vc.type = 1;
            //            }
            
            vc.cid = [_gProfile objectForKey:@"cid"];
            
            NSMutableArray *uidArr = [[NSMutableArray alloc] init];
#if 1
            NSMutableArray *sidArr = [[NSMutableArray alloc] init];
#endif
            for (id obj in _memberArr) {
                NSDictionary *dic = (NSDictionary *)obj;
                
                [uidArr addObject:[dic objectForKey:@"uid"]];
#if 1
                [sidArr addObject:[dic objectForKey:@"sid"]];
#endif
                
            }
            
            if ([@"0" isEqualToString:_gid]) {
                // 单聊
                vc.addToGroupChat = @"1";
                
                [uidArr addObject:[NSString stringWithFormat:@"%lld", _userObj.user_id]];
#if 1
                [sidArr addObject:[NSString stringWithFormat:@"%lld", _chatList.schoolID]];
#endif
                //                // 需要把自己也添加进去
                //                NSDictionary *user = [g_userInfo getUserDetailInfo];
                //                NSString *userUid = [user objectForKey:@"uid"];
                //                [uidArr addObject:userUid];
                
                vc.settingMembersArray = uidArr;
#if 1
                vc.settingSidArray = sidArr;
#endif
            }else {
                vc.settingMembersArray = uidArr;
#if 1
                vc.settingSidArray = sidArr;
#endif
            }
            
            _uidArray = [NSMutableArray arrayWithArray:uidArr];
            _sidArray = [NSMutableArray arrayWithArray:sidArr];
            
            SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }else if ([@"remove"  isEqual: type]) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            
            GroupChatSettingMemberTableViewCell *cell = (GroupChatSettingMemberTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
            [cell setRemoveIconHidden:!_isShowRemoveIcon];
            _isShowRemoveIcon = !_isShowRemoveIcon;
        }
    }else {
        
        if (![_viewType isEqualToString:@"hiddenMomentsList"]) {
            NSString *uid = [memberDic objectForKey:@"uid"];
            
            if (uid) {
                FriendProfileViewController *fpvc = [[FriendProfileViewController alloc] init];
                fpvc.fuid = uid;
                
#if 1
                if ([@"0" isEqualToString:_gid]) {
                    // 单聊
                    if (![G_SCHOOL_ID isEqualToString:[NSString stringWithFormat:@"%lld", _userObj.schoolID]]) {
                        fpvc.fsid = [NSString stringWithFormat:@"%lld", _userObj.schoolID];
                    }
                }else {
                    // 群聊
                    if (![G_SCHOOL_ID isEqualToString:[memberDic objectForKey:@"sid"]]) {
                        fpvc.fsid = [NSString stringWithFormat:@"%@", [memberDic objectForKey:@"sid"]];
                    }
                }
#endif
                
                [self.navigationController pushViewController:fpvc animated:YES];
            }
        }
    }
}

- (void)addMemberAction:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSArray *selectMembers = [dic objectForKey:@"uidList"];
    
    NSMutableArray *uidList = [[NSMutableArray alloc] init];
    NSMutableArray *sidList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[selectMembers count]; i++ ) {
        
        NSMutableArray *list = [selectMembers objectAtIndex:i];
        
        for (int j =0; j<[list count]; j++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
            NSString *isChecked = [dic objectForKey:@"isChecked"];
            NSString *isNail = [dic objectForKey:@"nail"];
            
            if (![@"1"  isEqual: isNail]) {
                if ([isChecked integerValue] == 1) {
                    [uidList addObject:[dic objectForKey:@"uid"]];
                    [sidList addObject:[dic objectForKey:@"sid"]];
                }
            }
        }
    }
    
    if (0 != [uidList count]) {
        [Utilities showProcessingHud:self.view];
        
        //        NSString * uidListStr = [uidList componentsJoinedByString:@","];
        
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger i = 0; i < uidList.count; i++) {
            NSString *tempStr = [NSString stringWithFormat:@"%@:%@",  sidList[i], uidList[i]];
            [tempArr addObject:tempStr];
        }
        
        NSString * uidListStr = [tempArr componentsJoinedByString:@","];
        
        /**
         * 发起群聊天：创建群
         * 2016.07.05 添加新参数type:标示群聊类型- 0 管理组, 1 普通群聊, 2 班级群聊(请确保cid>0)
         * @author luke
         * @date    2015.05.26
         * @args
         *  ac=GroupChat v= 2 op=setup, sid=, cid=, uid=, members=uid,... type=
         */
        
        
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"GroupChat",@"ac",
                              @"2",@"v",
                              @"invite", @"op",
                              _gid, @"gid",
                              uidListStr, @"members",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                
                NSDictionary *chatDic = [respDic objectForKey:@"message"];
                NSString *gid = [chatDic objectForKey:@"gid"];
                _gid = gid;
                
                [Utilities showSuccessedHud:@"添加成功" descView:self.view];
                
                [_memberArr removeAllObjects];
                [_memberWithAddArr removeAllObjects];
                [_gProfile removeAllObjects];
                
                [self doGetGroupProfile];
                
                //---add by kate 2015.06.11---------------------------------------------------------------------------
                [self reGetHeadUrl];
                // To do:更新数据库
                NSLog(@"respDic:%@",respDic);
                
                /*
                 {
                 message =     {
                 gid = 489;
                 message =         {
                 avatar = "http://test.5xiaoyuan.cn/ucenter/avatar.php?uid=63255&size=big&type=&timestamp=1427860027";
                 cid = 6102;
                 dateline = 1434019924;
                 gid = 489;
                 message = "\U4e1b\U5343\U91cc\U9080\U8bf7\U4e86t0000001\U52a0\U5165\U7fa4\U804a";
                 mid = 11162;
                 msgid = 1434083179;
                 name = "\U4e1b\U5343\U91cc";
                 type = 12;
                 uid = 63255;
                 url = "";
                 };
                 uid = 63255;
                 };
                 protocol = "GroupChatAction.invite";
                 result = 1;
                 }
                 */
                
                NSDictionary *msg = [respDic objectForKey:@"message"];
                [self updateDB:msg];
                //------------------------------------------------------------------------------------------------------
                
                
            } else {
                NSString *msg = [respDic objectForKey:@"message"];
                [Utilities showFailedHud:msg descView:self.view];
            }
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
    
    
    //    NSDictionary *memberDic = [_memberArr objectAtIndex:[tag integerValue]];
    //    NSString *type = [memberDic objectForKey:@"type"];
    
}

- (void)removeMemBerListClickAction:(NSNotification *)notification
{
    if ([_viewType isEqualToString:@"hiddenMomentsList"]) {
        
        NSDictionary *dic = [notification userInfo];
        NSString *tag = [dic objectForKey:@"tag"];
        
        NSDictionary *infoDic = [_memberWithAddArr objectAtIndex:[tag integerValue]];
        NSString *infoUid = [infoDic objectForKey:@"uid"];
        
        [_hiddenMomentsArr addObject:infoUid];
        
        [_memberWithAddArr removeObjectAtIndex:[tag integerValue]];
        [_memberArr removeObjectAtIndex:[tag integerValue]];
        
        // 重新计算群成员个数，计算出cell0的高度
        NSInteger row = 0;
        if (iPhone6p || iPhone6) {
            // 计算群成员个数，计算出headerview的高度
            if ([_memberWithAddArr count]%5 != 0) {
                row = [_memberWithAddArr count]/5 + 1;
            }else {
                row = [_memberWithAddArr count]/5;
            }
            
            _headerViewHeight = row*(90+16) + 16;
        }else {
            // 计算群成员个数，计算出headerview的高度
            if ([_memberWithAddArr count]%4 != 0) {
                row = [_memberWithAddArr count]/4 + 1;
            }else {
                row = [_memberWithAddArr count]/4;
            }
            
            _headerViewHeight = row*(90+16) + 16;
        }
        
        [_tableView reloadData];
        
        //((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"不看Ta的师生圈(%lu)", (unsigned long)[_memberArr count]];
        [super setCustomizeTitle:[NSString stringWithFormat:@"不看Ta的师生圈(%lu)", (unsigned long)[_memberArr count]]];
        
        
        [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = YES;
        [super setCustomizeRightButtonWithName:@"完成" color:[UIColor whiteColor]];
    }else {
        NSDictionary *dic = [notification userInfo];
        NSString *tag = [dic objectForKey:@"tag"];
        
        NSDictionary *infoDic = [_memberWithAddArr objectAtIndex:[tag integerValue]];
        NSString *infoUid = [infoDic objectForKey:@"uid"];
        
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"GroupChat",@"ac",
                              @"2",@"v",
                              @"remove", @"op",
                              _gid, @"gid",
                              infoUid, @"member",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                [Utilities showSuccessedHud:@"移除成功" descView:self.view];
                
                [_memberWithAddArr removeObjectAtIndex:[tag integerValue]];
                [_memberArr removeObjectAtIndex:[tag integerValue]];
                
                // 重新计算群成员个数，计算出cell0的高度
                NSInteger row = 0;
                if (iPhone6p || iPhone6) {
                    // 计算群成员个数，计算出headerview的高度
                    if ([_memberWithAddArr count]%5 != 0) {
                        row = [_memberWithAddArr count]/5 + 1;
                    }else {
                        row = [_memberWithAddArr count]/5;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }else {
                    // 计算群成员个数，计算出headerview的高度
                    if ([_memberWithAddArr count]%4 != 0) {
                        row = [_memberWithAddArr count]/4 + 1;
                    }else {
                        row = [_memberWithAddArr count]/4;
                    }
                    
                    _headerViewHeight = row*(90+16) + 16;
                }
                
                // 刷新tableView
                [_tableView reloadData];
                
                //---add by kate 2015.06.09---------------------------------------------------------------------------------
                [self reGetHeadUrl];
                // To do:更新数据库
                NSDictionary *msg = [respDic objectForKey:@"message"];
                [self updateDB:msg];
                //----------------------------------------------------------------------------------------------------------
                
            } else {
                NSString *msg = [respDic objectForKey:@"message"];
                [Utilities showFailedHud:msg descView:self.view];
            }
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
}

- (void)changeGroupName:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *name = [dic objectForKey:@"name"];
    
    [_gProfile setObject:name forKey:@"name"];
    
    // 刷新tableView
    [_tableView reloadData];
    
    //---update by kate 2016.01.25--------
    //通知聊天详情页修改名字
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitleName" object:name];
    //更新数据库名字
    _chatList.title = name;
    [_chatList updateGroupName];
    //---------------------------------
}

- (void)settingChatToGroupChat:(NSNotification *)notification
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
}

// 移除或邀请成员，重新获取头像url
-(void)reGetHeadUrl{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          [NSString stringWithFormat:@"%lli",[_gid longLongValue]],@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            //群聊数量
            NSString *memberNum = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"member"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserNumer" object:memberNum];
            
            GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
            headObject.gid = [_gid longLongValue];
            [headObject deleteData];
            
            for (int i =0; i<[tempArray count]; i++) {
                
                long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                
                headObject.user_id = headUid;
                headObject.headUrl = headUrl;
                headObject.name = name;
                [headObject insertData];
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeHeadArray" object:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

// 删除或移除成员后更新群聊数据库
-(void)updateDB:(NSDictionary*)msg{
    
    NSDictionary *subMsg = [msg objectForKey:@"message"];
    
    long long userid = [[msg objectForKey:@"uid"] longLongValue];
    NSString *gid = [NSString stringWithFormat:@"%@",[msg objectForKey:@"gid"]];
    NSString *userName = [subMsg objectForKey:@"name"];// 人名
    NSString *mid = [NSString stringWithFormat:@"%@",[subMsg objectForKey:@"mid"]];
    //消息类型-文本
    NSInteger msgType = [[subMsg objectForKey:@"type"] integerValue];
    
    // 更新数据库
    MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
    // 消息的msgID
    chatDetail.msg_id = [[subMsg objectForKey:@"msgid"] longLongValue];
    chatDetail.user_id = userid;
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
    
    if (msgType == 10 || msgType == 12 ) {
        chatDetail.msg_type = 3;
    }else if (msgType == 13){
        chatDetail.msg_type = 4;
    }else if (msgType == 14){
        chatDetail.msg_type = 5;
    }else{
        chatDetail.msg_type = msgType;
    }
    
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
    // 消息内容
    if (chatDetail.msg_type == MSG_TYPE_PIC) {
        chatDetail.msg_content = @"[图片]";
        // 原始图片文件的HTTP-URL地址
        chatDetail.pic_url_thumb = [Utilities replaceNull:[subMsg objectForKey:@"url"]];
        chatDetail.pic_url_original = [Utilities replaceNull:[subMsg objectForKey:@"url"]];
    }else if(chatDetail.msg_type == MSG_TYPE_Audio){
        chatDetail.msg_content = @"[语音]";
        chatDetail.audio_url = [Utilities replaceNull:[subMsg objectForKey:@"url"]];
    }else {
        chatDetail.msg_content = [Utilities replaceNull:[subMsg objectForKey:@"message"]];
    }
    
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = @"";
    NSString *timestampStr = [Utilities replaceNull:[subMsg objectForKey:@"dateline"]];
    chatDetail.timestamp = [timestampStr longLongValue]*1000;
    //NSLog(@"timestamp:%lli",chatDetail.timestamp);
    chatDetail.cid = [[Utilities replaceNull:[subMsg objectForKey:@"cid"]] longLongValue];
    chatDetail.groupid = [[Utilities replaceNull:gid] longLongValue];
    chatDetail.headimgurl = [subMsg objectForKey:@"avatar"];
    [chatDetail updateToDB];
    
    MixChatListObject *chatList = [[MixChatListObject alloc] init];
    chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", userid];
    chatList.cid = chatDetail.cid;
    chatList.gid = chatDetail.groupid;
    chatList.is_recieved = MSG_IO_FLG_RECEIVE;
    //最后一条消息ID
    chatList.last_msg_id= chatDetail.msg_id;
    // 聊天的最后一条消息的类型
    chatList.last_msg_type= chatDetail.msg_type;
    // 聊天的最后一条消息内容
    if (msgType!= 10 && msgType!= 12 && msgType!= 13 && msgType!= 14) {
        chatList.last_msg = [NSString stringWithFormat:@"%@:%@",userName,chatDetail.msg_content];
        
    }else{
        chatList.last_msg = chatDetail.msg_content;
        
    }
    //该条消息状态
    chatList.msg_state = MSG_RECEIVED_SUCCESS;
    chatList.user_id = 0;
    chatList.mid = mid;//add 2015.01.25
    //时间戳
    chatList.timestamp = chatDetail.timestamp;
    [chatList updateToDB];
    
}

@end

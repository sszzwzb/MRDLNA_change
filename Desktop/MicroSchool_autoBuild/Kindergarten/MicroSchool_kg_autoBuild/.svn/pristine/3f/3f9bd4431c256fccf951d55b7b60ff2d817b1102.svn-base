//
//  LaunchGroupChatViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "LaunchGroupChatViewController.h"
#import "FriendMultiSelectTableViewCell.h"
#import "GroupChatList.h"
#import "GroupChatDetailObject.h"
#import "GroupChatMemberListCell.h"
#import "GroupChatListHeadObject.h"

@interface LaunchGroupChatViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
- (IBAction)ChooseAll:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *allImgV;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UIButton *chooseAllBtn;

@end

@implementation LaunchGroupChatViewController
@synthesize mySearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([@"groupChatSetting"  isEqual: _viewType]) {
        [self setCustomizeTitle:@"选择联系人"];
    }else {
        [self setCustomizeTitle:@"发起群聊"];
    }
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    _finishBtn.layer.cornerRadius = 5.0;
    _finishBtn.layer.masksToBounds = YES;
   
    
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:232.0/255.0 alpha:1];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    searchResults = [[NSMutableArray alloc]init];

    //count = 0;
    
    headArray = [[NSMutableArray alloc]init];
    
    [self getData];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*-(void)selectRightAction:(id)sender{
    
    if ([@"groupChatSetting"  isEqual: _viewType]) {
        // 这里放新增加的群成员的uid列表
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             checkListArray, @"uidList",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_ADDMEMBER object:self userInfo:dic];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        //To do:创建群聊
        NSString *members = @"";
        
        for (int i=0; i<[checkListArray count]; i++ ) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                
                if ([isChecked integerValue] == 1) {
                    
                    NSString *item = [dic objectForKey:@"uid"];
                    if ([members length] == 0) {
                        members = item;
                    }
                    members = [NSString stringWithFormat:@"%@,%@",members,item];
                    
                }
            }
            
        }
        
        [self createGroup:members];
    }

    
}*/

// 创建群
-(void)createGroup:(NSString*)members{
    
    /**
     * 发起群聊天：创建群
     * 1. 教师
     * @author luke
     * @date    2015.05.26
     * @args
     *  op=setup, sid=, cid=, uid=, members=uid,...
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"setup", @"op",
                          _cid,@"cid",
                          members,@"members",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        /*
         respDic:{
         message =     {
         gid = 143;
         message =         {
         avatar = "http://test.5xiaoyuan.cn/ucenter/avatar.php?uid=63255&size=big&type=&timestamp=1427860027";
         cid = 6089;
         dateline = 1432815046;
         gid = 143;
         message = "\U7fa4\U521b\U5efa\U6210\U529f";
         mid = 6392;
         msgid = 1432878301;
         name = "\U4e1b\U5343\U91cc";
         type = 10;
         uid = 63255;
         url = "";
         };
         uid = 63255;
         name = "\U7fa4\U804a";
         };
         protocol = "GroupChatAction.setup";
         result = 1;
         }
         */
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSDictionary *subDic = [dic objectForKey:@"message"];
            // 群id
            NSString *gid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"gid"]]];
            // 发送方uid
            NSString *sendUid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]]];
            // 群名字
            NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
            // 班级id
            NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"cid"]]];
            // 发送方头像
            //NSString *avatar = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"avatar"]]];
            // 时间戳
            NSString *timestamp =[Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"dateline"]]];
            // 接收的消息
            NSString *msg_content = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"message"]]];
            // 消息类型
           // NSString *type = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"type"]]];
            // 服务器返回的最后一条消息id
            NSString *mid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"type"]]];
            // 消息id
            NSString *msgid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"msgid"]]];

            
            //To do:更新数据库
            
            GroupChatDetailObject *groupChatDetailObject = [[GroupChatDetailObject alloc] init];
            groupChatDetailObject.groupid = [gid longLongValue];
            groupChatDetailObject.cid = [cid longLongValue];
            groupChatDetailObject.msg_content = msg_content;
            groupChatDetailObject.msg_type = 3;//创建群
            groupChatDetailObject.msg_id = [msgid longLongValue];
            groupChatDetailObject.is_recieved = MSG_IO_FLG_RECEIVE;
            groupChatDetailObject.msg_state = MSG_RECEIVED_SUCCESS;
            groupChatDetailObject.timestamp = [timestamp longLongValue]*1000;
            groupChatDetailObject.user_id = [sendUid longLongValue];
            NSLog(@"content:%@",groupChatDetailObject.msg_content);
            [groupChatDetailObject updateToDB];
            
            GroupChatList *groupChatListObject = [[GroupChatList alloc] init];
            groupChatListObject.bother = 0;
            groupChatListObject.gid = [gid longLongValue];
            groupChatListObject.cid = [cid longLongValue];
            groupChatListObject.user_id = groupChatDetailObject.user_id;
            groupChatListObject.is_recieved = MSG_IO_FLG_RECEIVE;
            //最后一条消息ID
            groupChatListObject.last_msg_id= groupChatDetailObject.msg_id;
            // 聊天的最后一条消息的类型
            groupChatListObject.last_msg_type= groupChatDetailObject.msg_type;
            // 聊天的最后一条消息内容
            groupChatListObject.last_msg = groupChatDetailObject.msg_content;
            //该条消息状态
            groupChatListObject.msg_state = MSG_RECEIVED_SUCCESS;
            groupChatListObject.mid = mid;
            groupChatListObject.title = name;// 群名字
            groupChatListObject.timestamp = groupChatDetailObject.timestamp;
            BOOL isExist = [groupChatListObject updateToDB];
            [groupChatListObject updateGroupName];
            
            // 获取群头像url存在一个数据表中，判断chatList中是否有gid了，如果没有就拉取群头像，有就不拉
            if (!isExist) {//不存在
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"GroupChat",@"ac",
                                      @"2",@"v",
                                      @"getGroupAvatar", @"op",
                                      [NSString stringWithFormat:@"%lli",groupChatListObject.gid],@"gid",
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
                        headObject.gid = groupChatListObject.gid;
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
                        
                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP object:nil];
                        
                    }
                    
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                    
                }];
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoGroupChatDetail" object:groupChatListObject];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[respDic objectForKey:@"message"]                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];

}

-(void)getData{
    
    /**
     * 班级成员分组列表
     * @author luke
     * @date 2015.05.27
     * @args
     *  ac=GroupChat, v=2, op=getClassMembers, sid=, uid=, cid=
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getClassMembers", @"op",
                          _cid,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
           listDataArray = [[NSMutableArray alloc] initWithArray:[respDic objectForKey:@"message"] copyItems:YES];
           checkListArray = [[NSMutableArray alloc] init];
           checkSectionArray = [[NSMutableArray alloc] init];
            rowCount = 0;
            
            
            for (int i =0; i<[listDataArray count]; i++) {
                
                NSInteger sectionListCount = 0;

                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                
                for (int j=0; j<[(NSArray*)[[listDataArray objectAtIndex:i] objectForKey:@"list"] count]; j++){
                    
                    
                  NSString *uid = [[[[listDataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"uid"];
                    
                    NSString *name = [[[[listDataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"name"];
                    
                    NSString* head_url = [[[[listDataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"avatar"];
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar", nil];
                   
                    [subArray addObject:dic];
                    
                    rowCount ++;
                    sectionListCount ++;
                }
                
                [checkListArray addObject:subArray];
                
                NSDictionary *checkSectionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil];
                [checkSectionArray addObject:checkSectionDic];
                
                NSInteger selectSectionListCount = 0;
                if ([@"groupChatSetting"  isEqual: _viewType]) {
                    if (0 != [_memberUidArr count]) {
                        for(id obj in _memberUidArr) {
                            NSString *memberUid = (NSString *)obj;
                            
                            NSInteger uidPos = -1;
                            NSInteger uidPos1 = -1;

                            for (NSInteger i=0; i<[checkListArray count]; i++) {
                                NSArray *subArr = [checkListArray objectAtIndex:i];

                                for (NSInteger j=0; j<[subArr count]; j++) {
                                    NSDictionary *dic = [subArr objectAtIndex:j];
                                    NSString *checkListUid = [dic objectForKey:@"uid"];

                                    if ([memberUid isEqual: checkListUid]) {
                                        uidPos = i;
                                        uidPos1 = j;
                                        break;
                                    }
                                }
                                
                                if (-1 != uidPos) {
                                    [[[checkListArray objectAtIndex:uidPos] objectAtIndex:uidPos1] setValue:@"1" forKey:@"isChecked"];
                                    [[[checkListArray objectAtIndex:uidPos] objectAtIndex:uidPos1] setValue:@"1" forKey:@"nail"];
                                }
                                
                                selectSectionListCount ++;
                            }
                        }
                        
                        NSArray *a = [checkListArray objectAtIndex:i];
                        
                        NSInteger selCnt = 0;
                        for (id obj in a) {
                            NSDictionary *arr = (NSDictionary *)obj;
                            NSString *isNail = [arr objectForKey:@"nail"];
                            
                            if ([@"1" isEqual:isNail]) {
                                selCnt ++;
                            }
                        }
                        
                        // 如果传入的uidList里面满足了一个组都被选择的情况，则需要把组的nail设置为1
                        if (selCnt == [a count]) {
                            [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"1", @"nail", nil]];
                        }
                    }
                }else {
                }
            }
            
           [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[respDic objectForKey:@"message"]                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

-(void)reload{
    
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       return 1;
    }else{
       return [listDataArray count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return  [searchResults count];
    }else{
         return [(NSArray*)[[listDataArray objectAtIndex:section] objectForKey:@"list"] count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       return @"";
    }else{
        return [[listDataArray objectAtIndex:section] objectForKey:@"role"];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.0;
    }else{
        return 35.0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
    }else{
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35.0)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-160.0, 35.0)];
        titleLabel.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listDataArray objectAtIndex:section] objectForKey:@"role"]]];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:titleLabel];
        
        // 下边的线
        UIImageView *lineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, view.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1)];
        lineImgV.image = [UIImage imageNamed:@"lineRed.png"];
        [view addSubview:lineImgV];
        
        if (section > 0) {
            //上边的线
            UIImageView *lineImgVUp = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
            lineImgVUp.image = [UIImage imageNamed:@"lineSystem.png"];
            [view addSubview:lineImgVUp];
            
        }
        
        UILabel *chooseAllLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 114.0, 0, 60.0, 35.0)];
        chooseAllLabel.text = @"选择全部";
        chooseAllLabel.font = [UIFont systemFontOfSize:14.0];
        chooseAllLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:chooseAllLabel];
        
        //需要判断一下是否这个section下全选中了，如果全选中了，用选中后的图片
        UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-47.0, (35.0-16.0)/2.0, 16.0, 16.0)];
        
        if ([[[checkSectionArray objectAtIndex:section] objectForKey:@"isChecked"] integerValue] == 1) {
            checkImageView.image = [UIImage imageNamed:@"rb_gander_p_02.png"];
        }else{
            checkImageView.image = [UIImage imageNamed:@"rb_gander_d_02.png"];
        }
        
        [view addSubview:checkImageView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60.0, 0, 50, 35.0);
        btn.tag = section;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        // 判断是否是前画面传入的section被选择了，如果被选择则不让点击，并设置灰色图片
        if ([[[checkSectionArray objectAtIndex:section] objectForKey:@"nail"] integerValue] == 1) {
            btn.enabled = NO;
            checkImageView.image = [UIImage imageNamed:@"rb_gander_ee"];
        }else {
            btn.enabled = YES;
        }
      
    }

    return view;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
  
    GroupChatMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
            cell = [[GroupChatMemberListCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        
        NSDictionary *dic = [searchResults objectAtIndex:indexPath.row];
        NSString* head_url = [dic objectForKey:@"avatar"];
        NSString *isCheck = [dic objectForKey:@"isChecked"];
        [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        cell.name = [Utilities replaceNull:[dic objectForKey:@"name"]];
        NSString *nail = [dic objectForKey:@"nail"];
        if ([nail integerValue] == 1) {
            
            [cell setChecked:2];
            
        }else{
           
            if ([isCheck integerValue] == 1) {
                [cell setChecked:1];
            }else{
                [cell setChecked:0];
            }
            
        }
        
    }else{
        
        NSArray *array = [[listDataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        NSString* head_url = [dic objectForKey:@"avatar"];
        [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        cell.name = [Utilities replaceNull:[dic objectForKey:@"name"]];
        
        NSString *nail = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nail"];
        
        if ([nail integerValue] == 1) {
            
            [cell setChecked:2];
            
        }else{
            
            NSString *isCheck = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
            
            if ([isCheck integerValue] == 1) {
                [cell setChecked:1];
            }else{
                [cell setChecked:0];
            }
            
        }
        
        // 计算右上角数量
        NSInteger checkCount = 0;
        NSInteger nailCount = 0;
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    NSString *isChecked = [dic objectForKey:@"isChecked"];
                    
                    if ([isChecked integerValue] == 1) {
                        checkCount ++;
                    }
                }else {
                 
                    nailCount++;
                }
            }
        }
        
        if (nailCount == rowCount) {
            
             _allImgV.image = [UIImage imageNamed:@"rb_gander_ee.png"];
             _chooseAllBtn.userInteractionEnabled = NO;
            
        }else{
            
            _chooseAllBtn.userInteractionEnabled = YES;

        }
        
        if (checkCount == 0) {
            
            //[self setCustomizeRightButtonWithName:@"" font:[UIFont systemFontOfSize:15.0]];
            [_finishBtn setBackgroundColor:[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:194.0/255.0 alpha:1]];
            [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
            [_finishBtn setUserInteractionEnabled:NO];
            
        }else {
            
            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"完成(%ld)", (long)checkCount] font:[UIFont systemFontOfSize:15.0]];
            [_finishBtn setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1]];
            [_finishBtn setTitle:[NSString stringWithFormat:@"完成(%ld)", (long)checkCount] forState:UIControlStateNormal];
            [_finishBtn setUserInteractionEnabled:YES];
            
        }
    }
    
    return cell;
}


//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        // 变更searchResults数据选中情况，更新checkList选中情况
         NSDictionary *dic = [searchResults objectAtIndex:indexPath.row];
         NSString *nail = [dic objectForKey:@"nail"];
         NSString *isCheck = [dic objectForKey:@"isChecked"];
         NSString *uid = [dic objectForKey:@"uid"];
         NSString *name =[dic objectForKey:@"name"];
         NSString *head_url = [dic objectForKey:@"avatar"];
        
        if ([nail integerValue] != 1) {
            
            if ([isCheck integerValue]!=1) {
                
                NSDictionary *newDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",nail, @"nail",head_url,@"avatar",nil];
                [searchResults replaceObjectAtIndex:indexPath.row withObject:newDic];
                
                for (int i = 0; i<[checkListArray count]; i++) {
                    
                    NSArray *list = [checkListArray objectAtIndex:i];
                    
                    for (int j=0; j<[list count]; j++) {
                        
                        NSString *user_id =[[list objectAtIndex:j] objectForKey:@"uid"];
                        
                        if ([user_id isEqualToString:uid]) {
                             [[checkListArray objectAtIndex:i] replaceObjectAtIndex:j withObject:newDic];
                        }
                        
                        
                    }
                    
                }
                
                //---section选中情况-----------------------------------------------------
                int sectionCount = 0;
                for (int i = 0; i<[checkListArray count]; i++) {
                    
                   NSMutableArray *list = [checkListArray objectAtIndex:i];
                   for (int j =0; j<[list count]; j++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    NSString *isChecked = [dic objectForKey:@"isChecked"];
                    
                    if ([isChecked integerValue] == 1) {
                        
                        sectionCount ++;
                        
                      }
                   }
                
                   NSLog(@"sectionCount=%d,listCount=%lu",sectionCount,(unsigned long)[list count]);
                  if (sectionCount == [list count]) {
                    [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", nail, @"nail", nil]];
                  }
                }
            
                //---全选按钮以及连带影响的section选中情况------------------------------------------------
                int checkCount = 0;
                for (int i = 0; i<[checkListArray count]; i++) {
                    
                    NSMutableArray *list = [checkListArray objectAtIndex:i];
                    
                    for (int j =0; j<[list count]; j++) {
                        
                        NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                        
                        if (![@"1"  isEqual: nail]) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                            NSString *isChecked = [dic objectForKey:@"isChecked"];
                            
                            if ([isChecked integerValue] == 1) {
                                
                                checkCount ++;
                                
                            }
                        }else {
                            
                        }
                        
                    }
                    
                }
                
                if (checkCount == rowCount) {
                    
                    _allImgV.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
                    
                    for (int i =0; i<[checkListArray count]; i++) {
                        [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", nail, @"nail", nil]];
                    }
                    
                }
                //--------------------------------------------------------------------------------------
                
            }
        }
        
        searchDisplayController.active = NO;
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    }else{
        //-----每行的选中情况-------------------------------
        NSArray *array = [[listDataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
        NSDictionary *diction = [array objectAtIndex:indexPath.row];
        NSString *uid = [Utilities replaceNull:[diction objectForKey:@"uid"]];
        NSString *name =[Utilities replaceNull:[diction objectForKey:@"name"]];
        NSString *head_url = [Utilities replaceNull:[diction objectForKey:@"avatar"]];
        
        NSDictionary *dic = nil;
        
        NSString *nail = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nail"];
        
        if (![@"1"  isEqual: nail]) {
            NSString *isCheck = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
            
            if ([isCheck integerValue] ==1) {
                
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar",nil];
                UIImage *img1 = [UIImage imageNamed:@"rb_gander_d_01.png"];
                
                if (![Utilities image:_allImgV.image equalsTo:img1]) {// 取消其中一个，这时将全选勾选去掉
                    _allImgV.image = [UIImage imageNamed:@"rb_gander_d_01.png"];
                }
                
                
            }else{
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar",nil];
            }
            
            [[checkListArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:dic];
            
            //---全选按钮以及连带影响的section选中情况-----------------------------------
            int checkCount = 0;
            for (int i = 0; i<[checkListArray count]; i++) {
                
                NSMutableArray *list = [checkListArray objectAtIndex:i];
                
                for (int j =0; j<[list count]; j++) {
                    
                    NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                    
                    if (![@"1"  isEqual: nail]) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                        NSString *isChecked = [dic objectForKey:@"isChecked"];
                        
                        if ([isChecked integerValue] == 1) {
                            
                            checkCount ++;
                            
                        }
                    }else {
                        
                    }
                    
                }
                
            }
            
            if (checkCount == rowCount) {
                _allImgV.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
                
                for (int i =0; i<[checkListArray count]; i++) {
                    [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
                }
                
            }else{
                _allImgV.image = [UIImage imageNamed:@"rb_gander_d_01.png"];
                [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
            }
            
            
            //---section选中情况-----------------------------------------------------
            int sectionCount = 0;
            NSMutableArray *list = [checkListArray objectAtIndex:indexPath.section];
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                
                if ([isChecked integerValue] == 1) {
                    
                    sectionCount ++;
                    
                }
            }
            
            NSLog(@"sectionCount=%d,listCount=%lu",sectionCount,(unsigned long)[list count]);
            
            if (sectionCount == [list count]) {
                [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
            }else{
                [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
            }
            
#if 0
            //----右上角完成按钮的显示，显示选中数量
            if (checkCount > 0) {
                
                NSString *str = [NSString stringWithFormat:@"完成(%d)",checkCount];
                
                [self setCustomizeRightButtonWithName:str font:[UIFont systemFontOfSize:15.0]];
            }
#endif
            
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        }
    }
    
    [self addHeadBtnToScrollView];
}

// headerView 点击选择全部
- (IBAction)ChooseAll:(id)sender {
    
    
    UIImage *img1 = [UIImage imageNamed:@"rb_gander_d_01.png"];
    
    if ([Utilities image:_allImgV.image equalsTo:img1]) {// 全选
    
          _allImgV.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
        
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    [dic setObject:@"1" forKey:@"isChecked"];
                    
                    [list replaceObjectAtIndex:j withObject:dic];
                }else {
                    
                }
            }
            
            [checkListArray replaceObjectAtIndex:i withObject:list];
            
            NSDictionary *dic = [checkSectionArray objectAtIndex:i];
            if (![@"1"  isEqual: [dic objectForKey:@"nail"]]) {
                [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
            }
        }
        
#if 0
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];

        //---计算选中数量-------------------------------------------
        int checkCount = 0;
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    NSString *isChecked = [dic objectForKey:@"isChecked"];
                    
                    if ([isChecked integerValue] == 1) {
                        
                        checkCount ++;
                        
                    }
                }else {
                    
                }
                
            }
            
        }

        if (checkCount > 0) {
            
            NSString *str = [NSString stringWithFormat:@"完成(%d)",checkCount];
            
            [self setCustomizeRightButtonWithName:str font:[UIFont systemFontOfSize:15.0]];
        }
#endif
        
    }else{// 取消全选
        
        _allImgV.image = [UIImage imageNamed:@"rb_gander_d_01.png"];
        
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    [dic setObject:@"0" forKey:@"isChecked"];
                    
                    [list replaceObjectAtIndex:j withObject:dic];
                }else {
                    
                }

            }
            
            [checkListArray replaceObjectAtIndex:i withObject:list];
            
            NSDictionary *dic = [checkSectionArray objectAtIndex:i];
            if (![@"1"  isEqual: [dic objectForKey:@"nail"]]) {
                [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
            }

            
        }
#if 0
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];

        [self setCustomizeRightButtonWithName:@"" font:[UIFont systemFontOfSize:15.0]];
#endif
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    [self addHeadBtnToScrollView];
}

// 点击section
-(void)clickSection:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger section = btn.tag;
    
    if ([[[checkSectionArray objectAtIndex:section] objectForKey:@"isChecked"] integerValue] == 0) {// 选中
        NSMutableArray *list = [checkListArray objectAtIndex:section];
        
        for (int j =0; j<[list count]; j++) {
            
            NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
            
            if (![@"1"  isEqual: nail]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                [dic setObject:@"1" forKey:@"isChecked"];
                
                [list replaceObjectAtIndex:j withObject:dic];
            }else {
                
            }

        }
        
        [checkListArray replaceObjectAtIndex:section withObject:list];
        [checkSectionArray replaceObjectAtIndex:section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
        
#if 0

        //---计算选中数量-------------------------------------------
        int checkCount = 0;
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    NSString *isChecked = [dic objectForKey:@"isChecked"];
                    
                    if ([isChecked integerValue] == 1) {
                        
                        checkCount ++;
                        
                    }
                }else {
                    
                }

            }
            
        }
        
        NSString *str = [NSString stringWithFormat:@"完成(%d)",checkCount];
        [self setCustomizeRightButtonWithName:str font:[UIFont systemFontOfSize:15.0]];
        
        //---------------------------------------------------------------
#endif
    }else{// 取消选中
        
        NSMutableArray *list = [checkListArray objectAtIndex:section];
        
        for (int j =0; j<[list count]; j++) {
            
            NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
            
            if (![@"1"  isEqual: nail]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                [dic setObject:@"0" forKey:@"isChecked"];
                
                [list replaceObjectAtIndex:j withObject:dic];
            }else {
                
            }

        }
        
        [checkListArray replaceObjectAtIndex:section withObject:list];
        [checkSectionArray replaceObjectAtIndex:section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
        
#if 0

        //---计算选中数量-------------------------------------------
        int checkCount = 0;
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                
                if (![@"1"  isEqual: nail]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                    NSString *isChecked = [dic objectForKey:@"isChecked"];
                    
                    if ([isChecked integerValue] == 1) {
                        
                        checkCount ++;
                        
                    }
                }else {
                    
                }

            }
            
        }
        
        if (checkCount == 0) {
           
            [self setCustomizeRightButtonWithName:@"" font:[UIFont systemFontOfSize:15.0]];
        }else {
            [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%d", checkCount] font:[UIFont systemFontOfSize:15.0]];
        }
       
        //---------------------------------------------------------------
#endif

    }
    
    int checkSectionCount = 0;
    for (int i=0; i<[checkListArray count]; i++) {
        
        if ([[[checkSectionArray objectAtIndex:i] objectForKey:@"isChecked"] integerValue] == 1) {
            checkSectionCount ++;
        }
    }
    
    if (checkSectionCount == [checkSectionArray count]) {
        
         _allImgV.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
        
    }else{
        
         _allImgV.image = [UIImage imageNamed:@"rb_gander_d_01.png"];
        
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
    [self addHeadBtnToScrollView];
    
}

// 添加头像到scrollView
-(void)addHeadBtnToScrollView{
    
    
    for (int i=0; i<[checkListArray count]; i++) {
        
        
        NSMutableArray *list = [checkListArray objectAtIndex:i];
        
        for (int j =0 ; j<[list count]; j++) {
            
            
            NSString *isChecked = [[list objectAtIndex:j] objectForKey:@"isChecked"];
            
            NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
            
            if (![@"1" isEqualToString:nail]) {
                
                NSString *uid = [[list objectAtIndex:j] objectForKey:@"uid"];
                
                if ([isChecked integerValue] == 1) {
                    
                    NSString *head_url = [[list objectAtIndex:j] objectForKey:@"avatar"];

                        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10.0*count + 35.0*count +10, 0.0, 35.0, 35.0)];
                        [imgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
                        imgV.layer.masksToBounds = YES;
                        imgV.layer.cornerRadius = imgV.frame.size.height/2.0;
                        imgV.tag = [uid integerValue];
                        imgV.userInteractionEnabled = YES;
                    
                        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.0, 35.0)];
                        headBtn.tag = ([uid integerValue]+5000);
                    
                        headBtn.backgroundColor = [UIColor clearColor];
                        [headBtn addTarget:self action:@selector(deleteHeadBtnFromScrollView:) forControlEvents:UIControlEventTouchUpInside];
                        [imgV addSubview:headBtn];
                    
                        if (![_scrollV viewWithTag:imgV.tag]) {
                            
                            [headArray addObject:imgV];
                            
                            [_scrollV addSubview:imgV];

                            
                        }

                }else{
                    
                   UIImageView *imgV = (UIImageView*)[_scrollV viewWithTag:[uid integerValue]];
                    
                        if (imgV){
                            
                            [headArray removeObject:imgV];
                            [imgV removeFromSuperview];
            
                            
                        }
                    
                }
            }
            
           
        }
        
        
    }
    
     NSLog(@"headArrayCount:%lu",(unsigned long)[headArray count]);
    [self showHead];
}

// 删除头像从scrollView
-(void)deleteHeadBtnFromScrollView:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger tag = btn.tag;
    
    NSInteger imgTag = tag - 5000;// 同时是uid
    
    UIImageView *headV = (UIImageView*)[_scrollV viewWithTag:imgTag];
    
    if (headV) {
        //To do: 删除scroview上的头像，同时删除checkListArray对应的值
        [headV removeFromSuperview];
        [headArray removeObject:headV];
        
        for (int i = 0; i<[checkListArray count]; i++) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
                NSString *uid = [[list objectAtIndex:j] objectForKey:@"uid"];
                
                if (![@"1"  isEqual: nail]) {
                    
                    if ([uid integerValue] == imgTag) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                        [dic setObject:@"0" forKey:@"isChecked"];
                        
                        [list replaceObjectAtIndex:j withObject:dic];
                        
                    }
                    
                }else {
                    
                }
                
            }
            
            [checkListArray replaceObjectAtIndex:i withObject:list];
            [checkSectionArray replaceObjectAtIndex:i withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
        }
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    }
  
    [self showHead];
    
}

// 显示底部头像
-(void)showHead{
    
    for (int i=0; i<[headArray count]; i++) {
        
        UIImageView *imgV = [headArray objectAtIndex:i];
        [imgV removeFromSuperview];
        
        imgV.frame = CGRectMake(10.0*i + 35.0*i +10, 5.0, 35.0, 35.0);
        [_scrollV addSubview:imgV];
        
        _scrollV.contentSize = CGSizeMake(35.0*(i+1) + 10*(i+1) + 10, 0.0);
        
    }
    
    
}

// 点击底部完成按钮
- (IBAction)finishSelectAction:(id)sender {
    
    if ([@"groupChatSetting"  isEqual: _viewType]) {
        // 这里放新增加的群成员的uid列表
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             checkListArray, @"uidList",
                             nil];
        
        NSInteger cnt = 0;
        for (int i=0; i<[checkListArray count]; i++ ) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                
                if ([isChecked integerValue] == 1) {
                    
                    cnt ++;
                    
                }
            }
            
        }

        if (cnt >= 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_ADDMEMBER object:self userInfo:dic];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            

        }else{
            [Utilities showAlert:@"提示" message:@"请至少选择一人" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
        
          }else {
        //To do:创建群聊
        NSString *members = @"";
        NSInteger cnt = 0;
        for (int i=0; i<[checkListArray count]; i++ ) {
            
            NSMutableArray *list = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                
                if ([isChecked integerValue] == 1) {
                    
                    NSString *item = [dic objectForKey:@"uid"];
                    if ([members length] == 0) {
                        members = item;
                    }
                    members = [NSString stringWithFormat:@"%@,%@",members,item];
                    cnt ++;
                    
                }
            }
            
        }
        
        if (cnt >= 2) {
           [self createGroup:members];
        }else{
            [Utilities showAlert:@"提示" message:@"请至少选择两人" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
        
        
    }
}

#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [searchResults removeAllObjects];
    
    if (mySearchBar.text.length>0&&![Utilities isIncludeChineseInString:mySearchBar.text]) {
       
        for (int i=0; i<[checkListArray count]; i++) {
            
            NSArray *list  = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                
                if ([Utilities isIncludeChineseInString:[dic objectForKey:@"name"]]) {
                    
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:[dic objectForKey:@"name"]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:dic];
                    }
                    
                }else{
                    
                    NSRange titleResult= [[dic objectForKey:@"name"] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:dic];
                    }
                }
                
            }
            
        }
        
    } else if (mySearchBar.text.length>0&&[Utilities isIncludeChineseInString:mySearchBar.text]) {
        
        for (int i= 0; i<[checkListArray count]; i++) {
            
            NSArray *list  = [checkListArray objectAtIndex:i];
            
            for (int j =0; j<[list count]; j++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                NSString *tempStr = [dic objectForKey:@"name"];
                NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [searchResults addObject:dic];
                }
            
            }
            
        }
        
        
    }
    

}
@end

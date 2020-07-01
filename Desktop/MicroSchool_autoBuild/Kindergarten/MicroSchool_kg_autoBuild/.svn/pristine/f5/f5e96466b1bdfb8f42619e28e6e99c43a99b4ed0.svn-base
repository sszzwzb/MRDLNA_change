//
//  FriendViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-24.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendViewController.h"
#import "DBDao.h"
#import "MsgDetailsViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

@synthesize classid;

@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        
        reflashFlag = 1;

        _sortedArrForArrays = [[NSMutableArray alloc] init];
        _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"通讯录"];
    [super setCustomizeLeftButton];
    
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    //---add by kate 2015.05.05-----------
    schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    _tableView.tableFooterView = [[UIView alloc] init];
    //------------------------------------

    [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"friend", @"ac",
                          @"friend", @"op",
                          classid, @"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendGet andData:data];
}

-(void)selectLeftAction:(id)sender
{
    reflashFlag = 0;

    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;

//    [self createHeaderView];

   
    [Utilities showProcessingHud:self.view];// 2015.05.12
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStylePlain];
    
    //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //
    //    _tableView.backgroundView = imgView_bg;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12

}

-(void)doGetFriend
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"friend", @"ac",
                          @"friend", @"op",
                          classid, @"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendGet andData:data];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [(NSArray *)[self.sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionHeadsKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeadsKeys;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";

    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[FriendTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.viewName = @"friendView";
    
//    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
//    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    cell.backgroundView = imgView_bg;

    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.name = str.string;
            
            if (0 == [indexPath section] && 0 == [indexPath row]) {
                cell.btn_thumb.layer.masksToBounds = NO;
                //[cell.btn_thumb setFrame:CGRectMake(10,13,35,30)];
                [cell.btn_thumb setFrame:CGRectMake(15,13,34,34)];//update by kate 2015l.07.01
                [cell.btn_thumb setImage:[UIImage imageNamed:@"friend/icon_tontacts_xdpy.png"] forState:UIControlStateNormal];
                [cell.btn_thumb setEnabled:false];
            } else if (0 == [indexPath section] && 1 == [indexPath row]) {
                cell.btn_thumb.layer.masksToBounds = NO;
                //[cell.btn_thumb setFrame:CGRectMake(10,13,40,30)];
                [cell.btn_thumb setFrame:CGRectMake(15,13,34,34)];//update by kate 2015l.07.01
                [cell.btn_thumb setImage:[UIImage imageNamed:@"friend/icon_tontacts_wdtx.png"] forState:UIControlStateNormal];
                [cell.btn_thumb setEnabled:false];
            } else if (0 == [indexPath section] && 2 == [indexPath row]) {
                cell.btn_thumb.layer.masksToBounds = NO;
                //[cell.btn_thumb setFrame:CGRectMake(15,13,30,30)];
                [cell.btn_thumb setFrame:CGRectMake(15,13,34,34)];//update by kate 2015l.07.01
                [cell.btn_thumb setImage:[UIImage imageNamed:@"friend/icon_tontacts_ls.png"] forState:UIControlStateNormal];
                [cell.btn_thumb setEnabled:false];
            } else if (0 == [indexPath section] && 3 == [indexPath row]) {
                cell.btn_thumb.layer.masksToBounds = NO;
                //[cell.btn_thumb setFrame:CGRectMake(15,13,30,30)];
                [cell.btn_thumb setFrame:CGRectMake(15,13,34,34)];//update by kate 2015l.07.01
                [cell.btn_thumb setImage:[UIImage imageNamed:@"friend/icon_tontacts_jz.png"] forState:UIControlStateNormal];
                [cell.btn_thumb setEnabled:false];
            } else {
                cell.btn_thumb.layer.masksToBounds = YES;
                cell.btn_thumb.layer.cornerRadius = 40/2;
                cell.btn_thumb.contentMode = UIViewContentModeScaleToFill;
                [cell.btn_thumb setEnabled:true];

                cell.uid = str.uid;

                [cell.btn_thumb setFrame:CGRectMake(10,10,40,40)];

                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

//                [cell.btn_thumb setImageWithURL:[NSURL URLWithString:str.avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if ((0 == [indexPath section] && 0 == [indexPath row]) ||
        (0 == [indexPath section] && 1 == [indexPath row]) ||
        (0 == [indexPath section] && 2 == [indexPath row]) ||
        (0 == [indexPath section] && 3 == [indexPath row])) {
        
//        if (0 == [indexPath section] && 0 == [indexPath row]) {
//            // 进入各种列表
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 classid, @"classid",
//                                 [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
//                                 nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToFriendCommonView" object:self userInfo:dic];
//        } else {
        
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString *checked = [user objectForKey:@"role_checked"];
            NSString *cid = [user objectForKey:@"role_cid"];

            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        
        //----------------update by kate 2015.05.05----------------------------------------------
        if ([@"bureau" isEqualToString:schoolType]) {//教育局
            
            // 教师未认证点击分组时，提示：只有认证教师可以使用 2015.06.18
        
            if([@"7"  isEqual: usertype])
            {
                if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
                {
//                    [self.view makeToast:@"您还未获得教师身份，请递交申请."
//                                duration:0.5
//                                position:@"center"
//                                   title:nil];
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"只有认证教师可以使用."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
                {
//                    [self.view makeToast:@"请耐心等待审批."
//                                duration:0.5
//                                position:@"center"
//                                   title:nil];
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"只有认证教师可以使用."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    // update by kate
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"FriendCommon", @"toViewName",
                                         [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                         nil];

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToMyClassView" object:self userInfo:dic];
                }
            }else if ([@"2"  isEqual: usertype] || [@"9"  isEqual: usertype]){
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"DepartmentList", @"toViewName",
                                     [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                     nil];

                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToMyClassView" object:self userInfo:dic];
            }else{
                
                //---update by kate 2015.06.18----------------------------------------------------------
                /*if ([@""  isEqual: cid]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"请先加入部门"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                    
                } else {
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"DepartmentList", @"toViewName",
                                         [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                         nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToMyClassView" object:self userInfo:dic];

                }*/
                
                
                 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                message:@"只有认证教师可以使用."
                                                                delegate:nil
                                                                cancelButtonTitle:@"知道了"
                                                                otherButtonTitles:nil];
                 [alert show];
                /*对于教育局版本（分组：本单位、下属单位）：
                 教师未认证点击分组时，提示：只有认证教师可以使用
                 家长学生无论是否加入班级，均有如上提示。*/
                
                
            }
        //---------------------------------------------------------------------------------------------
        }else{
            
            // update by kate 2015.06.18
            // 对于其他类型版本（分组：我的同学、老师、家长）：
            // 教师未认证点击分组时，提示：只有认证教师可以使用
            // 家长学生未加入班级时，提示：您还未加入任何班级，无法使用此功能
            
            if([@"7"  isEqual: usertype])
            {
                if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
                {
//                    [self.view makeToast:@"您还未获得教师身份，请递交申请."
//                                duration:0.5
//                                position:@"center"
//                                   title:nil];
                    
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"只有认证教师可以使用."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
                {
//                    [self.view makeToast:@"请耐心等待审批."
//                                duration:0.5
//                                position:@"center"
//                                   title:nil];
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"只有认证教师可以使用."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"FriendCommon", @"toViewName",
                                         [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToMyClassView" object:self userInfo:dic];
                }
            }else if ([@"2"  isEqual: usertype] || [@"9"  isEqual: usertype]){
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"FriendCommon", @"toViewName",
                                     [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToMyClassView" object:self userInfo:dic];
            }else{
                
                if ([@""  isEqual: cid] || [cid integerValue] == 0) {
                    
//                    NSString *msg = @"请先加入一个班级";
//                    if ([@"bureau" isEqualToString:schoolType]) {
//                        msg = @"请先加入一个部门";
//                    }
  #if BUREAU_OF_EDUCATION
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"您还未加入任何部门，无法使用此功能。"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                    
#else
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"您还未加入任何班级，无法使用此功能。"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                    
#endif
                    
                    
                } else {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         classid, @"classid",
                                         [NSString stringWithFormat:@"%ld", (long)[indexPath row]], @"row",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToFriendCommonView" object:self userInfo:dic];
                }
            }
        }
        
      
//        }
    }else {
        // 选择好友 跳转至聊天页
        
        UserObject *user = [[UserObject alloc]init];
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            user.user_id = [str.uid longLongValue];
            user.name = str.string;
            user.headimgurl = str.avatar;
        }
        
        [user updateToDB];
        
        // 更改聊天列表的title
        NSString *updateListSql =[NSString stringWithFormat: @"update msgList set title = '%@' where user_id = %lli", user.name, user.user_id];
        [[DBDao getDaoInstance] executeSql:updateListSql];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             user, @"user",
                             @"user",@"frontName",
                             nil];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailView" object:self userInfo:dic];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((0 == [indexPath section] && 0 == [indexPath row]) ||
        (0 == [indexPath section] && 1 == [indexPath row]) ||
        (0 == [indexPath section] && 2 == [indexPath row]) ||
        (0 == [indexPath section] && 3 == [indexPath row])) {
        return NO;
    }else {
        return YES;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];

        _deleteUid = str.uid;
                
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"是否要删除好友？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定",nil];
        alert.tag = 888;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 888) {
        // 删除好友
        if (buttonIndex == 1) {
            
            [ReportObject event:ID_DEL_FRIEND];//2015.06.24
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Friend", @"ac",
                                  @"del", @"op",
                                  _deleteUid, @"fuid",
                                  nil];
            
            [network sendHttpReq:HttpReq_FriendDelete andData:data];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *visibleRows = [tableView visibleCells];
//    if([visibleRows count] > 0){
//        for (MsgListCell *cell in visibleRows) {
//            cell.timeLabel.hidden = NO;
//            //        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
//            //            cell.unReadBadgeView.hidden = NO;
//            //        } else {
//            //            cell.unReadBadgeView.hidden = YES;
//            //        }
//        }
//    }
//    
//    [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
    
    
//    [_tableView beginUpdates];
//    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationTop];
//    [_tableView endUpdates];

}

-(void)doShowTableview
{
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"friend", @"ac",
                          @"friend", @"op",
                          classid, @"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendGet andData:data];
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
//    if (_refreshFooterView) {
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
//        [self setFooterView];
//    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
//    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
//    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
//    if (_refreshFooterView && [_refreshFooterView superview])
//	{
//        // reset position
//        _refreshFooterView.frame = CGRectMake(0.0f,
//                                              height,
//                                              self->_tableView.frame.size.width,
//                                              self.view.bounds.size.height);
//    }else
//	{
//        // create the footerView
//        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
//                              CGRectMake(0.0f, height,
//                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
//        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
//        _refreshFooterView.delegate = self;
//        [self->_tableView addSubview:_refreshFooterView];
//    }
//    
//    if (_refreshFooterView)
//	{
//        [_refreshFooterView refreshLastUpdatedDate];
//    }
}

//-(void)removeFooterView
//{
//    if (_refreshFooterView && [_refreshFooterView superview])
//	{
//        [_refreshFooterView removeFromSuperview];
//    }
//    _refreshFooterView = nil;
//}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        //[self refreshView];
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.2];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"friend", @"ac",
                              @"friend", @"op",
                              classid, @"cid",
                              nil];
        
        [network sendHttpReq:HttpReq_FriendGet andData:data];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    [self enableLeftAndRightKey];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if([@"FriendAction.del" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        // 删除成功
        if(true == [result intValue])
        {
            // 成功
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"friend", @"ac",
                                  @"friend", @"op",
                                  classid, @"cid",
                                  nil];
            
            [network sendHttpReq:HttpReq_FriendGet andData:data];
        }else {
            // 失败
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }
    }else {
        if(true == [result intValue])
        {
            if(_sortedArrForArrays!=nil){// update by kate 2015.02.02
                [_sortedArrForArrays removeAllObjects];
            }
            if (_sectionHeadsKeys!=nil) {// update by kate 2015.02.02
                [_sectionHeadsKeys removeAllObjects];
            }
            
            NSArray* message_info = [resultJSON objectForKey:@"message"];
            if (0 != [message_info count]) {
                NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:message_info];
                self.sortedArrForArrays = [Utilities getChineseStringArr:myMutableArray andResultKeys:_sectionHeadsKeys flag:0];
            }
            
            
            NSMutableArray *array0 = [[NSMutableArray alloc] init];
            
            //        ChineseString *newFriend=[[ChineseString alloc]init];
            //        newFriend.string = @"新的朋友";
            
            if ([schoolType isEqualToString:@"bureau"]) {// 教育局 update by kate 2015.05.21
                
                ChineseString *myDepartment =[[ChineseString alloc]init];// update by kate 2015.06.18又改回去...
                myDepartment.string = @"本单位";
                
                ChineseString *subDepartment = [[ChineseString alloc]init];
                subDepartment.string = @"下属单位";
                
                [array0 addObject:myDepartment];
                [array0 addObject:subDepartment];
                
            }else{
                ChineseString *classmate=[[ChineseString alloc]init];
                classmate.string = @"我的同学";
                
                ChineseString *tacher=[[ChineseString alloc]init];
                tacher.string = @"老师";
                
                ChineseString *parent=[[ChineseString alloc]init];
                parent.string = @"家长";
                
                //        [array0 addObject:newFriend];
                [array0 addObject:classmate];
                [array0 addObject:tacher];
                [array0 addObject:parent];
            }
            
            // 添加最上面的4个选择项
            [self.sortedArrForArrays insertObject:array0 atIndex:0];
            [self.sectionHeadsKeys insertObject:[NSString stringWithFormat:@""] atIndex:0];
            
            //        [self doShowTableview];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            [_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取通讯录错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
    if([self.sortedArrForArrays count] == 0){//2015.06.30
        if (![Utilities isConnected]) {
            
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            
        }
    }
    
}

@end

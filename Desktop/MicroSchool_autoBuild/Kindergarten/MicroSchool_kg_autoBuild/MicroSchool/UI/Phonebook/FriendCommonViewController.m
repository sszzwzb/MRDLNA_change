//
//  FriendCommonViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-25.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendCommonViewController.h"
#import "MsgDetailsViewController.h"
#import "DBDao.h"

@interface FriendCommonViewController ()

@end

@implementation FriendCommonViewController

@synthesize viewType;
@synthesize classid;

@synthesize friendNewArray = _friendNewArray;

@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

@synthesize sortedArrForArraysFilter = _sortedArrForArraysFilter;
@synthesize sectionHeadsKeysFilter = _sectionHeadsKeysFilter;
//@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;

        
        req_op = @"";
        title_name = @"";
        
        CGSize tagSize = CGSizeMake(15, 15);
        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_contact_add_d.png"]];
        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_contact_add_p.png"]];

        _friendNewArray = [[NSMutableArray alloc] init];
        _sortedArrForArrays = [[NSMutableArray alloc] init];
        _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...
        
        //---add by kate 2015.05.05-------------------------------
        _sortedArrForArraysFilter = [[NSMutableArray alloc] init];
        _sectionHeadsKeysFilter = [[NSMutableArray alloc] init];
         searchResults = [[NSMutableArray alloc]init];
        //--------------------------------------------------------
    }
    return self;
}

- (id)initWithVar:(FriendViewType)type
{
    if(self = [super init])
    {
        viewType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (FriendViewType_NewFriend == viewType) {
//        req_op = @"requests";
//        title_name = @"新的朋友";
    //----update by kate 2015.05.05----------------------------------------------------------
   
    if ([@"bureau" isEqualToString:schoolType]) {
        title_name = _fromTitle;
    }else{//-----------------------------------------------------------------------------------
        if (FriendViewType_Classmate == viewType) {
            req_op = @"classmate";
            title_name = @"我的同学";
        } else if (FriendViewType_Tacher == viewType) {
            req_op = @"teacher";
            title_name = @"老师";
        } else if (FriendViewType_Parent == viewType) {
            req_op = @"parent";
            title_name = @"家长";
        }
    }
    
    [super setCustomizeTitle:title_name];
    [super setCustomizeLeftButton];
    
    [self doShowTableview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAddFriend:) name:@"Weixiao_friendAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAddFriendAgree:) name:@"Weixiao_friendAddAgree" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromFriendCommonView2ProfileView" object:nil];

//    if (FriendViewType_NewFriend != viewType) {
//        // 导航右菜单，多人发送
//        [super setCustomizeRightButton:@"friend/icon_mass_message.png"];
//    }
    [super setCustomizeRightButton:@"friend/icon_mass_message.png"];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_friendAdd" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_friendAddAgree" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromFriendCommonView2ProfileView" object:nil];
}

-(void)doGoToProfileView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
}

-(void)doAddFriend:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *authority = [dic objectForKey:@"authority"];

    if ([@"2"  isEqual: authority]) {
        // 需要验证
        FriendAddReqViewController *friendAddViewCtrl = [[FriendAddReqViewController alloc] init];
        friendAddViewCtrl.uid = fuid;
        friendAddViewCtrl.name = name;
        [self.navigationController pushViewController:friendAddViewCtrl animated:YES];
    }else if([@"1"  isEqual: authority]) {
        // 任何人都可以添加
        
        [Utilities showProcessingHud:self.view];// 2015.05.12
        // 发送添加好友请求
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              @"add", @"op",
                              fuid, @"fuid",
                              @"0", @"gid",
                              @"", @"note",
                              nil];
        
        [network sendHttpReq:HttpReq_FriendAdd andData:data];
    }
}

-(void)doAddFriendAgree:(NSNotification *)notification
{
   
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Friend", @"ac",
                          @"accept", @"op",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendAddAccept andData:data];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
    friendSelectViewCtrl.classid = classid;
    friendSelectViewCtrl.friendType = req_op;
    if ([schoolType isEqualToString:@"bureau"]) {
        friendSelectViewCtrl.friendType = @"friend";
    }
    friendSelectViewCtrl.flag = _titleName;
    friendSelectViewCtrl.gid = _gid;

    [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];

}
- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    //schoolType = @"bureau";
    if ([@"bureau" isEqualToString:schoolType]){//教育局
        [self performSelector:@selector(doGetPeople) withObject:nil afterDelay:0.1];
    }else{
        [self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
    }
    
    
}

-(void)doGetFriend
{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"friend", @"ac",
                          req_op, @"op",
                          classid, @"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_FriendGet andData:data];
}

//---add by kate 2015.05.05------------------------------------
-(void)doGetPeople
{
   
    [Utilities showProcessingHud:self.view];//2015.05.12
    /**
     * 教育局本单位成员列表
     * @author luke
     * @date 2015.05.05
     * @args
     *  ac=Friend, v=2, op=department, sid=, uid=, cid=
     */
    /**
     * 教育局下属单位成员列表
     * @author luke
     * @date 2015.05.05
     * @args
     *  ac=Friend,v=2, op=subordinate, sid=, uid=, cid=
     */
    
    NSString *op = @"department";
    if ([_titleName isEqualToString:@"下属单位"]) {
        op = @"subordinate";
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              op, @"op",
                              @"1",@"v",
                              classid, @"cid",
                              nil];
        
        NSLog(@"data:%@",data);
        
        [network sendHttpReq:HttpReq_PeopleGet andData:data];

        [ReportObject event:ID_OPEN_SUBORDINATE_MEMBER];//2015.06.25
    }else{
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Contact", @"ac",
                              @"members", @"op",
                              @"2",@"v",
                              _gid, @"gid",
                              nil];
        
        NSLog(@"data:%@",data);
        
        [network sendHttpReq:HttpReq_PeopleGet andData:data];
        
        [ReportObject event:ID_OPEN_BUREAU_MEMBER];//2015.06.25
    }
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          REQ_URL, @"url",
//                          @"Friend", @"ac",
//                          op, @"op",
//                          @"1",@"v",
//                          classid, @"cid",
//                          nil];
//    
//    NSLog(@"data:%@",data);
//    
//    [network sendHttpReq:HttpReq_PeopleGet andData:data];
}
//----------------------------------------------------------------

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
//    if (FriendViewType_NewFriend == viewType) {
//        return [_friendNewArray count];
//    } else {
//        return [[self.sortedArrForArrays objectAtIndex:section] count];
//    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return  [(NSArray *)[self.sortedArrForArraysFilter objectAtIndex:section] count];
    }
    else {
        return [(NSArray *)[self.sortedArrForArrays objectAtIndex:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (FriendViewType_NewFriend == viewType) {
//        return 1;
//    } else {
//        return [self.sortedArrForArrays count];
//    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.sortedArrForArraysFilter count];
    }
    else {
        return [self.sortedArrForArrays count];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (FriendViewType_NewFriend == viewType) {
//        return @"";
//    } else {
//        return [_sectionHeadsKeys objectAtIndex:section];
//    }
    return [_sectionHeadsKeys objectAtIndex:section];

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (FriendViewType_NewFriend == viewType) {
//        NSArray *tmp = [[NSArray alloc] initWithObjects:@"", nil];
//        return tmp;
//    } else {
//        return self.sectionHeadsKeys;
//    }
    return self.sectionHeadsKeys;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (FriendViewType_NewFriend == viewType) {
//        return 70;
//    } else {
//        return 60;
//    }
    return 60;

}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{                UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320, 20)];
//    [image setImage:[UIImage imageNamed:@"letterline.png"]];
//    //image.backgroundColor=[UIColor redColor];
//    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.opaque = NO;
//    headerLabel.textColor = [UIColor blackColor];
//    
//    headerLabel.font = [UIFont boldSystemFontOfSize:20];
//    headerLabel.frame = CGRectMake(10.0, 0-10, 300.0, 44.0);
//    
//    
//    headerLabel.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//    
//    [image addSubview:headerLabel];
//    
//    return image;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";
    static NSString *CellTableIdentifier2 = @"CellTableIdentifier2";
    static NSString *CellTableIdentifier3 = @"CellTableIdentifier3";
    static NSString *CellTableIdentifier4 = @"CellTableIdentifier4";

//    if (FriendViewType_NewFriend == viewType) {
//        FriendNewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
//        if(cell == nil) {
//            cell = [[FriendNewFriendTableViewCell alloc]
//                    initWithStyle:UITableViewCellStyleDefault
//                    reuseIdentifier:CellTableIdentifier];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        NSUInteger row = [indexPath row];
//        NSDictionary* list_dic = [_friendNewArray objectAtIndex:row];
//
//        [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:[list_dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
//        cell.name = [list_dic objectForKey:@"name"];
//        cell.uid = [list_dic objectForKey:@"uid"];
//
//        cell.content = [list_dic objectForKey:@"note"];
//        
//        Utilities *util = [Utilities alloc];
//        NSString *time = [NSString stringWithFormat: @"%@",
//                              [util linuxDateToString:[list_dic objectForKey:@"timestamp"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM]];
//        cell.time = time;
//
//        cell.button_addFriend.hidden = NO;
//        [cell.button_addFriend setTitle:@"同意" forState:UIControlStateNormal];
//        [cell.button_addFriend setTitle:@"同意" forState:UIControlStateHighlighted];
//
//        return cell;
//        
//        //cell.name = [self.sortedArrForArrays];
//
//    } else {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        if ([self.sortedArrForArraysFilter count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArraysFilter objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                if ([str.isFriend  isEqual: @"0"]) {
                    if ([@"3"  isEqual: str.authority]) {
                        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier4];
                        if(cell == nil) {
                            cell = [[FriendTableViewCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellTableIdentifier4];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        cell.button_addFriend.hidden = NO;
                        cell.name = str.string;
                        cell.uid = str.uid;
                        cell.isFriend = str.isFriend;
                        cell.viewName = @"friendCommonView";
                        cell.authority = str.authority;
                        
                        cell.button_addFriend.enabled = NO;
                        [cell.button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        
                        [cell.button_addFriend setTitle:@"无法添加" forState:UIControlStateNormal];
                        [cell.button_addFriend setTitle:@"无法添加" forState:UIControlStateHighlighted];
                        
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        
                        return cell;
                    }else {
                        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
                        if(cell == nil) {
                            cell = [[FriendTableViewCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellTableIdentifier1];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.viewName = @"friendCommonView";
                        cell.authority = str.authority;
                        
                        cell.button_addFriend.hidden = NO;
                        cell.name = str.string;
                        cell.uid = str.uid;
                        cell.isFriend = str.isFriend;
                        
                        [cell.button_addFriend setImage:buttonImg_d forState:UIControlStateNormal] ;
                        [cell.button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted] ;
                        
                        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateNormal];
                        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateHighlighted];
                        
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        
                        return cell;
                    }
                } else {
                    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier2];
                    if(cell == nil) {
                        cell = [[FriendTableViewCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellTableIdentifier2];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    cell.button_addFriend.hidden = NO;
                    cell.name = str.string;
                    cell.uid = str.uid;
                    cell.isFriend = str.isFriend;
                    cell.viewName = @"friendCommonView";
                    cell.authority = str.authority;
                    
                    cell.button_addFriend.enabled = NO;
                    [cell.button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    
                    [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateNormal];
                    [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateHighlighted];
                    
                    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                    
                    return cell;
                }
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    
    }else{
        
        if ([self.sortedArrForArrays count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                if ([str.isFriend  isEqual: @"0"]) {
                    if ([@"3"  isEqual: str.authority]) {
                        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier4];
                        if(cell == nil) {
                            cell = [[FriendTableViewCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellTableIdentifier4];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        cell.button_addFriend.hidden = NO;
                        cell.name = str.string;
                        cell.uid = str.uid;
                        cell.isFriend = str.isFriend;
                        cell.viewName = @"friendCommonView";
                        cell.authority = str.authority;
                        
                        cell.button_addFriend.enabled = NO;
                        [cell.button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        
                        [cell.button_addFriend setTitle:@"无法添加" forState:UIControlStateNormal];
                        [cell.button_addFriend setTitle:@"无法添加" forState:UIControlStateHighlighted];
                        
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        
                        return cell;
                    }else {
                        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
                        if(cell == nil) {
                            cell = [[FriendTableViewCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellTableIdentifier1];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.viewName = @"friendCommonView";
                        cell.authority = str.authority;
                        
                        cell.button_addFriend.hidden = NO;
                        cell.name = str.string;
                        cell.uid = str.uid;
                        cell.isFriend = str.isFriend;
                        
                        [cell.button_addFriend setImage:buttonImg_d forState:UIControlStateNormal] ;
                        [cell.button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted] ;
                        
                        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateNormal];
                        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateHighlighted];
                        
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                        
                        return cell;
                    }
                } else {
                    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier2];
                    if(cell == nil) {
                        cell = [[FriendTableViewCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellTableIdentifier2];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    cell.button_addFriend.hidden = NO;
                    cell.name = str.string;
                    cell.uid = str.uid;
                    cell.isFriend = str.isFriend;
                    cell.viewName = @"friendCommonView";
                    cell.authority = str.authority;
                    
                    cell.button_addFriend.enabled = NO;
                    [cell.button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    
                    [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateNormal];
                    [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateHighlighted];
                    
                    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                    
                    return cell;
                }
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    }
    
    
//    }

    // temp cell for function return
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier3];
    if(cell == nil) {
        cell = [[FriendTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier3];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (FriendViewType_NewFriend == viewType) {
//        
//    } else {
        /*avatar = "http://116.255.225.145:9797/ucenter/avatar.php?uid=49439&size=middle&type=";
         friend = 0;
         name = "\U4e1c\U65b9\U5b9e\U9a8c";
         title = "\U5b66\U751f";
         uid = 49439;*/
        UserObject *user = [[UserObject alloc]init];
        NSArray *arr = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = [self.sortedArrForArraysFilter objectAtIndex:indexPath.section];
    }
    else {
       arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
    }
    
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
        MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
        chatDeatilController.user = user;
        chatDeatilController.frontName = @"user";
        [chatDeatilController getChatDetailData];
        [self.navigationController pushViewController:chatDeatilController animated:YES];
//    }
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
    
    if(HttpReq_FriendAddAccept == type) {
        if(true == [result intValue])
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                           message:message_info
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
            // 添加好友成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:DataReport_Act_PhoneBook_AddFriend];
        }
        else
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }

    }else if([@"FriendAction.add" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        // 不需要验证的用户，添加好友
        if(true == [result intValue])
        {
            // 成功
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            alert.tag = 122;
            [alert show];
        }else {
            // 失败
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }
    }else if ([@"FriendAction.department" isEqualToString:[resultJSON objectForKey:@"protocol"]] || [@"FriendAction.subordinate" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        
        NSArray* message_info = [resultJSON objectForKey:@"message"];
        
        if (1 == [result integerValue]) {// 成功
            
            
            [_friendNewArray removeAllObjects];
            [_sortedArrForArrays removeAllObjects];
            [_sectionHeadsKeys removeAllObjects];
            
            if (0 != [message_info count]) {
                
                mySearchBar.hidden = NO;
             
                mutableArrayOrign =[NSMutableArray arrayWithArray:message_info];
                self.sortedArrForArrays = [Utilities getChineseStringArr:mutableArrayOrign andResultKeys:_sectionHeadsKeys flag:1];
                
            }else{
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 20.0 - 49.0)/2.0, [UIScreen mainScreen].bounds.size.width, 20.0)];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor grayColor];
                label.text = @"暂无相关数据";
                
                [self.view addSubview:label];

            }
            
            [_tableView reloadData];
            
        }else{// 失败
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
            
        }
        
    }else {
        if(true == [result intValue])
        {
            NSArray* message_info = [resultJSON objectForKey:@"message"];
            NSLog(@"message_info:%@",message_info);
            
            [_friendNewArray removeAllObjects];
            [_sortedArrForArrays removeAllObjects];
            [_sectionHeadsKeys removeAllObjects];

            if (0 != [message_info count]) {
                
                mySearchBar.hidden = NO;
                
//                if (FriendViewType_NewFriend == viewType) {
//                    self.friendNewArray = [NSMutableArray arrayWithArray:message_info];
//                } else {
                   //------update by kate 2015.05.05-------------------------------------------------------
                    //NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:message_info];
                    //self.sortedArrForArrays = [Utilities getChineseStringArr:myMutableArray andResultKeys:_sectionHeadsKeys];
                    mutableArrayOrign =[NSMutableArray arrayWithArray:message_info];
                    self.sortedArrForArrays = [Utilities getChineseStringArr:mutableArrayOrign andResultKeys:_sectionHeadsKeys flag:0];
                  //-----------------------------------------------------------------------------------------
                
//                }
            }else{
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 20.0 - 49.0)/2.0, [UIScreen mainScreen].bounds.size.width, 20.0)];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor grayColor];
                label.text = @"暂无相关数据";
                
                [self.view addSubview:label];
            }
            
            [_tableView reloadData];
//            [self doShowTableview];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取朋友错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)doShowTableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    
    _tableView.backgroundView = imgView_bg;

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    //---add by kate 2015.05.05---------------------------------------------------
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    mySearchBar.delegate = self;
    mySearchBar.hidden = YES;
    [mySearchBar setPlaceholder:@"真实姓名"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    _tableView.tableHeaderView = mySearchBar;
    //------------------------------------------------------------------------------
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122) {
        if ([@"bureau" isEqualToString:schoolType]){//教育局
            [self performSelector:@selector(doGetPeople) withObject:nil afterDelay:0.1];
        }else{
            [self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
        }
        //[self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
    } else {
        //[self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
        if ([@"bureau" isEqualToString:schoolType]){//教育局
            [self performSelector:@selector(doGetPeople) withObject:nil afterDelay:0.1];
        }else{
            [self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
        }
    }

//    [self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];

//    [self doGetFriend];

}

//----add by kate 2015.05.05-------------------------------------------------------
#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchResults removeAllObjects];
    
    if (mySearchBar.text.length>0&&![Utilities isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<mutableArrayOrign.count; i++) {
            if ([Utilities isIncludeChineseInString:[mutableArrayOrign[i] objectForKey:@"name"]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:[mutableArrayOrign[i] objectForKey:@"name"]];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:mutableArrayOrign[i]];
                }
            }
            else {
                NSRange titleResult=[[mutableArrayOrign[i] objectForKey:@"name"] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:mutableArrayOrign[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[Utilities isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<mutableArrayOrign.count; i++) {
            NSString *tempStr = [mutableArrayOrign[i] objectForKey:@"name"];
            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [searchResults addObject:mutableArrayOrign[i]];
            }
        }
    }
    
    [_sortedArrForArraysFilter removeAllObjects];
    [_sectionHeadsKeysFilter removeAllObjects];
    
    if ([_titleName isEqualToString:@"下属单位"] || [_titleName isEqualToString:@"本单位"]){
        
         _sortedArrForArraysFilter = [Utilities getChineseStringArr:searchResults andResultKeys:_sectionHeadsKeysFilter flag:1];
        
    }else{
         _sortedArrForArraysFilter = [Utilities getChineseStringArr:searchResults andResultKeys:_sectionHeadsKeysFilter flag:0];
    }
   
}
//---------------------------------------------------------------------

@end

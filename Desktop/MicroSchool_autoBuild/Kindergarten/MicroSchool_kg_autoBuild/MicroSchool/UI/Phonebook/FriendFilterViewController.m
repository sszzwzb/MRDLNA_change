//
//  FriendFilterViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 5/14/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "FriendFilterViewController.h"
#import "MsgDetailsViewController.h"
#import "DBDao.h"

@interface FriendFilterViewController ()

@end

@implementation FriendFilterViewController

@synthesize classid;

@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

@synthesize sortedArrForArraysFilter = _sortedArrForArraysFilter;
@synthesize sectionHeadsKeysFilter = _sectionHeadsKeysFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
       
        mutableArrayOrign = [[NSMutableArray alloc] init];
        searchResults = [[NSMutableArray alloc]init];

        _sortedArrForArrays = [[NSMutableArray alloc] init];
        _sectionHeadsKeys = [[NSMutableArray alloc] init];
        
        _sortedArrForArraysFilter = [[NSMutableArray alloc] init];
        _sectionHeadsKeysFilter = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"查找好友"];
    [super setCustomizeLeftButton];
    
    [ReportObject event:ID_OPEN_FIND_FRIEND];//2015.06.25
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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    [self performSelector:@selector(doGetFriend) withObject:nil afterDelay:0.1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
}

-(void)doGetFriend
{
 
    [Utilities showProcessingHud:self.view];// 2015.05.12
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return  [(NSArray *)[self.sortedArrForArraysFilter objectAtIndex:section] count];
    }
    else {
        return  [(NSArray *)[self.sortedArrForArrays objectAtIndex:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.sortedArrForArraysFilter count];
    }
    else {
        return [self.sortedArrForArrays count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_sectionHeadsKeysFilter objectAtIndex:section];
    }
    else {
        return [_sectionHeadsKeys objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.sectionHeadsKeysFilter;
    }
    else {
        return self.sectionHeadsKeys;
    }
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
    
    //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //    cell.backgroundView = imgView_bg;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if ([self.sortedArrForArraysFilter count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArraysFilter objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                cell.name = str.string;
                
                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    } else {
        if ([self.sortedArrForArrays count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                cell.name = str.string;
                
                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:str.avatar] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    }

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
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
    
    if(true == [result intValue])
    {
        NSArray* message_info = [resultJSON objectForKey:@"message"];
        if (0 != [message_info count]) {
            mutableArrayOrign = [NSMutableArray arrayWithArray:message_info];
            self.sortedArrForArrays = [Utilities getChineseStringArr:mutableArrayOrign andResultKeys:_sectionHeadsKeys flag:0];
        }
        
        [self doShowTableview];
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

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)doShowTableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"真实姓名"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
	_tableView.tableHeaderView = mySearchBar;
}

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
    
    _sortedArrForArraysFilter = [Utilities getChineseStringArr:searchResults andResultKeys:_sectionHeadsKeysFilter flag:0];
}

@end

//
//  FriendSearchViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendAddSearchViewController.h"
#import "FriendProfileViewController.h"

@interface FriendAddSearchViewController ()

@end

@implementation FriendAddSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        listDataArray =[[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        searchText = @"";
        
        // 获取当前用户的uid
        NSDictionary *user1 = [g_userInfo getUserDetailInfo];
        cid = [user1 objectForKey:@"cid"];
        
        CGSize tagSize = CGSizeMake(15, 15);
        buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_contact_add_d.png"]];
        buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/icon_contact_add_p.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setCustomizeTitle:@"添加朋友"];
}

-(void)doAddFriendReq:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    NSString *name = [dic objectForKey:@"name"];
    
    FriendAddReqViewController *friendAddViewCtrl = [[FriendAddReqViewController alloc] init];
    friendAddViewCtrl.uid = fuid;
    friendAddViewCtrl.name = name;
    [self.navigationController pushViewController:friendAddViewCtrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAddFriendReq:) name:@"Weixiao_friendAddReq" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_friendAddReq" object:nil];
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // search图片
    UIImageView *imgView_searchIcom =[[UIImageView alloc]initWithFrame:CGRectMake(5,5,25,30)];
    //[imgView_searchIcom setImage:[UIImage imageNamed:@"icon_liulan.png"]];
    [self.view addSubview:imgView_searchIcom];
    
    if (isOSVersionLowwerThan(@"7.0")){
        
        textField_search = [[UITextField alloc] initWithFrame: CGRectMake(
                                                                          imgView_searchIcom.frame.origin.x + imgView_searchIcom.frame.size.width,
                                                                          imgView_searchIcom.frame.origin.y+13,
                                                                          WIDTH - imgView_searchIcom.frame.origin.x - imgView_searchIcom.frame.size.width-20 - 60,
                                                                          50)];
        
    }else{
        textField_search = [[UITextField alloc] initWithFrame: CGRectMake(
                                                                          imgView_searchIcom.frame.origin.x + imgView_searchIcom.frame.size.width,
                                                                          imgView_searchIcom.frame.origin.y-3,
                                                                          WIDTH - imgView_searchIcom.frame.origin.x - imgView_searchIcom.frame.size.width-20 - 60,
                                                                          50)];
    }
    
    // search输入框
    textField_search.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    textField_search.borderStyle = UITextBorderStyleNone;
    textField_search.backgroundColor = [UIColor clearColor];
    textField_search.placeholder = @"真实姓名/电话号码";
    textField_search.font = [UIFont systemFontOfSize:14.0f];
    textField_search.textColor = [UIColor blackColor];
    textField_search.textAlignment = NSTextAlignmentLeft;
    textField_search.keyboardType=UIKeyboardTypeDefault;
    textField_search.returnKeyType =UIReturnKeySearch;
    
    [textField_search setDelegate: self];
    [textField_search addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [textField_search performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [self.view addSubview: textField_search];
    
    // 搜索button
    UIButton *button_search = [UIButton buttonWithType:UIButtonTypeCustom];
    button_search.frame = CGRectMake(
                                     250,
                                     imgView_searchIcom.frame.origin.y,
                                     58, 44);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_search.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [button_search setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_wiki_search_d.png"] forState:UIControlStateNormal] ;
    [button_search setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_wiki_search_p.png"] forState:UIControlStateHighlighted] ;
    
    button_search.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    
    [button_search addTarget:self action:@selector(search_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview:button_search];
    
    // search输入下方的横线
    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(0,50,WIDTH,2)];
    [imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [self.view addSubview:imgView_line];
    
    // 列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+2, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-52) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    //[self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    _tableView.backgroundView = imgView_bg;
    
    [self.view addSubview:_tableView];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"textField text : %@", [textField text]);
    searchText = [textField text];
}

- (IBAction)search_btnclick:(id)sender
{
    [ReportObject event:ID_SEARCH_USER];//2015.06.25
    
    [textField_search resignFirstResponder];

    [listDataArray removeAllObjects];
    [_tableView reloadData];
    
    
    [Utilities showProcessingHud:self.view];//2015.05.12
    // ac=Friend op=findByMobileOrName sid= cid= uid= key=
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Friend", @"ac",
                          @"findByMobileOrName", @"op",
                          cid, @"cid",
                          searchText, @"key",
                          nil];

    [network sendHttpReq:HttpReq_FriendSearch andData:data];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

// 当用户按下return键或者按回车键，开始搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    searchText = textField.text;
    
    [textField resignFirstResponder];
    
    
    [self search_btnclick:nil];
    
    return YES;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listDataArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [listDataArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    FriendAddSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[FriendAddSearchTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSUInteger row = [indexPath row];
    
    NSDictionary* list_dic = [listDataArray objectAtIndex:row];
    
    if ([[NSString stringWithFormat:@"%@", [list_dic objectForKey:@"friend"]]  isEqual: @"0"]) {
        cell.button_addFriend.hidden = NO;
        
        [cell.button_addFriend setImage:buttonImg_d forState:UIControlStateNormal] ;
        [cell.button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted] ;
        
        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateNormal];
        [cell.button_addFriend setTitle:@"加好友" forState:UIControlStateHighlighted];
    } else {
        cell.button_addFriend.hidden = NO;
        cell.button_addFriend.enabled = NO;
        
        [cell.button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.button_addFriend setTitle:@"已添加" forState:UIControlStateHighlighted];
    }
    
//    NSString* spacenote= [list_dic objectForKey:@"spacenote"];
    NSString* name= [list_dic objectForKey:@"name"];
    NSString* shcool= [list_dic objectForKey:@"shcool"];
    NSString* pic= [list_dic objectForKey:@"avatar"];

    cell.name = name;
    cell.shcool = shcool;
    cell.uid = [list_dic objectForKey:@"uid"];

    cell.spacenote = @"这家伙很懒，什么都没有留下。";

    [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:[eidList objectAtIndex:indexPath.row] forKey:@"tid"];
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         [eidList objectAtIndex:indexPath.row], @"tid",
//                         [subuidList objectAtIndex:indexPath.row], @"subuid", nil];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToKnowledgeDetailView" object:self userInfo:dic];
    NSDictionary* list_dic = [listDataArray objectAtIndex:indexPath.row];
    NSString *fuid = [list_dic objectForKey:@"uid"];
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
    
    
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
  
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        NSArray *temp = [resultJSON objectForKey:@"message"];
        
        for (NSObject *object in temp)
        {
            [listDataArray addObject:object];
        }
        
        // 刷新表格内容
        [_tableView reloadData];
    }
    else
    {
       
        [Utilities dismissProcessingHud:self.view];//2015.05.12
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"搜索错误，请重试"
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

@end

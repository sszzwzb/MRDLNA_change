//
//  SchoolExhibitionViewController.m
//  MicroSchool
//
//  Created by jojo on 14/11/28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SchoolExhibitionViewController.h"
#import "RegionsViewController.h"
#import "SchoolModuleListViewController.h"

@interface SchoolExhibitionViewController ()

@end

@implementation SchoolExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"校校通"];
    [super setCustomizeLeftButton];
   
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    searchResults = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    
    [ReportObject event:ID_OTHER_SCHOOL_HOME];//2015.06.25
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    // 去城市筛选页
    RegionsViewController *regionV = [[RegionsViewController alloc]init];
    regionV.fromName = @"stos";//school to school 校校通
    [self.navigationController pushViewController:regionV animated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    [Utilities showProcessingHud:self.view];//2015.07.11
    [self performSelector:@selector(doGetExhiSchool) withObject:nil afterDelay:0.1];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    // search bar
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"输入关键字搜索学校"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    _tableView.tableHeaderView = mySearchBar;
    
    _label_noLike = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           20,
                                                           ([UIScreen mainScreen].applicationFrame.size.height - 50-44)/2,
                                                           [UIScreen mainScreen].applicationFrame.size.width - 40,
                                                           50)];
    //设置title自适应对齐
    _label_noLike.font = [UIFont systemFontOfSize:19.0f];
    _label_noLike.lineBreakMode = NSLineBreakByWordWrapping;
    _label_noLike.numberOfLines = 0;
    _label_noLike.textAlignment = NSTextAlignmentCenter;
    _label_noLike.backgroundColor = [UIColor clearColor];
    _label_noLike.textColor = [UIColor blackColor];
    _label_noLike.text = @"您还没有收藏学校，点击右上角收藏一所试试吧！";
    _label_noLike.hidden = YES;
    [_tableView addSubview:_label_noLike];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doReflashView:) name:NOTIFICATION_UI_SCHOOLEXHI_REFLASHVIEW object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)doReflashView:(NSNotification *)notification
{
    // 收藏学校之后刷新收藏列表
    [self doGetExhiSchool];
}

-(void)doGetExhiSchool
{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"OtherSchool", @"ac",
                          @"2", @"v",
                          @"favorites", @"op",
                          nil];
    
    [network sendHttpReq:HttpReq_GetOtherSchoolFavorite andData:data];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return  [searchResults count];
    }else {
        return  [dataArray count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 70;
    }else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if 0
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NameAndImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[NameAndImgTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.label_name.frame = CGRectMake(20, (50-20)/2, 200, 20);
        cell.label_name.text = [[searchResults objectAtIndex:[indexPath row]] objectForKey:@"name"];
    } else {
    }
#endif
    
    static NSString *CellTableIdentifier = @"SchoolTableViewCell";
    
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"SchoolTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString* head_url = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"logo"];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
        cell.titleLabel.text = [Utilities replaceNull:[[searchResults objectAtIndex:[indexPath row]] objectForKey:@"name"]];
        
    } else {
        NSString* head_url = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
        cell.titleLabel.text = [Utilities replaceNull:[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"name"]];
        
    }

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
     NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //---add by kate---------------------------------------------------------------------
        SchoolModuleListViewController *smlV = [[SchoolModuleListViewController alloc]init];
        smlV.otherSid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] objectForKey:@"sid"]]];
        smlV.otherSchoolName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        smlV.favorite = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[searchResults objectAtIndex:indexPath.row] objectForKey:@"favorite"]]];
        
        if ([schoolType isEqualToString:@"bureau"]){
            smlV.fromView = @"bureauExhibition";
        }
        [self.navigationController pushViewController:smlV animated:YES];
        //-----------------------------------------------------------------------------------
        
        
    }else {
        //---add by kate---------------------------------------------------------------------
        SchoolModuleListViewController *smlV = [[SchoolModuleListViewController alloc]init];
        smlV.otherSid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"sid"]]];
        smlV.otherSchoolName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        smlV.favorite = @"1";
        if ([schoolType isEqualToString:@"bureau"]){
            smlV.fromView = @"bureauExhibition";
        }
        [self.navigationController pushViewController:smlV animated:YES];
        //-----------------------------------------------------------------------------------
    }
}

#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![@""  isEqual: mySearchBar.text]) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"OtherSchool", @"ac",
                              @"2", @"v",
                              @"search", @"op",
                              mySearchBar.text, @"keyword",
                              @"0",@"page",
                              @"100",@"size",
                              nil];
        
        [network sendHttpReq:HttpReq_GetOtherSchoolResult andData:data];
    }else {
        [searchResults removeAllObjects];
    }
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
    
    if ([@"OtherSchoolAction.search"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        // 动态搜索学校列表
        [searchResults removeAllObjects];

        if(true == [result intValue]) {

            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            if (0 != [message_info count]) {
                [searchResults addObjectsFromArray:[message_info objectForKey:@"list"]];
            }
            
            // 刷新search view
            [self.searchDisplayController.searchResultsTableView reloadData];
        }else {
        }
    }else if ([@"OtherSchoolAction.favorites" isEqual: [resultJSON objectForKey:@"protocol"]]){
        // 收藏的学校
        [self setCustomizeRightButton:@"SchoolExhibition/icon_add_right.png"];//add by kate 2015.04.14

        if (![Utilities isConnected]) {//2015.06.30
            
            noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
            [self.view addSubview:noNetworkV];
            
        }else{
            
            [noNetworkV removeFromSuperview];
        }
        if(true == [result intValue]) {
            NSArray* message_info = [resultJSON objectForKey:@"message"];
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:message_info];
            
            if (0 == [dataArray count]) {
                _label_noLike.hidden = NO;
            }else {
                _label_noLike.hidden = YES;
            }
            
            [_tableView reloadData];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取收藏学校错误，请稍候再试"
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
    
    if ([mySearchBar.text length]>0) {
        
    }else{
        if (![Utilities isConnected]) {//2015.06.30
            
            noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
            [self.view addSubview:noNetworkV];
            
        }else{
            
            [noNetworkV removeFromSuperview];
        }
    }
    
    
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
    
}

@end

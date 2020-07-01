//
//  SubscribeNumListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SubscribeNumListViewController.h"
#import "MyClassListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SubscribeViewNewsListController.h"
#import "SubscribeNumListTableViewCell.h"
#import "MyTabBarController.h"

@interface SubscribeNumListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubscribeNumListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    startNum = @"0";
    
    reflashFlag = 1;
    isReflashViewType = 1;
    
    //lasts = [[NSUserDefaults standardUserDefaults]objectForKey:@"subscribeLasts"];
#if 0
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastSubscribeNumDic"]];

    NSArray *allKeysArray = [tempDic allKeys];
    
    for (int i =0; i<[allKeysArray count]; i++) {
        
        id key  = [allKeysArray objectAtIndex:i];
        id value = [tempDic objectForKey:key];
        
        NSString *item = [NSString stringWithFormat:@"%@:%@",key,value];
        if (i == 0) {
            lasts = item;
        }else{
            lasts = [NSString stringWithFormat:@"%@,%@",lasts,item];
        }
        
    }
#endif
    
    [Utilities updateSchoolRedPoints:_lastSubscribeId mid:_mid];//更新主页导读红点 2016.02.19
    //------2015.11.12--------------------------------------------------------------------------------------------
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
    
    if (defaultsDic) {
        
        NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithArray:[defaultsDic objectForKey:@"numbers"]];
        
        if ([filteredArray count]>0) {
        
            for (int i=0; i<[filteredArray count]; i++) {
                
                NSDictionary *dic = [filteredArray objectAtIndex:i];
                NSString *key = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mid"]];
                NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:@"last"]];
                NSString *item = [NSString stringWithFormat:@"%@:%@",key,value];
                if (i == 0) {
                    lasts = item;
                }else{
                    lasts = [NSString stringWithFormat:@"%@,%@",lasts,item];
                }
                
            }
        }
    }
    
    //----------------------------------------------------------------------------------------------------------------
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [_tableView addSubview:_refreshHeaderView];
    
    isFirst = 0;
    
    [self getData:0];
    
    [ReportObject event:ID_SUBSCRIPTION_HOME];//2015.06.25
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    // 更新主画面new图标 2015.11.12
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:_newsDic];
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
//    if (isFirst!=0) {
//
//        [self refreshView];
//        isFirst = 0;
//    }
    
}

-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    [self loadData:index];
    
}

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //NSLog(@"lasts:%@",lasts);
        
        NSMutableArray *array = [FRNetPoolUtils getSubscribeNumList:index size:@"20" lasts:lasts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
            }else{
                
                [noNetworkV removeFromSuperview];
            }
            
            if (array == nil) {
                
                // 2015.06.30
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if([array count] >0){
                    
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    if ([startNum intValue] > 0) {
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            [listArray addObject:[array objectAtIndex:i]];
                            
                        }
                        
                    }else{
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array];
                        
                    }
                    
                    [noDataView removeFromSuperview];
                    
                }else{
                    
                    if ([startNum integerValue] == 0) {
                        CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                        noDataView = [Utilities showNodataView:@"没有相关内容" msg2:@"" andRect:rect imgName:@"消息列表_03.png"];
                        [self.view addSubview:noDataView];
                    }
                    
                   
                }
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }
        });
        
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [listArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"SubscribeNumListTableViewCell";
    SubscribeNumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"SubscribeNumListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
//        cell = [[SubscribeNumListTableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    /*
     list =         (
     {
     article =                 {
     count = 0;
     dateline = 1429677323;
     title = "\U6d4b\U8bd5\U6807\U98982";
     };
     "auth_desc" = "\U6211\U662f\U63cf\U8ff0";
     "auth_status" = 1;
     name = "\U77e5\U6821";
     number = 1;
     pic = "http://test.5xiaoyuan.cn/ucenter/data/avatar/000/06/32/35_avatar_middle.jpg";
     type = 2;
     }
     );
     */
    
    NSMutableDictionary *articleDic = [[listArray objectAtIndex:indexPath.row] objectForKey:@"article"];
    
    NSString *countStr = [Utilities replaceNull:[articleDic objectForKey:@"count"]];
    
    if ([countStr integerValue] > 0) {
        
        cell.redLabel.backgroundColor = [UIColor redColor];
        
        
        if ([countStr length] > 1) {

            if ([countStr integerValue] > 99) {
                countStr = @"99+";
            }
            
            if ([countStr length] > 2) {
                
                cell.redLabel.frame = CGRectMake(cell.redLabel.frame.origin.x - (15*[countStr length]/4.0), cell.redLabel.frame.origin.y, 13*[countStr length], 20.0);
            }else if([countStr length] ==  1){
                cell.redLabel.frame = CGRectMake(cell.redLabel.frame.origin.x-10.0, cell.redLabel.frame.origin.y, 13*[countStr length], 20.0);
            }else{
                 cell.redLabel.frame = CGRectMake(cell.redLabel.frame.origin.x, cell.redLabel.frame.origin.y, 13*[countStr length], 20.0);
            }
            
        }
        
        cell.redLabel.text = countStr;
        cell.redLabel.hidden = NO;
    }else{
        cell.redLabel.hidden = YES;
    }
    
    
    cell.redLabel.layer.cornerRadius =  10.0;
    cell.redLabel.layer.masksToBounds = YES;
    
    NSString *date = [Utilities replaceNull:[articleDic objectForKey:@"dateline"]];
    
    NSString *dateStr = @"";
    
    if (![@"0" isEqualToString:date]) {
        
        dateStr = [Utilities timeIntervalToDate:[[Utilities replaceNull:[articleDic objectForKey:@"dateline"]] longLongValue] timeType:2 compareWithToday:YES];
        
    }
    
    if ([@"昨天" isEqualToString:dateStr]) {
         cell.detalineLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [dateStr length]*13.0-10.0, cell.detalineLabel.frame.origin.y, [dateStr length]*13.0, 21.0);
    }else{
         cell.detalineLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [dateStr length]*8.0-10.0, cell.detalineLabel.frame.origin.y, [dateStr length]*8.0, 21.0);
    }
    
    cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - cell.detalineLabel.frame.size.width-10, cell.titleLabel.frame.size.height);
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"dyh.png"]];
    cell.titleLabel.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    cell.detailLabel.text = [articleDic objectForKey:@"title"];
    cell.detalineLabel.text = dateStr;
    
    return cell;
    
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *number = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"number"]]];
    NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    
    SubscribeViewNewsListController *subsribeV = [[SubscribeViewNewsListController alloc]init];
    subsribeV.number = number;
    subsribeV.titleName = name;
    subsribeV.subscribNumName = name;
    [self.navigationController pushViewController:subsribeV animated:YES];
    //isFirst = 1;
    
    SubscribeNumListTableViewCell *cell = (SubscribeNumListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.redLabel.hidden = YES;
    
    // update 2015.04.28
    NSMutableDictionary *itemDic = [[NSMutableDictionary alloc]initWithDictionary:[listArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *articleDic = [[NSMutableDictionary alloc]initWithDictionary:[itemDic objectForKey:@"article"]];
    [articleDic setObject:@"0" forKey:@"count"];
    [itemDic setObject:articleDic forKey:@"article"];
    [listArray replaceObjectAtIndex:indexPath.row withObject:itemDic];
    
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0){
    
    return YES;
}

// 按下改变cell里面控件的颜色等 如Label
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0){
    
    NSDictionary *articleDic = [[listArray objectAtIndex:indexPath.row] objectForKey:@"article"];
    
    NSString *countStr = [Utilities replaceNull:[articleDic objectForKey:@"count"]];
    
    if([countStr length] > 0){
        SubscribeNumListTableViewCell *cell = (SubscribeNumListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if(!cell.redLabel.hidden){
            cell.redLabel.backgroundColor = [UIColor redColor];
        }
    }

    
}


//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        [self loadData:startNum];
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[listArray count]];
        NSLog(@"startNum:%@",startNum);
        [self loadData:startNum];
        
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(_tableView.bounds.size.height, _tableView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, _tableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_reloading == NO) {
        [self beginToReloadData:aRefreshPos];
    }
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

@end

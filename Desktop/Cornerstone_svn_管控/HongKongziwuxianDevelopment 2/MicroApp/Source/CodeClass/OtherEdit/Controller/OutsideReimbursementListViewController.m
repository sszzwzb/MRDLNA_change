//
//  OutsideReimbursementListViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementListViewController.h"

#import "OnlyEditPerButDownView.h"
#import "OutsideReimbursementListTableViewCell.h"
#import "OutsideReimbursementListModel.h"


#import "OutsideReimbursementEditViewController.h"
#import "OutsideReimbursementDetailViewController.h"


static NSString * showOutsideReimbursementListTableViewCell = @"cell";

@interface OutsideReimbursementListViewController () <UITableViewDelegate,UITableViewDataSource,OnlyEditPerButDownViewDelegate,HttpReqCallbackDelegate>

@property (nonatomic,assign) NSInteger type;  //  外采报销0   剩余油量1

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) OnlyEditPerButDownView *downButView;  //  新增按键

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation OutsideReimbursementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    if ([self.title isEqualToString:@"外采报销"]) {
        [self setCustomizeTitle:@"外采报销"];
        _type = 0;
        
        
        //  外采上传，权限
        [self up_data_GetFlyingTube];
        
    } else if ([self.title isEqualToString:@"剩余油量"]) {
        [self setCustomizeTitle:@"剩余油量"];
        _type = 1;
    }
    
    
    
    
    
    _dataArr = [NSMutableArray array];
    _page = 0;
    
    [self up_tableView];
    
    [self up_downButView];
    
    
    [self up_data];
    
    [self MJRefreshNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:@"OutsideReimbursementListViewController_reloadData" object:nil];
}

-(void)up_downButView
{
    _downButView = [[OnlyEditPerButDownView alloc]initWithFrame:
                                           CGRectMake(0, KScreenHeight - KScreenTabBarHeight - 49 - KScreenNavigationBarHeight, KScreenWidth, 49)];
    _downButView.typeInt = 0;
    [self.view addSubview:_downButView];
    _downButView.delegate = self;
}


#pragma mark - OnlyEditPerButDownViewDelegate
-(void)selectButDownViewWithTag:(NSInteger)tag
{
    NSLog(@"新建");
    
    OutsideReimbursementEditViewController *vc = [[OutsideReimbursementEditViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)up_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarHeight - KScreenNavigationBarHeight - 49) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerClass:[OutsideReimbursementListTableViewCell class] forCellReuseIdentifier: showOutsideReimbursementListTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OutsideReimbursementListTableViewCell cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutsideReimbursementListTableViewCell *cell = (OutsideReimbursementListTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOutsideReimbursementListTableViewCell forIndexPath:indexPath];
    
    if ([_dataArr count] > 0) {
        cell.model = _dataArr[indexPath.section];
        [cell reloadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
    OutsideReimbursementDetailViewController *vc = [[OutsideReimbursementDetailViewController alloc]init];
    vc.model = _dataArr[indexPath.section];
    vc.hidesBottomBarWhenPushed = YES;
    if (_type == 0) {
        vc.title = @"外采报销详情";
    } else {
        vc.title = @"剩余油量详情";
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}






#pragma mark - 加载  2017.10.19  kaiyi
-(void) MJRefreshNormal
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个getData）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNewData];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreMessage)];
    
    // 设置了底部inset
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
    // 如果没有数据的时候，没有上拉加载
    _tableView.mj_footer.automaticallyHidden = YES;
    
    [self reRefreshFooterHidden];
    
    _tableView.mj_footer.hidden = _tableView.contentSize.height <= CGRectGetHeight(_tableView.mj_footer.scrollView.frame) ? YES : NO;
    
}

#pragma mark - 2017.10.17   数据不足一页的时候，不显示上拉加载
-(void)reRefreshFooterHidden
{
    [_tableView.mj_footer.scrollView setMj_reloadDataBlock:^(NSInteger totalDataCount)
     {
         [_tableView layoutIfNeeded];
         
         _tableView.mj_footer.hidden = _tableView.contentSize.height <= CGRectGetHeight(_tableView.mj_footer.scrollView.frame) ? YES : NO;
     }];
}

-(void)closeRefreshAll
{
    //  不知道为什么那么多结束加载，目前解决办法，全部取消，不做处理。
    //  UI 暂时不优化，等有人提交bug在做处理  2017.10.19
    [_tableView.mj_header endRefreshing];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_tableView.mj_footer endRefreshing];
        
    });
    
    [self reRefreshFooterHidden];
}

-(void)getNewData
{
    [_dataArr removeAllObjects];
    _page = 0;
    [self up_data];
}

-(void)getMoreMessage
{
    _page++;
    [self up_data];
}




-(void)up_data
{
    
    if (_type == 0) {
        [self up_data_forGetOrderFinWCList];
    } else {
        [self up_data_forGetOrderFinOilList];
    }
    
}


-(void)up_data_GetFlyingTube
{
    /**
     
     外采上传 权限
     http://app.meridianjet.vip/login.svc/login.svc/GetFlyingTube
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/GetFlyingTube",
                           
                           @"UserName":[UtilitiesData getLoginUserName]
                           };
    
    [network sendHttpReq:HttpReq_GetFlyingTube andData:data];
}


-(void)up_data_forGetOrderFinWCList
{
    /**
     
     外采已完成接口
     http://app.meridianjet.vip/login.svc/login.svc/GetOrderFinWCList
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    if (_page == 0) {
        [Utilities showProcessingHud:self.view];
    }
    
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/GetOrderFinWCList",
                           
                           @"UserName":[UtilitiesData getLoginUserName],
                           @"num":[NSString stringWithFormat:@"%ld",_page],
                           @"Count":@"10"
                           };
    
    [network sendHttpReq:HttpReq_GetOrderFinWCList andData:data];
}

-(void)up_data_forGetOrderFinOilList
{
    /**
     
     已完成剩油得
     http://app.meridianjet.vip/login.svc/login.svc/GetOrderFinOilList
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    if (_page == 0) {
        [Utilities showProcessingHud:self.view];
    }
    
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/GetOrderFinOilList",
                           
                           @"UserName":[UtilitiesData getLoginUserName],
                           @"num":[NSString stringWithFormat:@"%ld",_page],
                           @"Count":@"10"
                           };
    
    [network sendHttpReq:HttpReq_GetOrderFinOilList andData:data];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"OutsideReimbursementListViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
    
    //   已完成剩油得  &  外采已完成接口
    if (type == HttpReq_GetOrderFinOilList || type == HttpReq_GetOrderFinWCList) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            NSString *MessageStr = [Utilities replaceNull:resultJSON[@"Message"]];
            NSArray *MessageArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:MessageStr]];
            
            if (_page == 0) {
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in MessageArr) {
                OutsideReimbursementListModel *model = [OutsideReimbursementListModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            
            [_tableView reloadData];
            
            //  没有数据显示
            [Utilities showNoListView:@"" msg2:@"" descView:_tableView isShow:([_dataArr count] == 0 ? YES : NO)];
            
            [self closeRefreshAll];
            
        } else {
            [self closeRefreshAll];
            
            [Utilities showNoListView:@"" msg2:@"" descView:_tableView isShow:([_dataArr count] == 0 ? YES : NO)];
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    
    if (type == HttpReq_GetFlyingTube) {
        if ([resultJSON[@"Result"] boolValue]) {
            
            
            
        } else {
            [Utilities dismissProcessingHud:self.view];
            
            _downButView.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarHeight - KScreenNavigationBarHeight);
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:nil];
        }
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
        [self closeRefreshAll];
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
    }
}


@end

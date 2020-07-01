//
//  NewClassPhotoViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "NewClassPhotoViewController.h"
#import "NewClassPhotoTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "MomentsDetailViewController.h"
#import "MyTabBarController.h"
#import "PublishMomentsViewController.h"


@interface NewClassPhotoViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewClassPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"班级相册"];
    
    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student) {
        [self setCustomizeRightButton:@"ClassKin/icon_sendPhoto"];
    }
    
    _tableView.hidden = YES;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reLoadClassNewPhoto"
                                               object:nil];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView addSubview:_refreshHeaderView];
    
    
    heightArray = [[NSMutableArray alloc] init];
    
    [Utilities showProcessingHud:self.view];
    [self getData:@"0"];
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 传照片
-(void)selectRightAction:(id)sender{
    
    PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
    publish.flag = 0;
    publish.cid = _cId;
    publish.fromName = @"classPhotoList";
    [self.navigationController pushViewController:publish animated:YES];
    
}


-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData:(NSString*)index{
    
    /**
     * 班级相册最新
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classTopics sid= cid= uid= app= page= size=
     */
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classTopics", @"op",
                          _cId,@"cid",
                          index,@"page",
                          @"20",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
             NSLog(@"班级相册返回:%@",respDic);
            
            _tableView.hidden = NO;
            NSArray *array = [[respDic objectForKey:@"message"] objectForKey:@"list"];
            
            if ([array count] > 0) {
                
                [noDataView removeFromSuperview];
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [listArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                }
                
                [heightArray removeAllObjects];
                
                for (int i=0; i<[listArray count]; i++) {
                    
                    float height;
                    
                        //如果是图片类型
                        height = 90.0;
                   
                    
                    height = [self getHeight:height index:i];
                    
                    NSString *heightStr = [NSString stringWithFormat:@"%f",height];
                    [heightArray addObject:heightStr];
                    
                }
                
                
            }else{
                
                    if([startNum intValue] == 0){
                        
                         listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        [noDataView removeFromSuperview];
                        
                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                       
                        noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png"];
                        [self.view addSubview:noDataView];
                    }
                
            }
            
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *GroupedTableIdentifier0 = @"NewClassPhotoTableViewCell";//图片类型
    
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
    NSString *count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    NSString *imgUrl = [dic objectForKey:@"thumb"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];//type: 1 视频；0 图片；
    
    
    //如果是图片类型
        
        NewClassPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier0];
    
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"NewClassPhotoTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier0];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    
    cell.delegte = self;
    cell.index = indexPath.row;
    
    if (indexPath.row == 0) {
        
       NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:9 compareWithToday:YES];
        
        if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]) {
            
            cell.dayLabel.font = [UIFont systemFontOfSize:18.0];
            cell.dayLabel.text = isYestOrToday;
            cell.monthLabel.text = @"";
            
        }else{
            
            cell.dayLabel.font = [UIFont systemFontOfSize:24.0];
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
        }
        
    }
    
    if (indexPath.row-1 >= 0) {
        
         NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:9 compareWithToday:YES];
        
        cell.monthLabel.text = [tempDate substringToIndex:3];
        cell.dayLabel.text = [tempDate substringFromIndex:3];
        
        NSDictionary *list_dic = [listArray objectAtIndex:indexPath.row-1];
        NSString *dateline = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
        NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        
        
        if (![tempDate isEqualToString:tempDateB]) {
            
            // NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:4 compareWithToday:YES];
            if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]) {
                
                cell.dayLabel.font = [UIFont systemFontOfSize:18.0];
                cell.dayLabel.text = isYestOrToday;
                cell.monthLabel.text = @"";
                
            }else{
                
                cell.dayLabel.font = [UIFont systemFontOfSize:24.0];
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
            }
            
        }else{
            cell.monthLabel.text = @"";
            cell.dayLabel.text = @"";
            
        }
        
    }
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    if ([type integerValue] == 1) {// type: 1 视频；0 图片；
        
        cell.videoImgV.hidden = NO;
    }else{
        cell.videoImgV.hidden = YES;
    }
    
    if ([count integerValue] > 1) {
        cell.imgNumLabel.text = [NSString stringWithFormat:@"共%@张",count];
    }else{
        cell.imgNumLabel.text = @"";
    }
    
    cell.titleLabel.text = title;

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height = [[heightArray objectAtIndex:indexPath.row] floatValue];

    return height;
}

-(float)getHeight:(float)height index:(NSInteger)row{
    
    NSDictionary *dic = [listArray objectAtIndex:row];
    NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
    
    if (row+1 < [listArray count]) {
        
        NSDictionary *list_dic = [listArray objectAtIndex:row+1];
        NSString *dateline = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
        NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        
        if (![tempDate isEqualToString:tempDateB]) {
            
            height = height + 15.0;
            
        }else{
            
            height = height + 5;
        }
        
    }
    
    return height;
}

#pragma 回调
-(void)gotoFootmarkPicDetail:(NSInteger)index type:(NSString*)type{
    
    /**
     * 班级相册图片详情
     *
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classTopic sid= cid= uid= tid=主题ID app= page= size=
     */
    NSString *tid = [[listArray objectAtIndex:index] objectForKey:@"id"];
#if 0
    MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
    momentsDetailViewCtrl.tid = tid;//动态id
    //momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
    momentsDetailViewCtrl.fromName = @"classPhoto";
    momentsDetailViewCtrl.cid = _cId;
    [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoFootmarkPicDetail" object:tid userInfo:nil];
}

-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        [self getData:startNum];
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[listArray count]];
        [self getData:startNum];
        
    }
    
    //[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self->_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
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

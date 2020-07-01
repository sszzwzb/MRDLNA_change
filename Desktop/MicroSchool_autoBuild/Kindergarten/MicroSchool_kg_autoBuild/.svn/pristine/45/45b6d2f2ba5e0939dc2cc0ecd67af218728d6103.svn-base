//
//  SingleSubjectListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "SingleSubjectListViewController.h"
#import "SingleSubjectTableViewCell.h"

@interface SingleSubjectListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SingleSubjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView addSubview:_refreshHeaderView];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
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

/**
 *  单科成绩纪录
 * @author luke
 * @date 2015.10.08
 * @args
 *  v=2, ac=GrowingSpace, op=course, sid=, uid=, cid=, course=学科ID, page=, size=
 */
-(void)getData:(NSString*)index{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"course", @"op",
                          _cId,@"cid",
                          _subjectId,@"course",
                          index,@"page",
                          @"20",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"单科成绩列表:%@",respDic);
            
            _tableView.hidden = NO;
            
            NSMutableArray *array = [[respDic objectForKey:@"message"] objectForKey:@"list"];
            
            if ([array count] >0) {
                
                [noDataView removeFromSuperview];
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [listArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                }
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                    noDataView = [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:rect];
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

-(void)reload{
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return [listArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 15;
    }else{
        return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"SingleSubjectTableViewCell";
    
    SingleSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"SingleSubjectTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *profileDic = [[listArray objectAtIndex:indexPath.section]objectForKey:@"profile"];
    NSDictionary *classDic = [[[listArray objectAtIndex:indexPath.section]objectForKey:@"clazz"] objectForKey:@"rank"];
    NSDictionary *schoolDic = [[[listArray objectAtIndex:indexPath.section]objectForKey:@"school"] objectForKey:@"rank"];
    NSString *dateStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[profileDic objectForKey:@"dateline"]]];
    
    cell.scoreNameLabel.text = [NSString stringWithFormat:@"%@",[profileDic objectForKey:@"name"]];
    
    NSString *score = [NSString stringWithFormat:@"%@",[profileDic objectForKey:@"score"]];
    if ([score length] == 0) {
        score = @"--";
    }else if ([score integerValue] == -1){
        score = @"--";
    }
    
    cell.totalLabel.text = score;
    
    
    NSString *date = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
    cell.dateLineLabel.text = [NSString stringWithFormat:@"更新时间：%@",date];
    
    cell.classRankLabel.text = [NSString stringWithFormat:@"%@",[classDic objectForKey:@"val"]];
    cell.schoolRankLabel.text = [NSString stringWithFormat:@"%@",[schoolDic objectForKey:@"val"]];
    //cell.classAverage.text = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"clazz"] objectForKey:@"avg"]];
    
    NSString *scoreClassAverage = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"clazz"] objectForKey:@"avg"]];
    if ([scoreClassAverage length] == 0) {
        scoreClassAverage = @"--";
    }else if ([scoreClassAverage integerValue] == -1){
        scoreClassAverage = @"--";
    }
    
    cell.classAverage.text = scoreClassAverage;
    
    //cell.schoolAverage.text = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"school"] objectForKey:@"avg"]];
    NSString *scoreschoolAverage = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"school"] objectForKey:@"avg"]];
    if ([scoreschoolAverage length] == 0) {
        scoreschoolAverage = @"--";
    }else if ([scoreschoolAverage integerValue] == -1){
        scoreschoolAverage = @"--";
    }
    
    cell.schoolAverage.text = scoreschoolAverage;
    
    
    //cell.classHighest.text = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"clazz"] objectForKey:@"max"]];
    
    NSString *scoreclassHighest = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"clazz"] objectForKey:@"max"]];
    if ([scoreclassHighest length] == 0) {
        scoreclassHighest = @"--";
    }else if ([scoreclassHighest integerValue] == -1){
        scoreclassHighest = @"--";
    }
    cell.classHighest.text = scoreclassHighest;
    
    
    //cell.schoolHighest.text = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"school"] objectForKey:@"max"]];
    NSString *scoreschoolHighest = [NSString stringWithFormat:@"%@",[[[listArray objectAtIndex:indexPath.section]objectForKey:@"school"] objectForKey:@"max"]];
    if ([scoreschoolHighest length] == 0) {
        scoreschoolHighest = @"--";
    }else if ([scoreschoolHighest integerValue] == -1){
        scoreschoolHighest = @"--";
    }
    cell.schoolHighest.text= scoreschoolHighest;
    
    
    NSString *classUpOrDown = [classDic objectForKey:@"ord"];// lt 下降，gt 上升, eq 不变
    if ([classUpOrDown isEqualToString:@"gt"]) {//上升
        cell.classScoreRankImgV.image = [UIImage imageNamed:@"scoreUp.png"];
    }else if([classUpOrDown isEqualToString:@"lt"]){//下降
        cell.classScoreRankImgV.image = [UIImage imageNamed:@"scoreDown.png"];
    }else{
        cell.classScoreRankImgV.image = [UIImage imageNamed:@"eq.png"];;
    }
    
    NSString *schoolUpOrDown = [schoolDic objectForKey:@"ord"];// lt 下降，gt 上升, eq 不变
    if ([schoolUpOrDown isEqualToString:@"gt"]) {//上升
        cell.schoolScoreRankImgV.image = [UIImage imageNamed:@"scoreUp.png"];
    }else if([schoolUpOrDown isEqualToString:@"lt"]){//下降
        cell.schoolScoreRankImgV.image = [UIImage imageNamed:@"scoreDown.png"];
    }else{
        cell.schoolScoreRankImgV.image = [UIImage imageNamed:@"eq.png"];
    }
    
        cell.classScoreRankImgV.frame = CGRectMake(cell.classRankLabel.frame.origin.x+[cell.classRankLabel.text length]*8.0+5, cell.classScoreRankImgV.frame.origin.y, cell.classScoreRankImgV.frame.size.width, cell.classScoreRankImgV.frame.size.height);
        cell.schoolScoreRankImgV.frame = CGRectMake(cell.schoolRankLabel.frame.origin.x+[cell.schoolRankLabel.text length]*8.0+5, cell.classScoreRankImgV.frame.origin.y, cell.schoolScoreRankImgV.frame.size.width, cell.schoolScoreRankImgV.frame.size.height);
    
    
    if ([cell.classRankLabel.text length] == 0 || [cell.classRankLabel.text integerValue] == 0) {
        cell.classScoreRankImgV.image = nil;
        cell.classRankLabel.text = @"--";
    }
    if ([cell.schoolRankLabel.text length] == 0 || [cell.schoolRankLabel.text integerValue] == 0) {
        cell.schoolScoreRankImgV.image = nil;
        cell.schoolRankLabel.text = @"--";
    }
    
    return cell;
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
        
        startNum = [NSString stringWithFormat:@"%d",[listArray count]];
        [self getData:startNum];
        
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

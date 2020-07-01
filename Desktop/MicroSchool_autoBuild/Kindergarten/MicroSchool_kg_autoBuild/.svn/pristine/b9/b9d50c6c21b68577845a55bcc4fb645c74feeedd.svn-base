//
//  ToReplyListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ToReplyListViewController.h"
#import "FRNetPoolUtils.h"
#import "AnswerQuestionViewController.h"

@interface ToReplyListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ToReplyListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"责任督学"];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_tableView addSubview:_refreshHeaderView];
    
    _tableView.hidden = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getData:@"0"];
    
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
}

// 获取数据从server
-(void)getData:(NSString*)startIndex{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if (reflashFlag != 1 ) {
        [Utilities showProcessingHud:self.view];//2015.05.12
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSMutableArray *array = [FRNetPoolUtils getToReplyAnswerList:startIndex size:@"20"];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if ([array count] > 0 ) {
                    
                    if ([startNum intValue] > 0) {
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            [listArray addObject:[array objectAtIndex:i]];
                        }
                        
                    }else{
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        
                    }
                    
                    
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                }
                
            }
        });
    });

}

// 刷新调用的方法
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

-(void)reload{
    
    [_tableView reloadData];
    
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.backgroundColor =   [UIColor clearColor];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    
    NSString *updatetime = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"updatetime"]];
    NSString *dateline = [[Utilities alloc] linuxDateToString:updatetime andFormat:@"%@年%@月%@日" andType:DateFormat_YMD];
    cell.textLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"message"]];
    cell.detailTextLabel.text = dateline;
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后的反显颜色即刻消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *Qid = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"id"]];
    NSString *QuserId = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"uid"]];
    NSString *questionText = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"message"]];
    NSString *updatetime = [Utilities replaceNull:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"updatetime"]];
    NSString *dateline =  [Utilities timeIntervalToDate:[updatetime longLongValue] timeType:10 compareWithToday:NO];
    AnswerQuestionViewController *answerQuV = [[AnswerQuestionViewController alloc]init];
    answerQuV.qustionText = questionText;
    answerQuV.date = dateline;
    answerQuV.aid = QuserId;
    answerQuV.rid = Qid;
    [self.navigationController pushViewController:answerQuV animated:YES];

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

@end

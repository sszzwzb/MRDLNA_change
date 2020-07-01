//
//  SchoolListByCityViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SchoolListByCityViewController.h"
#import "SchoolTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SchoolModuleListViewController.h"


@interface SchoolListByCityViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SchoolListByCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"选择学校"];
    [self setCustomizeLeftButton];
    
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
    
    [self getData:@"0"];
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
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

-(void)reload{
    
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    [self loadData:index];
}

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getSchool:_cid keyword:@"" page:index size:@"20"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
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
    
    static NSString *CellTableIdentifier = @"SchoolTableViewCell";
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"SchoolTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
    cell.titleLabel.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    
    
    return cell;
    
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    SchoolModuleListViewController *smlV = [[SchoolModuleListViewController alloc]init];
    smlV.otherSid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"sid"]]];
    smlV.otherSchoolName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    smlV.favorite = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"favorite"]]];
    smlV.fromView = @"SchoolExhibition";
    [self.navigationController pushViewController:smlV animated:YES];
    
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
        
        startNum = [NSString stringWithFormat:@"%d",[listArray count]];
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
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
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

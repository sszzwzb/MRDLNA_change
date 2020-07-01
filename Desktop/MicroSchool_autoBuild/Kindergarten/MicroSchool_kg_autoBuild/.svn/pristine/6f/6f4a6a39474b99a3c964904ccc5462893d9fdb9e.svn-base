//
//  teacherListViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "teacherListViewController.h"
#import "KnowlegeHomeTableViewCell.h"
#import "FRNetPoolUtils.h"
#import "UIImageView+WebCache.h"
#import "RegionsViewController.h"
#import "AuthorZoneViewController.h"

@interface teacherListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *searchResultTableV;

@end

NSString *ownsid;
@implementation teacherListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"教师列表"];
    [self setCustomizeRightButton:@"icon_sxbj.png"];
    ownsid = @"0";
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addSubview:_refreshHeaderView];
    
    noDataView = [[UILabel alloc]initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 44 - 22)/2.0, [UIScreen mainScreen].bounds.size.width, 22.0)];
    noDataView.text = @"无匹配的结果";
    noDataView.textAlignment = NSTextAlignmentCenter;
    noDataView.textColor = [UIColor grayColor];
    noDataView.font = [UIFont systemFontOfSize:20.0];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getData:@"0"];
    startNum = @"0";
    searchStartNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    _searchResultTableV.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    ownsid = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    if([_searchBar.text length] == 0){
         [_tableView reloadData];
    }else{
        [_searchResultTableV reloadData];
    }
   
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    //去筛选页
    RegionsViewController *regionV = [[RegionsViewController alloc]init];
    [self.navigationController pushViewController:regionV animated:YES];
    
}

// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    [self loadData:index];
}

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *diction = [FRNetPoolUtils getTeacherList:_searchBar.text ownsid:ownsid page:index size:@"20"];
        
        NSMutableArray *array = [diction objectForKey:@"list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            if (diction == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if ([array count] >0) {
                    
                    [noDataView removeFromSuperview];
                    
                    if([_searchBar.text length] == 0){
                        
                        if ([startNum intValue] > 0) {
                            
                            for (int i=0; i<[array count]; i++) {
                                
                                [listArray addObject:[array objectAtIndex:i]];
                                
                            }
                            
                        }else{
                            
                            listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                            
                        }
                    }else{
                        
                        _searchResultTableV.hidden = NO;
                        
                        if ([searchStartNum intValue] > 0) {
                            
                            for (int i=0; i<[array count]; i++) {
                                
                                [searchListArray addObject:[array objectAtIndex:i]];
                                
                                
                            }
                            
                        }else{
                            
                            searchListArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                            
                            
                        }
                        
                    }
                    
                }else{
                    
                    if ([startNum intValue] > 0) {
                        
                    }else{
                        
                        if([ownsid length] > 0 && [startNum intValue] == 0 ){
                            
                            [listArray removeAllObjects];//未筛选出结果
                            if ([_searchBar.text length]!=0) {
                                
                                _tableView.hidden = YES;
                                [searchListArray removeAllObjects];
                                [self.view addSubview:noDataView];
                            }
                            
                        }
                    }
                    
                }
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }
        });
        
    });
}

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        searchStartNum = @"0";
        if([_searchBar.text length] == 0){
             [self loadData:startNum];
        }else{
            [self loadData:searchStartNum];
        }
       
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        if([_searchBar.text length] == 0){
             startNum = [NSString stringWithFormat:@"%d",[listArray count]];
             [self loadData:startNum];
        }else{
             searchStartNum = [NSString stringWithFormat:@"%d",[searchListArray count]];
             [self loadData:searchStartNum];
        }
       
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];

}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([_searchBar.text length] != 0){
        return [searchListArray count];
    }else{
        return [listArray count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"KnowlegeHomeTableViewCell";
    
    KnowlegeHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"KnowlegeHomeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    // Configure the cell...
    
    if([_searchBar.text length] != 0){
        
        NSString* head_url = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        
        cell.teacherName.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
//        cell.detailLabel.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"school"]];
        //cell.specialLabel.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"special"]];
        NSString *specialStr = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"special"]];
        if ([specialStr length] > 0) {
            
            cell.teacherName.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.specialLabel.text =[NSString stringWithFormat:@"擅长科目:%@",specialStr];
            cell.teacherNameNoSpecial.text = @"";
        }else{
            
            cell.teacherNameNoSpecial.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.teacherName.text = @"";
            cell.specialLabel.text = @"";
            
        }
        cell.headImgV.layer.masksToBounds = YES;
        cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
        
    }else{
        NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        
        
//        cell.detailLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"school"]];
        
        NSString *specialStr = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"special"]];
        if ([specialStr length] > 0) {
            
            cell.teacherName.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.specialLabel.text =[NSString stringWithFormat:@"擅长科目:%@",specialStr];
            cell.teacherNameNoSpecial.text = @"";
        }else{
            
            cell.teacherNameNoSpecial.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.teacherName.text = @"";
            cell.specialLabel.text = @"";
            
        }
        cell.headImgV.layer.masksToBounds = YES;
        cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
    }
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *tid = nil;
    if (tableView == _searchResultTableV) {
        tid = [[searchListArray objectAtIndex:indexPath.row] objectForKey:@"uid"];
    }else{
        tid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"];
    }
    // 去作者空间
    AuthorZoneViewController *azvc = [[AuthorZoneViewController alloc]init];
    azvc.tid = tid;
    [self.navigationController pushViewController:azvc animated:YES];
    
}


#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        
        if ([_searchBar.text length] == 0) {
            
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        }else{
              [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_searchResultTableV];
        }
       
    }
    
    if (_refreshFooterView) {
        
        if ([_searchBar.text length] == 0) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        }else{
             [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_searchResultTableV];
        }
        [self setFooterView];
        
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    if ([_searchBar.text length] == 0) {
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
            
        }
        [_refreshFooterView removeFromSuperview];
        [self->_tableView addSubview:_refreshFooterView];

    }else{
        CGFloat height = MAX(self->_searchResultTableV.bounds.size.height, self->_searchResultTableV.contentSize.height);
        //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
        if (_refreshFooterView && [_refreshFooterView superview])
        {
            // reset position
            _refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self->_searchResultTableV.frame.size.width,
                                                  self.view.bounds.size.height);
        }else
        {
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.view.frame.size.width, self->_searchResultTableV.bounds.size.height)];
            //self->_tableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView.delegate = self;
            
        }
        
        [_refreshFooterView removeFromSuperview];
        [self->_searchResultTableV addSubview:_refreshFooterView];

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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    if (isOSVersionLowwerThan(@"7.0")) {
        for (id cc in [searchBar subviews]) {
            if ([cc isKindOfClass:[UIButton class]]) {
                UIButton *sbtn = (UIButton *)cc;
                [sbtn setTitle:@"取消"  forState:UIControlStateNormal];
                [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [sbtn setBackgroundImage:[UIImage imageNamed:@"cancel_normal.png"] forState:UIControlStateNormal];
                [sbtn setBackgroundImage:[UIImage imageNamed:@"cancel_press.png"] forState:UIControlStateHighlighted];
            }
        }
    }
    else{
        for(id cc in [searchBar subviews])
        {
            for (id zz in [cc subviews]) {
                if([zz isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)zz;
                    [btn setTitle:@"取消"  forState:UIControlStateNormal];
                }
            }
        }
    }
    
    _tableView.hidden = YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
    
    [_refreshHeaderView removeFromSuperview];
    [_searchResultTableV addSubview:_refreshHeaderView];
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = YES;
    ownsid = @"0";
    [self getData:@"0"];
    
    // 搜索键盘消失，但是取消按钮可用,点击取消回到原列表
    if (isOSVersionLowwerThan(@"7.0")) {
        for (id cc in [searchBar subviews]) {
            if ([cc isKindOfClass:[UIButton class]]) {
                UIButton *sbtn = (UIButton *)cc;
                [sbtn setTitle:@"取消"  forState:UIControlStateNormal];
                [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                sbtn.enabled = YES;
                
            }
        }
    }
    else{
        for(id cc in [searchBar subviews])
        {
            for (id zz in [cc subviews]) {
                if([zz isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)zz;
                    [btn setTitle:@"取消"  forState:UIControlStateNormal];
                    btn.enabled = YES;
                }
            }
        }
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // called when cancel button pressed
    
    [noDataView removeFromSuperview];
    searchBar.text = @"";
    _tableView.hidden = NO;
    _searchResultTableV.hidden = YES;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [_refreshHeaderView removeFromSuperview];
    [_tableView addSubview:_refreshHeaderView];
    [self setFooterView];
    
}

@end

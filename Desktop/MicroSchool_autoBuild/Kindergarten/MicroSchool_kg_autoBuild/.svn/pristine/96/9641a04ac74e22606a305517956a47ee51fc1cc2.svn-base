//
//  MySubscribedTeachersViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MySubscribedTeachersViewController.h"
#import "MySubscribedTeachersTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AuthorZoneViewController.h"

@interface MySubscribedTeachersViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MySubscribedTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"我订阅的教师"];
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
    
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    [self getData:@"0"];
    
    [ReportObject event:ID_OPEN_SUBSCRIBE_TEACHER];//2015.06.24
    
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData:(NSString*)index{
    
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    [self loadData:index];
    
}

-(void)loadData:(NSString*)index{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getMySubscribedTeachers:index size:@"20"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
                if ([array count] >0) {
                    
                    [noDataView removeFromSuperview];
                    
                    if ([startNum intValue] > 0) {
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            [listArray addObject:[array objectAtIndex:i]];
                        }
                        
                    }else{
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        
                    }
                    
                    
                   
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }else{
                    
                     if ([listArray count] == 0) {
                    
                      noDataView = [Utilities showNodataView:@"暂未订阅名师" msg2:@"订阅作者跟踪最新知识点"];
                         [self.view addSubview:noDataView];
                     }

                }
                
            }
            
             [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
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



#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"MySubscribedTeachersTableViewCell";
    
    MySubscribedTeachersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"MySubscribedTeachersTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    cell.titleLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
//    cell.detailLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"school"]];
    NSString *specialStr = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"special"]];
    if ([specialStr length] > 0) {
        cell.dateLineLabel.text = [NSString stringWithFormat:@"擅长科目:%@",specialStr];
    }
    
    
    cell.headImgV.layer.masksToBounds = YES;
    cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
//    NSString *payment = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"payment"]];
//    NSString *isFree = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"free"]];
//    [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
//    cell.isFreeBtn.layer.masksToBounds = YES;
//    cell.isFreeBtn.layer.cornerRadius = 2.0;
//    if([isFree intValue] == 1){//免费
//        [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:169.0/255.0 blue:250.0/255.0 alpha:1]];
//    }else{//付费
//        [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1]];
//    }
    NSString *end_time = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row]objectForKey:@"end_time"]];
   
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    //subscribed
    NSString *subscribed = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row]objectForKey:@"subscribed"]];
    
    if ([subscribed intValue] == 0) {
        //续费
        [cell.continueBtn setTitle:@"续费" forState:UIControlStateNormal];
//        [cell.continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [cell.continueBtn setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:91.0/255.0 blue:63.0/255.0 alpha:1]];
        [cell.continueBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
        [cell.continueBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateHighlighted];
    }else{
        
        Utilities *util = [Utilities alloc];
        
        cell.expireLabel.text =  [util linuxDateToString:end_time andFormat:@"%@-%@-%@到期" andType:DateFormat_YMD];
        
    }
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSString *tid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"];
    
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


@end

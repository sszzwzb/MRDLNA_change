//
//  ChoosePhotoAlbumViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ChoosePhotoAlbumViewController.h"
#import "ChoosePhotoAlbumTableViewCell.h"
#import "CreatePhotoCollectionViewController.h"

@interface ChoosePhotoAlbumViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoosePhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"新建"];
    [self setCustomizeTitle:@"选择相册"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reLoadPhotoAlbum"
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

-(void)selectRightAction:(id)sender{
    
    CreatePhotoCollectionViewController *cpcv = [[CreatePhotoCollectionViewController alloc] init];
    cpcv.cid = _cid;
    cpcv.fromName = @"chooseAlbum";
    if (![@"managePhoto" isEqualToString:_fromName]) {//从传照片页来
        cpcv.isSelectPhoto = 1;
    }
    [self.navigationController pushViewController:cpcv animated:YES];
    
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData:(NSString*)index{
    
    /**
     * 班级相册列表
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classAlbums sid= cid= uid= app= page= size=
     */
    
    if (!_aid) {
        
        _aid = @"0";
        
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classAlbums", @"op",
                          _cid,@"cid",
                          _aid,@"aid",
                          index,@"page",
                          @"40",@"size",
                          nil];
    
    
    //NSLog(@"data:%@",data);
    
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
                
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    [noDataView removeFromSuperview];
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
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

    static NSString *GroupedTableIdentifier = @"ChoosePhotoAlbumTableViewCell";
    ChoosePhotoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"ChoosePhotoAlbumTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSString *count = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"count"]];
    NSString *urlStr = [[listArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    cell.titleLab.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.photoNumLab.text = [NSString stringWithFormat:@"共%@张",count];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *aid = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    if ([@"managePhoto" isEqualToString:_fromName]) {
       
         [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMoveAid" object:aid userInfo:nil];
        
    }else{
        
        NSString *title = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
       
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",aid,@"aid",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePhotoAlbum" object:nil userInfo:dic];

    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
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

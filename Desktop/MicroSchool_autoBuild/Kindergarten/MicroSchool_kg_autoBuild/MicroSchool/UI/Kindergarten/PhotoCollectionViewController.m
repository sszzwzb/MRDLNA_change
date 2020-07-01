//
//  PhotoCollectionViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/5.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"

#import "PhonebookTabBarViewController.h"

static NSString *cellIdentifier = @"PhotoCollectionViewCell";

@interface PhotoCollectionViewController ()

@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    maxHeight = [[UIScreen mainScreen] bounds].size.height;
    maxWidth = [[UIScreen mainScreen] bounds].size.width;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *nib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    //self.collectionView.delegate = self;
    [self setCustomizeLeftButton];

    _collectionView.hidden = YES;
    _collectionView.alwaysBounceVertical = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reLoadPhotoCollection"
                                               object:nil];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_collectionView addSubview:_refreshHeaderView];
    
    
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

-(void)getData:(NSString*)index{
    
    /**
     * 班级相册列表
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classAlbums sid= cid= uid= app= page= size=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classAlbums", @"op",
                          _cid,@"cid",
                          index,@"page",
                          @"40",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册返回:%@",respDic);
            
            _collectionView.hidden = NO;
            NSArray *array = [[respDic objectForKey:@"message"] objectForKey:@"list"];
            
            if ([array count] > 0) {
                
                [noDataView removeFromSuperview];
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [dataArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    //老师
                    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student){
                        
                        NSDictionary *firstDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"count",@"",@"dateline",@"",@"id",@"",@"thumb",@"创建相册",@"title",nil];
                        [dataArray insertObject:firstDic atIndex:0];
                        
                    }
                    
                    
                }
                
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    [noDataView removeFromSuperview];
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    //老师
                    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student){
                        
                        NSDictionary *firstDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"count",@"",@"dateline",@"",@"id",@"",@"thumb",@"创建相册",@"title",nil];
                        [dataArray insertObject:firstDic atIndex:0];
                        
                    }else{
                        
                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                        
                        noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png"];
                        [self.view addSubview:noDataView];
                        
                    }
                    
                   
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
    
    [_collectionView reloadData];
}


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *count = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"count"]];
    cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgV.frame = CGRectMake(cell.imgV.frame.origin.x, cell.imgV.frame.origin.y, 140.0, 142.0);
    //老师
    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student){
        
        if (indexPath.row == 0) {
            
            cell.photoBg.image = [UIImage imageNamed:@"photoCollectCreate.png"];
            cell.imgV.image = nil;
            
        }else{
            
            NSString *urlStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            cell.photoBg.image = [UIImage imageNamed:@"photoCollectBg.png"];
            
        }
        
    }else{//学生
        
        NSString *urlStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        cell.photoBg.image = [UIImage imageNamed:@"photoCollectBg.png"];
        
    }
    
    cell.titleLab.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.photoNumLab.text = count;
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    //老师
    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student){
        
        if (indexPath.row == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCreatePhotoCollection" object:_cid userInfo:nil];
            
        }else{
            
            //相册id
            NSString *aid = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            NSString *title = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aid,@"aid",title,@"title", nil];
            //去相册详情
           // NSLog(@"aid:%@",aid);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoPhotoCollectionDetail" object:nil userInfo:dic];
        }
        
    }else{//学生
        
        //相册id
        NSString *pid = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
        //去相册详情
        NSLog(@"pid:%@",pid);
        
        NSString *aid = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSString *title = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aid,@"aid",title,@"title", nil];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoPhotoCollectionDetail" object:nil userInfo:dic];
        
    }

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
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[dataArray count]];
        [self getData:startNum];
        
    }
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_collectionView.bounds.size.height, self->_collectionView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_collectionView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_collectionView.bounds.size.height)];
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
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
    NSLog(@"NscrollView.contentSize:%f",scrollView.contentSize.height);
    NSLog(@"NcollectionView.contentSize:%f",_collectionView.contentSize.height);

    
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
    NSLog(@"NscrollView.contentSize1:%f",scrollView.contentSize.height);
    NSLog(@"NcollectionView.contentSize1:%f",_collectionView.contentSize.height);
    
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

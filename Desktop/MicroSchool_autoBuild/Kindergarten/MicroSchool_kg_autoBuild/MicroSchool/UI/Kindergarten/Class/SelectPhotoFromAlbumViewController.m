//
//  SelectPhotoFromAlbumViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SelectPhotoFromAlbumViewController.h"
#import "RecipeCollectionHeaderView.h"
#import "PhotoCollDetailCollectionViewCell.h"


static NSString *cellIdentifier = @"PhotoCollDetailCollectionViewCell";
static NSString *kCollectionViewHeaderIdentifier = @"HeaderView";

@interface SelectPhotoFromAlbumViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SelectPhotoFromAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"选择照片"];
    
    _collectionView.alwaysBounceVertical = YES;
    
    UINib *nib = [UINib nibWithNibName:@"PhotoCollDetailCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([RecipeCollectionHeaderView class])  bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:headerNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier: kCollectionViewHeaderIdentifier ];  //注册加载头
    
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
     * 班级相册详情
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classAlbum sid= cid= uid= aid=相册ID app= page= size=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classAlbum", @"op",
                          _cid,@"cid",
                          _aid,@"aid",
                          index,@"page",
                          @"40",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
      
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册详情返回:%@",respDic);
            _collectionView.hidden = NO;
            
            NSArray *array = [[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"list"];
            //hasNext = [[[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"hasNext"] boolValue];
            
            if ([array count] > 0) {
                
                [noDataView removeFromSuperview];
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [dataArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                }
                
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    //imagev.hidden = YES;
                    
                    [noDataView removeFromSuperview];
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    CGRect rect = CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0);
                    
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

-(void)reload{
    
    [_collectionView reloadData];
}


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [(NSArray*)[[dataArray objectAtIndex:section] objectForKey:@"list"] count];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return dataArray.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    PhotoCollDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //NSLog(@"section %d:row %d",indexPath.section,indexPath.row);
    
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    
    //NSLog(@"rowArray:%@",rowArray);
    
    NSString *urlStr = [[rowArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
  
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
       
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *title = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"dateline"];
        
        headerView.titleLabel.text = title;
        
        reusableview = headerView;
        
    }else if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = nil;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    NSString *picUrl = [NSString stringWithFormat:@"%@",[[rowArray objectAtIndex:indexPath.row] objectForKey:@"pic"]];
    
    //NSLog(@"picUrl:%@",picUrl);
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImg" object:picUrl];
    
  
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
        
        NSLog(@"dataArray:%@",dataArray);
        
        NSInteger count;
        
        for (int i=0; i<[dataArray count]; i++) {
            
            if (i == 0) {
                
                NSDictionary *dic = [dataArray objectAtIndex:0];
                count = [(NSArray*)[dic objectForKey:@"list"] count];
                
            }else{
                
                NSDictionary *dic = [dataArray objectAtIndex:i];
                count = count + [(NSArray*)[dic objectForKey:@"list"] count];
                
            }
            
        }
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)count];
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

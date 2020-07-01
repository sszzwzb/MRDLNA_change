//
//  SubscribeViewNewsListController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SubscribeViewNewsListController.h"
#import "SubscribeViewNewsListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CertificationViewController.h"
#import "SingleWebViewController.h"
#import "UIImage+UIImageScale.h"

@interface SubscribeViewNewsListController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubscribeViewNewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButton:@"icon_grzx.png"];

    
    startNum = @"0";
    
    reflashFlag = 1;
    isReflashViewType = 1;
    
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
    
    [self getData:0];
    
    [ReportObject event:ID_SUBSCRIPTION_LIST];//2015.06.25
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

// 认证详情
-(void)selectRightAction:(id)sender{
    
    CertificationViewController *certifiV =  [[CertificationViewController alloc] init];
    certifiV.titleName = _titleName;
    certifiV.number = _number;
    [self.navigationController pushViewController:certifiV animated:YES];
    
}


-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    [self loadData:index];
}

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getSubscribeArticles:index size:@"20" number:_number];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
            }else{
                
                [noNetworkV removeFromSuperview];
            }
            
            if (array == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
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
                        
                        NSString *lastStr = [Utilities replaceNull:[[listArray objectAtIndex:0] objectForKey:@"aid"]];
                        
#if 0
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastSubscribeNumDic"]];
                        [tempDic setObject:lastStr forKey:_number];
                        [userDefaults setObject:tempDic forKey:@"lastSubscribeNumDic"];
                        [userDefaults synchronize];
#endif
                        
                        
                        //------------2015.11.12----------------------------------------------------------------------
                        // 更新校园订阅号文章列表最后一条id
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                        
                        if (defaultsDic) {
                            
                            NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithArray:[defaultsDic objectForKey:@"numbers"]];
                            
                            if ([filteredArray count]>0) {
                                
                                for (int i=0; i<[filteredArray count]; i++) {
                                    
                                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[filteredArray objectAtIndex:i]];
                                    
                                    NSString *mid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mid"]];
                                    
                                    if ([mid integerValue] == [_number integerValue]) {
                                        
                                        [dic setObject:lastStr forKey:@"last"];
                                        
                                        [filteredArray replaceObjectAtIndex:i withObject:dic];
                                        
                                    }
                                    
                                }
                                
                                [defaultsDic setObject:filteredArray forKey:@"numbers"];
                                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                                [userDefaults synchronize];
                            }
                            
                        }
                        //-----------------------------------------------------------------------------------------------

                        
                        
                    }
                    
                    [noDataView removeFromSuperview];
                    
                }else{
                    
                     if ([startNum integerValue] == 0) {
                    
                       CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                       noDataView = [Utilities showNodataView:@"没有相关内容" msg2:@"" andRect:rect];
                         [self.view addSubview:noDataView];
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
    
    static NSString *CellTableIdentifier = @"SubscribeViewNewsListTableViewCell";
    SubscribeViewNewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"SubscribeViewNewsListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        //        cell = [[SubscribeNumListTableViewCell alloc]
        //                initWithStyle:UITableViewCellStyleDefault
        //                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    /*
     list =         (
     {
     aid = 2;
     dateline = 1429677323;
     number = 1;
     pic = "<null>";
     "read_num" = 1;
     title = "\U6d4b\U8bd5\U6807\U98982";
     url = "http://test.5xiaoyuan.cn/test/for/kate";
     },
     {
     aid = 1;
     dateline = 1429677323;
     number = 1;
     pic = "<null>";
     "read_num" = 1;
     title = "\U6d4b\U8bd5\U6807\U9898";
     url = "http://test.5xiaoyuan.cn/test/for/kate";
     }
     );
     
     */
    
    NSString *dateStr = [[Utilities alloc] linuxDateToString:[Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"dateline"]] andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
    NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"content"]]];
    //detailStr = @"一行数据测试";
    
    
    NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"]];
    
    if ([head_url length] >0) {
         [cell.detailImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        //cell.detailImgV.image = [self scaleImageForSelf:cell.detailImgV.image imgV:cell.detailImgV];
        cell.detailImgV.hidden = NO;
        cell.detailLabel.hidden = YES;
    }else{ 
        cell.detailImgV.hidden = YES;
        cell.detailLabel.text = detailStr;
        cell.detailLabel.hidden = NO;
        
        //cell.detailLabel.backgroundColor = [UIColor redColor];
        
        CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 0)];
        if (size.height > 38.0) {
            cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width, 38.0);
        }else{
            cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width, 21.0);
        }
    }
    
    cell.titleLabel.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"title"]]];
    
    cell.dateLineLabel.text = dateStr;
    
    NSString *viewNum = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"read_num"]]];
    
    if ([viewNum length] == 0) {
        viewNum = @"0";
    }
    
    if ([viewNum integerValue] > 10000) {
        viewNum = @"10000+";
    }
    
    //viewNum = @"2222";
    
    NSInteger length = [viewNum length];
    
    if (length == 1) {
         cell.viewNumImgV.frame = CGRectMake(cell.viewNumLabel.frame.origin.x+cell.viewNumLabel.frame.size.width-(20*length)-13, cell.viewNumImgV.frame.origin.y, 20.0, 20.0);
    }else{
        if (length == 2) {
            cell.viewNumImgV.frame = CGRectMake(cell.viewNumLabel.frame.origin.x+cell.viewNumLabel.frame.size.width-(15*length)-10, cell.viewNumImgV.frame.origin.y, 20.0, 20.0);
        }else if(length == 3){
            cell.viewNumImgV.frame = CGRectMake(cell.viewNumLabel.frame.origin.x+cell.viewNumLabel.frame.size.width-(12*length)-10, cell.viewNumImgV.frame.origin.y, 20.0, 20.0);
        }else if(length == 6){
             cell.viewNumImgV.frame = CGRectMake(cell.viewNumLabel.frame.origin.x+cell.viewNumLabel.frame.size.width-(10*length)-10, cell.viewNumImgV.frame.origin.y, 20.0, 20.0);
        }else{
            cell.viewNumImgV.frame = CGRectMake(cell.viewNumLabel.frame.origin.x+cell.viewNumLabel.frame.size.width-(11*length)-10, cell.viewNumImgV.frame.origin.y, 20.0, 20.0);
        }
        
    }
    
    cell.viewNumLabel.text = viewNum;
    
    return cell;
                                       
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"]];
    NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"content"]]];
    //detailStr = @"一行数据测试";
    
    CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 0)];
    
    if ([head_url length] == 0) {
        
        if (size.height > 38.0) {
           return 79.0+38.0;
        }else{
            return 79.0+21.0;
        }
        
    }else{
       return 200.0;//图片高度是200 文字高度是160
    }
    
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *aid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"aid"]]];
#if 0
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.fromName = @"subsribe";
    fileViewer.titleName = _subscribNumName;
    fileViewer.aid = aid;
#endif
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWSubsribe;
    fileViewer.titleName = _subscribNumName;
    fileViewer.aid = aid;
    
    [self.navigationController pushViewController:fileViewer animated:YES];
    
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
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[listArray count]];
        NSLog(@"startNum:%@",startNum);
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

- (UIImage*)scaleImageForSelf:(UIImage *)newImage imgV:(UIImageView*)imgV

{
    UIImage *resizeImage;
    
//    CGSize size;
//    
//    size.width = imgV.frame.size.width ;
//    
//    size.height = (imgV.frame.size.width * image.size.height) /image.size.width ;
//    
//    UIImage *newImage = [image scaleToSize:size];
    
    
    CGFloat srcRatio = newImage.size.height/newImage.size.width;
    
    CGFloat desRatio = imgV.frame.size.height/imgV.frame.size.width;
    
    
    CGRect rect;
    
    if(srcRatio > desRatio){ //截上下，宽一致
        
        CGFloat ratio = newImage.size.width/imgV.frame.size.width;//缩放比
        
        rect.size.height = imgV.frame.size.height * ratio ;
        
        rect.size.width = newImage.size.width;
        
        rect.origin.x = 0;
        
        rect.origin.y = (newImage.size.height - imgV.frame.size.height)/2.0;
        
        resizeImage = [newImage getSubImage:rect];
        
    }else if (srcRatio < desRatio)
        
        //截左右，高一致
    {
        
        CGFloat ratio = newImage.size.height/imgV.frame.size.height;
        
        rect.size.width = imgV.frame.size.width * ratio;
        
        rect.size.height = newImage.size.height ;
        
        rect.origin.x =newImage.size.width - imgV.frame.size.width/2.0;
        
        rect.origin.y =  0;
        
        
        
        resizeImage = [newImage getSubImage:rect];
        
    }else
        
    {
        
        resizeImage = newImage;//得到的图片的长宽比与iamgeView的长宽比一致，不用裁剪
        
    }
    
    return resizeImage;
    
}

@end
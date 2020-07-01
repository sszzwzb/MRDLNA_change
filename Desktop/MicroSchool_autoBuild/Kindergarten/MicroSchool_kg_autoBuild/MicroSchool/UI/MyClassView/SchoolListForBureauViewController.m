//
//  SchoolListForBureauViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/21.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SchoolListForBureauViewController.h"
#import "SchoolTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FRNetPoolUtils.h"
#import "SchoolModuleListViewController.h"
#import "MyTabBarController.h"

@interface SchoolListForBureauViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SchoolListForBureauViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];//2015.10.29
    [self setCustomizeTitle:_titleName];//2015.10.29
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    //----add by kate--------------------------------------------------------------------------
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    reflashFlag = 1;
    //-------------------------------------------------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnectedForSchoolListForBureau"
                                               object:nil];//2015.06.25
    
    [Utilities showProcessingHud:self.view];
    [self getData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//2015.10.29 教育局改版
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //[MyTabBarController setTabBarHidden:NO];//2015.10.29
    
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *result = [FRNetPoolUtils getSchoolListForBureau];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];
            
            if (result) {
                
                if ([[result objectForKey:@"result"] integerValue] == 1) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"momentEnter"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    _tableView.hidden = NO;
                    
                    listArray =[[NSMutableArray alloc] initWithArray:[[result objectForKey:@"message"] objectForKey:@"schools"] copyItems:YES];
                    
                    /*2015.10.29
                    NSString *titleName = [NSString stringWithFormat:@"%@",[[result objectForKey:@"message"] objectForKey:@"module"]];
                    if ([titleName length] == 0) {
                         ((UILabel *)self.navigationItem.titleView).text = @"下属单位";
                    }else{
                         ((UILabel *)self.navigationItem.titleView).text = [Utilities replaceNull:titleName];
                    }*/

                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }
                
                
            }else{
                
                //[self setCustomizeTitle:@"下属单位"];//2015.10.29
               
                if (_reloading) {
                    
                }else{
                    
                    //---update 2015.06.25-------------------------------------------------------------
                    //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    [self isConnected];
                    //----------------------------------------------------------------------------------
                
                }
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                
            }
            
        });
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return [listArray count];// 2015.05.13
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
     return [(NSArray*)[[listArray objectAtIndex:section] objectForKey:@"list"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[listArray objectAtIndex:section] objectForKey:@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;
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
    
     NSArray *array = [[listArray objectAtIndex:indexPath.section] objectForKey:@"list"];
     NSDictionary *dic = [array objectAtIndex:indexPath.row];
     NSString* head_url = [dic objectForKey:@"logo"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
    cell.titleLabel.text = [Utilities replaceNull:[dic objectForKey:@"name"]];
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
    if ([@"headLineNews"  isEqual: _viewType]) {
        NSArray *array = [[listArray objectAtIndex:indexPath.section] objectForKey:@"list"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];

        NSDictionary *dicN = [NSDictionary dictionaryWithObjectsAndKeys:
                             [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sid"]]], @"sid",
                             [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]], @"name",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHeadLineNews" object:self userInfo:dicN];

        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSArray *array = [[listArray objectAtIndex:indexPath.section] objectForKey:@"list"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        
        SchoolModuleListViewController *smlV = [[SchoolModuleListViewController alloc]init];
        smlV.otherSid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sid"]]];
        smlV.otherSchoolName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        smlV.special = @"1";
        [self.navigationController pushViewController:smlV animated:YES];
    }
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        [self getData];
        
    }
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
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
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    
}

//----add by  kate 2015.06.26---------------
-(void)isConnected{
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        if (!networkVC) {
            
            networkVC = [[networkBar alloc] init];
            
            _tableView.tableHeaderView = networkVC.view;
            
            _tableView.hidden = NO;
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
            singleTouch.delegate = self;
            [_tableView.tableHeaderView addGestureRecognizer:singleTouch];
            
        }
        
    }else{
        
        networkVC = nil;
        _tableView.tableHeaderView = nil;
    }
    
}
//去网络设置引导页
-(void)gotoNetworkGuide{
    
    NetworkGuideViewController *networkGVC = [[NetworkGuideViewController alloc]init];
    [self.navigationController pushViewController:networkGVC animated:YES];
}


@end



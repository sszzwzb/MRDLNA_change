//
//  KnowlegeHomePageViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowlegeHomePageViewController.h"
#import "KnowlegeHomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KnowledgeDetailViewController.h"
#import "AuthorZoneViewController.h"
#import "TypeListViewController.h"
#import "MyTabBarController.h"
#import "teacherListViewController.h"
#import "KnowledgePayItemViewController.h"

@interface KnowlegeHomePageViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *searchResultTableV;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation KnowlegeHomePageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"知识库"];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _searchResultTableV.tableFooterView = [[UIView alloc] init];
  
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
     [_searchResultTableV addSubview:_refreshHeaderView];
    
    noticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-22-6, 3, 10, 10)];//update by kate 2014.12.30
    noticeImgV.image = [UIImage imageNamed:@"icon_new"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshKnowledgeHome"
                                               object:nil];
    
    noDataView = [[UILabel alloc]initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 44 - 22)/2.0, [UIScreen mainScreen].bounds.size.width, 22.0)];
    noDataView.text = @"无匹配的结果";
    noDataView.textAlignment = NSTextAlignmentCenter;
    noDataView.textColor = [UIColor grayColor];
    noDataView.font = [UIFont systemFontOfSize:20.0];

    
    [self getData];
    
    [ReportObject event:ID_OPEN_MY_SCHOOL_WIKI_LIST];//2015.06.24
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    searchStartNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    if (_tableView.hidden == YES) {
        
    }else{
        _searchResultTableV.hidden = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"subscribedWikiCount"]!=nil) {
        
        [noticeImgV removeFromSuperview];
        [self.navigationController.navigationBar addSubview:noticeImgV];
    }else{
        [noticeImgV removeFromSuperview];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [noticeImgV removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    // 去知识库分类列表
    TypeListViewController *typeLV = [[TypeListViewController alloc]init];
    typeLV.subscribedWikiCount = subscribedWikiCount;
    typeLV.subscriberCount = subscriberCount;
    [self.navigationController pushViewController:typeLV animated:YES];

    
}

-(void)getData{
    
    //getKnowlegeHomePageList
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSString *last = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastKid"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *tempDiction = [FRNetPoolUtils getKnowlegeHomePageList:last];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                
                noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
                [self.view addSubview:noNetworkV];
                
            }else{
                
                [noNetworkV removeFromSuperview];
            }
            
            if (tempDiction == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                [self setCustomizeRightButton:@"icon_grzx.png"];
                
                subscribedWikiCount = [NSString stringWithFormat:@"%@",[tempDiction objectForKey:@"subscribedWikiCount"]];
                subscriberCount = [NSString stringWithFormat:@"%@",[tempDiction objectForKey:@"subscriberCount"]];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if([subscribedWikiCount intValue] > 0){
                  
                    [noticeImgV removeFromSuperview];
                    [self.navigationController.navigationBar addSubview:noticeImgV];
                    [defaults setObject:subscribedWikiCount forKey:@"subscribedWikiCount"];
                    [defaults synchronize];
                    
                }else{
                    
                    [defaults setObject:nil forKey:@"subscribedWikiCount"];
                    [defaults synchronize];
                    
                }

                _tableView.hidden = NO;
                
                if([tempDiction count] >0){
                    
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    diction = [[NSDictionary alloc] initWithDictionary:tempDiction];
                    NSArray *tempTagArray = [[diction objectForKey:@"tags"] objectForKey:@"list"];
                    if(tempTagArray!=nil){
                    
                        tagArray = [[NSMutableArray alloc]initWithArray:tempTagArray];
                    }
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
            }
        });
        
    });
    
}

-(void)getSearchResult:(NSString*)index{
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];
    [self loadResult:index];

}

-(void)loadResult:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dictionary = [FRNetPoolUtils getItems:_searchBar.text category:@"" course:@"" grade:@"" page:index size:@"20"];
        
        NSMutableArray *array = [dictionary objectForKey:@"list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            if (dictionary == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _searchResultTableV.hidden = NO;
                
                if ([array count] >0) {
                    
                    [noDataView removeFromSuperview];
                    
                    if ([searchStartNum intValue] > 0) {
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            [searchListArray addObject:[array objectAtIndex:i]];
                            
                        }
                        
                    }else{
                        
                        searchListArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                    }
                    
                }else{
                    
                   searchListArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    [self.view addSubview:noDataView];
                }
                
               
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
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
        //startNum = @"0";
        searchStartNum = @"0";
        if([_searchBar.text length] == 0){
            //[self getData:startNum];
        }else{
            [self loadResult:searchStartNum];
        }
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        if([_searchBar.text length] == 0){
            //startNum = [NSString stringWithFormat:@"%d",[listArray count]];
            
        }else{
            searchStartNum = [NSString stringWithFormat:@"%d",[searchListArray count]];
            [self loadResult:searchStartNum];
        }
        
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}

-(void)reload{
    
    if([_searchBar.text length] == 0){

        [_tableView reloadData];
    }else{
        [_searchResultTableV reloadData];
    }
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 1;

    if (tableView == _searchResultTableV) {
        
        count = [searchListArray count];
        
    }else{
        if(section == 0){
            count = [(NSArray *)[[diction objectForKey:@"teachers"] objectForKey:@"list"] count];
        }else if (section == 1){
            count = [(NSArray *)[[diction objectForKey:@"items"] objectForKey:@"list"] count];
        }
    }

    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _searchResultTableV) {
        
        return 1;
        
    }else{
       return 2;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _searchResultTableV) {
        return [[UIView alloc] init];
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35.0)];
        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35.0);
        btn.tag = section;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[btn setBackgroundColor:[UIColor colorWithRed:0.0 green:169.0/255.0 blue:250.0/255.0 alpha:1]];
        if(section == 0){
            //[btn setTitle:@"名师推荐                                     查看更多》" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"mstj_d.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"mstj_p.png"] forState:UIControlStateHighlighted];
        }else if (section == 1){
            //[btn setTitle:@"热门课程                                     查看更多》" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"rmkc_d.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"rmkc_p.png"] forState:UIControlStateHighlighted];
        }
        [btn addTarget:self action:@selector(viewMore:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
         return view;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _searchResultTableV) {
        return 0.0;
    }else{
        return 35.0;
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (tableView == _searchResultTableV) {
    
        NSString* head_url = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        cell.titleLabel.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
        cell.detailLabel.text = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        //cell.dateLineLabel.text =  [[Utilities alloc] linuxDateToString:[Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"dateline"]] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        
        cell.headImgV.layer.masksToBounds = YES;
        cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
        
        NSString *payment = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"payment"]];
        NSString *isFree = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"free"]];
        [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
        cell.isFreeBtn.layer.masksToBounds = YES;
        cell.isFreeBtn.layer.cornerRadius = 2.0;
        if([isFree intValue] == 1){//免费
//            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
//             [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateHighlighted];
        }else{//付费
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateHighlighted];
            
        }

    }else{
        if(indexPath.section == 0){
            
            NSString* head_url = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
            [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
            
          
//            cell.detailLabel.text = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"school"]];
            
            NSString *specialStr = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"special"]];
            if ([specialStr length]>0) {
                
                  cell.teacherName.text = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
                  cell.specialLabel.text =[NSString stringWithFormat:@"擅长科目:%@",specialStr];
                 cell.teacherNameNoSpecial.text = @"";
            }else{
                cell.teacherNameNoSpecial.text = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
                cell.teacherName.text = @"";
                cell.specialLabel.text = @"";
            }
          
            cell.headImgV.layer.masksToBounds = YES;
            cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
            
            cell.titleLabel.text = @"";
            cell.detailLabel.text = @"";
            cell.dateLineLabel.text=@"";
            
        }else if (indexPath.section == 1){
            
            NSString* head_url = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
            [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
            
            cell.specialLabel.text = @"";
            cell.teacherName.text = @"";
            cell.teacherNameNoSpecial.text = @"";
            
            cell.titleLabel.text = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
            cell.detailLabel.text = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
            
            cell.dateLineLabel.text =  [[Utilities alloc] linuxDateToString:[Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"dateline"]] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            cell.headImgV.layer.masksToBounds = YES;
            cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
            
            NSString *payment = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"payment"]];
            NSString *isFree = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"free"]];
          
            cell.isFreeBtn.layer.masksToBounds = YES;
            cell.isFreeBtn.layer.cornerRadius = 2.0;
            if([isFree intValue] == 1){//免费
//                [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:169.0/255.0 blue:250.0/255.0 alpha:1]];
//                [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
//                [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateHighlighted];
                
                
            }else{//付费
              
//                [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1]];
                [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
                [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
                [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateHighlighted];
            }
            
        }
        
    }
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
   
    if(tableView == _searchResultTableV){
        
//            NSString *isFree = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"free"]];
//            NSString *subscribed = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"subscribed"]];
        
        NSString *isFree = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"free"]];
        NSString *subscribed = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"subscribed"]];
        
            if([isFree intValue] == 0){//收费
                
                if([subscribed intValue] == 1){
                    //去详情页
                    KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
                    knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"kid"]];
                    knowledgeDetailViewCtrl.subuid =subscribed;
                    [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
                }else{
                    //去订阅页
                    KnowledgePayItemViewController *kpivc = [[KnowledgePayItemViewController alloc]init];
                    kpivc.tid = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"uid"]];
                    [self.navigationController pushViewController:kpivc animated:YES];
                }
                
                
            }else{//免费
                // 去详情页
                KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
                knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[searchListArray objectAtIndex:indexPath.row] objectForKey:@"kid"]];
                knowledgeDetailViewCtrl.subuid =subscribed;
                [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
                
            }
        
        
    }else{
        if(indexPath.section == 0){//去作者空间
            
            AuthorZoneViewController *azv = [[AuthorZoneViewController alloc]init];
            azv.tid = [Utilities replaceNull:[[[[diction objectForKey:@"teachers"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"uid"]];
            [self.navigationController pushViewController:azv animated:YES];
            
        }else if (indexPath.section == 1){
            
            NSString *isFree = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"free"]];
            NSString *subscribed = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"subscribed"]];
            
            if([isFree intValue] == 0){//收费
                
                if([subscribed intValue] == 1){
                    //去详情页
                    KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
                    knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"kid"]];
                    knowledgeDetailViewCtrl.subuid =subscribed;
                    [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
                }else{
                    //去订阅页
                    KnowledgePayItemViewController *kpivc = [[KnowledgePayItemViewController alloc]init];
                    kpivc.tid = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"uid"]];
                    [self.navigationController pushViewController:kpivc animated:YES];
                }
                
                
            }else{//免费
                // 去详情页
                KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
                knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[[[diction objectForKey:@"items"] objectForKey:@"list"] objectAtIndex:indexPath.row] objectForKey:@"kid"]];
                knowledgeDetailViewCtrl.subuid =subscribed;
                [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
                
            }
            
            
        }
        
    }
    
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_searchResultTableV];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_searchResultTableV];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
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
    if ([_searchBar.text length] == 0) {
        
    }else{
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
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_searchBar.text length] == 0) {
        
    }else{
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
    _searchResultTableV.hidden = YES;
    [self removeTagButton];
    [self addTagBtn];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
   
    [ReportObject event:ID_SEARCH_WIKI];//2015.06.24
    
    [self removeTagButton];
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = YES;
    [self getSearchResult:@"0"];
    
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
    [self removeTagButton];
    [noDataView removeFromSuperview];
    searchBar.text = @"";
    _tableView.hidden = NO;
    _searchResultTableV.hidden = YES;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)viewMore:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if(btn.tag){//热门课程
        // 2015.02.09 add by ht
#if 0
        KnowledgeHotWikiViewController *hot = [[KnowledgeHotWikiViewController alloc]init];
        KnowledgeHotWikiFilterViewController *hotFilter = [[KnowledgeHotWikiFilterViewController alloc]init];
        
        UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:hot];
        [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
        
        if([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
            UINavigationController * rightSideNavController = [[MMNavigationController alloc] initWithRootViewController:hotFilter];
            [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
            self.drawerController = [[MMDrawerController alloc]
                                     initWithCenterViewController:navigationController
                                     leftDrawerViewController:nil
                                     rightDrawerViewController:rightSideNavController];
//            [self.drawerController setShowsShadow:NO];
        }
        else{
            self.drawerController = [[MMDrawerController alloc]
                                     initWithCenterViewController:hot
                                     leftDrawerViewController:nil
                                     rightDrawerViewController:hotFilter];
        }
        
        [self.drawerController setRestorationIdentifier:@"MMDrawer"];
        [self.drawerController setMaximumRightDrawerWidth:220.0];
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

        
        
        

//        MMDrawerController * drawerController = [[MMDrawerController alloc]
//                                                 initWithCenterViewController:hot
//                                                 leftDrawerViewController:nil
//                                                 rightDrawerViewController:hotFilter];
        
        [self.navigationController pushViewController:self.drawerController animated:YES];
        
        
//        [self.drawerController
//         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//             MMDrawerControllerDrawerVisualStateBlock block;
//             block = [[MMExampleDrawerVisualStateManager sharedManager]
//                      drawerVisualStateBlockForDrawerSide:drawerSide];
//             if(block){
//                 block(drawerController, drawerSide, percentVisible);
//             }
//         }];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        if(OSVersionIsAtLeastiOS7()){
//            UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
//                                                  green:173.0/255.0
//                                                   blue:234.0/255.0
//                                                  alpha:1.0];
//            [self.window setTintColor:tintColor];
//        }
//        [self.view setRootViewController:self.drawerController];

#endif 
        KnowledgeHotWikiViewController *tlv = [[KnowledgeHotWikiViewController alloc]init];
        [self.navigationController pushViewController:tlv animated:YES];

        
    }else{//名师推荐
        
        teacherListViewController *tlv = [[teacherListViewController alloc]init];
        [self.navigationController pushViewController:tlv animated:YES];
       
    }
    
}

-(void)addTagBtn{
    
    int x = 0;//横
    int j = 0;//竖
    
    float lastY = 0;
    
//    tagArray = [[NSMutableArray alloc] initWithObjects:@"热门标签",@"滑雪",@"物理",@"昨日作业",@"生物",@"语文",@"热门标签",@"生物",@"语文",@"生物",@"语文", nil];
    
    for (int i=0; i<[tagArray count]; i++) {
  
        NSString *name = [Utilities replaceNull:[tagArray objectAtIndex:i]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70.0, 30.0);
        button.tag = 410+i;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:92/255.0 blue:67.0/255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"keyword_Bg.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"keyword_Bg.png"] forState:UIControlStateNormal];
        [button setTitle:name forState:UIControlStateNormal];
        
        if ((i!=0) && (i%3 == 0)) {
        
            j++;
            x = 0;
        }
        
        lastY = j*30.0 + 30.0;
        
        UIView *moudelView = [[UIView alloc]init];
        moudelView.frame = CGRectMake(x*70.0+20.0*(x+1), 30.0*j+54+10*(j+1), 70.0, 30.0);
        moudelView.tag = 110+i;
        [moudelView addSubview:button];
        x++;
        [self.view addSubview:moudelView];
        
    }
    
}

-(void)removeTagButton{
    
    for(int i=0;i<[tagArray count];i++){
        
        UIView *view = [self.view viewWithTag:(110+i)];
        [view removeFromSuperview];
        
    }
}

-(void)tagSelect:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSString *tagName = btn.titleLabel.text;
    _searchBar.text = tagName;
    
}


@end

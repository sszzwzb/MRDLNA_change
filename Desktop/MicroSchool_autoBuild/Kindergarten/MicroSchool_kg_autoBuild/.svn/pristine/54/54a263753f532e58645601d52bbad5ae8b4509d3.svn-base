//
//  AuthorZoneViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "AuthorZoneViewController.h"
#import "KnowlegeHomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FriendProfileViewController.h"
#import "KnowledgeDetailViewController.h"
#import "KnowledgePayItemViewController.h"
#import "AuthorZoneTableViewCell.h"

@interface AuthorZoneViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *authorHeadImgV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolLabel;
@property (strong, nonatomic) IBOutlet UILabel *majorLabel;
@property (strong, nonatomic) IBOutlet UIButton *subscribeBtn;
- (IBAction)subscribeAction:(id)sender;
- (IBAction)gotoProfileAction:(id)sender;

@end

@implementation AuthorZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"作者空间"];
    
    
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

-(void)reload{
    
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    [Utilities showProcessingHud:self.view];//2015.05.12
    [self loadData:index];
}

-(void)loadData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        diction = [FRNetPoolUtils getTeacherDetail:_tid page:index size:@"10"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            if (diction == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSMutableArray *array = (NSMutableArray*)[[diction objectForKey:@"items"] objectForKey:@"list"];
                NSString *count = [Utilities replaceNull:[[diction objectForKey:@"items"] objectForKey:@"count"]];
                if ([count length] == 0) {
                    count = @"0";
                }
                knowledgeCount = [NSString stringWithFormat:@"%@条知识点",count];
               
                
                NSString *tuid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[diction objectForKey:@"profile"] objectForKey:@"uid"]]];//this user id
                if ([tuid isEqualToString:[Utilities getUniqueUid]]) {//自己不可订阅自己 2015.03.30
                    _subscribeBtn.hidden = YES;
                }else{
                    
                    //free
                     NSString *free = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[diction objectForKey:@"profile"] objectForKey:@"free"]]];
                    if ([free intValue] == 1) {
                        _subscribeBtn.hidden = YES;
                    }else{
                        _subscribeBtn.hidden = NO;
                        [_subscribeBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
                        [_subscribeBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
                        NSString *subscribed = [[diction objectForKey:@"profile"] objectForKey:@"subscribed"];
                        if ([subscribed intValue] == 0) {
                            [_subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
                            _subscribeBtn.userInteractionEnabled = YES;
                        }else{
                            [_subscribeBtn setTitle:@"已订阅" forState:UIControlStateNormal];
                            [_subscribeBtn setTitleColor:[UIColor colorWithRed:147.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1] forState:UIControlStateNormal];
                            _subscribeBtn.userInteractionEnabled = NO;
                            [_subscribeBtn setBackgroundImage:[UIImage imageNamed:@"btn_unEnable_d.png"] forState:UIControlStateNormal] ;//灰显
                            [_subscribeBtn setBackgroundImage:[UIImage imageNamed:@"btn_unEnable_d.png"] forState:UIControlStateHighlighted] ;
                        }
                    }
                    
                    
                }
                
              
                _tableView.hidden = NO;
                
                if ([(NSDictionary*)[diction objectForKey:@"profile"] count] == 0 && [array count] == 0) {
                    
                     [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    
                }else{
                    
                    
                   // _schoolLabel.text = [Utilities replaceNull:[[diction objectForKey:@"profile"] objectForKey:@"school"]];
                    NSString *majorStr = [Utilities replaceNull:[[diction objectForKey:@"profile"] objectForKey:@"special"]];
                    
                    if([majorStr length] > 0 ){
                        
                        _nameLabel.text =  [Utilities replaceNull:[[diction objectForKey:@"profile"] objectForKey:@"name"]];
                        _majorLabel.text = [NSString stringWithFormat:@"擅长科目:%@",majorStr];
                        
                    }else{
                        
                        _nameLabel.text =  @"";
                        _schoolLabel.text = [Utilities replaceNull:[[diction objectForKey:@"profile"] objectForKey:@"name"]];
                        _majorLabel.text = @"";
                    }
                    
                    
                    NSString* head_url = [Utilities replaceNull:[[diction objectForKey:@"profile"] objectForKey:@"avatar"]];
                    [_authorHeadImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
                    _authorHeadImgV.layer.masksToBounds = YES;
                    _authorHeadImgV.layer.cornerRadius = _authorHeadImgV.frame.size.height/2.0;
                    
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
                    _tableView.tableHeaderView = _headerView;
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
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
    
    static NSString *CellTableIdentifier = @"AuthorZoneTableViewCell";
    
    AuthorZoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"AuthorZoneTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    // Configure the cell...
    
        //NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
        //[cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        cell.titleLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
        cell.detailLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        cell.dateLineLabel.text =  [[Utilities alloc] linuxDateToString:[Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"dateline"]] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        //cell.headImgV.layer.masksToBounds = YES;
        //cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
    NSString *payment = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"payment"]];
    NSString *isFree = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"free"]];
       cell.isFreeBtn.layer.masksToBounds = YES;
    cell.isFreeBtn.layer.cornerRadius = 2.0;
    if([isFree intValue] == 1){//免费
        //[cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:169.0/255.0 blue:250.0/255.0 alpha:1]];
//        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
//        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateHighlighted];
    }else{//付费
        //[cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1]];
        [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateHighlighted];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 22.0)];
        view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        UILabel *btn = [[UILabel alloc] init];
        btn.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-15.0, 22.0);
        btn.tag = section;
        btn.font = [UIFont systemFontOfSize:15.0];
        btn.text = knowledgeCount;
        [view addSubview:btn];
        return view;

}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
        NSString *isFree =  [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"free"]];
        NSString *subscribed = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"subscribed"]];
    
        if([isFree intValue] == 0){//收费
            
            if([subscribed intValue] == 1){
                //去详情页
                KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
                knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"kid"]];
                knowledgeDetailViewCtrl.subuid =subscribed;
                [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
            }else{
                //去订阅页
                KnowledgePayItemViewController *kpivc = [[KnowledgePayItemViewController alloc]init];
                kpivc.tid = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"]];
                [self.navigationController pushViewController:kpivc animated:YES];
            }
            
            
        }else{//免费
            // 去详情页
            KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
            knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"kid"]];
            knowledgeDetailViewCtrl.subuid =subscribed;
            [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
            
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

// 订阅
- (IBAction)subscribeAction:(id)sender {
    // 20150213 add by ht
    KnowledgePayItemViewController *knowledgePayItem = [[KnowledgePayItemViewController alloc] init];
    knowledgePayItem.tid = _tid;
    [self.navigationController pushViewController:knowledgePayItem animated:YES];
    
    
}

// 作者详细资料页
- (IBAction)gotoProfileAction:(id)sender {
    
    NSString *fuid = [[diction objectForKey:@"profile"] objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
    
}
@end

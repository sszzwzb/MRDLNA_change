//
//  KnowledgeHotWikiViewController.m
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeHotWikiViewController.h"

@interface KnowledgeHotWikiViewController ()

@end

@implementation KnowledgeHotWikiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"知识点"];
    [super setCustomizeLeftButton];
    
    dataDic = [[NSMutableDictionary alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    
    startNum = @"0";
    endNum = @"10";
    
    reflashFlag = 1;
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    chooseArray = [[NSMutableArray alloc] init];
    
    _filter_categorise = @"0";
    _filter_courses = @"0";
    _filter_grades = @"0";

//    [self setupLeftMenuButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setupLeftMenuButton
//{
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
    //    [self createHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44) style:UITableViewStylePlain];// update frame by kate
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"section:%ld ,index:%ld",(long)section,(long)index);
    NSLog(@"name:%@ ,id:%@",[[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"name"],[[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"id"]);

    if (0 == section) {
        _filter_categorise = [[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"id"];
    }else if (1 == section) {
        _filter_courses = [[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"id"];
    }else if (2 == section) {
        _filter_grades = [[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"id"];
    }
    
    [Utilities showProcessingHud:self.view];// 2015.05.12

    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];

}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
//    return chooseArray[section][index];
    return [[[chooseArray objectAtIndex:section] objectAtIndex:index] objectForKey:@"name"];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    // 因为在viewwillappare里面调用了 所以这里不调用
    // 发出两次请求会有问题
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Wiki",@"ac",
                          @"2",@"v",
                          @"wikiItems", @"op",
                          startNum, @"page",
                          endNum, @"size",
                          _filter_categorise, @"category",
                          _filter_courses, @"course",
                          _filter_grades, @"grade",
                          nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiItems andData:data];
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
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Wiki",@"ac",
                              @"2",@"v",
                              @"wikiItems", @"op",
                              startNum, @"page",
                              endNum, @"size",
                              _filter_categorise, @"category",
                              _filter_courses, @"course",
                              _filter_grades, @"grade",
                              nil];
        
        [network sendHttpReq:HttpReq_KnowledgeWikiItems andData:data];
    }
}
//加载调用的方法
-(void)getNextPageView
{
    if (reflashFlag == 1) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Wiki",@"ac",
                              @"2",@"v",
                              @"wikiItems", @"op",
                              startNum, @"page",
                              endNum, @"size",
                              _filter_categorise, @"category",
                              _filter_courses, @"course",
                              _filter_grades, @"grade",
                              nil];
        
        [network sendHttpReq:HttpReq_KnowledgeWikiItems andData:data];
    }
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

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSUInteger row = [indexPath row];
    NSDictionary *dic = [dataArr objectAtIndex:row];

    NSString* head_url = [dic objectForKey:@"avatar"];
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    cell.detailLabel.text = [dic objectForKey:@"name"];
    cell.dateLineLabel.text =  [[Utilities alloc] linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    cell.headImgV.layer.masksToBounds = YES;
    cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;

    NSString *payment = [Utilities replaceNull:[dic objectForKey:@"payment"]];
//    [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
    cell.isFreeBtn.layer.masksToBounds = YES;
    cell.isFreeBtn.layer.cornerRadius = 2.0;

    if([[dic objectForKey:@"free"] intValue] == 1){
        //免费
//        [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:169.0/255.0 blue:250.0/255.0 alpha:1]];
//        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
//        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateHighlighted];
    }else{
        //付费
//        [cell.isFreeBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1]];
        [cell.isFreeBtn setTitle:payment forState:UIControlStateNormal];
        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
        [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateHighlighted];
    }

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"free"]  intValue] == 0){
        // 收费
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"subscribed"] intValue] == 1){
            // 去详情页
            KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
            knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"kid"]];
            knowledgeDetailViewCtrl.subuid = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"subscribed"];
            [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
        }else{
            // 去订阅页
            KnowledgePayItemViewController *kpivc = [[KnowledgePayItemViewController alloc]init];
            kpivc.tid = [Utilities replaceNull:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"uid"]];
            [self.navigationController pushViewController:kpivc animated:YES];
        }
    }else{
        // 免费
        KnowledgeDetailViewController *knowledgeDetailViewCtrl = [[KnowledgeDetailViewController alloc] init];
        knowledgeDetailViewCtrl.tid = [Utilities replaceNull:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"kid"]];
        knowledgeDetailViewCtrl.subuid =[[dataArr objectAtIndex:indexPath.row] objectForKey:@"subscribed"];
        [self.navigationController pushViewController:knowledgeDetailViewCtrl animated:YES];
    }

    
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];

}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"WikiAction.wikiItems"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        
        [Utilities dismissProcessingHud:self.view];
        if(true == [result intValue]) {
            
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[KnowledgeHotWikiModel class]
                               fromJSONDictionary:resultJSON
                                            error:&error];

            [chooseArray addObject:_model.categories];
            [chooseArray addObject:_model.courses];
            [chooseArray addObject:_model.grades];
            
            if (nil == dropDownView) {
                dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44) dataSource:self delegate:self];
                dropDownView.mSuperView = self.view;
                
                [self.view addSubview:dropDownView];
            }

            if ([@"0"  isEqual: startNum]) {
                [dataArr removeAllObjects];
            }

            for (NSObject *object in _model.list)
            {
                [dataArr addObject:object];
            }

//            [dataArr addObject:<#(id)#>];
            
//            dataArr = (NSMutableArray*)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)_model.list, kCFPropertyListMutableContainers));
//            NSLog(@"newArray:%@", dataArr);
//            
//            [dataArr removeObjectAtIndex:3];
            
            
//            
//            if ([@"0"  isEqual: startNum]) {
//                [dataArr removeAllObjects];
//            }
//            
//            NSDictionary *dic = [resultJSON objectForKey:@"message"];
//            NSArray *arr = [dic objectForKey:@"list"];
//            
//            for (NSObject *object in arr)
//            {
//                [dataArr addObject:object];
//            }
//            
//            dataDic = [resultJSON objectForKey:@"message"];
            
            startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            [_tableView reloadData];
            
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取历史广播错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }else if ([@"OtherSchoolAction.favorites"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end

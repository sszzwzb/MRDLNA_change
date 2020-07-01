//
//  NewsViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NewsViewController2.h"
#import "HomeworkSubmitViewController.h"
#import "SubmitViewController.h"

@interface NewsViewController2 ()

@end

@implementation NewsViewController2

//@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"03" ofType:@"png"];
        
        UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:filePath];
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"tab3" image:myImage tag:1];
        
        self.tabBarItem = item;
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
        
        newsArray =[[NSMutableArray alloc] init];
        newsDBArray =[[NSMutableArray alloc] init];
        
        newsidList =[[NSMutableArray alloc] init];
        newsDateList =[[NSMutableArray alloc] init];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"10";
        
        reflashFlag = 1;
        isReflashViewType = 1;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    noDataView = [Utilities showNodataView:@"一条信息也没有" msg2:@"管理员不勤快" andRect:rect];
    noDataView.hidden = YES;
    //[self.view addSubview:noDataView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    
#if BUREAU_OF_EDUCATION
    if ([@"headLineNews"  isEqual: _newsType]) {
        
        [super setCustomizeRightButtonWithName:@"学校"];
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(reloadHeadLineNews)
        //                                                     name:@"reloadHeadLineNews"
        //                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadLineNews:) name:@"reloadHeadLineNews" object:nil];
        
    }else if ([@"eduinspectorNews" isEqualToString:_fromName]){
        
        //2016.06.08 tony确认 教育局版本非学生家长都可以发督学通知
        if ([role_id integerValue]!= 0 && [role_id integerValue]!= 6) {
            [self setCustomizeRightButton:@"icon_edit_forums.png"];
        }
    }else{
        if ([role_id integerValue] == 9) {//新增校园管理员发布公告入口 2015.08.25 by kate
            [self setCustomizeRightButton:@"icon_edit_forums.png"];
        }//修改校园条右上角图标显示不对问题
    }
    
#else
    
    if ([role_id integerValue] == 9) {//新增校园管理员发布公告入口 2015.08.25 by kate
        [self setCustomizeRightButton:@"icon_edit_forums.png"];
    }//修改校园条右上角图标显示不对问题
    
    
    
#endif
    
    [self createHeaderView];
    
    [self doGetNews];
    
    //    if (0 != [newsDBArray count]) {
    //
    //    }else {
    //        [self createHeaderView];
    //    }
    
    [ReportObject event:ID_OPEN_NEWS_LIST module:_titleName];//2015.06.23
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"refreshNewsView" object:nil];
    
}

#if BUREAU_OF_EDUCATION
-(void)reloadHeadLineNews:(NSNotification *)notification{
    NSDictionary *notifyDic = [notification userInfo];
    
    _headLineNewsSid = [notifyDic objectForKey:@"sid"];
    
    ((UILabel *)self.navigationItem.titleView).text = [notifyDic objectForKey:@"name"];
    
    startNum = @"0";
    endNum = @"10";
    
    isReflashViewType = 1;
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"News", @"ac",
                          @"2", @"v",
                          @"news4edu", @"op",
                          _headLineNewsSid,@"school",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [self doNewsActionNewsList:data];
    
}
#endif

-(void)selectLeftAction:(id)sender
{
    // 设置刷新标志位，在下拉或者上拉刷新的时候，先判断是否需要网络请求，
    // 如不需要，则不请求
    reflashFlag = 0;
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 更新主画面new图标 2015.11.12
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:_newsDic];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
- (BOOL)gestureRecognizerShouldBegin{
    
    // 设置刷新标志位，在下拉或者上拉刷新的时候，先判断是否需要网络请求，
    // 如不需要，则不请求
    reflashFlag = 0;
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 更新主画面new图标 2015.11.12
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:_newsDic];
    return YES;
}

-(void)selectRightAction:(id)sender{
#if BUREAU_OF_EDUCATION
    if ([@"headLineNews"  isEqual: _newsType]) {
        SchoolListForBureauViewController *schoolListBureau = [[SchoolListForBureauViewController alloc]init];
        schoolListBureau.titleName = @"下属学校";
        schoolListBureau.viewType = @"headLineNews";
        [self.navigationController pushViewController:schoolListBureau animated:YES];
    }else{//添加遗漏分支 志伟确认 add by kate 2016.03.12
        
        if ([@"eduinspectorNews" isEqualToString:_fromName]) {
            
            
            SubmitViewController *submitViewCtrl = [[SubmitViewController alloc] init];
            [submitViewCtrl setFlag:4];
            [self.navigationController pushViewController:submitViewCtrl animated:YES];
            
        }else{
            
            HomeworkSubmitViewController *homeSubmitV = [[HomeworkSubmitViewController alloc] init];
            homeSubmitV.flag = 2;
            homeSubmitV.modelName = _titleName;
            [self.navigationController pushViewController:homeSubmitV animated:YES];
            
        }
        
    }
    
#else
    HomeworkSubmitViewController *homeSubmitV = [[HomeworkSubmitViewController alloc] init];
    homeSubmitV.flag = 2;
    homeSubmitV.modelName = _titleName;
    [self.navigationController pushViewController:homeSubmitV animated:YES];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    network.delegate = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [newsArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";
    NSUInteger section = [indexPath row];
    
    NSDictionary* list_dic = [newsArray objectAtIndex:section];
    
    NSString* title= [list_dic objectForKey:@"title"];
    NSString* dateline= [list_dic objectForKey:@"updatetime"];
    NSString* pic= [list_dic objectForKey:@"pic"];
    NSString* smessage= [list_dic objectForKey:@"smessage"];
    NSString* stick= [list_dic objectForKey:@"stick"];
    NSString* iscomment= [list_dic objectForKey:@"iscomment"];
    
    NSString *viewnum = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"viewnum"]];//add by kate 2015.03.19
    
    if ([@"eduinspectorNews"  isEqual: _fromName]) {
        NewsTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[NewsTableViewCell2 alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        [cell.imgView_thumb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0,0));
        }];
        
        Utilities *util = [Utilities alloc];
        
        cell.label_content.text = title;
        cell.label_contentDetail.text = smessage;
        
#if BUREAU_OF_EDUCATION
        cell.imgView_edu.hidden = YES;
        [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.label_content.mas_left).with.offset(0);
        }];
#endif
        
        if ([@"0"  isEqual: [list_dic objectForKey:@"readStatus"]]) {
            // 未读过的
            cell.label_content.textColor = [UIColor blackColor];
        }else {
            // 读过的
            cell.label_content.textColor = [UIColor grayColor];
        }
        cell.label_date.text = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        
        cell.label_contentDetail.text = [list_dic objectForKey:@"message"];
        
        cell.imgView_edit.hidden = YES;
        cell.imgView_stick.hidden = YES;
        
        return cell;
    }else {
        if([@""  isEqual: pic])
        {
            NewsTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
            if(cell == nil) {
                cell = [[NewsTableViewCell2 alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            [cell.imgView_thumb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0,0));
            }];
            
            Utilities *util = [Utilities alloc];
            
            cell.label_content.text = title;
            cell.label_contentDetail.text = smessage;
            
            if ([@"0"  isEqual: [list_dic objectForKey:@"readStatus"]]) {
                // 未读过的
                cell.label_content.textColor = [UIColor blackColor];
            }else {
                // 读过的
                cell.label_content.textColor = [UIColor grayColor];
            }
            
#if BUREAU_OF_EDUCATION
            cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
            
            if ([@"headLineNews"  isEqual: _newsType]) {
                // 教育局版本的校园头条不要置顶和评论
//                cell.imgView_stick.hidden = YES;
//                cell.imgView_edit.hidden = YES;
//                cell.imgView_edu.hidden = YES;
                
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                cell.label_viewNum.text = [list_dic objectForKey:@"schoolName"];
                [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.label_content.mas_left).with.offset(0);
                }];
//                cell.label_viewNum.frame = CGRectMake(cell.label_viewNum.frame.origin.x, cell.label_viewNum.frame.origin.y, cell.label_viewNum.frame.size.width + 29, cell.label_viewNum.frame.size.height);
                
            }else if ([@"schoolNews"  isEqual: _newsType]){
                // 公告发布不可评论，但是公告发布在学校无置顶，在教育局里可以置顶
                cell.imgView_edit.hidden = YES;
                
                if(![@"0"  isEqual: iscomment]) {
                    // 可编辑
                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                    
                    if (strSize.width > 250) {
                        cell.label_content.frame = CGRectMake(20, 20, 250, 15);
                    }
                    
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = NO;
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
//                    cell.imgView_edit.frame = CGRectMake(270, 16, 21, 21);
                    
                }else {
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = YES;
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                }
                
                if (![@"0"  isEqual: [list_dic objectForKey:@"schoolCount"]]) {
                    cell.imgView_edu.hidden = NO;
                }else {
//                    cell.imgView_edu.hidden = YES;
                    [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.label_content.mas_left).with.offset(0);
                    }];
                }
                
            }else{//添加漏掉的自定义公告分支 add by kate 2016.03.10
                
//                cell.imgView_edu.hidden = YES;
                [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
                
                if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
                    // 置顶加编辑
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 225) {
//                        cell.label_content.frame = CGRectMake(20, 20, 215, 15);
//                    }
//                    
                    cell.imgView_stick.hidden = NO;
                    cell.imgView_edit.hidden = NO;
                    
//                    cell.imgView_stick.frame = CGRectMake(240, 16, 21, 21);
                    
                }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
                    // 置顶
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 250) {
//                        cell.label_content.frame = CGRectMake(20, 20, 250, 15);
//                    }
                    
//                    cell.imgView_stick.hidden = NO;
//                    cell.imgView_edit.hidden = YES;
//                    
//                    cell.imgView_stick.frame = CGRectMake(270, 16, 21, 21);
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    
                }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
                    // 可编辑
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 250) {
//                        cell.label_content.frame = CGRectMake(20, 20, 250, 15);
//                    }
//                    
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = NO;
//                    
//                    cell.imgView_edit.frame = CGRectMake(270, 16, 21, 21);
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    
                }else {
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = YES;
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                }
                
                cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
                
            }
#else
            cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
                // 置顶加编辑
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 225) {
                //                    cell.label_content.frame = CGRectMake(20, 20, 215, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = NO;
                //                cell.imgView_edit.hidden = NO;
                //
                //                cell.imgView_stick.frame = CGRectMake(240, 16, 21, 21);
                
            }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
                // 置顶
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 250) {
                //                    cell.label_content.frame = CGRectMake(20, 20, 250, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = NO;
                //                cell.imgView_edit.hidden = YES;
                //
                //                cell.imgView_stick.frame = CGRectMake(270, 16, 21, 21);
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
            }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
                // 可编辑
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 250) {
                //                    cell.label_content.frame = CGRectMake(20, 20, 250, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = YES;
                //                cell.imgView_edit.hidden = NO;
                //
                //                cell.imgView_edit.frame = CGRectMake(270, 16, 21, 21);
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                
            }else {
                //                cell.imgView_stick.hidden = YES;
                //                cell.imgView_edit.hidden = YES;
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
            }
            
            cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
            
#endif
            
            return cell;
        }
        else
        {
            NewsImgTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
            if(cell == nil) {
                cell = [[NewsImgTableViewCell2 alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            Utilities *util = [Utilities alloc];
            
            cell.label_content.text = title;
            cell.label_contentDetail.text = smessage;
            [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            if ([@"0"  isEqual: [list_dic objectForKey:@"readStatus"]]) {
                // 未读过的
                cell.label_content.textColor = [UIColor blackColor];
            }else {
                // 读过的
                cell.label_content.textColor = [UIColor grayColor];
            }
#if BUREAU_OF_EDUCATION
            cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
            
            if ([@"headLineNews"  isEqual: _newsType]) {
                // 教育局版本的校园头条不要置顶和评论
//                cell.imgView_stick.hidden = YES;
//                cell.imgView_edit.hidden = YES;
//                cell.imgView_edu.hidden = YES;
                
                cell.label_viewNum.text = [list_dic objectForKey:@"schoolName"];
                
//                cell.label_viewNum.frame = CGRectMake(cell.label_viewNum.frame.origin.x, cell.label_viewNum.frame.origin.y, cell.label_viewNum.frame.size.width + 29, cell.label_viewNum.frame.size.height);
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.label_content.mas_left).with.offset(0);
                }];
            }else if ([@"schoolNews"  isEqual: _newsType]){
                // 公告发布不可评论，但是公告发布在学校无置顶，在教育局里可以置顶
                cell.imgView_edit.hidden = YES;
                
                if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
                    // 可编辑
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 170) {
//                        cell.label_content.frame = CGRectMake(98, 11, 170, 15);
//                    }
//                    
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = NO;
//                    
//                    cell.imgView_edit.frame = CGRectMake(270, 11, 21, 21);
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    
                }else {
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = YES;
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                }
                
                if (![@"0"  isEqual: [list_dic objectForKey:@"schoolCount"]]) {
                    cell.imgView_edu.hidden = NO;
                }else {
//                    cell.imgView_edu.hidden = YES;
                    [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.label_content.mas_left).with.offset(0);
                    }];
                }
                
            }else{//添加漏掉的自定义公告分支 add by kate 2016.03.10
                
//                cell.imgView_edu.hidden = YES;
                [cell.imgView_edu mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
                cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
                [cell.label_date mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.label_content.mas_left).with.offset(0);
                }];
                if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
                    // 置顶加编辑
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 150) {
//                        cell.label_content.frame = CGRectMake(98, 13, 140, 15);
//                    }
//                    
//                    cell.imgView_stick.hidden = NO;
//                    cell.imgView_edit.hidden = NO;
//                    
//                    cell.imgView_stick.frame = CGRectMake(240, 11, 21, 21);
                    
                }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
                    // 置顶
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 170) {
//                        cell.label_content.frame = CGRectMake(98, 11, 170, 15);
//                    }
//                    
//                    cell.imgView_stick.hidden = NO;
//                    cell.imgView_edit.hidden = YES;
//                    
//                    cell.imgView_stick.frame = CGRectMake(270, 11, 21, 21);
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    
                }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
                    // 可编辑
//                    CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
//                    
//                    if (strSize.width > 170) {
//                        cell.label_content.frame = CGRectMake(98, 11, 170, 15);
//                    }
//                    
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = NO;
//                    
//                    cell.imgView_edit.frame = CGRectMake(270, 11, 21, 21);
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    
                    
                }else {
//                    cell.imgView_stick.hidden = YES;
//                    cell.imgView_edit.hidden = YES;
                    [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                    [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(0, 0));
                    }];
                }
                
                cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
                
            }
            
#else
            cell.label_date.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
            if(([@"1"  isEqual: stick]) && ([@"1"  isEqual: iscomment])) {
                // 置顶加编辑
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 150) {
                //                    cell.label_content.frame = CGRectMake(98, 13, 140, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = NO;
                //                cell.imgView_edit.hidden = NO;
                //
                //                cell.imgView_stick.frame = CGRectMake(240, 11, 21, 21);
                
            }else if(([@"1"  isEqual: stick]) && (![@"1"  isEqual: iscomment])) {
                // 置顶
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 170) {
                //                    cell.label_content.frame = CGRectMake(98, 11, 170, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = NO;
                //                cell.imgView_edit.hidden = YES;
                //
                //                cell.imgView_stick.frame = CGRectMake(270, 11, 21, 21);
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                
                [cell.label_content mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.imgView_stick.mas_left).with.offset(0);
                }];
                
                
                
            }else if((![@"1"  isEqual: stick]) && (![@"0"  isEqual: iscomment])) {
                // 可编辑
                //                CGSize strSize = [Utilities getStringHeight:title andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(0, 15)];
                //
                //                if (strSize.width > 170) {
                //                    cell.label_content.frame = CGRectMake(98, 11, 170, 15);
                //                }
                //
                //                cell.imgView_stick.hidden = YES;
                //                cell.imgView_edit.hidden = NO;
                //
                //                cell.imgView_edit.frame = CGRectMake(270, 11, 21, 21);
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                [cell.label_content mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.imgView_stick.mas_left).with.offset(0);
                }];
                
            }else {
                //                cell.imgView_stick.hidden = YES;
                //                cell.imgView_edit.hidden = YES;
                [cell.imgView_edit mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                [cell.imgView_stick mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0,0));
                }];
                [cell.label_content mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.imgView_stick.mas_left).with.offset(0);
                }];
            }
            
            cell.label_viewNum.text = [NSString stringWithFormat: @"浏览 %@ 次", viewnum];//add by kate 2015.03.19
#endif
            
            
            return cell;
        }
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *dic = [newsArray objectAtIndex:indexPath.row];
    
    if ([@"eduinspectorNews"  isEqual: _fromName]) {
        NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _titleName, [dic objectForKey:@"fid"]];
        ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
        rsObj.readId = readId;
        rsObj.status = @"1";
        [rsObj updateToDB];
        
    }else {
        // 设置db中的该条数据变为已读
        NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _mid, [dic objectForKey:@"newsid"]];
        ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
        rsObj.readId = readId;
        rsObj.status = @"1";
        [rsObj updateToDB];
    }
    
    
    // 设置内存中的该条数据变为已读
    NSMutableDictionary* list_dic1 = [newsArray objectAtIndex:[indexPath row]];
    [list_dic1 setObject:@"1" forKey:@"readStatus"];
    [newsArray replaceObjectAtIndex:[indexPath row] withObject:list_dic1];
    
    if ([@"eduinspectorNews"  isEqual: _fromName]) {
        
        NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:_titleName];
        
        newsDetailViewCtrl.newsid = [list_dic1 objectForKey:@"fid"];
        Utilities *util = [[Utilities alloc] init];
        newsDetailViewCtrl.newsDate = [util linuxDateToString:[list_dic1 objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        //        newsDetailViewCtrl.viewNum = [dic objectForKey:@"viewnum"];
        
        newsDetailViewCtrl.isEduinspectorNews = YES;
        
        newsDetailViewCtrl.isFromDownNotification = YES;
        
        [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
        
    }else {
        NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:_titleName];
        
        newsDetailViewCtrl.newsid = [newsidList objectAtIndex:indexPath.row];
        newsDetailViewCtrl.newsDate = [newsDateList objectAtIndex:indexPath.row];
        newsDetailViewCtrl.viewNum = [dic objectForKey:@"viewnum"];
#if BUREAU_OF_EDUCATION
        
        newsDetailViewCtrl.schoolName = [dic objectForKey:@"schoolName"];
        newsDetailViewCtrl.newsType = _newsType;
        newsDetailViewCtrl.schoolCount = [dic objectForKey:@"schoolCount"];
        
#endif
        [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
    }
}

-(void)doGetNews {
#if 0
    newsDBArray = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
    
    if (0 == [newsDBArray count]) {
        // 菊花
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"News", @"ac",
                              @"2", @"v",
                              @"newsList", @"op",
                              _titleName, @"smid",
                              startNum, @"page",
                              endNum, @"size",
                              nil];
        
        [self doNewsActionNewsList:data];
    }else {
        // 20140922 update by ht 修正最新时间的获取，改为从db中取update最新的值，而不是最后一条得updatetime
        NSString *lastTime = [[NewsListDBDao getDaoInstance] getLastTimeFromNews:_titleName];
        
        // 判断服务器上是否有更新的新闻条目
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"News", @"ac",
                              @"2", @"v",
                              @"lastUpdatedNews", @"op",
                              _titleName, @"smid",
                              @"0", @"page",
                              @"0", @"size",
                              lastTime,@"lastTime",
                              nil];
        
        [self doNewsActionLastUpdatedNews:data];
    }
#endif
    
    //----离线缓存2015.09.22--------------------------
    [NewsListDBDao getDaoInstance];
    BOOL isConnect = [Utilities connectedToNetwork];
    startNum = @"0";
    
    if (isConnect) {
#if BUREAU_OF_EDUCATION
        /**
         * 教育局新闻列表
         * @author luke
         * @date 2016.03.07
         * @args
         *  v=2 ac=News op=news4edu sid= uid= school=[0:all|sid:某学校] page=0 size=3
         */
        
        [Utilities showProcessingHud:self.view];
        
        if ([@"headLineNews"  isEqual: _newsType]) {
            
            NSString *school = @"0";
            if (nil != _headLineNewsSid) {
                school = _headLineNewsSid;
            }
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"news4edu", @"op",
                                  school,@"school",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }else if ([@"schoolNews"  isEqual: _newsType]){
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"edu2news", @"op",
                                  @"0",@"school",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }else if ([@"eduinspectorNews"  isEqual: _fromName]) {//add by kate 2016.06.08
            
            /**
             * 通知列表
             * @author yangzc
             * @date 2016.05.28
             * @args
             *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
             */
            NSDictionary *user_info = [g_userInfo getUserDetailInfo];
            NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"InspectorMessage",@"ac",
                                  @"3",@"v",
                                  @"messageList", @"op",
                                  cid, @"cid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  [Utilities getAppVersion], @"app",
                                  nil];
            
            [self doEduinspectorNewsActionNewsList:data];
            
        }else{//添加漏掉的自定义公告分支 add by kate 2016.03.10
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"newsList", @"op",
                                  _titleName, @"smid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }
#else
        if ([@"eduinspectorNews"  isEqual: _fromName]) {
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            /**
             * 通知列表
             * @author yangzc
             * @date 2016.05.28
             * @args
             *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
             */
            NSDictionary *user_info = [g_userInfo getUserDetailInfo];
            NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"InspectorMessage",@"ac",
                                  @"3",@"v",
                                  @"messageList", @"op",
                                  cid, @"cid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  [Utilities getAppVersion], @"app",
                                  nil];
            
            [self doEduinspectorNewsActionNewsList:data];
            
        }else {
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"newsList", @"op",
                                  _titleName, @"smid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }
#endif
        
        
        
    }else{
        
        NSArray *arr = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
        
        if ([arr count] > 0) {
            
            [newsArray removeAllObjects];
            [newsidList removeAllObjects];
            [newsDateList removeAllObjects];
            
            for (NSObject *object in arr)
            {
                NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                
                // 去db里查找是否有该条记录。
                NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _mid, [listDic objectForKey:@"newsid"]];
                NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                
                if (nil == dicFromDb) {
                    // db里没有，存入db。
                    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                    rsObj.readId = readId;
                    rsObj.status = @"0";
                    [rsObj updateToDB];
                    
                    [listDic setObject:@"0" forKey:@"readStatus"];
                }else {
                    // db里面有，直接取出来。
                    NSString *status = [dicFromDb objectForKey:@"status"];
                    [listDic setObject:status forKey:@"readStatus"];
                }
                
                [newsArray addObject:listDic];
            }
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            for (NSObject *object in arr)
            {
                NSDictionary *dic = (NSDictionary *)object;
                [newsidList addObject:[dic objectForKey:@"newsid"]];
                
                NSString* dateline= [dic objectForKey:@"updatetime"];
                [newsDateList addObject:dateline];
            }
        }
        
        
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [_tableView reloadData];
    }
    
    //-----------------------------------------------
    
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

//刷新调用的方法
-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
        //        [newsArray removeAllObjects];
        //        [newsidList removeAllObjects];
        //        [newsDateList removeAllObjects];
#if 0
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"News", @"ac",
                              @"2", @"v",
                              @"newsList", @"op",
                              _titleName, @"smid",
                              startNum, @"page",
                              endNum, @"size",
                              nil];
        
        [self doNewsActionNewsList:data];
#endif
        //-----2015.09.22------------------------------------------------------------
        BOOL isConnect = [Utilities connectedToNetwork];
        if (isConnect) {
#if BUREAU_OF_EDUCATION
            if ([@"headLineNews"  isEqual: _newsType]) {
                
                NSString *school = @"0";
                if (nil != _headLineNewsSid) {
                    school = _headLineNewsSid;
                }
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"News", @"ac",
                                      @"2", @"v",
                                      @"news4edu", @"op",
                                      school,@"school",
                                      startNum, @"page",
                                      endNum, @"size",
                                      nil];
                
                [self doNewsActionNewsList:data];
            }else if ([@"eduinspectorNews"  isEqual: _fromName]) {//add by kate 2016.06.08
                
                /**
                 * 通知列表
                 * @author yangzc
                 * @date 2016.05.28
                 * @args
                 *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
                 */
                NSDictionary *user_info = [g_userInfo getUserDetailInfo];
                NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"InspectorMessage",@"ac",
                                      @"3",@"v",
                                      @"messageList", @"op",
                                      cid, @"cid",
                                      startNum, @"page",
                                      endNum, @"size",
                                      [Utilities getAppVersion], @"app",
                                      nil];
                
                [self doEduinspectorNewsActionNewsList:data];
            }else if ([@"schoolNews"  isEqual: _newsType]){
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"News", @"ac",
                                      @"2", @"v",
                                      @"edu2news", @"op",
                                      @"0",@"school",
                                      startNum, @"page",
                                      endNum, @"size",
                                      nil];
                
                [self doNewsActionNewsList:data];
            }else{
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"News", @"ac",
                                      @"2", @"v",
                                      @"newsList", @"op",
                                      _titleName, @"smid",
                                      startNum, @"page",
                                      endNum, @"size",
                                      nil];
                
                [self doNewsActionNewsList:data];
            }
#else
            if ([@"eduinspectorNews"  isEqual: _fromName]) {
                //[Utilities showProcessingHud:self.view];// modify by kate 下拉刷新不需要转圈
                
                /**
                 * 通知列表
                 * @author yangzc
                 * @date 2016.05.28
                 * @args
                 *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
                 */
                NSDictionary *user_info = [g_userInfo getUserDetailInfo];
                NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"InspectorMessage",@"ac",
                                      @"3",@"v",
                                      @"messageList", @"op",
                                      cid, @"cid",
                                      startNum, @"page",
                                      endNum, @"size",
                                      [Utilities getAppVersion], @"app",
                                      nil];
                
                [self doEduinspectorNewsActionNewsList:data];
            }else {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"News", @"ac",
                                      @"2", @"v",
                                      @"newsList", @"op",
                                      _titleName, @"smid",
                                      startNum, @"page",
                                      endNum, @"size",
                                      nil];
                
                [self doNewsActionNewsList:data];
            }
#endif
            
        }else{
            
            NSArray *arr = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
            
            
            if ([arr count] > 0) {
                
                [newsArray removeAllObjects];
                [newsidList removeAllObjects];
                [newsDateList removeAllObjects];
                
                for (NSObject *object in arr)
                {
                    NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                    
                    // 去db里查找是否有该条记录。
                    NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _mid, [listDic objectForKey:@"newsid"]];
                    NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                    
                    if (nil == dicFromDb) {
                        // db里没有，存入db。
                        ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                        rsObj.readId = readId;
                        rsObj.status = @"0";
                        [rsObj updateToDB];
                        
                        [listDic setObject:@"0" forKey:@"readStatus"];
                    }else {
                        // db里面有，直接取出来。
                        NSString *status = [dicFromDb objectForKey:@"status"];
                        [listDic setObject:status forKey:@"readStatus"];
                    }
                    
                    [newsArray addObject:listDic];
                }
                startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
                for (NSObject *object in arr)
                {
                    NSDictionary *dic = (NSDictionary *)object;
                    [newsidList addObject:[dic objectForKey:@"newsid"]];
                    
                    NSString* dateline= [dic objectForKey:@"updatetime"];
                    [newsDateList addObject:dateline];
                }
                
                
            }
            
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            [_tableView reloadData];
        }
        //-------------------------------------------------------------------------------------------------
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
#if 0
    
    NSArray *arr = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
    
    // 如果db中没有新数据了，就去服务器上取
    if (0 == [arr count]) {
        if (reflashFlag == 1) {
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"newsList", @"op",
                                  _titleName, @"smid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }
    }else {
        for (NSObject *object in arr)
        {
            [newsArray addObject:object];
        }
        
        startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
        
        for (NSObject *object in arr)
        {
            NSDictionary *dic = (NSDictionary *)object;
            [newsidList addObject:[dic objectForKey:@"newsid"]];
            
            NSString* dateline= [dic objectForKey:@"updatetime"];
            [newsDateList addObject:dateline];
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [_tableView reloadData];
    }
#endif
    
    //----离线缓存2015.09.22--------------------------
    
    BOOL isConnect = [Utilities connectedToNetwork];
    
    if (isConnect) {
#if BUREAU_OF_EDUCATION
        if ([@"headLineNews"  isEqual: _newsType]) {
            
            NSString *school = @"0";
            if (nil != _headLineNewsSid) {
                school = _headLineNewsSid;
            }
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"news4edu", @"op",
                                  school,@"school",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }else if ([@"schoolNews"  isEqual: _newsType]){
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"edu2news", @"op",
                                  @"0",@"school",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }if ([@"eduinspectorNews"  isEqual: _fromName]) {
            
            /**
             * 通知列表
             * @author yangzc
             * @date 2016.05.28
             * @args
             *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
             */
            
            NSDictionary *user_info = [g_userInfo getUserDetailInfo];
            NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"InspectorMessage",@"ac",
                                  @"3",@"v",
                                  @"messageList", @"op",
                                  cid, @"cid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  [Utilities getAppVersion], @"app",
                                  nil];
            
            [self doEduinspectorNewsActionNewsList:data];
        }else{
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"newsList", @"op",
                                  _titleName, @"smid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }
#else
        if ([@"eduinspectorNews"  isEqual: _fromName]) {
            //[Utilities showProcessingHud:self.view];//// modify by kate 上拉加载更多不需要转圈
            
            /**
             * 通知列表
             * @author yangzc
             * @date 2016.05.28
             * @args
             *  v=3 ac=InspectorMessage op=messageList sid= cid= uid= app=
             */
            
            NSDictionary *user_info = [g_userInfo getUserDetailInfo];
            NSString *cid = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"InspectorMessage",@"ac",
                                  @"3",@"v",
                                  @"messageList", @"op",
                                  cid, @"cid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  [Utilities getAppVersion], @"app",
                                  nil];
            
            [self doEduinspectorNewsActionNewsList:data];
        }else {
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"newsList", @"op",
                                  _titleName, @"smid",
                                  startNum, @"page",
                                  endNum, @"size",
                                  nil];
            
            [self doNewsActionNewsList:data];
        }
#endif
    }else{
        
        NSArray *arr = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
        
        if ([arr count] > 0) {
            
            for (NSObject *object in arr)
            {
                NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                
                // 去db里查找是否有该条记录。
                NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _mid, [listDic objectForKey:@"newsid"]];
                NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                
                if (nil == dicFromDb) {
                    // db里没有，存入db。
                    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                    rsObj.readId = readId;
                    rsObj.status = @"0";
                    [rsObj updateToDB];
                    
                    [listDic setObject:@"0" forKey:@"readStatus"];
                }else {
                    // db里面有，直接取出来。
                    NSString *status = [dicFromDb objectForKey:@"status"];
                    [listDic setObject:status forKey:@"readStatus"];
                }
                
                [newsArray addObject:listDic];
            }
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            for (NSObject *object in arr)
            {
                NSDictionary *dic = (NSDictionary *)object;
                [newsidList addObject:[dic objectForKey:@"newsid"]];
                
                NSString* dateline= [dic objectForKey:@"updatetime"];
                [newsDateList addObject:dateline];
            }
        }
        
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [_tableView reloadData];
        
    }
    //-----------------------------------------------
    
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

- (id)initWithVar:(NSString *)newsName;
{
    if(self = [super init])
    {
        _titleName = newsName;
    }
    
    return self;
}

- (void)doEduinspectorNewsActionNewsList:(NSDictionary *)data
{
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            //BOOL isHasNext = [[message_info objectForKey:@"hasNext"] boolValue];
            
            NSArray *temp = [message_info objectForKey:@"list"];
            
            //        for(int i = 0; i < [temp count]; i++)
            //        {
            //            NSObject *obj = [[temp objectAtIndex:i] copy];
            //            [newsArray addObject: obj];
            //        }
            
            if (isReflashViewType == 1) {
                [newsArray removeAllObjects];
                [newsidList removeAllObjects];
                [newsDateList removeAllObjects];
            }
            
            //            Utilities *util = [Utilities alloc];
#if 1
            //----2015.09.22----------------------------------------------------------------
            if ([@"0" isEqualToString:startNum]) {
                
                [[NewsListDBDao getDaoInstance] deleteAllData];// 删除所有数据
            }
            //-----------------------------------------------------------------------
#endif
            
            for (NSObject *object in temp)
            {
                NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                
                // 去db里查找是否有该条记录。
                NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _titleName, [listDic objectForKey:@"fid"]];
                NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                
                if (nil == dicFromDb) {
                    // db里没有，存入db。
                    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                    rsObj.readId = readId;
                    rsObj.status = @"0";
                    [rsObj updateToDB];
                    
                    [listDic setObject:@"0" forKey:@"readStatus"];
                }else {
                    // db里面有，直接取出来。
                    NSString *status = [dicFromDb objectForKey:@"status"];
                    [listDic setObject:status forKey:@"readStatus"];
                }
                
                [newsArray addObject:listDic];
                
                NSDictionary *dic = (NSDictionary *)object;
                [newsidList addObject:[dic objectForKey:@"fid"]];
                
                
                //                NSString* dateline= [dic objectForKey:@"updatetime"];
                //                [newsDateList addObject:dateline];
            }
            
            //            NSArray *arr = [[NewsListDBDao getDaoInstance] getAllData];
            
            //        if(([NSString stringWithFormat:@"%d",(startNum.integerValue + 5)].integerValue  >= count.integerValue))
            //        {
            //            endNum = count;
            //        }
            //        else
            //        {
            
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
            //        }
            
            //[self performSelector:@selector(finishReloadingData) withObject:nil afterDelay:1.0];
            [self removeFooterView];
            
            //[self testFinishedLoadData];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            //刷新表格内容
            [_tableView reloadData];
            
            if ([newsidList count] > 0) {
                
#if 0
                NSString *newsId =  [[NewsListDBDao getDaoInstance] getAllDataNOOrder:_titleName];
                [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:_titleName];
#endif
                //------------2015.11.12----------------------------------------------------------------------
                NSLog(@"newsDic:%@",_newsDic);
                // 更新督学最后一条id
                [Utilities updateSchoolRedPoints:_last mid:_mid];
                //-------------------------------------------------------------------------------------------------
                
            }
            //----add by kate-------------------------------
            if ([newsArray count] > 0) {
                
                noDataView.hidden = YES;
                [Utilities dismissNodataView:self.view];
                
            }else{
               // noDataView.hidden = NO;
               [Utilities showNodataView:@"一条信息也没有" msg2:@"管理员不勤快" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }
        } else {
            
            [Utilities dismissProcessingHud:self.view];
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        
        if (![Utilities isConnected]) {//2015.06.30
            
            if ([startNum integerValue] >= 1) {
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }else{
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
                
            }
            
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    }];
}

- (void)doNewsActionNewsList:(NSDictionary *)data
{
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            //BOOL isHasNext = [[message_info objectForKey:@"hasNext"] boolValue];
            
            NSArray *temp = [message_info objectForKey:@"list"];
            
            //        for(int i = 0; i < [temp count]; i++)
            //        {
            //            NSObject *obj = [[temp objectAtIndex:i] copy];
            //            [newsArray addObject: obj];
            //        }
            
            if (isReflashViewType == 1) {
                [newsArray removeAllObjects];
                [newsidList removeAllObjects];
                [newsDateList removeAllObjects];
            }
            
            //            Utilities *util = [Utilities alloc];
#if 1
            //----2015.09.22----------------------------------------------------------------
            if ([@"0" isEqualToString:startNum]) {
                
                [[NewsListDBDao getDaoInstance] deleteAllData];// 删除所有数据
            }
            //-----------------------------------------------------------------------
#endif
            
            for (NSObject *object in temp)
            {
                NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                
                // 去db里查找是否有该条记录。
                NSString *readId = [NSString stringWithFormat:@"%@%@_%@", @"newsList", _mid, [listDic objectForKey:@"newsid"]];
                NSDictionary *dicFromDb = [[ReadStatusDBDao getDaoInstance] getDataFromReadId:readId];
                
                if (nil == dicFromDb) {
                    // db里没有，存入db。
                    ReadStatusObject *rsObj = [[ReadStatusObject alloc] init];
                    rsObj.readId = readId;
                    rsObj.status = @"0";
                    [rsObj updateToDB];
                    
                    [listDic setObject:@"0" forKey:@"readStatus"];
                }else {
                    // db里面有，直接取出来。
                    NSString *status = [dicFromDb objectForKey:@"status"];
                    [listDic setObject:status forKey:@"readStatus"];
                }
                
                [newsArray addObject:listDic];
                
                NSDictionary *dic = (NSDictionary *)object;
                [newsidList addObject:[dic objectForKey:@"newsid"]];
                
                NewsListObject *newsList = [[NewsListObject alloc] init];
                newsList.newsid = [dic objectForKey:@"newsid"];
                newsList.newsType = _titleName;
                
                newsList.title = [dic objectForKey:@"title"];
                newsList.dateline = [dic objectForKey:@"dateline"];
                newsList.pic = [dic objectForKey:@"pic"];
                newsList.updatetime = [dic objectForKey:@"updatetime"];
                newsList.stick = [dic objectForKey:@"stick"];
                newsList.digest = [Utilities replaceNull:[dic objectForKey:@"digest"]];
                newsList.smessage = [dic objectForKey:@"smessage"];
                newsList.viewnum = [dic objectForKey:@"viewnum"];
                newsList.iscomment = [dic objectForKey:@"iscomment"];
                [newsList updateToDB];
                
                NSString* dateline= [dic objectForKey:@"updatetime"];
                [newsDateList addObject:dateline];
            }
            
            //            NSArray *arr = [[NewsListDBDao getDaoInstance] getAllData];
            
            //        if(([NSString stringWithFormat:@"%d",(startNum.integerValue + 5)].integerValue  >= count.integerValue))
            //        {
            //            endNum = count;
            //        }
            //        else
            //        {
            
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
            //endNum = [NSString stringWithFormat:@"%d",(endNum.integerValue + 5)];
            //        }
            
            //[self performSelector:@selector(finishReloadingData) withObject:nil afterDelay:1.0];
            [self removeFooterView];
            
            //[self testFinishedLoadData];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1];
            
            //刷新表格内容
            [_tableView reloadData];
            
            if ([newsidList count] > 0) {
                
#if 0
                NSString *newsId =  [[NewsListDBDao getDaoInstance] getAllDataNOOrder:_titleName];
                [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:_titleName];
#endif
                //------------2015.11.12----------------------------------------------------------------------
                // 更新公告类最后一条id
                NSString *last =  [[NewsListDBDao getDaoInstance] getAllDataNOOrder:_titleName];
                [Utilities updateSchoolRedPoints:last mid:_mid];
                //-------------------------------------------------------------------------------------------------
                
            }
            //----add by kate-------------------------------
            if ([newsArray count] > 0) {
                
                //noDataView.hidden = YES;
                [Utilities dismissNodataView:self.view];
                
            }else{
                //noDataView.hidden = NO;
                [Utilities showNodataView:@"一条信息也没有" msg2:@"管理员不勤快" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }
        } else {
            
            [Utilities dismissProcessingHud:self.view];
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        
        if (![Utilities isConnected]) {//2015.06.30
            
            if ([startNum integerValue] >= 1) {
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }else{
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
                
            }
            
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    }];
}

- (void)doNewsActionLastUpdatedNews:(NSDictionary *)data
{
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            // 有新的新闻条目，判断是增加还是删除或者更新，然后更新到数据库
            NSArray *arr = [[respDic objectForKey:@"message"] objectForKey:@"list"];
            
            if (0 != [arr count]) {
                for (int i=0; i<[arr count]; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    
                    // 获取有变化的数据，直接更新数据库即可，现在还差删除的信息
                    NewsListObject *newsList = [[NewsListObject alloc] init];
                    newsList.newsid = [dic objectForKey:@"newsid"];
                    newsList.newsType = _titleName;
                    
                    newsList.title = [dic objectForKey:@"title"];
                    newsList.dateline = [dic objectForKey:@"dateline"];
                    newsList.pic = [dic objectForKey:@"pic"];
                    newsList.updatetime = [dic objectForKey:@"updatetime"];
                    newsList.stick = [dic objectForKey:@"stick"];
                    newsList.digest = [Utilities replaceNull:[dic objectForKey:@"digest"]];
                    newsList.smessage = [dic objectForKey:@"smessage"];
                    newsList.viewnum = [dic objectForKey:@"viewnum"];
                    newsList.iscomment = [dic objectForKey:@"iscomment"];
                    [newsList updateToDB];
                }
                
                // 因为有更新的新闻内容，需要去db中重新取出前10条并且显示，这里重新给page和size赋值
                startNum = @"0";
                endNum = @"10";
                
                // 去db中重新取出前10条
                newsDBArray = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
                
                // 为了上拉更多，自增page
                startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
                
                newsArray = newsDBArray;
                
                [newsidList removeAllObjects];
                [newsDateList removeAllObjects];
                
                for (NSObject *object in newsDBArray)
                {
                    NSDictionary *dic = (NSDictionary *)object;
                    [newsidList addObject:[dic objectForKey:@"newsid"]];
                    
                    NSString* dateline= [dic objectForKey:@"updatetime"];
                    [newsDateList addObject:dateline];
                }
                
                [_tableView reloadData];
                
                if ([newsidList count] > 0) {
                    
                    //NSString *newsId = [NSString stringWithFormat:@"%@",[newsidList objectAtIndex:0]];
                    //NSString *newsId = [NSString stringWithFormat:@"%@",[newsidList objectAtIndex:0]];
                    NSString *newsId =  [[NewsListDBDao getDaoInstance] getAllDataNOOrder:_titleName];
                    [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:_titleName];
                }
                
                //----add by kate------------------------------------------
                if ([newsArray count] > 0) {
                    
                    //noDataView.hidden = YES;
                    [Utilities dismissNodataView:self.view];
                }else{
                    //noDataView.hidden = NO;
                    [Utilities showNodataView:@"一条信息也没有" msg2:@"管理员不勤快" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
                }
                //-------------------------------------------------------------
                
            }else {
                // nothing
            }
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        newsDBArray = [[NewsListDBDao getDaoInstance] getDataType:_titleName andPage:startNum andSize:endNum];
    }];
    
    newsArray = newsDBArray;
    
    startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 10)];
    
    for (NSObject *object in newsDBArray)
    {
        NSDictionary *dic = (NSDictionary *)object;
        [newsidList addObject:[dic objectForKey:@"newsid"]];
        
        NSString* dateline= [dic objectForKey:@"updatetime"];
        [newsDateList addObject:dateline];
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    
}

@end

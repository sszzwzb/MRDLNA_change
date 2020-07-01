//
//  NewListViewController.m
//  MicroSchool
//  个人动态消息列表
//  Created by Kate on 14-12-18.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "NewListViewController.h"
#import "NewListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MomentsDetailViewController.h"
#import "MicroSchoolAppDelegate.h"

@interface NewListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"动态消息"];
    [self setCustomizeLeftButton];
    
    
    //listArray = [[NSMutableArray alloc]init];
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
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getData:@"0"];
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
}

-(void)reload{
    
    [_tableView reloadData];
}




// 获取数据从服务器
-(void)getData:(NSString*)index{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *diction = [FRNetPoolUtils getSelfNewsList:index size:@"20"];
        
        NSMutableArray *array = [diction objectForKey:@"list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
                
            }
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            if (diction == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if ([array count] >0) {
                    
                    [self setCustomizeRightButton:@"icon_trash_p.png"];
                    
                    [noDataView removeFromSuperview];
                    
                    if ([startNum intValue] > 0) {
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            [listArray addObject:[array objectAtIndex:i]];
                        }
                        
                    }else{
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        //----------------------------------------------------
                        // done :从我的动态进入 因为没有模块id所以无法更新
                        NSString *module = [diction objectForKey:@"module"];//师生圈模块id 2016.07.11
                        
                        // 个人消息动态lastid
                        //lastIdStr = [[array objectAtIndex:0] objectForKey:@"mid"];
                        lastIdStr = [diction objectForKey:@"last"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                       
                        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastMyNewMsgIdDic"]];
                        [tempDic setObject:lastIdStr forKey:[Utilities getUniqueUid]];
                        [userDefaults setObject:tempDic forKey:@"lastMyNewMsgIdDic"];
                        [userDefaults synchronize];

                        NSDictionary *user = [g_userInfo getUserDetailInfo];
                        NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                        //if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                        
                        if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                           
                            
                            NSString *cid = [user objectForKey:@"role_cid"];
                            
                            if ([usertype integerValue] == 0) {
                                
                                if (_mid) {
                                    [Utilities updateClassRedPoints:_cid last:lastIdStr mid:_mid];
                                }else{
                                    [Utilities updateClassRedPoints:cid last:lastIdStr mid:module];
                                }
                                
                            }else{
                                
                                // 6555_698 6589_698
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                NSMutableArray *classArray = [[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:@"cids_parent"]];
                                
                                if ([classArray count] == 0) {
                                    
                                    classArray = [self doGetChild];
                                    
                                }
                                
                                for (int i = 0 ; i<[classArray count]; i++) {
                                    
                                    NSString *cid = [NSString stringWithFormat:@"%@",[classArray objectAtIndex:i]];
                                    
                                    if ([cid length]>0 && [cid integerValue]>0) {
                                        
                                        [Utilities updateClassRedPoints:cid last:lastIdStr mid:module];
                                    }
                                    
                                }
                                
                                
                            }
                            
#if 0
                           // 学生 更新该班级的班级圈评论最后一条id
                            [Utilities updateClassRedPoints:_cid last:lastIdStr mid:_mid];
#endif

                        }else{
                            
                            // 老师 更新所有班级的班级圈评论最后一条id
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            NSMutableDictionary *alwaysNewsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"alwaysNewsDic"]];
                            NSArray *classArray = [alwaysNewsDic objectForKey:@"classes"];
                            
                            NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                            NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
                            
                            for (int i = 0 ; i<[classArray count]; i++) {
                                
                                NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                                NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                                 NSString *type = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"type"]];
                                if ([type integerValue] == 19) {
                                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                                    [classLastDicDefault setObject:lastIdStr forKey:keyStr];
                                }
                                
                            }
                            [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
                            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                            [userDefaults synchronize];
                           
                        }
     
                        //---------------------------------------------------------
                            // done:更新班级动态
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView1" object:nil];
                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                        NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                        UINavigationController *nav = [array objectAtIndex:1];
                        
                        if ([[nav.viewControllers objectAtIndex:0] isKindOfClass:[MyClassListViewController class]]) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                            
                        }
                            
                        /*}
                        
                        else{
                            //2.9.4 老师身份 师生圈(动态)从主页回来了 入口仅在发现中班级中没有 学生身份动态入口仅在班级主页中 发现中没有
                            // 个人消息动态lastid
                            lastIdStr = [[array objectAtIndex:0] objectForKey:@"mid"];
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            
                            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastMyNewMsgIdDic"]];
                            [tempDic setObject:lastIdStr forKey:[Utilities getUniqueUid]];
                            [userDefaults setObject:tempDic forKey:@"lastMyNewMsgIdDic"];
                            [userDefaults synchronize];
                            //---------------------------------------------------------
                            
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
                        }*/
                        
                       
                        }
                        
                      
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }else{
                    
                    if([startNum intValue] == 0){
                        
//                        _tableView.hidden = NO;

                        [listArray removeAllObjects];
                        
                        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];

//                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
//                        noDataView = [Utilities showNodataView:@"空空如也" msg2:@"去其他地方看看吧" andRect:rect];
//                        [self.view addSubview:noDataView];
                        
                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                        noDataView = [Utilities showNodataView:@"还木有消息" msg2:@"过会再来看看吧" andRect:rect imgName:@"消息列表_03.png"];
                        [self.view addSubview:noDataView];

                    }
                    
                }
                
            }
        });
        
    });
}

//获取家长的子女列表 为了得到加入的cid 2016.07.11
- (NSMutableArray*)doGetChild {
    /**
     * 获取家长在当前学校的绑定的子女列表
     * @auth yangzc
     * @date 16/6/16
     * @args
     *  v=4 ac=StudentIdBind op=findRecord sid= cid= uid=
     */
    
    NSDictionary *userD = [g_userInfo getUserDetailInfo];
    NSString *cid = [userD objectForKey:@"role_cid"];
    //---add by kate 2016.06.30------------------------------------------
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *classArray = [[NSMutableArray alloc] init];
    //--------------------------------------------------------------------
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"StudentIdBind", @"ac",
                          @"4", @"v",
                          @"findRecord", @"op",
                          cid, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSMutableArray *list = [NSMutableArray arrayWithArray:[respDic objectForKey:@"message"]];
            
            if (0 != [list count]) {
                
                for (int i=0; i<[list count]; i++) {
                    
                    //---add by kate 2016.06.30----------------------
                    //存储家长加入的多个班级cid 用户更新师生圈红点
                    
                    NSString *class_id = [[list objectAtIndex:i] objectForKey:@"class_id"];
                    [classArray addObject:class_id];
                    
                    [userDefaults setObject:classArray forKey:@"cids_parent"];
                    [userDefaults synchronize];
                    //-----------------------------------------------
                    
                }
                
            }
            
        }else{
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
    return classArray;
}

//刷新调用的方法
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
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}

-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    // 更新主画面new图标 2015.11.12
    //alwaysNewsDic
    if (!_newsDic) {
    
       _newsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"alwaysNewsDic"];
    }
    
    // 2.9.4迭代2 需求 去掉红点
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MAIN_NEW_MESSAGE object:_newsDic];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)selectRightAction:(id)sender{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"是否清空我的全部动态"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    alert.tag = 250;
    [alert show];

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
    static NSString *CellTableIdentifier = @"NewListTableViewCell";
    
    NewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
       
        UINib *nib = [UINib nibWithNibName:@"NewListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
        NSString* head_url = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]];
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        cell.nameLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"subject"]];
        cell.noteLabel.text = [Utilities replaceNull:[[listArray objectAtIndex:indexPath.row] objectForKey:@"message"]];
        cell.headImg.layer.masksToBounds = YES;
        cell.headImg.layer.cornerRadius = cell.headImg.frame.size.height/2.0;

    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *tid = [[listArray objectAtIndex:indexPath.row]objectForKey:@"tid"];
    //跳转到动态详情页
    MomentsDetailViewController *momentsDetail = [[MomentsDetailViewController alloc]init];
    momentsDetail.tid = tid;
    [self.navigationController pushViewController:momentsDetail animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete");
    NSString *mid = [[listArray objectAtIndex:indexPath.row]objectForKey:@"mid"];
    [self deleteItem:mid];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 250) {
        if (buttonIndex == 1) {
            [self deleteAll:lastIdStr];
        }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 删除某条
-(void)deleteItem:(NSString*)tid{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils deleteMyMomentsById:tid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            if (msg == nil) {
                
                [self getData:@"0"];
                startNum = @"0";
                reflashFlag = 1;
                isReflashViewType = 1;
                
            }else{
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        });
        
    });
}

// 清空列表
-(void)deleteAll:(NSString*)last{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils deleteMyMoments:last];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            if (msg == nil) {
                
                [self getData:@"0"];
                startNum = @"0";
                reflashFlag = 1;
                isReflashViewType = 1;
                
                [self setCustomizeRightButton:@""];
                
            }else{
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        });
        
    });

}

@end

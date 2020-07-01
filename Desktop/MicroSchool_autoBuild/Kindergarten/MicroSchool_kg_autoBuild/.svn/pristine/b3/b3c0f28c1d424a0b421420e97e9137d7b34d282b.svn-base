//
//  SetAdminMemberListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetAdminMemberListViewController.h"
#import "SetAdminMemberCellTableViewCell.h"
#import "ClassFilterViewController.h"
#import "FRNetPoolUtils.h"
#import "UIImageView+WebCache.h"
#import "MyTabBarController.h"

@interface SetAdminMemberListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetAdminMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MyTabBarController setTabBarHidden:YES];
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"管理员设置"];
//    [self setCustomizeRightButton:@"icon_sxbj.png"];
    [self setCustomizeRightButtonWithName:@"筛选"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"updateAdminMemberList"
                                               object:nil];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"1" forKey:@"teacherTypeForFilter"];
    
//    if (_refreshHeaderView && [_refreshHeaderView superview]) {
//        [_refreshHeaderView removeFromSuperview];
//    }
//    
//    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
//                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
//                                     self.view.frame.size.width, self.view.bounds.size.height)];
//    _refreshHeaderView.delegate = self;
//    
//    [_tableView addSubview:_refreshHeaderView];
    
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc]init];
     [self getData:@"1" index:@"0"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    NSString *typeFlag = [userdefaults objectForKey:@"teacherTypeForFilter"];
//    [self getData:typeFlag index:@"0"];
    
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
    //---add 2015.06.24---------------------------------------------------
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *typeFlag = [userdefaults objectForKey:@"teacherTypeForFilter"];
    if ([typeFlag integerValue] == 1) {
        [ReportObject event:ID_OPEN_THIS_CLASS_TEACHER_LIST];
    }else if ([typeFlag integerValue] == -1){
        [ReportObject event:ID_OPEN_OTHER_CLASS_TEACHER_LIST];
    }
    //---------------------------------------------------------------------
}

-(void)updateUI{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *typeFlag = [userdefaults objectForKey:@"teacherTypeForFilter"];
    [self getData:typeFlag index:@"0"];
    
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;

}

// 2016.03.16
-(void)refreshFilter:(NSString*)typeFlag{
    
    [self getData:typeFlag index:@"0"];
    
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
}

// 获取数据从server
-(void)getData:(NSString*)flag index:(NSString*)startIndex{
    
   // [_refreshHeaderView refreshLastUpdatedDate];

    [Utilities showProcessingHud:self.view];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSMutableDictionary *dic = [FRNetPoolUtils getTeachers:_cId role:@"" page:startIndex size:@"1000"];
        NSMutableArray *allArray = [dic objectForKey:@"list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if ([listArray count] == 0) {
                if (![Utilities isConnected]) {//2015.06.30
                    UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
                    [self.view addSubview:noNetworkV];
                    
                }
            }
            
            if (dic == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }else{
                
                _tableView.hidden = NO;
                NSMutableArray *array = [[NSMutableArray alloc] init];
                if ([allArray count] > 0) {
                    
                    for (int i = 0; i<[allArray count]; i++) {
                        
                        NSDictionary *dic = [allArray objectAtIndex:i];
                        NSString *grade = [dic objectForKey:@"grade"];
                        
                        if ([flag isEqualToString:@"-1"]) {
                            if ([grade isEqualToString:@"-1"]) {// 非本班老师
                                [array addObject:[allArray objectAtIndex:i]];
                            }else{// 本班老师
                                
                            }
                        }else if ([flag isEqualToString:@"1"]){
                            if ([grade isEqualToString:@"-1"]) {// 非本班老师
                                
                            }else{// 本班老师
                                 [array addObject:[allArray objectAtIndex:i]];
                            }
                        }
                        
                    }
                
                if ([array count] > 0 ) {
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];

                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                }
                
            }
            
            
        });
    });
    
}

////刷新调用的方法
//-(void)refreshView
//{
//    isReflashViewType = 1;
//    
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    NSString *typeFlag = [userdefaults objectForKey:@"teacherTypeForFilter"];
//    
//    if (reflashFlag == 1) {
//        NSLog(@"刷新完成");
//        startNum = @"0";
//        [self getData:typeFlag index:startNum];
//        
//    }
//}
//
////加载调用的方法
//-(void)getNextPageView
//{
//    isReflashViewType = 0;
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    NSString *typeFlag = [userdefaults objectForKey:@"teacherTypeForFilter"];
//    
//    if (reflashFlag == 1) {
//        
//        startNum = [NSString stringWithFormat:@"%d",[listArray count]];
//        [self getData:typeFlag index:startNum];
//        
//    }
//    
//    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
//    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
//    
//    
//}
//
//-(void)testFinishedLoadData{
//    
//    [self finishReloadingData];
//    [self setFooterView];
//    
//}



// 返回
-(void)selectLeftAction:(id)sender{
    
    reflashFlag = 0;
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

// 进入成员筛选列表
-(void)selectRightAction:(id)sender{
    
//    ClassFilterViewController *classFilterV = [[ClassFilterViewController alloc]init];
//    classFilterV.fromName = @"selectTeacherType";
//    [self.navigationController pushViewController:classFilterV animated:YES];
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"本班老师",@"name",@"1",@"userTypeForFilter", nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"非本班老师",@"name",@"-1",@"userTypeForFilter", nil];
   
    tagArray = [[NSMutableArray alloc] initWithObjects:dic0,dic1, nil];
    
    
    if (!isRightButtonClicked) {
        
        
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                          5,
                                                                          128,
                                                                          35.0*[tagArray count]+10)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        
        if ([tagArray count] < 2) {
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_one.png"]];
        }else{
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_more.png"]];
        }
        
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        for (int i=0; i<[tagArray count]; i++) {
            
            NSDictionary *tagDic = [tagArray objectAtIndex:i];
            //NSString *tagId = [NSString stringWithFormat:@"%@",[tagDic objectForKey:@"userTypeForFilter"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 600+i;
            button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+9+35.0*i, 128.0, 35.0);
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateNormal];
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            
            [button addTarget:self action:@selector(selectTag:) forControlEvents: UIControlEventTouchUpInside];
            
            UIImageView *lineV = [[UIImageView alloc] init];
            lineV.image = [UIImage imageNamed:@"ClassKin/bg_contacts_line.png"];
            lineV.frame = CGRectMake(10, button.frame.size.height-1, button.frame.size.width-20, 1);
            if (i<[tagArray count]-1) {
                [button addSubview:lineV];
            }
            
            [imageView_bgMask addSubview:button];
            
        }
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
        
        
    }else{
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
    
}

// 标签筛选
-(void)selectTag:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    NSInteger i = button.tag - 600;
    
    [self dismissKeyboard:nil];
    
    NSString *typeId = [[tagArray objectAtIndex:i] objectForKey:@"userTypeForFilter"];
    //全部：-1 老师：7 家长：6
    
    [self refreshFilter:typeId];
    
}


-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}


-(void)reload{
    
    [_tableView reloadData];
    
}

// cell回调方法
-(void)setAdmin:(NSString*)userIDIndex{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *roleType = [[listArray objectAtIndex:[userIDIndex intValue]] objectForKey:@"grade"];
        NSString *type = @"1";
        if([roleType isEqualToString:@"-1"]){
            type = @"1";//设为管理
            [ReportObject event:ID_SET_CLASS_MASTER];//2015.06.24
        }else if([roleType isEqualToString:@"0"]){
             type = @"1";//设为管理
            [ReportObject event:ID_SET_CLASS_MASTER];//2015.06.24
        }else if([roleType isEqualToString:@"9"]){
             type = @"2";//取消管理
            [ReportObject event:ID_UNSET_CLASS_MASTER];//2015.06.24
        }
        NSString *oUid = [[listArray objectAtIndex:[userIDIndex intValue]] objectForKey:@"uid"];
        NSString *message = [FRNetPoolUtils setAdmin:_cId oUid:oUid type:type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (message!= nil) {
                
                [Utilities showAlert:@"错误" message:message cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSString *grade = @"9";
                if([type intValue] == 1){// 设为管理成功
                    grade = @"9";
                }else if ([type intValue] == 2){// 取消管理成功
                    grade = @"0";
                }
                
                if (nil != _msgCenterMid) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _msgCenterMid, @"mid",
                                         @"admin_class_charge", @"msg",
                                         nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
                }
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 [[listArray objectAtIndex:[userIDIndex intValue]] objectForKey:@"uid"], @"uid",[[listArray objectAtIndex:[userIDIndex intValue]] objectForKey:@"name"],@"name",grade,@"grade",[[listArray objectAtIndex:[userIDIndex intValue]] objectForKey:@"avatar"],@"avatar",nil];
                                            
                
                [listArray replaceObjectAtIndex:[userIDIndex intValue] withObject:dic];
                
               // [[listArray objectAtIndex:[userIDIndex intValue]] setObject:@"9" forKey:@"grade"];
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }
        });
    });
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
    static NSString *CellTableIdentifier = @"SetAdminMemberCellTableViewCell";
    
    SetAdminMemberCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
       
        UINib *nib = [UINib nibWithNibName:@"SetAdminMemberCellTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
    }
   
    cell.delegte = self;
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"bg_photo"]];
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *roleType = [[listArray objectAtIndex:indexPath.row] objectForKey:@"grade"];
    if([roleType isEqualToString:@"-1"]){
        cell.userTypeLabel.text = @"未加入";
        [cell.setAdminBtn setTitle:@"设为管理" forState:UIControlStateNormal];
        //[cell.ButtonTitleImgV setImage:[UIImage imageNamed:@"icon_szgl_ScAdmin.png"]];

        
    }else if([roleType isEqualToString:@"0"]){
        
        cell.userTypeLabel.text = @"成员";
        [cell.setAdminBtn setTitle:@"设为管理" forState:UIControlStateNormal];
        //[cell.ButtonTitleImgV setImage:[UIImage imageNamed:@"icon_szgl_ScAdmin.png"]];
        
    }else if([roleType isEqualToString:@"9"]){
        cell.userTypeLabel.text = @"本班管理";
        [cell.setAdminBtn setTitle:@"取消管理" forState:UIControlStateNormal];
        //[cell.ButtonTitleImgV setImage:[UIImage imageNamed:@"icon_qxgl_ScAdmin.png"]];

    }
    
    [cell.setAdminBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/big_btnBg_normal.png"] forState:UIControlStateNormal];
    [cell.setAdminBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/big_btnBg_press.png"] forState:UIControlStateHighlighted];

    cell.headImgView.layer.masksToBounds = YES;
    cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    cell.index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
    
}


//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
//    ClassFilterViewController *classFilterV = [[ClassFilterViewController alloc]init];
//    classFilterV.fromName = @"teacherTypeForFilter";
//    [self.navigationController pushViewController:classFilterV animated:YES];
    
}




//#pragma mark -
//#pragma mark method that should be called when the refreshing is finished
//- (void)finishReloadingData{
//    
//    //  model should call this when its done loading
//    _reloading = NO;
//    
//    if (_refreshHeaderView) {
//        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
//    }
//    
//    if (_refreshFooterView) {
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
//        [self setFooterView];
//    }
//    
//    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
//}
//
//-(void)setFooterView{
//    //    UIEdgeInsets test = self.aoView.contentInset;
//    // if the footerView is nil, then create it, reset the position of the footer
//    
//    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
//    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
//    if (_refreshFooterView && [_refreshFooterView superview])
//    {
//        // reset position
//        _refreshFooterView.frame = CGRectMake(0.0f,
//                                              height,
//                                              self->_tableView.frame.size.width,
//                                              self.view.bounds.size.height);
//    }else
//    {
//        // create the footerView
//        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
//                              CGRectMake(0.0f, height,
//                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
//        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
//        _refreshFooterView.delegate = self;
//        [self->_tableView addSubview:_refreshFooterView];
//    }
//    
//    if (_refreshFooterView)
//    {
//        [_refreshFooterView refreshLastUpdatedDate];
//    }
//}
//
//-(void)removeFooterView
//{
//    if (_refreshFooterView && [_refreshFooterView superview])
//    {
//        [_refreshFooterView removeFromSuperview];
//    }
//    _refreshFooterView = nil;
//}

//===============
//刷新delegate
//#pragma mark -
//#pragma mark data reloading methods that must be overide by the subclass
//-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
//    
//    //  should be calling your tableviews data source model to reload
//    _reloading = YES;
//    
//    if (aRefreshPos == EGORefreshHeader)
//    {
//        // pull down to refresh data
//        //[self refreshView];
//        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
//    }else if(aRefreshPos == EGORefreshFooter)
//    {
//        // pull up to load more data
//        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
//    }
//    
//    // overide, the actual loading data operation is done in the subclass
//}
//
//#pragma mark -
//#pragma mark UIScrollViewDelegate Methods
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (_reloading == NO) {
//        if (_refreshHeaderView)
//        {
//            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//        }
//        
//        if (_refreshFooterView)
//        {
//            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (_reloading == NO) {
//        if (_refreshHeaderView)
//        {
//            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//        }
//        
//        if (_refreshFooterView)
//        {
//            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
//        }
//    }
//}

//#pragma mark -
//#pragma mark EGORefreshTableDelegate Methods
//- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
//{
//    if (_reloading == NO) {
//        [self beginToReloadData:aRefreshPos];
//    }
//}
//
//- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
//{
//    return _reloading; // should return if data source model is reloading
//}
//
//// if we don't realize this method, it won't display the refresh timestamp
//- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
//{
//    return [NSDate date]; // should return date data source was last changed
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

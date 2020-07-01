//
//  EduinspectorViewController.m
//  MicroSchool
//
//  Created by jojo on 14-8-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduinspectorViewController.h"
#import "ToReplyListViewController.h"
#import "AnswerQuestionViewController.h"
#import "InfoCenterForInspectorViewController.h"

@interface EduinspectorViewController ()

@end

@implementation EduinspectorViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        eduInsModuleBtnArr = [[NSMutableArray alloc] init];
        eduInspectorsArr = [[NSMutableArray alloc] init];
        eduInterractionsArr = [[NSMutableArray alloc] init];

        questionArr =[[NSMutableArray alloc] init];
        
        startNum = @"0";
        endNum = @"10";

        isFirst = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    

    [Utilities showProcessingHud:self.view];//2015.05.12

    
    isRightButtonClicked = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshEduinspectorInfo"
                                               object:nil];
    
    [ReportObject event:ID_OPEN_EDU];//2015.06.24
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self dismissMask:nil];
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
#if 0
    CGRect rect;
    // 设置背景scrollView
    if (iPhone5)
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 45 );
    }
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    NSLog(@"height:%f",_scrollerView.frame.size.height);
    
    if (iPhone5)
    {
        _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height);
    }
    else
    {
        _scrollerView.contentSize = CGSizeMake(WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    //    _scrollerView.bounces = YES;
    //    _scrollerView.alwaysBounceHorizontal = NO;
    //    _scrollerView.alwaysBounceVertical = YES;
    //    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
#endif
    
    // 督学人下面的线
    imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(20,120,280,1)];
    [imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [imgView_line setTag:999];
    imgView_line.hidden = NO;
    [self.view addSubview:imgView_line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imgView_line.frame.origin.y+2, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 - imgView_line.frame.origin.y - 10) style:UITableViewStylePlain];
    
    //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //
    //    _tableView.backgroundView = imgView_bg;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
//    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableView.tableFooterView = [[UIView alloc] init]; 
    
    [self.view addSubview:_tableView];
    
    //----add by kate 2014.10.21---------------------------------------------
    nodataView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    UILabel *nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 64)/2.0 - 40, [[UIScreen mainScreen] bounds].size.width, 40)];
    nodataLabel.text = @"本校暂无督学人";
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    [nodataView addSubview:nodataLabel];
    nodataView.hidden = YES;
    [self.view addSubview:nodataView];
    //-----------------------------------------------------------------------
    
    

    // 获取督学相关信息
    [self doGetEduInsInfo];
}

-(void)doGetEduInsInfo
{
    // 获取督学首页
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"interractions", @"op",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorInterractions andData:data];
}

-(void)doShowInspectors
{
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];

    scrollViewIns = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];

    scrollViewIns.pagingEnabled = YES; //是否分页
    scrollViewIns.contentSize = CGSizeMake(WIDTH*[eduInspectorsArr count], 110);
    scrollViewIns.showsHorizontalScrollIndicator = NO;
    scrollViewIns.showsVerticalScrollIndicator = NO;
    scrollViewIns.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    scrollViewIns.delegate = self;
    scrollViewIns.bounces = NO;
    [self.view addSubview:scrollViewIns];

    for (int i=0; i<[eduInspectorsArr count]; i++) {
        UIView *view = [[UIView alloc] init];
        //如果要触发事件，必须设置为yes
        view.userInteractionEnabled = YES;
        view.contentMode = UIViewContentModeScaleToFill;
        view.frame = CGRectMake(WIDTH*i, 0, WIDTH, 110);
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [view addGestureRecognizer:singleTouch];
        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        
        //NSLog(@"url:%@",[[eduInspectorsArr objectAtIndex:i] objectForKey:@"photo"]);
        
        // 缩略图
        UIImageView *imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(40,10,100,100)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        [imgView_thumb sd_setImageWithURL:[NSURL URLWithString:[[eduInspectorsArr objectAtIndex:i] objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        [view addSubview:imgView_thumb];

        // 姓名
        UILabel *label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 15,
                                                                  imgView_thumb.frame.origin.y + 15,
                                                                  200,
                                                                  20)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:15.0f];
        label_name.text = [NSString stringWithFormat:@"姓名：%@", [[eduInspectorsArr objectAtIndex:i] objectForKey:@"name"]];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.backgroundColor = [UIColor clearColor];
        label_name.textColor = [UIColor blackColor];
        [view addSubview:label_name];

        // 职务
        UILabel *label_zhiwu = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                        imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 15,
                                                                        label_name.frame.origin.y + label_name.frame.size.height + 10 -5,
                                                                        200,
                                                                        20)];
        //设置title自适应对齐
        label_zhiwu.lineBreakMode = NSLineBreakByWordWrapping;
        label_zhiwu.font = [UIFont systemFontOfSize:15.0f];
        label_zhiwu.text = [NSString stringWithFormat:@"职务：%@", [[eduInspectorsArr objectAtIndex:i] objectForKey:@"job"]];
        label_zhiwu.lineBreakMode = NSLineBreakByTruncatingTail;
        label_zhiwu.textAlignment = NSTextAlignmentLeft;
        label_zhiwu.backgroundColor = [UIColor clearColor];
        label_zhiwu.textColor = [UIColor blackColor];
        [view addSubview:label_zhiwu];

        // 单位
        UILabel *label_danwei = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 15,
                                                                          label_zhiwu.frame.origin.y + label_zhiwu.frame.size.height + 10 -5,
                                                                         150,
                                                                         20)];
        //设置title自适应对齐
        label_danwei.lineBreakMode = NSLineBreakByWordWrapping;
        label_danwei.font = [UIFont systemFontOfSize:15.0f];
        label_danwei.text = [NSString stringWithFormat:@"单位：%@", [[eduInspectorsArr objectAtIndex:i] objectForKey:@"company"]];
        label_danwei.lineBreakMode = NSLineBreakByTruncatingTail;
        label_danwei.textAlignment = NSTextAlignmentLeft;
        label_danwei.backgroundColor = [UIColor clearColor];
        label_danwei.textColor = [UIColor blackColor];
        [view addSubview:label_danwei];

        [scrollViewIns addSubview:view];
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 102, WIDTH, 20)];
    pageControl.numberOfPages = [eduInspectorsArr count];
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
}

-(void)dismissKeyboard:(id)sender{
    NSLog(@"select %@", [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"]);
    NSLog(@"uid %@", [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"]);

    EduinspectorDetailViewController *insViewCtrl = [[EduinspectorDetailViewController alloc] init];
    insViewCtrl.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
    [self.navigationController pushViewController:insViewCtrl animated:YES];

}

-(void)dismissMask:(id)sender{
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算分页的索引
    float x = scrollView.contentOffset.x;
//    NSLog(@"x---------------------:%f",x);
    int indexPage = x /320;
//    NSLog(@"select %d", indexPage);
    pageControl.currentPage = indexPage;
    
    selectInspector = indexPage;
}

-(void)doShowInfo
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    btnStartYPos = 0;
    questionPos = 0;

    // 督学模块 如果有的话
    for (int i=0; i<[eduInsModuleBtnArr count]; i++) {
        // 模块button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (0 == i) {
            btn.frame = CGRectMake(10, btnStartYPos + 10, 140, 40);
            if (1 == [eduInsModuleBtnArr count]) {
                btn.frame = CGRectMake(10, btnStartYPos + 10, 300, 40);
            }
            questionPos += 40 + 10;
        } else if (1 == i) {
            btn.frame = CGRectMake(10 + 140 + 20, btnStartYPos + 10, 140, 40);
        } else if (2 == i) {
            btn.frame = CGRectMake(10, btnStartYPos + 10 + 40 + 10, 140, 40);
            if (3 == [eduInsModuleBtnArr count]) {
                btn.frame = CGRectMake(10, btnStartYPos + 10 + 40 + 10, 300, 40);
            }
            questionPos += 40 + 10;
        } else if (3 == i) {
            btn.frame = CGRectMake(10 + 140 + 20, btnStartYPos + 10 + 40 + 10, 140, 40);
            
            UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
            btnMore.frame = CGRectMake(0, btnStartYPos + 10 + 40 + 10 + 40 + 10+10, WIDTH, 40);
            
            btnMore.tag = 99;
            btnMore.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            // 设置title自适应对齐
            btnMore.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            // 设置颜色和字体
            [btnMore setTitleColor:[[UIColor alloc] initWithRed:97/255.0f green:179/255.0f blue:250/255.0f alpha:1.0] forState:UIControlStateNormal];
            [btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            btnMore.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            
            [btnMore setBackgroundImage:[Utilities imageWithColor:[[UIColor alloc] initWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0] andSize:CGSizeMake(WIDTH, 30)] forState:UIControlStateNormal] ;
            [btnMore setBackgroundImage:[Utilities imageWithColor:[[UIColor alloc] initWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0] andSize:CGSizeMake(WIDTH, 30)] forState:UIControlStateHighlighted];
            // 221 238
            // 添加 action
            [btnMore addTarget:self action:@selector(eduInsModuleMore_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            
            //设置title
            [btnMore setTitle:@"更多" forState:UIControlStateNormal];
            [btnMore setTitle:@"更多" forState:UIControlStateHighlighted];
            
            [headerView addSubview:btnMore];

            questionPos += 40 + 10;
        } else {
            break;
        }
        
        btn.tag = i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置title自适应对齐
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // 设置颜色和字体
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
        
        // 添加 action
        [btn addTarget:self action:@selector(eduInsModule_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        //设置title
        [btn setTitle:[[eduInsModuleBtnArr objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateNormal];
        [btn setTitle:[[eduInsModuleBtnArr objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateHighlighted];
        
        [headerView addSubview:btn];
    }
    
    UIButton *btnQusetion = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQusetion.frame = CGRectMake(40, questionPos + 10, 240, 40);
    
    btnQusetion.tag = 999;
    btnQusetion.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    btnQusetion.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [btnQusetion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQusetion setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btnQusetion.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [btnQusetion setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [btnQusetion setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [btnQusetion addTarget:self action:@selector(eduInsQuiz_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [btnQusetion setTitle:@"我要提问" forState:UIControlStateNormal];
    [btnQusetion setTitle:@"我要提问" forState:UIControlStateHighlighted];
    
    //---update by kate 2014.10.21------------------------------------------------------------
    NSDictionary *user_info = [g_userInfo getUserDetailInfo];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    
    if([role_id intValue] == 2){// 督学身份
        
        headerView.frame = CGRectMake(0,
                                      0,
                                      WIDTH,
                                      btnQusetion.frame.origin.y - 5);
        [self setCustomizeRightButton:@"icon_more.png"];
        
    }else{// 非督学身份
        
        [headerView addSubview:btnQusetion];
        headerView.frame = CGRectMake(0,
                                      0,
                                      WIDTH,
                                      btnQusetion.frame.origin.y+40+10);
        
    }
    
    

    //-----------------------------------------------------------------------------------------
    
    _tableView.tableHeaderView = headerView;
}

// update by kate 2014.10.21

-(void)selectRightAction:(id)sender
{
//    NSDictionary *user = [g_userInfo getUserDetailInfo];
//    // 课表
//    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        //UIView * mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        //mask.backgroundColor =[UIColor clearColor];
        //mask.opaque = NO;
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMask:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        

            
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                              5,
                                                                              128,
                                                                              44*2)];
            imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
            [imageView_rightMenu setImage:[UIImage imageNamed:@"bg_contacts_single.png"]];
        
        
        
        
        // 搜索button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x,
                                         imageView_rightMenu.frame.origin.y + 18,
                                         108,
                                         32);
        
        UIImage *buttonImg_d;
        UIImage *buttonImg_p;
        
        //CGSize tagSize = CGSizeMake(20, 20);
        buttonImg_d = [UIImage imageNamed:@"icon_bjzl_d_inspector.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_bjzl_p_inspector.png"];
        
        [button_search setImage:buttonImg_d forState:UIControlStateNormal];
        [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_search setTitle:@"编辑资料" forState:UIControlStateNormal];
        [button_search setTitle:@"编辑资料" forState:UIControlStateHighlighted];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 44+6, 128-20, 1)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"friend/bg_contacts_more_line.png"]];
        [imageView_rightMenu addSubview:view];
        
        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_search setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_search addTarget:self action:@selector(gotoEdit) forControlEvents: UIControlEventTouchUpInside];
        
        // 管理成员button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x,
                                            button_search.frame.origin.y + button_search.frame.size.height,
                                            108,
                                            32);
        
        buttonImg_d = [UIImage imageNamed:@"icon_answer_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_answer_p.png"];
        
        [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_multiSend setTitle:@"解答问题" forState:UIControlStateNormal];
        [button_multiSend setTitle:@"解答问题" forState:UIControlStateHighlighted];
        
        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_multiSend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_multiSend addTarget:self action:@selector(gotoAnswer) forControlEvents: UIControlEventTouchUpInside];
        
        
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        [imageView_bgMask addSubview:button_search];
        [imageView_bgMask addSubview:button_multiSend];
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
}

// 去编辑个人资料页
-(void)gotoEdit{
    
    InfoCenterForInspectorViewController *infoCenterV = [[InfoCenterForInspectorViewController alloc]init];
    infoCenterV.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
    [self.navigationController pushViewController:infoCenterV animated:YES];
}

// 去待回复问题列表页
-(void)gotoAnswer{
    
    ToReplyListViewController *toReplyListV = [[ToReplyListViewController alloc]init];
    [self.navigationController pushViewController:toReplyListV animated:YES];
    
}

- (IBAction)eduInsModule_btnclick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    EduModuleDetailViewController *detailViewCtrl = [[EduModuleDetailViewController alloc] init];
    detailViewCtrl.detailInfo = [[eduInsModuleBtnArr objectAtIndex:btn.tag] objectForKey:@"message"];
    detailViewCtrl.titlea = [[eduInsModuleBtnArr objectAtIndex:btn.tag] objectForKey:@"title"];
    [self.navigationController pushViewController:detailViewCtrl animated:YES];
}

- (IBAction)eduInsModuleMore_btnclick:(id)sender
{
    EduModuleListViewController *listViewCtrl = [[EduModuleListViewController alloc] init];
    listViewCtrl.eduInsModuleList = eduInsModuleBtnArr;
    [self.navigationController pushViewController:listViewCtrl animated:YES];
}

- (IBAction)eduInsQuiz_btnclick:(id)sender
{
    NSDictionary *user_info = [g_userInfo getUserDetailInfo];

    NSString *role_id = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];

    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
    /*2015.10.29 教育局改版
     if ([schoolType isEqualToString:@"bureau"]) {
        EduQuizViewController *quizViewCtrl = [[EduQuizViewController alloc] init];
        //    listViewCtrl.eduInsModuleList = eduInsModuleBtnArr;
        quizViewCtrl.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
        [self.navigationController pushViewController:quizViewCtrl animated:YES];
    }else {*/
        if([@"7"  isEqual: role_id]) {
            if ([@"1"  isEqual: role_checked]) {
                EduQuizViewController *quizViewCtrl = [[EduQuizViewController alloc] init];
                //    listViewCtrl.eduInsModuleList = eduInsModuleBtnArr;
                quizViewCtrl.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
                [self.navigationController pushViewController:quizViewCtrl animated:YES];
            }else if([@"2"  isEqual: role_checked]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"您还未获得教师身份，请递交申请."
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
            }else if([@"0"  isEqual: role_checked]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"请耐心等待审批."
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }else if([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]) {// 督学身份 相当于审批通过的老师
            
            EduQuizViewController *quizViewCtrl = [[EduQuizViewController alloc] init];
            //    listViewCtrl.eduInsModuleList = eduInsModuleBtnArr;
            quizViewCtrl.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
            [self.navigationController pushViewController:quizViewCtrl animated:YES];
            
        }
        else {
            if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                
                NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
                NSString *msg = @"请先加入一个班级";
                if ([@"bureau" isEqualToString:schoolType]) {
                    msg = @"请先加入一个部门";
                }
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:msg
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
                [alert show];
            }else {
                EduQuizViewController *quizViewCtrl = [[EduQuizViewController alloc] init];
                //    listViewCtrl.eduInsModuleList = eduInsModuleBtnArr;
                quizViewCtrl.insUid = [[eduInspectorsArr objectAtIndex:selectInspector] objectForKey:@"uid"];
                [self.navigationController pushViewController:quizViewCtrl animated:YES];
            }
        }
    //}
    
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eduInterractionsArr count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [newsArray count];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    NSUInteger row = [indexPath row];
    
    NSDictionary* list_dic = [eduInterractionsArr objectAtIndex:row];
    
    NSString *message= [list_dic objectForKey:@"message"];
    
    EduQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[EduQuestionTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //        cell.backgroundView.frame = CGRectMake(9, 0, 302, 100);
    //        cell.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 100);
    
    cell.label_content.text = message;
    
    CGSize strSize = [Utilities getStringHeight:cell.label_content.text andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake(300, 0)];

    cell.label_content.frame = CGRectMake(10,
                                          10,
                                          300,
                                          strSize.height);

    // 时间
    NSString *updatetime = [list_dic objectForKey:@"updatetime"];
    NSString *dateline = [[Utilities alloc] linuxDateToString:updatetime andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
    cell.label_time.text = dateline;
    cell.label_time.frame = CGRectMake(10,
                                       cell.label_content.frame.origin.y + cell.label_content.frame.size.height + 10,
                                       100,
                                       20);

    // 已回答
    cell.label_ans.text = @"已回答";
    cell.label_ans.frame = CGRectMake(260,
                                       cell.label_content.frame.origin.y + cell.label_content.frame.size.height + 10,
                                       100,
                                       20);

    CGRect rect = cell.frame;
//    rect.size.height = (10 +
//                        requiredSizeMessage.height +
//                        cell.label_time.frame.size.height +
//                        15);
    rect.size.height = (10 +
                        strSize.height +
                        cell.label_time.frame.size.height +
                        15);

    cell.frame = rect;

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *dic = [eduInterractionsArr objectAtIndex:indexPath.row];
    
    EduQuesDetailViewController *eduDetailViewCtrl = [[EduQuesDetailViewController alloc] init];
    eduDetailViewCtrl.quesDic = dic;
    [self.navigationController pushViewController:eduDetailViewCtrl animated:YES];

//    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:_titleName];
//    
//    NSLog(@"askljlsjdf %ld", (long)indexPath.row);
//    
//    newsDetailViewCtrl.newsid = [newsidList objectAtIndex:indexPath.row];
//    newsDetailViewCtrl.newsDate = [newsDateList objectAtIndex:indexPath.row];
//    
//    [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
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
    
    // 获取督学button模块
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"information", @"op",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorInformation andData:data];
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
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
//    isReflashViewType = 1;
//    
//    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
//        [newsArray removeAllObjects];
//        [newsidList removeAllObjects];
//        [newsDateList removeAllObjects];
    
    // 获取督学首页
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"interractions", @"op",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorInterractions andData:data];
    
}


//加载调用的方法
-(void)getNextPageView
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"interractions", @"op",
                          startNum, @"page",
                          endNum, @"size",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorInterractions andData:data];
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
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString *protocol = [resultJSON objectForKey:@"protocol"];
    
    if ([@"EduinspectorAction.information" isEqual: protocol]) {
        if(true == [result intValue])
        {
//            eduInsModuleBtnArr = [resultJSON objectForKey:@"message"];
            NSArray *message = [resultJSON objectForKey:@"message"];
            
            if ([message count] > 0) {
                
                nodataView.hidden = YES;
                _tableView.hidden = NO;
                imgView_line.hidden = NO;
                
                [eduInsModuleBtnArr removeAllObjects];
                
                for (NSObject *object in message)
                {
                    [eduInsModuleBtnArr addObject:object];
                }
                
                // temp
//                [self createHeaderView];
                
            }else{
                
//                nodataView.hidden = NO;
//                _tableView.hidden = YES;
//                imgView_line.hidden = YES;
                
            }
            [self doShowInfo];

            //刷新表格内容
            [_tableView reloadData];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];


//            //刷新表格内容
//            [_tableView reloadData];
//            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        }
        else
        {
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取督学信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if([@"EduinspectorAction.profile" isEqual: protocol]) {
        if(true == [result intValue])
        {
            eduInsModuleBtnArr = [resultJSON objectForKey:@"message"];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取督学信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if([@"EduinspectorAction.interractions" isEqual: protocol]) {
        // 督学首页信息
        if(true == [result intValue])
        {
            NSDictionary *dic = [resultJSON objectForKey:@"message"];
            
//            eduInspectorsArr = [dic objectForKey:@"inspectors"];
//            eduInterractionsArr = [[dic objectForKey:@"interractions"] objectForKey:@"list"];

            NSArray *interractions = [[dic objectForKey:@"interractions"] objectForKey:@"list"];
            NSArray *inspectors = [dic objectForKey:@"inspectors"];// 督学人信息
            
            //------update by kate 2014.10.21-----------------------------------------------
            // 加入if判断 如果没有督学人则显示“本校暂无督学人”
            
            if ([inspectors count] == 0) {
                
                nodataView.hidden = NO;
                _tableView.hidden = YES;
                imgView_line.hidden = YES;
                
            }else{
                

                nodataView.hidden = YES;
                _tableView.hidden = NO;
                imgView_line.hidden = NO;
                
                if ([@"0"  isEqual: startNum]) {
                    [eduInspectorsArr removeAllObjects];
                    [eduInterractionsArr removeAllObjects];
                }
                
                for (NSObject *object in interractions)
                {
                    [eduInterractionsArr addObject:object];
                }
                for (NSObject *object in inspectors)
                {
                    [eduInspectorsArr addObject:object];
                }
                
                startNum = [NSString stringWithFormat:@"%d",(startNum.integerValue + 10)];
                
                // 只有第一次进入view时候去刷新督学人
                //if (isFirst) {// update by kate 2014.11.12
                    [self doShowInspectors];
                //}
                //isFirst = NO;
                
//                //刷新表格内容
//                [_tableView reloadData];
//                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                
//                [self doShowInfo];

                [self createHeaderView];

            }
            //--------------------------------------------------------------------------------------
            
        }
        else
        {
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取督学信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end

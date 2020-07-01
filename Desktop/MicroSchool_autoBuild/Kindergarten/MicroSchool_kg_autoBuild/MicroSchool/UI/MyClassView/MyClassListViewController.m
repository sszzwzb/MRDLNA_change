//
//  MyClassListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyClassListViewController.h"
#import "ClassListViewController.h"
#import "FRNetPoolUtils.h"
#import "MyClassListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ClassMainNoHomeworkViewController.h"
#import "ClassMainNoScheduleViewController.h"
#import "ClassMainViewController.h"
#import "ClassMainViewController2.h"
//#import "ClassMainViewNewViewController.h"
#import "ClassDetailViewController.h"
#import "MyTabBarController.h"
#import "MicroSchoolAppDelegate.h"

#import "SetPersonalViewController.h"
#import "MyClassDetailViewController.h"
#import "MyPointsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "GrowthNotValidateViewController.h"
#import "ChildViewController.h"
#import "ParenthoodListForParentTableViewController.h"

#import "ChildrenViewController.h"
#import "AddClassApplyViewController.h"
#import "SwitchChildViewController.h"
#import "GrowVIPViewController.h"
@interface MyClassListViewController (){
    NSString *str;
    NSString *strNum;
    NSString *joinNum;
    
    TSTapGestureRecognizer *myTapGesture7;

}
@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *noDataImgV;

@end

@implementation MyClassListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkNewsIcon:)
                                                     name:@"reLoadMyClassListNews"
                                                   object:nil];// 2015.11.12
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake((107.0-25)/2.0+20, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];//tab上的红点
        noticeImgVForMsg.tag = 123;//
        
        newsDic = [[NSDictionary alloc] init];
        
    }
    return self;
}
//#3.20
-(void)selectLeftAction:(id)sender{
    myTapGesture7 = (TSTapGestureRecognizer *)sender;
//#3.31 此处为解决左划时产生错位的问题。代码拿掉了原来在tab里通过代理控制leftorright，现在统一用通知在wws里控制，每次显示main以后，重置scalef为零。
    if ([@"0"  isEqual: myTapGesture7.infoStr]) {
        NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
        [choose setObject:@"2" forKey:@"CHOOSE"];
        myTapGesture7.infoStr = @"1";
         _maskView.hidden = NO;
        strNum =@"1";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else {
        myTapGesture7.infoStr = @"0";
        strNum =@"2";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
         _maskView.hidden = YES;
    }
}
-(void)goRight{
    strNum =@"2";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
//#4.1   在本页面点击左侧cell后，接受通知。根据num的值进行跳转。具体情况如下。
- (void)tongzhi:(NSNotification *)select{
    NSLog(@"%@",select.userInfo[@"num"]);
    NSLog(@"－－－－－接收到通知------");
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *userType = [user objectForKey:@"role_id"];
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    if ([select.userInfo[@"num"]isEqualToString:@"1"]) {//我的消息
        [self goRight];
        rt.pan.enabled = NO;
        MessageCenterViewController *vc = [[MessageCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"2"]){//我的动态
       [self goRight];
        MomentsViewController *momentsV = [[MomentsViewController alloc]init];
        momentsV.titleName = @"我的动态";
        momentsV.fromName = @"mine";
        rt.pan.enabled = NO;
        [self.navigationController pushViewController:momentsV animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"3"]){//我的积分
        [self goRight];
        if ([userType integerValue] == 7) {//教师
            [ReportObject event:ID_CLICK_MYPOINT_TEACHER];
        }else if ([userType integerValue] == 9){//管理员
            [ReportObject event:ID_CLICK_MYPOINT_ADMIN];
        }
        
        MyPointsViewController *myPoint = [[MyPointsViewController alloc]init];
        //        myPoint.titleName = name;
        myPoint.titleName = @"我的积分";
        rt.pan.enabled = NO;
        [self.navigationController pushViewController:myPoint animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"4"]){//学校二维码
        [self goRight];
        rt.pan.enabled = NO;
        SchoolQRCodeViewController *schoolQRVC = [[SchoolQRCodeViewController alloc] init];
        [self.navigationController pushViewController:schoolQRVC animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"5"]){//账号及隐私
        [self goRight];
        rt.pan.enabled = NO;
        AccountandPrivacyViewController *accountandprivacy = [[AccountandPrivacyViewController alloc]init];
        [self.navigationController pushViewController:accountandprivacy animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"6"]){//系统设置
        [self goRight];
        SettingViewController *settingView = [[SettingViewController alloc]init];
        settingView.isNewVersion = isNewVersion;
        rt.pan.enabled = NO;
        [self.navigationController pushViewController:settingView animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"7"]){//个人信息
        [self goRight];
        rt.pan.enabled = NO;
        SetPersonalInfoViewController *vc =[[SetPersonalInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"8"]){//成长空间
        [self goRight];
        rt.pan.enabled = NO;
        GrowthNotValidateViewController *growthnv = [[GrowthNotValidateViewController alloc]init];
        [self.navigationController pushViewController:growthnv animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"9"]){//我的二维码
        [self goRight];
        rt.pan.enabled = NO;
        MyQRCodeViewController *qrViewCtrl = [[MyQRCodeViewController alloc] init];
        [self.navigationController pushViewController:qrViewCtrl animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"10"]){//亲子关系绑定
        [self goRight];
        rt.pan.enabled = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ParentNew_Done"];
        if ([userType intValue] == 0) {
            ChildViewController *childV = [[ChildViewController alloc] init];
            [self.navigationController pushViewController:childV animated:YES];
        }else{
            ParenthoodListForParentTableViewController *parentListV = [[ParenthoodListForParentTableViewController alloc]init];
            [self.navigationController pushViewController:parentListV animated:YES];
        }
    }else if ([select.userInfo[@"num"]isEqualToString:@"11"]){//用户帮助
        [self goRight];
        rt.pan.enabled = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HelpNew_Done"];
        HelpViewController *helpV = [[HelpViewController alloc] init];
        [self.navigationController pushViewController:helpV animated:YES];
    }else if ([select.userInfo[@"num"]isEqualToString:@"12"]){//重新申请
        [self goRight];
        rt.pan.enabled = NO;
        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
        personalViewCtrl.iden = @"teacher";
        personalViewCtrl.viewType = @"chooseIden";
        personalViewCtrl.perNum = @"1";
        [self.navigationController pushViewController:personalViewCtrl animated:YES];
    }else if ([select.userInfo[@"num"]isEqualToString:@"13"]){//重新申请
        [self goRight];
        rt.pan.enabled = NO;
        SwitchChildViewController *vc = [[SwitchChildViewController alloc] init];
        vc.titleName = [NSString stringWithFormat:@"切换子女"];
        vc.viewType = @"switchChild";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([select.userInfo[@"num"]isEqualToString:@"14"]){//重新申请
        [self goRight];
        rt.pan.enabled = NO;
        GrowVIPViewController *vc = [[GrowVIPViewController alloc] init];
//        NSString *app = [Utilities getAppVersion];
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"Kindergarden", @"ac",
//                              @"3", @"v",
//                              @"classHome", @"op",
//                              _classId, @"cid",
//                              app,@"app",
//                              nil];
//        vc.innerLinkReqData = data;
        vc.VIPUrl = select.userInfo[@"payUrl"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@""];
    [self setCustomizeLeftButtonWithImage:@""];
    //#3.31
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"select" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi2" object:nil];
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    
    // 隐藏导航条底部的线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageViewa=(UIImageView *)obj;
                NSArray *list2=imageViewa.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    
    
//    if ((UserType_Student == [Utilities getUserType] || (UserType_Parent == [Utilities getUserType]))) {
        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 640)];
        
//        // 提示文字
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,80, WIDTH, 100)];
//
//       _tipsLabel.text = @"您还未加入班级，\n立即加入班级实时了解孩子信息。";
//
//        _tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _tipsLabel.font = [UIFont systemFontOfSize:18.0f];
//        _tipsLabel.numberOfLines = 0;
//        UIColor *testColor1= [UIColor grayColor];
//        
//        _tipsLabel.textColor = testColor1;
//        _tipsLabel.backgroundColor = [UIColor clearColor];
//        _tipsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _tipsLabel.textAlignment = NSTextAlignmentCenter;
//        [_tipsView addSubview:_tipsLabel];
    
        // 提示button
        _tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipsButton.frame = CGRectMake(20, _tipsLabel.frame.origin.y + _tipsLabel.frame.size.height +90, WIDTH-40, 40);
        _tipsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //设置title自适应对齐
        _tipsButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // 设置颜色和字体
        [_tipsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tipsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _tipsButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        
        [_tipsButton setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
        [_tipsButton setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
        
        // 添加 action
        [_tipsButton addTarget:self action:@selector(join_btnclick:) forControlEvents: UIControlEventTouchUpInside];

        //设置title
        [_tipsButton setTitle:@"加入班级" forState:UIControlStateNormal];
        [_tipsButton setTitle:@"加入班级" forState:UIControlStateHighlighted];
    
      CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49);
   
    noDataView = [Utilities showNodataView:@"再不加班级你就OUT啦~" msg2:@"" andRect:rect imgName:@"noClassBg.png" textColor:[UIColor grayColor] startY:70.0];
    
        [_tipsView addSubview:noDataView];

        [_tipsView addSubview:_tipsButton];
//    }
//    else {
//        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
//        _tipsView.backgroundColor = [UIColor whiteColor];
//        
//        noDataImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 275, 275)];
//        noDataImgV.image = [UIImage imageNamed:@"noDataViewforClass.png"];
//        
//        [_tipsView addSubview:noDataImgV];
//    }


    //[self setCustomizeLeftButton];
    winSize = [[UIScreen mainScreen] bounds].size;
    
    //_tableView.frame = CGRectMake(0, 0, winSize.width, winSize.height-49);
    _tableView.tableFooterView = [[UIView alloc]init];

    isAdmin = NO;
    
    //newListArray = [[NSMutableArray alloc]init];
    // refreshMyClassList
    
    //----add by kate---------------------------------------------------
    
    [_tableView addSubview:_tipsView];
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    //--------------------------------------------------------------------
    
//    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
//    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshMyClassList"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"reLoadMyClassList"
                                               object:nil];//update by kate 2014.12.30
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkNewsIcon:)
//                                                 name:@"reLoadMyClassListNews"
//                                               object:nil];// 2015.11.12
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnectedForMyClassList"
                                               object:nil];//2015.06.25
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAppliedAndChangeStatus:) name:@"zhixiao_myClassAppliedSuccessAndChangeStatus" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeAddNoTouchView:) name:@"schoolHomeAddNoTouchView" object:nil];

    noDataView.hidden = YES;
    _tipsView.hidden = YES;
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 640)];
    TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture1.infoStr = @"0";
    _maskView.hidden = YES;
    [_maskView addGestureRecognizer:myTapGesture1];
    [self.view addSubview:_maskView];

    [self getData];//update by kate 2014.12.30
   
}
-(void)img_btnclick:(id)sender{
    
    //    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    myTapGesture7.infoStr = @"0";
    //#3.31
    strNum =@"2";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    _maskView.hidden = YES;
    
}

- (void)schoolHomeAddNoTouchView:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    NSUInteger a = [[dic objectForKey:@"status"] integerValue];
    
    if (1 == a) {
        _maskView.hidden = NO;
        
    }else {
        _maskView.hidden = YES;
        
    }
    
}
-(void)classAppliedAndChangeStatus:(NSNotification *)notification
{
    [self getData];
//    NSDictionary *dic = [notification userInfo];
//    
//    NSString *name = [dic objectForKey:@"className"];
//    
//    _classId = [dic objectForKey:@"cId"];
//    
//    _tipsLabel.text = [NSString stringWithFormat:@"您已申请加入%@，\n请耐心等待班级管理员审核。", name];
//    
//    [_tipsButton setTitle:@"取消申请" forState:UIControlStateNormal];
//    [_tipsButton setTitle:@"取消申请" forState:UIControlStateHighlighted];
}

- (IBAction)join_btnclick:(id)sender
{
    joinNum = @"1";
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = NO;
    //老师
    if ((UserType_Student != [Utilities getUserType]) && (UserType_Parent != [Utilities getUserType])){
        
        [self selectRightAction:nil];
        
    }else{  //学生家长
        
        if (nil != _classId) {
            // 取消申请
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Class",@"ac",
                                  @"2",@"v",
                                  @"cancelApply", @"op",
                                  _classId, @"cid",
                                  _aid, @"aid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    _classId = nil;
                    
                    [self getData];
                    
                } else {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                   message:@"获取信息错误，请稍候再试"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
        }else {
            
            NSString *identity;
            
            if (UserType_Student == [Utilities getUserType]) {
                identity = @"student";
            }else if (UserType_Parent == [Utilities getUserType]) {
                identity = @"parent";
            }
#if 0
            SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
            personalViewCtrl.iden = identity;
            personalViewCtrl.viewType = @"classApply";
            [self.navigationController pushViewController:personalViewCtrl animated:YES];
#endif
            
            /**
             * 检查我的所有绑定记录
             * @args  v=4 ac=StudentIdBind op=checkRecord sid= cid= uid=
             */
             NSLog(@"myClassList 检查我的所有绑定记录");
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"StudentIdBind",@"ac",
                                  @"4",@"v",
                                  @"checkRecord", @"op",
                                  @"0",@"cid",
                                  nil];
            
            NSLog(@"data:%@",data);
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                NSLog(@"是否绑定过学生id:%@",respDic);
                
                if ([result integerValue] == 1) {
                    
                    NSMutableArray *tempArray = [respDic objectForKey:@"message"];
                    
                    if ([tempArray count] > 0) {//如果是老用户 无论学生家长 都先跳转到列表页
                        
                        ChildrenViewController *childVC = [[ChildrenViewController alloc] init];
                        childVC.listArray = tempArray;
                        childVC.iden = identity;
                        //childVC.titleName = @"选择ID";
                        childVC.titleName = @"";//此页有导航条 无title 经纬确认 2016.06.24
                        childVC.viewType = @"classApply";
                        [self.navigationController pushViewController:childVC animated:YES];
                        
                    }else{
                        
                        AddClassApplyViewController *personalViewCtrl = [[AddClassApplyViewController alloc] init];
                        personalViewCtrl.iden = identity;
                        personalViewCtrl.viewType = @"classApply";
                        personalViewCtrl.titleName = @"用户信息完善";
                        [self.navigationController pushViewController:personalViewCtrl animated:YES];;
                        
                    }
                    
                }else{
                    
                    [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                [Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }];

            
            [MyTabBarController setTabBarHidden:YES];
        }
        
    }
 
}

-(void)viewWillAppear:(BOOL)animated{
    joinNum =@"0";
    NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
    [choose setObject:@"2" forKey:@"CHOOSE"];
    NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
    NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    [self setCustomizeLeftButtonWithImage:@""];

    if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
        [super setRedPointHidden:NO];
    }else {
        [super setRedPointHidden:YES];
    }

    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:NO];
//#4.1   实例化myTapGesture7并设置初始值为零。
     myTapGesture7 = [[TSTapGestureRecognizer alloc]init];
     myTapGesture7.infoStr = @"0";
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = YES;
    self.view.userInteractionEnabled = YES;
    
    
//    for (int i =0 ; i< [listArray count]; i++) {
//        
//        UIImageView *imgV = (UIImageView*)[_tableView viewWithTag:(410+i)];
//        [imgV removeFromSuperview];
//    }

    
   // _noDataView.hidden = YES;
    //_tableView.hidden = YES;
    
    //[self getData];//update by kate 2014.12.30
    //[self checkNewsIcon];// 检查new标记
    
    //[self reloadData];//2015.10.30
    
    [[NSUserDefaults standardUserDefaults] setObject:@"MyClassListViewController" forKey:@"viewName"];
     reflashFlag = 1;
    
    [ReportObject event:ID_OPEN_MY_CLASS_LIST];//2015.06.24
    
    
    
}
- (void)change:(NSNotification *)select{
    NSLog(@"%@",select.userInfo[@"num"]);
    NSLog(@"－－－－－接收到通知------");
    if ([select.userInfo[@"num"]isEqualToString:@"1"]) {
        myTapGesture7.infoStr = @"0";
        
    }else{
        myTapGesture7.infoStr = @"1";
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
     self.view.userInteractionEnabled = NO;
   
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
}

-(void)refreshView{
    
#if BUREAU_OF_EDUCATION
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"您已经被管理员移出部门"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
    [alertView show];
    
#else
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"您已经被管理员移出班级"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
    [alertView show];
#endif
    
   
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if (buttonIndex == 0) {
            
           [self getData];
            
        }else{
            
        }
   
}

-(void)updateUI{
    
    //role_cid
    //role_classes
    
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    [userDetail setObject:@"1" forKey:@"role_classes"];
    
}

//-------------------------------------------------------------------------------
// 更新页面红点 2016.02.18
-(void)updateRedPoint:(NSDictionary*)dic{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"classes"];//new
        //NSArray *filteredArray = [allLastIdDic objectForKey:@"classes"];//old
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *classLastDicDefault = [allLastIdDic objectForKey:@"classLastDicDefault"];//old
        
        if ([classLastDicDefault count] > 0) {
        
            [noticeImgVForMsg removeFromSuperview];
            [noticeImgVForMsg removeFromSuperview];
            
//            [self buildRedArray:listArray];//构造红点数组
            
            for (int i=0; i<[array count]; i++){
                
                NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
               // NSString *type = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"type"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                
                //if (i <= [filteredArray count]-1) {//防止新拉回来的数据 与本地数据Count不一致 导致crash
                   
                    NSString *lastFiltered = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[classLastDicDefault objectForKey:keyStr]]];
                
                            {//其他
                                
                                if ([last integerValue] > [lastFiltered integerValue]) {//新的last比本地的last大
                                    
                                    if ([listArray count] >0) {
                                            
                                            for (int i =0 ; i< [listArray count]; i++) {
                                                
                                                NSString *cId = [[listArray objectAtIndex:i] objectForKey:@"tagid"];
                                                
                                                if ([cid integerValue] == [cId integerValue]) {//为了获取cid所在的行
                                                    
                                                    [redImgArray replaceObjectAtIndex:i withObject:@"1"];
                                                    
                                                    [self checkSelfMomentsNew];
                                                    
                                                }
                                                
                                            }
                                        
                                    }else{
                                       
                                        [self checkSelfMomentsNew];
                                        
                                    }
                                    
                                }
                            }
                //}
                
            }
            
            [_tableView reloadData];
        }
    
    }
    
}

// 构造红点数组
-(void)buildRedArray:(NSMutableArray*)array{
    
    if(!redImgArray){//add 2016.02.18
        
        redImgArray = [[NSMutableArray alloc] init];
        
        if ([redImgArray count] == 0) {
            
            for (int i=0; i<[array count]; i++) {
                
                [redImgArray addObject:@"0"];
                
            }
        }
    }else if ([redImgArray count] == 0){
        
        for (int i=0; i<[array count]; i++) {
            
            [redImgArray addObject:@"0"];
            
        }
        
    }else{
        
        if ([array count] > [redImgArray count]) {
            
            [redImgArray removeAllObjects];
            for (int i=0; i<[array count]; i++) {
                
                [redImgArray addObject:@"0"];
                
            }
            
        }
        else{

            for (int i=0; i<[redImgArray count]; i++) {

                [redImgArray replaceObjectAtIndex:i withObject:@"0"];

            }

        }
        
        
    }
}
//----------------------------------------------------------------------

// 成长空间红点 单独拿出来检查 2015.12.17
-(BOOL)addNewCountForSpaces:(NSDictionary*)dic cid:(NSString*)cId{
    
    if (dic) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *spaceLastDicDefault = [allLastIdDic objectForKey:@"spaceLastDicDefault"];//old
        NSArray *array = [dic objectForKey:@"spaces"];
        
        if ([spaceLastDicDefault count] > 0) {
            
            for (int i=0; i<[array count]; i++) {
                
                NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                NSString *lastFiltered = [NSString stringWithFormat:@"%@",[spaceLastDicDefault objectForKey:keyStr]];
                if ([cid integerValue] == [cId integerValue]) {
                    
                    if ([last integerValue] > [lastFiltered integerValue]) {
                        
                        return YES;
                        
                    }
                    
                }
                
                
            }
            
        }
    }
    
    return NO;
    
}

// check群聊红点
-(BOOL)addNewCountForGroupMsg:(NSString*)cid{
   
    //-----检查是否有未读消息-------------------------------------------------
   
    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[cid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    
    NSInteger count = [chatsListDict.allKeys count];
    
    for (int listCnt = 0; listCnt < count; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        long long gid =[[chatObjectDict objectForKey:@"gid"] longLongValue];
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", gid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        if (cnt > 0) {
            
            return YES;
        }
    }
    //---------------------------------------------------------------------------------
    return NO;
}

-(void)checkNewsIcon:(NSNotification*)notify{

    NSDictionary *dic = [notify object];
    if (dic) {
        
        newsDic = dic;
        [self updateRedPoint:dic];
    }else{
        [self checkNewsIcon];
    }
    
}

-(void)checkNewsIcon{
    
    NSString *app = [Utilities getAppVersion];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"checkModules", @"op",
                          app,@"app",
                          nil];

    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSLog(@"新红点check接口返回:%@",dic);
            
            if (dic) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"alwaysNewsDic"];
                [userDefaults synchronize];//存贮实时的最新的last
                newsDic = dic;
                
                [Utilities updateLocalData:dic];
                [self updateRedPoint:dic];
            }
            
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

-(void)checkSelfMomentsNew{
    
    [noticeImgVForMsg removeFromSuperview];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
    UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
    UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
    
    [detailImg removeFromSuperview];
    [listImg removeFromSuperview];
    
    [button addSubview:noticeImgVForMsg];
    
}


-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器
-(void)getData{
    
     NSLog(@"myClassList getData");
    [Utilities showProcessingHud:self.view];

    [self reloadData];
    
}

-(void)reloadData{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if (listArray!=nil) {
        for (int i=0; i<[listArray count]; i++) {
            
            UIImageView *imgV = (UIImageView*)[_tableView viewWithTag:(410+i)];
            [imgV removeFromSuperview];
            
        }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [FRNetPoolUtils getMyClassList];
        
        NSLog(@"dic:%@",dic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];

            // 东方高中 5kuccom 学校管理员账号密码
            if ([[dic objectForKey:@"grade"] intValue] == 1) {
                
                isAdmin = YES;
                
            }else{
                
                isAdmin = NO;
            }
            
            if (dic == nil) {
                
                //---update 2015.06.25-----------------------------------------------------------------------------------
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                //[self isConnected];
                //-------------------------------------------------------------------------------------------------------
                
                [self isConnected];
                
            }else{
                
                [noNetworkV removeFromSuperview];
                self.view.hidden = NO;
                
//                // 学生不显示右键加入按钮了。

                
                titleName = [dic objectForKey:@"module"];
                if ([titleName length] > 0) {
                    // bug fix 2015.01.16 beck start
                    // 刷新view的时候如果需要重新set title，不能直接调用父类的方法，需要直接设置，不然会闪一下

                    ((UILabel *)self.navigationItem.titleView).text = titleName;
                    // bug fix 2015.01.16 beck end
                }
                
                NSMutableArray *array = [dic objectForKey:@"list"];
                 [listArray removeAllObjects];
                
                if (array!=nil) {
                    
                    if ([array count] >0) {
                        
                        if ((UserType_Student != [Utilities getUserType]) &&
                            (UserType_Parent != [Utilities getUserType])) {
                            [self setCustomizeRightButton:@"icon_jrbj"];
                            
                        }
                        
                        _tableView.hidden = NO;
                        noDataView.hidden = YES;
                        _tipsView.hidden = YES;
                        //[noDataImgV removeFromSuperview];
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        NSDictionary *userInfo = [g_userInfo getUserDetailInfo];
                        NSString *usertype = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];
                        
                        if ([listArray count] == 1) {
                            
                            NSString *tagId = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:0] objectForKey:@"tagid"]];
                            
                            if ([tagId integerValue]!=0 && [tagId length] >0) {
                                
                                MyClassDetailViewController *detailV = [[MyClassDetailViewController alloc]init];
                                detailV.cId = tagId;
                                detailV.fromName = @"tab";
//#3.28&&#3.31  List点击立即加入时候joinNum的值为1，其他时候的值为零。
                                if ([joinNum isEqualToString:@"1"]) {
                                     detailV.nextNum = @"0";
                                }
                                detailV.hidesBottomBarWhenPushed = YES;
                                
                                UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:detailV];
                                
                                NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
                                if ([array count] > 1) {
                                    [array replaceObjectAtIndex:1 withObject:customizationNavi];
                                    [self.tabBarController setViewControllers:array];
                                    
                                }
                            }
                        }
                        
                        if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {

                            
                        }else{
                            
                            [self buildRedArray:listArray];//构造红点数组
                            
                            [self checkNewsIcon];
                            
                            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
                            
                            _tableView.frame = CGRectMake(0, 0, winSize.width, winSize.height - 49 - 64);
                            
                            
                        }
                        
                      
                    }else{
                        
                        // 所有班级都是公开的 无需申请 tony确认 2016.03.15
                        
//                        if ((UserType_Student == [Utilities getUserType]) ||
//                            (UserType_Parent == [Utilities getUserType])) {
//                            NSArray *applies = [dic objectForKey:@"applies"];
                            
//                            if (0 != [applies count]) {
//                                NSDictionary *appliesDic = [applies objectAtIndex:0];
//                                NSString *tagname = [appliesDic objectForKey:@"tagname"];
//                                _classId = [appliesDic objectForKey:@"cid"];
//                                _aid = [appliesDic objectForKey:@"id"];
//                                
//                                _tipsLabel.text = tagname;
//                                
//                                [_tipsButton setTitle:@"取消申请" forState:UIControlStateNormal];
//                                [_tipsButton setTitle:@"取消申请" forState:UIControlStateHighlighted];
//                                
//                                _tipsView.hidden = NO;
//                                
//                            }else {
                       
                                [_tipsButton setTitle:@"立即加入" forState:UIControlStateNormal];
                                [_tipsButton setTitle:@"立即加入" forState:UIControlStateHighlighted];
                                
                                noDataView.hidden = NO;
                                _tipsView.hidden = NO;
                            //}
//                        }
//                        else {//老师
//                            
//                            [_tableView reloadData];
//                            
//                            _noDataView.hidden = NO;
//                            _tipsView.hidden = NO;
//                        
//                            
//                            [noDataImgV removeFromSuperview];
//                            
//                            if (noDataImgV) {
//                                noDataImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 275, 275)];
//                            }
//                           
//                            noDataImgV.image = [UIImage imageNamed:@"noDataViewforClass.png"];
//                            
//                            NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
//                            if ([schoolType isEqualToString:@"bureau"]) {//教育局or幼儿园 假数据
//                                [noDataImgV setImage:[UIImage imageNamed:@"noDataViewforDepartment.png"]];//等待图片
//                            }
//                            
//                            [_tipsView addSubview:noDataImgV];
//                            
//                        }
                        
                        
                    }
                }else{
                    
                }
                
            }
            
             [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];//先注释
        });
        
    });
}


//-(void)selectLeftAction:(id)sender{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

// 进入班级列表
-(void)selectRightAction:(id)sender{
    
//    if (nil != _classId) {
    
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"Class",@"ac",
//                              @"2",@"v",
//                              @"cancelApply", @"op",
//                              _classId, @"cid",
//                              @"", @"aid",
//                              @"", @"aid",
//
//                              nil];
//        
//        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
//            [Utilities dismissProcessingHud:self.view];
//            
//            NSDictionary *respDic = (NSDictionary*)responseObject;
//            NSString *result = [respDic objectForKey:@"result"];
//            
//            if(true == [result intValue]) {
//                
//            } else {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                               message:@"获取信息错误，请稍候再试"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
//            }
//            
//        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
//            [Utilities doHandleTSNetworkingErr:error descView:self.view];
//        }];
        
//    }else {
        NSDictionary *userInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];
        NSString *role_checked = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_checked"]];
        NSString *roleCid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_cid"]];
        
        int classNum = 0;
        if (listArray!=nil) {
            classNum = [listArray count];
        }
        // 原来接口 1为老师，0为学生，2为家长
        
        // 现在接口 0 学生 6 家长 7 老师
        
        //if ([usertype intValue]!=1) {//学生/家长
        if ([usertype intValue]==6 || [usertype intValue] == 0) {//学生/家长
            if (classNum == 0 || [roleCid isEqualToString:@"0"]) {//没有加入班级
                
                ClassListViewController *classListV = [[ClassListViewController alloc] init];
                [self.navigationController pushViewController:classListV animated:YES];
                [MyTabBarController setTabBarHidden:YES];
                
            }else{//已经加入班级
                
#if BUREAU_OF_EDUCATION
        [Utilities showAlert:@"提示" message:@"您只可加入一个班级，如需更换部门，请先退出当前部门" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
#else
      [Utilities showAlert:@"提示" message:@"您只可加入一个班级，如需更换班级，请先退出当前班级" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
#endif
                
            }
        }else{//老师
            // 如果是未通过验证的老师，则需要谈popup
            if ([@"1"  isEqual: role_checked]) {//等待审核
                
                ClassListViewController *classListV = [[ClassListViewController alloc] init];
                [self.navigationController pushViewController:classListV animated:YES];
                [MyTabBarController setTabBarHidden:YES];
            }
            else {
               
                [Utilities showAlert:@"提示" message:@"您还未通过管理员审核，无法使用此功能" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
        }
//    }
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
    static NSString *CellTableIdentifier = @"MyClassListTableViewCell";
    
    MyClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
//        cell = [[MyClassListTableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:CellTableIdentifier];
        
        UINib *nib = [UINib nibWithNibName:@"MyClassListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"班级通知",@"intro",lastApply,@"lastApply",count,@"count", nil];
    
    
    if (indexPath.row == 0) {
        
        /*if (isAdmin) {
            
            cell.headImgView.image = [UIImage imageNamed:@"icon_bjtz.png"];
            cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"];
            cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"lastApply"];
            //cell.introductionLabel.text = @"lastApply";
            
        }else{*/
            
            NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
            cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
            cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"];
        //}
        

    }else{
        
        NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
        cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"];
        
    }
    
//    cell.headImgView.layer.masksToBounds = YES;
//    cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    
    if (redImgArray) {
        
        if ([redImgArray count]>0) {
            
            if ([[redImgArray objectAtIndex:indexPath.row] integerValue] == 1) {
                cell.redImg.image = [UIImage imageNamed:@"icon_new.png"];
            }else{
                cell.redImg.image = nil;
            }
            
        }
        
    }else{
        cell.redImg.image = nil;
    }
    
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"99999999999999999 %@", indexPath);
    //    NSLog(@"99999999999999999 %d", indexPath.section);
    //    NSLog(@"99999999999999999 %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (isAdmin) {//管理员
        
        /*if (indexPath.row == 0) {// 去班级通知列表
            
         
        }else{*/
            
            NSString *classTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
            NSString *cId = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagid"];
           // NSString *classType = [[NSUserDefaults standardUserDefaults]objectForKey:@"classType"];
            //int classTypeint = [classType intValue];
            NSString *grade = [[listArray objectAtIndex:indexPath.row] objectForKey:@"grade"];
            BOOL admin = NO;
            if ([grade intValue] == 0) {
                
                admin = NO;
            }else{
                
                admin = YES;
            }
            
            //ClassMainViewNewViewController *myClassViewCtrl = [[ClassMainViewNewViewController alloc]init];
            MyClassDetailViewController *myClassViewCtrl = [[MyClassDetailViewController alloc]init];//测试数据
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.fromName = @"myClassList";
            //myClassViewCtrl.isAdmin = admin;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.newsDic = newsDic;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];

        //}
        
    }else{
        
        NSString *classTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
        NSString *cId = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagid"];
        NSString *classType = [[NSUserDefaults standardUserDefaults]objectForKey:@"classType"];
        int classTypeint = [classType intValue];

        
        /*if (classTypeint == 0) {
            // 只课表
            ClassMainNoHomeworkViewController *myClassViewCtrl = [[ClassMainNoHomeworkViewController alloc] init];
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.isAdmin = isAdmin;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        } else if (classTypeint == 1) {
            // 只作业
            ClassMainNoScheduleViewController *myClassViewCtrl = [[ClassMainNoScheduleViewController alloc] init];
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
              myClassViewCtrl.isAdmin = isAdmin;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        } else if (classTypeint == 2) {
            // 课表作业都有
            // update by kate 2014.12.02
            //ClassMainViewController *myClassViewCtrl = [[ClassMainViewController alloc] init];
            ClassMainViewNewViewController *myClassViewCtrl = [[ClassMainViewNewViewController alloc] init];
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.isAdmin = isAdmin;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        } else if (classTypeint == 3) {
            // 课表作业都没有
            ClassMainViewController2 *myClassViewCtrl = [[ClassMainViewController2 alloc] init];
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.isAdmin = isAdmin;
            myClassViewCtrl.joined = @"1";
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
        } else {
            // nothing
            [Utilities showAlert:nil message:@"错误！服务器未返回班级类型" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }*/
        
        //ClassMainViewNewViewController *myClassViewCtrl = [[ClassMainViewNewViewController alloc]init];
        MyClassDetailViewController *myClassViewCtrl = [[MyClassDetailViewController alloc]init];// 测试数据
        myClassViewCtrl.fromName = @"myClassList";
        myClassViewCtrl.titleName = classTitle;
        //myClassViewCtrl.isAdmin = isAdmin;
        myClassViewCtrl.cId = cId;
        myClassViewCtrl.newsDic = newsDic;
        [self.navigationController pushViewController:myClassViewCtrl animated:YES];

    }
    
     [MyTabBarController setTabBarHidden:YES];
}

//刷新调用的方法
-(void)pushRefreshView
{
    if (reflashFlag == 1) {
        
        [self reloadData];
        
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
        [self performSelector:@selector(pushRefreshView) withObject:nil afterDelay:0.1];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----add by  kate 2015.06.26---------------
-(void)isConnected{
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        if (!networkVC) {
            
            networkVC = [[networkBar alloc] init];
            
            _tableView.tableHeaderView = networkVC.view;
            
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

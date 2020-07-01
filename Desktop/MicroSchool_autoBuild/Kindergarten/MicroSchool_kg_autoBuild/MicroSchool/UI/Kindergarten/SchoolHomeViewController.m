//
//  SchoolHomeViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SchoolHomeViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "NewsViewController.h"
#import "LeftViewController.h"
#import "MessageCenterViewController.h"
#import "MyPointsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "MyInfoCenterViewController.h"
#import "GrowthNotValidateViewController.h"
#import "ChildViewController.h"
#import "ParenthoodListForParentTableViewController.h"
#import "KnowlegeHomePageViewController.h"
#import "SwitchChildViewController.h"
#import "GrowVIPViewController.h"

#import "Camera360ViewController.h"
//#3.20
@interface SchoolHomeViewController ()<ShowLeftOrRightView>
{
    UIView *bgV;
    UIButton *btn;
    NSString *strNum;
    TSTapGestureRecognizer *myTapGesture7;
    NSString *eventID;
    BOOL returnNum;
    NSString *passTeachersDayURL;
}

@end

@implementation SchoolHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeTitle:G_SCHOOL_NAME];
    [self setCustomizeLeftButtonWithImage:@""];
     isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    
    
    _recipesAry = [[NSMutableArray alloc] init];
    
    //------add by kate 2016.03.19----------------------------------------------------------------------
    isRefresh = NO;//2015.11.16
    isFirst = YES;//2015.12.28 大退红点修改
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
//#3.31
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"select" object:nil];
    
    //3.20
    MyTabBarController * controller = (MyTabBarController*)self.navigationController.tabBarController;
    controller.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNewsIcon:)
                                                 name:NOTIFICATION_UI_MAIN_NEW_MESSAGE
                                               object:nil];
    
    //单聊
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNewCount)
                                                 name:@"addNewCountForMsg"
                                               object:nil];
    
    noticeImgVForMsgTab = [[UIImageView alloc]initWithFrame:CGRectMake((106.0-25)/2.0+20, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMsgTab.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMsgTab.tag = 640;//add 2015.11.19
    
//    iconNoticeForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
//    iconNoticeForMsg.tag = 620;
//    iconNoticeForMsg.image = [UIImage imageNamed:@"icon_new"];
    
    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake((106.0-25)/2.0+20, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMsg.tag = 600;
    
    //通讯录红点
    redLabelForMsg = [[UILabel alloc]initWithFrame:CGRectMake((106.0-25)/2.0+20, 5, 10, 10)];
    redLabelForMsg.tag = 630;
    redLabelForMsg.backgroundColor = [UIColor redColor];
    redLabelForMsg.textColor = [UIColor whiteColor];
    redLabelForMsg.layer.cornerRadius = 10.0;
    redLabelForMsg.layer.masksToBounds = YES;
    redLabelForMsg.textAlignment = NSTextAlignmentCenter;

    
    //--------------------------------------------------------------------------------------------------
//
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

    [self setCustomizeLeftButtonWithImage:@""];

    // 上传菜谱按钮的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeUploadRecipeButtonClick:) name:@"schoolHomeUploadRecipeButtonClick" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhixiao_recipesPicDetail:) name:@"zhixiao_recipesPicDetail" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeRefleshContentView) name:@"schoolHomeRefleshContentView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeDismissHeadRedPoint) name:@"schoolHomeDismissHeadRedPoint" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeAddNoTouchView:) name:@"schoolHomeAddNoTouchView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashschoolHomeRedPoint) name:@"reflashschoolHomeRedPoint" object:nil];

    // 原来写在了leftView中
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyProfile) name:NOTIFICATION_GET_PROFILE object:nil];

    NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    NSMutableDictionary *uD = [NSMutableDictionary dictionaryWithDictionary:userDetailDic];
    [g_userInfo setUserDetailInfo:uD];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44-48) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    [self createHeaderView];

    _moduleAry = [[NSMutableArray alloc] init];
    
    [self doGetModuleAndContent];
//    [self performSelector:@selector(doGetModuleAndContent) withObject:nil afterDelay:0.5];

    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 640)];
    TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture1.infoStr = @"0";
    _maskView.hidden = YES;
    [_maskView addGestureRecognizer:myTapGesture1];
    [self.view addSubview:_maskView];
}

-(void)img_btnclick:(id)sender{
    
//    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;

    myTapGesture7.infoStr = @"0";
//#3.31  此处代码的作用是，主页面处于左划状态的时候，点击主页面通知wws恢复主页面位置。
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

- (void)zhixiao_recipesPicDetail:(NSNotification *)notification {
    NSDictionary *list_dic = [notification userInfo];

    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    
    //去查看大图页 FullImageViewController
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSArray *imageArr = [list_dic objectForKey:@"pics"];
    
    if (0 != [imageArr count]) {
        
        for (int i=0; i<[imageArr count]; i++) {
            NSDictionary *image = [imageArr objectAtIndex:i];
            NSString *str = [image objectForKey:@"url"];
            [list addObject:str];
        }
        
        [MyTabBarController setTabBarHidden:YES];
        rt.pan.enabled = NO;
        FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
        fullImageViewController.assetsArray = list;
        fullImageViewController.currentIndex = 0;
        fullImageViewController.isShowBottomBar = 1;
        fullImageViewController.bottomStr = [list_dic objectForKey:@"content"];
        fullImageViewController.delOrSave = 1;
        fullImageViewController.titleName = [list_dic objectForKey:@"title"];
        [self.navigationController pushViewController:fullImageViewController animated:YES];
    }

    
}

- (void)schoolHomeDismissHeadRedPoint {
    [super setRedPointHidden:YES];
}

- (void)reflashschoolHomeRedPoint {
    NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
    NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
        [super setRedPointHidden:NO];
    }else {
        [super setRedPointHidden:YES];
    }
}

- (void)schoolHomeRefleshContentView {
    
    NSLog(@"schoolhome refleshC");
    [Utilities showProcessingHud:self.view];
    
    [self doGetModuleAndContent];
}

-(void)schoolHomeUploadRecipeButtonClick:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSUInteger cellNum = [[dic objectForKey:@"cellIndex"] integerValue];
    
    NSDictionary* list_dic = [_recipesAry objectAtIndex:cellNum];

    RecipeUploadViewController *vc = [[RecipeUploadViewController alloc] init];
    vc.titleName = @"编辑";
    vc.recipeDic = list_dic;
    [self.navigationController pushViewController:vc animated:YES];
    [MyTabBarController setTabBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recre ated.
}

-(void)viewWillAppear:(BOOL)animated
{
//#4.1  此处代码为了解决偶尔点击左侧页面无反应的bug，无反应的原因是在left页面取不到NSUserDefaults里CHOOSE的值,无法进行判断。现在我在4个页面1.SchoolHome 2.MyclassList 3.ParkHome 4.MyclassDetail 的viewWillAppear方法传值，这样就解决了这个问题。
    NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
    [choose setObject:@"1" forKey:@"CHOOSE"];
    [self setCustomizeLeftButtonWithImage:@""];

//#3.29  此处代码用来解决新家长身份账号第一次注册完毕后，强制退出（非退出登录）再运行后无法登录的问题。代码来源于一处备注（第一次注册成功后，清除注册信息以便于下次直接进入主页面——by  ht   MicroSchoolMainMenuViewController1599行代码注释!我怀疑是哪处代码缺失导致注册成功后的信息没有清除，所以在这个页面给清除掉。）——CD
    NSString *uid1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid1]];
//#end
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = YES;
    self.view.userInteractionEnabled = YES;
//    self.tableView.userInteractionEnabled = YES;
//    self.tableView.tableHeaderView.userInteractionEnabled = YES;

    if ([isNewVersion intValue] == 1) {
//        [super setRedPointHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftViewReloadRedPoint" object:self userInfo:nil];
    }else {
//        [super setRedPointHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftViewReloadRedPoint" object:self userInfo:nil];
    }
    
    
    
    
    
    NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
    NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
        [super setRedPointHidden:NO];
    }else {
        [super setRedPointHidden:YES];
    }

    
    
    
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:NO];
    
    //----add by kate 2016.03.19-------------------
    reflashFlag = 1;
    [self checkNewIconForMsgCenter];//检查我的消息
    [self checkNewFeedback];//检查意见反馈
    isRefresh = NO;
    [self addNewCount];//2015.11.19 获取单聊未读数量
    //-----------------------------------
//#4.1   实例化myTapGesture7并设置初始值为零。
    myTapGesture7 = [[TSTapGestureRecognizer alloc]init];
    myTapGesture7.infoStr = @"0";
    
    [self getMyProfile];
    [self ifShowTeachersDayThanks];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"iosbar.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}
- (void)showThanksDic:(NSDictionary *)dic
{
    NSDictionary *message_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
    //    NSMutableDictionary *message_info = [[NSMutableDictionary alloc] init];
    //    message_info = [g_userInfo getUserDetailInfo];
    NSString *uid = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"uid"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *teachersDayUid = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", eventID,uid]];
    //    NSString *key = [NSString stringWithFormat:@"%@_%@", eventID,teachersDayUid];
    
    if (nil == teachersDayUid) {
        [self showCustomAlert:[NSString stringWithFormat:@"%@", [dic objectForKey:@"note"]] buttonTitle:@"立即查看" imgName:@"customAlert/alert_thankBg.png"];
    }else {
        if ([[defaults objectForKey:teachersDayUid] integerValue] > 0) {
            [bgV removeFromSuperview];
        }
    }
    
    
    
    //    [defaults setObject:[message_info objectForKey:@"student_number"] forKey:@"student_number_fuck_id"];
    //    [defaults synchronize];
    
}
-(void)ifShowTeachersDayThanks{
    
    NSDictionary *message_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
    //    NSMutableDictionary *message_info = [g_userInfo getUserDetailInfo];
    NSString *usertype = [message_info objectForKey:@"role_id"];
    NSString *app = [Utilities getAppVersion];
    //    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"SpecialActivity",@"ac",
                          @"3",@"v",
                          @"fetch", @"op",
                          app,@"app",
                          [message_info objectForKey:@"role_cid"], @"cid",
                          nil];
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[respDic objectForKey:@"message"]];
        if (dataArr.count == 0 ) {
            return;
        }
        NSString * currentDate = [dataArr[0] objectForKey:@"dateline"];
        NSString * firstDate = [[dataArr[0] objectForKey:@"interval"] objectForKey:@"start"];
        NSString * lastDate = [[dataArr[0] objectForKey:@"interval"] objectForKey:@"end"];
        if(true == [result intValue]) {
            if ([[dataArr[0] objectForKey:@"id"] integerValue] > 0) {
                if ([currentDate integerValue] >= [firstDate integerValue] && [currentDate integerValue] <= [lastDate integerValue]) {
                    returnNum = 1;
                    //                    NSString *b = [aaa objectForKey:@"url"];//url需要拼接
                    //                    NSString *newUrl = [Utilities appendUrlParams:b];
                    //                    newUrl = [NSString stringWithFormat:@"%@&grade=%@",newUrl,usertype];
                    eventID = [NSString stringWithFormat:@"%@",[dataArr[0] objectForKey:@"id"]];
                    NSString *b = [dataArr[0] objectForKey:@"url"];
                    NSString *newUrl = [Utilities appendUrlParamsV2:b];
                    passTeachersDayURL = [NSString stringWithFormat:@"%@&grade=%@",newUrl,usertype];
                    [self showThanksDic:(NSDictionary *)dataArr[0]];
                }
            }
            
            
        }else{
            
            [Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

-(void)showCustomAlert:(NSString*)msg buttonTitle:(NSString*)btnTitle imgName:(NSString*)name{
    
    if (!bgV) {
        
        bgV = [UIView new];
        //        bgV.tag = 333;
        bgV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"customAlert/commonBg.png"]];
        
    }
    BOOL addBGV = false;
    for (UIView *view in [self.view subviews]) {
        if ([view isEqual:bgV]) {
            addBGV = true;
        }else{
            
        }
    }
    if (!addBGV) {
        bgV.tag = 10086;
        [[UIApplication sharedApplication].keyWindow addSubview:bgV];
    }
    
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([UIApplication sharedApplication].keyWindow).with.offset(0);
        
        make.left.equalTo([UIApplication sharedApplication].keyWindow).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    }];
    UIImageView *alertBgImgV = [UIImageView new];
    alertBgImgV.image = [UIImage imageNamed:name];
    alertBgImgV.userInteractionEnabled = YES;
    [bgV addSubview:alertBgImgV];
    
    [alertBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgV).with.offset(([UIApplication sharedApplication].keyWindow.bounds.size.height - 48.0 - alertBgImgV.image.size.height)/2.0);
        make.left.equalTo(bgV).with.offset(([UIApplication sharedApplication].keyWindow.bounds.size.width - alertBgImgV.image.size.width)/2.0 );
        make.size.mas_equalTo(CGSizeMake(alertBgImgV.image.size.width, alertBgImgV.image.size.height));
        
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"customAlert/btnBg_normal.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"customAlert/btnBg_press.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
    [alertBgImgV addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertBgImgV.mas_bottom).with.offset(0);
        make.left.equalTo(alertBgImgV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(alertBgImgV.image.size.width, btn.currentBackgroundImage.size.height));
        
    }];
    
    UITextView *txv = [UITextView new];
    txv.backgroundColor = [UIColor clearColor];
    txv.textAlignment = NSTextAlignmentCenter;
    txv.text = msg;
    txv.font = [UIFont systemFontOfSize:15.0];
    txv.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    txv.editable = NO;
    [alertBgImgV addSubview:txv];
    [txv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertBgImgV).with.offset(alertBgImgV.image.size.height/2.0);
        make.left.equalTo(alertBgImgV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(alertBgImgV.image.size.width,  btn.currentBackgroundImage.size.height*2 - 10.0));
        
    }];
    
}
- (void)alertClick:(UIButton *)button{
    NSDictionary *message_info = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:G_NSUserDefaults_UserLoginInfo]];
    //    NSMutableDictionary *message_info = [g_userInfo getUserDetailInfo];
    NSString *uid = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"uid"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:[NSString stringWithFormat:@"%@_%@", eventID,uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [bgV removeFromSuperview];
    SingleWebViewController *singleWebView = [[SingleWebViewController alloc] init];
    singleWebView.isFromEvent = YES;
    singleWebView.webType = SWLoadURl;//2015.09.23
    singleWebView.url = [NSURL URLWithString:passTeachersDayURL];
    singleWebView.isShowSubmenu = @"0";
    singleWebView.closeVoice = 1;
//    singleWebView.hideBar = YES;
    [self.navigationController pushViewController:singleWebView animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {

    self.view.userInteractionEnabled = NO;
//    self.tableView.userInteractionEnabled = NO;
//    self.tableView.tableHeaderView.userInteractionEnabled = NO;

}
//#4.1  在本页面点击左侧页面的cell后，通知wws恢复主页面位置。
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
        rt.pan.enabled = NO;
        SettingViewController *settingView = [[SettingViewController alloc]init];
        settingView.isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
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
        personalViewCtrl.viewType = @"resendTeacherRequest";
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
//        NSDictionary * userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
//        NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"Kindergarden", @"ac",
//                              @"3", @"v",
//                              @"classHome", @"op",
//                              cid, @"cid",
//                              app,@"app",
//                              nil];
//        vc.innerLinkReqData = data;
        vc.VIPUrl = select.userInfo[@"payUrl"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
//#4.1 此处通知是为了解决滑动一次后，需要点击两次左上角头像才会产生效果的问题。在4个可以侧滑的页面重置myTapGesture7的值。
- (void)change:(NSNotification *)select{
    NSLog(@"%@",select.userInfo[@"num"]);
    NSLog(@"－－－－－接收到通知------");
    if ([select.userInfo[@"num"]isEqualToString:@"1"]) {
         myTapGesture7.infoStr = @"0";
        
    }else{
     myTapGesture7.infoStr = @"1";
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)selectLeftAction:(id)sender{
    
//    myTapGesture7 = (TSTapGestureRecognizer *)sender;
//#3.31 此处为解决左划时产生错位的问题。代码拿掉了原来在tab里通过代理控制leftorright，现在统一用通知在wws里控制，每次显示main以后，重置scalef为零。
    if ([@"0"  isEqual: myTapGesture7.infoStr]) {
        _maskView.hidden = NO;

        myTapGesture7.infoStr = @"1";
        strNum =@"1";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
           [choose setObject:@"1" forKey:@"CHOOSE"];

    }else {
        myTapGesture7.infoStr = @"0";
        _maskView.hidden = YES;
        strNum =@"2";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
- (void)doGetModuleAndContent {
    /**
     * 幼儿园首页
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=schoolHome sid= cid= uid= app=
     */
    
    [_recipesAry removeAllObjects];
    
    NSString *op = @"schoolHome";
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          op, @"op",
                          cid, @"cid",
                          nil];

//    NSDictionary *data = @{@"ac":@"Kindergarten",
//                           @"v":@3,
//                           @"op":op,
//                           @"cid":cid
//                           };
    
//    NSString *ac = data[@"ac"];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            _contentDic = [NSMutableDictionary dictionaryWithDictionary:[respDic objectForKey:@"message"]];
            
            NSDictionary *recipes = [_contentDic objectForKey:@"recipes"];
            if (nil != recipes) {
                _recipesAry = [NSMutableArray arrayWithArray:[recipes objectForKey:@"list"]];
            }

            for (int i=0; i<[_recipesAry count]; i++) {
                NSDictionary *dic = [_recipesAry objectAtIndex:i];
                
                NSArray *pics = [dic objectForKey:@"pics"];
                for (int j=0; j<[pics count]; j++) {
                    UIImageView *img = [[UIImageView alloc]init];
                    NSDictionary *picsDic = [pics objectAtIndex:j];

                    [img sd_setImageWithURL:[NSURL URLWithString:[picsDic objectForKey:@"url"]]
                                      placeholderImage:nil
                                               options:SDWebImageCacheMemoryOnly];
                }
            }
            
            moduleFromServer = [[NSMutableArray alloc] initWithArray:[_contentDic objectForKey:@"modules"] copyItems:YES];
            _moduleAry = [NSMutableArray arrayWithArray:[_contentDic objectForKey:@"modules"]];
            
            [self doShowContentView];
        } else {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                           message:@"获取信息错误，请稍候再试"
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [self performSelector:@selector(finishedLoadData) withObject:nil afterDelay:0.1];
        [_tableView reloadData];

        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)doShowContentView {
    _tableViewHeaderView = [UIView new];
    _tableViewHeaderView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    _tableView.tableHeaderView = _tableViewHeaderView;
    
    [_tableViewHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_top).with.offset(0);
        make.left.equalTo(_tableView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities convertPixsH:260]));
    }];

//    _noRecipesView = [[UIImageView alloc] initWithFrame:CGRectMake(320-90, 30, 90, 90)];
//    [_noRecipesView setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeRecipeNoImage"]];
//    _noRecipesView.hidden = YES;
//    [_tableViewHeaderView addSubview:_noRecipesView];

    // 可以滚动的banner
    _scrolledBannerView = [ScrolledBanner new];
    _scrolledBannerView.delegate = self;
    [_tableViewHeaderView addSubview:_scrolledBannerView];
    [_scrolledBannerView initImages:[_contentDic objectForKey:@"sliders"] content:@"asjflkasdjflkajsdf" rect:CGRectMake(0, 0, [Utilities getScreenSizeWithoutBar].width, [Utilities convertPixsH:200])];
    
    [_scrolledBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableViewHeaderView.mas_top).with.offset(0);
        make.left.equalTo(_tableViewHeaderView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities convertPixsH:200]));
    }];

    // 模块列表
    _modulesView = [UIView new];
    _modulesView.backgroundColor = [UIColor whiteColor];
    [_tableViewHeaderView addSubview:_modulesView];

    [_modulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrolledBannerView.mas_bottom).with.offset(10);
        make.left.equalTo(_scrolledBannerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities convertPixsH:90]));
    }];

    
    
    
    UILabel *repipeLabel = [UILabel new];
    repipeLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    repipeLabel.backgroundColor = [UIColor clearColor];
    repipeLabel.text = [[[_contentDic objectForKey:@"recipes"] objectForKey:@"profile"] objectForKey:@"name"];
    repipeLabel.font = [UIFont systemFontOfSize:14.0f];
//    repipeLabel.backgroundColor = [UIColor redColor];
    [_tableViewHeaderView addSubview:repipeLabel];
    
    [repipeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modulesView.mas_bottom).with.offset(-5);
        make.left.equalTo(_scrolledBannerView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 43));
    }];

    UIView *greenMarkView = [UIView new];
    greenMarkView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
    [_tableViewHeaderView addSubview:greenMarkView];
    [greenMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repipeLabel.mas_top).with.offset(10);
        make.left.equalTo(_scrolledBannerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];

    UILabel *weekLabel = [UILabel new];
    weekLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
    weekLabel.backgroundColor = [UIColor clearColor];
    weekLabel.text = [[[_contentDic objectForKey:@"recipes"] objectForKey:@"profile"] objectForKey:@"date"];
    weekLabel.font = [UIFont systemFontOfSize:13.0f];
    weekLabel.textAlignment = NSTextAlignmentRight;
    [_tableViewHeaderView addSubview:weekLabel];
    
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modulesView.mas_bottom).with.offset(-5);
        make.left.equalTo(_scrolledBannerView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 45));
    }];


    [self doShowModuleView];
}

- (void)doShowModuleView {
    
    _moduleSelectView = [TSImageSelectView new];
    _moduleSelectView.delegate = self;
    [_moduleSelectView initArrays];
    _moduleSelectView.tag = 110;//add by kate 2016.03.23
    [_modulesView addSubview:_moduleSelectView];

    [_moduleSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modulesView.mas_top).with.offset(0);
        make.left.equalTo(_modulesView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, 0));
    }];
    
    [self performSelector:@selector(updateImageSelectViewElement) withObject:nil afterDelay:0.1];
    
    
}

- (void)updateImageSelectViewElement {
    float wid = [Utilities getScreenSizeWithoutBar].width/4;
    float hei = 80;

    NSMutableArray *selectedImages = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[_moduleAry count]; i++) {
        NSDictionary *picDic = [_moduleAry objectAtIndex:i];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [picDic objectForKey:@"name"], @"name",
                             [picDic objectForKey:@"icon"], @"image",
                             @"selectImageServerCustom", @"imageType",
                             [NSString stringWithFormat:@"%@", [picDic objectForKey:@"id"]], @"id",
                             nil];
        
        [selectedImages addObject:dic];
    }
    
    int moduleCount = [Utilities getScreenSizeWithoutBar].width / ([Utilities getScreenSizeWithoutBar].width/4);
    int lineCount = (int)[_moduleAry count]/moduleCount+1;
    
    CGRect ccc = _tableViewHeaderView.frame;
    ccc.size.height = [Utilities convertPixsH:260] + lineCount*80+10-8;
    _tableViewHeaderView.frame = ccc;
//    _tableView.tableHeaderView = _tableViewHeaderView;

    
    
    CGRect c = _moduleSelectView.frame;
    c.size.width = [Utilities getScreenSizeWithoutBar].width;
    c.size.height = lineCount*80+10;
    _moduleSelectView.frame = c;

    CGRect cc = _moduleSelectView.frame;
    cc.size.width = [Utilities getScreenSizeWithoutBar].width;
    cc.size.height = lineCount*80+10;
    _modulesView.frame = cc;
    
    


    
    
    [_moduleSelectView setImages:selectedImages elementWidth:wid elementHeight:hei gapWidth:0];
}

- (void)tsImageSelectView:(TSImageSelectView *)v height:(NSInteger)h {
    [_tableViewHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_tableViewHeaderView.frame.size.height);
    }];
    
    if (0 == [_recipesAry count]) {
        
        
    }
    
    [_modulesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
    
    [_moduleSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
    
    
    
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.1];
    
    //---add by kate 2016.03.19-----------------------
    [self buildRedArray:_moduleAry];
    
    if (isRefresh || isFirst) {// 大退红点修改
        
        [self checkNewsIcon];
    }
    [self addNewCount];
    //--------------------------------------------------
    
    
    // 判断是否是大退之后通过通知栏进入的。如果是则按照推送类型跳转到相应详细页面。
    NSDictionary *recivedApsInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"recivedApsInfo"];
    
    if (nil != recivedApsInfo) {
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate doHandleInactiveNotification:recivedApsInfo];
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"recivedApsInfo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

- (void)reloadTableView {
    _tableView.tableHeaderView = _tableViewHeaderView;
    
    _tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    _tableViewFooterView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    _tableView.tableFooterView = _tableViewFooterView;
    
    if (0 == [_recipesAry count]) {
        _tableViewFooterView.frame = CGRectMake(0, 0, WIDTH, 140);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-90)/2, 10, 90, 90)];
        [img setImage:[UIImage imageNamed:@"BlankViewImage/幼标@3_11.png"]];
        [_tableViewFooterView addSubview:img];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 20)];
        title.text = @"今日暂无菜谱";
        title.font = [UIFont systemFontOfSize:14.0f];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor grayColor];
        [_tableViewFooterView addSubview:title];
        
        _tableViewFooterView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = _tableViewFooterView;
    }else {
        NSArray *views = [_tableViewFooterView subviews];
        for(UIView* view in views) {
            [view removeFromSuperview];
        }
        
        _tableViewFooterView.frame = CGRectMake(0, 0, WIDTH, 10);
        
        _tableViewFooterView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = _tableViewFooterView;
    }

    _tableView.tableFooterView = _tableViewFooterView;

    [self performSelector:@selector(finishedLoadData) withObject:nil afterDelay:0.1];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recipesAry count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == ([_recipesAry count]-1)) {
        return 125;
    }else {
        return 125;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (1 == [_recipesAry count]) {
        return 1;
    }else {
        if (section == ([_recipesAry count]-1)) {
            return 10;
        }else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    NSMutableDictionary *recipesDic = [NSMutableDictionary dictionaryWithDictionary:[_recipesAry objectAtIndex:row]];
    
    SchoolHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[SchoolHomeTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.cellIndex = [NSString stringWithFormat:@"%lu", (unsigned long)row];
    cell.recipesInfo = recipesDic;
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];

    if((![@"0"  isEqual: role_id]) && (![@"6"  isEqual: role_id])) {
        cell.uploadRecipesButton.hidden = NO;

        if ([@"1"  isEqual: role_checked]) {
            // 只有通过验证的教师才显示修改菜谱
            cell.uploadRecipesButton.hidden = NO;
        }else {
            cell.uploadRecipesButton.hidden = YES;
        }
    }else {
        cell.uploadRecipesButton.hidden = YES;
    }
    
    NSString *iconName = @"";
    if ([@"0"  isEqual: [recipesDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon0";
    }else if ([@"1"  isEqual: [recipesDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon1";
    }else if ([@"2"  isEqual: [recipesDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon2";
    }else if ([@"3"  isEqual: [recipesDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon3";
    }else if ([@"4"  isEqual: [recipesDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon4";
    }
    
    [cell.iconImageView setImage:[UIImage imageNamed:iconName]];
    cell.titleLabel.text = [recipesDic objectForKey:@"title"];
    cell.contentLabel.text = [recipesDic objectForKey:@"content"];
    
    CGSize msgSize = [cell.contentLabel sizeThatFits:CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-90-10, 0)];
    // 3行的高度
    if (msgSize.height > 52) {
        msgSize.height = 52;
    }
    
    [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-90-10, msgSize.height));
    }];

    NSInteger picsCount = [(NSArray *)[recipesDic objectForKey:@"pics"] count];
    cell.picsNumberLabel.text = [NSString stringWithFormat:@"共%lu张", picsCount];

    if (0 == picsCount) {
        [cell.thumbImageView setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeRecipeNoImage"]];
    }else {
        [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:[recipesDic objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    }
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#if 0
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* list_dic = [_recipesAry objectAtIndex:[indexPath row]];
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    
    //去查看大图页 FullImageViewController
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSArray *imageArr = [list_dic objectForKey:@"pics"];
    
    if (0 != [imageArr count]) {
        
        for (int i=0; i<[imageArr count]; i++) {
            NSDictionary *image = [imageArr objectAtIndex:i];
            NSString *str = [image objectForKey:@"url"];
            [list addObject:str];
        }
        
        [MyTabBarController setTabBarHidden:YES];
        rt.pan.enabled = NO;
        FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
        fullImageViewController.assetsArray = list;
        fullImageViewController.currentIndex = 0;
        fullImageViewController.isShowBottomBar = 1;
        fullImageViewController.bottomStr = [list_dic objectForKey:@"content"];
        fullImageViewController.delOrSave = 1;
        fullImageViewController.titleName = [list_dic objectForKey:@"title"];
        [self.navigationController pushViewController:fullImageViewController animated:YES];
    }
#endif
}

-(void)ScrolledBannerSelectedImage:(ScrolledBanner *)v index:(NSInteger)index {
    NSString *moduleName = @"风采";
    for (int i=0; i<[_moduleAry count]; i++) {
        NSDictionary *moduleDic = [_moduleAry objectAtIndex:i];
        
        if ([@"34"  isEqual: [moduleDic objectForKey:@"type"]]) {
            moduleName = [moduleDic objectForKey:@"name"];
            break;
        }
    }
    
    NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:moduleName];
    newsDetailViewCtrl.newsid = [NSString stringWithFormat:@"%ld", (long)index];
    [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
     NSLog(@"schoolhome createH");
    [Utilities showProcessingHud:self.view];
    
    _page = @"0";
    _size = @"20";
    
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

-(void)finishedLoadData{
    
    [self finishReloadingData];
//    [self setFooterView];
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

//加载调用的方法
-(void)getNextPageView
{
//    [self doGetPresence];
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        isRefresh = YES;
        
        // to beck to do:下拉刷新
        [self doGetModuleAndContent];
        
    }
    
}

#pragma mark -
#pragma mark TSImageSelectViewSelectDelegate
- (void)tsImageSelectViewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic {
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = NO;
    
    NSDictionary *module = [_moduleAry objectAtIndex:index];
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];
    
    BOOL isConnect = [Utilities connectedToNetwork];
    if ([@"28"  isEqual: [module objectForKey:@"type"]]) {
        // 校园公告
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;//2015.11.12
        newsViewCtrl.newsType = @"schoolNews";
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        [MyTabBarController setTabBarHidden:YES];
    }else if ([@"1"  isEqual: [module objectForKey:@"type"]]) {
        // 自定义公告
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;//2015.11.12
        newsViewCtrl.newsType = @"customizeNews";
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        [MyTabBarController setTabBarHidden:YES];
        
    }else if ([@"2"  isEqual: [module objectForKey:@"type"]]) {
        // 讨论区
        if(isConnect) {
            DiscussViewController *discussViewCtrl = [[DiscussViewController alloc] init];
            discussViewCtrl.fromName = @"discuss";
            [self.navigationController pushViewController:discussViewCtrl animated:YES];
            discussViewCtrl.titleName = [module objectForKey:@"name"];//update by kate
            [MyTabBarController setTabBarHidden:YES];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"3"  isEqual: [module objectForKey:@"type"]]) {
        if (isConnect) {
            // 活动
            if([@"7"  isEqual: role_id]) {
                if ([@"1"  isEqual: role_checked]) {
                    SchoolEventViewController *schoolEventViewCtrl = [[SchoolEventViewController alloc] initWithVar:[module objectForKey:@"name"]];//update by kate
                    [self.navigationController pushViewController:schoolEventViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
                }else if ([@"2"  isEqual: role_checked]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"您还未获得教师身份，请递交申请."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else if ([@"0"  isEqual: role_checked]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"请耐心等待审批."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                SchoolEventViewController *schoolEventViewCtrl = [[SchoolEventViewController alloc] initWithVar:[module objectForKey:@"name"]];//update by kate
                [self.navigationController pushViewController:schoolEventViewCtrl animated:YES];
                [MyTabBarController setTabBarHidden:YES];
            }
            else {
                if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user objectForKey:@"role_cid"]]]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"请先加入一个班级."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else {
                    SchoolEventViewController *schoolEventViewCtrl = [[SchoolEventViewController alloc] initWithVar:[module objectForKey:@"name"]];//update by kate
                    [self.navigationController pushViewController:schoolEventViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
                }
            }
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"4"  isEqual: [module objectForKey:@"type"]]) {
        if (isConnect) {
            // 班级
            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            if([@"7"  isEqual: usertype]) {
                if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", role_checked]]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"您还未获得教师身份，请递交申请."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", role_checked]]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"请耐心等待审批."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"知道了"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else {
//                    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",classType] forKey:@"classType"];
                    MyClassListViewController *myclassV = [[MyClassListViewController alloc]init];
                    [self.navigationController pushViewController:myclassV animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
                }
            }else {
//                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",classType] forKey:@"classType"];
                MyClassListViewController *myclassV = [[MyClassListViewController alloc]init];
                [self.navigationController pushViewController:myclassV animated:YES];
                [MyTabBarController setTabBarHidden:YES];
            }
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"9"  isEqual: [module objectForKey:@"type"]]) {
        // 知识库
        if(isConnect) {//此处应该到新版知识库 update by kate 2016.04.21
            
//            KnowledgeViewController *knowledgeViewCtrl = [[KnowledgeViewController alloc] init];
//            knowledgeViewCtrl.titleName = [module objectForKey:@"name"];
//            [self.navigationController pushViewController:knowledgeViewCtrl animated:YES];
            KnowlegeHomePageViewController *kbV = [[KnowlegeHomePageViewController alloc]init];
            [self.navigationController pushViewController:kbV animated:YES];
            
            [MyTabBarController setTabBarHidden:YES];
            
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"10"  isEqual: [module objectForKey:@"type"]]) {
        if(isConnect) {
            // 通讯录
            if([@"7"  isEqual: role_id]) {
                
                    // update by kate 2015.06.18
                    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                    friendViewCtrl.classid = cid;
                    friendViewCtrl.titleName = [module objectForKey:@"name"];
                    [self.navigationController pushViewController:friendViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
//                    [iconNoticeForMsg removeFromSuperview];
                    [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
            }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                
                PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                friendViewCtrl.classid = cid;
                friendViewCtrl.titleName = [module objectForKey:@"name"];
                [self.navigationController pushViewController:friendViewCtrl animated:YES];
                [MyTabBarController setTabBarHidden:YES];
//                [iconNoticeForMsg removeFromSuperview];
                [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                
            }else {
                
                    // update by kate 2015.06.18
                    //                     if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                    //
                    //                         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                    //                                                                        message:@"请先加入一个班级."
                    //                                                                       delegate:nil
                    //                                                              cancelButtonTitle:@"知道了"
                    //                                                              otherButtonTitles:nil];
                    //                         [alert show];
                    //
                    //
                    //
                    //                     }else {
                    
                    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                    friendViewCtrl.classid = cid;
                    friendViewCtrl.titleName = [module objectForKey:@"name"];
                    [self.navigationController pushViewController:friendViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
//                    [iconNoticeForMsg removeFromSuperview];
                    [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                    //                    }
                
                
            }
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"11"  isEqual: [module objectForKey:@"type"]]) {
        if(isConnect) {
            // 督学
            EduinspectorViewController *eduInsViewCtrl = [[EduinspectorViewController alloc] init];
            eduInsViewCtrl.titleName = [module objectForKey:@"name"];
            [self.navigationController pushViewController:eduInsViewCtrl animated:YES];
            [MyTabBarController setTabBarHidden:YES];
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if ([@"20"  isEqual: [module objectForKey:@"type"]]) {
        // 校园广播
        if(isConnect) {
#if 0
            HomeworkDetailViewController *testApi = [[HomeworkDetailViewController alloc] init];
            [self.navigationController pushViewController:testApi animated:YES];
            [MyTabBarController setTabBarHidden:YES];
            
            //            GroupChatSettingViewController *testApi = [[GroupChatSettingViewController alloc] init];
            //            [self.navigationController pushViewController:testApi animated:YES];
            //            [MyTabBarController setTabBarHidden:YES];
            
            
            
            //            TestApiTSNetworkingViewController *testApi = [[TestApiTSNetworkingViewController alloc] init];
            //            testApi.testStr = @"test";
            //            [self.navigationController pushViewController:testApi animated:YES];
            //            [MyTabBarController setTabBarHidden:YES];
#else
            BroadcastViewController *broadcastViewCtrl = [[BroadcastViewController alloc] init];
            broadcastViewCtrl.moduleName = [module objectForKey:@"name"];
            broadcastViewCtrl.otherSid = G_SCHOOL_ID;// add by kate 2015.04.22
            broadcastViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
            //broadcastViewCtrl.newsDic = newsDic;
            [self.navigationController pushViewController:broadcastViewCtrl animated:YES];
            [MyTabBarController setTabBarHidden:YES];
#endif
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"21"  isEqual: [module objectForKey:@"type"]]){
        //校园订阅/校园导读
        
        if (isConnect){
            
#if 9
            SubscribeNumListViewController *subListV = [[SubscribeNumListViewController alloc]init];
            subListV.titleName = [module objectForKey:@"name"];
            subListV.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
            //            subListV.lastSubscribeId = lastSubscribeId;
            subListV.newsDic = newsDic;//2015.11.12
            [self.navigationController pushViewController:subListV animated:YES];
#else
            
            
            
        
//            RecordSightViewController *vc = [[RecordSightViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];

            SightPlayerViewController *vc = [[SightPlayerViewController alloc] init];
//            vc.videoURL = [NSURL URLWithString:@"http://image.5xiaoyuan.cn/attachment/201604/14/71460622020134.570f52d3b99294.11522145.mp4"];
//            
            vc.videoURL = [NSURL URLWithString:@"http://image.5xiaoyuan.cn/attachment/201604/14/14Merge.570f4e5d8a0af2.63395787.mp4"];

//            vc.isLocalUrl = YES;
//            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];

            [ self presentViewController:vc animated: YES completion:nil];
            
//            [self.navigationController pushViewController:vc animated:YES];
//            [MyTabBarController setTabBarHidden:YES];

            
            
            
            
//            ShowSightViewController *vc = [[ShowSightViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];

            
            
            
            
#endif
            
            
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }else if ([@"23"  isEqual: [module objectForKey:@"type"]]){
        // 链接模块
        
        if (isConnect){
            
            NSURL *webUrl = [NSURL URLWithString:[module objectForKey:@"url"]];
            
            if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"message";
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                //fileViewer.fromName = @"message";
                fileViewer.webType = SWLoadURl;//2015.09.23
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
                
            }else {
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"scan";
                fileViewer.loadHtmlStr = [module objectForKey:@"url"];
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                //fileViewer.fromName = @"scan";
                fileViewer.webType = SWLoadHtml;
                fileViewer.loadHtmlStr = [module objectForKey:@"url"];
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }
            
            [ReportObject event:ID_OPEN_OUTER_LINK];//2015.06.25
            
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }
        
    }else if ([@"24"  isEqual: [module objectForKey:@"type"]]){
        
        if (isConnect){
            
            // 内链模块
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"innerLinkModule", @"op",
                                  [module objectForKey:@"name"], @"module",
                                  @"290",@"width",
                                  nil];
            
            NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:[module objectForKey:@"name"]];
            
            newsDetailViewCtrl.viewType = @"innerLink";
            newsDetailViewCtrl.innerLinkReqData = data;
            
            [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
            
            [MyTabBarController setTabBarHidden:YES];
            
            [ReportObject event:ID_OPEN_HTML];//2015.06.25
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"25"  isEqual: [module objectForKey:@"type"]]){
        
        if (isConnect){
            // 视频监控
            CCTVListViewController *cctv = [[CCTVListViewController alloc]init];
            cctv.titleName = [module objectForKey:@"name"];
            [self.navigationController pushViewController:cctv animated:YES];
            
            [MyTabBarController setTabBarHidden:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"videoNew"];//2015.09.10
            
            [_tableView reloadData];//2015.09.10
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"27" isEqual:[module objectForKey:@"type"]]){//教育局版本特有模块 原来在tab中
        
        if (isConnect){
            
            SchoolListForBureauViewController *schoolListBureau = [[SchoolListForBureauViewController alloc]init];
            schoolListBureau.titleName = [module objectForKey:@"name"];
            [self.navigationController pushViewController:schoolListBureau animated:YES];
            [MyTabBarController setTabBarHidden:YES];
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"网络异常，请检查网络"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }else if ([@"19" isEqual:[module objectForKey:@"type"]]){//师生圈
        
        MomentsViewController *commentList  = [[MomentsViewController alloc]init];
        commentList.newsDic = newsDic;
        commentList.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        commentList.titleName = [module objectForKey:@"name"];
        commentList.fromName = @"school";
        commentList.cid = @"0";
//        commentList.lastMsgId = lastMsgId;
        [self.navigationController pushViewController:commentList animated:YES];
        
    }else if ([@"33" isEqual:[module objectForKey:@"type"]]){
        // 菜谱
        WeeklyRecipesViewController *vc = [[WeeklyRecipesViewController alloc] init];
        vc.titleName = [module objectForKey:@"name"];
        [self.navigationController pushViewController:vc animated:YES];
        [MyTabBarController setTabBarHidden:YES];
    }else if ([@"34" isEqual:[module objectForKey:@"type"]]){
        // 风采
        PresenceViewController *vc = [[PresenceViewController alloc] init];
        vc.titleName = [module objectForKey:@"name"];
        [self.navigationController pushViewController:vc animated:YES];
        [MyTabBarController setTabBarHidden:YES];
    }else if ([@"10035" isEqual:[module objectForKey:@"type"]] || [@"10040" isEqual:[module objectForKey:@"type"]]){  //   10035  测试  10040 正式  1
        // 校园监控  360    2017.10.11
        
#if DEVICE_IPHONE
        Camera360ViewController *c360vc = [[Camera360ViewController alloc] init];
        c360vc.cId = @"0";
        c360vc.titleName = [module objectForKey:@"name"];
        //   只有校管可以编辑，其他人没有编辑
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
        if ([usertype integerValue] == 9) {
            c360vc.isAdmin = YES;
        } else {
            c360vc.isAdmin = NO;
        }
        
        [self presentViewController:c360vc animated:YES completion:nil];
#else
        [Utilities showTextHud:@"360sdk不支持模拟器，请在真机上调试。" descView:self.view];
#endif
        
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"敬请期待"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getMyProfile{
    NSString *uid= [Utilities getUniqueUid];
    
    if (uid) {
        // 登录成功后去服务器获取个人详细信息
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"view", @"op",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            if(true == [result intValue]) {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[msg objectForKey:@"profile"]];
                
                NSDictionary *vip = [msg objectForKey:@"vip"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                
                [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[msg objectForKey:@"role"]];

//                [Utilities doSaveUserInfoToDefaultAndSingle:[msg objectForKey:@"profile"] andRole:[msg objectForKey:@"role"]];
            } else {
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
}

//------------add by kate 2016.03.18-------------------------------------------------
// 我的消息红点检查接口
-(void)checkNewIconForMsgCenter{
    
    NSString *lastId_news = nil;
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    lastId_news = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyMsgLastId"];
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"MessageCenter",@"ac",
                          @"2",@"v",
                          @"checkNewMessage", @"op",
                          lastId_news, @"last",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSDictionary *messageDic = [respDic objectForKey:@"message"];
            
            NSString *last = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"last"]];
            
            if ([lastId_news integerValue] == 0) {
                
                [userDefaults setObject:last forKey:@"MyMsgLastId"];
                [userDefaults synchronize];
            }
            
            //存储我的消息红点数量
            NSString *count = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"count"]];
            [userDefaults setObject:count forKey:@"MyMsgNewCount"];
            [userDefaults synchronize];
            
            if ([@"0"  isEqual: count]) {
//                [super setRedPointHidden:YES];
            }else {
//                [super setRedPointHidden:NO];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leftViewReloadRedPoint" object:self userInfo:nil];
            }
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
}

//---检查意见反馈红点
-(void)checkNewFeedback{
    
    //lastIDForFeedback
    NSString *lastIDForFeedback = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastIDForFeedback"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([lastIDForFeedback length] > 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *flag = [FRNetPoolUtils isNewForFeedbackMsg:lastIDForFeedback];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                //                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
                //                UIImageView *imgV = (UIImageView*)[button viewWithTag:224];
                
                //isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];//原检查新版本存储
                
                if ([flag intValue] > 0) {
//                    [super setRedPointHidden:NO];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftViewReloadRedPoint" object:self userInfo:nil];
                    
                    NSString *isNewFeedback = @"1";
                    [userDefaults setObject:isNewFeedback forKey:@"isNewFeedback"];
                    [userDefaults synchronize];
                    
                }else{
//                    [super setRedPointHidden:YES];
                    
                    NSString *isNewFeedback = @"0";
                    [userDefaults setObject:isNewFeedback forKey:@"isNewFeedback"];
                    [userDefaults synchronize];//意见返回存储
                }
                
                /*if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1){
                 NSLog(@"1");
                 if (imgV) {
                 
                 }else{
                 
                 [noticeImgVForMsg removeFromSuperview];
                 [button addSubview:noticeImgVForMsg];
                 //noticeImgVForMsg.hidden = YES;
                 }
                 
                 }else {
                 
                 [noticeImgVForMsg removeFromSuperview];
                 [_settingImgView removeFromSuperview];
                 }*/
                
            });
            
        });
        
    }
    
}


// 构造红点数组
-(void)buildRedArray:(NSMutableArray*)array{
    
    if ([array count] != [redImgArray count]) {
        
        [redImgArray removeAllObjects];
        if (!redImgArray) {
            redImgArray = [[NSMutableArray alloc] init];
            
        }
        for (int i=0; i<[array count]; i++) {
            
            [redImgArray addObject:@"0"];
            
        }
        
    }else{
        
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
            
        }
        //    else{
        //
        //        for (int i=0; i<[redImgArray count]; i++) {
        //
        //            [redImgArray replaceObjectAtIndex:i withObject:@"0"];
        //
        //        }
        //    }
        
    }
    
}

-(void)updateRedPoint:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"school"];
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *schoolLastDicDefault = [allLastIdDic objectForKey:@"schoolLastDicDefault"];//old
        
        if ([schoolLastDicDefault count] > 0){
            
            [noticeImgVForMsg removeFromSuperview];
            //            for (int i=0; i<[customizeModuleList count]; i++) {
            //                UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+i)];
            //                [newView removeFromSuperview];
            //            }
            
            for (int i=0; i<[array count]; i++) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                
                //NSString *type = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"type"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",@"0",mid];
                
                NSString *lastFiltered = [NSString stringWithFormat:@"%@",[schoolLastDicDefault objectForKey:keyStr]];
                
                
                if ([last integerValue] > [lastFiltered integerValue]) {
                    
                    for (int i=0; i<[_moduleAry count]; i++) {
                        
                        NSString *moudleId = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"id"]];
                        //NSString *type = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"type"]];
                        
                        // 3.0 校园公告 通讯录 显示红点
                        
                        if ([mid integerValue] == [moudleId integerValue]) {
                            
                            //                                NSInteger index = -1;
                            //
                            //                                for (int i = 0; i<[_moduleAry count]; i++) {
                            //
                            //                                    NSString *localType = [[_moduleAry objectAtIndex:i] objectForKey:@"type"];
                            //
                            //                                    if ([type isEqualToString:localType]) {
                            //                                        index = i;
                            //                                    }
                            //
                            //                                }
                            //
                            //                                if (index!=-1) {
                            
                            NSInteger index = i;
                            
                            [redImgArray replaceObjectAtIndex:index withObject:@"1"];
                            [noticeImgVForMsg removeFromSuperview];
                            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                            UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                            [button addSubview:noticeImgVForMsg];
                            
                            //}
                            
                        }
                        
                    }
                }else{
                    
                    for (int i=0; i<[_moduleAry count]; i++) {
                        
                        NSString *moudleId = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"id"]];
                        //NSString *type = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"type"]];
                        
                        if ([moudleId integerValue] == [mid integerValue]) {
                            
                            //                            NSInteger index = -1;
                            //
                            //                            for (int i = 0; i<[_moduleAry count]; i++) {
                            //
                            //                                NSString *localType = [[_moduleAry objectAtIndex:i] objectForKey:@"type"];
                            //
                            //                                if ([type isEqualToString:localType]) {
                            //                                    index = i;
                            //                                }
                            //
                            //                            }
                            //
                            //                            if (index!=-1){
                            
                            NSInteger index = i;
                            
                            [redImgArray replaceObjectAtIndex:index withObject:@"0"];
                            //}
                            
                        }
                        
                        
                    }
                }
                
            }
            
            
            [self performSelector:@selector(showRedPoint) withObject:nil afterDelay:0.01];
            
            //[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        }
        
    }
    [self addNewCount];
}

-(void)showRedPoint{
    
    TSImageSelectView *msv = [_modulesView viewWithTag:110];
    
    for (int i=0; i< [_moduleAry count]; i++){
        
        TSTouchImageView *mv = [msv viewWithTag:210+i];
        
        float w =  [Utilities convertPixsW:40];
        
        NSLog(@"width[%d]:%f",i,mv.frame.size.width);
        
        UIImageView *newImgV = [mv viewWithTag:i+320];
        
        if (!newImgV){
            
            newImgV = [[UIImageView alloc]initWithFrame:CGRectMake((mv.frame.size.width - w)/2.0 + w-5, 13, 10, 10)];
            newImgV.image = [UIImage imageNamed:@"icon_new"];
            newImgV.tag = i+320;
            
        }
        
        //NSLog(@"isRed:%@",[redImgArray objectAtIndex:i]);
        
        if ([[redImgArray objectAtIndex:i] isEqualToString:@"1"]) {
            
            if (![mv viewWithTag:i+320]) {
                [mv addSubview:newImgV];
            }
            
            
        }else{
            
            [newImgV removeFromSuperview];
        }
        
    }
    
    
}

-(void)checkNewsIcon:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    if (dic) {
        
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
        
        isFirst = NO;//2015.12.28 大退红点修改
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSLog(@"新红点check接口返回:%@",dic);
            
            if (dic) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"alwaysNewsDic"];
                [userDefaults synchronize];//存贮实时的最新的last
                
                newsDic = [[NSDictionary alloc] initWithDictionary:dic];
                
                [self updateRedPoint:dic];
            }
            
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

-(void)addNewCount{
    
    int index = 0;
    for (int i=0; i<[_moduleAry count]; i++) {
        
        NSDictionary *dic = [_moduleAry objectAtIndex:i];
        NSString *type = [dic objectForKey:@"type"];
        //NSString *moduleStr = [dic objectForKey:@"module"];
        //NSString *name = [dic objectForKey:@"name"];
        
        if ([type intValue] == 10) {
            index = i;
        }
        
    }
    
    //[iconNoticeForMsg removeFromSuperview];
    
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
    NSString *sql = [NSString stringWithFormat:@"select * from msgListMix where uid = %lli",[uid longLongValue]];
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    
    //[[DBDao getDaoInstance] CreateMixListTable];//to do :版本处理
    
    int userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
        //NSLog(@"objectDict:%@",objectDict);
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoMix_%lli_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"gid"] longLongValue],[[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
    }
    
    NSString *countAll = [NSString stringWithFormat:@"%d",count];
    NSInteger totalMsgCount = [countAll integerValue];
    
    //totalMsgCount = 5;//测试代码
    
    if(totalMsgCount > 0){
        
        //to do:
        TSTouchImageView *mv = [_moduleSelectView viewWithTag:210+index];
        float w =  [Utilities convertPixsW:40];
        
        NSLog(@"width:%f",mv.frame.size.width);
        
        if (totalMsgCount > 99) {
            redLabelForMsg.text = @"...";
        }else{
            redLabelForMsg.text = [NSString stringWithFormat:@"%ld",(long)totalMsgCount];
        }
        
        NSInteger length = [redLabelForMsg.text length];
        
        if ([@"..." isEqualToString:redLabelForMsg.text]) {
            redLabelForMsg.frame = CGRectMake((mv.frame.size.width - w)/2.0 + w-8.0, 4, 2*15, 20);
        }else{
            if (length == 1) {
                redLabelForMsg.frame = CGRectMake((mv.frame.size.width - w)/2.0 + w-8.0, 4, 20, 20);
            }else{
                redLabelForMsg.frame = CGRectMake((mv.frame.size.width - w)/2.0 + w-8.0, 4, length*15, 20);
            }
        }
        
        
        [mv addSubview:redLabelForMsg];
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
        
        if ([button viewWithTag:600]) {
            
        }else{
            
            [noticeImgVForMsgTab removeFromSuperview];
            [button addSubview:noticeImgVForMsgTab];
        }
        
    }else{
        
        [redLabelForMsg removeFromSuperview];
        [noticeImgVForMsgTab removeFromSuperview];
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalMsgCount];
    
}

//------------------------------------------------------------------------------

@end

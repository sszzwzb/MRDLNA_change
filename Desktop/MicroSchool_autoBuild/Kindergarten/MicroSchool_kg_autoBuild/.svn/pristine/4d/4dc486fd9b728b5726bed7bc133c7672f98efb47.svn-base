//
//  ParksHomeViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ParksHomeViewController.h"
#import "MessageCenterViewController.h"
#import "MomentsViewController.h"
#import "MyPointsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "SettingViewController.h"
#import "GrowthNotValidateViewController.h"
#import "MyQRCodeViewController.h"
#import "ParenthoodListForParentTableViewController.h"
#import "ChildViewController.h"
#import "WWSideslipViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "SetPersonalViewController.h"
#import "SwitchChildViewController.h"
#import "GrowVIPViewController.h"
@interface ParksHomeViewController ()<ShowLeftOrRightView>{
    TSTapGestureRecognizer *myTapGesture7;
     NSString *str;
    NSString *strNum;
}
@end
@implementation ParksHomeViewController

-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;

}

//#3.20
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeTitle:@"乐园"];
    [self setCustomizeLeftButtonWithImage:@""];
    
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//#3.31
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"select" object:nil];
     isRefresh = NO;
//实例化webView
//    webView =[UIWebView new];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT-90)];

    webView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview: webView];
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(0);
//        make.left.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-90));
//    }];
    webView.delegate =self;
    webView.scrollView.delegate = self;
//加载webview
    [self loadWebView];
//初始化refreshView，添加到webview 的 scrollView子视图中
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-webView.scrollView.bounds.size.height, webView.scrollView.frame.size.width, webView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [webView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi3" object:nil];
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeAddNoTouchView:) name:@"schoolHomeAddNoTouchView" object:nil];
    _maskView =[UIView new];
    [self.view addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture1.infoStr = @"0";
    [_maskView addGestureRecognizer:myTapGesture1];

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
//取主页面URL
-(void)loadWebView{
#if IS_TEST_SERVER
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://test.5xiaoyuan.cn/open/index.php/WebView/eden/index"]];
#else
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.5xiaoyuan.cn/open/index.php/WebView/eden/index"]];
#endif

    [webView loadRequest:request];
}
//每次刷新，通过webview与js交互获取当前页面url刷新
-(void)localUrl{
NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    [webView loadRequest:request];
}
//实例化Warning图片
-(void)loadwarnImg{
    CGRect rect = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    noDataView = [Utilities showNodataView:@"呀，网络好像有点问题" msg2:nil andRect:rect imgName:@"网络不给力空白页_03.png"];
    [webView addSubview:noDataView];
}
-(void)viewWillAppear:(BOOL)animated{
//#4.1  此处代码为了解决偶尔点击左侧页面无反应的bug，无反应的原因是在left页面取不到NSUserDefaults里CHOOSE的值,无法进行判断。现在我在4个页面1.SchoolHome 2.MyclassList 3.ParkHome 4.MyclassDetail 的viewWillAppear方法传值，这样就解决了这个问题。
    NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
    [choose setObject:@"3" forKey:@"CHOOSE"];
    
    NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
    NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
        [super setRedPointHidden:NO];
    }else {
        [super setRedPointHidden:YES];
    }

    [super viewWillAppear:YES];
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = YES;
    self.view.userInteractionEnabled = YES;
    reflashFlag = 1;
    isRefresh = NO;
    [MyTabBarController setTabBarHidden:NO];
     myTapGesture7 = [[TSTapGestureRecognizer alloc]init];
     myTapGesture7.infoStr = @"0";
}
-(void)viewDidDisappear:(BOOL)animated{
   self.view.userInteractionEnabled = NO;
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
//网页开始加载代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _reloading = YES;
    noDataView.hidden = YES;
}
//网页加载完成代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
//#4.1 wb代理方法里判断，根据是否可以goback判断子页面，如果是子页面重新setFrame解决子页面下方白条问题，同时通过与js交互获取当前页面的title。调用setBackImage方法将左上角图片修改为返回图片，隐藏TabBar。
    if([webView canGoBack]){
//       [webView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-64));
        }];
        NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
        rt.pan.enabled = NO;
        [self setCustomizeTitle:title];
        [super setRedPointHidden:YES];
    [MyTabBarController setTabBarHidden:YES];
        [self setBackImage:@"back.png"];
    }else {
//#4.1   如果是主页面，显示TabBar，重新setFrame，获取当面页面title。
    [MyTabBarController setTabBarHidden:NO];
    [self setCustomizeLeftButtonWithImage:@""];
//        [webView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT-90)];
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-90));
        }];
        NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
        NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
        NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
        
        if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
            [super setRedPointHidden:NO];
        }else {
            [super setRedPointHidden:YES];
        }
         NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
        [self setCustomizeTitle:title];

        rt.pan.enabled = YES;
    }
    _reloading = NO;
     [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
    [noDataView removeFromSuperview];
    
}
//网页加载出错时候显示网络不给力图片
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
    [self loadwarnImg];
    noDataView.hidden = NO;
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
    
    [webView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)testFinishedLoadData{
    
   
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:webView];
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
    }
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
//#4.1 刷新当面页面
        [self localUrl];
        
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
//#4.1   在leftVC点击cell后，本页面接受通知跳转时候，通知wws恢复主页面位置。
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
        rt.pan.enabled = NO;
        if ([userType integerValue] == 7) {//教师
            [ReportObject event:ID_CLICK_MYPOINT_TEACHER];
        }else if ([userType integerValue] == 9){//管理员
            [ReportObject event:ID_CLICK_MYPOINT_ADMIN];
        }
        
        MyPointsViewController *myPoint = [[MyPointsViewController alloc]init];
        //        myPoint.titleName = name;
        myPoint.titleName = @"我的积分";
        [self.navigationController pushViewController:myPoint animated:YES];
        
    }else if ([select.userInfo[@"num"]isEqualToString:@"4"]){//学校二维码
       [self goRight];
        rt.pan.enabled = NO;
        [MyTabBarController setTabBarHidden:YES];

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
        settingView.isNewVersion = isNewVersion;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#4.1  左上角点击事件。判断如果是子页面，点击就是返回效果。否则就是显示左划。
-(void)selectLeftAction:(id)sender{
    if([webView canGoBack]){
    
        [webView goBack];
    }else {
//    myTapGesture7 = (TSTapGestureRecognizer *)sender;
//#4.1  此处为解决左划时产生错位的问题。代码拿掉了原来在tab里通过代理控制leftorright，现在统一用通知在wws里控制，每次显示main以后，重置scalef为零。
    if ([@"0"  isEqual: myTapGesture7.infoStr]) {
        NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
        [choose setObject:@"3" forKey:@"CHOOSE"];
        myTapGesture7.infoStr = @"1";
        _maskView.hidden = NO;
        strNum =@"1";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
}
@end

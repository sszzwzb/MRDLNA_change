//
//  MyClassDetailViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MyClassDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MomentsDetailViewController.h"
#import "MyClassListViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "ClassDiscussViewController.h"
#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "SetPersonalViewController.h"
#import "MemberListViewController.h"
#import "EditClassProfileViewController.h"
#import "ClassListViewController.h"
#import "NewClassPhotoViewController.h"
#import "MyTabBarController.h"
#import "MyPointsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "ChildViewController.h"
#import "ParenthoodListForParentTableViewController.h"
#import "PhotoClassHomeViewController.h"
#import "AddClassApplyViewController.h"
#import "SwitchChildViewController.h"
#import "GrowVIPViewController.h"
#import "NoCardViewController.h"
#import "MyCheckinHome.h"
#import "SignStatisticsViewController.h"
#import "Camera360ViewController.h"

#define moduleCount 4

@interface MyClassDetailViewController (){
    NSString *str;
    NSString *strNum;
    TSTapGestureRecognizer *myTapGesture7;
}

@end

@implementation MyClassDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkNewsIcon:)
                                                     name:@"reLoadClassDetailNews"
                                                   object:nil];//2015.11.12
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake((107.0-25)/2.0+20, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 456;
        
    }
    return self;
}
//#3.20
-(void)selectLeftAction:(id)sender{
    
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyClassListViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
//#3.31 此处为解决左划时产生错位的问题。代码拿掉了原来在tab里通过代理控制leftorright，现在统一用通知在wws里控制，每次显示main以后，重置scalef为零。
        myTapGesture7 = (TSTapGestureRecognizer *)sender;
        if ([@"0"  isEqual: myTapGesture7.infoStr]) {
            NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
            [choose setObject:@"4" forKey:@"CHOOSE"];
            myTapGesture7.infoStr = @"1";
            strNum =@"1";
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
             _maskView.hidden = NO;
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
        //        myPoint.titleName = name;
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
//        vc.hidesBottomBarWhenPushed = YES;
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
//                              _cId, @"cid",
//                              app,@"app",
//                              nil];
//        vc.innerLinkReqData = data;
        vc.VIPUrl = select.userInfo[@"payUrl"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeTitle:@"班级"];
    //#3.31
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"select" object:nil];
    
    if([_fromName isEqualToString:@"tab"]){
        
        [self setCustomizeLeftButtonWithImage:@""];
    }else{
        
       [self setCustomizeLeftButton]; 
    }
    
    moduleNameArray = [[NSArray alloc] initWithObjects:@"班级相册",@"班级点滴",@"班级圈",@"成长空间",@"请假", nil];
  
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    //messageDic = [[NSDictionary alloc] init];
     NSMutableDictionary *dic0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"班级公告",@"title",@"ClassKin/bjgg.png",@"imgName",@"14",@"type", nil];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"班级相册",@"title",@"ClassKin/bjxc.png",@"imgName",@"35",@"type", nil];
     NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"班级点滴",@"title",@"ClassKin/bjdd.png",@"imgName",@"13",@"type", nil];
     NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"班级圈",@"title",@"ClassKin/bjq.png",@"imgName",@"19",@"type", nil];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"成长空间",@"title",@"ClassKin/czkj.png",@"imgName",@"26",@"type", nil];
    if ([usertype integerValue] == 0 || [usertype integerValue] == 6){
        
    }else{//老师的成长空间管理
        
        
          dic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"成长空间",@"title",@"ClassKin/czkj.png",@"imgName",@"29",@"type", nil];
    }
   
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"请假",@"title",@"ClassKin/qj.png",@"imgName",@"30",@"type", nil];

    
   moduleArray = [[NSMutableArray alloc] initWithObjects:dic0,dic1,dic2,dic3,dic4,dic5,nil];
    
    [self createBar];
    
    [self doShowContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi4" object:nil];
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolHomeAddNoTouchView:) name:@"schoolHomeAddNoTouchView" object:nil];
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 640)];
    TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture1.infoStr = @"0";
    _maskView.hidden = YES;
    [_maskView addGestureRecognizer:myTapGesture1];
    [self.view addSubview:_maskView];
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
   
}
-(void)img_btnclick:(id)sender{
    
    //    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    myTapGesture7.infoStr = @"0";
    if ([self.nextNum isEqualToString:@"1"]) {
        
    }else{
//#3.31  此处代码的作用是，主页面处于左划状态的时候，点击主页面通知wws恢复主页面位置。
        strNum =@"2";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:strNum,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi5" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)createBar{
    
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    barView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:224.0/255.0 blue:147.0/255.0 alpha:1];
    
    barTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, [UIScreen mainScreen].bounds.size.width - 30.0, 30.0)];
    barTitleLab.font = [UIFont systemFontOfSize:12.0];
    barTitleLab.textColor = [UIColor colorWithRed:252.0/255.0 green:83.0/255.0 blue:11.0/255.0 alpha:1];
    barTitleLab.textAlignment = NSTextAlignmentCenter;
    barTitleLab.backgroundColor = [UIColor clearColor];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, 0, barView.frame.size.width, barView.frame.size.height);
    [clickBtn addTarget:self action:@selector(gotoBindView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30.0, 0.0, 30.0, 30.0);
    [closeBtn setImage:[UIImage imageNamed:@"closeBg.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"closeBg.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeUnbindBar) forControlEvents:UIControlEventTouchUpInside];
    
    
    [barView addSubview:barTitleLab];
    [barView addSubview:clickBtn];
    //[barView addSubview:closeBtn];
    
    return barView;
}

-(void)viewWillAppear:(BOOL)animated{
//#4.1  此处代码为了解决偶尔点击左侧页面无反应的bug，无反应的原因是在left页面取不到NSUserDefaults里CHOOSE的值,无法进行判断。现在我在4个页面1.SchoolHome 2.MyclassList 3.ParkHome 4.MyclassDetail 的viewWillAppear方法传值，这样就解决了这个问题。
    NSUserDefaults *choose = [NSUserDefaults standardUserDefaults];
    [choose setObject:@"4" forKey:@"CHOOSE"];
    
    if([_fromName isEqualToString:@"tab"]){
     
        [self dismissKeyboard:nil];
        [self setCustomizeLeftButtonWithImage:@""];
    }else{
        
        [self setCustomizeLeftButton];
    }

    NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
    NSString *isNewForVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    NSString *isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    
    if (([isNewFeedback intValue] == 1) || ([isNewForVersion intValue] == 1) || (isNewForMsg!=nil && [isNewForMsg intValue] >= 1)) {
        [super setRedPointHidden:NO];
    }else {
        [super setRedPointHidden:YES];
    }

    self.view.userInteractionEnabled = YES;
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;

    [super viewWillAppear:animated];
     myTapGesture7 = [[TSTapGestureRecognizer alloc]init];
     myTapGesture7.infoStr = @"0";
    
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyClassListViewController class]]) {

        rt.pan.enabled = NO;
    
    }else{
        [MyTabBarController setTabBarHidden:NO];
        rt.pan.enabled = YES;
        
    }
    
    if ([messageDic count] > 0) {
       
        [self loadData];
        
    }else{
      
        [self getData];
        
    }
    
    reflashFlag = 1;
    
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
-(void)viewDidDisappear:(BOOL)animated{

 self.view.userInteractionEnabled = NO;
}
-(void)getData{
    
    NSLog(@"myClassDetail getdata");
    [Utilities showProcessingHud:nil];
    [self loadData];
}

-(void)doShowContent{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    self.view = view;
    
    scrollView = [UIScrollView new];
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为0
        make.top.equalTo(self.view.mas_top).with.offset(0);
        
        // 距离屏幕左边距为20
        make.left.equalTo(self.view.mas_left).with.offset(0);
        
        make.bottom.equalTo(self.view).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, [Utilities getScreenSize].height - 64));
    }];
    
    viewWhiteBg = [UIView new];
    viewWhiteBg.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(_scrollViewBg);
        make.edges.equalTo(scrollView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
        make.width.equalTo(scrollView);
    }];

    moduleView = [UIView new];
    moduleView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:moduleView];
    //模块view的约束
    
    [moduleView mas_makeConstraints:^(MASConstraintMaker *make){
       
        // 距离屏幕上边距为80
        make.top.equalTo(viewWhiteBg.mas_top).with.offset(15.0);
        // 距离屏幕左边距为20
        make.left.equalTo(viewWhiteBg.mas_left).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 164.0));
        
    }];
    
    newPhotoSection = [UIView new];
    [scrollView addSubview:newPhotoSection];
    //最新照片section title的约束
    [newPhotoSection mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(moduleView.mas_bottom).with.offset(17.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(moduleView).with.offset(0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 17.0));
    }];
    

    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"最新照片";
    titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [newPhotoSection addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(newPhotoSection).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(newPhotoSection).with.offset(10.0);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-20.0, 17.0));
    }];

    
    UIView *greenMarkV = [UIView new];
    greenMarkV.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
    [newPhotoSection addSubview:greenMarkV];
    [greenMarkV mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(newPhotoSection).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(newPhotoSection).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake(3.0, 17.0));
    }];

    newPhotoView = [UIView new];
    //newPhotoView.backgroundColor = [UIColor redColor];//测试代码
    [scrollView addSubview:newPhotoView];
    //显示照片view的约束
    [newPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(newPhotoSection.mas_bottom).with.offset(7.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(newPhotoSection).with.offset(0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 412.0));
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(newPhotoView.mas_bottom).with.offset(20);
    }];
    
    
    //refreshHeaderView
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    // mark 用Masonry时候 如果在scrollView上加下拉刷新 那么刷新控件的宽度请设置成scrollview的宽度
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                              CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                         scrollView.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [scrollView addSubview:_refreshHeaderView];

}

// 自定义弹出框展示
-(void)showCustomAlert:(NSString*)msg buttonTitle:(NSString*)btnTitle imgName:(NSString*)name{
    
    if (!bgV) {
        
        bgV = [UIView new];
        bgV.tag = 333;
        bgV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"customAlert/commonBg.png"]];
    
    }
    
    if (![self.view viewWithTag:333]) {
        
        [self.view addSubview:bgV];
        
        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view).with.offset(0);
            
            make.left.equalTo(self.view).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 48 - 64));
        }];
    }
    
    UIImageView *alertBgImgV = [UIImageView new];
    alertBgImgV.image = [UIImage imageNamed:name];
    alertBgImgV.userInteractionEnabled = YES;
    [bgV addSubview:alertBgImgV];

    [alertBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgV).with.offset(([UIScreen mainScreen].bounds.size.height - 48.0 - alertBgImgV.image.size.height)/2.0 - 44.0);
        
        make.left.equalTo(bgV).with.offset(([UIScreen mainScreen].bounds.size.width - alertBgImgV.image.size.width)/2.0 );
        
        make.size.mas_equalTo(CGSizeMake(alertBgImgV.image.size.width, alertBgImgV.image.size.height));
        
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
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

// 点击立即加入或完善信息
-(void)alertClick:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    NSLog(@"button.title:%@",button.titleLabel.text);
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
    NSString *iden;
    
    switch ([usertype integerValue]) {
        case 0:
            iden = @"student";
            break;
        case 6:
            iden = @"parent";
            break;
        case 7:
            iden = @"teacher";
            break;
        case 9:
            iden = @"admin";
            break;
            
        default:
            break;
    }
   
    if ([button.titleLabel.text isEqualToString:@"完善信息"]) {
        
        //在班级内 直接跳转至完善信息页
        AddClassApplyViewController *personalViewCtrl = [[AddClassApplyViewController alloc] init];
        personalViewCtrl.iden = iden;
        personalViewCtrl.viewType = @"classDetail";
        personalViewCtrl.titleName = @"用户信息完善";
        personalViewCtrl.cId = _cId;
        [self.navigationController pushViewController:personalViewCtrl animated:YES];;
        
    }else if ([button.titleLabel.text isEqualToString:@"立即加入"]){
        
        // 去h5页支付
        NSString *payUrl = [[messageDic objectForKey:@"vip"] objectForKey:@"payUrl"];
        
        GrowVIPViewController *growthVIPV = [[GrowVIPViewController alloc] init];
        growthVIPV.VIPUrl = payUrl;
        [self.navigationController pushViewController:growthVIPV animated:YES];
        
    }
    
    [MyTabBarController setTabBarHidden:YES];
    
}


-(void)loadData{
    
    /**
     * 幼儿园班级首页
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classHome sid= cid= uid= app=
     */
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classHome", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:nil];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级详情:%@",respDic);
            
            messageDic = [[NSDictionary alloc]initWithDictionary:[respDic objectForKey:@"message"]];
            
            NSString *admin = [messageDic objectForKey:@"admin"];
            NSString *isQuit = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"quit"]];//是否退出了班级
            
            if([_fromName isEqualToString:@"ClassList"]){
                
            }else{
                [self setCustomizeRightButton:@"icon_more.png"];
            }
            
            if ([isQuit integerValue] == 1){//退出了 add 2015.10.21
                //if ([@"6" isEqualToString:usertype] || [@"0" isEqualToString:usertype]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
                // }
                //-----add by kate for beck----------------------------------
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                [userDetail setObject:@"0" forKey:@"role_cid"];
                
                [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //-----------------------------------------------------------
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];

                if([_fromName isEqualToString:@"tab"]){
                    
                    MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
                    myClass.hidesBottomBarWhenPushed = YES;
                    UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
                    
                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                    [array replaceObjectAtIndex:1 withObject:customizationNavi];
                    [appDelegate.tabBarController setViewControllers:array];
                    
                    
                }else{
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                    
                    UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已退出班级" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alerV.tag = 345;
                    [alerV show];

                }
                
            }else{
                
                if([admin intValue] == 1){
                    
                    _isAdmin = YES;
                }else{
                    _isAdmin = NO;
                }

                NSDictionary *class = [messageDic objectForKey:@"profile"];
                NSString *clasStr = [Utilities replaceNull:[class objectForKey:@"classname"]];
                ((UILabel *)self.navigationItem.titleView).text = clasStr;
                
                spaceForClass = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"space"]];//班级是否有学籍
                unbindIntroduceUrl = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"number_url"]];//老师身份班级未绑定学籍介绍页url
                isNumber = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"number"]];//是否绑定
                
                statusForSpace = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"status"]];//是否绑定;
                
                moduleFromServer = [[NSMutableArray alloc] initWithArray:[messageDic objectForKey:@"modules"] copyItems:YES];
                
                //[self addMoudelView];
                
                [self buildRedArray:moduleFromServer];//构造红点数组
                if (_newsDic) {
                    [self updateRedPoint:_newsDic];// 检查new标记
                }else{
                    [self checkNewsIcon];// 检查new标记
                }
                
                if (galleriesArray) {
                    
                    for (int i=0; i<[galleriesArray count]; i++) {
                        
                        UIImageView *tempImgV = [newPhotoView viewWithTag:110+i];
                        [tempImgV removeFromSuperview];
                        
                    }
                    
                }
                
                galleriesArray = [[NSMutableArray alloc] initWithArray:[[messageDic objectForKey:@"galleries"] objectForKey:@"list"] copyItems:YES];
                
                //galleriesArray = [[NSMutableArray alloc] init];//测试代码
                
                if ([galleriesArray count] == 0) {
                    
                    //无照片空白页
                    [noDataView removeFromSuperview];
                    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - newPhotoSection.frame.size.height - newPhotoSection.frame.origin.y);
                    noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png" textColor:[UIColor grayColor] startY:0.0];
                    [newPhotoView addSubview:noDataView];
                    
                    [newPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(newPhotoSection.mas_bottom).with.offset(12.0);
                        
                        make.left.equalTo(newPhotoSection).with.offset(0);
                        
                        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, rect.size.height));
                    }];
                    
                    
                }else{
                    
                    [noDataView removeFromSuperview];
                    
                    [self addPhoto];
                }
                
                //教师端提示添加学籍信息
                if ([spaceForClass integerValue] == 1) {
                
                    if((UserType_Student == [Utilities getUserType]) ||
                                           (UserType_Parent == [Utilities getUserType])){
                        
                        if ([isNumber integerValue] == 0) {
                            
//                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                            BOOL isShowPopViewForClass = [userDefaults boolForKey:@"isShowPopViewForClass"];
//                            if (isShowPopViewForClass) {
//                                //弹出提示框 取消 绑定
//                                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未绑定学籍信息，无法使用成长空间" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"暂不绑定", nil];
//                                alertV.tag = 126;
//                                [alertV show];
//                            }
#if 0
                            barTitleLab.text = @"点击完成身份认证，体验更多功能!";
                            [self addUnbindBar];
#endif
                           
                            
                        }else{
                            
                            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                            WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
                            rt.pan.enabled = NO;
#if 0
                            [self closeUnbindBar];
#endif
                            
                        }
                    }
                    
                }else{
                    
#if 0 //老师的黄条也不要了 tony确认 2016.07.21
                     barTitleLab.text  = @"您的班级还未添加认证信息。";
                    
                    [self addUnbindBar];
#endif
                    
                }
                
            
                if((UserType_Student == [Utilities getUserType]) ||
                   (UserType_Parent == [Utilities getUserType])){
                    
                    if ([isNumber integerValue] == 0) {
                        
                        //done:显示 "简单动动手指，让班级功能同学更了解你吧！"的提示
                        // 点击"完善信息"去完善信息页
                        [self showCustomAlert:@"简单动动手指，\n让班级同学更了解你吧!" buttonTitle:@"完善信息" imgName:@"customAlert/alert_bindBg.png"];
                        
                    }else{
                        
                        [bgV removeFromSuperview];
                        
                        NSDictionary *vipDic = [messageDic objectForKey:@"vip"];
                        
                        // 学校是否开通了VIP
                        BOOL open = [[NSString stringWithFormat:@"%@",[vipDic objectForKey:@"schoolEnabled"]] boolValue];
                        
                        if (open) {
                            
                           NSInteger state = [[NSString stringWithFormat:@"%@",[vipDic objectForKey:@"state"]] integerValue];
                       
                            //以下state状态为猜测
                            if (state == 0 || state == 3 || state == 4) {//未开通/到期
                             
                            [self closeUnbindBar];    
                            [self showCustomAlert:@"快加入成长VIP伐木累,\n与其他童鞋一起嗨皮吧!" buttonTitle:@"立即加入" imgName:@"customAlert/alert_vipBg.png"];
                                
                            }else{
                                
                                [bgV removeFromSuperview];
                                
                                if (state == 5 || state == 2){//快到期 试用 显示黄条 经纬确认 2016.07.26
                                    
                                    barTitleLab.text = [vipDic objectForKey:@"message"];
                                    [self addUnbindBar];
                                    
                                }else{//正常 试用
                                    
                                    [self closeUnbindBar];
                                }
                            }
                          
                            
                        }else{
                            
                            [bgV removeFromSuperview];
                            [self closeUnbindBar];
                            
                        }
                    
                    }
                }
            
            }
         
        }else{
            
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
       
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
       
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:nil];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];

}


-(void)selectRightAction:(id)sender
{
    NSDictionary *user = [g_userInfo getUserDetailInfo];
  
    NSString *usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];

    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
    
    //usertype = @"9";//测试代码
    
    if (_isAdmin) {
        
        if ([usertype integerValue] == 9) {
            
          tagArray = [[NSMutableArray alloc] initWithObjects:@"加入班级",@"编辑资料",@"成员管理",@"管理员设置",@"退出班级", nil];
            
        }else if([usertype integerValue] == 0 || [usertype integerValue] == 6){
            
            tagArray = [[NSMutableArray alloc] initWithObjects:@"编辑资料",@"成员管理",@"退出班级", nil];
            
        }else{
            
            tagArray = [[NSMutableArray alloc] initWithObjects:@"加入班级",@"编辑资料",@"成员管理",@"退出班级", nil];
        }
        
    }else{
        
        if([usertype integerValue] == 0 || [usertype integerValue] == 6){
            
             tagArray = [[NSMutableArray alloc] initWithObjects:@"退出班级", nil];
            
        }else if ([usertype integerValue] == 9){
            
             tagArray = [[NSMutableArray alloc] initWithObjects:@"加入班级",@"管理员设置",@"退出班级", nil];
            
        }else{
            
            tagArray = [[NSMutableArray alloc] initWithObjects:@"加入班级",@"退出班级", nil];
            
        }
       
    }
    
    if (!isRightButtonClicked) {
        
        
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 112 - 10,
                                                                          5,
                                                                          112,
                                                                          30.0*[tagArray count]+7)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        
        if ([tagArray count] < 2) {
                 [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_one.png"]];
        }else{
                [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_more.png"]];
        }
   
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        for (int i=0; i<[tagArray count]; i++) {
            
            //NSDictionary *tagDic = [tagArray objectAtIndex:i];
            //NSString *tagId = [NSString stringWithFormat:@"%@",[tagDic objectForKey:@"id"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 600+i;
            button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+7+(35.0-5.0)*i, 112, 35.0-5.0);
            [button setTitle:[tagArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[tagArray objectAtIndex:i] forState:UIControlStateHighlighted];
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
   
    NSString *name = [tagArray objectAtIndex:i];
    if ([@"加入班级" isEqualToString:name]) {
        
        ClassListViewController *classListV = [[ClassListViewController alloc] init];
        classListV.viewType = @"classDetail";
        [self.navigationController pushViewController:classListV animated:YES];
        [MyTabBarController setTabBarHidden:YES];
        
    }else if ([@"编辑资料" isEqualToString:name]){
        
        EditClassProfileViewController *editV = [[EditClassProfileViewController alloc] init];
        editV.cId = _cId;
        [self.navigationController pushViewController:editV animated:YES];
        
    }else if ([@"成员管理" isEqualToString:name]){
        
        MemberListViewController *memberV = [[MemberListViewController alloc]init];
        memberV.cId = _cId;
        memberV.titleName = @"成员管理";
        [self.navigationController pushViewController:memberV animated:YES];
        
    }else if ([@"管理员设置" isEqualToString:name]){
        
        SetAdminMemberListViewController *setAdminLV = [[SetAdminMemberListViewController alloc]init];
        setAdminLV.cId= _cId;
        [self.navigationController pushViewController:setAdminLV animated:YES];
        
    }else if ([@"退出班级" isEqualToString:name]){
        
       NSString *msg = @"您确定要退出该班级？";
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        if ([usertype isEqualToString:@"6"]) {
           msg = @"您退出班级后,将与当前子女解绑.是否确认退出班级?";
        }
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消",nil];
        alert.tag = 122;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122) {
        
        if (buttonIndex == 0) {
            
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            if ([usertype isEqualToString:@"6"]||[usertype isEqualToString:@"0"]) {
                [self quit2];
            }else{
              [self quit];
            }
            
            [ReportObject event:ID_QUIT_CLASS];//2015.06.24
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
        }else{
            
        }
    }else if (alertView.tag == 126){
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
        NSString *iden;
        
        switch ([usertype integerValue]) {
            case 0:
                iden = @"student";
                break;
            case 6:
                iden = @"parent";
                break;
            case 7:
                iden = @"teacher";
                break;
            case 9:
                iden = @"admin";
                break;
                
            default:
                break;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (buttonIndex == 0) {
            
            [MyTabBarController setTabBarHidden:YES];
            
            //在班级内 直接跳转至完善信息页
            AddClassApplyViewController *personalViewCtrl = [[AddClassApplyViewController alloc] init];
            personalViewCtrl.iden = iden;
            personalViewCtrl.viewType = @"classDetail";
            personalViewCtrl.titleName = @"用户信息完善";
            personalViewCtrl.cId = _cId;
            [self.navigationController pushViewController:personalViewCtrl animated:YES];;
            
//            SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
//            
//            setPVC.viewType = @"classDetail";
//            setPVC.cId = _cId;
//            setPVC.iden = iden;
//            [self.navigationController pushViewController:setPVC animated:YES];
            
        }
        
        //[userDefaults setBool:NO forKey:@"isShowPopViewForClass"];
        
    }else if (alertView.tag == 345){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)quit2{
    
    //Chenth 6.25
    //这是家长身份退班时候走的接口
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* student_numberID= [NSString stringWithFormat:@"%@", [user objectForKey:@"student_number_id"]];
    NSLog(@"myClassDetail quit2");
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          //                          REQ_URL, @"url",
                          @"4",@"v",
                          @"StudentIdBind",@"ac",
                          @"exitClass", @"op",
                          _cId,@"cid",
                          student_numberID,@"childNumberId",
                          nil];
    
    //    NSLog(@"data:%@",data);
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
     
        [Utilities dismissProcessingHud:self.view];
        //以下为以前的
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSString *msg = [respDic objectForKey:@"message"];
        
        if(true == [result intValue]) {
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            //            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            //if ([@"6" isEqualToString:usertype] || [@"0" isEqualToString:usertype]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
            // }
            //-----add by kate for beck----------------------------------
            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
            [userDetail setObject:@"0" forKey:@"role_cid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //-----------------------------------------------------------
            if([_fromName isEqualToString:@"tab"]){
                
                MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
                myClass.hidesBottomBarWhenPushed = YES;
                UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
                
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                [array replaceObjectAtIndex:1 withObject:customizationNavi];
                [appDelegate.tabBarController setViewControllers:array];
                
                //---2016.02.26----------------------------------------------------------------
                [noticeImgVForMsg removeFromSuperview];
                [noticeImgVForMsg removeFromSuperview];
                
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
                UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
                UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
                
                [detailImg removeFromSuperview];
                [listImg removeFromSuperview];
                //-------------------------------------------------------------------------------
                
                
            }else{
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            //--退出班级将原来班级详情页/班级列表页现有未读红点全部清空 赵经纬 李昌明 张昊天 确认 kate被迫修改 2016.02.26-----------
            
            //[self deleteTableForGroupMsg:_cId];//清空群聊红点消息
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *alwaysNewsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"alwaysNewsDic"]];
            NSArray *classArray = [alwaysNewsDic objectForKey:@"classes"];
            
            NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
            NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
            
            for (int i = 0 ; i<[classArray count]; i++) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                [classLastDicDefault setObject:last forKey:keyStr];
                
                
                
            }
            
            //            [Utilities showSuccessedHud:@"success" descView:nil];
            
            [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
            [userDefaults synchronize];
            
            NSArray *spacesArray = [alwaysNewsDic objectForKey:@"spaces"];
            NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
            
            for (int i = 0 ; i<[spacesArray count]; i++) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
                NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                [spaceLastDicDefault setObject:last forKey:keyStr];
                
                
            }
            
            [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
            [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
            [userDefaults synchronize];
            
            //        if ([[[responseObject objectForKey:@"message"] objectForKey:@"error"] isEqual:@"1"]) {
            //
            //            UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:[[responseObject objectForKey:@"message"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alerV show];
            //        }
            //                alerV.tag = 345;
            
            //-------------------------------------------------------------------------------------------------------
            NSString* usertype2= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            if (![usertype2 isEqualToString:@"0"]) {
                
                
                if ([[[[responseObject objectForKey:@"message"] objectForKey:@"error"] stringValue] isEqualToString:@"1"]) {
                    
                    
                    [Utilities showTextHud:[[responseObject objectForKey:@"message"] objectForKey:@"alert"] descView:self.view];
                    
                }else{
                    
                    [Utilities showTextHud:[[responseObject objectForKey:@"message"] objectForKey:@"alert"] descView:self.view];
                    
                }
            }else{
                //Chenth 6.28  kate 确认  弱提示不用提示 已经退了  用户已经用的很方便了
                
                [Utilities showTextHud:[[responseObject objectForKey:@"message"] objectForKey:@"alert"] descView:self.view];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
            
            
        } else {
            
            [Utilities showTextHud:msg descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

-(void)quit{
    
    // 调用退出班级接口
     NSLog(@"myClassDetail quit");
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils quitFromClass:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSDictionary *user = [g_userInfo getUserDetailInfo];
                NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                //if ([@"6" isEqualToString:usertype] || [@"0" isEqualToString:usertype]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
                // }
                //-----add by kate for beck----------------------------------
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                [userDetail setObject:@"0" forKey:@"role_cid"];
                
                [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //-----------------------------------------------------------
                if([_fromName isEqualToString:@"tab"]){
                    
                    MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
                    myClass.hidesBottomBarWhenPushed = YES;
                    UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
                    
                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                    [array replaceObjectAtIndex:1 withObject:customizationNavi];
                    [appDelegate.tabBarController setViewControllers:array];
                    
                    //---2016.02.26----------------------------------------------------------------
                    [noticeImgVForMsg removeFromSuperview];
                    [noticeImgVForMsg removeFromSuperview];
                    
                    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
                    UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
                    UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
                    
                    [detailImg removeFromSuperview];
                    [listImg removeFromSuperview];
                    //-------------------------------------------------------------------------------
                    
                }else{
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                //--退出班级将原来班级详情页/班级列表页现有未读红点全部清空 赵经纬 李昌明 张昊天 确认 kate被迫修改 2016.02.26-----------
                
                //[self deleteTableForGroupMsg:_cId];//清空群聊红点消息
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *alwaysNewsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"alwaysNewsDic"]];
                NSArray *classArray = [alwaysNewsDic objectForKey:@"classes"];
                
                NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
                
                for (int i = 0 ; i<[classArray count]; i++) {
                    
                    NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                    NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
                    
                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                    [classLastDicDefault setObject:last forKey:keyStr];
                    
                    
                    
                }
                
                
                [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                [userDefaults synchronize];
                
                NSArray *spacesArray = [alwaysNewsDic objectForKey:@"spaces"];
                NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
                
                for (int i = 0 ; i<[spacesArray count]; i++) {
                    
                    NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
                    NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
                    
                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                    [spaceLastDicDefault setObject:last forKey:keyStr];
                    
                    
                }
                
                [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                [userDefaults synchronize];
                
            }
        });
    });
    
}


-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

-(void)addMoudelView{
    
   
    int x = 0;//横
    int j = 0;//竖
   
    float lastY = 0;
    
    NSArray *views = [moduleView subviews];
    for(UIView *view in views){
        
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//        }
        
        [view removeFromSuperview];
        
    }
    
//    NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i< [moduleFromServer count]; i++) {
//        
//        NSInteger type = [[[moduleFromServer objectAtIndex:i] objectForKey:@"type"] integerValue];
//        NSString *tag = [NSString stringWithFormat:@"%ld",210+type];
//        [tagsArray addObject:tag];
//        
//    }
//    
//    
//    for(UIView *view in views){
//        
//        if ([view isKindOfClass:[UIButton class]]) {
//          [view removeFromSuperview];
//        }else{
//            
//            for (int i=0; i<[tagsArray count]; i++) {
//                
//                if (view.tag == [[tagsArray objectAtIndex:i] integerValue]) {
//                    break;
//                }else{
//                    [view removeFromSuperview];
//                }
//                
//            }
//        }
//        
//    }
    
      /* //需求变更 现在所有的模块都可以开惯了 不用终端再特意做处理
       if ([moduleFromServer count] < [moduleArray count]) {
           
           //这两个模块可以关掉
           UIView *newsMv = [moduleView viewWithTag:210+14];//公告
           UIView *classPhotoMv = [moduleView viewWithTag:210+35];//相册
           BOOL isNew = NO;
           BOOL isClassPhoto = NO;
           for (int i = 0; i<[moduleFromServer count]; i++) {
               
               NSInteger type = [[[moduleFromServer objectAtIndex:i] objectForKey:@"type"] integerValue];
               if (type == 14) {
                   isNew = YES;
               }else if (type == 35){
                   isClassPhoto = YES;
               }

           }
           //没有这两个模块则移除
           if (!isNew) {
               if (newsMv) {
                   [newsMv removeFromSuperview];
               }
           }
           
           if (!isClassPhoto) {
               if (classPhotoMv) {
                   [classPhotoMv removeFromSuperview];
               }
           }
          
       }*/
    
        for (int i=0; i< [moduleFromServer count]; i++) {
            
            NSString *name = [[moduleFromServer objectAtIndex:i] objectForKey:@"name"];
            NSInteger type = [[[moduleFromServer objectAtIndex:i] objectForKey:@"type"] integerValue];
        
            float width = [UIScreen mainScreen].bounds.size.width/moduleCount;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, width, 61.0);
            button.tag = 410+i;
            [button addTarget:self action:@selector(moudelSelect:) forControlEvents:UIControlEventTouchUpInside];
            //button.backgroundColor=[UIColor redColor];
            //[button setBackgroundImage:[UIImage imageNamed:@"module_press.png"] forState:UIControlStateHighlighted];
            
            if ((i!=0) && (i%moduleCount == 0)) {
                
                j++;
                x = 0;
            }
            
            UIView *mv = [moduleView viewWithTag:210+type];
            if (!mv) {
            
                UIView *moudelView = [Utilities createmodule:[[moduleFromServer objectAtIndex:i] objectForKey:@"icon"] title:name count:moduleCount tag:310+type];
                moudelView.frame = CGRectMake(x*width, 61.0*j+(j+1)*15, width, 61.0);
                moudelView.tag = 210+type;
                //moudelView.backgroundColor = [UIColor purpleColor];
                moudelView.userInteractionEnabled = YES;
                [moudelView addSubview:button];
                [moduleView addSubview:moudelView];
                
            }else{
                
                mv.frame = CGRectMake(x*width, 61.0*j+(j+1)*15, width, 61.0);
                
                UIImageView *iconImgV = [mv viewWithTag:310+type];
                if (iconImgV) {
                    [iconImgV sd_setImageWithURL:[NSURL URLWithString:[[moduleFromServer objectAtIndex:i] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                }
                
            }
            
            x++;
            
            lastY = 61.0*(j+1)+(j+1)*15;
           
        }
    
    [self showRedPoint];
    
    lastYForModuleV = lastY;
    
    NSString *height = [NSString stringWithFormat:@"%f",lastY+10];
    [self performSelector:@selector(updateModuleView:) withObject:height afterDelay:0.1];
    
}

-(void)updateModuleView:(id)sender{
    
    NSString *heightStr = (NSString*)sender;
    
    float height = [heightStr floatValue];
    
    [moduleView mas_updateConstraints:^(MASConstraintMaker *make) {
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, height));
        
    }];
}

//-------------------------------------------------------------------------------

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
        
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSLog(@"新红点check接口返回:%@",dic);
            
            if (dic) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"alwaysNewsDic"];
                [userDefaults synchronize];//存贮实时的最新的last
                
                [Utilities updateLocalData:dic];
                [self updateRedPoint:dic];
            }
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

// 更新页面红点
-(void)updateRedPoint:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"classes"];//new
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *classLastDicDefault = [allLastIdDic objectForKey:@"classLastDicDefault"];//old
        
        if ([classLastDicDefault count] > 0) {
            
            [noticeImgVForMsg removeFromSuperview];
            
            //[self buildRedArray:moduleFromServer];//构造红点数组
            
            for (int i=0; i<[array count]; i++){
                
                NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                
                NSString *lastFiltered = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[classLastDicDefault objectForKey:keyStr]]];
                
                if ([cid integerValue] == [_cId integerValue]) {
                    
                    NSString *type = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"type"]];
                    
                    if ([type integerValue] == 30) {
                        lastLeaveId = last;//点击请假模块用此id更新
                    }
                    
                    if ([type integerValue] == 19) {
                        lastMsgId = lastFiltered;//动态消息id
                        if ([lastFiltered isEqualToString:@""]) {
                            NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
                            lastFiltered = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
                        }
                    }
                        if (([last integerValue] > [lastFiltered integerValue])) {//新的last比本地的last大
                            
                            if ([moduleFromServer count] > 0) {
                                
                                for (int i=0; i<[moduleFromServer count]; i++) {
                                    
                                    NSString *moudleId = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"id"]];
                                   // NSString *type = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"type"]];
                                    
                                    if ([moudleId integerValue] == [mid integerValue]) {
                                    
                                        NSInteger  index = i;
                                        
                                            [redImgArray replaceObjectAtIndex:index withObject:@"1"];
                                            if([_fromName isEqualToString:@"tab"]){
                                                [self checkSelfMomentsNew];
                                            }
                                        
                                    }else{
                                        NSInteger  index = i;
                                        [redImgArray replaceObjectAtIndex:index withObject:@"0"];
                                    }
                                    
                                }
                                
                            }else{
                                
                                    if([_fromName isEqualToString:@"tab"]){
                                        [self checkSelfMomentsNew];
                                    }
                                
                            }
                           
                        }else{
                            
                            for (int i=0; i<[moduleFromServer count]; i++) {
                                
                                NSString *moudleId = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"id"]];
                                //NSString *type = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"type"]];
                                
                                if ([moudleId integerValue] == [mid integerValue]) {
                                    
                                    NSInteger index = i;
                                    
                                    [redImgArray replaceObjectAtIndex:index withObject:@"0"];
                                    
                                }
                                
                                
                            }
                            
                        }

                }
                
            }
            
            //[self showRedPoint];
       
        }
        
    }
    
     [self addMoudelView];
    
    
}

-(void)showRedPoint{
    
    for (int i=0; i< [moduleFromServer count]; i++){
        
        NSInteger type = [[[moduleFromServer objectAtIndex:i] objectForKey:@"type"] integerValue];
        
        UIView *mv = [moduleView viewWithTag:type+210];
        float w =  [Utilities convertPixsW:40];
        
        UIImageView *newImgV = [mv viewWithTag:type+WIDTH];
        
        if (!newImgV){
            
            newImgV = [[UIImageView alloc]initWithFrame:CGRectMake((mv.frame.size.width - w)/2.0 + w-5.0, -3, 10, 10)];
            newImgV.image = [UIImage imageNamed:@"icon_new"];
            newImgV.tag = type+WIDTH;
            
        }
     
         //NSLog(@"isRed:%@",[redImgArray objectAtIndex:i]);
        newImgV.image = [UIImage imageNamed:@"icon_new"];
        if ([[redImgArray objectAtIndex:i] isEqualToString:@"1"]) {
            
            if (![mv viewWithTag:type+WIDTH]) {
                [mv addSubview:newImgV];
            }
            
        }else{
            
        }
        
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
       
    }
    
}

//班级tab红点
-(void)checkSelfMomentsNew{
    
    [noticeImgVForMsg removeFromSuperview];
    [noticeImgVForMsg removeFromSuperview];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
    UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
    UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
    
    [detailImg removeFromSuperview];
    [listImg removeFromSuperview];
    
    [button addSubview:noticeImgVForMsg];
    
}

-(void)moudelSelect:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger i = btn.tag - 410;
//    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
//    NSDictionary *positionDic = tsTap.infoDic;
//    NSInteger i = [[positionDic objectForKey:@"moduleIndex"] integerValue];
    
//    NSString *localType = [[moduleArray objectAtIndex:i] objectForKey:@"type"];
    NSString *type = [[moduleFromServer objectAtIndex:i] objectForKey:@"type"];
    NSInteger index = i;
    NSString *mid = @"";
    NSString *titleName = @"";
    
//    for (int i = 0; i<[moduleFromServer count]; i++) {
//        
//        NSString *type = [[moduleFromServer objectAtIndex:i] objectForKey:@"type"];
//        
//        if ([type isEqualToString:localType]) {
//            index = i;
//        }
//        
//    }
    
    //if (index!=-1) {
        mid = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:index] objectForKey:@"id"]];
        titleName = [NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:index] objectForKey:@"name"]];
    //}
    
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    rt.pan.enabled = NO;

    switch ([type integerValue]) {
            
        case 35:
            //去班级相册
        {
            rt.pan.enabled = NO;
#if 0
             NewClassPhotoViewController *ncpV = [[NewClassPhotoViewController alloc] init];
            ncpV.cId = _cId;
            [self.navigationController pushViewController:ncpV animated:YES];
            [MyTabBarController setTabBarHidden:YES];
#endif
            
            PhotoClassHomeViewController *photoCVC = [[PhotoClassHomeViewController alloc] init];
            photoCVC.cid = _cId;
            [self.navigationController pushViewController:photoCVC animated:YES];
            [MyTabBarController setTabBarHidden:YES];
            
        }
    
            break;
        case 13:
            //去班级点滴
            rt.pan.enabled = NO;

            [self gotoClassDiscussViewList:@"班级点滴"];
            break;
        case 14://班级公告 红点
            [self goToPublic:titleName mid:mid];
            rt.pan.enabled = NO;

            break;
        case 19:
            //班级圈 红点
            [self gotoClassNews:titleName mid:mid];
            rt.pan.enabled = NO;

            break;
        case 26:
            //成长空间
            if ([spaceForClass integerValue] == 1) {
                
                //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
                if ([isNumber integerValue] == 0 || isNumber == nil) {
                   
                    //弹出提示框 取消 绑定
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"完成身份认证，体验更多功能" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"稍后再说", nil];
                    alertV.tag = 126;
                    [alertV show];
                    
                }else{
                    
                    if ([usertype integerValue] == 0  || [usertype integerValue] == 6) {
                        // 用于判断老用户是否绑定
                        NSString *number =[NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"number"]];
                        if ([number integerValue] == 0) {//未绑定
                            //弹出提示框 取消 绑定
                            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"完成身份认证，体验更多功能" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"暂不绑定", nil];
                            alertV.tag = 126;
                            [alertV show];
                            
                        }else{
                            
                            NSString *url = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"space_url"]];
                            
                            NSString *spaceStatus =[NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"status"]];
                            
                            NSString *trial = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"trial"]];
                            
                            NSString *growthInfo = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"trial_note"]];
                            
                            NSLog(@"growthInfo:%@",growthInfo);
                            
                            if ([spaceStatus integerValue] == 0 && [trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
                                rt.pan.enabled = NO;

                                [self gotoPayView:url status:spaceStatus trial:trial];
                                
                                [userDefault setObject:@"1" forKey:@"isNewForSpace"];
                            }else{
                                rt.pan.enabled = NO;

                                [self gotoGrowthSpace:url status:spaceStatus mid:mid trial:trial growthInfo:growthInfo];
                                [userDefault setObject:@"1" forKey:@"isNewForSpace"];
                            }
                            
                            
                        }
                    }
                }
                
            }else{
                
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的班级还未添加认证信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            }
            break;
        case 29:
            //成长空间管理
        {
            rt.pan.enabled = NO;

            [ReportObject event:ID_OPEN_SPACE_LIST];
            
            StudentsStatusListViewController *vc = [[StudentsStatusListViewController alloc]init];
            vc.cid = _cId;
            vc.titleName = titleName;
            [self.navigationController pushViewController:vc animated:YES];
             [MyTabBarController setTabBarHidden:YES];
        }
            
            break;
        case 30:
            //请假 红点
            
            {
            [ReportObject event:ID_OPEN_CLASS_LEAVE];
          
                if ([usertype integerValue] == 0 || [usertype integerValue] == 6){
                
                if ([spaceForClass integerValue] == 1) {
                    
                    //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
                    if ([isNumber integerValue] == 0 || isNumber == nil) {
                       
                        //弹出提示框 取消 绑定
                        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"完成身份认证，体验更多功能" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"稍后再说", nil];
                        alertV.tag = 126;
                        [alertV show];
                        
                    }else{
                        
                        NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"url"]]]];
                       
                        NSDictionary *userInfoa = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
                        NSString *uid= [userInfoa objectForKey:@"uid"];//后续需要修改从单例里面取 kate
                        if (nil == uid) {
                            uid = @"";
                        }
                        
                        // app_code
                        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                        NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
                        
                        // 设备型号 eg:iPhone 4S
                        NSString *mobile_model = [Utilities getCurrentDeviceModel];
                        // 去掉型号里面的空格
                        mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
                        // 手机系统版本 eg:8.0.2
                        NSString *os_version = [[UIDevice currentDevice] systemVersion];
                        
                        NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
                        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
                        if (nil == token) {
                            token = @"";
                        }
                        
                        NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
                        key = [Utilities md5:key];
                        
                        NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
                        
                        NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@&uid=%@&sid=%@&cid=%@&grade=%@",tempUrl, api, love, key, uid, G_SCHOOL_ID, _cId, usertype];
                        rt.pan.enabled = NO;

                        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                        fileViewer.requestURL = newUrl;
                        fileViewer.titleName = @"";
                        rt.pan.enabled = NO;
                        fileViewer.isShowSubmenu = @"0";
                        fileViewer.isRotate = @"1";
                        [self.navigationController pushViewController:fileViewer animated:YES];
                        
                        //isNewForLeave
                        [userDefault setObject:@"1" forKey:@"isNewForLeave"];
                         [MyTabBarController setTabBarHidden:YES];
                        
                    }
                    
                    
                }else{
                    
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的班级还未添加认证信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertV show];
                }
                
            }else{
                
                NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[moduleFromServer objectAtIndex:i] objectForKey:@"url"]]]];
                NSString *url = [Utilities appendUrlParams:tempUrl];
                
                NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", url, _cId, usertype];
                rt.pan.enabled = NO;

                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.requestURL = reqUrl;
                fileViewer.titleName = @"";
                fileViewer.isShowSubmenu = @"0";
                fileViewer.isRotate = @"1";
                [self.navigationController pushViewController:fileViewer animated:YES];
                
                if ([spaceForClass integerValue] == 1) {
                    //isNewForLeave
                    [userDefault setObject:@"1" forKey:@"isNewForLeave"];
                }
                // 修改红点时候改
                [Utilities updateClassRedPoints:_cId last:lastLeaveId mid:mid];//更新请假红点 只有老师有红点 tony确认
                [MyTabBarController setTabBarHidden:YES];
            }
        }
            break;
//            
//        case 10007:
//            //老师请假
//            
//            break;
            
        case 18:// 班级成员
             [self gotoClassmate:titleName];
            break;
            
        case 40:{//考勤 api暂无返回以下需要的数据
            
            NSDictionary *stateDic = [[moduleFromServer objectAtIndex:i] objectForKey:@"state"];
            NSString *url = [[moduleFromServer objectAtIndex:i] objectForKey:@"url"];
            NSString *school = [NSString stringWithFormat:@"%@",[stateDic objectForKey:@"school"]];
            
            NSString *card = [NSString stringWithFormat:@"%@",[stateDic objectForKey:@"card"]];
            
            NSLog(@"我点击了 ClassDetailViewController 中的考勤 -- \n %@ \n\n\n %@ \n\n\n %@ \n\n\n",school,card,_fromName);
            
            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];   //  2017.08.30  ky
            if ((0 == [usertype integerValue]) || (6 == [usertype integerValue])) {//学生身份
                
                //NSString *authority = [NSString stringWithFormat:@"%@",[stateDic objectForKey:@"authority"]];
                
                //card = @"0";//测试代码
                //                  school = @"1";
                //                    authority = @"1";
                if ([school integerValue] != 0) {//上了设备
                    
                    
                    /*if ([authority integerValue] == 1) {//有权限查看考勤统计
                     
                     LeaveHomeViewController *vc = [[LeaveHomeViewController alloc] init];
                     vc.titleName = titleName;
                     vc.redPointDic = redPointDic;
                     vc.url = url;
                     vc.fromName = @"attendance";
                     vc.isBind = [card integerValue];
                     [self.navigationController pushViewController:vc animated:YES];
                     
                     }else{*///无权限查看考勤统计
                    
                    if ([card integerValue] > 0) {//绑定了
                        NSLog(@"日历");
                        MyCheckinHome *mch = [[MyCheckinHome alloc] init];
                        mch.fromName = @"tab";
                        mch.titleName = @"签到";
                        mch.isStudent = 1;
                        mch.showRightItem = YES;
                        
                        NSMutableDictionary *userDetailInfo = [[GlobalSingletonUserInfo sharedGlobalSingleton] getUserDetailInfo];
                        NSString *student_number_id = [NSString stringWithFormat:@"%@", [userDetailInfo objectForKey:@"student_number_id"]];
                        mch.teacherUid = student_number_id;
                        
                        [self.navigationController pushViewController:mch animated:YES];
                        
                    }else{//未绑定
                        
                        NoCardViewController *ndvc = [[NoCardViewController alloc] init];
                        ndvc.titleName = titleName;
                        ndvc.isStudent = 1;
                        ndvc.cid = _cId;
                        [self.navigationController pushViewController:ndvc animated:YES];
                        
                    }
                    //}
                    
                }else{//未上设备
                    
                    // 去介绍web页
                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                    fileViewer.url = [NSURL URLWithString:url];
                    fileViewer.webType = SWLoadURl;
                    fileViewer.titleName = @"";
                    fileViewer.isShowSubmenu = @"0";
                    fileViewer.isRotate = @"1";
                    fileViewer.isFromEvent = YES;
                    [self.navigationController pushViewController:fileViewer animated:YES];
                    
                }
                
            }else{//老师
                
                if ([school integerValue] != 0) {//上了设备
                    
                    //to do:查看学生考勤列表页 for chenth
                    SignStatisticsViewController *signStatistics = [[SignStatisticsViewController alloc] init];
                    signStatistics.isFromClass = YES;
                    signStatistics.cid = _cId;
                    [self.navigationController pushViewController:signStatistics animated:YES];
                }else{//未上设备
                    
                    // 去介绍web页
                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                    fileViewer.url = [NSURL URLWithString:url];
                    fileViewer.webType = SWLoadURl;
                    fileViewer.titleName = @"";
                    fileViewer.isShowSubmenu = @"0";
                    fileViewer.isRotate = @"1";
                    fileViewer.isFromEvent = YES;
                    [self.navigationController pushViewController:fileViewer animated:YES];
                    
                }
                
                
            }
            
            [MyTabBarController setTabBarHidden:YES];  //  2017.08.30  //  ky
            
            
        }
            break;

            
#if 9
        case 41:{// 视频监控模块
            
            if ([Utilities isConnected] && messageDic!=nil) {
                
                
                NSDictionary *cameraDic = [messageDic objectForKey:@"camera"];
                NSString *url = [cameraDic objectForKey:@"url"];
                NSString *open = [NSString stringWithFormat:@"%@",[cameraDic objectForKey:@"open"]];
                
                NSLog(@"---------------  %@",open);
                
                //open = @"0";//测试代码
                if ([open integerValue] == 0) {
                    
                    // 去介绍web页
                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                    fileViewer.webType = SWLoadURl;
                    fileViewer.url = [NSURL URLWithString:url];
                    fileViewer.isShowSubmenu = @"0";
                    fileViewer.isRotate = @"1";
                    fileViewer.hideBar = YES;
                    fileViewer.isFromEvent = YES;
                    [self.navigationController pushViewController:fileViewer animated:YES];
    
                }else{
                    
                    if((UserType_Student == [Utilities getUserType]) ||
                       (UserType_Parent == [Utilities getUserType])){
                        
                        if ([isNumber integerValue] == 0) {
                            
                            //done:显示 "简单动动手指，让班级功能同学更了解你吧！"的提示
                            // 点击"完善信息"去完善信息页
                            [self showCustomAlert:@"简单动动手指，\n让班级同学更了解你吧!" buttonTitle:@"完善信息" imgName:@"customAlert/alert_bindBg.png"];
                            
                        }else{
                            
                            [bgV removeFromSuperview];
                            
                            NSDictionary *vipDic = [messageDic objectForKey:@"vip"];
                            
                            // 学校是否开通了VIP
                            //BOOL open = [[NSString stringWithFormat:@"%@",[vipDic objectForKey:@"schoolEnabled"]] boolValue];
                            // 幼儿园版本state字段 K12版本叫status字段
                            NSInteger state = [[NSString stringWithFormat:@"%@",[vipDic objectForKey:@"state"]] integerValue];
                            
                            if (state == 0 || state == 3 || state == 4) {//未开通/到期
                                
                                //[self showCustomAlert:@"快加入成长VIP伐木累,\n与其他童鞋一起嗨皮吧!" buttonTitle:@"立即加入" imgName:@"customAlert/alert_vipBg.png"];
                                
                                //NSString *CancelStr = @"暂不开通";
                                NSString *OKStr = @"开通";
                                NSString *popStr = @"您未开通VIP会员，暂时无法观看视频监控";
                                if (state!= 0) {
                                    //CancelStr = @"暂不续费";
                                    OKStr = @"续费";
                                    popStr = @"您的VIP会员已到期，暂时无法观看视频监控";
                                }
                                
                                TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
                                    
                                    NSString *urlStr = [[messageDic objectForKey:@"vip"] objectForKey:@"payUrl"];
                                    
                                    NSLog(@"您的VIP会员已到期，暂时无法观看视频监控  url == %@",messageDic);
                                    
                                    GrowVIPViewController *myInfoCenter = [[GrowVIPViewController alloc] init];
                                    myInfoCenter.VIPUrl = urlStr;
                                    [self.navigationController pushViewController:myInfoCenter animated:YES];
                                    
                                };
                                
                                NSArray *itemsArr =
                                @[TSItemMake(OKStr, TSItemTypeNormal, handlerTest)];
                                [Utilities showPopupView:popStr items:itemsArr];
                                
                            }else{//status:1 正常缴费 2 试用期
#if DEVICE_IPHONE
                                Camera360ViewController *c360vc = [[Camera360ViewController alloc] init];
                                c360vc.cId = _cId;
                                c360vc.titleName = titleName;
                                c360vc.isAdmin = _isAdmin;
                                [self presentViewController:c360vc animated:YES completion:nil];
#else
                                [Utilities showTextHud:@"360sdk不支持模拟器，请在真机上调试。" descView:self.view];
#endif
                            }
                        }
                        
                    }else{
#if DEVICE_IPHONE
                        Camera360ViewController *c360vc = [[Camera360ViewController alloc] init];
                        c360vc.cId = _cId;
                        c360vc.titleName = titleName;
                        c360vc.isAdmin = _isAdmin;
                        [self presentViewController:c360vc animated:YES completion:nil];
#else
                        [Utilities showTextHud:@"360sdk不支持模拟器，请在真机上调试。" descView:self.view];
#endif
                        
                    }
                    
                }
            }
        }
                break;
#endif
        default:
            
            [self.view makeToast:@"敬请期待."
                        duration:0.5
                        position:@"center"
                           title:nil];
            
            break;
    }
   
}

-(void)addPhoto{
    
    int x = 0;//横
    int j = 0;//竖
    
    float lastY = 0;
    
    float width = ([UIScreen mainScreen].bounds.size.width-30.0)/2.0;
    float height = width;
    
//    for (int i=0; i<[galleriesArray count]; i++) {
//        
//        UIImageView *tempImgV = [newPhotoView viewWithTag:110+i];
//        [tempImgV removeFromSuperview];
//        
//    }
    
    for (int i = 0; i< [galleriesArray count]; i++) {
        
        NSString *photoNum = [[galleriesArray objectAtIndex:i] objectForKey:@"count"];
        
        
        NSString *title = [[galleriesArray objectAtIndex:i] objectForKey:@"title"];
        NSString *imgUrl = [[galleriesArray objectAtIndex:i] objectForKey:@"thumb"];
        NSString *dateTemp = [[galleriesArray objectAtIndex:i] objectForKey:@"dateline"];
        //NSString *photoId = [[galleriesArray objectAtIndex:i] objectForKey:@"id"];
        Utilities *util = [Utilities alloc];
        NSString *dateStr = [util linuxDateToString:dateTemp andFormat:@"%@-%@ %@:%@" andType:DateFormat_MDHM];
        NSString *type = [NSString stringWithFormat:@"%@",[[galleriesArray objectAtIndex:i] objectForKey:@"type"]];
        if ([type integerValue] == 1) {//type=1 视频 0 图片
            
            photoNum = @"0";
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width, height+57.0);
        button.tag = 700+i;
        [button addTarget:self action:@selector(photoSelect:) forControlEvents:UIControlEventTouchUpInside];

        if ((i!=0) && (i%2 == 0)) {
            
            j++;
            x = 0;
        }
        
        UIImageView *imgView = [self createPhoto:title date:dateStr imgName:imgUrl photoCount:photoNum];
        imgView.frame = CGRectMake(x*width+(x+1)*10, (height+57.0)*j+(j+1)*10, width, height+57.0);
        imgView.tag = 110+i;
        //moudelView.backgroundColor = [UIColor purpleColor];
        imgView.userInteractionEnabled = YES;
        
        UIImageView *videoMarkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, imgView.frame.size.height-57.0-13.0-5.0, 13.0, 13.0)];
        videoMarkImgV.image = [UIImage imageNamed:@"videoMark.png"];
        [imgView addSubview:videoMarkImgV];
        [imgView addSubview:button];
        [newPhotoView addSubview:imgView];
        
        if ([type integerValue] == 1) {//type=1 视频 0 图片
            
            videoMarkImgV.hidden = NO;
            
        }else{
            
            videoMarkImgV.hidden = YES;
        }
        
         x++;
        
         lastY = (j+1)*(height + 57.0)+(j+1)*10+30;

    }
    
    
    [newPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
      
        float y = newPhotoSection.frame.size.height + newPhotoSection.frame.origin.y + lastY + 10;
        if(y <= [Utilities getScreenSizeWithoutBar].height){
           make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, lastY+10+30));
        }else{
           make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, lastY+10));
        }
        
    }];
    
}

// 点击照片
-(void)photoSelect:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger i = btn.tag - 700;
    //174 221 215
    NSString *photoId = [[galleriesArray objectAtIndex:i] objectForKey:@"id"];
    //去详情页
    /**
     * 班级相册图片详情
     *
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classTopic sid= cid= uid= tid=主题ID app= page= size=
     */
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    WWSideslipViewController *rt = (WWSideslipViewController *)appDelegate.window.rootViewController;
    MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
    momentsDetailViewCtrl.tid = photoId;//动态id
    //momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
    momentsDetailViewCtrl.fromName = @"classPhoto";
    momentsDetailViewCtrl.cid = _cId;
    rt.pan.enabled = NO;
    [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
    
    [MyTabBarController setTabBarHidden:YES];

    
}

-(UIImageView*)createPhoto:(NSString*)title date:(NSString*)dateStr imgName:(NSString*)imgUrl photoCount:(NSString*)photoNum{
    
     float width = ([UIScreen mainScreen].bounds.size.width-30.0)/2.0;
     float height = width;
    
    UIImageView *imgBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height+57.0)];
    imgBgV.image = [UIImage imageNamed:@"ClassKin/photoBg"];
   
    
    UIImageView *photoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    photoImgV.contentMode = UIViewContentModeScaleAspectFill;
    [photoImgV setClipsToBounds:YES];
    [photoImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    // 指定的角圆角
    /* UIRectCornerTopLeft
    * UIRectCornerTopRight
    * UIRectCornerBottomLeft
    * UIRectCornerBottomRight
    * UIRectCornerAllCorners
    */
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:photoImgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = photoImgV.bounds;
    maskLayer.path = maskPath.CGPath;
    photoImgV.layer.mask = maskLayer;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5.0, height+10.0, width-10.0, 17.0)];
    titleLab.font = [UIFont systemFontOfSize:14.0];
    titleLab.text = title;
    titleLab.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(5.0, titleLab.frame.origin.y+17.0+10.0, width/2.0 -5.0, 13.0)];
    dateLab.font = [UIFont systemFontOfSize:11.0];
    dateLab.text = dateStr;
    dateLab.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    //dateLab.backgroundColor = [UIColor yellowColor];
    
    NSString *numStr = [NSString stringWithFormat:@"共%@张",photoNum];
    UILabel *photoNumLab = [[UILabel alloc] initWithFrame:CGRectMake(width - (width/2.0 - 5.0), dateLab.frame.origin.y, width/2.0-5.0-10, 13.0)];
    photoNumLab.font = [UIFont systemFontOfSize:11.0];
    photoNumLab.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    if ([photoNum integerValue] == 0) {
        photoNumLab.text = @"";
    }else{
         photoNumLab.text = numStr;
    }
    photoNumLab.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    photoNumLab.textAlignment = NSTextAlignmentRight;
    //photoNumLab.backgroundColor = [UIColor redColor];
    
    
    [imgBgV addSubview:photoImgV];
    [imgBgV addSubview:titleLab];
    [imgBgV addSubview:dateLab];
    [imgBgV addSubview:photoNumLab];
    
    return imgBgV;
}

// 去学生签到页
-(void)gotoSingend:(NSString*)titleName{
   
    NoCardViewController *nosignV = [[NoCardViewController alloc] init];
    nosignV.titleName = titleName;
    [self.navigationController pushViewController:nosignV animated:YES];
    
}

// 去班级讨论区列表
- (IBAction)gotoClassDiscussViewList:(NSString*)titleName {
    
    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
    cladddisV.fromName = @"classDiscuss";
    cladddisV.cId = _cId;
    cladddisV.titleName = titleName;
    [self.navigationController pushViewController:cladddisV animated:YES];
    
    [ReportObject event:ID_OPEN_CLASS_THREAD_LIST];// 2015.06.24
    
     [MyTabBarController setTabBarHidden:YES];
}

// 去班级公告
- (IBAction)goToPublic:(NSString*)titleName mid:(NSString*)mid{
    
    //_publicBtn.backgroundColor = [UIColor lightGrayColor];
    //_publicBtn.alpha = 0.4;
    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
    cladddisV.titleName = titleName;
    cladddisV.cId = _cId;
    cladddisV.mid  = mid;
    [self.navigationController pushViewController:cladddisV animated:YES];
    
    [ReportObject event:ID_OPEN_CLASS_NEWS_LIST];//2015.06.24
    [MyTabBarController setTabBarHidden:YES];
}

// 去班级动态
-(IBAction)gotoClassNews:(NSString*)titleName mid:(NSString*)mid{
    
    MomentsViewController *momentsViewCtrl = [[MomentsViewController alloc] init];
    momentsViewCtrl.titleName = titleName;
    momentsViewCtrl.fromName = @"class";
    momentsViewCtrl.cid = _cId;
    //momentsViewCtrl.cName = _classNameLab.text;
    momentsViewCtrl.isAdmin = _isAdmin;
    momentsViewCtrl.mid = mid;
    momentsViewCtrl.lastMsgId = lastMsgId;
    [self.navigationController pushViewController:momentsViewCtrl animated:YES];
    
    [MyTabBarController setTabBarHidden:YES];
    
}

// 去成长空间
-(void)gotoGrowthSpace:(NSString*)urlStr status:(NSString*)status mid:(NSString*)mid trial:(NSString*)trial growthInfo:(NSString*)growthInfo{
    
    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
    growVC.cId = _cId;
    growVC.urlStr = urlStr;
    growVC.spaceStatus = status;
    growVC.mid = mid;
    growVC.redPointDic = redPointDic;
    growVC.isTrial = trial;
    growVC.growthInfo = growthInfo;
    [self.navigationController pushViewController:growVC animated:YES];
    [MyTabBarController setTabBarHidden:YES];
    
}

// 去成长空间支付状态页 2015.12.21
-(void)gotoPayView:(NSString*)urlStr status:(NSString*)status trial:(NSString*)trial{
    
    PayViewController *growVC = [[PayViewController alloc] init];
    growVC.fromName = @"class";
    growVC.cId = _cId;
    growVC.urlStr = urlStr;
    growVC.spaceStatus = status;
    growVC.redPointDic = redPointDic;
    growVC.isTrial = trial;
    [self.navigationController pushViewController:growVC animated:YES];
     [MyTabBarController setTabBarHidden:YES];
    
}

// 去成员列表页
- (IBAction)gotoClassmate:(NSString*)titleName
{
    MemberListViewController *memberList = [[MemberListViewController alloc]init];
    memberList.fromName = @"classDetail";
    memberList.titleName = titleName;
    memberList.cId = _cId;
    [self.navigationController pushViewController:memberList animated:YES];
    
}


//去网络设置引导页
-(void)gotoNetworkGuide{
    
    NetworkGuideViewController *networkGVC = [[NetworkGuideViewController alloc]init];
    [self.navigationController pushViewController:networkGVC animated:YES];
}

// 点击未绑定学籍黄条去绑定页
- (void)gotoBindView:(id)sender {
    
    if ([spaceForClass integerValue] == 1) {
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
        NSString *iden;
        
        switch ([usertype integerValue]) {
            case 0:
                iden = @"student";
                break;
            case 6:
                iden = @"parent";
                break;
            case 7:
                iden = @"teacher";
                break;
            case 9:
                iden = @"admin";
                break;
                
            default:
                break;
        }
        
        
        [MyTabBarController setTabBarHidden:YES];
        
#if 0
        SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
        setPVC.viewType = @"classDetail";
        setPVC.cId = _cId;
        setPVC.iden = iden;
        [self.navigationController pushViewController:setPVC animated:YES];
#endif
        NSString *payUrl = [[messageDic objectForKey:@"vip"] objectForKey:@"payUrl"];
        GrowVIPViewController *growthVIPV = [[GrowVIPViewController alloc] init];
        growthVIPV.VIPUrl = payUrl;
        [self.navigationController pushViewController:growthVIPV animated:YES];
        
        
    }else{
        
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        
        NSURL *url = [NSURL URLWithString:unbindIntroduceUrl];
        fileViewer.webType = SWLoadURl;
        fileViewer.url = url;
        fileViewer.isShowSubmenu = @"0";
        [self.navigationController pushViewController:fileViewer animated:YES];
        
    }
    
}

-(void)addUnbindBar{
    
    [self.view addSubview:barView];
    [moduleView mas_updateConstraints:^(MASConstraintMaker *make){
        
        // 距离屏幕上边距为80
        make.top.equalTo(viewWhiteBg.mas_top).with.offset(30.0);
        // 距离屏幕左边距为20
        make.left.equalTo(viewWhiteBg.mas_left).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, lastYForModuleV+10));
        
    }];
}

-(void)closeUnbindBar{
    
    [barView removeFromSuperview];
    [moduleView mas_updateConstraints:^(MASConstraintMaker *make){
        
        // 距离屏幕上边距为80
        make.top.equalTo(viewWhiteBg.mas_top).with.offset(15.0);
        // 距离屏幕左边距为20
        make.left.equalTo(viewWhiteBg.mas_left).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, lastYForModuleV+10));
        
    }];
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        _newsDic = nil;
        [self loadData];
        
    }
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
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

@end

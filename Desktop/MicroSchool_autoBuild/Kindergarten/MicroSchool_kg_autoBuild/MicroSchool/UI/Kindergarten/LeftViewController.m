//
//  LeftViewController.m
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LeftViewController.h"
#import "NormalTableViewCell.h"
#import "MessageCenterViewController.h"
#import "BaseViewController.h"
#import "MyPointsViewController.h"
#import "MomentsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "SettingViewController.h"
#import "SchoolHomeViewController.h"
#import "PersonalInfoViewController.h"
#import "SetPersonalViewController.h"
#import "LeftTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface LeftViewController (){

     NSString *isNewVersion;

     NSString *str;
    NSString *choose;
    UITableView *leftTableview;
    NSMutableDictionary *uD;
    NSDictionary *userDetailDic;
    UIImageView *arrowImg;//全局变量在cellf做Masonry适配
    UIImageView *iconImg;//全局变量在cellf做Masonry适配
    UILabel *textLable;//全局变量在cellf做Masonry适配
    NSString *iconLeftImage;
    UIImageView *iconLeftImageV;
    BOOL isOpenVip;
    BOOL isRefresh;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createrView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewReloadRedPoint) name:@"leftViewReloadRedPoint" object:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUserProfile) name:@"reflashUserProfile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUserProfile) name:NOTIFICATION_GET_PROFILE object:nil];

    
    //刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadleft:)
                                                 name:@"reloadleft"
                                               object:nil];
//#4.1  不在wws初始方法是传背景Img，现在在leftVC里面设置背景Img。
    UIImageView *bgView = [UIImageView new];
    bgView.image = [UIImage imageNamed:@"左侧菜单-bg"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    self.cellDelegate =self;
    
    
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    
    [self getMyProfile];
    
    // Do any additional setup after loading the view.
}

-(void)reloadleft:(NSNotification *)notification
{
    [self chooseID];
    [leftTableview reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
//    [leftTableview removeFromSuperview];
//    [self createrView];
    isRefresh = 1;
    [super viewWillAppear:YES];
//#4.1  在LeftVC的viewWillAppear方法取值CHOOSE，判断在哪个页面进行点击跳转，1 SchoolHome  2.MyclassList  3.ParkHome  4.MyclassDetail
    choose=[[NSUserDefaults standardUserDefaults]objectForKey:@"CHOOSE"];
    userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    uD = [NSMutableDictionary dictionaryWithDictionary:userDetailDic];
    str =@"";
    [self checkNew];
}

- (void)leftViewReloadRedPoint {
    
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    uD = [NSMutableDictionary dictionaryWithDictionary:userDetailDic];
    [self checkNew];
    [leftTableview reloadData];
    
}

- (void)reflashUserProfile {
    
    //if (isRefresh == 1) {
        //所有拉取个人资料的方法都走这里 所以不再判断isRefresh
        [self getMyProfile];
        isRefresh = 0 ;
    
    //}
}


-(void)getMyProfile{
    
    NSString *uid= [Utilities getUniqueUidWithoutQuit];
    
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
//                isOpenVip = [[vip objectForKey:@"schoolEnabled"] integerValue];
                self.payUrl = [vip objectForKey:@"payUrl"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];

                [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[msg objectForKey:@"role"]];
                
                userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
                uD = [NSMutableDictionary dictionaryWithDictionary:userDetailDic];

                
                [self chooseID];
                [leftTableview reloadData];
                
            } else {
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
}

//---检查意见反馈红点
-(void)checkNew{
    
    isNewFeedback = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isNewFeedback"]];
    if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1){
        NSLog(@"1");
        
    }else {
        
//        [_settingImgView removeFromSuperview];
    }
    [self chooseID];
    [leftTableview reloadData];
    
    //lastIDForFeedback
   /* NSString *lastIDForFeedback = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastIDForFeedback"];
    
    if ([lastIDForFeedback length] > 0) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *flag = [FRNetPoolUtils isNewForFeedbackMsg:lastIDForFeedback];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
                
                if ([flag intValue] > 0) {
                    
                    isNewFeedback = @"1";//update 2015.07.13
                    
                }else{
                    
                  
                    isNewFeedback = @"0";//update 2015.07.13
                }
               
                if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1){
                    NSLog(@"1");
                  
                    
                }else {
                    
                    
                    [_settingImgView removeFromSuperview];
                }
                
                //[ reloadData];//update 2015.07.13
                
            });
            
        });
        
    }*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)chooseID{
    NSDictionary *userInfom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];

//    if ([usertype intValue] == 7) {
//        cell.detailTextLabel.text = @"教师";
//    }else if([usertype intValue] == 6){
//        cell.detailTextLabel.text = @"家长";
//    }else if([usertype intValue] == 0){
//        cell.detailTextLabel.text = @"学生";
//    }else if([usertype intValue] == 2){
//        cell.detailTextLabel.text = @"督学";
//    }else if([usertype intValue] == 9){
//        cell.detailTextLabel.text = @"管理员";
//    }
    
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *userType = [userInfom objectForKey:@"role_id"] ;
//    NSDictionary *ewm = [[NSDictionary alloc] initWithObjectsAndKeys:
//                         @"icon_wdewm_.png", @"icon",
//                         @"我的二维码", @"name",
//                         nil];
    
    NSDictionary *xxewm = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"左侧菜单_10.png", @"icon",
                           @"校园二维码", @"name",
                           nil];
    
    
    NSDictionary *wdjf = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"左侧菜单_08.png", @"icon",
                          @"我的积分", @"name",
                          nil];
    
    NSDictionary *wdxx = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"左侧菜单_03.png", @"icon",
                          @"我的消息", @"name",
                          nil];
    
    NSDictionary *wddt = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"左侧菜单_06.png", @"icon",
                          @"我的动态", @"name",
                          nil];
    
    NSDictionary *zhjys = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"左侧菜单_12.png", @"icon",
                           @"账号安全", @"name",
                           nil];

    NSDictionary *yhbb = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_yhbz.png", @"icon",
                          @"用户帮助", @"name",
                          nil];
    NSDictionary *xtsz = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"左侧菜单_14.png", @"icon",
                          @"设置", @"name",
                          nil];
    //Chenth 7.22
    NSDictionary *growVIP = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_leftVIP.png", @"icon",
                          @"成长VIP", @"name",
                          nil];
    NSDictionary *changeChild = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"icon_leftChangeChild", @"icon",
                           @"切换子女", @"name",
                                 nil];

    NSArray *section2 = [NSArray arrayWithObjects:wddt, nil];
    NSArray *section1;
    if ([userType integerValue] == 6) {
        //还没加上 vip 判断
        if ([userInfom objectForKey:@"vip_schoolEnabled"] &&[[userInfom objectForKey:@"student_number_id"] integerValue] > 0) {
            if ([[userInfom objectForKey:@"vip_schoolEnabled"] integerValue]) {
                
                section1 = [NSArray arrayWithObjects:growVIP, wdxx, changeChild, nil];
            }else{
                section1 = [NSArray arrayWithObjects:wdxx, changeChild, nil];
            }
        }else{
        section1 = [NSArray arrayWithObjects: wdxx, changeChild, nil];
        }
    }else{
    section1 = [NSArray arrayWithObjects:wdxx, nil];
    }
//    section1 = [NSArray arrayWithObjects:wdxx,xxewm, nil];
    
    
    
    if ([userType intValue] == 0 || [userType intValue] == 6 || [userType intValue] == 7 || [userType intValue] == 9) {//新增校园管理员亲子绑定入口 2015.07.27
        if ([userType intValue] == 7 || [userType intValue] == 9) {// 我的积分只开放给管理员&教师 ，其他身份不可见。2015.08.04
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"]) {
                pointsDic = [[NSDictionary alloc] init];
                [self getPoints];
            }

            
#if BUREAU_OF_EDUCATION
            section2 = [NSArray arrayWithObjects:wddt, nil];
#else
            section2 = [NSArray arrayWithObjects:xxewm, zhjys,xtsz, nil];
            section1 = [NSArray arrayWithObjects:wdxx,wddt,wdjf ,nil];
#endif
            
            
        }else{

            section2 = [NSArray arrayWithObjects:xxewm, zhjys,xtsz, nil];
            
        }
        
    }else {
        
    }
    
    if (section2 == nil) {
        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2,  nil];
    }else{
        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2,  nil];
    }
    
    
    
    
    
    


}

-(void)getPoints{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Reward",@"ac",
                          @"2",@"v",
                          @"credit", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            pointsDic = [respDic objectForKey:@"message"];
            
            NSString *myPoints = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[pointsDic objectForKey:@"credit"]]];
            
            if ([myPoints length] >0) {
                [[NSUserDefaults standardUserDefaults] setObject:myPoints forKey:@"MyPoints"];
            }
            
            [leftTableview reloadData];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
}
//加载View实例化tableview
-(void)createrView{
    [self.view setBackgroundColor:[UIColor clearColor]];
    leftTableview = [UITableView new];
    leftTableview.delegate = self;
    leftTableview.dataSource = self;
    [leftTableview setBackgroundColor:[UIColor clearColor]];
    leftTableview.separatorStyle = NO;
    [self.view addSubview:leftTableview];
    [leftTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(85);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    
}
//#4.1  此处是头像的点击事件，根据CHOOSE的值判断在哪个页面进行跳转。
-(void)goPersonVC{
    choose=[[NSUserDefaults standardUserDefaults]objectForKey:@"CHOOSE"];
    str =@"7";
    if ([choose isEqualToString:@"1"]) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([choose isEqualToString:@"2"]){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    }else if ([choose isEqualToString:@"3"]){
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([choose isEqualToString:@"4"]){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

//自定义cell左侧icon
-(UIImageView*)leftIcon:(NSString*)icon{
    iconImg = [UIImageView new];
    iconImg.image = [UIImage imageNamed:icon];
    return iconImg;
}
//自定义cellText
-(UILabel *)cellText:(NSString*)text{
//    if (textLable) {
//        [textLable removeFromSuperview];
//    }else{
//    
//    }
    textLable = [UILabel new];
    textLable.text = text;
    textLable.textColor = [UIColor whiteColor];
    return textLable;
}
#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemsArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [(NSArray *)[_itemsArr objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 100;
            break;
        case 1:
            return 20;
            break;
        default:
            break;
    }
    return 1;
}
//未通过审核时候点击重新申请进入审核页面
-(void)goSetPersonalVC{
    choose=[[NSUserDefaults standardUserDefaults]objectForKey:@"CHOOSE"];
    str =@"12";
    if ([choose isEqualToString:@"1"]) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([choose isEqualToString:@"2"]){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if ([choose isEqualToString:@"3"]){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([choose isEqualToString:@"4"]){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }}
//个人头像，姓名，账号
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
//判断审核状态 ——待审核:0  通过审核 :1  拒绝 :2
//        NSDictionary *userInfo = [g_userInfo getUserDetailInfo];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];

        NSString *userType = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"role_id"]];
        NSString *role_checked = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_checked"]];
       
//用户账户
        NSString *account = [userDetailDic objectForKey:@"username"];
//用户姓名
        NSString *users = [userDetailDic objectForKey:@"name"];
        UIView *topView = [[UIView alloc]init];
        [topView setFrame:[UIScreen mainScreen].bounds];
        topView.backgroundColor = [UIColor clearColor];
//ImageView
        UIButton *btn =[UIButton new];
        [btn sd_setImageWithURL:[NSURL URLWithString:[uD objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
        [btn sd_setImageWithURL:[NSURL URLWithString:[uD objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
        [btn addTarget:self action:@selector(goPersonVC) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 30;
        [topView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_top).with.offset(20);
            make.left.equalTo(topView.mas_left).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(60,60));
        }];
        if (userType.integerValue == 6 && [userInfo objectForKey:@"student_number"]) {
            //UserName
            UILabel *userName =[UILabel new];
            userName.text = users;
            [userName setFont:[UIFont systemFontOfSize:16]];
            userName.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
            [topView addSubview:userName];
            [userName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topView.mas_top).with.offset(20);
                make.left.equalTo(topView.mas_left).with.offset(95);
                make.size.mas_equalTo(CGSizeMake(150,16));
            }];
            //UserID
            UILabel *userID = [UILabel new];
            NSDictionary *userInfom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
            NSString *userType = [userInfom objectForKey:@"role_id"] ;
            if ([userType intValue] == 7 || [userType intValue] == 9) {
                if ([@"2"  isEqual: role_checked] ){//未通过审核
                    userID.text = @"未通过审核";
                    UIButton *button = [UIButton new];
                    [button setTitle:@"重新申请" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
                    [button addTarget:self action:@selector(goSetPersonalVC) forControlEvents:UIControlEventTouchUpInside];
                    [topView addSubview:button];
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(userName.mas_bottom).with.offset(10);
                        make.left.equalTo(topView.mas_left).with.offset(130);
                        make.size.mas_equalTo(CGSizeMake(120,13));
                    }];
                }else if ([@"1"  isEqual: role_checked]){//通过审核正常显示账号
                    userID.text = [NSString stringWithFormat:@"账号 : %@",account];
                }else if ([@"0"  isEqual: role_checked]){
                    userID.text = @"待审核";
                }
            }else{
                userID.text = [NSString stringWithFormat:@"账号 : %@",account];
            }
            userID.font = [UIFont systemFontOfSize:13];
            userID.textColor  = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
            [topView addSubview:userID];
            [userID mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(userName.mas_bottom).with.offset(10);
                make.left.equalTo(topView.mas_left).with.offset(95);
                make.size.mas_equalTo(CGSizeMake(150,13));
            }];
            
            
            
            
            
            UILabel *childID = [UILabel new];
            if ([userType intValue] == 6 ) {
                if ([[userInfom objectForKey:@"student_number"] integerValue] > 0){
                    childID.text = [NSString stringWithFormat:@"%@的ID:%@", [userInfom objectForKey:@"student_name" ], [userInfom objectForKey:@"student_number" ]];
                    [topView addSubview:childID];
                    [childID mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(userID.mas_bottom).with.offset(8);
                        make.left.equalTo(userID.mas_left).with.offset(0);
                        make.size.mas_equalTo(CGSizeMake(150,13));
                    }];
                }
            }
            childID.font = [UIFont systemFontOfSize:13];
            childID.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
            
            
            
            return topView;
        

        }else{
//UserName
        UILabel *userName =[UILabel new];
        userName.text = users;
        [userName setFont:[UIFont systemFontOfSize:16]];
        userName.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        [topView addSubview:userName];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_top).with.offset(30);
            make.left.equalTo(topView.mas_left).with.offset(95);
            make.size.mas_equalTo(CGSizeMake(150,16));
        }];
//UserID
        UILabel *userID = [UILabel new];
        NSDictionary *userInfom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        NSString *userType = [userInfom objectForKey:@"role_id"] ;
        if ([userType intValue] == 7 || [userType intValue] == 9) {
        if ([@"2"  isEqual: role_checked] ){//未通过审核
                userID.text = @"未通过审核";
                UIButton *button = [UIButton new];
                [button setTitle:@"重新申请" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [button addTarget:self action:@selector(goSetPersonalVC) forControlEvents:UIControlEventTouchUpInside];
                [topView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(userName.mas_bottom).with.offset(10);
                make.left.equalTo(topView.mas_left).with.offset(150);
                make.size.mas_equalTo(CGSizeMake(80,13));
            }];
        }else if ([@"1"  isEqual: role_checked]){//通过审核正常显示账号
         userID.text = [NSString stringWithFormat:@"账号 : %@",account];
        }else if ([@"0"  isEqual: role_checked]){
        userID.text = @"待审核";
        }
        }else{
        userID.text = [NSString stringWithFormat:@"账号 : %@",account];
        }
        userID.font = [UIFont systemFontOfSize:13];
        userID.textColor  = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        [topView addSubview:userID];
        [userID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userName.mas_bottom).with.offset(10);
            make.left.equalTo(topView.mas_left).with.offset(95);
            make.size.mas_equalTo(CGSizeMake(150,13));
        }];
        
        

        
        
        UILabel *childID = [UILabel new];
        if ([userType intValue] == 6 ) {
            if ([[userInfom objectForKey:@"student_number"] integerValue] > 0){
                childID.text = [NSString stringWithFormat:@"%@的ID:%@", [userInfom objectForKey:@"student_name" ], [userInfom objectForKey:@"student_number_id" ]];
                [topView addSubview:childID];
                [childID mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(userID.mas_bottom).with.offset(8);
                    make.left.equalTo(userID.mas_left).with.offset(0);
                    make.size.mas_equalTo(CGSizeMake(150,13));
                }];
            }
        }
        childID.font = [UIFont systemFontOfSize:13];
        childID.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];

        
        
        return topView;
        }
    }else{
        UIView *secView = [[UIView alloc]init];
        [secView setFrame:[UIScreen mainScreen].bounds];
        secView.backgroundColor = [UIColor clearColor];
        return secView;
    }
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    [footerView setFrame:[UIScreen mainScreen].bounds];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_itemsArr count]-1 == section) {
        return 20;
    }else {
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[LeftTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
//#3.24隐藏掉系统自带小箭头，自定义img并调整位置
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.1];
    
    cell.textLabelC.text = [NSString stringWithFormat:@"%@",[[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]];
    
//    [cell.textLabel addSubview:[self cellText:[[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]];

    
//#3.24自定义icon图标，干掉原来的
//    if (iconLeftImageV) {
////        [iconLeftImageV removeFromSuperview];
//    }
    iconLeftImage =[[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"icon"];
    cell.imageViewC.image = [UIImage imageNamed:iconLeftImage];
//    iconLeftImageV = [self leftIcon:iconLeftImage];
//    [iconLeftImageV removeFromSuperview];
//    [cell.contentView addSubview:iconLeftImageV];
//    

    
    if ([@"设置"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]) {
        
        cell.redPoint.hidden = YES;
        if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
            
            
            if ([cell viewWithTag:223]) {
                cell.redPoint.hidden = NO;
                
            }else{
//                [cell addSubview:_settingImgView];
            }
            
        }else{
//            [_settingImgView removeFromSuperview];
        }
        
    }else if ([@"我的消息"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]){
        

        //MyMsgNewCount
        NSString *isNewForMsg = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMsgNewCount"];
        //NSLog(@"cell.frame.size.width:%f",cell.frame.size.width);
        
        cell.MyMsgsImgView.hidden = YES;
        if (isNewForMsg!=nil && [isNewForMsg intValue] >= 1) {
            
            if ([cell viewWithTag:224]) {
                cell.MyMsgsImgView.hidden = NO;
                
            }else{
                
            }
            
        }
        
    }else if ([@"我的积分"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]){
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"]){
            cell.detailTextLabelC.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[pointsDic objectForKey:@"credit"]]];
        }else{
            cell.detailTextLabelC.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"];
        }
        cell.detailTextLabelC.hidden = YES;
    }else{
        cell.redPoint.hidden = YES;
        cell.MyMsgsImgView.hidden = YES;
        cell.detailTextLabelC.text = @"";//2015.11.16
        
        CGPoint contentOffsetPoint = tableView.contentOffset;
        CGRect frame = tableView.frame;
        if (contentOffsetPoint.y > tableView.contentSize.height - frame.size.height)//已经到了tableview底部，继续上拉,最后一行上的new标记会消失，在此判断下
        {
            
        }else{
//            _settingImgView.hidden = YES;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index:%@", @(indexPath.row));
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    choose=[[NSUserDefaults standardUserDefaults]objectForKey:@"CHOOSE"];
    NSString *userType = [user objectForKey:@"role_id"];
    NSString *name = [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];
//#4.1  根据choose的值判断往哪个页面发送通知。1.SchoolHome 2.MyclassList 3.ParkHome 4.MyclassDetail str是通知传值，在4个主页面判断该跳转哪个页面。
            if ([@"我的消息"  isEqual: name]) {//我的消息
                 str =@"1";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                
//                [MyMsgsImgView removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"MyMsgNewCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else if ([@"我的动态"  isEqual: name]){
                str =@"2";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"我的积分" isEqualToString:name]) {
                 str =@"3";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num",name,@"name", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num",name,@"name", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                }else if ([@"校园二维码"  isEqual: name]){//校园二维码
                str =@"4";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                }else if ([@"账号安全"  isEqual: name]){//账号安全
                str =@"5";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"设置"  isEqual: name]) {
                 str =@"6";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"成长空间"  isEqual: name]) {
                str =@"8";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"我的二维码"  isEqual: name]) {
                str =@"9";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"亲子关系绑定"  isEqual: name]) {
                str =@"10";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if ([@"用户帮助"  isEqual: name]) {
                str =@"11";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }else if([@"切换子女"  isEqual: name]) {
                str =@"13";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }

            }else if ([@"成长VIP"  isEqual: name]){
                str =@"14";
                if ([choose isEqualToString:@"1"]) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num",_payUrl, @"payUrl" ,nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"2"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num",_payUrl, @"payUrl" , nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"3"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num",_payUrl, @"payUrl" , nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }else if ([choose isEqualToString:@"4"]){
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"num", _payUrl, @"payUrl" ,nil];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi4" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }

            }
    [leftTableview reloadData];
        }


@end

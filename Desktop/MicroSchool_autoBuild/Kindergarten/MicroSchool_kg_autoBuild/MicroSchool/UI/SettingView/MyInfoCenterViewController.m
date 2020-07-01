//
//  MyInfoCenterViewController.m
//  MicroSchool
//  个人中心
//  Created by Kate on 14-10-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyInfoCenterViewController.h"
#import "SetPersonalInfoTableViewCell.h"
#import "SetPersonalInfoViewController.h"
#import "SettingViewController.h"
#import "AccountandPrivacyViewController.h"
#import "ChildViewController.h"
#import "ParenthoodListForParentTableViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "MyPointsViewController.h"
#import "GrowthNotValidateViewController.h"
#import "SchoolQRCodeViewController.h"

@interface MyInfoCenterViewController ()

@end

@implementation MyInfoCenterViewController

// 2015.11.13
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
#if 0
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkNewIconForMsgCenter)
                                                     name:@"checkMsgCenterNew"
                                                   object:nil];
#endif
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkNewIconForMsgCenter)
                                                     name:@"checkMsgCenterTabNew"
                                                   object:nil];
        
        noticeImgVForMsg =[[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 224;
      
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCustomTabTitle:)
                                                 name:@"setCustomNavTitle2"
                                               object:nil];
    
    [super setCustomizeTitle:@"我"];
    //---------------------------------------------------
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"tabTitles"];
    
    if([tempArray count] > 0){
        [self setCustomizeTitle:[tempArray objectAtIndex:3]];
    }
    //-------------------------------------------------------
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];

   
    button_req = [UIButton buttonWithType:UIButtonTypeCustom];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              WIDTH,
                                                              [UIScreen mainScreen].applicationFrame.size.height - 44-48) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = imgView_bgImg;
    
    [self.view addSubview:_tableView];
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(125+10, (44 - 18)/2+2, 21, 21);
    imgView.image = [UIImage imageNamed:@"icon_hot.png"];
    
    
    
//    noticeImgVForMsg =[[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
//    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
//    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
//    [button addSubview:noticeImgVForMsg];
//    noticeImgVForMsg.hidden = YES;
   
    
    settingNewImg = [[UIImageView alloc]init];
    settingNewImg.image = [UIImage imageNamed:@"icon_forNew"];
//    settingNewImgForFeedback = [[UIImageView alloc]init];
//    settingNewImgForFeedback.image = [UIImage imageNamed:@"icon_forNew"];
    
    pointNewImg = [[UIImageView alloc]init];
    pointNewImg.image = [UIImage imageNamed:@"icon_forNew"];

    
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *userType = [user objectForKey:@"role_id"];
    
    if ([userType intValue] == 0 || [userType intValue] == 6 || [userType intValue] == 7){
        settingNewImg.frame = CGRectMake(92+50.0, 130+300 - 25 +7 -9 - 15, 30.0, 18.0);
//        settingNewImgForFeedback.frame = CGRectMake(92+50.0, 130+300 - 25 +7 -9 - 15, 30.0, 18.0);
    }else{
        
        settingNewImg.frame = CGRectMake(92+50.0, 130+300 - 25 +7 -9 - 15 - 50, 30.0, 18.0);
//        settingNewImgForFeedback.frame = CGRectMake(92+50.0, 130+300 - 25 +7 -9 - 15, 30.0, 18.0);
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkNewIconForMsgCenter)
//                                                 name:@"checkMsgCenterNew"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(teacherApplyResult)
                                                 name:@"teacher_apply_result"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingNew:)
                                                 name:@"settingNew"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeNewForFeedback:)
                                                 name:@"removeNewForFeedback"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMyPoints:)
                                                 name:@"refreshMyPoints"
                                               object:nil];

    //------------add by kate 2014.12.03-------------------------------------------------
//    [self checkNewIconForMsgCenter:_count];
    //-------------------------------------------------------------
    
    _redLabel = [[UILabel alloc]init];
    
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    
//    if ([isNewVersion intValue] == 1) {
//        
//            [_tableView addSubview:settingNewImg];
//            noticeImgVForMsg.hidden = NO;
//        
//    }else{
//        
//           [settingNewImg removeFromSuperview];
//           noticeImgVForMsg.hidden = YES;
//    }

    NSDictionary *ewm = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_wdewm_.png", @"icon",
                          @"我的二维码", @"name",
                          nil];

    NSDictionary *xxewm = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"icon_xxewm_.png", @"icon",
                         @"学校二维码", @"name",
                         nil];


    NSDictionary *wdjf = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_wdjf.png", @"icon",
                          @"我的积分", @"name",
                          nil];
    
    NSDictionary *wdxx = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"icon_wdxx.png", @"icon",
                         @"我的消息", @"name",
                         nil];

    NSDictionary *wddt = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"icon_wddt.png", @"icon",
                      @"我的动态", @"name",
                      nil];

    NSDictionary *zhjys = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"icon_zhjys.png", @"icon",
                      @"账号及隐私", @"name",
                      nil];
#if 0
    NSDictionary *qzgxbd = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"icon_qzgx.png", @"icon",
                      @"亲子关系绑定", @"name",
                      nil];
#endif
    NSDictionary *yhbb = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"icon_yhbz.png", @"icon",
                      @"用户帮助", @"name",
                      nil];
    NSDictionary *xtsz = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"icon_sz.png", @"icon",
                      @"系统设置", @"name",
                      nil];
    
//    NSDictionary *czkj = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"icon_czkj.png", @"icon",
//                          @"成长空间",@"name",
//                          nil];

    //NSArray *section1 = [NSArray arrayWithObjects:ewm, nil];
#if 0
    NSArray *section2 = [NSArray arrayWithObjects:wdxx, wddt, nil];
#endif
    NSArray *section2 = [NSArray arrayWithObjects:wddt, nil];
    NSArray *section4 = [NSArray arrayWithObjects:xtsz, nil];
    
    NSArray *section1;
//    if ([userType intValue] == 0 || [userType intValue] == 6) {//学生或家长开放成长空间 2015.09.18
//         section1 = [NSArray arrayWithObjects:czkj,ewm, nil];
//    }else{

        section1 = [NSArray arrayWithObjects:ewm,xxewm, nil];

//    }
    
    
    NSArray *section3;
    if ([userType intValue] == 0 || [userType intValue] == 6 || [userType intValue] == 7 || [userType intValue] == 9) {//新增校园管理员亲子绑定入口 2015.07.27
        section3 = [NSArray arrayWithObjects:zhjys, yhbb, nil];
        if ([userType intValue] == 7 || [userType intValue] == 9) {// 我的积分只开放给管理员&教师 ，其他身份不可见。2015.08.04
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"]) {
              
                pointsDic = [[NSDictionary alloc] init];
                [self getPoints];
            }
#if 0
            section2 = [NSArray arrayWithObjects:wdjf, wdxx, wddt, nil];
#endif
            
#if BUREAU_OF_EDUCATION
        section2 = [NSArray arrayWithObjects:wddt, nil];
#else
       section2 = [NSArray arrayWithObjects:wdjf, wddt, nil];
#endif
            
            
        }else{
#if 0
            section2 = [NSArray arrayWithObjects:wdxx, nil];
#endif
            section2 = nil;

        }
        
    }else {
        section3 = [NSArray arrayWithObjects:zhjys, yhbb,nil];
    }
    
    if (section2 == nil) {
        _itemsArr = [NSMutableArray arrayWithObjects:section1, section3, section4, nil];
    }else{
       _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, section3, section4, nil];
    }
    
    
    
    _settingImgView = [[UIImageView alloc] init];
}

// 自定义tabTitle-----------------------------------------
-(void)setCustomTabTitle:(NSNotification*)notification{
    
    NSMutableArray *titleList  =  (NSMutableArray*)[notification object];
    
    if (titleList!=nil) {
        if ([titleList count]>0) {
            
            [self setCustomTabTitle:[[titleList objectAtIndex:3] objectForKey:@"name"]];
        }
    }
    
}
//--------------------------------------------------------------

//------------add by kate 2014.12.03-------------------------------------------------
-(void)checkNewIconForMsgCenter:(NSString*)count{
    
    if([count intValue] > 0){
        
        NSInteger length = [count length];
        _redLabel.frame = CGRectMake(138, (44 - 18)/2+2, length*15, 20);

        if (length == 1) {
            _redLabel.frame = CGRectMake(138, (44 - 18)/2+2, 20, 20);

        }
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.text = count;
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.layer.cornerRadius = 10.0;
        _redLabel.layer.masksToBounds = YES;
        _redLabel.textAlignment = NSTextAlignmentCenter;
//        [_tableView addSubview:_redLabel];
        
    }
   
}

-(void)teacherApplyResult
{

}

-(void)settingNew:(NSNotification*)notify{
    
//    NSString *isNew = (NSString*)[notify object];
//    if ([isNew intValue] == 1) {
//        isNewVersion = @"1";
//         [_tableView addSubview:settingNewImg];
//    }else{
//       isNewVersion = @"0";
//       [settingNewImg removeFromSuperview];
//    }
    
}


# if 0
// 我的消息红点检查接口
-(void)checkNewIconForMsgCenter{
    
    /*
     params.put("ac", "MessageCenter");
     params.put("v", "2");
     params.put("op", "check");
     params.put("last", id + "");
     params.put("uid", ConfigDao.getInstance().getUID() + "");
     params.put("sid", MainConfig.sid);
     */
    //[noticeImgVForMsg removeFromSuperview];
    
    NSString *lastId_news = nil;
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    lastId_news = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyMsgLastId"];
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
        if ([isNewVersion intValue] == 0) {//update by kate 2015.03.13
            
            noticeImgVForMsg.hidden = YES;
            
        }else{
            noticeImgVForMsg.hidden = NO;
        }
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int count = [FRNetPoolUtils checkNewsForMsg:lastId_news];
            
            NSString *countNew = [NSString stringWithFormat:@"%d",count];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (count > 0) {
                    
                    //[self.navigationController.navigationBar addSubview:noticeImgVForMsg];
                    //-----update by kate 2014.12.30---------------------------
                     [self checkNewIconForMsgCenter:countNew];
//                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//                    
//                    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
//                    [button addSubview:noticeImgVForMsg];
                    noticeImgVForMsg.hidden = NO;//update by kate 2015.03.13
                    //-----------------------------------------------------------
                    
                    [_tableView reloadData];
                    
                }else{
                    
                    _redLabel.text = @"0";
                    [_tableView reloadData];
                    
                    //[noticeImgVForMsg removeFromSuperview];
                    if ([isNewVersion intValue] == 0) {//update by kate 2015.03.13
                    
                        noticeImgVForMsg.hidden = YES;
                        
                    }else{
                        noticeImgVForMsg.hidden = NO;
                    }
                        
                }
                
            });
        });
        
    }
    
}
#endif

/**
 * 检查是否有新消息
 * @author luke
 * @date 2015.11.12
 * @args
 *  v=2, op=checkNewMessage, sid=, uid= ,last=最新消息ID
 */
// 我的消息红点检查接口
-(void)checkNewIconForMsgCenter{

    /*NSString *lastId_news = nil;
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //lastId_news = [userDefaults objectForKey:@"MyMsgLastId"];
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
        if ([isNewVersion intValue] == 0) {
            
            noticeImgVForMsg.hidden = YES;
            
        }else{
            noticeImgVForMsg.hidden = NO;
        }
    }else*/{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
        UIImageView *imgV = (UIImageView*)[button viewWithTag:224];
        isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
        
        if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1){
            
            if (imgV) {
                
            }else{
                
                [noticeImgVForMsg removeFromSuperview];
                [button addSubview:noticeImgVForMsg];
                //noticeImgVForMsg.hidden = YES;
            }
            
        }else {
            [_settingImgView removeFromSuperview];
        }
        
        [self checkNew];
        
        /*
         NSString *lastId_news = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"MyMsgLastId"]]];
         
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
                
                //NSLog(@"last:%@",last);
                
                if ([lastId_news length] == 0) {
                
                    [userDefaults setObject:last forKey:@"MyMsgLastId"];
                }
                
                NSString *count = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"count"]];
                
                //NSLog(@"count:%@",count);
                
                if ([count integerValue] > 0) {
                    
                    [self checkNewIconForMsgCenter:count];
                    
                   
                    if(imgV.hidden){
                        [imgV removeFromSuperview];
                    }else{
                        [imgV removeFromSuperview];
                        [button addSubview:noticeImgVForMsg];
                    }
                    
                    noticeImgVForMsg.hidden = NO;
                    
                    [_tableView reloadData];
                    
                }else{
                    
                    _redLabel.text = @"0";
                    [_tableView reloadData];
                    
                    if ([isNewVersion intValue] == 0) {
                        
                       noticeImgVForMsg.hidden = YES;
                        
                    }else{
                        
                        if(imgV.hidden){
                            [imgV removeFromSuperview];
                        }else{
                            [imgV removeFromSuperview];
                            [button addSubview:noticeImgVForMsg];
                        }
                        noticeImgVForMsg.hidden = NO;
                        
                    }
                    
                }
                
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
        }];*/

        
    }
}


//---检查意见反馈红点
-(void)checkNew{
    
    //lastIDForFeedback
    NSString *lastIDForFeedback = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastIDForFeedback"];
    
    if ([lastIDForFeedback length] > 0) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *flag = [FRNetPoolUtils isNewForFeedbackMsg:lastIDForFeedback];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
                UIImageView *imgV = (UIImageView*)[button viewWithTag:224];
                isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
                
                if ([flag intValue] > 0) {
                    
                    //[_tableView addSubview:settingNewImgForFeedback];
                    isNewFeedback = @"1";//update 2015.07.13
                 
                }else{
                    
                    //[settingNewImgForFeedback removeFromSuperview];
                    
                    isNewFeedback = @"0";//update 2015.07.13
                }
                
//                 NSString *isNewVersionShowFeature = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
//                if ((nil == isNewVersionShowFeature) || ([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
                if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1){
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
                }
                
                 [_tableView reloadData];//update 2015.07.13
                
            });
            
        });
        
    }
    
}

-(void)removeNewForFeedback:(id)sender{
    
    [settingNewImgForFeedback removeFromSuperview];

}

//-------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self doShowUserViewNew];
    _tableView.tableHeaderView = headerView;
#if 0
    [self checkNewIconForMsgCenter];
#endif
    [self checkNew];// add by kate 2015.02.16
    
    [MyTabBarController setTabBarHidden:NO];
    
    /*去掉new标实
     if (imgNew) {
        
        NSString *isDuty = [[NSUserDefaults standardUserDefaults]objectForKey:@"isDuty"];
        NSString *isSubject = [[NSUserDefaults standardUserDefaults]objectForKey:@"isSubject"];
        
        if ([isDuty integerValue]== 1 && [isSubject integerValue] == 1) {
            [imgNew removeFromSuperview];
        }
        
    }*/

    //NSString *isNewVersionShowFeature = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
    // NSString *cacheNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheNew"];
     //NSString *pointsNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointsNew"];
    
    //if ((nil == isNewVersionShowFeature) || ([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
    if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
        
    }else {
        [_settingImgView removeFromSuperview];
    }
    
   /*去掉new标实
    NSString *isDuty = [[NSUserDefaults standardUserDefaults]objectForKey:@"isDuty"];
    NSString *isSubject = [[NSUserDefaults standardUserDefaults]objectForKey:@"isSubject"];
    
    if ((nil != isNewVersionShowFeature) && ([isNewVersion intValue] != 1) && [isDuty integerValue]== 1 && [isSubject integerValue] == 1){
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
        UIImageView *tabNewImgV = (UIImageView*)[button viewWithTag:123];
        [tabNewImgV removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isCenterNew"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }*/
    
    //if ((nil != isNewVersionShowFeature) && ([isNewVersion intValue] != 1) &&([pointsNew length] > 0)){
      //if ((nil != isNewVersionShowFeature) && ([isNewVersion intValue] != 1)){//2015.09.09
       if (([isNewVersion intValue] != 1)){//2015.09.09

        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
          
        UIImageView *msgTabNewImgV = (UIImageView*)[button viewWithTag:224];
          //不知为何 直接hiddeen这个tab上的imgv不好用，必须remove所以加入下边的判断 2016.01.04
          if(msgTabNewImgV.hidden){
              [msgTabNewImgV removeFromSuperview];
          }
          
          NSArray *array = [button subviews];
          for (int i=0; i<[array count]; i++) {
              
              if([[array objectAtIndex:i] isKindOfClass:[UIImageView class]]){
              
                  UIImageView *imgV = [array objectAtIndex:i];
                  NSLog(@"tag:%ld",(long)imgV.tag);
                  if (imgV.tag == 123) {
                      [imgV removeFromSuperview];
                  }
                  
              }
                 
              
          }

          
        UIImageView *tabNewImgV = (UIImageView*)[button viewWithTag:123];
        [tabNewImgV removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isCenterNew"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }

    [_tableView reloadData];
    
    [ReportObject event:ID_OPEN_PERSON_CENTER];//2015.06.25
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
  
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
   
        return [_itemsArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[_itemsArr objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 20;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_itemsArr count]-1 == section) {
        return 20;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:[[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"icon"]];
    
    //cell.imageView.image = [UIImage imageNamed:@"wdewm.png"];

    if ([@"系统设置"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]) {
        
        _settingImgView.hidden = NO;
        
        //NSString *isNewVersionShowFeature = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
         //NSString *cacheNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheNew"];
        
//        if ((nil == isNewVersionShowFeature) || ([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
        if (([isNewVersion intValue] == 1) || [isNewFeedback intValue] == 1) {
//            _settingImgView.frame = CGRectMake(138, (44 - 18)/2+2, 32, 20);
//            _settingImgView.image = [UIImage imageNamed:@"icon_forNew.png"];
            
            _settingImgView.frame = CGRectMake(cell.frame.size.width - 40.0,(50.0 - 10)/2-0.5 , 10.0, 10.0);
            _settingImgView.image = [UIImage imageNamed:@"icon_new.png"];//2015.11.25
            _settingImgView.tag = 223;
            
            if ([cell viewWithTag:223]) {
                
            }else{
                [cell addSubview:_settingImgView];
            }
            
        }
        
    }else if ([@"我的消息"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]){
        
#if 0
        if ([_redLabel.text integerValue] != 0) {
             [cell addSubview:_redLabel];
        }else{
            [_redLabel removeFromSuperview];
        }
#endif
       
    }else if ([@"我的积分"  isEqual: [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"]]){
       
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"]){
             cell.detailTextLabel.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[pointsDic objectForKey:@"credit"]]];
        }else{
             cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyPoints"];
        }
        
        // 我的积分new标记去掉 2015.09.09
//        NSString *pointsNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointsNew"];
//        
//        if (nil == pointsNew) {
//            
//            pointNewImg.frame = CGRectMake(138, (44 - 18)/2+2, 32, 20);
//            pointNewImg.image = [UIImage imageNamed:@"icon_forNew.png"];
//            pointNewImg.tag = 222;
//            
//            if ([cell viewWithTag:222]) {
//                
//            }else{
//                [cell addSubview:pointNewImg];
// 
//            }
//            
//        }else{
//            [pointNewImg removeFromSuperview];
//           
//        }
        
    }else{

        cell.detailTextLabel.text = @"";//2015.11.16
        
        CGPoint contentOffsetPoint = tableView.contentOffset;
        CGRect frame = tableView.frame;
        if (contentOffsetPoint.y > tableView.contentSize.height - frame.size.height)//已经到了tableview底部，继续上拉,最后一行上的new标记会消失，在此判断下
        {
           
        }else{
           _settingImgView.hidden = YES;
        }
        
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
   
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *userType = [user objectForKey:@"role_id"];
    
    NSString *name = [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];

    if ([@"我的积分" isEqualToString:name]) {
        
        //[[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"pointsNew"];
        
        if ([userType integerValue] == 7) {//教师
            [ReportObject event:ID_CLICK_MYPOINT_TEACHER];
        }else if ([userType integerValue] == 9){//管理员
            [ReportObject event:ID_CLICK_MYPOINT_ADMIN];
        }
     
        MyPointsViewController *myPoint = [[MyPointsViewController alloc]init];
        myPoint.titleName = name;
        [self.navigationController pushViewController:myPoint animated:YES];
        
    }else if ([@"成长空间"  isEqual: name]) {//2015.09.18
        
        GrowthNotValidateViewController *growthnv = [[GrowthNotValidateViewController alloc]init];
        [self.navigationController pushViewController:growthnv animated:YES];
        
    }else if ([@"我的二维码"  isEqual: name]) {
        MyQRCodeViewController *qrViewCtrl = [[MyQRCodeViewController alloc] init];
        [self.navigationController pushViewController:qrViewCtrl animated:YES];
    }else if ([@"我的消息"  isEqual: name]) {
        
        [_redLabel removeFromSuperview];//add by kate 2014.12.03
        if ([isNewVersion intValue] == 0) {//update by kate 2015.03.13
            
            noticeImgVForMsg.hidden = YES;
            
        }else{
            noticeImgVForMsg.hidden = NO;
        }

        MessageCenterViewController *msgCenterViewCtrl = [[MessageCenterViewController alloc] init];
        msgCenterViewCtrl.title = @"我的消息";
        [self.navigationController pushViewController:msgCenterViewCtrl animated:YES];
    }else if ([@"我的动态"  isEqual: name]) {
        MomentsViewController *momentsV = [[MomentsViewController alloc]init];
        momentsV.titleName = @"我的动态";
        momentsV.fromName = @"mine";
        [self.navigationController pushViewController:momentsV animated:YES];
    }else if ([@"账号及隐私"  isEqual: name]) {
        AccountandPrivacyViewController *accountandprivacy = [[AccountandPrivacyViewController alloc]init];
        [self.navigationController pushViewController:accountandprivacy animated:YES];
    }else if ([@"亲子关系绑定"  isEqual: name]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ParentNew_Done"];
        
        if ([userType intValue] == 0) {
            
            ChildViewController *childV = [[ChildViewController alloc] init];
            [self.navigationController pushViewController:childV animated:YES];
            
        }else{
            
            ParenthoodListForParentTableViewController *parentListV = [[ParenthoodListForParentTableViewController alloc]init];
            [self.navigationController pushViewController:parentListV animated:YES];
            
        }
    }else if ([@"用户帮助"  isEqual: name]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HelpNew_Done"];
        HelpViewController *helpV = [[HelpViewController alloc] init];
        [self.navigationController pushViewController:helpV animated:YES];
    }else if ([@"系统设置"  isEqual: name]) {
        
        SettingViewController *settingView = [[SettingViewController alloc]init];
        settingView.isNewVersion = isNewVersion;
        [self.navigationController pushViewController:settingView animated:YES];
        
    }else if ([@"学校二维码"  isEqual: name]){
        
        SchoolQRCodeViewController *schoolQRVC = [[SchoolQRCodeViewController alloc] init];
        [self.navigationController pushViewController:schoolQRVC animated:YES];
        
    }
    
      [MyTabBarController setTabBarHidden:YES];
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)doShowUserViewNew
{
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    
    NSString* realname = [message_info objectForKey:@"name"];
    NSString *roleName = [ message_info objectForKey:@"role_name"];
    NSString* username = [message_info objectForKey:@"username"];
    NSString* duty = [message_info objectForKey:@"duty"];
    NSString* mobile = [message_info objectForKey:@"mobile"];
    NSString* roleId = [message_info objectForKey:@"role_id"];

    NSString *name;
    if ((nil != duty) && (![@""  isEqual: duty])) {
        name = [NSString stringWithFormat:@"%@|%@",realname,duty];
    }else {
        name = [NSString stringWithFormat:@"%@|%@",realname,roleName];
    }
    
    NSString *usernameStr = @"";
    if (![@""  isEqual: mobile]) {
        usernameStr = [NSString stringWithFormat:@"注册手机:%@",mobile];
    }else {
        usernameStr = [NSString stringWithFormat:@"注册手机:未绑定"];
    }
    
    NSString* sex = [message_info objectForKey:@"sex"];
    //reason = [message_info objectForKey:@"role_reason"];
    NSString* spacenote = [message_info objectForKey:@"spacenote"];
    NSString* checked = [message_info objectForKey:@"role_checked"];
    NSString* usertype = [message_info objectForKey:@"role_id"];
    reason = [message_info objectForKey:@"role_reason"];
    //-----------------------------------------------------
    
    if(!headerView){
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,110.0)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 25, (122.0-18.0)/2.0, 12.0, 12.0)];
        imgV.image = [UIImage imageNamed:@"accessory.png"];
        [headerView addSubview:imgV];
        
        /*去掉new标记
         if ([usertype integerValue] == 7 || [usertype integerValue] == 9) {
            
            NSString *isCenterNew = [[NSUserDefaults standardUserDefaults]objectForKey:@"isCenterNew"];
            if (!isCenterNew) {
                
                imgNew = [[UIImageView alloc] init];
                imgNew.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 25 -30,  (122.0-20.0)/2.0, 30, 18);;
                imgNew.image = [UIImage imageNamed:@"icon_forNew.png"];
                [headerView addSubview:imgNew];
                
                
            }
        }*/
        
    
       UIButton *gotoMyInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       gotoMyInfoBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 72 + 20 + 10);
       [gotoMyInfoBtn addTarget:self action:@selector(gotoMyInfoView) forControlEvents:UIControlEventTouchUpInside];
       gotoMyInfoBtn.backgroundColor = [UIColor clearColor];
       [headerView addSubview:gotoMyInfoBtn];
        
        // 头像图片
        headImgView =[[UIImageView alloc]initWithFrame:CGRectMake(40-20,13,70,70)];
        headImgView.layer.masksToBounds = YES;
        headImgView.layer.cornerRadius = 70/2;
        headImgView.contentMode = UIViewContentModeScaleToFill;
        NSString *headUrl = [message_info objectForKey:@"avatar"];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
        [headerView addSubview:headImgView];
        
        //---update by kate 2014.10.15-----------------------------------------
        UIButton *touchImgHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchImgHeadBtn.frame = CGRectMake(40,10,60,60);
        [touchImgHeadBtn addTarget:self action:@selector(touchImgHeadAction) forControlEvents:UIControlEventTouchUpInside];
        touchImgHeadBtn.backgroundColor = [UIColor clearColor];
        [headerView addSubview:touchImgHeadBtn];
        //--------------------------------------------------------------------
        
        
        // 姓名
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(140-20, 26, 280, 20)];
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        label_name.font = [UIFont systemFontOfSize:15.0f];
        label_name.text = name;
        [headerView addSubview:label_name];
        
        // 性别icon
        imgView_gender =[[UIImageView alloc]initWithFrame:CGRectMake(118-20,26,17,17)];
        if ([@"2"  isEqual: sex]) {
            imgView_gender.image=[UIImage imageNamed:@"icon_female.png"];
        }
        else {
            imgView_gender.image=[UIImage imageNamed:@"icon_male.png"];
        }
        [headerView addSubview:imgView_gender];
        
//        if ([@"6"  isEqual: [NSString stringWithFormat:@"%@",roleId]]) {
//            label_name.frame = CGRectMake(118, 26, 280, 20);
//            imgView_gender.hidden = YES;
//        }
        
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(117-20, label_name.frame.origin.y+label_name.frame.size.height+5, 150, 20)];
        userNameLabel.font = [UIFont systemFontOfSize:13.0];
        userNameLabel.text = usernameStr;
        [headerView addSubview:userNameLabel];
        // 是否审批
        label_class = [[UILabel alloc] initWithFrame:CGRectMake(117-22, userNameLabel.frame.origin.y+20+5, 102, 20)];
        label_class.font = [UIFont systemFontOfSize:13.0f];
        label_class.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label_class];
        
        // 个性签名
        label_sign = [[UILabel alloc] initWithFrame:CGRectMake(40-20, label_class.frame.origin.y+20, 260, 20)];
        label_sign.textColor = [UIColor blackColor];
        label_sign.font = [UIFont systemFontOfSize:13.0f];
        label_sign.backgroundColor = [UIColor clearColor];
        label_sign.lineBreakMode = NSLineBreakByTruncatingTail;
//         [headerView addSubview:label_sign];
        
        label_sign_mask = [[UIButton alloc] initWithFrame:CGRectMake(40-20, label_sign.frame.origin.y, 260, 20)];
        [label_sign_mask setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        label_sign_mask.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        label_sign_mask.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [label_sign_mask addTarget:self action:@selector(goToProfile_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [headerView addSubview:label_sign_mask];
    }
    
 
     //------------------------------------------------------------------------
     NSString *headUrl = [message_info objectForKey:@"avatar"];
     [headImgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
     label_name.text = name;
     if ([@"2"  isEqual: sex]) {
        imgView_gender.image=[UIImage imageNamed:@"icon_female.png"];
     }
     else {
        imgView_gender.image=[UIImage imageNamed:@"icon_male.png"];
     }
     userNameLabel.text = usernameStr;
    
    if ([@"" isEqualToString: spacenote]) {
        // 2015.10.19 zamir邮件文案确认
//        spacenote = @"（您还没有设置个性签名）";
//        label_sign.textColor = [UIColor blueColor];
    }else {
        label_sign.textColor = [UIColor blackColor];
    }
  
    label_sign.text = spacenote;
    
    
    if ([@"7"  isEqual: [NSString stringWithFormat:@"%@", usertype]]) {
        if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]]) {
            [button_req removeFromSuperview];
            
#if 0
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"（ 等待审批 ）"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,5)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(6,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(2, 5)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(6, 1)];
            
            label_class.attributedText = str;
#endif
            
            [label_class setTextColor:[UIColor redColor]];
            label_class.text = @"(等待审批)";
          
        }else if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]]) {
#if  0
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"（ 身份申请未通过 ）"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,8)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(2, 8)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(9, 1)];
           
            label_class.attributedText = str;
            
#endif
            
            [label_class setTextColor:[UIColor redColor]];
            label_class.text = @"(身份申请未通过)";

            button_req.frame = CGRectMake(label_class.frame.origin.x + label_class.frame.size.width+5,
                                          label_class.frame.origin.y-3,
                                          60,
                                          25);
            
            [button_req setTitle:@"重新申请" forState:UIControlStateNormal];
            [button_req setTitle:@"重新申请" forState:UIControlStateHighlighted];
            button_req.titleLabel.textAlignment = NSTextAlignmentCenter;
            button_req.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [button_req setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button_req setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            button_req.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            [button_req setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
            [button_req setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
            [button_req addTarget:self action:@selector(reSendReq_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            [headerView addSubview:button_req];
        }else if ([@"1"  isEqual: [NSString stringWithFormat:@"%@", checked]]) {
            // 通过申请
            [button_req removeFromSuperview];
            label_class.text = @"";
        }
    }
    //--------------------------------------------
}

- (void)goToProfile_btnclick:(id)sender
{
    if ([@"（您还没有设置个性签名）" isEqual: label_sign.text]) {
        
        [MyTabBarController setTabBarHidden:YES];
        SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
        [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
        //-------------------------------------------------------------------------------------------------
        
    }
}

// 点击主页menu上方的个人信息介绍部分跳转至个人信息页
-(void)gotoMyInfoView{
    
    [MyTabBarController setTabBarHidden:YES];
    
    /*去掉new标实
     if (imgNew) {
       
        NSString *isDuty = [[NSUserDefaults standardUserDefaults]objectForKey:@"isDuty"];
        NSString *isSubject = [[NSUserDefaults standardUserDefaults]objectForKey:@"isSubject"];
        
        if ([isDuty integerValue]== 1 && [isSubject integerValue] == 1) {
             [imgNew removeFromSuperview];
        }
        
    }*/
   
    SetPersonalInfoViewController *setPersonalViewCtrl = [[SetPersonalInfoViewController alloc] init];
    setPersonalViewCtrl.title = @"个人信息";
    [self.navigationController pushViewController:setPersonalViewCtrl animated:YES];
    
}

- (IBAction)reSendReq_btnclick:(id)sender
{
    [MyTabBarController setTabBarHidden:YES];
    
    SetPersonalViewController *personalTeacherViewCtrl = [[SetPersonalViewController alloc] init];
    personalTeacherViewCtrl.viewType = @"resendTeacherRequest";
    personalTeacherViewCtrl.iden = @"teacher";
    
    [self.navigationController pushViewController:personalTeacherViewCtrl animated:YES];

#if 0
    SetPersonalTeacherViewController *personalTeacherViewCtrl = [[SetPersonalTeacherViewController alloc] init];
    personalTeacherViewCtrl.reason = reason;
    
    [self.navigationController pushViewController:personalTeacherViewCtrl animated:YES];
    
#endif
}

// 查看头像大图
-(void)touchImgHeadAction{
    
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    
    //    NSString* uid = [message_info objectForKey:@"uid"];
    //    Utilities *util = [Utilities alloc];
    //NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"2"];
    NSString *head_url = [message_info objectForKey:@"avatar"];
    NSString *imgUrl =   [NSString stringWithFormat:@"%@&original=1",head_url];
 
    //    UIImageView *imageView = [[UIImageView alloc]init];
    //    imageView.backgroundColor = [UIColor clearColor];
    //    if(IS_IPHONE_5){
    //        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    //    }else{
    //        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    //    }
    // 1.封装图片数据
    //设置所有的图片。photos是一个包含所有图片的数组。
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.save = NO;
    photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
    photo.srcImageView = headImgView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
//
// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
 * 用户积分接口，用户当前积分
 * @author luke
 * @date 2015.08.05
 * $args
 *  ac=Reward, v=2, op=credit, sid=, uid=
 {
 "protocol": "RewardAction.credit",
 "result": true,
 "message": [
 {
 "credit": "35",
 "experience": "21"
 }
 ]
 }
 */
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
            
            [_tableView reloadData];
        }
       
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
}

-(void)refreshMyPoints:(NSNotification*)notificatio{
    
    [_tableView reloadData];
    
}


/*----2015.08.14-----------------------------------------------------------------------
-(void)createTestData{
    
    //-----------测试代码 假数据 1G缓存--------------------------------------------------
    
    [Utilities showSuccessedHud:@"造假中，稍后" descView:self.view];
    [Utilities showProcessingHud:self.view];
    

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *fullNamespace = [@"com.hackemist.SDWebImageCache." stringByAppendingString:@"default"];
        NSString *str =  [paths[0] stringByAppendingPathComponent:fullNamespace];
        
        
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
        NSString *myVideoPath = str;
        
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:myVideoPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:myVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if([self copyMissingFile:sourcePath toPath:myVideoPath]){
            
            [Utilities dismissProcessingHud:self.view];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"造假成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 111;
            [alert show];
            
        }

        //--------------------------------------------------------------------------------
}

- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)destPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [destPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 111) {
        if (buttonIndex==0) {
            SettingViewController *settingView = [[SettingViewController alloc]init];
            settingView.isNewVersion = isNewVersion;
            [self.navigationController pushViewController:settingView animated:YES];
        }
    }else if (alertView.tag == 112){
        

    }
}*/
//----------------------------------------------------------------------------------------------------

@end

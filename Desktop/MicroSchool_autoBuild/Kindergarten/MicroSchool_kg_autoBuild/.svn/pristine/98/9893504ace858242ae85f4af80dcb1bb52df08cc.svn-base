//
//  MicroSchoolMainMenuViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-6.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MicroSchoolMainMenuViewController.h"
#import "FRNetPoolUtils.h"
#import "MyClassListViewController.h"
#import "MyInfoCenterViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "PublicConstant.h"
#import "SubscribeNumListViewController.h"
#import "ClassDetailViewController.h"
#import "FileManager.h"//单例模型，用来记录当前的网络状态 add by kate 2015.06.26
#import "NetworkGuideViewController.h"
#import "MomentsViewController.h"

@interface MicroSchoolMainMenuViewController ()

@end

@implementation MicroSchoolMainMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        customizeModuleList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:G_SCHOOL_NAME];
    //[super setCustomizeRightButton];//update by kate 2014.12.30
    
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    isRefresh = NO;//2015.11.16
    isFirst = YES;//2015.12.28 大退红点修改

    
    iconNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(143, 8, 9, 9)];
    iconNoticeImgV.image = [UIImage imageNamed:@"icon_new"];
    //------------add by kate 2014.12.03--------------------------
    //noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 20, 8, 9, 9)];
    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMsg.tag = 600;
    //-----------------------------------------------------------
    
    noticeImgVForMsgTab = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMsgTab.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMsgTab.tag = 640;//add 2015.11.19
    
    noticeImgVForMyMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMyMsg.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMyMsg.tag = 650;//add 2015.11.19
    
    //----add by kate 2015.01.28------------------------------------------------
    iconNoticeForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    iconNoticeForMsg.tag = 620;
    iconNoticeForMsg.image = [UIImage imageNamed:@"icon_new"];
    //--------------------------------------------------------------------------
    
    //----add by kate 2015.11.17------------------------------------------------
    redLabelForMsg = [[UILabel alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    redLabelForMsg.tag = 630;
    redLabelForMsg.backgroundColor = [UIColor redColor];
    redLabelForMsg.textColor = [UIColor whiteColor];
    redLabelForMsg.layer.cornerRadius = 10.0;
    redLabelForMsg.layer.masksToBounds = YES;
    redLabelForMsg.textAlignment = NSTextAlignmentCenter;
    //--------------------------------------------------------------------------
    
    //---------2016.2.22我的消息入口迁移到本页右上角--------------------------------
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundColor:[UIColor clearColor]];
        //rightButton.frame = CGRectMake(0, 0, 33, 33);
        rightButton.frame = CGRectMake(0, 0, 24, 24);
        [rightButton setImage:[UIImage imageNamed:@"myMsg.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"myMsg.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    redLabForMyMsg = [[UILabel alloc]initWithFrame:CGRectMake(13.0, -5, 16, 16)];//update by kate 2014.12.30
    redLabForMyMsg.tag = 631;
    redLabForMyMsg.textColor = [UIColor whiteColor];
    redLabForMyMsg.layer.cornerRadius = 8;
    redLabForMyMsg.layer.masksToBounds = YES;
    redLabForMyMsg.textAlignment = NSTextAlignmentCenter;
    redLabForMyMsg.font = [UIFont systemFontOfSize:12.0];
    
    if ([redLabForMyMsg.text integerValue] > 99) {
        
        redLabForMyMsg.text = @"...";
    }
    
    [rightButton addSubview:redLabForMyMsg];
    
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
        if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
            /**
             *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
             *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
             */
            negativeSpacer.width = -10;
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
        }else{
            self.navigationItem.rightBarButtonItem = rightBarButton;
        }
        
    
    //--------------------------------------------------------------------------
    
    videoNewImg = [[UIImageView alloc]init];//new标记 视频监控 2015.09.10
    videoNewImg.tag = 601;
   
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkNewInfo)
//                                                 name:NOTIFICATION_UI_MAIN_NEW_MESSAGE
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNewsIcon:)
                                                 name:NOTIFICATION_UI_MAIN_NEW_MESSAGE
                                               object:nil];
    
    //单聊
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNewCount)
                                                 name:@"addNewCountForMsg"
                                               object:nil];
//    //校园导读
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(addNewCountForNumbers)
//                                                 name:@"addNewCountForNumbers"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMyProfile)
                                                 name:NOTIFICATION_GET_PROFILE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayMyClassItem:)
                                                 name:NOTIFICATION_UI_MAIN_NEW_CLASSMSG
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addMaskView)
                                                 name:@"addMaskView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnected"
                                               object:nil];//2015.06.25
    
    //------------add by kate 2014.12.03-------------------------------------------------
    //update by kate 2014.12.30
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNewIconForMsgCenter)
                                                 name:@"checkMsgCenterNew"
                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(removeMsgICon)
//                                                 name:@"removeMsgICon"
//                                               object:nil];
    //-----------------------------------------------------------------------------

    lastMsgId = @"0";

    [ReportObject event:ID_OPEN_MAIN_ACTIVITY];//2015.06.23
    
}

//------------add by kate 2014.12.03-------------------------------------------------
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
            
            NSString *count = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"count"]];
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
           
            if ([count integerValue] > 0) {
                
                redLabForMyMsg.backgroundColor = [UIColor redColor];
                
                if ([count integerValue] > 9) {
                    
                    redLabForMyMsg.text = @"9+";
                    
                }else{
                    
                   redLabForMyMsg.text = count;
                }
                
              
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                
                if ([button viewWithTag:640]) {
                    
                }else if ([button viewWithTag:600]){
                    
                }else{
                    
                    [button addSubview:noticeImgVForMyMsg];
                }
                
            }else{
              
                
                redLabForMyMsg.backgroundColor = [UIColor clearColor];
                redLabForMyMsg.text = @"";
                [noticeImgVForMyMsg removeFromSuperview];
                
            }
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
  
}

// 移除右上角红点
-(void)removeMsgICon{
    
    [noticeImgVForMsg removeFromSuperview];
}
//-------------------------------------------------------------

// 收到加入班级成功的推送 重新获取个人资料 add by kate
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
        [network sendHttpReq:HttpReq_Profile andData:data];
        //[self doShowUserInfo];//udpate by kate
    }
    
}


-(void)checkNews:(NSString*)moduleStr{
    
    NSString *lastId_news = nil;
    lastId_news = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastId_news"];
    
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
       
        [Utilities dismissProcessingHud:self.view];//2015.05.12
        return;
    }
    
    int count = [FRNetPoolUtils checkNews:@"checkModule" sid:G_SCHOOL_ID module:moduleStr lastId:lastId_news];
  
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    if (count > 0) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        MicroSchoolMainMenuTableViewCell *cell = (MicroSchoolMainMenuTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];

        [cell addSubview:iconNoticeImgV];
    }else{
        [iconNoticeImgV removeFromSuperview];
    }
}

-(void)selectRightAction:(id)sender
{
#if 0
    MyInfoCenterViewController *myInfoCenter = [[MyInfoCenterViewController alloc]init];
    myInfoCenter.title = @"个人中心";
    myInfoCenter.count = countNew;//add by kate 2014.12.03
    [self.navigationController pushViewController:myInfoCenter animated:YES];
    [noticeImgVForMsg removeFromSuperview];//add by kate 2014.12.03
    //---------------------------------------------------------------------------------
#endif
    
    MessageCenterViewController *msgCenterViewCtrl = [[MessageCenterViewController alloc] init];
    msgCenterViewCtrl.title = @"我的消息";
    [self.navigationController pushViewController:msgCenterViewCtrl animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if 0
// 主页拉取红点新接口 update by kate 2014.12.31
-(void)checkNewsIcon{
    
    NSString *moudles = @"";
    NSString *lastId = @"";
    for (int i=0; i<[customizeModuleList count]; i++) {
        
        UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+i)];
        [newView removeFromSuperview];
        
        NSDictionary *dic = [customizeModuleList objectAtIndex:i];
        NSString *type = [dic objectForKey:@"type"];
        //NSString *moduleStr = [dic objectForKey:@"module"];
        NSString *name = [dic objectForKey:@"name"];
        
        lastId = [[NSUserDefaults standardUserDefaults]objectForKey:name];
        if (lastId == nil) {
            lastId = @"";
            
            if ([type integerValue] == 21) {// 校园订阅
                lastId = @"1";//add by kate 2015.04.23

            }
        }
        NSString *item = [NSString stringWithFormat:@"%@:%@",name,lastId];
        if (i == 0) {
            moudles = item;
        }else{
            moudles = [NSString stringWithFormat:@"%@,%@",moudles,item];
        }
    
    }
    
    NSLog(@"modules:%@",moudles);
    //NSString *moduleStr = [array objectAtIndex:0];
   
//    if ([lastId_news length] == 0) {
//        lastId_news = @"0";
//        return;
//    }
    
    //-----------add by kate 2015.04.23-------------------------------------
    NSString *numbers =  @"";
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastSubscribeNumDic"]];
    
    NSArray *allKeysArray = [tempDic allKeys];
    
    for (int i =0; i<[allKeysArray count]; i++) {
        
        id key  = [allKeysArray objectAtIndex:i];
        id value = [tempDic objectForKey:key];
        
        NSString *item = [NSString stringWithFormat:@"%@:%@",key,value];
        if (i == 0) {
            numbers = item;
        }else{
            numbers = [NSString stringWithFormat:@"%@,%@",numbers,item];
        }
        
    }
    
//---------------------------------------------------------------------------------------
    
    // update by kate 2014.12.30
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用接口
        NSArray *array = [FRNetPoolUtils checkNewForSchool:moudles numbers:numbers];// update by kate 2015.04.23
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([array count] > 0){
                
                totalCount = 1;
                
                [noticeImgVForMsg removeFromSuperview];
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                [button addSubview:noticeImgVForMsg];
                
                for (int i =0 ; i< [array count]; i++) {
                    
                    UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+i)];
                    [newView removeFromSuperview];
                    
                    
                    NSString *newCount =[[array objectAtIndex:i] objectForKey:@"count"];
                    NSString *type = [[array objectAtIndex:i]objectForKey:@"type"];
                    
                    if ([newCount intValue] > 0) {
                        
                        UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44+15,(i*60)+5, 10, 10)];
                        iconRedImgV.tag = 510 + i;
                        iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];
                        
                        if ([type intValue]!=10) {
                            [_tableView addSubview:iconRedImgV];
                        }
                        
                        
                    }else{
                        
                    }
                    
                }
                
                [_tableView reloadData];
                
            }else{
                totalCount = 0;
                if ([_tableView viewWithTag:620]) {
                    
                }else{
                   [noticeImgVForMsg removeFromSuperview]; 
                }
                
            }
            
        });
    });
    
}
#endif

#if 0
// 更新页面红点 2015.11.11
-(void)updateRedPoint:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
    
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"school"];
        NSArray *filteredArray = [allLastIdDic objectForKey:@"school"];
        
        
        if ([filteredArray count] > 0) {
            
            [noticeImgVForMsg removeFromSuperview];
            for (int i=0; i<[customizeModuleList count]; i++) {
                UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+i)];
                [newView removeFromSuperview];
            }
            
            for (int i=0; i<[array count]; i++) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                
                if (i <= [filteredArray count]-1) {//防止新拉回来的数据 与本地数据Count不一致 导致crash
                    
                    NSString *midFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *lastFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"last"]];
                    NSString *type = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"type"]];
                        if ([type integerValue] == 19) {
                            lastMsgId = lastFiltered;//动态消息id
                        }
                    
                    if ([mid integerValue] == [midFiltered integerValue]) {
                        
                        if ([last integerValue] > [lastFiltered integerValue]) {
                            
                            for (int i=0; i<[customizeModuleList count]; i++) {
                                
                                NSDictionary *dic = [customizeModuleList objectAtIndex:i];
                                NSString *type = [dic objectForKey:@"type"];
                                //NSString *moduleStr = [dic objectForKey:@"module"];
                                NSString *idM = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                                
                                if ([type integerValue] == 1 || [type integerValue] == 28 || [type integerValue] == 21 || [type integerValue] == 20 || [type integerValue] == 19) {
                                    
                                    if ([mid integerValue] == [idM integerValue]) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            NSLog(@"type:%@ last:%@ > lastFiltered:%@",type,last,lastFiltered);
                                            
                                            UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44+15,(i*60)+5, 10, 10)];
                                            iconRedImgV.tag = 510 + i;
                                            iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];
                                            
                                            [_tableView addSubview:iconRedImgV];
                                            
                                        });
                                        
                                       
                                        [noticeImgVForMsg removeFromSuperview];
                                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                                        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                                        [button addSubview:noticeImgVForMsg];
                                        
                                       
                                        
                                        continue;
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
            }
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
        }
    }
    
    [self addNewCountForNumbers:dic];//校园导读
    [self addNewCount];
}
#endif

-(void)updateRedPoint:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"school"];
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *schoolLastDicDefault = [allLastIdDic objectForKey:@"schoolLastDicDefault"];//old
        
        if ([schoolLastDicDefault count] > 0){
            
            [noticeImgVForMsg removeFromSuperview];
            for (int i=0; i<[customizeModuleList count]; i++) {
                UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+i)];
                [newView removeFromSuperview];
            }
            
            for (int i=0; i<[array count]; i++) {
                
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                
                NSString *type = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"type"]];
                
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",@"0",mid];
                
                NSString *lastFiltered = [NSString stringWithFormat:@"%@",[schoolLastDicDefault objectForKey:keyStr]];
                
#if 0
                //原用于记录师生圈模块在主页的消息id 2.9.4不用了
                if ([type integerValue] == 19) {
                    lastMsgId = lastFiltered;//动态消息id
                }
#endif
                
                if ([type integerValue] == 21) {//校园导读的最新last，点击cell用于更新本地数据
                    lastSubscribeId = last;
                }
                
                if ([last integerValue] > [lastFiltered integerValue]) {
                    
                    for (int i=0; i<[customizeModuleList count]; i++) {
                        
                        NSDictionary *dic = [customizeModuleList objectAtIndex:i];
                        NSString *type = [dic objectForKey:@"type"];
                        NSString *idM = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                        
                        // 2.9.4 迭代2需求 校园公告 校园导读 显示红点
                        if ([type integerValue] == 28 || [type integerValue] == 21) {
                            
                            if ([mid integerValue] == [idM integerValue]) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44+15,(i*60)+5, 10, 10)];
                                    iconRedImgV.tag = 510 + i;
                                    iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];
                                    
                                    [_tableView addSubview:iconRedImgV];
                                    
                                });
                                
                                [noticeImgVForMsg removeFromSuperview];
                                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                                [button addSubview:noticeImgVForMsg];
                                
                                continue;
                            }
                        }
                        
                    }
                }
                
            }
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        }
        
    }
    [self addNewCount];
}

// 2015.11.11
-(void)checkNewsIcon:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    if (dic) {
        
         [self updateRedPoint:dic];
        
    }else{
        [self checkNewsIcon];
    }
    
}


// 2015.11.11
-(void)checkNewsIcon{
    
    NSString *app = [Utilities getAppVersion];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Module",@"ac",
                          @"3",@"v",
                          @"check", @"op",
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

#if 0
// 订阅号红点
-(void)addNewCountForNumbers:(NSDictionary*)dic{
    
    int index = -1;
    for (int i=0; i<[customizeModuleList count]; i++) {
        
        NSDictionary *dic = [customizeModuleList objectAtIndex:i];
        NSString *type = [dic objectForKey:@"type"];
        //NSString *moduleStr = [dic objectForKey:@"module"];
        //NSString *name = [dic objectForKey:@"name"];
        
        if ([type intValue] == 21) {
            index = i;
        }
        
    }
    
    if (index!= -1) {//说明有校园导读模块 更新导读红点
        
        
        if (dic) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
            
            NSArray *array = [dic objectForKey:@"numbers"];
            NSArray *filteredArray = [allLastIdDic objectForKey:@"numbers"];
            
            if ([filteredArray count] > 0) {
                
                for (int i=0; i<[array count]; i++) {
                    
                    NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                    
                    if (i <= [filteredArray count]-1) {//防止新拉回来的数据 与本地数据Count不一致 导致crash
                        
                        NSString *midFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"mid"]];
                        NSString *lastFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"last"]];
                        
                        if ([mid integerValue] == [midFiltered integerValue]) {
                            
                            if ([last integerValue] > [lastFiltered integerValue]) {
                                
                                
                                UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(510+index)];
                                [newView removeFromSuperview];
                                
                                UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44+15,(index*60)+5, 10, 10)];
                                iconRedImgV.tag = 510 + index;
                                iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];
                                
                                [_tableView addSubview:iconRedImgV];
                                
                                [noticeImgVForMsg removeFromSuperview];
                                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                                [button addSubview:noticeImgVForMsg];
                                
                                
                            }
                        }
                    }
                    
                }
                
                [_tableView reloadData];
                
            }
        }
        
    }
    
}
#endif

#if 0
//---通讯录红点 add by kate 2015.01.28--------------------------------------------
// 所有消息总数
-(void)addNewCount{
    
    /*BOOL isCheck = YES;
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    //NSString *cid = [user objectForKey:@"role_cid"];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];
    
    if([@"7"  isEqual: role_id]) {
        if ([@"2"  isEqual: role_checked]) {
            isCheck = NO;
            
        }else if ([@"0" isEqual:role_checked]){
            isCheck = NO;
        }
    
    }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
        isCheck = YES;
    }else{
        
        if ([@"0" isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]){
            isCheck = NO;
        }
        
    }*/
    
// if (isCheck) {
    
        int index = 0;
        for (int i=0; i<[customizeModuleList count]; i++) {
            
            NSDictionary *dic = [customizeModuleList objectAtIndex:i];
            NSString *type = [dic objectForKey:@"type"];
            //NSString *moduleStr = [dic objectForKey:@"module"];
            //NSString *name = [dic objectForKey:@"name"];
            
            if ([type intValue] == 10) {
                index = i;
            }
            
        }
        
        [iconNoticeForMsg removeFromSuperview];
        
        NSString *sql = [NSString stringWithFormat:@"select * from msgList"];
        
        NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
        int userCount = [idListDict.allKeys count];
        int count = 0;
        for (int i=0; i<userCount; i++) {
            
            NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
            //NSLog(@"objectDict:%@",objectDict);
            
            NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
            int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
            count = count+cnt;
        }
        //----------------------------------------------------
        
        
        NSString *countAll = [NSString stringWithFormat:@"%d",count];
        
        if([countAll intValue] > 0){
            
            
            iconNoticeForMsg.frame = CGRectMake(44+15,(index*60)+5, 10, 10);
            iconNoticeForMsg.image = [UIImage imageNamed:@"icon_new.png"];
            [_tableView addSubview:iconNoticeForMsg];
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
            
            if ([button viewWithTag:600]) {
                
            }else{
                [noticeImgVForMsg removeFromSuperview];
                [button addSubview:noticeImgVForMsg];
            }
            
        }

    //}

}
#endif
/**
 * 获取与朋友聊天的未读消息数量
 * v=1, ac=Message, op=count, sid=, uid=
 * 2015.11.17
 */
-(void)addNewCount{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Message",@"ac",
                          @"1",@"v",
                          @"count", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            int index = 0;
            for (int i=0; i<[customizeModuleList count]; i++) {
                
                NSDictionary *dic = [customizeModuleList objectAtIndex:i];
                NSString *type = [dic objectForKey:@"type"];
                
                if ([type intValue] == 10) {
                    index = i;
                }
                
            }
            
            [redLabelForMsg removeFromSuperview];
            
            NSArray *messageArray = [respDic objectForKey:@"message"];
            //NSLog(@"messageArray:%@",messageArray);
            
            NSInteger totalMsgCount = 0;
            
            //Done:数据库中查出的fuid和friend比较，相同则累计加上count，得出未读总数，更新角标
            for (int i =0; i<[messageArray count]; i++) {
                
                long long fuid = [[NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:i]objectForKey:@"friend"]] longLongValue];
                NSInteger count =  [[NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:i]objectForKey:@"count"]] intValue];;
                
                NSString *sql = [NSString stringWithFormat:@"select count(*) from msgList where user_id = %lli",
                                 fuid];
                
                NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
                
                
                NSString *sql2 = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", fuid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
                int cnt = [[DBDao getDaoInstance] getResultsToInt:sql2];

                
                if (iCnt > 0) {
                    
                    if (cnt < count) {
                        count = cnt;
                    }
                    
                    if (count < cnt) {
                        count = count;
                    }
                    
                    totalMsgCount+=count;
                    
                }
 
            }
            
            //totalMsgCount = 999;//测试代码
            
            if(totalMsgCount > 0){
                
                if (totalMsgCount > 99) {
                    redLabelForMsg.text = @"...";
                }else{
                   redLabelForMsg.text = [NSString stringWithFormat:@"%d",totalMsgCount];
                }
                
                
                NSInteger length = [redLabelForMsg.text length];
               
                if ([@"..." isEqualToString:redLabelForMsg.text]) {
                     redLabelForMsg.frame = CGRectMake(44+15, (index*60)+5, 2*15, 20);
                }else{
                    if (length == 1) {
                        redLabelForMsg.frame = CGRectMake(44+15, (index*60)+5, 20, 20);
                    }else{
                        redLabelForMsg.frame = CGRectMake(44+15, (index*60)+5, length*15, 20);
                    }
                }
                
                [_tableView addSubview:redLabelForMsg];
                
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:0];
                
                if ([button viewWithTag:600]) {
                    
                }else if([button viewWithTag:650]){
                    
                }else{
                    
                    [noticeImgVForMsgTab removeFromSuperview];
                    [button addSubview:noticeImgVForMsgTab];
                }
                
            }else{
                
                [noticeImgVForMsgTab removeFromSuperview];
                
            }
            
            //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalMsgCount];
            
            
        }
       
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

-(void)reload{
    
    [_tableView reloadData];
}

// 刷新我的班级这条红点
-(void)displayMyClassItem:(NSNotification *)notification{
    
    NSString *isAddRedImg = (NSString*)notification.object;
 
    int index = -1;
     NSString *moduleStr = @"";
    for (int i=0; i<[customizeModuleList count]; i++) {
        
        NSDictionary *dic = [customizeModuleList objectAtIndex:i];
        NSString *type = [dic objectForKey:@"type"];
        moduleStr = [dic objectForKey:@"name"];         //NSLog(@"type:%@  module:%@",type,moduleStr);
        if ([type intValue] == 4){
            index = i;
        }else{
            
        }
        
    }
    
    UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(83+[moduleStr length]*15, 8, 9, 9)];
    
    int tag = 310 + index;
    iconRedImgV.tag = tag;
    iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];

    if ([isAddRedImg intValue] == 1) {
        if (index > 0) {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            MicroSchoolMainMenuTableViewCell *cell = (MicroSchoolMainMenuTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
            
            [cell addSubview:iconRedImgV];
            
        }else{
            
            iconRedImgV.image = nil;
            [iconRedImgV removeFromSuperview];
            
        }

    }else{
        
        iconRedImgV.image = nil;
        [iconRedImgV removeFromSuperview];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MyTabBarController setTabBarHidden:NO];
    //----add by kate-------------------
    reflashFlag = 1;
    isReflashViewType = 1;
    //-----------------------------------
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"MainMenu" forKey:@"viewName"];
    [userDefaults synchronize];
    
    [self checkNewIconForMsgCenter];// update by kate 2016.2.22
    
    
    NSDictionary *message_info = [g_userInfo getUserDetailInfo];
    
    NSString* username = [message_info objectForKey:@"username"];
    NSString* uid = [message_info objectForKey:@"uid"];
   
    if ((![@""  isEqual: username]) && (![@""  isEqual: uid])) {
        // 显示用户信息
        //[self doShowUserInfo];//update by kate
    }
    
    //[self checkNewInfo];// 检查new标记
#if 0 // check红点不需要及时性的处理 2015.11.11 志伟确认
    if([customizeModuleList count]>0){
        [self checkNewsIcon];
    }
#endif
    
    isRefresh = NO;
    
    [super hideLeftAndRightLine];
    //---update by kate 2014.10.14---------------------
    //[super setCustomizeRightButton];
    //[super setCustomizeRightButton:@"icon_grzx.png"];
    //--------------------------------------------------
    
     [MyTabBarController setTabBarHidden:NO];
    
    [self addNewCount];//2015.11.19 获取单聊未读数量
    
#if BUREAU_OF_EDUCATION
    [self isNeedShowMasking];//教育局蒙版
#endif
    
#if 0
    //---add by kate 2015.06.16------------------------------------------------------------------------
    NSString *userType = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"role_id"]];

    if ([userType length] > 0) {
   
    //if ([userType integerValue] == 9 || [userType integerValue] == 7) {
        
        NSString *isCenterNew = [[NSUserDefaults standardUserDefaults]objectForKey:@"isCenterNew"];
        
        if (!isCenterNew) {
            
            UIImageView *tabNewImgV = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];
            tabNewImgV.tag = 123;
            tabNewImgV.image = [UIImage imageNamed:@"icon_new.png"];
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:3];
            if (button) {
                
                UIImageView *tempImgV = [button viewWithTag:123];
                if (tempImgV) {
                    
                }else{
                    [tabNewImgV removeFromSuperview];
                    [button addSubview:tabNewImgV];
                }
                
               
            }
            
            
        }
    }
    //----------------------------------------------------------------------------------------------------
#endif
   
}

// V 2.9.4教育局新增蒙版
/*-(void)addMaskView{
    
    [imgV removeFromSuperview];
    //-------add by kate 2015.05.22-------------------------------------------
//    schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];add 2015.05.05
//    
//    if ([schoolType isEqualToString:@"bureau"]) {
//        
//        NSString *isFirstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpen"];
//        if (isFirstOpen) {
//            
//        }else{
//            
//            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
//            imgV.image = [UIImage imageNamed:@"mask.png"];
//            imgV.userInteractionEnabled = YES;
//            
//            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
//            
//            [appDelegate.tabBarController.view addSubview:imgV];
//            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImgView)];
//            singleTouch.delegate = self;
//            [imgV addGestureRecognizer:singleTouch];
//        }
//        
//    }else{
    
        NSString *isFirstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpenForMoment"];
        if (isFirstOpen) {
            
        }else{
            
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
            imgV.image = [UIImage imageNamed:@"mask_moment.png"];
            imgV.userInteractionEnabled = YES;
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            
            [appDelegate.tabBarController.view addSubview:imgV];
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImgView)];
            singleTouch.delegate = self;
            
            [imgV addGestureRecognizer:singleTouch];
        }
        
    //}
    
    //---------------------------------------------------------------------------
}

//-------add by kate 2015.05.22-------------------------------------------------
// 蒙版消失
-(void)dismissImgView{
    
    [imgV removeFromSuperview];
 
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOpenForMoment"];
    
}*/
//-------------------------------------------------------------------------------

//教育局蒙版 2.9.4
- (void)isNeedShowMasking{
    
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaskForBureau"];
    
    if (nil == mask) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"MaskForBureau"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
            if (iPhone4) {
                [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0-60.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/maskSchoolTopTitle_bureauFor4.png"]];
            }else {
                [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0-60.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/maskSchoolTopTitle_bureau.png"]];
            }
    
    }
}

- (void)showMaskingView:(CGRect )rect image:(UIImage *)img{
    
    viewMasking = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *imageViewMasking = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imageViewMasking setImage:img];
    [viewMasking addSubview:imageViewMasking];
    
    UIButton *buttonMasking = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMasking.frame = rect;
    //buttonMasking.backgroundColor = [UIColor redColor];
    [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
    [viewMasking addSubview:buttonMasking];
    
    [[UIApplication sharedApplication].keyWindow addSubview:viewMasking];
}

- (IBAction)dismissMaskingView:(id)sender {
    viewMasking.hidden = YES;
}

//---add by kate 2014.12.03------------------
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // 2015.01.21 beck
    // 有crash的可能性，先注释
//    [network cancelCurrentRequest];
    //[noticeImgVForMsg removeFromSuperview];
  
}//----------------------------------------

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    //----add by kate-------------------------------
    refreshMsglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-64-49-20)/2, [UIScreen mainScreen].bounds.size.width, 20)];
    refreshMsglabel.text = @"下拉可以刷新哦~试试看！";
    refreshMsglabel.textColor = [UIColor grayColor];
    refreshMsglabel.textAlignment = NSTextAlignmentCenter;
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    //------------------------------------------------------------
    
//    NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
//    NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);
//    
//    NSLog(@"x = %f",[ UIScreen mainScreen].applicationFrame.origin.x);
//    NSLog(@"y = %f",[ UIScreen mainScreen].applicationFrame.origin.y);
    //[self doShowUserViewNew];
    [self doShowMenusNew];

    NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];

    if ((0 == [userDetailDic count]) || (0 == [dynamicArr count])) {
        
        NSLog(@"mainmenu loadview");
         [Utilities showProcessingHud:self.view];// 2015.05.12
        [self performSelector:@selector(doGetProfile) withObject:nil afterDelay:0.01];
    }else {
        _tableData = dynamicArr;
        
        for (int i=0; i<[dynamicArr count]; i++) {
            [customizeModuleList addObject:[dynamicArr objectAtIndex:i]];
        }

        [g_userInfo setUserDetailInfo:userDetailDic];

        // 显示用户view
//        [self doShowUserViewNew];

        // 显示用户信息
        //[self doShowUserInfo];//update by kate

        // 按照账户列别来进行menu描画
//        [self doShowMenusNew];
        
        if (iPhone5) {
            //---update by kate----------------------------------------
            // 按照菜单数量设置scrollview的高度
//            if ([UIScreen mainScreen].applicationFrame.size.height > (150 + 60*[_tableData count] - 44 + 22)) {
//                _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 43);
//            } else {
//                _scrollerView.contentSize = CGSizeMake(320, 150 + 60*[_tableData count] - 44);
//            }
            
//            if ([UIScreen mainScreen].applicationFrame.size.height > (60*[_tableData count] - 64 - 49)) {
//                _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 64 - 49);
//            } else {
//                _scrollerView.contentSize = CGSizeMake(320, 60*[_tableData count] - 64 - 49);
//            }
          //--------------------------------------------------------------
            
        } else {
            //---update by kate---------------------------------------
//            if ([UIScreen mainScreen].applicationFrame.size.height > (150 + 60*[_tableData count] - 44 + 22)) {
//                _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 43);
//            } else {
//                _scrollerView.contentSize = CGSizeMake(320, 150 + 60*[_tableData count] - 44);
//            }
            
//            if ([UIScreen mainScreen].applicationFrame.size.height > (60*[_tableData count] - 64 - 49)) {
//                _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 64 - 49);
//            } else {
//                _scrollerView.contentSize = CGSizeMake(320, 60*[_tableData count] - 64 - 49);
//            }
            //-------------------------------------------------------------
        }
        [_tableView reloadData];

        [self performSelector:@selector(doGetProfile) withObject:nil afterDelay:0.01];
    }
    
    // 判断是否是大退之后通过通知栏进入的。如果是则按照推送类型跳转到相应详细页面。
    NSDictionary *recivedApsInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"recivedApsInfo"];
    
    if (nil != recivedApsInfo) {
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate doHandleInactiveNotification:recivedApsInfo];
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"recivedApsInfo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


//从后台获取主页menu数据
-(void)doGetCustomizeModule
{
    NSString *app = [Utilities getAppVersion];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"3",@"v",
                          @"Module", @"ac",
                          @"schoolModules", @"op",
                          app, @"app",
                          nil];
    
    [network sendHttpReq:HttpReq_GetCustomizeModule andData:data];
}

-(void)doGetProfile
{
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
    
    NSString *regSuccess = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];

    if ([@"regSuccess"  isEqual: regSuccess]) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"view", @"op",
//                              uid, @"uid",
                              nil];
        [network sendHttpReq:HttpReq_Profile andData:data];
    } else {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"view", @"op",
//                              uid, @"uid",
                              nil];
        [network sendHttpReq:HttpReq_Profile andData:data];
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    // ModuleAction.school
    
    //if([@"ModuleAction.dynamic"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
//    if([@"ModuleAction.school"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
    if([@"ModuleAction.schoolModules"  isEqual: [resultJSON objectForKey:@"protocol"]]) {//udpate by kate
  
        if(true == [result intValue]) {
            
            
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            [customizeModuleList removeAllObjects];
            [refreshMsglabel removeFromSuperview];
            
            //---add by kate 2014.12.01-----------------------------------------------------------------
            NSMutableArray *classArray = [NSMutableArray arrayWithObjects:@"1",@"0",@"0",@"0",@"1", nil];
            //-------------------------------------------------------------------------------------------
            
            NSLog(@"message:%@",[resultJSON objectForKey:@"message"]);
            int posSch = -1;
            int posHom = -1;
            
            BOOL hasSchedule = NO;
            BOOL hasHomework = NO;
            BOOL hasDiscuss = NO;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray *array = [resultJSON objectForKey:@"message"];
            [userDefaults setObject:@"0" forKey:@"isKnowledge"];
            [userDefaults synchronize];
            
            for (int i = 0; i<[array count];i++) {
                
                NSString *type = [[array objectAtIndex:i] objectForKey:@"type"];
                NSString *realName = [[array objectAtIndex:i] objectForKey:@"name"];
                NSString *note = [[array objectAtIndex:i] objectForKey:@"note"];
                
                if([type intValue] == 13){
                    
                    hasDiscuss = YES;
                    [classArray replaceObjectAtIndex:3 withObject:@"1"];
                    [userDefaults setObject:note forKey:@"classDiscussForDescription"];
                    [userDefaults setObject:realName forKey:@"discussName"];
                    [userDefaults synchronize];
                    
                }else{
                    
                    // 因为知识库移动到发现中，所以不在首页显示update by kate 2015.03.04
                    if([type intValue] !=9){
                        
                         [customizeModuleList addObject:[array objectAtIndex:i]];
                        
                    }else{
                        [userDefaults setObject:@"1" forKey:@"isKnowledge"];
                        [userDefaults setObject:realName forKey:@"knowledgeName"];
                        [userDefaults synchronize];
                    }
                   
                }
                
            }
            
            // 通过后台返回的menu信息来确定是否存在课表或者作业
            for (int i=0; i<[customizeModuleList count]; i++) {
                NSDictionary *modu = [customizeModuleList objectAtIndex:i];
                NSString *name = [modu objectForKey:@"type"];
                NSString *realName = [modu objectForKey:@"name"];
                NSString *note = [modu objectForKey:@"note"];
                
                if ([@"7"  isEqual: name]) {
                    posSch = i;
                    hasSchedule = YES;
                    [classArray replaceObjectAtIndex:2 withObject:@"1"];//add by kate 2014.12.01
                }
                
                if ([@"8"  isEqual: name]) {
                    posHom = i;
                    hasHomework = YES;
                    [classArray replaceObjectAtIndex:1 withObject:@"1"];// add by kate 2014.12.01
                    [userDefaults setObject:realName forKey:@"homeworkName"];
                    [userDefaults synchronize];
                }
                
                if ([@"4" isEqual:name]) {
                    
                    [[NSUserDefaults standardUserDefaults]setObject:realName forKey:@"classPublic"];
                    [userDefaults synchronize];
                }
                
                
            }
            
            //---add by kate 2014.12.01-------------------------------------------------------
            [[NSUserDefaults standardUserDefaults]setObject:classArray forKey:@"classArray"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //---------------------------------------------------------------------------------
            
            if (hasSchedule && !hasHomework) {
                //hasSch = true; 只有课程表
                classType = 0; // update by kate 2014.09.18
            } else if (!hasSchedule && hasHomework) {
                //hasHom = true;  只有作业
                classType = 1; // update by kate 2014.09.18
            } else if (hasSchedule && hasHomework) {
                //both = true;    课程表作业都有
                classType = 2; // update by kate 2014.09.18
            } else if (!hasSchedule && !hasHomework) {
                //none = true;    课程表作业都没有
                classType = 3; // update by kate 2014.09.18
            }
            // 需要增加一个

            if ((-1 != posSch) && (-1 != posHom)) {
                if (posSch > posHom) {
                    [customizeModuleList removeObjectAtIndex:posHom];
                    [customizeModuleList removeObjectAtIndex:posSch-1];
                } else {
                    [customizeModuleList removeObjectAtIndex:posSch];
                    [customizeModuleList removeObjectAtIndex:posHom-1];
                }
            }else{
                if (-1 != posHom) {
                    [customizeModuleList removeObjectAtIndex:posHom];
                } else if (-1 != posSch) {
                    [customizeModuleList removeObjectAtIndex:posSch];
                }
            }
            
            [Utilities doSaveDynamicModule:customizeModuleList];

            _tableData = customizeModuleList;
            
//            NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
//            NSArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
            
//            if ((0 == [userDetailDic count]) || (0 == [dynamicArr count])) {
                // 显示用户view
//                [self doShowUserViewNew];
//            }
            
            // 显示用户信息
           // [self doShowUserInfo];//update by kate
            
            // 按照账户列别来进行menu描画
            [self doShowMenusNew];
            
            // 检查new
            //[self checkNewInfo];
            if (isRefresh || isFirst) {//2015.12.28 大退红点修改

                [self checkNewsIcon];//2015.11.11
            }
            [self addNewCount];//add by kate 2015.01.28
            
            /*---update by kate
             if (iPhone5) {
                // 按照菜单数量设置scrollview的高度
                if ([UIScreen mainScreen].applicationFrame.size.height > (150 + 60*[_tableData count] - 44 + 22)) {
                    _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 43);
                } else {
                    _scrollerView.contentSize = CGSizeMake(320, 150 + 60*[_tableData count] - 44);
                }
            } else {
                if ([UIScreen mainScreen].applicationFrame.size.height > (150 + 60*[_tableData count] - 44 + 22)) {
                    _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 43);
                } else {
                    _scrollerView.contentSize = CGSizeMake(320, 150 + 60*[_tableData count] - 44);
                }
            }*/
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
        }
    }else if([@"ProfileAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            // add by ht 20140915 如果注册完毕并且登录成功后，清空注册信息，以便下一次直接进入主界面，增加userDefaults变量
            NSString *uid1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            // 清空注册完毕信息
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid1]];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // 保存是否是注册登录流程完成，设置为no，则为完成了
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid1]];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSDictionary *profile = [message_info objectForKey:@"profile"];
            NSDictionary *role = [message_info objectForKey:@"role"];

            NSLog(@"profile:%@",profile);
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[message_info objectForKey:@"profile"]];
            
            NSDictionary *vip = [message_info objectForKey:@"vip"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
            
            [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[message_info objectForKey:@"role"]];

            user_info = [g_userInfo getUserDetailInfo];

            [self performSelector:@selector(doGetCustomizeModule) withObject:nil afterDelay:0.1];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_delegate_getFoundName" object:self userInfo:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getMomentsNotify" object:self userInfo:nil];
            
        }else {
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            [Utilities dismissProcessingHud:self.view];//2015.05.12
            NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
            NSArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
            
            // 如果是第一次获取信息失败，则显示popup
            if ((0 == [userDetailDic count]) || (0 == [dynamicArr count])) {
                // 显示用户view
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取个人信息失败。"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];

//-------网络连接错误提示由以下方法取代，此页不再蹦出提示框 2015.06.25---------------------
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
    
    [self isConnected];
//---------------------------------------------------------------------------------
    
    if ([customizeModuleList count] == 0) {
         [self.view addSubview:refreshMsglabel];
    }
    
   
}

//---add by kate 2015.06.12------------------
// 小退在进入的时候判断是否已经加入班级
/*-(void)checkClassApprove:(NSDictionary*)role{
    
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[user objectForKey:@"role_id"]];
    NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[role objectForKey:@"cid"]]];
    NSString *classesCount = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[role objectForKey:@"classes"]]];

    if([@"0"  isEqual: usertype] || [@"6" isEqual:usertype] ){// 家长 学生
        
        if ([cid integerValue]!=0 && [cid length] >0) {
            
            ClassDetailViewController *detailV = [[ClassDetailViewController alloc]init];
            detailV.cId = cid;
            detailV.fromName = @"tab";
            detailV.hidesBottomBarWhenPushed = YES;
            
            UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:detailV];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [array replaceObjectAtIndex:1 withObject:customizationNavi];
            [self.tabBarController setViewControllers:array];
        }
        
        
    }else{
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
    }
}*/
//-----------------------------------

/*-(void)doShowUserInfo
{
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }

    NSString* uid = [message_info objectForKey:@"uid"];

    NSString* username = [message_info objectForKey:@"name"];

    // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
    NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"name", nil];

    [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString* usertype = [message_info objectForKey:@"role_id"];
    NSString* checked = [message_info objectForKey:@"role_checked"];
    //NSLog(@"usertype:%@",usertype);
    NSString* title = [message_info objectForKey:@"role_name"];
    NSString* spacenote = [message_info objectForKey:@"spacenote"];
    NSString* yeargrade = [message_info objectForKey:@"role_classname"];
    NSString* sex = [message_info objectForKey:@"sex"];
    reason = [message_info objectForKey:@"role_reason"];

    if ([@"2"  isEqual: sex]) {
        imgView_gender.image=[UIImage imageNamed:@"icon_female.png"];
    }
    else {
        imgView_gender.image=[UIImage imageNamed:@"icon_male.png"];
    }
    
    username = [[username stringByAppendingString:@"|"] stringByAppendingString:title];
    label_name.text = username;
    
    if ([@""  isEqual: spacenote]) {
        spacenote = @"（您还没有设置个性签名）";
//        [label_sign setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [label_sign setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

        label_sign.textColor = [UIColor blueColor];
    }else {
//        [label_sign setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [label_sign setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

        label_sign.textColor = [UIColor blackColor];
    }
//    [label_sign setTitle:spacenote forState:UIControlStateNormal];
//    [label_sign setTitle:spacenote forState:UIControlStateHighlighted];
    label_sign.text = spacenote;
    
    if ([@"7"  isEqual: [NSString stringWithFormat:@"%@", usertype]]) {
        if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]]) {
            [button_req removeFromSuperview];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"（ 等待审批 ）"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,5)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(6,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(2, 5)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(6, 1)];
            
            [label_class setAttributedTitle:str forState:UIControlStateNormal];
            [label_class setAttributedTitle:str forState:UIControlStateHighlighted];

//            label_class.attributedText = str;
        }
        else if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"（ 身份申请未通过 ）"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,8)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(2, 8)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(9, 1)];
            
            [label_class setAttributedTitle:str forState:UIControlStateNormal];
            [label_class setAttributedTitle:str forState:UIControlStateHighlighted];

//            label_class.attributedText = str;
            
            button_req = [UIButton buttonWithType:UIButtonTypeCustom];
            button_req.frame = CGRectMake(label_class.frame.origin.x + label_class.frame.size.width - 25,
                                          label_name.frame.origin.y + label_name.frame.size.height,
                                          80,
                                          25);
            
            [button_req setTitle:@"重新申请" forState:UIControlStateNormal];
            [button_req setTitle:@"重新申请" forState:UIControlStateHighlighted];
            button_req.titleLabel.textAlignment = NSTextAlignmentCenter;
            button_req.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [button_req setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button_req setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            button_req.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [button_req setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
            [button_req setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
            [button_req addTarget:self action:@selector(reSendReq_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            [_scrollerView addSubview:button_req];
        }
    }// 校园管理员 9 督学身份 2 这两个身份不显示班级信息 add notes by kate 2014.10.21 
    else if ([@"9"  isEqual: [NSString stringWithFormat:@"%@", usertype]] || [@"2"  isEqual: [NSString stringWithFormat:@"%@", usertype]]){
    
    }
    else
    {
        if ([@""  isEqual: yeargrade]) {
            yeargrade = @"(未加入班级)";
            [label_class setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [label_class setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

//            [label_class setTextColor:[UIColor redColor]];
        }
        
//        label_class.text = yeargrade;
        [label_class setTitle:yeargrade forState:UIControlStateNormal];
        [label_class setTitle:yeargrade forState:UIControlStateHighlighted];

#if 0
        // 用户为学生时，显示学年和班级
        NSString *classStr = [yeargrade stringByAppendingString:@"级"];
        
        if ([@""  isEqual: class]) {
            classStr = [classStr stringByAppendingString:@"（ 未选择 ）班"];
            
            if (classStr.length <= 11) {
                classStr = [NSString stringWithFormat:@"%@%@班", classStr, class];
                label_class.text = classStr;
            } else {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:classStr];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,6)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,3)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(11,1)];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 6)];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(7, 3)];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(11, 1)];
                label_class.attributedText = str;
            }
        } else {
            classStr = [NSString stringWithFormat:@"%@%@班", classStr, class];
            label_class.text = classStr;
        }
#endif
    }
    
    //---update by kate 2014.11.14--------------------------------
    
    //    Utilities *util = [Utilities alloc];
    //    NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"1"];
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    NSString *headUrl = [message_info objectForKey:@"avatar"];
    [imgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
}*/

- (IBAction)reSendReq_btnclick:(id)sender
{
    SetPersonalTeacherViewController *personalTeacherViewCtrl = [[SetPersonalTeacherViewController alloc] init];
    personalTeacherViewCtrl.reason = reason;
    
    [self.navigationController pushViewController:personalTeacherViewCtrl animated:YES];
}

/*-(void)doShowUserViewNew
{
    // 背景图片
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    
    CGRect rect;
    // 设置背景scrollView
    if (iPhone5)
    {
        //rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44);
        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44 - 49);// udpate by kate 2014.12.26

    }
    else
    {
        //rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 45 );
        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44 - 49);// udpate by kate 2014.12.26

    }
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    NSLog(@"height:%f",_scrollerView.frame.size.height);
    
    if (iPhone5)
    {
        //_scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 64 - 49);

    }
    else
    {
        //_scrollerView.contentSize = CGSizeMake(320,[UIScreen mainScreen].applicationFrame.size.height - 44);
        _scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 64 - 49);
    }
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
//    _scrollerView.bounces = YES;
//    _scrollerView.alwaysBounceHorizontal = NO;
//    _scrollerView.alwaysBounceVertical = YES;
//    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    /*---update by kate 2014.12.26-------------------------------
    //---update by kate 2014.10.14---------------------------------------------------------------
    UIButton *gotoMyInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMyInfoBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 72 + 20 + 10);
    [gotoMyInfoBtn addTarget:self action:@selector(gotoMyInfoView) forControlEvents:UIControlEventTouchUpInside];
    gotoMyInfoBtn.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:gotoMyInfoBtn];
    //--------------------------------------------------------------------------------------------
    
    // 头像图片
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(40,10,60,60)];
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 60/2;
    imgView.contentMode = UIViewContentModeScaleToFill;
    [_scrollerView addSubview:imgView];
    
    //---update by kate 2014.10.15-----------------------------------------------------------------
    UIButton *touchImgHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchImgHeadBtn.frame = CGRectMake(40,10,60,60);
    [touchImgHeadBtn addTarget:self action:@selector(touchImgHeadAction) forControlEvents:UIControlEventTouchUpInside];
    touchImgHeadBtn.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:touchImgHeadBtn];
    //----------------------------------------------------------------------------
    
    // 姓名
    label_name = [[UILabel alloc] initWithFrame:CGRectMake(140, 26, 280, 20)];
    label_name.textColor = [UIColor blackColor];
    label_name.backgroundColor = [UIColor clearColor];
    label_name.font = [UIFont systemFontOfSize:13.0f];
    [_scrollerView addSubview:label_name];
    
    // 性别icon
    imgView_gender =[[UIImageView alloc]initWithFrame:CGRectMake(118,26,17,17)];
    [_scrollerView addSubview:imgView_gender];
    
    // 班级
    label_class = [[UIButton alloc] initWithFrame:CGRectMake(120, 48, 140, 20)];
    [label_class setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    label_class.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    label_class.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [label_class addTarget:self action:@selector(goToClass_btnclick:) forControlEvents: UIControlEventTouchUpInside];

//    label_class.textColor = [UIColor blackColor];
//    label_class.font = [UIFont systemFontOfSize:12.0f];
//    label_class.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:label_class];
    
    // 个性签名
    label_sign = [[UILabel alloc] initWithFrame:CGRectMake(40, 72, 260, 20)];
    label_sign.textColor = [UIColor blackColor];
    label_sign.font = [UIFont systemFontOfSize:12.0f];
    label_sign.backgroundColor = [UIColor clearColor];
    label_sign.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_sign];

    label_sign_mask = [[UIButton alloc] initWithFrame:CGRectMake(40, 72, 260, 20)];
    [label_sign_mask setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    label_sign_mask.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    label_sign_mask.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [label_sign_mask addTarget:self action:@selector(goToProfile_btnclick:) forControlEvents: UIControlEventTouchUpInside];

//    label_sign.textColor = [UIColor blackColor];
//    label_sign.font = [UIFont systemFontOfSize:12.0f];
//    label_sign.backgroundColor = [UIColor clearColor];
//    label_sign.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_sign_mask];*/
    //--------------------------------------------
//}

//----add by kate 2014.10.14----------------------------------------------------------------
// 点击主页menu上方的个人信息介绍部分跳转至个人信息页
-(void)gotoMyInfoView{
    
    SetPersonalInfoViewController *setPersonalViewCtrl = [[SetPersonalInfoViewController alloc] init];
    setPersonalViewCtrl.title = @"个人信息";
    setPersonalViewCtrl.fromName = @"mainMenu";
    [self.navigationController pushViewController:setPersonalViewCtrl animated:YES];
 
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
    NSString *imgUrl = head_url;
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
    photo.srcImageView = imgView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}
//--------------------------------------------------------------------------------------------

- (IBAction)goToProfile_btnclick:(id)sender
{
    if ([@"（您还没有设置个性签名）" isEqual: label_sign.text]) {
        
        //----update by kate 2014.10.14----------------------------------------------------------------
        /*PersonalInfoViewController *personalViewCtrl = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:personalViewCtrl animated:YES];
        personalViewCtrl.title = @"个人资料";*/
        
        SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
        [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
        //-------------------------------------------------------------------------------------------------
    
    }
}

- (IBAction)goToClass_btnclick:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",classType] forKey:@"classType"];
    if([label_class.titleLabel.text length] == 0){
        
    }else{
        MyClassListViewController *myclassV = [[MyClassListViewController alloc]init];
        [self.navigationController pushViewController:myclassV animated:YES];

    }
    
}

-(void)doShowMenusNew
{
    /*if (iPhone5) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label_sign.frame.origin.y + label_sign.frame.size.height + 10, 320, [UIScreen mainScreen].applicationFrame.size.height-44+150 + 500) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height-64-49 + 500) style:UITableViewStylePlain];//update by kate 14.12.26
    } else {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label_sign.frame.origin.y + label_sign.frame.size.height + 10, 320, [UIScreen mainScreen].applicationFrame.size.height-44+150 + 20 + 80 + 500) style:UITableViewStylePlain];
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label_sign.frame.origin.y + label_sign.frame.size.height + 10, 320, [UIScreen mainScreen].applicationFrame.size.height-44-49+ 20 + 80 + 500) style:UITableViewStylePlain];//update by kate
    }*/
    
     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height-44-49) style:UITableViewStylePlain];//update by kate 14.01.04
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
//    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    _tableView.backgroundView = imgView_bg;
    
   //----add by kate----------------------------
    [_tableView addSubview:_refreshHeaderView];
    [self.view addSubview:_tableView];
   
    //-----------------------------------------------
    
    //[_scrollerView addSubview:_tableView];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    MicroSchoolMainMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MicroSchoolMainMenuTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-49-44)];
//    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
 //   cell.backgroundView = imgView_bg;
    
    //    NSUInteger section = [indexPath section];
    NSUInteger section = [indexPath row];
    
    NSDictionary* list_dic = [_tableData objectAtIndex:section];
  
    NSString* iconName= [list_dic objectForKey:@"icon"];
    NSString* name= [list_dic objectForKey:@"name"];
    NSString* comment= [list_dic objectForKey:@"note"];
    NSString *type = [list_dic objectForKey:@"type"];//模块类型
    
    cell.name = name;
    cell.comment = comment;
    
    [cell.imgView_icon sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    // new标记添加
    /*if ([type integerValue] == 25) {//视频监控 2.9.0去掉new
        
        NSString *videoNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoNew"];
         
        if (nil == videoNew) {
            
            cell.videoNewImg.image = [UIImage imageNamed:@"icon_forNew.png"];
            
        }else {
            cell.videoNewImg.image = nil;
        }
        
    }else{
        
        cell.videoNewImg.image = nil;
    
    }*/

    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath  animated:YES];
    
    schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.05
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    //-----add by kate 2014.09.25----------------------------------------------------------
    //点击一行去掉红点
    MicroSchoolMainMenuTableViewCell *cell = (MicroSchoolMainMenuTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    int row = indexPath.row + 310;
    if ([cell viewWithTag:row]!=nil) {
        UIImageView *imgV = (UIImageView*)[cell viewWithTag:row];
        [imgV removeFromSuperview];
    }
    //-------------------------------------------------------------------------------------
    NSDictionary *module = [customizeModuleList objectAtIndex:indexPath.row];

    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_checked"]];

    NSMutableDictionary *test = [NSMutableDictionary dictionaryWithDictionary:module];
    
    BOOL isConnect = [Utilities connectedToNetwork];
    if ([@"28"  isEqual: [module objectForKey:@"type"]]) {
#if BUREAU_OF_EDUCATION
        // 公告发布就是校园公告模块
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;
        newsViewCtrl.newsType = @"schoolNews";
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        [MyTabBarController setTabBarHidden:YES];
#else
        // 校园公告
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;//2015.11.12
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        [MyTabBarController setTabBarHidden:YES];
        
#endif
    }else if ([@"1"  isEqual: [module objectForKey:@"type"]]) {
        // 自定义公告
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;//2015.11.12
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
                if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_cid"]]]) {
                    
                    
                    if ([schoolType isEqualToString:@"bureau"]) {//教育局 假数据 2015.05.05
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                       message:@"请先加入一个部门."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                        [alert show];

                    }else{
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                       message:@"请先加入一个班级."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                        [alert show];
 
                    }
                    
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
                    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",classType] forKey:@"classType"];
                    MyClassListViewController *myclassV = [[MyClassListViewController alloc]init];
                    [self.navigationController pushViewController:myclassV animated:YES];
                     [MyTabBarController setTabBarHidden:YES];
                }
            }else {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",classType] forKey:@"classType"];
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
        if(isConnect) {
            KnowledgeViewController *knowledgeViewCtrl = [[KnowledgeViewController alloc] init];
            knowledgeViewCtrl.titleName = [module objectForKey:@"name"];
            [self.navigationController pushViewController:knowledgeViewCtrl animated:YES];
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
                
                //2015.10.29 教育局改版
                 if ([schoolType isEqualToString:@"bureau"]) {//add 2015.06.18 提示移到通讯录里边
                    
                    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                    friendViewCtrl.classid = cid;
                    friendViewCtrl.titleName = [module objectForKey:@"name"];
                    [self.navigationController pushViewController:friendViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
                    [iconNoticeForMsg removeFromSuperview];
                    
                    [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                    
                }else{
                    
                    // update by kate 2015.06.18
                    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                    friendViewCtrl.classid = cid;
                    friendViewCtrl.titleName = [module objectForKey:@"name"];
                    [self.navigationController pushViewController:friendViewCtrl animated:YES];
                    [MyTabBarController setTabBarHidden:YES];
                    [iconNoticeForMsg removeFromSuperview];
                    [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                    
//                    对于其他类型版本（分组：我的同学、老师、家长）：
//                    教师未认证点击分组时，提示：只有认证教师可以使用
//                    家长学生未加入班级时，提示：您还未加入任何班级，无法使用此功能
                    
                    /*if ([@"1"  isEqual: role_checked]) {
                        PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                        friendViewCtrl.classid = cid;
                        friendViewCtrl.titleName = [module objectForKey:@"name"];
                        [self.navigationController pushViewController:friendViewCtrl animated:YES];
                        [MyTabBarController setTabBarHidden:YES];
                        [iconNoticeForMsg removeFromSuperview];
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
                    }*/
                }
                
               
            }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                
                PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                friendViewCtrl.classid = cid;
                friendViewCtrl.titleName = [module objectForKey:@"name"];
                [self.navigationController pushViewController:friendViewCtrl animated:YES];
                 [MyTabBarController setTabBarHidden:YES];
                [iconNoticeForMsg removeFromSuperview];
                [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                
            }else {
                
                 if ([schoolType isEqualToString:@"bureau"]) {//教育局 updat by kate 2015.05.21
//                     // 教育局专版学生家长不可以访问通讯录
//                     
//                     UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                                    message:@"只有认证教师可以使用."
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"知道了"
//                                                          otherButtonTitles:nil];
//                     [alert show];
                     
                     PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
                     friendViewCtrl.classid = cid;
                     friendViewCtrl.titleName = [module objectForKey:@"name"];
                     [self.navigationController pushViewController:friendViewCtrl animated:YES];
                     [MyTabBarController setTabBarHidden:YES];
                     [iconNoticeForMsg removeFromSuperview];
                     [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
                 
                 }else{
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
                         [iconNoticeForMsg removeFromSuperview];
                         [ReportObject event:ID_OPEN_CONTACTS_LIST];//2015.06.24
 //                    }
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
        
            SubscribeNumListViewController *subListV = [[SubscribeNumListViewController alloc]init];
            subListV.titleName = [module objectForKey:@"name"];
            subListV.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
            subListV.lastSubscribeId = lastSubscribeId;
            subListV.newsDic = newsDic;//2015.11.12
            [self.navigationController pushViewController:subListV animated:YES];
            
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
        commentList.lastMsgId = lastMsgId;
        [self.navigationController pushViewController:commentList animated:YES];
        
    }
#if BUREAU_OF_EDUCATION
    else if ([@"31" isEqual:[module objectForKey:@"type"]]){
        // 校园头条
        NewsViewController *newsViewCtrl = [[NewsViewController alloc] initWithVar:[module objectForKey:@"name"]];
        newsViewCtrl.mid = [NSString stringWithFormat:@"%@",[module objectForKey:@"id"]];
        newsViewCtrl.newsDic = newsDic;
        newsViewCtrl.newsType = @"headLineNews";
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        [MyTabBarController setTabBarHidden:YES];
    }
#endif
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"敬请期待"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122) {
        if (buttonIndex == 0) {
            NSURL *url = [[NSURL alloc]initWithString:self->updateUrl];
            [[UIApplication sharedApplication ]openURL:url];
        }else{
        }
    }
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        isRefresh = YES;
    
        [self doGetCustomizeModule];
    
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

//// add 2015.05.04
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

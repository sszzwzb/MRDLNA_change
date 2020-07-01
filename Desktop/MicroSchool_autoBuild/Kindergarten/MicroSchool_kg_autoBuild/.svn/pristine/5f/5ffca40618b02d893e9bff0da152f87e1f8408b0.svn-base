//
//  MomentsEntranceForTeacherController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/26.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MomentsEntranceForTeacherController.h"
#import "LaunchGroupChatViewController.h"
#import "MsgListCell.h"
#import "GroupChatDetailObject.h"
#import "GroupChatDetailViewController.h"
#import "SubUINavigationController.h"
#import "GroupChatListHeadObject.h"
#import "KnowlegeHomePageViewController.h"

@interface MomentsEntranceForTeacherController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *headerView;
@property (nonatomic,strong) NSMutableArray *positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray *positionFor9ModeImage;
@end

UIImageView *newIconImgForTeacher;
@implementation MomentsEntranceForTeacherController
@synthesize chatListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(isShowNewOnTab3)
                                                     name:@"isShowNewOnTab3"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkSelfMomentsNew)
                                                     name:@"checkMomentsNew"
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkMomentsMsgNew)
                                                     name:@"checkMomentsMsgNew"
                                                   object:nil];
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 431;
       
        
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    
    [self showHeaderView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    headArray = [[NSMutableArray alloc]init];
    
    //[self createNoDataView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoGroupChatDetail:)
                                                 name:@"gotoGroupChatDetailForTeacher"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatListData)
                                                 name:NOTIFICATION_DB_GET_CHAT_LIST_DATA_GROUP_TEACHER
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteGroupListCell:)
                                                 name:@"deleteGroupListCellForTeacher"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeHeadArray)
                                                 name:@"removeHeadArrayForTeacher"
                                               object:nil];
    
    [ReportObject event:ID_GROUP_CHAT_OPEN_LIST_INFO];//2015.06.25
    
}

-(void)showHeaderView{
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    isNewForScan = [[UIImageView alloc] init];//new标实
    isNewForScan.tag = 345;
    // NSString *isK = [[NSUserDefaults standardUserDefaults] objectForKey:@"isKnowledge"];
    
    //_foundModuleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"foundModule"];
    
    if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
        _foundModuleName = @"校友圈";
#endif
        _foundModuleName = @"师生圈";//2016.01.05
    }
    
    /*if([isK intValue] == 1){
     isKnowledge = YES;
     
     knowledgeName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"knowledgeName"]];
     }else{
     isKnowledge = NO;
     }*/
    
    
    newIconImgForTeacher = [[UIImageView alloc]init];
    newIconImgForTeacher.hidden = YES;
    //newIconImgForTeacher.frame = CGRectMake([_foundModuleName length]*17 + 63, (44 - 18)/2+20, 10, 10);
    newIconImgForTeacher.frame = CGRectMake(self.view.frame.size.width - 40.0, (50 - 10)/2+20, 10, 10);
    newIconImgForTeacher.image = [UIImage imageNamed:@"icon_new"];
    
    
//    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
//    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
//    noticeImgVForMsg.tag = 431;
    
    _headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    _headerView.tableFooterView = [[UIView alloc] init];
    
    [super setCustomizeTitle:_titleName];
    
    //----add by kate---------------------------------------------------
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    //--------------------------------------------------------------------
    
    //-------------------------------------------------
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"tabTitles"];
    
    if([tempArray count] > 0){
        [self setCustomizeTitle:[tempArray objectAtIndex:2]];
    }
    //----------------------------------------------------------
    
#if 1 //2015.12.30 校友圈cell红点
    [_headerView addSubview:newIconImgForTeacher];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"getMomentsNotify" object:nil];// 2015.05.13
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnectedForMoments"
                                               object:nil];//2015.06.25
    
    _tableView.tableHeaderView = _headerView;
    
    [self getData];// 2015.05.13
}

//教育局蒙版 2.9.4
- (void)isNeedShowMasking{
    
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaskLeaveForBureau"];
    
    if (nil == mask) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"MaskLeaveForBureau"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (iPhone4) {
            [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0-60.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/maskLeave_bureauFor4@2x.png"]];
        }else {
            [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0-60.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/maskLeave_bureau.png"]];
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _cid = @"0";
    NSLog(@"cid:%@",_cid);
    
    [self getChatListData];// 获取群聊列表数据
    
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    // NSLog(@"viewName:%@",viewName);
    //点击聊天列表页单行发送通知之后做完聊天详情页的viewWillAppear之后又走了一遍聊天记录列表页的viewWillAppear，将defaults中存的viewName的值覆盖了,所以加入此判断
//    if ([viewName isEqualToString:@"GroupChatDetailView"]) {//update by kate 2015.03.02
//        
//    }else{
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"GroupMsgListViewForTeacher" forKey:@"viewName"];
        [userDefaults synchronize];
 //   }
    
   //-------------------------------------------
 
    [MyTabBarController setTabBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
    reflashFlag = 1;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkSelfMomentsNew)
//                                                 name:@"checkMomentsNew"
//                                               object:nil];
    
    // 发现tab上的红点remove update by kate 2015.03.03
    if (newIconImgForTeacher.hidden) {
        
       MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
        UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
        [imgV removeFromSuperview];
        [noticeImgVForMsg removeFromSuperview];

        
    }
    
    [self checkMomentsMsgNew];
    //----离线缓存2015.05.14---------------------------------------------------------------------
    BOOL isConnect = [Utilities connectedToNetwork];
    if (isConnect) {
       
    }else{
        NSDictionary *result = [[NSUserDefaults standardUserDefaults]objectForKey:@"momentEnter"];
        //NSLog(@"result:%@",result);
        
        if (result) {
            
            if ([[result objectForKey:@"result"] integerValue] == 1) {
                
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"momentEnter"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _tableView.hidden = NO;
                
                listArray =[[NSMutableArray alloc] initWithArray:[result objectForKey:@"message"] copyItems:YES];
                
                float heightFrame;
                for (int i=0; i<[listArray count]; i++) {
                    
                    NSArray *array =[listArray objectAtIndex:i];
                    for (int j=0; j<[array count]; j++) {
                        
                        NSDictionary *dic = [array objectAtIndex:j];
                        NSString *type = [dic objectForKey:@"type"];
                        if ([type integerValue] == 10001) {
                            _foundModuleName = [dic objectForKey:@"name"];
                        }
                        
                    }
                    
                    float height = [array count]*50;
                    if (i == 0) {
                        heightFrame = height;
                    }else{
                        
                        heightFrame = heightFrame+height;
                        
                    }
                    
                }
                
                if ([_foundModuleName length]>13) {
                    newIconImgForTeacher.frame = CGRectMake(14*16 + 63, (50 - 10)/2+20, 10, 10);
                }else{
                    newIconImgForTeacher.frame = CGRectMake([_foundModuleName length]*16 + 63, (50 - 10)/2+20, 10, 10);
                    
                }
                
                newIconImgForTeacher.frame = CGRectMake(self.view.frame.size.width - 40.0, (50 - 10)/2+20, 10, 10);
                
                _headerView.frame = CGRectMake(0, 0, _tableView.frame.size.width, heightFrame+50+20*([listArray count]+1));
                [_headerView reloadData];
                _tableView.tableHeaderView = _headerView;

                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }else{
                [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        }
    }
    
    if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
        _foundModuleName = @"校友圈";
#endif
        _foundModuleName = @"师生圈";//2016.01.05
    }
    
    if ([_foundModuleName length]>13) {
        newIconImgForTeacher.frame = CGRectMake(14*16 + 63, (50 - 10)/2+20, 10, 10);
    }else{
        newIconImgForTeacher.frame = CGRectMake([_foundModuleName length]*16 + 63, (50 - 10)/2+20, 10, 10);
        
    }
    
    newIconImgForTeacher.frame = CGRectMake(self.view.frame.size.width - 40.0, (50 - 10)/2+20, 10, 10);
    
    //[_tableView reloadData];
//---------------------------------------------------------------------------------
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkMomentsNew" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *result = [FRNetPoolUtils getMoments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                
                
                if ([[result objectForKey:@"result"] integerValue] == 1) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"momentEnter"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    _headerView.hidden = NO;
                    
                    listArray =[[NSMutableArray alloc] initWithArray:[result objectForKey:@"message"] copyItems:YES];
                    
                    float heightFrame;
                    for (int i=0; i<[listArray count]; i++) {
                        
                        NSArray *array =[listArray objectAtIndex:i];
                        for (int j=0; j<[array count]; j++) {
                            
                            NSDictionary *dic = [array objectAtIndex:j];
                            NSString *type = [dic objectForKey:@"type"];
                            if ([type integerValue] == 10001) {
                                _foundModuleName = [dic objectForKey:@"name"];
                            }
                            
#if BUREAU_OF_EDUCATION
                            if ([type integerValue] == 10007) {
                                [self isNeedShowMasking];
                            }
#endif
                            
                        }
                        
                        float height = [array count]*50;
                        if (i == 0) {
                            heightFrame = height;
                        }else{
                            
                            heightFrame = heightFrame+height;
                          
                        }
                        
                    }
                    
                    
                    if ([_foundModuleName length]>13) {
                        newIconImgForTeacher.frame = CGRectMake(14*16 + 63, (50 - 10)/2+20, 10, 10);
                    }else{
                        newIconImgForTeacher.frame = CGRectMake([_foundModuleName length]*16 + 63,(50 - 10)/2+20, 10, 10);
                        
                    }
                    newIconImgForTeacher.frame = CGRectMake(self.view.frame.size.width - 40.0, (50 - 10)/2+20, 10, 10);
                    
                    _headerView.frame = CGRectMake(0, 0, _tableView.frame.size.width, heightFrame+50+20*([listArray count]+1));
                    [_headerView reloadData];//
                    _tableView.tableHeaderView = _headerView;
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }
                
                
            }else{
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                //---update 2015.06.25--------------------------------------------------------------
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
                [self isConnected];
                //------------------------------------------------------------------------------------
                
            }
            
        });
        
    });
}


- (void)createNoDataView
{
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49)];
    noDataView.backgroundColor = [UIColor clearColor];
    noDataView.hidden = YES;
    
    UIImageView *noDataLogo = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 124, 174)];
    noDataLogo.image = [UIImage imageNamed:@"icon_jxw.png"];
    
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataLogo.frame.origin.y+noDataLogo.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您还没有加入任何群聊";
    
    
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"点击右上角创建一个试试吧";
    //label2.backgroundColor = [UIColor grayColor];
    
    //---update 2015.05.06----------------------
    if ([@"bureau" isEqualToString:schoolType]) {//教育局
        
        noDataLogo.hidden = YES;
        label.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 20.0 -49.0)/2.0, [UIScreen mainScreen].bounds.size.width, 20.0);
        label.text = @"暂无聊天信息";
        label.textColor = [UIColor grayColor];
        [noDataView addSubview:label];
        
    }else{
        
        [noDataView addSubview:noDataLogo];
        [noDataView addSubview:label];
        [noDataView addSubview:label2];
    }
    //--------------------------------------------
    
    
    [self.view addSubview:noDataView];
    
}

-(void)showNoDataView{
    
    if ([self.chatListArray count] == 0) {
        noDataView.hidden = NO;
    }
    
}

// 获取群聊列表数据
-(void)getChatListData{
    
//    if (![Utilities isConnected]) {//2015.06.30
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
//        return;
//        
//    }
    
    [Utilities dismissProcessingHud:self.view];
    //[Utilities showProcessingHud:self.view];
    
    [NSThread detachNewThreadSelector:@selector(getChatListDataNewThread) toTarget:self withObject:nil];
}

- (void)getChatListDataNewThread
{
    
    @autoreleasepool{
        
        NSLog(@"sql cid:%@",_cid);
        NSLog(@"uid:%@",[Utilities getUniqueUidWithoutQuit]);
        
        NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[_cid longLongValue]];
        NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
        NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
        int cnt = [chatsListDict.allKeys count];
         MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        if(appDelegate.tabBarController.selectedIndex == 2){
            
            if (cnt > [self.chatListArray count]) {
                
                [self removeHeadArray];
            }
            
        }

        if(cnt > 0){
            
            for (int listCnt = 0; listCnt < cnt; listCnt++) {
                
                NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
                
                GroupChatList *chatList = [[GroupChatList alloc] init];
                chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
                chatList.msg_table_name = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_table_name"]];
                chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
                chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
                chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
                chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
                chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
                chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
                chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
                chatList.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
                chatList.cid = [[chatObjectDict objectForKey:@"cid"] longLongValue];
                chatList.bother = [[chatObjectDict objectForKey:@"bother"] integerValue];
                
                //                NSLog(@"gid:%@",[chatObjectDict objectForKey:@"gid"]);
                //                NSLog(@"cid:%@",[chatObjectDict objectForKey:@"cid"]);
                //                NSLog(@"last_msg:%@",[chatObjectDict objectForKey:@"last_msg"]);
                //       NSLog(@"title:%@",[chatObjectDict objectForKey:@"title"]);
                //---update 2015.09.08----------------------------------------------------------
                if(listCnt > 0){
                    
                    GroupChatList *chatListTemp = [chatListArr objectAtIndex:[chatListArr count]-1];
                    if (chatList.gid != chatListTemp.gid) {
                        [chatListArr addObject:chatList];
                    }
                }else{
                    [chatListArr addObject:chatList];
                }
                
                //[chatListArr addObject:chatList];
                //----------------------------------------------------------------------------------
                
            }
            
        }else{
            
            [Utilities dismissProcessingHud:self.view];
            [self showNoDataView];
            
        }
        
        
        
        [self performSelectorOnMainThread:@selector(loadChatListData:) withObject:chatListArr waitUntilDone:YES];
        
    }
    
    
    [NSThread exit];
    
    
}

// 加载聊天列表数据
- (void)loadChatListData:(NSMutableArray *)chatListData
{
    [self.chatListArray removeAllObjects];
    self.chatListArray = chatListData;
    
    //NSLog(@"chatListArray:%@",self.chatListArray);
    
    if ([self.chatListArray count] > 0) {
        
        noDataView.hidden = YES;
        //_tableView.hidden = NO;
        
        [Utilities dismissProcessingHud:self.view];
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        
    } else {
        noDataView.hidden = NO;
        //_tableView.hidden = YES;
       
        
    }
    
}

- (BOOL)deleteChatsListDataWithUserID:(long long)gid
{
    BOOL deleteResult = NO;
    
    NSString *deleteChatListSql = [[NSString alloc] initWithFormat:@"delete from msgListForGroup_%lli where gid = %lli",[_cid longLongValue],gid];
    deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatListSql];
    
    return deleteResult;
}

-(NSMutableArray*)getGroupAvatar:(NSString*)gid{
    
    /**
     * 拉取群头像
     * @author luke
     * @date 2015.05.26
     * @args
     *  op=getGroupAvatar, sid=, uid=, gid=
     */
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          gid,@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        //NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            for (int i=0; i<[tempArray count]; i++) {
                [array addObject:[[tempArray objectAtIndex:i] objectForKey:@"avatar"]];
            }
            
            for (int i=0; i<[array count]; i++) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    UIImage *itemImg = [FRNetPoolUtils getImage:[array objectAtIndex:i]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [returnArray addObject:itemImg];
                        
                    });
                    
                });
                
                
            }
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
    return returnArray;
    
}

// 获取头像数组
-(NSMutableArray*)getHeadArray:(long long)gid{
    
    NSLog(@"gid:%lli",gid);
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from msgGroupListForHeadImg where gid = %lli and uid = %lli",gid,[[Utilities getUniqueUidWithoutQuit] longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
    NSInteger cnt = [chatsListDict.allKeys count];
    for (int i = 0; i < cnt; i++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:i]];
        
        GroupChatListHeadObject *chatListHead = [[GroupChatListHeadObject alloc] init];
        chatListHead.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
        chatListHead.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        chatListHead.headUrl = [chatObjectDict objectForKey:@"headUrl"];
        chatListHead.name = [chatObjectDict objectForKey:@"name"];
        [chatListArr addObject:chatListHead];
        
    }
    
    return chatListArr;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return 1;
    }else{
        // Return the number of sections.
        NSInteger number = [listArray count]+1;
         return number;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        // Return the number of rows in the section.
        return [self.chatListArray count];
    }else{
        
        if (section < [listArray count]) {
            return [(NSArray*)[listArray objectAtIndex:section] count];
        }else{
          return 1;
        }
        
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        static NSString *CellIdentifier = @"MsgListCell";
        
        MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        GroupChatList *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        cell.groupChatListObject = chatListObject;
        cell.nameLabel.text = chatListObject.title;
        //cell.detailLabel.text = chatListObject.last_msg;
        cell.headImageViewForGroup.image = [UIImage imageNamed:@"loading_gray.png"];
        
        if (chatListObject.bother == 0) {
            
            cell.botherImgV.image = nil;
            cell.botherImgV.hidden = YES;
            
        }else{
            
            cell.botherImgV.image = [UIImage imageNamed:@"icon_mdr.png"];
            cell.botherImgV.hidden = NO;
        }
        
        //cell.botherImgV.image = [UIImage imageNamed:@"icon_mdr.png"];
        
        //NSLog(@"gid:%lli",chatListObject.gid);
        
        if (chatListObject.msg_state == MSG_SEND_FAIL) {
            cell.sendFailed.hidden = NO;
            cell.detailLabel.frame = CGRectMake(80, 34, 237, 26);
        } else {
            cell.sendFailed.hidden = YES;
            cell.detailLabel.frame = CGRectMake(67+8, 34, [[UIScreen mainScreen] bounds].size.width - 67 - 8, 26);
        }
        
        [cell setDetail:chatListObject.last_msg];//update 2015.07.17
        //---------------------------------------------------------
        /*Done:获取群头像数组，排列组合，设置cell.headImageView*/
        
        cell.headImageView.hidden = YES;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        
        //NSLog(@"gid:%lli",chatListObject.gid);
        
        NSMutableArray *tempArray = [self getHeadArray:chatListObject.gid];
        
        for (int i=0; i<[tempArray count]; i++) {
            
            GroupChatListHeadObject *headObj = [tempArray objectAtIndex:i];
            
            long long headUid = headObj.user_id;
            NSString *headUrl = headObj.headUrl;
            NSString *imageName = [headUrl lastPathComponent];
            NSString *imagePath = [Utilities getHeadImagePath:headUid imageName:imageName];
            if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                if (image) {
                    [returnArray addObject:image];
                }else{
                    [array addObject:headObj];
                    
                }
                
            }else{
                
                [array addObject:headObj];
                
            }
        }
        
        if (([tempArray count]>0) && ([returnArray count] == [tempArray count])) {
            
            if ([headArray count] == [self.chatListArray count]) {
                
                cell.headImageViewForGroup.image = [headArray objectAtIndex:indexPath.row];
                
            }else{
                
                [self initImageposition];
                //NSLog(@"returnArrayCount:%d",[returnArray count]);
                UIImage *image = [self makeGroupAvatar:returnArray];
                if (image) {
                    [headArray addObject:image];
                }else{
                    NSLog(@"nil");
                }
                
                cell.headImageViewForGroup.image = image;
                
            }
            
            
        }else{
            for (int i=0; i<[array count]; i++) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    GroupChatListHeadObject *headObj = [array objectAtIndex:i];
                    
                    long long headUid = headObj.user_id;
                    NSString *headUrl = headObj.headUrl;
                    NSString *imageName = [headUrl lastPathComponent];
                    NSString *imagePath = [Utilities getHeadImagePath:headUid imageName:imageName];
                    
                    // 拉取头像存储本地
                    [FRNetPoolUtils getPicWithUrl:headUrl picType:PIC_TYPE_HEAD userid:headUid msgid:0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                            if (image) {
                                [returnArray addObject:image];
                            }
                        }
                        
                        if (i == [array count]-1) {
                            
                            [self initImageposition];
                            
                            //NSLog(@"returnArrayCount:%d",[returnArray count]);
                            
                            UIImage *image = [self makeGroupAvatar:returnArray];
                            
                            cell.headImageViewForGroup.image = image;
                            
                        }
                    });
                    
                });
                
            }
            
        }
        
        //---------------------------------------------------------------------------
        
        // 时间标签,转换时间形式
        long long timestamp = chatListObject.timestamp;
        timestamp = timestamp/1000.0;
        
        NSString *dateString = [Utilities timeIntervalToDate:timestamp timeType:0 compareWithToday:YES];
        [cell setTime:dateString];
        
        if (tableView.editing == YES) {
            cell.timeLabel.hidden = YES;
            
        } else {
            cell.timeLabel.hidden = NO;
            cell.unReadBadgeView.hidden = YES;
            cell.unReadLabel.hidden = YES;
            cell.unReadLabel.text = @"";
            
            NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", cell.groupChatListObject.gid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
            int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
            if (cnt > 0) {
                
                cell.unReadBadgeView.hidden = NO;
                cell.unReadLabel.hidden = NO;
                cell.unReadBadgeView.frame = CGRectMake(cell.headImageViewForGroup.frame.origin.x + WIDTH_HEAD_CELL_IMAGE - 10, cell.headImageViewForGroup.frame.origin.y - 2, 19, 19);
                cell.unReadLabel.frame = cell.unReadBadgeView.frame;
                
                
                if (cnt < 10) {
                    cell.unReadLabel.text = [NSString stringWithFormat:@"%d", cnt];
                } else {
                    CGRect frame = cell.unReadBadgeView.frame;
                    frame.origin.x -= 5;
                    frame.size.width += 10;
                    cell.unReadBadgeView.frame = frame;
                    cell.unReadLabel.frame = frame;
                    
                    if (cnt < 100) {
                        cell.unReadLabel.text = [NSString stringWithFormat:@"%d", cnt];
                    } else {
                        cell.unReadLabel.text = @"...";
                    }
                }
            }
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = COMMON_TABLEVIEWCELL_SELECTED_COLOR;
        
        return cell;

    }else{
        
        static NSString *GroupedTableIdentifier = @"reuseIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        if (indexPath.section < [listArray count]) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            NSArray *array = [listArray objectAtIndex:indexPath.section];
            NSDictionary *dic = [array objectAtIndex:indexPath.row];
            NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
            
            cell.textLabel.text = name;
            cell.textLabel.font = [UIFont systemFontOfSize:17.0];
            [cell.imageView sd_setImageWithURL:[dic objectForKey:@"icon"] placeholderImage:[UIImage imageNamed:@"knowledge/icon_xyq.png"]];
            
            // 去掉new标实 2015.07.29
             if ([type integerValue] == 10007) {//请假
             
                 NSString *isNewForScann = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNewForLeaveT"];
                 
                 if (!isNewForScann) {
                     isNewForScan.image = [UIImage imageNamed:@"icon_forNew.png"];
                     
                     if ([name length]>11) {
                         isNewForScan.frame = CGRectMake(12*16 + 63+5, (50.0 - 18)/2, 30, 18.0);
                     }else{
                         isNewForScan.frame = CGRectMake([name length]*16 + 63+5, (50.0 - 18)/2, 30.0, 18.0);
                         
                     }
                     
                     if (![cell viewWithTag:345]) {
                         [cell addSubview:isNewForScan];
                     }
                     
                 }else{
                     
                     [isNewForScan removeFromSuperview];
                 }
             
             }else{
               //isNewForScan.image = nil;
             }

            
        }else{
            
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"                      +创建管理组"];
            
            [title addAttribute:(NSString *)kCTFontAttributeName
                          value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:24].fontName,24,NULL))
                          range:NSMakeRange(22,1)];//字体
            [title addAttribute:(NSString *)kCTFontAttributeName
                          value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:17.0].fontName,
                                                                           17.0,
                                                                           NULL))
                          range:NSMakeRange(23,5)];//字体
            
            [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] range:NSMakeRange(22,6)];//颜色
            //[title addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(22,1)];//颜色
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.attributedText = title;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            }
        
        return cell;

    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        // 进入编辑状态后不显示时间和未读消息数
        MsgListCell *cell =  (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (tableView.editing == YES) {
            cell.timeLabel.hidden = YES;
            
        } else {
            cell.timeLabel.hidden = NO;
            
        }
        
        return YES;
    }else{
        return NO;
    }
   
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        GroupChatList *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.gid];
        
        if (bDeleteMsg) {
            
            NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoForGroup_%lli",chatListObject.gid];
            [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
            
            [self.chatListArray removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
            
            [self isShowNewOnTab3];
            
        } else {
            // 删除失败提示
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Failed to delete chat!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
            [alert show];
            
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleRows = [tableView visibleCells];
    if([visibleRows count] > 0){
        for (MsgListCell *cell in visibleRows) {
            cell.timeLabel.hidden = NO;
            
        }
    }
    
    //[self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableView) {
        
        GroupChatList *groupChatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        
        //    MsgListCell *cell = (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
        //    if (cell.groupChatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.groupChatListObject.msg_state != MSG_READ_FLG_READ) {
        //        cell.groupChatListObject.msg_state = MSG_READ_FLG_READ;
        //        [cell.groupChatListObject updateToDB];
        //    }
        if (groupChatListObject.is_recieved == MSG_IO_FLG_RECEIVE && groupChatListObject.msg_state != MSG_READ_FLG_READ ) {
            groupChatListObject.msg_state = MSG_READ_FLG_READ;
            [groupChatListObject updateToDB];
        }
        //cell.unReadBadgeView.hidden = YES;
        
        //NSLog(@"cell.groupChatListObject.gid:%lld",cell.groupChatListObject.gid);
        
        NSString *title = [NSString stringWithFormat:@"%@",groupChatListObject.title];
        long long gid = groupChatListObject.gid;
        long long cid = groupChatListObject.cid;
        
        [MyTabBarController setTabBarHidden:YES];

        GroupChatDetailViewController *chatDeatilController = [[GroupChatDetailViewController alloc] init];
        //chatDeatilController.hidesBottomBarWhenPushed = YES;//解决隐藏TabBar时候，放在此位置上的view无法点击的问题
        chatDeatilController.gid = gid;
        chatDeatilController.titleName = title;
        chatDeatilController.cid = cid;
        chatDeatilController.groupChatList = groupChatListObject;
        if (groupChatListObject.last_msg_type == 4 || groupChatListObject.last_msg_type == 5) {
            
            if (groupChatListObject.user_id == [[Utilities getUniqueUidWithoutQuit] longLongValue]) {
                chatDeatilController.isViewGroupMember = 0;
            }else{
                chatDeatilController.isViewGroupMember = 1;
            }
            
        }else{
            chatDeatilController.isViewGroupMember = 1;
        }
        
        [self.navigationController pushViewController:chatDeatilController animated:YES];
        
        [self getGroupHead:groupChatListObject];
        
    }else{
        
        if (indexPath.section < [listArray count]) {
            
            NSArray *array = [listArray objectAtIndex:indexPath.section];
            NSDictionary *dic = [array objectAtIndex:indexPath.row];
            NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
            switch ([type integerValue]) {
                case 10001:// 校友圈
                {
                    MomentsViewController *commentList  = [[MomentsViewController alloc]init];
                    commentList.titleName = name;
                    commentList.fromName = @"school";
                    commentList.cid = @"0";
                    [self.navigationController pushViewController:commentList animated:YES];
                }
                    break;
                    
                case 9:// 知识库
                {
                    KnowlegeHomePageViewController *kbV = [[KnowlegeHomePageViewController alloc]init];
                    [self.navigationController pushViewController:kbV animated:YES];
                }
                    break;
                    
                case 10002:// 校校通
                {
                    SchoolExhibitionViewController *schoolExhi = [[SchoolExhibitionViewController alloc]init];
                    [self.navigationController pushViewController:schoolExhi animated:YES];
                }
                    break;
                    
                case 10003:// 扫一扫
                {
                    //            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNewForScan"];
                    //            [[NSUserDefaults standardUserDefaults] synchronize];//去掉new标实 2015.07.29
                    
                    ScanViewController *scan = [[ScanViewController alloc]init];
                    scan.viewType = @"scanView";
                    [self.navigationController pushViewController:scan animated:YES];
                    
                }
                    break;
                    
                case 10004:{// 同城服务
                    
                    NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"extra"]]];
                    NSString *url = [Utilities appendUrlParams:tempUrl];
                    NSLog(@"url:%@",url);
#if 0
                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                    //fileViewer.url = [NSURL URLWithString:url];
                    fileViewer.fromName = @"momentsEntrance";
                    fileViewer.requestURL = url;
                    fileViewer.titleName = @"";
                    fileViewer.isShowSubmenu = @"0";
                    fileViewer.isRotate = @"1";
#endif
                    if (isOSVersionLowwerThan(@"9.0")){
                        
                        // 2015.09.23
                        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                        fileViewer.requestURL = url;
                        fileViewer.titleName = @"";
                        fileViewer.isShowSubmenu = @"0";
                        fileViewer.isRotate = @"1";
                        [self.navigationController pushViewController:fileViewer animated:YES];
                        
                    }else{// iOS9.0以上 同城服务内发布页点击相册问题 先跳转到浏览器
                        
                        NSLog(@"url:%@",url);
                        
                        
                        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                        fileViewer.requestURL = url;
                        fileViewer.titleName = @"";
                        fileViewer.isShowSubmenu = @"0";
                        fileViewer.isRotate = @"1";
                        [self.navigationController pushViewController:fileViewer animated:YES];
                        
                        
                        //
                        //                NSURL *serveUrl = [[NSURL alloc]initWithString:url];
                        //                [[UIApplication sharedApplication ]openURL:serveUrl];
                        
                    }
                    
                    
                }
                    break;
                case 10007:
                 //to beck:To do :去请假wap页
                {
                    [ReportObject event:ID_OPEN_TAB3_LEAVE];

                    NSDictionary *user = [g_userInfo getUserDetailInfo];
                    NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                        // 请假
                        //                    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithDictionary:[displayArray objectAtIndex:indexPath.row]];
                    
//                    NSArray *listArr = [listArray objectAtIndex:indexPath.row];
//                    NSDictionary *listDic = [listArr objectAtIndex:0];
                    
                        NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]]];
//                        NSString *url = [Utilities appendUrlParams:tempUrl];
                    
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
                    
                    NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@&uid=%@&sid=%@&cid=%@&grade=%@",tempUrl, api, love, key, uid, G_SCHOOL_ID, @"0", usertype];

//                        NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", newUrl, _cid, usertype];
                    
                        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                        fileViewer.requestURL = newUrl;
                        fileViewer.titleName = @"";
                        fileViewer.isShowSubmenu = @"0";
                        fileViewer.isRotate = @"1";
                        [self.navigationController pushViewController:fileViewer animated:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNewForLeaveT"];
                    [_headerView reloadData];
                    
//                        [Utilities updateClassRedPoints:_cid last:lastLeaveId mid:mid];//更新请假红点 只有老师有红点 tony确认
                }
                    break;
                case 10008:{
                    
                    NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]]];
                    if ([@"" isEqualToString:tempUrl]) {
                        
                         [self.view makeToast:@"敬请期待" duration:1.0 position:@"center" image:nil];
                        
                    }else{
                        
                        NSDictionary *user = [g_userInfo getUserDetailInfo];
                        NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                        
                        //                        NSString *url = [Utilities appendUrlParams:tempUrl];
                        
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
                        
                        NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@&uid=%@&sid=%@&cid=%@&grade=%@",tempUrl, api, love, key, uid, G_SCHOOL_ID, @"0", usertype];
                        
                        //                        NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", newUrl, _cid, usertype];
                        
                        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                        fileViewer.requestURL = newUrl;
                        fileViewer.titleName = @"";
                        fileViewer.isShowSubmenu = @"0";
                        fileViewer.isRotate = @"1";
                        [self.navigationController pushViewController:fileViewer animated:YES];
                    }
                 
                }
                break;
                    
                    
                default:
                    break;
            }
        }else{
            
            NSDictionary *message_info;
            message_info = [g_userInfo getUserDetailInfo];
            NSString *checked = [message_info objectForKey:@"role_checked"];
            if ([checked integerValue] == 1) {
                //创建群聊
                LaunchGroupChatViewController *launchGroup = [[LaunchGroupChatViewController alloc] init];
                launchGroup.cid = @"0";
                SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:launchGroup];
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                
                 [self.view makeToast:@"您还未通过审核无法使用此功能" duration:1.0 position:@"center" image:nil];            }
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _headerView) {
        if (0 == section) {
            return 20;
        }else {
            return 10;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _headerView) {
        
        if (section < [listArray count]) {
           return 10;
        }else{
            return 0;
        }
        
    }
 
    return 0;
}

// 调用群头像接口
-(void)getGroupHead:(GroupChatList*)chatList{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          [NSString stringWithFormat:@"%lli",chatList.gid],@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            //群聊数量
            NSString *memberNum = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"member"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserNumer" object:memberNum];
            
            //name 群名字
            NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
            chatList.title = groupName;
            [chatList updateGroupName];//更新群名字
            
            GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
            headObject.gid = chatList.gid;
            [headObject deleteData];
            
            for (int i =0; i<[tempArray count]; i++) {
                
                long long headUid = [[[tempArray objectAtIndex:i] objectForKey:@"uid"] longLongValue];
                NSString *headUrl = [[tempArray objectAtIndex:i] objectForKey:@"avatar"];
                NSString *name = [[tempArray objectAtIndex:i] objectForKey:@"name"];
                
                headObject.user_id = headUid;
                headObject.headUrl = headUrl;
                headObject.name = name;
                [headObject insertData];
                
            }
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

// 去群聊详细页
-(void)gotoGroupChatDetail:(NSNotification*)notification{
    
    // To do:生成群成功接收消息走此方法 刷新群聊列表 跳转至聊天详细页
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
    //[self getChatListData];// 获取最新群聊列表数据显示
    
    groupChatList = (GroupChatList*)[notification object];
    _cid = [NSString stringWithFormat:@"%lli",groupChatList.cid];
     [MyTabBarController setTabBarHidden:YES];
    GroupChatDetailViewController *groupDetailV = [[GroupChatDetailViewController alloc]init];
    groupDetailV.hidesBottomBarWhenPushed = YES;
    groupDetailV.fromName = @"createGroupForTeacher";
    groupDetailV.titleName = groupChatList.title;
    groupDetailV.gid = groupChatList.gid;
    groupDetailV.cid = groupChatList.cid;
    groupDetailV.isViewGroupMember = 1;
    groupDetailV.groupChatList = groupChatList;
    [self.navigationController pushViewController:groupDetailV animated:YES];
    
    
}

// 自己删除并推出群
-(void)deleteGroupListCell:(NSNotification*)notification{
    
    long long gid = [[notification object] longLongValue];
    
    BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:gid];
    
    BOOL deleteResult = NO;
    
    if (bDeleteMsg) {
        
        NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoForGroup_%lli",gid];
        deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
        
    }
    
    if (deleteResult) {
        
        [self.chatListArray removeAllObjects];
        [self getChatListData];// 重新获取最新群聊列表数据显示
    }
    
}

//---组合头像逻辑-----------------------------------------------------------------------
- (UIImage *)makeGroupAvatar: (NSMutableArray *)imageArray {
    //数组为空，退出函数
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,193,193)];
    groupAvatarView.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    
    for (int i = 0; i < [imageArray count]; i++){
        UIImageView *tempImageView;
        if ([imageArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor4ModeImage objectAtIndex:i]CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor9ModeImage objectAtIndex:i]CGRectValue]];
        }
        [tempImageView setImage:[imageArray objectAtIndex:i]];
        [groupAvatarView addSubview:tempImageView];
    }
    
    //把UIView设置为image并修改图片大小55*55，因为是Retina屏幕，要放大2倍
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(110.0, 110.0)];
    
    return reImage;
}

- (void)initImageposition{
    
    //初始化4图片模式和9图片模式
    for(int i = 0; i < 9; i++){
        CGRect tempMode4Rect;
        CGRect tempMode9Rect;
        float mode4PositionX = 0;
        float mode4PositionY = 0;
        float mode9PositionX = 0;
        float mode9PositionY = 0;
        
        switch (i) {
            case 0:
                mode4PositionX = 4;
                mode4PositionY = 4;
                mode9PositionX = 4;
                mode9PositionY = 4;
                break;
            case 1:
                mode4PositionX = 98.5;
                mode4PositionY = 4;
                mode9PositionX = 67;
                mode9PositionY = 4;
                break;
            case 2:
                mode4PositionX = 4;
                mode4PositionY = 98.5;
                mode9PositionX = 130;
                mode9PositionY = 4;
                break;
            case 3:
                mode4PositionX = 98.5;
                mode4PositionY = 98.5;
                mode9PositionX = 4;
                mode9PositionY = 67;
                break;
            case 4:
                mode9PositionX = 67;
                mode9PositionY = 67;
                break;
            case 5:
                mode9PositionX = 130;
                mode9PositionY = 67;
                break;
            case 6:
                mode9PositionX = 4;
                mode9PositionY = 130;
                break;
            case 7:
                mode9PositionX = 67;
                mode9PositionY = 130;
                break;
            case 8:
                mode9PositionX = 130;
                mode9PositionY = 130;
                break;
            default:
                break;
        }
        
        //添加4模式图片坐标到数组
        if (i < 4 ){
            tempMode4Rect = CGRectMake(mode4PositionX, mode4PositionY, 90.5, 90.5);
            [_positionFor4ModeImage addObject:[NSValue valueWithCGRect:tempMode4Rect]];
        }
        
        //添加4模式图片坐标到数组
        tempMode9Rect = CGRectMake(mode9PositionX, mode9PositionY, 59, 59);
        [_positionFor9ModeImage addObject:[NSValue valueWithCGRect:tempMode9Rect]];
    }
}

-(UIImage*)convertViewToImage:(UIView*)v{
    
    CGSize s = v.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)removeHeadArray{
    
    [headArray removeAllObjects];
}
//-----------------------------------------------------------------------------------------------------
//----add by  kate 2015.06.26---------------
-(void)isConnected{
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        if (!networkVC) {
            
            networkVC = [[networkBar alloc] init];
            //            topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
            //            topBar = networkVC.view;
            
            //            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
            //            singleTouch.delegate = self;
            //            [topBar addGestureRecognizer:singleTouch];
            //
            //            [self.view addSubview:topBar];
            
            _headerView.tableHeaderView = networkVC.view;
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
            singleTouch.delegate = self;
            [_headerView.tableHeaderView addGestureRecognizer:singleTouch];
            
            _headerView.frame = CGRectMake(0, 0, _headerView.frame.size.width, _headerView.frame.size.height+40.0);
            
            if (!newIconImgForTeacher.hidden) {
                
                newIconImgForTeacher.frame = CGRectMake(newIconImgForTeacher.frame.origin.x, newIconImgForTeacher.frame.origin.y + 40.0, newIconImgForTeacher.frame.size.width, newIconImgForTeacher.frame.size.height);
                
            }
            
            [_headerView reloadData];
            _tableView.tableHeaderView = _headerView;
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
        }
        
    }else{
        
        networkVC = nil;
        //直接将tableHeaderView设置为nil后者设置frame的height为0 不好用 先设置一个最小的值
        _headerView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        _headerView.frame = CGRectMake(0, 0, _headerView.frame.size.width, _headerView.frame.size.height-39.0);
       
        if (!newIconImgForTeacher.hidden) {
            if ([_foundModuleName length]>13) {
                newIconImgForTeacher.frame = CGRectMake(14*16 + 63, (50 - 10)/2+20, 10, 10);
            }else{
                newIconImgForTeacher.frame = CGRectMake([_foundModuleName length]*16 + 63, (50 - 10)/2+20, 10, 10);
                
            }
            newIconImgForTeacher.frame = CGRectMake(self.view.frame.size.width - 40.0, (50 - 10)/2+20, 10, 10);
        }
        
        [_headerView reloadData];
        _tableView.tableHeaderView = _headerView;
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    }
    
     NSLog(@"_headerView.height:%f",_headerView.frame.size.height);
    
}
//去网络设置引导页
-(void)gotoNetworkGuide{
    
    NetworkGuideViewController *networkGVC = [[NetworkGuideViewController alloc]init];
    [self.navigationController pushViewController:networkGVC animated:YES];
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        [self getData];
        
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

-(void)checkSelfMomentsNew{
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
    UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
    [imgV removeFromSuperview];
    UIImageView *imgV2 = (UIImageView*)[button viewWithTag:431];
    [imgV2 removeFromSuperview];
    
#if 1 //2015.12.30 发现tab上的红点
    [button addSubview:noticeImgVForMsg];
#endif
    
    newIconImgForTeacher.hidden = NO;
    
}

// check发现cell的红点
-(void)checkMomentsMsgNew{
    
    /**
     * 动态消息检查数量
     * @author luke
     * @date 2015.06.05
     * @args
     *  ac=Circle, v=2, op=check, sid=, uid=, last=
     */
    
    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Circle",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          msgLastId, @"last",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"respDic:%@",respDic);
            NSString *message = [respDic objectForKey:@"message"];
            
            if ([message integerValue] > 0) {
                
                [self checkSelfMomentsNew];
                newIconImgForTeacher.hidden = NO;
                
            }else{
                
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
                UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
                [imgV removeFromSuperview];
                UIImageView *imgV2 = (UIImageView*)[button viewWithTag:431];
                [imgV2 removeFromSuperview];
                newIconImgForTeacher.hidden = YES;
                [self isShowNewOnTab3];
            }
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
}

//查询本地数据库看看cid=0的聊天表有木有未读消息
-(BOOL)isShowNewOnTab3{
    
    BOOL ret = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from msgListForGroup_0"];
    
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSInteger userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
       
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"gid"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
        if (count > 0) {
            ret = YES;
        }
    }
    

    if (ret) {
      
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
        UIImageView *imgV2 = (UIImageView*)[button viewWithTag:431];
        
        if (!imgV2) {
            [button addSubview:noticeImgVForMsg];
        }
        
    }else{
        
        if (newIconImgForTeacher.hidden) {
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
            UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
            [imgV removeFromSuperview];
            [noticeImgVForMsg removeFromSuperview];
        }
    }
    return ret;
}

@end

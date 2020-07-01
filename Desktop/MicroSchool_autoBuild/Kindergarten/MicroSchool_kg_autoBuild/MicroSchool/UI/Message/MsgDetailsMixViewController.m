//
//  MsgDetailsMixViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/19.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MsgDetailsMixViewController.h"
#import "GroupChatSettingViewController.h"
#import "StringUtil.h"
#import "PublicConstant.h"
#import "DBDao.h"
#import "Utilities.h"
#import "MsgZoomImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageResourceLoader.h"
#import "SubUINavigationController.h"
#import "SingleWebViewController.h"
#import "TranspondViewController.h"
#import "AtListViewController.h"

@interface MsgDetailsMixViewController ()

- (float)getCellHeight:(MixChatDetailObject *)entity;

// TableView 滚动到底部显示最后的聊天消息
- (void)scrollTableViewToBottom;

// 判断是否需要加载更多聊天数据
- (void)needShowMoreByRowID;

// 加载更多聊天数据
//- (void)loadMoreDetailMsgFromDB;

// 创建聊天方式选择键盘
- (void)createChatSelectTool;

// 显示输入框
- (void)showInputBar;

// 打开照相机
- (void)actionUseCamera;

// 打开相册
- (void)actionOpenPhotoLibrary;

// 初始化图片选取器
- (void)initImagePicker;

//隐藏键盘
- (void)dismissKeyboard;

//更改键盘类型
- (void)changeKeyboardType;

//变成文字输入模式
- (void)changeToKeyboardText;

//变成工具输入模式
- (void)changeToKeyboardTool;

//发送消息
- (void)sendTextMsg;

// 消息重发
- (void)resendMessageConfirm;

// 输入栏左边的发送图片功能按钮
//- (void)selectPicConfirm;

@end

@implementation MsgDetailsMixViewController

@synthesize user;
@synthesize chatDetailArray;
@synthesize currentShowTime;
@synthesize inputBar;
@synthesize inputTextView;
@synthesize gid;

// 要重发的消息
@synthesize resendMsg;

@synthesize msgID;
@synthesize chatType;

@synthesize frontName;

// audio
static double startRecordTime = 0;
static double endRecordTime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *chatDetail = [[NSMutableArray alloc] initWithCapacity:1];
        self.chatDetailArray = chatDetail;
        //[chatDetail release];
        
        msgIndexDic = [[NSMutableDictionary alloc] init];
        _pics = [[NSMutableArray alloc] init];
        
        [self setCustomizeTitle:_titleName];
        
        //加载更多聊天数据时候的加载框
        waitForLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        waitForLoadMore.frame = CGRectMake(([Utilities getScreenSize].width-20.0)/2.0, 5.0f, 20.0f, 20.0f);
        
        self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        uid = [[userInfo objectForKey:@"uid"] longLongValue];
        
        [self createChatSelectTool];
        
        [self initImagePicker];
    }
    return self;
}

-(id)initWithFromName:(NSString*)fromName{
    
    _fromName = fromName;
    self = [super init];
    
    if (self) {
        
        NSMutableArray *chatDetail = [[NSMutableArray alloc] initWithCapacity:1];
        self.chatDetailArray = chatDetail;
        //[chatDetail release];
        
        msgIndexDic = [[NSMutableDictionary alloc] init];
        
        waitForLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        waitForLoadMore.frame = CGRectMake(([Utilities getScreenSize].width-20.0)/2.0, 5.0f, 20.0f, 20.0f);
        
        //self.view.backgroundColor = COMMON_BACKGROUND_COLOR;
        self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        
        [self createChatSelectTool];
        
        [self initImagePicker];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    NSLog(@"_titleName:%@",_titleName);
    
     atArray = [[NSMutableArray alloc] init];
    
    timeFirst = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFirst"];
    if ([timeFirst length] == 0) {
        
        long long time = [[NSDate date] timeIntervalSince1970];
        NSString *timeFirstStr = [NSString stringWithFormat:@"%lld",time];
        [[NSUserDefaults standardUserDefaults]setObject:timeFirstStr forKey:@"timeFirst"];
        
    }
    
    //---获取窗口大小
    winSize = [[UIScreen mainScreen] bounds].size;
    
    //---初始化tableview-----------------------------------------
    CGRect tableFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR);
    chatTableview = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    chatTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTableview.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    chatTableview.scrollsToTop = YES;
    chatTableview.clipsToBounds = NO;
    chatTableview.contentSize = CGSizeMake(winSize.width, 1000);
    chatTableview.delegate = self;
    chatTableview.dataSource = self;
    [self.view addSubview:chatTableview];
    
    //---手势识别-------------------------------------------
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [chatTableview addGestureRecognizer:singleTouch];
    
    // 显示输入框
    [self showInputBar];
    
    isScrollToBottom = YES;//2015.08.27
    //---------------------各种通知----------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(atSomebody:)
                                                 name:NOTIFICATION_UI_PRESSLONG_USER_HEAD_IMAGE_MIX
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAtNames:)
                                                 name:GETATNAMES_MIX
                                               object:nil];
    

    
    //单条接收语音数据刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshSingleCell:)
                                                 name:NOTIFICATION_GOT_CHAT_REFRESH
                                               object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(loadMoreChatsListData:)
    //                                                 name:NOTIFICATION_DB_GET_MORECHATINFODATA
    //                                               object:nil];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUserInfo:)
                                                 name:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_MIX
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMsg:)
                                                 name:NOTIFICATION_UI_DELETE_MSG_MIX
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transpondMsg:)
                                                 name:NOTIFICATION_UI_TANSPOND_MSG
                                               object:nil];
    
    // 聊天页超链接从webView打开
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoWebView:)
                                                 name:@"OpenUrlByWebView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTitleName:)
                                                 name:@"changeTitleName" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUserNumer:)
                                                 name:@"changeUserNumer" object:nil];
    
    
    
    // 监听键盘的显示和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //--- add by kate 键盘下落消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard)
                                                 name:@"keyBoardDrop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitle)
                                                 name:@"changeTitle" object:nil];
    
    
    [ReportObject event:ID_GROUP_CHAT_OPEN_MESSAGE_INFO];//2015.06.25
    
    heightArray = [[NSMutableArray alloc] init];//cell高度数组 2015.07.25
    
    
    isReGetChatDetailData = YES;//add 2015.08.13
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//检查成员是否在群内,用来控制右上角按钮是否显示
-(void)checkGroupMember{
    
    /**
     * 检查成员是否在群内
     * @author luke
     * @date 2015.06.02
     * @args
     *  op=check, sid=, uid=, gid=, member=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          [NSString stringWithFormat:@"%lli",gid], @"gid",
                          [Utilities getUniqueUidWithoutQuit],@"member",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            [self setCustomizeRightButton:@"btn_ltsz.png"];//等新的图片
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
    
}

// 调用群头像接口
-(void)getGroupHead{
    
//    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli where gid = %lli limit 1",_cid,gid];
//    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
//    NSInteger cnt = [chatsListDict.allKeys count];
//    
//    MixChatListObject *chatList = [[MixChatListObject alloc] init];
//    
//    if(cnt > 0){
//        
//        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:0]];
//        chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
//        chatList.msg_table_name = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_table_name"]];
//        chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
//        chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
//        chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
//        chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
//        chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
//        chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
//        chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
//        chatList.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
//        chatList.cid = [[chatObjectDict objectForKey:@"cid"] longLongValue];
//        chatList.bother = [[chatObjectDict objectForKey:@"bother"] integerValue];
//        
//    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupAvatar", @"op",
                          [NSString stringWithFormat:@"%lli",gid],@"gid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            //群聊数量
            NSString *memberNum = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"member"];
            _userNumber = memberNum;
            //name 群名字
            NSString *groupName = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"name"];
            _titleName = groupName;
            [self changeTitle];
            //if (cnt > 0) {
                _groupChatList.title = groupName;
                [_groupChatList updateGroupName];//更新群名字
            //}
            
            GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
            headObject.gid = gid;
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

- (void)viewDidAppear:(BOOL)animated {
    [UIView setAnimationsEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatDetailData)
                                                 name:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearChatMessage:)
                                                 name:NOTIFICATION_DB_CLEAR_CHAT_MESSAGES
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showZoomPic:)
                                                 name:NOTIFICATION_UI_TOUCH_IMAGE_MIX
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playAudio:)
                                                 name:NOTIFICATION_UI_TOUCH_PLAY_AUDIO_MIX
                                               object:nil];
    
    numOfCellAudioPlaying = -1;
    
    if (isReGetChatDetailData) {//update 2015.08.13
        
        [self changeTitle];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"MsgDetailsMixView" forKey:@"viewName"];
        [userDefaults synchronize];
        NSString *viewName = [userDefaults objectForKey:@"viewName"];
        NSLog(@"viewName:%@",viewName);
        
        isMoreDataLoading = NO;
        isScrollToBottom = YES;
        
        if (gid == 0) {//单聊
            
            
            
            if((_groupChatList.schoolID==0) || (_groupChatList.schoolID == [G_SCHOOL_ID longLongValue])){
                
                [self setCustomizeRightButton:@"btn_ltsz.png"];
                
            }else{
                
            }
        }else{//群聊
            
            //---add 2016.2.22 为了从推送通知进此页获取成员数量以及头像--------------------------
            if (_userNumber == nil || [_userNumber integerValue] == 0) {
                
                [self getGroupHead];
                
            }else{
                
                
            }
            //-----------------------------------------------------------------------------
            [self checkGroupMember];
        }
       
        [self getChatDetailData];
        
    }
    
    
}

-(void)changeTitle{
    
    long long myUid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
    
    //To do: 检查DB中这条群聊对应的聊天详情的bother标实是什么。以此来决定navigation的title是否显示免打扰图片
    NSString *sql =  [NSString stringWithFormat:@"select bother from msgListMix where uid = %lli and gid = %lli",myUid,gid];
    NSString *bother = [[DBDao getDaoInstance] getResultsToString:sql];
    
    NSString *title;
    
    if ([bother integerValue] == 1) {
        
        if (_userNumber == nil || [_userNumber integerValue] == 0) {
            
            _userNumber = @"";
            
            title = [NSString stringWithFormat:@"%@🔕",_titleName];
            
        }else{
            title = [NSString stringWithFormat:@"%@(%@)🔕",_titleName,_userNumber];
        }
        
        ((UILabel *)self.navigationItem.titleView).text = title;
        ((UILabel *)self.navigationItem.titleView).lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        
    }else{
        
        if (_userNumber == nil || [_userNumber integerValue] == 0) {
            
            _userNumber = @"";
            
            title = _titleName;
            
        }else{
            
            title = [NSString stringWithFormat:@"%@(%@)",_titleName,_userNumber];
            
        }
        
        ((UILabel *)self.navigationItem.titleView).text = title;
        ((UILabel *)self.navigationItem.titleView).lineBreakMode = NSLineBreakByTruncatingMiddle;
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self dismissKeyboard];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_TOUCH_IMAGE_MIX object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_TOUCH_PLAY_AUDIO_MIX object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground"
                                                        object:nil];

    
    long long myUid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
    
    NSString *updateDetailsSql =[NSString stringWithFormat: @"update msgInfoMix_%lli_%lli set msg_state = %d where is_recieved = %d and msg_state != %d", gid,user.user_id, MSG_READ_FLG_READ, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
    [[DBDao getDaoInstance] executeSql:updateDetailsSql];
    
    NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set msg_state = %d where uid = %lli and is_recieved = %d and msg_state != %d and gid = %lli", MSG_READ_FLG_READ, myUid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ, gid];
    [[DBDao getDaoInstance] executeSql:updateListSql];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DB_CLEAR_CHAT_MESSAGES object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    isReGetChatDetailData = YES;//add 2015.08.13
    
    GroupChatSettingViewController *groupChatSet = [[GroupChatSettingViewController alloc]init];
    groupChatSet.gid = [NSString stringWithFormat:@"%lld", gid];
    groupChatSet.chatList = _groupChatList;
    groupChatSet.userObj = user;
    [self.navigationController pushViewController:groupChatSet animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//2015.09.09
    
}

// 聊天页超链接从webView打开
-(void)gotoWebView:(NSNotification*)notification{
    
    isReGetChatDetailData = YES;// add 2015.08.13
    
    NSURL *url = [notification object];
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.isFromEvent = YES;
    fileViewer.webType = SWLoadURl;//2015.09.23
    //fileViewer.fromName = @"message";
    fileViewer.url = url;
    fileViewer.currentHeadImgUrl = nil;
    
    [self.navigationController pushViewController:fileViewer animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//2015.09.09
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [chatDetailArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*CGFloat cellheight = TIME_HEIGHT;//预留的时间label
     //取聊天表高度
     GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:indexPath.row];
     cellheight = cellheight + [self getCellHeight:entity];
     // ＋10防止最后一条消息的泡泡显示不出来
     return cellheight + 10;*/
    // 2015.07.25
    
    //NSLog(@"2heightArrayCount:%lu",(unsigned long)[heightArray count]);
    CGFloat cellheight = TIME_HEIGHT;//预留的时间label
    if (heightArray != nil && ![heightArray isKindOfClass:[NSNull class]] && heightArray.count != 0){
        
        if (([chatDetailArray count] > indexPath.row) && ([heightArray count] > indexPath.row)) {
            
            MixChatDetailObject *entity = [chatDetailArray objectAtIndex:indexPath.row];
            
            cellheight = cellheight + [[heightArray objectAtIndex:indexPath.row] floatValue];
            
            if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
                cellheight += 10.0;
            }
        }
    }
    //NSLog(@"%ld-height:%f",(long)indexPath.row,[[heightArray objectAtIndex:indexPath.row] floatValue]);
    
    return cellheight+10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MixChatDetailObject *entity;
    if (indexPath.row >= [chatDetailArray count]) {
        entity = [chatDetailArray lastObject];
    } else {
        entity = [chatDetailArray objectAtIndex:indexPath.row];
    }
    
    //entity.labelHeight = [[heightArray objectAtIndex:indexPath.row] floatValue];
    entity.size = [MsgTextView heightForEmojiText:entity.msg_content];
    
    //    NSString *CellIdentifier = @"ChatDetailCellId";
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    
    MsgDetailCell *cell = (MsgDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[MsgDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    
    //cell.customDelegate = self;
    cell.index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    // 通过判断标志位来判断该条cell是否被描画了，如果没有，则描画
    // 注释掉reflashFlag部分 2015.08.27
    
    //    if (scrollFlag == 2) {//滑动方向为向上滑动
    
    if ([@"0"  isEqual: entity.reflashFlag]) {
        [self updateCellWithEntity:cell entity:entity updateState:NO];
    }else {
        if ((MSG_TYPE_PIC == entity.msg_type) && (MSG_SEND_SUCCESS == entity.msg_state || MSG_RECEIVED_SUCCESS == entity.msg_state || MSG_READ_FLG_READ == entity.msg_state)) {
            [self updateCellWithEntity:cell entity:entity updateState:NO];
            //NSLog(@"pic index:%ld-height:%f",(long)indexPath.row,[[heightArray objectAtIndex:indexPath.row] floatValue]);
        }else if ((MSG_TYPE_Audio == entity.msg_type) && (MSG_SEND_SUCCESS == entity.msg_state || MSG_RECEIVED_SUCCESS == entity.msg_state || MSG_READ_FLG_READ == entity.msg_state )){
            [self updateCellWithEntity:cell entity:entity updateState:NO];
            //NSLog(@"audio index:%ld-height:%f",(long)indexPath.row,[[heightArray objectAtIndex:indexPath.row] floatValue]);
        }
        else {
            // NSLog(@"else index:%ld-height:%f",(long)indexPath.row,[[heightArray objectAtIndex:indexPath.row] floatValue]);
            [self updateCellWithEntity:cell entity:entity updateState:YES];
        }
    }
    //    }
    //    else{
    //        [self updateCellWithEntity:cell entity:entity updateState:NO];
    //    }
    
    entity.reflashFlag = @"1";
    
    //if ([chatDetailArray count] > earliestRowID) {
    
    // 描画完毕后，设置entity，并replace到聊天数组中
    //NSLog(@"indexPath.row:%d",indexPath.row);
    if (indexPath.row >= [chatDetailArray count]) {
        [chatDetailArray replaceObjectAtIndex:([chatDetailArray count] - 1) withObject:entity];
    } else {
        NSLog(@"msgContent:%@",entity.msg_content);
        [chatDetailArray replaceObjectAtIndex:indexPath.row withObject:entity];
        
    }
    //}
    
    //[self updateCellWithEntity:cell entity:entity updateState:NO];
    
    
#if 0
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
#endif
    
    return cell;
}

#pragma mark - scrollView delegate
//分页下拉 2015.08.26
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < tableOffset) {//当前y小于屏幕最低端的y，说明当前滚动范围不在屏幕最底部
        isScrollToBottom = NO;//此时来消息不允许自动滚动屏幕到最底端
    }else{
        if (!isMoreDataLoading) {//2015.09.08
            isScrollToBottom = YES;
        }
    }
    
    if (!isMoreDataLoading && scrollView.contentOffset.y < 0) {
        //        isMoreDataLoading = YES;
        NSLog(@"earliestRowID:%d",earliestRowID);
        [self needShowMoreByRowID];
        
    }
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    
//    contentOffsetY = scrollView.contentOffset.y;
//    
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    // NSLog(@"scrollViewDidEndDragging");
    
    if ([inputTextView isFirstResponder]) {
        // 键盘下落
        [inputTextView resignFirstResponder];//滑动键盘下落 侯丽娜确认 2016.08.01
    }
    
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    isActionStart = NO;
    //[inputTextView becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try {
        
        isActionStart = NO;
        
        // 获取图片原图
        UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        if (MAX(selectedImage.size.width, selectedImage.size.height) > 960) {
            float newRedis = 960 / MAX(selectedImage.size.width, selectedImage.size.height);
            selectedImage = [ImageResourceLoader resizeImage:selectedImage toSize:CGSizeMake(floorf(selectedImage.size.width * newRedis), floorf(selectedImage.size.height * newRedis))];
        }
        
        if (selectedImage) {
            [self performSelector:@selector(sendTakePhotoMsg:) withObject:selectedImage afterDelay:0.5];
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"",@"") message:NSLocalizedString(@"Unsupported image format!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
            [alert show];
            //[alert release];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    @catch (NSException *exception) {
        //
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromSelector(_cmd),[NSNumber numberWithInt:0],exception,[NSNumber numberWithInt:1],nil];
        dispatch_async(dispatch_get_main_queue(), ^{ @autoreleasepool {[[NSNotificationCenter defaultCenter] postNotificationName:PROGRAM_ERROR object:dictionary];}});
    }
    @finally {
        //
    }
}

#pragma mark - Keyboard methods
// 显示键盘，升高输入栏
- (void)keyboardWillShow:(NSNotification *)notification
{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = inputBar.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[curve integerValue]];
    
    // 调整输入栏的位置
    inputBar.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    // 调整tableview的位置到输入栏之上
    chatTableview.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, inputBar.frame.origin.y);
    
    [self scrollTableViewToBottom];
}

// 显示键盘，升高输入栏
- (void)keyboardDidShow:(NSNotification *)notification
{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
}

// 隐藏键盘，放下输入栏
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = inputBar.frame;
    // self.view.bounds.size.height在进入拍照页之后会高出20 2015.07.28
    //containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    containerFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 64.0 - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[curve integerValue]];
    
    // set views with new info
    inputBar.frame = containerFrame;
    
    float dis = containerFrame.size.height - HEIGHT_INPUT_BAR;
    
    // commit animations
    [UIView commitAnimations];
    
    chatTableview.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR - dis);
    
    if(inputBar.alpha == 0){
        showSelectTool = NO;
        [self changeToKeyboardText];
        inputBar.alpha = 1;
    }
}

#pragma mark HPGrowingTextView Delegate

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    
    //NSLog(@"growingTextViewDidChange length:%d",growingTextView.text.length);
    
    if(growingTextView.text.length == 0){
        
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    }else{
        
        audioButn.hidden = YES;
    
        AudioBtn.frame = CGRectMake(WIDTH-33-7, AudioBtn.frame.origin.y, 33, 33);
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_p.png"] forState:UIControlStateHighlighted];
    }
    
    if (atText) {
        
        if ([@"@" isEqualToString:atText]) {
           
            //去选择的人列表
            AtListViewController *alvc = [[AtListViewController alloc] init];
            alvc.gid = gid;
            alvc.type = 1;
            SubUINavigationController *atListNav = [[SubUINavigationController alloc]initWithRootViewController:alvc];
            [self presentViewController:atListNav animated:YES completion:nil];
            
            atText = @"";
            
        }
        
    }
   
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //if(inputTextView.text.length > 1){
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect rect = inputBar.frame;
    rect.size.height -= diff;
    rect.origin.y += diff;
    inputBar.frame = rect;
    
    entryBackgroundImageView.frame = CGRectMake(0, inputBar.frame.size.height-1, inputBar.frame.size.width, 1);
    
    CGRect tableFrame = chatTableview.frame;
    tableFrame.size.height += diff;
    chatTableview.frame = tableFrame;
    [self scrollTableViewToBottom];
    //}
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //NSLog(@"growingTextView.text.length:%d",growingTextView.text.length);
    
    if ((growingTextView.text.length == 0) && (text.length == 0)) {
        //没有字符输入时，删除字符串
        return YES;
    }
    if ((text.length == 0)&&(range.length > 0)) {
        if (gid >0) {
            return [self backAt];
        }
        return YES;
        
    }
    
    if (growingTextView.text.length + text.length > MAX_TEXTLENGTH) {// 50000 这样写是为了避免输入法联想字数超出上限 2015.07.21
        //达到输入的上线
        return NO;
    }else{
        
        if (gid > 0) {
            
            atText = text;
        }
        
        return YES;
    }
    
    //----------------------------------------------------------------------------------
    /*
     NSMutableString *key = [[NSMutableString alloc] initWithString:growingTextView.text];
     [key replaceCharactersInRange:range withString:text];
     
     NSString *marked = [growingTextView textInRange:growingTextView.markedTextRange];
     
     if ([key length] == 0) {
     // 输入框为空的时候，走这里
     } else {
     NSString *language = [[UITextInputMode currentInputMode] primaryLanguage];
     if ([language isEqualToString:@"zh-Hans"]) {
     if (range.length > 0) {
     if ([string length] == 0) {
     if ([marked length] <= 1) {
     [_delegate searchFieldChanging:self key:key];
     }
     } else {
     [_delegate searchFieldChanging:self key:key];
     }
     }
     } else {
     [_delegate searchFieldChanging:self key:key];
     }
     }*/
    //------------------------------------------------------------------------------------------
    
    
    return YES;
}

#pragma mark UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    @try {
        if ([touch.view isDescendantOfView:chatTableview] && [touch.view isKindOfClass:[UIButton class]]) {
            UIButton *stateBtn = (UIButton *)touch.view;
            if (stateBtn.tag == TAG_STATE_BUTTON) {
                id chatCell = [[stateBtn superview] superview];
                if ([chatCell isKindOfClass:[MsgDetailCell class]]) {
                    MsgDetailCell *cell = (MsgDetailCell *)chatCell;
                    long long clickedMsgID = cell.msgID;
                    self.resendMsg = nil;
                    
                    // 根据msgid查找点击的消息
                    NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", clickedMsgID]];
                    if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                        MixChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
                        entity.groupid = gid;
                        if (MSG_SEND_FAIL == entity.msg_state) {
                            self.resendMsg = entity;
                            // update by kate 2014.11.03
                            if ([_fromName isEqualToString:@"feedback"]) {
                                
                            }else{
                                [self resendMessageConfirm];
                            }
                            
                        }
                    }
                } else {
                    chatCell = [[[stateBtn superview] superview] superview];
                    if ([chatCell isKindOfClass:[MsgDetailCell class]]) {
                        MsgDetailCell *cell = (MsgDetailCell *)chatCell;
                        long long clickedMsgID = cell.msgID;
                        self.resendMsg = nil;
                        
                        // 根据msgid查找点击的消息
                        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", clickedMsgID]];
                        if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                            MixChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
                            entity.groupid = gid;
                            if (MSG_SEND_FAIL == entity.msg_state) {
                                self.resendMsg = entity;
                                // update by kate 2014.11.03
                                if ([_fromName isEqualToString:@"feedback"]) {
                                    
                                }else{
                                    [self resendMessageConfirm];
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(([gestureRecognizer.view isKindOfClass:[HPGrowingTextView class]])&&(showSelectTool)){
            [inputTextView resignFirstResponder];
            [self changeToKeyboardText];
            keyboardButtonType = BTN_EMOTICOM;
            [inputTextView becomeFirstResponder];
            showSelectTool = NO;
        }
        
        if ([gestureRecognizer.view isKindOfClass:[UIHeadImage class]] || [touch.view isKindOfClass:[UIHeadImage class]]){
            return NO;
        }
        
        return YES;
    }
    @catch (NSException *exception) {
        //
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromSelector(_cmd),[NSNumber numberWithInt:0],exception,[NSNumber numberWithInt:1],nil];
        dispatch_async(dispatch_get_main_queue(), ^{ @autoreleasepool {[[NSNotificationCenter defaultCenter] postNotificationName:PROGRAM_ERROR
                                                                                                                           object:dictionary];}});
    }
    @finally {
        //
    }
}

# if 0
#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    @try {
        if (TAG_ACTIONSHEET_RESEND == actionSheet.tag) {
            if (0 == buttonIndex) {
                // 重发消息
                resendMsg.msg_state = MSG_SENDING;
                resendMsg.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
                
                [resendMsg updateToDB];
                
                // 及时更新消息的显示时间
                //resendMsg.dtLabelText = [UT_Date timeIntervalToDate:resendMsg.timestamp timeType:3 compareWithToday:YES];
                //[self setChatDetailObjectTimeLabel:resendMsg];
                
                // 更新聊天数据后刷新画面
                NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", resendMsg.msg_id]];
                if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                    [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
                    [chatDetailArray addObject:resendMsg];
                    // 更新msgid对应数组的索引字典
                    [self reloadMsgIndexDictionaryAndMsgLabel];
                    [chatTableview reloadData];
                }
                
                
                NSDictionary *data;
                
                if (resendMsg.msg_type == MSG_TYPE_PIC || resendMsg.msg_type == MSG_TYPE_Audio) {
                    
                    /*NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                     resendMsg.msg_file, @"png0",
                     nil];
                     NSArray *fileArray = [NSArray arrayWithObjects:fileDic, nil];
                     
                     data = [[NSDictionary alloc] initWithObjectsAndKeys:
                     @"GroupChat",@"ac",
                     @"2",@"v",
                     @"send", @"op",
                     [NSString stringWithFormat:@"%lli,",resendMsg.groupid], @"gid",
                     [NSString stringWithFormat:@"%lli,",resendMsg.msg_id],@"msgid",
                     [NSString stringWithFormat:@"%li,",(long)resendMsg.msg_type],@"type",
                     resendMsg.msg_content,@"message",
                     fileArray,@"files",
                     @"png",@"fileType",
                     nil];*/
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 耗时的操作
                        NSString *sendFlag = [FRNetPoolUtils sendMsgForMix:resendMsg];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([sendFlag isEqualToString:@"NO"]) {
                                
                                // 发送失败
                                resendMsg.msg_state = MSG_SEND_FAIL;
                                resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                                
                                
                            }else{
                                
                                // 发送成功
                                resendMsg.msg_state = MSG_SEND_SUCCESS;
                                resendMsg.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                                
                            }
                            
                            
                            [resendMsg updateToDB];
                            [self saveMsgToChatList:resendMsg];
                            // 更新msgid对应数组的索引字典
                            [self reloadMsgIndexDictionaryAndMsgLabel];
                            [chatTableview reloadData];
                            [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                            isScrollToBottom = YES;//add 2015.09.01
                            
                        });
                    });
                    
                    
                    
                }/*else if (resendMsg.msg_type == MSG_TYPE_Audio){
                  
                  NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                  resendMsg.msg_file, @"arm0",
                  nil];
                  NSArray *fileArray = [NSArray arrayWithObjects:fileDic, nil];
                  
                  data = [[NSDictionary alloc] initWithObjectsAndKeys:
                  @"GroupChat",@"ac",
                  @"2",@"v",
                  @"send", @"op",
                  [NSString stringWithFormat:@"%lli,",resendMsg.groupid], @"gid",
                  [NSString stringWithFormat:@"%lli,",resendMsg.msg_id],@"msgid",
                  [NSString stringWithFormat:@"%li,",(long)resendMsg.msg_type],@"type",
                  resendMsg.msg_content,@"message",
                  fileArray,@"files",
                  @"amr",@"fileType",
                  nil];
                  
                  }*/else if (resendMsg.msg_type == MSG_TYPE_TEXT){
                      
                      data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Message",@"ac",
                              @"3",@"v",
                              @"send", @"op",
                              [NSString stringWithFormat:@"%lli,",resendMsg.user_id], @"friend",
                              [NSString stringWithFormat:@"%lli,",resendMsg.groupid], @"gid",
                              [NSString stringWithFormat:@"%lli,",resendMsg.msg_id],@"msgid",
                              [NSString stringWithFormat:@"%li,",(long)resendMsg.msg_type],@"type",
                              resendMsg.msg_content,@"message",
                              nil];
                      
                      [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                          
                          NSDictionary *respDic = (NSDictionary*)responseObject;
                          NSString *result = [respDic objectForKey:@"result"];
                          
                          //NSLog(@"respDic:%@",respDic);
                          
                          if ([result integerValue] == 1) {
                              
                              NSDictionary *dic = [respDic objectForKey:@"message"];
                              
                              // 发送成功
                              resendMsg.msg_state = MSG_SEND_SUCCESS;
                              resendMsg.timestamp  = [[dic objectForKey:@"timestamp"] longLongValue]*1000;
                              
                              
                          }else{
                              
                              // 发送失败
                              resendMsg.msg_state = MSG_SEND_FAIL;
                              resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                              
                              
                          }
                          // 更新msgid对应数组的索引字典
                          [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序update 2015.08.12
                          [chatTableview reloadData];
                          [resendMsg updateToDB];
                          [self saveMsgToChatList:resendMsg];
                          //                        // 更新msgid对应数组的索引字典
                          //                        [self reloadMsgIndexDictionaryAndMsgLabel];
                          //                        [chatTableview reloadData];
                          [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                          isScrollToBottom = YES;//add 2015.09.01
                          
                      } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                          
                          [Utilities doHandleTSNetworkingErr:error descView:self.view];
                          
                          resendMsg.msg_state = MSG_SEND_FAIL;
                          resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                          // 更新msgid对应数组的索引字典
                          [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序update 2015.08.12
                          [chatTableview reloadData];
                          [resendMsg updateToDB];
                          [self saveMsgToChatList:resendMsg];
                          //                        // 更新msgid对应数组的索引字典
                          //                        [self reloadMsgIndexDictionaryAndMsgLabel];
                          //                        [chatTableview reloadData];
                          [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                          
                      }];
                  }
                
                
                
            } else if (1 == buttonIndex) {
                // 删除消息
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"0heightArrayCount:%lu",(unsigned long)[heightArray count]);
                    // 耗时的操作
                    BOOL bDeleteMsg = [self deleteChatMessage:resendMsg.msg_id];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (bDeleteMsg) {
                            
                            // 更新聊天数据后刷新画面
                            NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", resendMsg.msg_id]];
                            if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                                
                                [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
                                [heightArray removeObjectAtIndex:[indexOfMsg intValue]];//2015.07.25
                                // 更新msgid对应数组的索引字典
                                [self reloadMsgIndexDictionaryAndMsgLabel];
                                
                                // 将之前的数据reflashFlag置为0
                                for (int i = 0; i<[chatDetailArray count]; i++) {
                                    
                                    MixChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
                                    entity.reflashFlag = @"0";
                                    [chatDetailArray replaceObjectAtIndex:i withObject:entity];
                                }
                                
                                [chatTableview reloadData];
                                
                                [self deleteChatFile:resendMsg];
                                MixChatDetailObject *chatDetail = [chatDetailArray lastObject];
                                _groupChatList.last_msg = chatDetail.msg_content;
                                [_groupChatList updateToDB];
                                
                            }
                        } else {
                            // 删除失败提示
                            [Utilities showTextHud:@"删除消息失败！" descView:self.view];
                        }
                    });
                });
            }
        } else if (TAG_ACTIONSHEET_PHOTO == actionSheet.tag) {
            if (0 == buttonIndex) {
                //[self actionUseCamera];
                [Utilities takePhotoFromViewController:self];//update by kate 2015.04.17
            } else if (1 == buttonIndex) {
                [self actionOpenPhotoLibrary];
            }
        }
    }
    @catch (NSException *exception) {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromSelector(_cmd),[NSNumber numberWithInt:0],exception,[NSNumber numberWithInt:1],nil];
        dispatch_async(dispatch_get_main_queue(), ^{ @autoreleasepool {[[NSNotificationCenter defaultCenter] postNotificationName:PROGRAM_ERROR object:dictionary];}});
    }
    @finally {
        //
    }
}
#endif

// 删除的回调方法
-(void)deleteMsg:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    MixChatDetailObject *deleteMsg;
    
    if ([notification.object isKindOfClass:[MixChatDetailObject class]]) {
        
        deleteMsg = (MixChatDetailObject*)notification.object;
        
    }else{
        
        deleteMsg = [dic objectForKey:@"object"];
        
    }
    NSLog(@"lastObjecttimestamp:%lld",deleteMsg.timestamp);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 耗时的操作
        BOOL bDeleteMsg = [self deleteChatMessage:deleteMsg.msg_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bDeleteMsg) {
                
                isDelete = YES;
                // 更新聊天数据后刷新画面
                NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", deleteMsg.msg_id]];
                if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                    
                    [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
                    [heightArray removeObjectAtIndex:[indexOfMsg intValue]];//2015.07.25
                    // 更新msgid对应数组的索引字典
                    [self reloadMsgIndexDictionaryAndMsgLabel];
                    
                    // 将之前的数据reflashFlag置为0
                    for (int i = 0; i<[chatDetailArray count]; i++) {
                        
                        MixChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
                        entity.reflashFlag = @"0";
                        [chatDetailArray replaceObjectAtIndex:i withObject:entity];
                    }
                    
                    if (deleteMsg.msg_type == MSG_TYPE_Audio) {
                        
                        if ([[dic objectForKey:@"index"] integerValue] == numOfCellAudioPlaying) {
                            numOfCellAudioPlaying = -1;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground"
                                                                                object:nil];
                        }
                        
                    }
                    
                    [chatTableview reloadData];
                    
                    [self deleteChatFile:deleteMsg];
                    
                    if ([chatDetailArray count] == 0) {
                        
                        _groupChatList.timestamp = deleteMsg.timestamp;
                        _groupChatList.last_msg = @"";
                        [_groupChatList updateToDB];
                        
                    }else{
                        
                        MixChatDetailObject *chatDetail = [chatDetailArray lastObject];
                        _groupChatList.is_recieved = chatDetail.is_recieved;
                        _groupChatList.last_msg = chatDetail.msg_content;
                        [_groupChatList updateToDB];
                        
                    }
                    
                }
            } else {
                // 删除失败提示
                [Utilities showTextHud:@"删除消息失败！" descView:self.view];
            }
        });
    });
    
}

// 转发
-(void)transpondMsg:(NSNotification*)notification{
    
    MixChatDetailObject *entity = (MixChatDetailObject*)[notification object];//这条聊天消息包含的详细信息
    // To beck:转发列表入口
    
    TranspondViewController *transV = [[TranspondViewController alloc]init];
    transV.entity = entity;
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:transV];
    SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:transV];
    [self presentViewController:nav animated:YES completion:nil];
    
}

// 收消息通知
-(void)getChatData:(NSNotification*)notify{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isReload = NO;
        
        NSMutableArray *tempArray = (NSMutableArray*)[notify object];
        if ([tempArray count] > 0) {
            
            for (int i =0; i<[tempArray count]; i++) {
                
                MixChatDetailObject *chatDetail = [tempArray objectAtIndex:i];
                
                if (chatDetail.groupid == gid) {
                    
                    isReload = YES;
                    chatDetail.reflashFlag = @"0";
                    if (chatDetail.msg_type == MSG_TYPE_TEXT) {
                        chatDetail.size = [MsgTextView heightForEmojiText:chatDetail.msg_content];
                    }
                    
                    // 更新聊天数据后刷新画面
                    float height = [self getCellHeight:chatDetail];
                    NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
                    if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                        [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:chatDetail];
                        [heightArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:[NSString stringWithFormat:@"%f",height]];
                    } else {
                        [chatDetailArray addObject:chatDetail];
                        [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
                        [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
                    }
                    
                    [self setChatDetailObjectTimeLabel:chatDetail];
                    
                }
                
            }
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isReload) {
                [chatTableview reloadData];
                [self scrollTableViewToBottom];
            }
            
        });
        
        
    });
    
}

// 从列表页进入获取所有聊天消息 update 2015.09.08
- (void)getChatDetailData
{
    inputBar.hidden = NO;
//    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoMix_%lli_%lli", gid,user.user_id];
//    
//    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
//    if (iCnt > 0) {
//        
//        // 分页显示sql文
//        NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoMix_%lli_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", gid, user.user_id, 0, TABLE_SHOWING_COUNT];
//        // 查询SQL文
//        //        NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC", gid];
//        //执行SQL
//        NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
//        [self updataChatDetailArray:retDictionary];
//        
//        [chatTableview reloadData];// update 2015.07.07
//    }
//    
//    if (!isMoreDataLoading && isScrollToBottom) {//2015.08.27
//        [self scrollTableViewToBottom];
//    }
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoMix_%lli_%lli", gid,user.user_id];
    NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoMix_%lli_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", gid, user.user_id, 0, TABLE_SHOWING_COUNT];
    
    if(gid == 0){
        long long sid;
        if (_sid) {
            sid = [_sid longLongValue];
        }else{
            sid = _groupChatList.schoolID;
        }
        
        sql = [NSString stringWithFormat:@"select count(*) from msgInfoMix_%lli_%lli where schoolID = %lli", gid,user.user_id,sid];
        getDataSql = [NSString stringWithFormat:@"select * from msgInfoMix_%lli_%lli where schoolID = %lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", gid, user.user_id,sid, 0, TABLE_SHOWING_COUNT];
        
    }
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    
    if (iCnt > 0) {
        //执行SQL
        NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
        [self updataChatDetailArray:retDictionary];
        //[chatTableview reloadData];// update 2015.07.07
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
    }
    
    if (!isMoreDataLoading && isScrollToBottom) {//2015.08.27
        [self scrollTableViewToBottom];
    }
    
}

- (void)updateCellWithEntity:(MsgDetailCell *)cell entity:(MixChatDetailObject *)entity updateState:(BOOL)updateState
{
    cell.msgType = CELL_TYPE_TEXT;
    
    if (entity.msg_type == MSG_TYPE_PIC) {
        cell.msgType = CELL_TYPE_PIC;
    }else if (entity.msg_type == MSG_TYPE_Audio){
        cell.msgType = CELL_TYPE_AUDIO;
        cell.audioView.numOfCellAudioPlaying = numOfCellAudioPlaying;
        
        if([cell.index integerValue] == numOfCellAudioPlaying){//add 2015.10.15
            
            if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
                
                if (isDownloaded || entity.audio_r_status!=1) {
                    if (cell.audioView.isStart) {//解决 在播放语音的中时收到新消息 播放动画不消失问题
                        cell.audioView.isStart = YES;
                       
                    }else{
                        cell.audioView.isStart = NO;
                       
                    }
                    
                }else{
                    cell.audioView.isStart = YES;
                   
                }
                
            }else{
                if (cell.audioView.isStart) {//解决 在播放语音的中时收到新消息 播放动画不消失问题
                    cell.audioView.isStart = YES;
                }else{
                    cell.audioView.isStart = NO;
                }
                
            }
            
        }else{
            
            if (cell.audioView.isStart) {//解决 在播放语音的中时收到新消息 播放动画不消失问题
                cell.audioView.isStart = YES;
            }else{
                
                if (cell.audioView.animationImageView.isAnimating) {
                    cell.audioView.isStart = YES;
                     NSLog(@"444");
                }else{
                  cell.audioView.isStart = NO;
                     NSLog(@"333");
                }
                
               
            }
            
        }
        
    }else if (entity.msg_type == 3){
        cell.msgType = CELL_TYPE_System;
    }else if (entity.msg_type == 4){
        cell.msgType = CELL_TYPE_Remove;
    }else if (entity.msg_type == 5){
        cell.msgType = CELL_TYPE_Leave;
    }
    
    [cell updataCellForMix:entity updateState:updateState];
    
    GlobalSingletonUserInfo* userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;;
    NSDictionary *message_info = [userInfo getUserDetailInfo];
    //NSString* userid = [message_info objectForKey:@"uid"];
    NSString *myHeadUrl = [message_info objectForKey:@"avatar"];
    //[cell setSelfHeadImage:myUserID];
    //    NSLog(@"*************************************");
    //    NSLog(@"index:%@ myHeadUrl:%@",cell.index,myHeadUrl);
    //    NSLog(@"**************************************");
    
    [cell setUserHeadImage:entity.headimgurl];
    [cell setSelfHeadImage:myHeadUrl];
    
    long long timestamp = entity.timestamp;
    timestamp = timestamp/1000.0;
    
    cell.timeLabel.text = [Utilities timeIntervalToDate:timestamp timeType:1 compareWithToday:YES];
    
    if (entity.showTimeLabel) {
        cell.timeLabel.alpha = 1;
    } else {
        cell.timeLabel.alpha = 0;
    }
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        if (entity.groupid == 0) {
            cell.nameLabel.alpha = 0;
        }else{
            
//---2017.02.28-----------------------------
            if ((entity.schoolID != [G_SCHOOL_ID longLongValue]) && [entity.schoolName length]!=0) {
               cell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",entity.userName,entity.schoolName];
            }else{
              cell.nameLabel.text = entity.userName;
            }
            //-----------------------------
#if 0
       cell.nameLabel.text = entity.userName;
#endif
           
            cell.nameLabel.alpha = 1;
        }
        
    }else{
        cell.nameLabel.alpha = 0;
    }
    
}

- (float)getCellHeight:(MixChatDetailObject*)entity
{
    float cellHeight = 0;
    if (entity.msg_type == MSG_TYPE_PIC) {
        cellHeight = [self getPicMessageHeight:entity];
    }else{
        if (cellHeight == 0){
            cellHeight = [self getTextMessageHeight:entity];
        }
    }
    
    //头像的高度是47，所以cell的高度必须满足大于等于47
    if(cellHeight < 47){
        cellHeight = 47;
    }
    
    if (entity.msg_type == 3 || entity.msg_type == 4 || entity.msg_type == 5) {
        
        cellHeight =  [self getSystemMessageHeight:entity];
    }
    
    return cellHeight;
}

// 获取图片信息高度
- (float)getPicMessageHeight:(MixChatDetailObject*)entity
{
    float height = 0;
    
    NSString *imagePath = @"";
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 此路径保存缩略图
        NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];// 可能要改
        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
        imagePath = thumbImagePath;
    }else{
        
        // 此路径保存缩略图
        NSString *originalImageDir = [Utilities getChatPicThumbDir:entity.user_id];// 可能要改
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id,FILE_JPG_EXTENSION];
        imagePath = originalImagePath;
    }
    
    UIImage *showImage = [UIImage imageWithContentsOfFile:imagePath];
    
    if(!showImage){
        //showImage = [UIImage imageNamed:@"reciveDefaultImg.png"];
        if (entity.msg_state == MSG_RECEIVED_SUCCESS) {
            showImage = [UIImage imageNamed:@"reciveDefaultImg.png"];//update 2015.07.16
        }else{
            showImage = [UIImage imageNamed:@"reciveNoMsgImg.png"];//update 2015.07.16
        }
        
    }
    
    CGFloat destW = 120;
    CGFloat destH = 120;
    CGFloat sourceW = showImage.size.width;
    CGFloat sourceH = showImage.size.height;
    
    CGSize imageSize;
    if ((sourceW <= destW)&&(sourceH <= destH)) { // 图片小于显示区域，不进行缩小，直接显示
        destW = sourceW;
        destH = sourceH;
        imageSize = CGSizeMake(destW, destH);
    } else {
        CGFloat ratio1 = destW/sourceW;
        CGFloat ratio2 = destH/sourceH;
        CGFloat ratio;
        if (ratio1 <= ratio2) {
            ratio = ratio1;
            imageSize = CGSizeMake(destW, sourceH * ratio);
        } else {
            ratio = ratio2;
            imageSize = CGSizeMake(sourceW * ratio, destH);
        }
    }
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE){
        height = imageSize.height + 4.0 + 15.0;//update 2015.07.17
    }else{
        
        height = imageSize.height + 20 + 10;//update 2015.07.17
        
    }
    
    return height;
}

// 获取文本信息高度
- (float)getTextMessageHeight:(MixChatDetailObject*)entity
{
    float height = 0;
    // update 2015.08.01
    //    MsgTextView *textView = [[MsgTextView alloc] init];
    //    height = [textView getTextHeightForGroup:entity] + 20;
    
    height = [MsgTextView heightForEmojiText:entity.msg_content].height+5.0f*2;
    
    return height;
}

// 获取文本信息高度
- (float)getSystemMessageHeight:(MixChatDetailObject*)entity
{
    float height = 0;
    
    height = [MsgSystemView getHeightForMix:entity];
    
    return height;
}

- (void)setChatDetailObjectTimeLabel:(MixChatDetailObject *)entity
{
    
    NSTimeInterval betweenTime = 0;
    long long timestamp = entity.timestamp;
    timestamp = timestamp/1000.0;
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    if (nil != self.currentShowTime) {
        betweenTime = [curDate timeIntervalSinceDate:self.currentShowTime];
    }
    if (currentShowTime == nil) {
        entity.showTimeLabel = YES;
        self.currentShowTime = curDate;
    } else {
        if (betweenTime != 0 && (betweenTime <= -MESSAGE_TIME_CLEARANCE || betweenTime >= MESSAGE_TIME_CLEARANCE)) { // 2分钟
            entity.showTimeLabel = YES;
            self.currentShowTime = curDate;
        } else {
            entity.showTimeLabel = NO;
        }
    }
}

// TableView 滚动到底部显示最后的聊天消息
- (void)scrollTableViewToBottom
{
    NSInteger sections = [chatTableview numberOfSections];
    if (sections < 1) return;
    NSInteger rows = [chatTableview numberOfRowsInSection:sections - 1];
    if (rows < 1) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows - 1 inSection:sections - 1];
    [chatTableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    tableOffset = chatTableview.contentOffset.y;
    isScrollToBottom = YES;
    
}

// 2015.08.27
- (void)needShowMoreByRowID
{
    //NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli", gid];
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoMix_%lli_%lli", gid,user.user_id];
    
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    
    if (iCnt > [chatDetailArray count]) {
        
        UIView *waitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 25)];
        waitView.backgroundColor = [UIColor clearColor];
        
        [waitForLoadMore startAnimating];
        [waitView addSubview:waitForLoadMore];
        
        chatTableview.tableHeaderView = waitView;
        
        isMoreDataLoading = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self getMoreChatInfofrom:[chatDetailArray count]];
            
            [self reloadMsgIndexDictionaryAndMsgLabel];
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
            if (earliestRowID == 0) {
                
            }else{
                
                //NSLog(@"earliestRowID:%d",earliestRowID);
                // 滚动到之前的位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:earliestRowID -1 inSection:0];
                CGRect showRect = [chatTableview rectForRowAtIndexPath:indexPath];
                showRect.origin.y = showRect.origin.y + 325;
                [chatTableview scrollRectToVisible:showRect animated:NO];
                
                tableOffset = chatTableview.contentOffset.y;
                
            }
            
            [waitForLoadMore stopAnimating];
            [waitForLoadMore removeFromSuperview];
            chatTableview.tableHeaderView = nil;
            isMoreDataLoading = NO;
            
            //earliestRowID = 0;
            
        });
        
    }else {
        chatTableview.tableHeaderView = nil;
    }
}

// 2015.08.27
-(void)getMoreChatInfofrom:(NSInteger)chatArrayCount{
    
    long long msg_id = -1;
    
    if (numOfCellAudioPlaying > 0 && numOfCellAudioPlaying < [chatDetailArray count]) {
        MixChatDetailObject *cdo = (MixChatDetailObject*)[chatDetailArray objectAtIndex:numOfCellAudioPlaying];
        msg_id = cdo.msg_id;
    }
    
    // 分页显示sql文
    NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoMix_%lli_%lli ORDER BY timestamp DESC limit %ld, %d", gid, user.user_id,(long)chatArrayCount, TABLE_SHOWING_COUNT];
    
    if(gid == 0){
        long long sid;
        if (_sid) {
            sid = [_sid longLongValue];
        }else{
            sid = _groupChatList.schoolID;
        }
        
        getDataSql = [NSString stringWithFormat:@"select * from msgInfoMix_%lli_%lli where schoolID = %lli ORDER BY timestamp DESC, msg_id DESC limit %ld, %d", gid, user.user_id,sid, (long)chatArrayCount, TABLE_SHOWING_COUNT];
        
    }
    
    //执行SQL
    NSMutableDictionary *dictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
    
    if ([dictionary.allKeys count] < 20) {
        earliestRowID = [dictionary.allKeys count];
    }
    
    for (int listCnt = 0; listCnt < [dictionary.allKeys count]; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        MixChatDetailObject *ChatDetail = [[MixChatDetailObject alloc] init];
        ChatDetail.groupid = gid;
        ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"] intValue];
        ChatDetail.msg_id = [[chatObjectDict objectForKey:@"msg_id"] longLongValue];
        ChatDetail.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        ChatDetail.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        ChatDetail.msg_type = [[chatObjectDict objectForKey:@"msg_type"] intValue];
        ChatDetail.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        ChatDetail.msg_content = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]];
        ChatDetail.msg_file = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_file"]];
        ChatDetail.pic_url_thumb = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_thumb"]];
        ChatDetail.pic_url_original = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_original"]];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        ChatDetail.headimgurl = [Utilities replaceNull:[chatObjectDict objectForKey:@"headimgurl"]];
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];//add 2015.07.07
        ChatDetail.reflashFlag = @"0";
        
        NSString *tempAudioState = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"msg_state_audio"]]];
        if ([tempAudioState length] == 0) {
            ChatDetail.msg_state_audio = 0;
        }else{
            ChatDetail.msg_state_audio = [[chatObjectDict objectForKey:@"msg_state_audio"] intValue];
            
        }
        
        if (ChatDetail.msg_type == MSG_TYPE_TEXT) {
            ChatDetail.size = [MsgTextView heightForEmojiText:[Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]]];
        }
        
        ChatDetail.userName = [Utilities replaceNull:[chatObjectDict objectForKey:@"userName"]];
        
        //------更新接收语音状态---------------------------------------------------------------------------------------------
        long long key = ChatDetail.user_id;
        if (ChatDetail.is_recieved == MSG_IO_FLG_SEND) {
            if (ChatDetail.user_id == 0) {
                key = uid;
            }
        }
        
        NSString *audioDir = [Utilities getChatAudioDir:key];
        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, ChatDetail.msg_id, FILE_AMR_EXTENSION];
        
        NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
        if (fileData == nil || [fileData length] == 0) {
            
        }else{
            
            ChatDetail.audio_r_status = 1;
            [ChatDetail updateRAudioState];
        }
        
        
        ChatDetail.audio_r_status =  [[Utilities replaceNull:[chatObjectDict objectForKey:@"audio_r_status"]] intValue];
        //------------------------------------------------------------------------------------------------------------------
        
        ChatDetail.schoolName = [Utilities replaceNull:[chatObjectDict objectForKey:@"schoolName"]];
        ChatDetail.schoolID = [[chatObjectDict objectForKey:@"schoolID"] longLongValue];
        ChatDetail.uid = [[chatObjectDict objectForKey:@"uid"] longLongValue];
        
        if (gid == 0){
            
            if (ChatDetail.uid == uid){
                
                // 更新聊天数据后刷新画面
                NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
                if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                    [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
                    [self setChatDetailObjectTimeLabel:ChatDetail];
                    
                    float height = [self getCellHeight:ChatDetail];
                    [heightArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:[NSString stringWithFormat:@"%f",height]];
                    
                    
                } else {
                    [chatDetailArray insertObject:ChatDetail atIndex:0];
                    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
                    [self setChatDetailObjectTimeLabel:ChatDetail];
                    
                    float height = [self getCellHeight:ChatDetail];
                    [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
                    
                }
                
            }
            
        }else{
           
            // 更新聊天数据后刷新画面
            NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
            if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
                [self setChatDetailObjectTimeLabel:ChatDetail];
                
                float height = [self getCellHeight:ChatDetail];
                [heightArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:[NSString stringWithFormat:@"%f",height]];
                
                
            } else {
                [chatDetailArray insertObject:ChatDetail atIndex:0];
                [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
                [self setChatDetailObjectTimeLabel:ChatDetail];
                
                float height = [self getCellHeight:ChatDetail];
                [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
                
            }
            
        }
        //        [self setChatDetailObjectTimeLabel:ChatDetail];
        //
        //        float height = [self getCellHeight:ChatDetail];
        //        [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
        
    }
    
    // 将之前的数据reflashFlag置为0
    for (int i = 0; i<[chatDetailArray count]; i++) {
        
        MixChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
        entity.reflashFlag = @"0";
        [chatDetailArray replaceObjectAtIndex:i withObject:entity];
        
        if (entity.msg_id == msg_id) {
            numOfCellAudioPlaying = i;
        }
    }
    
}

// 2015.08.27
-(void)reload{
    
    [chatTableview reloadData];
}

- (void)createChatSelectTool
{
    //聊天方式选择工具条
    if (!selectTool) {
        selectTool = [[MsgTypeSelectTool alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 216) withController:self];
    }
}

// 输入框
- (void)showInputBar
{
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR, [[UIScreen mainScreen] bounds].size.width, HEIGHT_INPUT_BAR)];
    inputBar.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1];
    // 输入框
    //inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(54, 8, 216, 36)];
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(80.0, (HEIGHT_INPUT_BAR-33.0)/2.0, winSize.width - 60 - 33 - 38, 33.0)];
    //inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    inputTextView.minNumberOfLines = 1;
    inputTextView.maxNumberOfLines = 3;
    inputTextView.returnKeyType = UIReturnKeyDefault;
    inputTextView.font = [UIFont systemFontOfSize:16.0f];
    inputTextView.delegate = self;
    inputTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    inputTextView.backgroundColor = [UIColor clearColor];
    inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inputTextView.internalTextView.backgroundColor = [UIColor clearColor];
    normalKeyboard = inputTextView.internalTextView.inputView;
    showSelectTool = NO;
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    //entryImageView.frame = CGRectMake(53, 5, 214, HEIGHT_INPUT_BAR_BUTTON);
    //entryImageView.frame = CGRectMake(53, 5, winSize.width - 54 - 5 - 3, HEIGHT_INPUT_BAR_BUTTON);
    //entryImageView.frame = CGRectMake(33+5+5+33+1, 5, winSize.width - 54 - 5 - 3 -50-10, 42);
    entryImageView.frame = CGRectMake(80.0, (HEIGHT_INPUT_BAR-34.0)/2.0, winSize.width - 60 - 33 - 37, 33.0);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard:)];
    singleTouch.delegate = self;
    [inputTextView addGestureRecognizer:singleTouch];
    //[singleTouch release];
    
    [inputBar addSubview:entryImageView];
    [inputBar addSubview:inputTextView];
    
    UIImage *rawBackground = [UIImage imageNamed:@"lineSystem.png"];
    entryBackgroundImageView = [[UIImageView alloc] initWithImage:rawBackground];
    entryBackgroundImageView.frame = CGRectMake(0, inputBar.frame.size.height-1, inputBar.frame.size.width, 1);
    entryBackgroundImageView.userInteractionEnabled = YES;
    [inputBar addSubview:entryBackgroundImageView];
    
    
    // 图片按钮
    actionBtnText = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtnText.frame = CGRectMake(40.0, (HEIGHT_INPUT_BAR-33.0)/2.0, 33, 33);
    actionBtnText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [actionBtnText addTarget:self action:@selector(changeToKeyboardTool) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:actionBtnText];
    
    //  语音图标小按钮
    AudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioBtn.frame = CGRectMake(WIDTH-33-5-3, (HEIGHT_INPUT_BAR-33.0)/2.0, 33, 33);
    AudioBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [AudioBtn addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:AudioBtn];
    
    // 表情按钮
    keyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardBtn.frame = CGRectMake(5, (HEIGHT_INPUT_BAR-33.0)/2.0, 33, 33);
    keyboardBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [keyboardBtn addTarget:self action:@selector(changeKeyboardType) forControlEvents:UIControlEventTouchUpInside];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_d.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_p.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:keyboardBtn];
    
    // 初始化audio lib
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    //点击录制语音
    audioButn = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButn.frame = CGRectMake(3, (HEIGHT_INPUT_BAR-33.0)/2.0, WIDTH-44, 33.0);
    audioButn.tag = 126;
    [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_d.png"]
                         forState:UIControlStateNormal];
    [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_armBg_p.png"]
                         forState:UIControlStateHighlighted];
    [audioButn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [audioButn addTarget:self action:@selector(recordEnd:) forControlEvents:UIControlEventTouchUpInside];
    [audioButn addTarget:self action:@selector(recordEndOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [audioButn addTarget:self action:@selector(recordDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [audioButn addTarget:self action:@selector(recordDragIn:) forControlEvents:UIControlEventTouchDragEnter];
    
    audioButn.hidden = YES;
    [inputBar addSubview:audioButn];
    
    if ( !faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = MAX_TEXTLENGTH;// 2015.07.21
        faceBoard.inputTextView = inputTextView;
    }
    
    keyboardButtonType = BTN_KEYBOARD;
    
    [self.view addSubview:inputBar];
    [self.view bringSubviewToFront:inputBar];
}

/*
 *按住开始录音
 *最长录制一分钟，有倒计时
 */
-(void)recordStart:(id)sender{
    
    [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    if (![Utilities canRecord]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
        return;
    }else {
        isRecording = YES;
        
        [recordAudio stopPlay];
        [recordAudio startRecord];
        startRecordTime = [NSDate timeIntervalSinceReferenceDate];
        
        // 倒计时开始，60秒后自动停止
        secondsCountDown = 60;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        curAudio=nil;
    }
}

/*
 * 松开手录音结束并发送
 */
-(void)recordEnd:(id)sender{
    if (isRecording) {
        
        [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
        [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];
        
        isRecording = NO;
        [countDownTimer invalidate];
        
        NSURL *url = [recordAudio stopRecord];
        
        endRecordTime = [NSDate timeIntervalSinceReferenceDate];
        endRecordTime -= startRecordTime;
        
        recordSec = endRecordTime;
        
        NSInteger time = 59;
        if (secondsCountDown > time) {
            [Utilities showFailedHud:@"时间太短，请重试。" descView:self.view];
        }else {
            if (url != nil) {
                curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
                if (curAudio) {
                    //NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                    //if (nil != amrDocPath) {
                    
                    [self createAudioMessage:curAudio];
                    
                    //audioButn.hidden = YES;
                    
                    //-----------------------------------------------------------
                    //}
                }
            }
        }
        
        if (curAudio.length >0) {
            
        } else {
            
        }
    }
}

-(void)recordEndOutside:(id)sender{
    [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    isRecording = NO;
    [countDownTimer invalidate];
    
    [recordAudio stopRecord];
}

-(void)recordDragExit:(id)sender{
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateNormal];
    [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];
}

-(void)recordDragIn:(id)sender{
    [audioButn setTitle:@"松开结束" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
}

- (void)timeFireMethod
{
    secondsCountDown--;
    
    if(secondsCountDown==0){
        NSURL *url = [recordAudio stopRecord];
        isRecording = NO;
        
        if (url != nil) {
            curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
            if (curAudio) {
                //NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
                //if (nil != amrDocPath) {
                // amrPath = [amrDocPath stringByAppendingPathComponent:@"weixiao_amr.amr"];
                // [curAudio writeToFile: amrPath atomically: NO];
                
                endRecordTime = [NSDate timeIntervalSinceReferenceDate];
                endRecordTime -= startRecordTime;
                
                recordSec = endRecordTime;
                
                [self createAudioMessage:curAudio];//60秒停止时发送语音 2015.11.13
                
                //  }
            }
        }
        [countDownTimer invalidate];
    }
}

// 点击输入框上的“+”出现多功能view，点击回调方法
- (void)changeChatTool:(int)chatMode
{
    switch (chatMode) {
        case ChatSelectTool_Pic:{
            isReGetChatDetailData = NO;
            [self actionOpenPhotoLibrary];
        }
            break;
        case ChatSelectTool_Camera:{
            isReGetChatDetailData = NO;
            [Utilities takePhotoFromViewController:self];//update by kate 2015.04.17
            
        }
            break;
        default:
            break;
    }
}

// 点击语音按钮
-(void)AudioClick:(id)sender{
    
    UIImage *image = [UIImage imageNamed:@"btn_yy_p.png"];
    //    if (AudioBtn.imageView.image == image) {
    if ([Utilities image:AudioBtn.imageView.image equalsTo:image]) {
        audioButn.hidden = NO;
        [AudioBtn setImage:[UIImage imageNamed:@"btn_sr_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"btn_sr_p.png"] forState:UIControlStateHighlighted];
        keyboardButtonType = BTN_KEYBOARD;
        
        [inputTextView resignFirstResponder];
        
        
    }else{
        
        audioButn.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"btn_sr_p.png"];
        //        if (AudioBtn.imageView.image == image) {
        if ([Utilities image:AudioBtn.imageView.image equalsTo:image]) {
            [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
            [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
            [inputTextView becomeFirstResponder];
            isActionStart = NO;
        }else{
          
            [self sendTextMsg];
            [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
            [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
            //[inputTextView resignFirstResponder];
            
        }
        
    }
    
}

// 打开照相机
- (void)actionUseCamera
{
    if (nil == imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    isActionStart = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"打开照相机");
    }];
}

// 打开相册
- (void)actionOpenPhotoLibrary
{
    if (nil == imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    isActionStart = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"打开相册");
    }];
}

// 初始化图片选取器
- (void)initImagePicker
{
    if (nil == imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
}

// 隐藏键盘
- (void)dismissKeyboard
{
    showSelectTool = NO;
    [inputTextView resignFirstResponder];
    [self changeToKeyboardText];
}

// 点击表情
- (void)changeKeyboardType
{
    if (isActionStart) { //打开相机，相册时不响应点击消息事件
        return;
    }
    
    [inputTextView resignFirstResponder];
    
    if (keyboardButtonType == BTN_KEYBOARD){
        keyboardButtonType = BTN_EMOTICOM;
        [self changeToKeyboardEmotion];
        
    } else {
        keyboardButtonType = BTN_KEYBOARD;
        [self changeToKeyboardText];
        //[self changeToKeyboardTool];
    }
    [inputTextView becomeFirstResponder];
}

//变成表情键盘
- (void)changeToKeyboardEmotion
{
    inputTextView.alpha = 1;
    entryImageView.alpha = 1;
    
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_sr_d.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_sr_p.png"] forState:UIControlStateHighlighted];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
    inputTextView.internalTextView.inputView = faceBoard;
    showSelectTool = YES;
}

//变成文字输入模式
- (void)changeToKeyboardText
{
    inputTextView.alpha = 1;
    entryImageView.alpha = 1;
    
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_d.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_p.png"] forState:UIControlStateHighlighted];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
    inputTextView.internalTextView.inputView = normalKeyboard;
    showSelectTool = NO;
}

//变成工具输入模式
- (void)changeToKeyboardTool
{
    if (isActionStart) { //打开相机，相册，录制语音中不响应点击消息事件
        return;
    }
    
    
    //[self selectPicConfirm];
    
    if (showSelectTool) {
        showSelectTool = NO;
        //[self changeToKeyboardText];
    }
    //else {
    inputTextView.text = @"";
    inputTextView.alpha = 1;
    entryImageView.alpha = 1;
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_d.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_p.png"] forState:UIControlStateHighlighted];
    keyboardButtonType = BTN_KEYBOARD;
    AudioBtn.frame = CGRectMake(WIDTH-33-5-3,AudioBtn.frame.origin.y, 33, 33);;
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    
    [inputTextView resignFirstResponder];
    
    //"+"号
    if (inputTextView.internalTextView.inputView == selectTool) {
        
        [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
        [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
        
        inputTextView.internalTextView.inputView = normalKeyboard;
        showSelectTool = NO;
        
    }else{
        
        [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_sr_d.png"] forState:UIControlStateNormal];
        [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_sr_p.png"] forState:UIControlStateHighlighted];
        
        inputTextView.internalTextView.inputView = selectTool;
        showSelectTool = YES;
        
        
        
    }
    
    [inputTextView becomeFirstResponder];
    
    //}
}

- (void)textViewDidChange:(UITextView *)_textView {
    
    if ([_textView.text length] > 0) {
        
        AudioBtn.frame = CGRectMake(WIDTH-40-2, AudioBtn.frame.origin.y, 40, 33);
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_p.png"] forState:UIControlStateHighlighted];
    }else{
        
        AudioBtn.frame = CGRectMake(WIDTH-33-5, AudioBtn.frame.origin.y, 33, 33);;
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    }
    
}

// 发送消息
- (void)sendTextMsg
{
    if (inputTextView.text.length == 0) {
        return;
    }
    
    // 去掉消息最后的换行
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    inputTextView.text = [inputTextView.text stringByTrimmingCharactersInSet:charSet];
    NSString *inputMsg = inputTextView.text;
    
    if (0 == [inputMsg length]) { // 没输入任何内容时不发送消息
        inputTextView.text = nil;
        return;
    }
    
    [self createTextMessage:inputMsg];
    inputTextView.text = nil;
}

- (void)updataChatDetailArray:(NSDictionary*)dictionary
{
    //    if (!isMoreDataLoading && isScrollToBottom){//2015.09.08
    //        [heightArray removeAllObjects];
    //    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:chatDetailArray];
    
    earliestRowID = [dictionary.allKeys count];
    
    for (int listCnt = [dictionary.allKeys count] - 1; listCnt >= 0; listCnt--) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        MixChatDetailObject *ChatDetail = [[MixChatDetailObject alloc] init];
        ChatDetail.groupid = gid;//表里没存
        ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"] intValue];
        ChatDetail.msg_id = [[chatObjectDict objectForKey:@"msg_id"] longLongValue];
        ChatDetail.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        ChatDetail.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        ChatDetail.msg_type = [[chatObjectDict objectForKey:@"msg_type"] intValue];
        ChatDetail.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        NSString *tempAudioState = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"msg_state_audio"]]];
        if ([tempAudioState length] == 0) {
            ChatDetail.msg_state_audio = 0;
        }else{
            ChatDetail.msg_state_audio = [[chatObjectDict objectForKey:@"msg_state_audio"] intValue];
            
        }
        ChatDetail.msg_content = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]];
        ChatDetail.msg_file = [Utilities replaceNull:[chatObjectDict objectForKey:@"msg_file"]];
        ChatDetail.pic_url_thumb = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_thumb"]];
        ChatDetail.pic_url_original = [Utilities replaceNull:[chatObjectDict objectForKey:@"pic_url_original"]];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        ChatDetail.headimgurl = [Utilities replaceNull:[chatObjectDict objectForKey:@"headimgurl"]];
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];//add 2015.07.07
        ChatDetail.audio_url = [Utilities replaceNull:[chatObjectDict objectForKey:@"audio_url"]];
        ChatDetail.reflashFlag = @"0";
        
        if (ChatDetail.msg_type == MSG_TYPE_TEXT) {
            ChatDetail.size = [MsgTextView heightForEmojiText:[Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]]];
        }
        
        //NSLog(@"is_recieved:%ld",(long)ChatDetail.is_recieved);
        //        NSString *newStr = [ChatDetail.msg_content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        //        ChatDetail.msg_content = newStr;
        
        ChatDetail.userName = [Utilities replaceNull:[chatObjectDict objectForKey:@"userName"]];
        
        // 更新聊天数据后刷新画面
        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
        /*if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
         [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
         } else {
         [chatDetailArray addObject:ChatDetail];
         [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
         }
         [self setChatDetailObjectTimeLabel:ChatDetail];
         
         //---add 2015.07.25----------------------------------------------
         float height = [self getCellHeight:ChatDetail];
         [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
         //-----------------------------------------------------------------*/
        
        ChatDetail.msg_content = [self sqliteEscape:ChatDetail.msg_content];
        
        ChatDetail.msg_content = [ChatDetail.msg_content stringByReplacingOccurrencesOfString:@"http:////" withString:@"http://"];
        
        //------更新接收语音状态---------------------------------------------------------------------------------------------
        long long key = ChatDetail.user_id;
        if (ChatDetail.is_recieved == MSG_IO_FLG_SEND) {
            if (ChatDetail.user_id == 0) {
                key = uid;
            }
        }
        
        ChatDetail.audio_r_status =  [[Utilities replaceNull:[chatObjectDict objectForKey:@"audio_r_status"]] intValue];
        
        NSString *audioDir = [Utilities getChatAudioDir:key];
        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, ChatDetail.msg_id, FILE_AMR_EXTENSION];
        
            NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
            if (fileData == nil || [fileData length] == 0) {
                
            }else{
                
                ChatDetail.audio_r_status = 1;
                [ChatDetail updateRAudioState];
            }
        
        
       
        //------------------------------------------------------------------------------------------------------------------

        ChatDetail.schoolName = [Utilities replaceNull:[chatObjectDict objectForKey:@"schoolName"]];
        ChatDetail.schoolID = [[chatObjectDict objectForKey:@"schoolID"] longLongValue];
        ChatDetail.uid = [[chatObjectDict objectForKey:@"uid"] longLongValue];

        if (gid == 0) {
            if (ChatDetail.uid == uid){
                
                // update 2015.09.08
                if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                    
                    [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
                    [self setChatDetailObjectTimeLabel:ChatDetail];
                    
                }
//                if (indexOfMsg && ([chatListArr count] > [indexOfMsg intValue])) {
//                    
//                    [chatListArr replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
//                    [self setChatDetailObjectTimeLabel:ChatDetail];
//                    
//                }
                else {
                
                    [chatDetailArray addObject:ChatDetail];
                    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
//                    [chatListArr addObject:ChatDetail];
//                    [msgIndexDic setObject:[NSNumber numberWithInt:[chatListArr count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
                    [self setChatDetailObjectTimeLabel:ChatDetail];
                    
                    //---add 2015.07.25----------------------------------------------
                    float height = [self getCellHeight:ChatDetail];
                    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
                    //-----------------------------------------------------------------
                    
                }
            }
        }else{
           
            // update 2015.09.08
            if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                
                [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
                [self setChatDetailObjectTimeLabel:ChatDetail];
                
            }
//            if (indexOfMsg && ([chatListArr count] > [indexOfMsg intValue])) {
//                
//                [chatListArr replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
//                [self setChatDetailObjectTimeLabel:ChatDetail];
//                
//            }
            else {
            
            [chatDetailArray addObject:ChatDetail];
            [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
            [self setChatDetailObjectTimeLabel:ChatDetail];
            
            //---add 2015.07.25----------------------------------------------
            float height = [self getCellHeight:ChatDetail];
            [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
            //-----------------------------------------------------------------
            }
            
        }
    }
    
    //    NSLog(@"***************************************************************");
    //    NSLog(@"chatDetailArrayCount:%lu",(unsigned long)[chatDetailArray count]);
    //    NSLog(@"heightArrayCount:%lu",[heightArray count]);
    //    NSLog(@"***************************************************************");
}

- (void)showKeyBoard:(UITapGestureRecognizer *)sender
{
    if(showSelectTool) {
        [inputTextView resignFirstResponder];
        [self changeToKeyboardText];
        keyboardButtonType = BTN_EMOTICOM;
        [inputTextView becomeFirstResponder];
        showSelectTool = NO;
    }
}

// 清空聊天记录
- (BOOL)clearChatMessage:(NSNotification*)notify
{
    NSString *tableName = [[NSString alloc] initWithFormat:@"msgInfoMix_%lli_%lli", gid,user.user_id];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from %@", tableName];
    if (gid == 0) {
        sql = [[NSString alloc] initWithFormat:@"delete from %@ where schoolID = %lli", tableName,
               _groupChatList.schoolID];
    }
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    
    if (ret) {
        
        if (self.chatDetailArray) {
            [self.chatDetailArray removeAllObjects];
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            NSString *sql = [NSString stringWithFormat:@"update msgListMix set last_msg = '%@' where uid = %lli and gid = %lli and user_id = %lli",
                             @"",
                             uid,
                             self.gid,
                             user.user_id
                             ];
            
            //---2017.02.28----------------------
            
            if (gid == 0) {
                
                sql = [NSString stringWithFormat:@"update msgListMix set last_msg = '%@' where uid = %lli and gid = %lli and user_id = %lli and schoolID = %lli",
                       @"",
                       uid,
                       gid,
                       user.user_id,
                       _groupChatList.schoolID
                       ];
                
            }
            //------------------------------------------
            
            BOOL ret = [[DBDao getDaoInstance] executeSqlNoPostNotification:sql];
            NSLog(@"ret:%d",ret);
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DB_CLEAR_CHAT_MESSAGES object:nil];
    return ret;

}

- (BOOL)deleteChatMessage:(long long)msgid
{
    NSString *tableName = [[NSString alloc] initWithFormat:@"msgInfoMix_%lli_%lli", gid,user.user_id];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from %@ where msg_id = %lli", tableName, msgid];
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    return ret;
}

//删除资源文件
- (void)deleteChatFile:(MixChatDetailObject*)object
{
    @try {
        NSFileManager *defaultMgr = [NSFileManager defaultManager];
        if (object.msg_type == MSG_TYPE_PIC) {
            
            // 此路径保存缩略图
            NSString *thumbImageDir = [Utilities getChatPicThumbDir:object.user_id];
            NSString *originalImageDir = [Utilities getChatPicOriginalDir:object.user_id];
            NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, object.msg_id,FILE_JPG_EXTENSION];
            NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, object.msg_id,FILE_JPG_EXTENSION];
            
            if ([defaultMgr fileExistsAtPath:thumbImagePath]) {
                [defaultMgr removeItemAtPath:thumbImagePath error:NULL];
            }
            
            if ([defaultMgr fileExistsAtPath:originalImagePath]) {
                [defaultMgr removeItemAtPath:originalImagePath error:NULL];
            }
            
            NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:thumbImagePath];
            if (pos!=-1) {
                [_pics removeObjectAtIndex:pos];
            }
            
        }else if (object.msg_type == MSG_TYPE_Audio){
            
            MixChatDetailObject *entityForAudio = object;
            NSString *audioDir = [Utilities getChatAudioDir:entityForAudio.user_id];
            NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
            if ([defaultMgr fileExistsAtPath:audioPath]) {
                [defaultMgr removeItemAtPath:audioPath error:NULL];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
}

// 消息重发确认
- (void)resendMessageConfirm
{
     //直接自动重发 不要确认提示框
#if 0
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重发", @"删除", nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    sheet.tag = TAG_ACTIONSHEET_RESEND;
    sheet.destructiveButtonIndex = 1;
    [sheet showInView:self.view];
#endif
    
    {
        // 重发消息
        resendMsg.msg_state = MSG_SENDING;
        resendMsg.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
        
        [resendMsg updateToDB];
        
        // 及时更新消息的显示时间
        //resendMsg.dtLabelText = [UT_Date timeIntervalToDate:resendMsg.timestamp timeType:3 compareWithToday:YES];
        //[self setChatDetailObjectTimeLabel:resendMsg];
        
        // 更新聊天数据后刷新画面
        //        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", resendMsg.msg_id]];
        //        if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
        //            [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
        //            [chatDetailArray addObject:resendMsg];
        //            // 更新msgid对应数组的索引字典
        //            [self reloadMsgIndexDictionaryAndMsgLabel];
        //            [chatTableview reloadData];
        //        }
        //
        
        NSDictionary *data;
        
        if (resendMsg.msg_type == MSG_TYPE_PIC || resendMsg.msg_type == MSG_TYPE_Audio) {
            
            /*NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
             resendMsg.msg_file, @"png0",
             nil];
             NSArray *fileArray = [NSArray arrayWithObjects:fileDic, nil];
             
             data = [[NSDictionary alloc] initWithObjectsAndKeys:
             @"GroupChat",@"ac",
             @"2",@"v",
             @"send", @"op",
             [NSString stringWithFormat:@"%lli,",resendMsg.groupid], @"gid",
             [NSString stringWithFormat:@"%lli,",resendMsg.msg_id],@"msgid",
             [NSString stringWithFormat:@"%li,",(long)resendMsg.msg_type],@"type",
             resendMsg.msg_content,@"message",
             fileArray,@"files",
             @"png",@"fileType",
             nil];*/
            
            [chatTableview reloadData];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                //NSString *sendFlag = [FRNetPoolUtils sendMsgForMix:resendMsg];
                
                NSDictionary *result = [FRNetPoolUtils sendMsgForMix:resendMsg];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    if ([sendFlag isEqualToString:@"NO"]) {
//                        
//                        // 发送失败
//                        resendMsg.msg_state = MSG_SEND_FAIL;
//                        resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
//                        
//                        
//                    }else{
//                        
//                        // 发送成功
//                        resendMsg.msg_state = MSG_SEND_SUCCESS;
//                        resendMsg.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                        
//                    }
                    
                    if ([[result objectForKey:@"result"] integerValue] == 1){
                        
                        NSDictionary *dic = [result objectForKey:@"message"];
                        NSString *timestamp = [dic objectForKey:@"timestamp"];
                        
                        // 发送成功
                        resendMsg.msg_state = MSG_SEND_SUCCESS;
                        resendMsg.timestamp  = [timestamp longLongValue]*1000;
                        
                        
                    }else if ([[result objectForKey:@"result"] integerValue] == 0){
                        
                        // 发送失败
                        resendMsg.msg_state = MSG_SEND_FAIL;
                        resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                    }
                    
                    //---2017.02.28---------------------------------------
                    if (gid == 0) {
                        if(_sid){
                            
                            
                        }else{
                            
                            if ([result objectForKey:@"message"]) {
                                resendMsg.schoolName = [[result objectForKey:@"message"] objectForKey:@"fname"];
                            }
                            
                        }
                    }
                    //---------------------------------------
                    
                    [resendMsg updateToDB];
                    [self saveMsgToChatList:resendMsg];
                    // 更新msgid对应数组的索引字典
                    [self reloadMsgIndexDictionaryAndMsgLabel];
                    [chatTableview reloadData];
                    //[self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                    //isScrollToBottom = YES;//add 2015.09.01
                    
                });
            });
            
            
            
        }else if (resendMsg.msg_type == MSG_TYPE_TEXT){
           
            MixChatListObject *chatList = [self saveMsgToChatList:resendMsg];

            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"Message",@"ac",
                    @"3",@"v",
                    @"send", @"op",
                    [NSString stringWithFormat:@"%lli",resendMsg.user_id], @"friend",
                    [NSString stringWithFormat:@"%lli",resendMsg.groupid], @"gid",
                    [NSString stringWithFormat:@"%lli",resendMsg.msg_id],@"msgid",
                    [NSString stringWithFormat:@"%li",(long)resendMsg.msg_type],@"type",
                    resendMsg.msg_content,@"message",
                    nil];
            
            NSLog(@"data:%@",data);
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                //NSLog(@"respDic:%@",respDic);
                
                if ([result integerValue] == 1) {
                    
                    NSDictionary *dic = [respDic objectForKey:@"message"];
                    
                    // 发送成功
                    resendMsg.msg_state = MSG_SEND_SUCCESS;
                    resendMsg.timestamp  = [[dic objectForKey:@"timestamp"] longLongValue]*1000;
                    
                    
                }else{
                    
                    // 发送失败
                    resendMsg.msg_state = MSG_SEND_FAIL;
                    resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                    
                    
                }
                //---2017.02.28---------------------------------------
                
                if (gid == 0) {
                    if(_sid){
                        
                        
                    }else{
                        
                        if ([respDic objectForKey:@"message"]) {
                            resendMsg.schoolName = [[respDic objectForKey:@"message"] objectForKey:@"fname"];
                        }
                        
                    }
                }
                //----------------------------------------------
                // 更新msgid对应数组的索引字典
                [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序update 2015.08.12
                [chatTableview reloadData];
                [resendMsg updateToDB];
                chatList.msg_state = resendMsg.msg_state;
                chatList.timestamp = resendMsg.timestamp;
                [chatList updateToDB];
                //                        // 更新msgid对应数组的索引字典
                //                        [self reloadMsgIndexDictionaryAndMsgLabel];
                //                        [chatTableview reloadData];
                //                  [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                //                  isScrollToBottom = YES;//add 2015.09.01
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
                resendMsg.msg_state = MSG_SEND_FAIL;
                resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                // 更新msgid对应数组的索引字典
                [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序update 2015.08.12
                [chatTableview reloadData];
                [resendMsg updateToDB];
                chatList.msg_state = resendMsg.msg_state;
                chatList.timestamp = resendMsg.timestamp;
                [chatList updateToDB];
                //                        // 更新msgid对应数组的索引字典
                //                        [self reloadMsgIndexDictionaryAndMsgLabel];
                //                        [chatTableview reloadData];
                //[self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                
            }];
            
            if ((resendMsg.msg_state!=MSG_SEND_FAIL) && (resendMsg.msg_state!=MSG_SEND_SUCCESS)) {
                
                resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                [resendMsg updateToDB];
                chatList.last_msg = resendMsg.msg_content;
                chatList.msg_state = resendMsg.msg_state;
                chatList.timestamp = resendMsg.timestamp;
                [chatList updateToDB];
                
                NSLog(@"chatList gid:%lld",chatList.gid);
                NSLog(@"resend111");
                
            }
        }
        
    }
    
}

- (void)createTextMessage:(NSString *)msgContent
{
    MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];//msgId本地算出
    if (gid == 0) {
         chatDetail.user_id = user.user_id;
    }else{
         chatDetail.user_id = 0;
    }
   
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_SEND;
    //消息类型-文本
    chatDetail.msg_type = MSG_TYPE_TEXT;
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_SENDING;
    // 消息内容
    chatDetail.msg_content = msgContent;
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = @"";
    // 原始图片文件的HTTP-URL地址
    chatDetail.pic_url_thumb = @"";
    chatDetail.pic_url_original = @"";
    chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    chatDetail.groupid = gid;
    chatDetail.userName = @"";
    //[self clearCacheCheck];
    
    chatDetail.reflashFlag = @"0";
    
    chatDetail.size = [MsgTextView heightForEmojiText:msgContent];
    
    //    AudioBtn.userInteractionEnabled = NO;//不让多次点击，避免多次点击卡顿 2015.07.28
    
    //[chatDetail updateToDB];//update 2015.08.12
    
    MixChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    //Done:发送消息新接口
    /**
     * 聊天消息发送接口
     * 后端根据gid判断聊天类型: 0 单聊, >0 群聊
     * 1. 单聊时 friend: 对方UID
     * 2. 群聊时 friend: 暂定0
     * @author luke
     * @date 2016.01.20
     * @args
     *  v=3, ac=Message, op=send, sid=, uid=, friend=, gid=, msgid=, type=, message=, file=图片或者语音, size=语音长度
     */
    NSString *friend = [NSString stringWithFormat:@"%lli",chatDetail.user_id];
    //---2017.02.28----------------------
    if (gid == 0) {//单聊
        
        if (_sid) {
            friend = [NSString stringWithFormat:@"%@:%@",_sid,friend];//对方的sid
        }else{
            friend = [NSString stringWithFormat:@"%lld:%@",_groupChatList.schoolID ,friend];//对方的sid
        }
    }
    //-----------------------------------
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Message",@"ac",
                          @"3",@"v",
                          @"send", @"op",
                          friend, @"friend",
                          [NSString stringWithFormat:@"%lli",chatDetail.groupid], @"gid",
                          [NSString stringWithFormat:@"%lli",chatDetail.msg_id],@"msgid",
                          [NSString stringWithFormat:@"%li",(long)chatDetail.msg_type],@"type",
                          msgContent,@"message",
                          nil];
    
    /*
     if (chatDetail.msg_type == MSG_TYPE_PIC || chatDetail.msg_type == MSG_TYPE_Audio) {
     [requestForm setFile:chatDetail.msg_file forKey:@"file"];
     }
     */

    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        AudioBtn.userInteractionEnabled = YES;// 2015.07.28
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        
        if ([result integerValue] == 1) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
           
            // 发送成功
            chatDetail.msg_state = MSG_SEND_SUCCESS;
            chatDetail.timestamp  = [[dic objectForKey:@"timestamp"] longLongValue]*1000;
            //---2017.02.28----------------------
            //done:更新sid
            if (gid == 0) {
                
                if (_sid) {
                    chatDetail.schoolID = [_sid longLongValue];
                }else{
                    chatDetail.schoolID = _groupChatList.schoolID;
                }
                chatDetail.uid = uid;
                chatDetail.schoolName = [[respDic objectForKey:@"message"] objectForKey:@"fname"];
                NSLog(@"fname0:%@",[[respDic objectForKey:@"message"] objectForKey:@"fname"]);
            }
            //-----------------------------------
            [chatTableview reloadData];//update 2015.08.12
            [chatDetail updateToDB];
            
            [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
            
            isScrollToBottom = YES;
            
        }else{
            
            // 发送失败
            chatDetail.msg_state = MSG_SEND_FAIL;
            chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
            //---2017.02.28----------------------
            //done:更新sid
            if (gid == 0) {
                
                if (_sid) {
                    chatDetail.schoolID = [_sid longLongValue];
                }else{
                    chatDetail.schoolID = _groupChatList.schoolID;
                }
                chatDetail.uid = uid;
            }
            
            //----------------------------------
            [chatTableview reloadData];//update 2015.08.12
            [chatDetail updateToDB];
            
            
        }
        
        chatList.msg_state = chatDetail.msg_state;
        chatList.timestamp = chatDetail.timestamp;
        //---2017.02.28----------------------
        chatList.cid = _groupChatList.cid;
        //to do:更新sid
        if (gid == 0) {
            
            if (_sid) {
                chatList.schoolID = [_sid longLongValue];
            }else{
                chatList.schoolID = _groupChatList.schoolID;
            }
            NSLog(@"fname1:%@",[[respDic objectForKey:@"message"] objectForKey:@"fname"]);
            chatList.schoolName = [[respDic objectForKey:@"message"] objectForKey:@"fname"];
        }else{
            
        }
        
        if (![chatList isExistInDB]) {
            
        }else{
            
            if([chatList isStick]){
                chatList.stick = chatList.timestamp;
            }
        }
        //---------------------------------------
        [chatList updateToDB];
        
        
        
        //        [chatTableview reloadData];//2015.08.12
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        AudioBtn.userInteractionEnabled = YES;// 2015.07.28
        
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        chatDetail.msg_state = MSG_SEND_FAIL;
        chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
        //---2017.02.28----------------------
        //done:更新sid
        if (gid == 0) {
            
            if (_sid) {
                chatDetail.schoolID = [_sid longLongValue];
            }else{
                chatDetail.schoolID = _groupChatList.schoolID;
            }
            chatDetail.uid = uid;
        }
        //-------------------------------
        [chatTableview reloadData];//2015.08.12
        [chatDetail updateToDB];
        chatList.msg_state = chatDetail.msg_state;
        chatList.timestamp = chatDetail.timestamp;
        //---2017.02.28----------------------
        chatList.cid = _groupChatList.cid;
        // done:更新sid
        if (gid == 0) {
            if (_sid) {
                chatList.schoolID = [_sid longLongValue];
                chatList.schoolName = user.schoolName;
            }else{
                chatList.schoolID = _groupChatList.schoolID;
            }
        }else{
            
        }
        if (![chatList isExistInDB]) {
            
        }else{
            
            if([chatList isStick]){
                chatList.stick = chatList.timestamp;
            }
        }
        //--------------------------------
        [chatList updateToDB];
        //[chatTableview reloadData];
        
    }];

    
    if ((chatDetail.msg_state!=MSG_SEND_FAIL) && (chatDetail.msg_state!=MSG_SEND_SUCCESS)) {
        
        //---2017.02.28----------------------
        //done:更新sid
        if (gid == 0) {
            
            if (_sid) {
                chatDetail.schoolID = [_sid longLongValue];
            }else{
                chatDetail.schoolID = _groupChatList.schoolID;
            }
            chatDetail.uid = uid;
        }
        //--------------------------------------
        chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
        [chatDetail updateToDB];
        
    }
  
    chatList.last_msg = chatDetail.msg_content;
    chatList.msg_state = chatDetail.msg_state;
    chatList.timestamp = chatDetail.timestamp;
    //---2017.02.28----------------------
    
    chatList.cid = _groupChatList.cid;
    // done:更新sid
    if (gid == 0) {
        
        if (_sid) {
            chatList.schoolID = [_sid longLongValue];
            chatList.schoolName = user.schoolName;
        }else{
            chatList.schoolID = _groupChatList.schoolID;
        }
    }else{
      
    }
    if (![chatList isExistInDB]) {
        
    }else{
        
        if([chatList isStick]){
            chatList.stick = chatList.timestamp;
        }
    }
    //------------------------------------
    [chatList updateToDB];
    
}

- (void)createPicMessage:(NSData*)imageData
{
    MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    if (gid == 0) {
        chatDetail.user_id = user.user_id;
    }else{
        chatDetail.user_id = uid;
    }
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_SEND;
    //消息类型-图片
    chatDetail.msg_type = MSG_TYPE_PIC;
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_SENDING;
    // 消息内容
    chatDetail.msg_content = @"[图片]";
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:imageData uid:chatDetail.user_id];
    // 原始图片文件的HTTP-URL地址
    chatDetail.pic_url_thumb = @"";
    chatDetail.pic_url_original = @"";
    // 时间戳
    chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    chatDetail.groupid = gid;
    chatDetail.cid = _cid;
    chatDetail.userName = @"";
    
    chatDetail.reflashFlag = @"0";
    
    //[self clearCacheCheck];
    
    MixChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    // 发送接口 需要改
    //Done:发送消息新接口
    /*
     * 发送聊天消息
     * @author luke
     * @date    2015.05.26
     * @args
     *  op=send, sid=, uid=, gid=, msgid=, type=, message=, png0=图片, arm0=语音
     */
    
    /*NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
     chatDetail.msg_file, @"file",
     nil];
     NSArray *fileArray = [NSArray arrayWithObjects:fileDic, nil];
     
     NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
     @"GroupChat",@"ac",
     @"2",@"v",
     @"send", @"op",
     [NSString stringWithFormat:@"%lli,",chatDetail.groupid], @"gid",
     [NSString stringWithFormat:@"%lli,",chatDetail.msg_id],@"msgid",
     [NSString stringWithFormat:@"%li,",(long)chatDetail.msg_type],@"type",
     chatDetail.msg_content,@"message",
     fileArray,@"files",
     @"png",@"fileType",
     nil];
     
     [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
     
     NSDictionary *respDic = (NSDictionary*)responseObject;
     NSString *result = [respDic objectForKey:@"result"];
     
     if ([result integerValue] == 1) {
     
     NSDictionary *tempDic = [respDic objectForKey:@"message"];
     NSDictionary *dic = [tempDic objectForKey:@"message"];
     
     // 发送成功
     chatDetail.msg_state = MSG_SEND_SUCCESS;
     chatDetail.timestamp  = [[dic objectForKey:@"dateline"] longLongValue]*1000;
     
     [chatDetail updateToDB];
     
     }else{
     
     // 发送失败
     chatDetail.msg_state = MSG_SEND_FAIL;
     chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
     [chatDetail updateToDB];
     
     //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
     //                                                                message:[respDic objectForKey:@"message"]
     //                                                               delegate:nil
     //                                                      cancelButtonTitle:@"确定"
     //                                                      otherButtonTitles:nil,nil];
     //            [alertView show];
     
     }
     
     chatList.msg_state = chatDetail.msg_state;
     chatList.timestamp = chatDetail.timestamp;
     //NSLog(@"lastmsg:%@",chatList.last_msg);
     [chatList updateToDB];
     [chatTableview reloadData];
     
     
     } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
     
     [Utilities doHandleTSNetworkingErr:error descView:self.view];
     chatDetail.msg_state = MSG_SEND_FAIL;
     chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
     [chatDetail updateToDB];
     chatList.msg_state = chatDetail.msg_state;
     chatList.timestamp = chatDetail.timestamp;
     [chatList updateToDB];
     [chatTableview reloadData];
     
     }];*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSDictionary *result = [FRNetPoolUtils sendMsgForMix:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"发送消息result:%@",result);
            if ([[result objectForKey:@"result"] integerValue] == 1) {
                
                NSDictionary *dic = [result objectForKey:@"message"];
                NSString *timestamp = [dic objectForKey:@"timestamp"];
                // 发送成功
                chatDetail.msg_state = MSG_SEND_SUCCESS;
                chatDetail.timestamp  = [timestamp longLongValue]*1000;
                //---2017.02.28----------------------
                //done:更新sid
                if (gid == 0) {
                    
                    if (_sid) {
                        chatDetail.schoolID = [_sid longLongValue];
                    }else{
                        chatDetail.schoolID = _groupChatList.schoolID;
                    }
                    chatDetail.uid = uid;
                    chatDetail.schoolName = [dic objectForKey:@"fname"];
                }
                //---------------------------------------------
                [chatDetail updateToDB];
                NSLog(@"sssssssssssssssssssssssssss");
                
                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
                
                isScrollToBottom = YES;
                
                //NSLog(@"bbb:%@",[rc substringFromIndex:3]);
            } else if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                //rc = @"NO";
                NSLog(@"发送消息失败message:%@", [result objectForKey:@"message"]);
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                //---2017.02.28----------------------
                //done:更新sid
                if (gid == 0) {
                    
                    if (_sid) {
                        chatDetail.schoolID = [_sid longLongValue];
                    }else{
                        chatDetail.schoolID = _groupChatList.schoolID;
                    }
                    chatDetail.uid = uid;
                }
                //-----------------------------
                [chatDetail updateToDB];
                
                NSLog(@"ffffffffffffffffffff");
            }
            
//            if ([sendFlag isEqualToString:@"NO"]) {
//                
//                // 发送失败
//                chatDetail.msg_state = MSG_SEND_FAIL;
//                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
//                [chatDetail updateToDB];
//                NSLog(@"ffffffffffffffffffff");
//                
//            }else{
//                
//                // 发送成功
//                chatDetail.msg_state = MSG_SEND_SUCCESS;
//                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                [chatDetail updateToDB];
//                 NSLog(@"sssssssssssssssssssssssssss");
//                
//                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
//                
//                isScrollToBottom = YES;
//                
//            }
//            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            //---2017.02.28----------------------
            
            if (gid == 0) {
                if(_sid){
                    
                    chatList.schoolID = [_sid longLongValue];
                    chatList.schoolName = user.schoolName;
                }else{
                    chatList.schoolID = _groupChatList.schoolID;
                    
                    if ([result objectForKey:@"message"]) {
                        chatList.schoolName = [[result objectForKey:@"message"] objectForKey:@"fname"];
                    }
                    
                }
                chatDetail.uid = uid;
            }else{
               
            }
            //-------------------------------
            [chatList updateToDB];
            
            [chatTableview reloadData];
        });
    });
    
    if ((chatDetail.msg_state!=MSG_SEND_FAIL) && (chatDetail.msg_state!=MSG_SEND_SUCCESS)) {
        
        //---2017.02.28----------------------
        //done:更新sid
        if (gid == 0) {
            
            if (_sid) {
                chatDetail.schoolID = [_sid longLongValue];
            }else{
                chatDetail.schoolID = _groupChatList.schoolID;
            }
            chatDetail.uid = uid;
        }
        //----------------------------------
        chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
        [chatDetail updateToDB];
        
    }
    
    chatList.last_msg = chatDetail.msg_content;
    chatList.msg_state = chatDetail.msg_state;
    chatList.timestamp = chatDetail.timestamp;
    //---2017.02.28----------------------
    
    if (gid == 0) {
        
        if (_sid) {
            chatList.schoolID = [_sid longLongValue];
            chatList.schoolName = user.schoolName;
        }else{
            chatList.schoolID = _groupChatList.schoolID;
        }
        chatDetail.uid = uid;
    }else{
       
    }
    
    //---------------------------
    [chatList updateToDB];
    
    
}

- (void)createAudioMessage:(NSData*)audioData
{
    MixChatDetailObject *chatDetail = [[MixChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    if (gid == 0) {
        chatDetail.user_id = user.user_id;
    }else{
        chatDetail.user_id = uid;
    }
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_SEND;
    //消息类型-图片
    chatDetail.msg_type = MSG_TYPE_Audio;
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_SENDING;
    // 消息内容
    chatDetail.msg_content = @"[语音]";
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = [self saveAudioToLocal:chatDetail.msg_id audioData:audioData uid:chatDetail.user_id];
    // 原始图片文件的HTTP-URL地址
    chatDetail.pic_url_thumb = @"";
    chatDetail.pic_url_original = @"";
    // 时间戳
    chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    chatDetail.groupid = gid;
    chatDetail.cid = _cid;
    chatDetail.userName = @"";
    
    chatDetail.reflashFlag = @"0";
    
    //[self clearCacheCheck];
    // 语音秒数
    if (recordSec > 60) {//2015.11.13
        recordSec = 60;
    }
    chatDetail.audioSecond = recordSec;//add 2015.11.03 2.9.1新需求
    
    //[chatDetail updateToDB];
    
    //    NSLog(@"gid:%lld",gid);
    //    NSLog(@"cid:%lld",_cid);
    
    MixChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSDictionary *result = [FRNetPoolUtils sendMsgForMix:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[result objectForKey:@"result"] integerValue] == 1) {
                
                NSDictionary *dic = [result objectForKey:@"message"];
                NSString *timestamp = [dic objectForKey:@"timestamp"];
                // 发送成功
                chatDetail.msg_state = MSG_SEND_SUCCESS;
                chatDetail.timestamp  = [timestamp longLongValue]*1000;
                [chatDetail updateToDB];
                
                chatDetail.audioSecond = recordSec;//add 2015.07.07
                [chatDetail updateAudio];//add 2015.07.07
                
                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
                
                isScrollToBottom = YES;
                
                //NSLog(@"bbb:%@",[rc substringFromIndex:3]);
            } else if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                //rc = @"NO";
                NSLog(@"发送消息失败message:%@", [result objectForKey:@"message"]);
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                [chatDetail updateToDB];
                
                NSLog(@"ffffffffffffffffffff");
            }
            
//            if ([sendFlag isEqualToString:@"NO"]) {
//                // 发送失败
//                chatDetail.msg_state = MSG_SEND_FAIL;
//                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
//                [chatDetail updateToDB];
//                
//            }else {
//                // 发送成功
//                chatDetail.msg_state = MSG_SEND_SUCCESS;
//                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                [chatDetail updateToDB];
//                
//                chatDetail.audioSecond = recordSec;//add 2015.07.07
//                [chatDetail updateAudio];//add 2015.07.07
//                
//                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
//                
//                isScrollToBottom = YES;
//                
//                
//            }
            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            //---2017.02.28----------------------
            if (gid == 0) {
                if(_sid){
                    
                    chatList.schoolID = [_sid longLongValue];
                    chatList.schoolName = user.schoolName;
                }else{
                    chatList.schoolID = _groupChatList.schoolID;
                    
                    if ([result objectForKey:@"message"]) {
                        chatList.schoolName = [[result objectForKey:@"message"] objectForKey:@"fname"];
                    }
                }
                chatDetail.uid = uid;
            }else{
                
            }
            //-----------------------------------
            [chatList updateToDB];
            
            [chatTableview reloadData];
        });
    });
    
    if ((chatDetail.msg_state!=MSG_SEND_FAIL) && (chatDetail.msg_state!=MSG_SEND_SUCCESS)) {
        
        //---2017.02.28----------------------
        //done:更新sid
        if (gid == 0) {
            
            if (_sid) {
                chatDetail.schoolID = [_sid longLongValue];
            }else{
                chatDetail.schoolID = _groupChatList.schoolID;
            }
            chatDetail.uid = uid;
        }
        //----------------------------------
        chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
        [chatDetail updateToDB];
        
    }
    
    chatList.last_msg = chatDetail.msg_content;
    chatList.msg_state = chatDetail.msg_state;
    chatList.timestamp = chatDetail.timestamp;
    //---2017.02.28----------------------
    
    chatList.cid = _groupChatList.cid;
    if (gid == 0) {
        
        if (_sid) {
            chatList.schoolID = [_sid longLongValue];
            chatList.schoolName = user.schoolName;
        }else{
            chatList.schoolID = _groupChatList.schoolID;
        }
        chatDetail.uid = uid;
    }else{
       
    }
    //----------------------------
    [chatList updateToDB];
    
    numOfCellAudioPlaying = -1;
    
}


//- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData
//{
//    // 取得msgID
//    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
//
//    NSString *thumbImageDir = [Utilities getChatPicThumbDir:uid];
//    NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
//    NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
//
//    // 创建聊天缩略图片，并写入本地
//    if ([fileData writeToFile:thumbImagePath atomically:YES]) {
//        NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
//    }
//
//    return thumbImagePath;//update by kate 2015.03.27
//}

// 发送图片存储大图 2015.07.09
- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData uid:(long long)key
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:key];
    NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
    NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
    
    //UIImage *originalImage = [UIImage imageWithData:fileData];
    
    //创建源图片，并写入本地成功
    if ([fileData writeToFile:originalImagePath atomically:YES]) {
        NSLog(@"writeToFile:%@", originalImagePath);
    }
    
    return originalImagePath;
    
}

- (NSString *)saveAudioToLocal:(long long)msgid audioData:(NSData*)fileData uid:(long long)key
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    NSString *originalImageDir = [Utilities getChatAudioDir:key];
    NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"%@", FILE_AMR_EXTENSION];
    NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
    
    //创建源文件，并写入本地成功
    if ([fileData writeToFile:originalImagePath atomically:YES]) {
        NSLog(@"writeToFile:%@", originalImagePath);
    }
    
    return originalImagePath;
}

// 更新msgid对应数组的索引字典
- (void)reloadMsgIndexDictionaryAndMsgLabel
{
    @try {
        [msgIndexDic removeAllObjects];
        MixChatDetailObject *entity = nil;
        self.currentShowTime = nil;
        
        for (int i = 0; i < [chatDetailArray count]; i++) {
            entity = [chatDetailArray objectAtIndex:i];
            // msgid对应数组的索引字典，用于快速定位消息体在数组中的位置进行修改
            [msgIndexDic setObject:[NSNumber numberWithInt:i] forKey:[NSString stringWithFormat:@"%lli", entity.msg_id]];
            //更新时间戳
            [self setChatDetailObjectTimeLabel:entity];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (MixChatListObject *)saveMsgToChatList:(MixChatDetailObject *)chatDetail
{
    
    MixChatListObject *chatList = [[MixChatListObject alloc] init];
    //chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", user.user_id];
    chatList.gid = chatDetail.groupid;
    chatList.is_recieved = MSG_IO_FLG_SEND;
    //最后一条消息ID
    chatList.last_msg_id= chatDetail.msg_id;
    // 聊天的最后一条消息的类型
    chatList.last_msg_type= chatDetail.msg_type;
    // 聊天的最后一条消息内容
    chatList.last_msg = chatDetail.msg_content;
    chatList.msg_state = chatDetail.msg_state;
    if(gid == 0){
        chatList.user_id = chatDetail.user_id;
    }else{
        chatList.user_id = 0;
    }
    //时间戳
    chatList.timestamp = chatDetail.timestamp;
    chatList.title = _titleName;
//---2017.02.28----------------------
    chatList.cid = _groupChatList.cid;
   
    if (gid == 0) {
        
        if (_sid) {
            
            chatList.schoolID = [_sid longLongValue];
            chatList.schoolName = user.schoolName;
            
        }else{
            chatList.schoolID = _groupChatList.schoolID;
        }
      chatDetail.uid = uid;
    }else{
        
    }
    if (![chatList isExistInDB]) {
        
    }else{
        
        if([chatList isStick]){
            chatList.stick = chatList.timestamp;
        }
    }
//-----------------------------------
    [chatList updateToDB];
    
    return chatList;
}

//发送拍照的图片
- (void)sendTakePhotoMsg:(id)object
{
    UIImage *selectedImage =  (UIImage *)object;
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, JPG_COMPRESSION_QUALITY);
    [self createPicMessage:imageData];
}

- (void)reloadChatTableView
{
    [chatTableview reloadData];
    
    [self scrollTableViewToBottom];
}

// 播放语音
-(void)playAudio:(NSNotification*)notification{
    
    NSMutableArray *objArray = [notification object];
    numOfCellAudioPlaying = [[objArray objectAtIndex:0] integerValue];
    
    for (int i=0; i<[chatDetailArray count]; i++) {
        
        NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
        //---update by kate 2015.08.31 减少cellForRowAtIndexPath调用的次数优化性能--------------------------------
        // MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
        // if (cellAll.msgType == CELL_TYPE_AUDIO) {
        MixChatDetailObject *groupChatForAudio = [chatDetailArray objectAtIndex:i];
        if (groupChatForAudio.msg_type == MSG_TYPE_Audio) {
            
            MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
            cellAll.audioView.numOfCellAudioPlaying = numOfCellAudioPlaying;
            [cellAll.audioView.animationImageView stopAnimating];
            cellAll.audioView.playImageViewSubject.hidden = NO;
        }
        //------------------------------------------------------------------------------------------------
    }
    
    MixChatDetailObject *entityForAudio = [objArray objectAtIndex:1];
    long long key = entityForAudio.user_id;
    if (entityForAudio.is_recieved == MSG_IO_FLG_SEND) {
        if (entityForAudio.user_id == 0) {
            key = uid;
        }
    }
    
    NSString *audioDir = [Utilities getChatAudioDir:key];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
    entityForAudio.groupid = gid;
    
    NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
    
    if (fileData == nil) {
        
#if 0
        [Utilities showFailedHud:@"没有语音文件" descView:self.view];
        entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
        [entityForAudio updateAudioState];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
//        [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //--------------------------------------------------------
#endif
        //add 2016.06.15 当语音没有下载成功，点击时再下载一次
        if (entityForAudio.is_recieved == MSG_IO_FLG_RECEIVE){
            
            if (![Utilities isConnected]) {
                
                [Utilities showFailedHud:@"当前网络异常，请检查网络设置" descView:self.view];
                
            }else{
                
                isDownloaded = NO;
                
                //[Utilities showFailedHud:@"语音下载中..." descView:self.view];
                
                if (!isDownloaded) {
                    // 当收到语音时 未拉取成功 则点击时再次拉取
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        BOOL isGot = [FRNetPoolUtils getAudioFromServer:entityForAudio.audio_url userid:entityForAudio.user_id msgid:entityForAudio.msg_id];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (isGot) {
                                
                                RecordAudio *recordAudio1 = [[RecordAudio alloc] init];
                                
                                NSString *audioDir = [Utilities getChatAudioDir:entityForAudio.user_id];
                                NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
                                
                                NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                                NSInteger audioSecond = [recordAudio1 dataDuration:fileData];
                                
                                if (audioSecond < entityForAudio.audioSecond) {
                                    
                                }else{
                                    entityForAudio.audioSecond = audioSecond;
                                    [entityForAudio updateAudio];
                                }
                                
                                if (fileData == nil || [fileData length] == 0) {
                                    
                                    [Utilities showFailedHud:@"没有语音文件或文件损坏" descView:self.view];
                                    
                                }else{
                                    
                                    isDownloaded = YES;
                                    entityForAudio.audio_r_status = 1;
                                    [entityForAudio updateRAudioState];
                                    
                                    //刷新该条数据
                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                                    [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                    
                                }
                                
                            }else{
                                
                                [entityForAudio updateAudio];
                                [Utilities showFailedHud:@"语音拉取失败，请检查网络设置" descView:self.view];
                            }
                            
                        });
                    });
                }
                
            }
            
        }
        
    }else{
        if(fileData.length>0){
            
            if (entityForAudio.audioSecond == 0) {
                
                entityForAudio.groupid = gid;
                entityForAudio.audioSecond = [recordAudio dataDuration:fileData];
                [entityForAudio updateAudio];
                entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
                [entityForAudio updateAudioState];
                //---update 2015.08.31 更新单条语音--------------------------------------------------------
                //[self getChatDetailData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                //---------------------------------------------------------------------------------------------
            }else{
                //----add 2015.11.03-----------------------------------------------------------------
                entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
                [entityForAudio updateAudioState];
                
                if(entityForAudio.is_recieved == MSG_IO_FLG_RECEIVE){
                    
                    NSInteger rowsNum = [chatTableview numberOfRowsInSection:0];
                    
                    //NSInteger chatArrayCount = [chatDetailArray count];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                    if (rowsNum <= numOfCellAudioPlaying) {
                        
                        //[chatTableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [chatTableview reloadData];
                        
                    }else{
                       [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                }
                //------------------------------------------------------------------------------------
                
            }
            
            [recordAudio handleNotification:YES];//2015.11.16
            [recordAudio play:fileData];
        }else{
            
            isDownloaded = NO;
            
            //[Utilities showFailedHud:@"语音下载中..." descView:self.view];
            
            if (!isDownloaded) {
                // 当收到语音时 未拉取成功 则点击时再次拉取.
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    BOOL isGot = [FRNetPoolUtils getAudioFromServer:entityForAudio.audio_url userid:entityForAudio.user_id msgid:entityForAudio.msg_id];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (isGot) {
                            
                            RecordAudio *recordAudio1 = [[RecordAudio alloc] init];
                            
                            NSString *audioDir = [Utilities getChatAudioDir:entityForAudio.user_id];
                            NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
                            
                            NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                            NSInteger audioSecond = [recordAudio1 dataDuration:fileData];
                            
                            if (audioSecond < entityForAudio.audioSecond) {
                                
                            }else{
                                entityForAudio.audioSecond = audioSecond;
                                [entityForAudio updateAudio];
                            }
                            
                            if (fileData == nil || [fileData length] == 0) {
                                
                                [Utilities showFailedHud:@"没有语音文件或文件损坏" descView:self.view];
                                
                            }else{
                                
                                isDownloaded = YES;
                                entityForAudio.audio_r_status = 1;
                                [entityForAudio updateRAudioState];
                                
                                //刷新该条数据
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                                [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                            }
                            
                        }else{
                            
                            [entityForAudio updateAudio];
                            [Utilities showFailedHud:@"语音拉取失败，请检查网络设置" descView:self.view];
                        }
                        
                    });
                });
            }
            
        }
    }
    
}

// 播放状态回调方法
-(void)RecordStatus:(int)status
{
    // 0-播放中 1-播放完成 2-播放错误
    if (status == 0) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        MsgDetailCell *cell = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPath];
        
        // 开始点击cell的播放效果
        [cell.audioView.animationImageView startAnimating];
        cell.audioView.playImageViewSubject.hidden = YES;
        
        
    }else if (status == 1){
        
       
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        MsgDetailCell *cell = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPath];
        
        [cell.audioView.animationImageView stopAnimating];
        cell.audioView.playImageViewSubject.hidden = NO;
        
        numOfCellAudioPlaying = -1;//add 2015.10.19 以上代码 语音那行cell滚出屏幕时并没有stop，加上此句代码
        
        
    }else if (status == 2){
        
    }
    
}

- (void)showZoomPic:(NSNotification *)notification
{
    [ReportObject event:ID_SHOW_ZOOM_PIC];//点击查看大图
    
    [inputTextView resignFirstResponder];
    
    MixChatDetailObject *entityForpic = [notification object];
    
    // NSLog(@"state:%ld",(long)entityForpic.msg_state);
    
    if ([[self.navigationController topViewController] isKindOfClass:[MsgZoomImageViewController class]]) {
        return;
    }
    
    NSString *fileUrl = @"";
    long long key = entityForpic.user_id;
    if (entityForpic.is_recieved == MSG_IO_FLG_SEND) {
        if (entityForpic.user_id == 0) {
            key = uid;
        }
    }
    
    
    // 此路径保存大图
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:key];
    NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entityForpic.msg_id, FILE_JPG_EXTENSION];
    
    
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:key];
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entityForpic.msg_id,FILE_JPG_EXTENSION];
    
    NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
    NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容老版本已经存在手机里的图片

    
    //    if (fileData) {
    //        fileUrl = originalImagePath;
    //    }else{
    //        fileUrl = entityForpic.pic_url_original;
    //    }
    
    if ([entityForpic.pic_url_original length] > 0) {//收图片
        if (fileData) {
            fileUrl = originalImagePath;
        }else{
            fileUrl = entityForpic.pic_url_original;
        }
    }else{//发图片
        if (fileData) {
            fileUrl = originalImagePath;
        }else if (fileData2){
            fileUrl = thumbImagePath;
        }
    }
    
    //NSLog(@"fileUrl:%@",fileUrl);
    
    if ([fileUrl length] == 0) {//2015.07.16
        return;
    }else if ([fileUrl isEqualToString:thumbImagePath] ){
        
        UIImage *pic = [UIImage imageWithContentsOfFile:fileUrl];
        if (!pic) {
            if (entityForpic.pic_url_original) {
                return;
            }
        }
        
    }
    
    //add 2015.07.20 当缩略图没有下载成功，点击时再下载一次
    if (entityForpic.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        UIImage *pic = [UIImage imageWithContentsOfFile:fileUrl];
        
        if (!fileData2 || !pic) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // get message from server
                [FRNetPoolUtils getPicWithUrl:entityForpic.pic_url_thumb picType:PIC_TYPE_THUMB userid:entityForpic.user_id msgid:entityForpic.msg_id];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [chatTableview reloadData];
                });
                
                
            });
            
        }
    }
    
    [_pics removeAllObjects];
    
    for (int i=0; i<[chatDetailArray count]; i++) {
        
        MixChatDetailObject *entity;
        entity = [chatDetailArray objectAtIndex:i];
        long long key = entity.user_id;
        if (entity.is_recieved == MSG_IO_FLG_SEND) {
            if (entity.user_id == 0) {
                key = uid;
            }
        }
        
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:key];
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        
        NSString *thumbImageDir = [Utilities getChatPicThumbDir:key];
        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
        
        if (entity.msg_type == MSG_TYPE_PIC) {
            
            //            NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
            //
            //            if (fileData) {
            //                [_pics addObject:originalImagePath];
            //            }else{
            //                [_pics addObject:entity.pic_url_original];
            //            }
            
            NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
            NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容老版本已经存在手机里的图片
            NSString *imgUrl = @"";
            
            UIImage *pic = nil;
            
            if ([entity.pic_url_original length] > 0) {//收图片
                if (fileData) {
                    imgUrl = originalImagePath;
                    pic = [UIImage imageWithContentsOfFile:imgUrl];
                    
                    if (pic) {
                        [_pics addObject:imgUrl];
                    }
                    
                }else{
                    imgUrl = entity.pic_url_original;
                    if ([imgUrl length] > 0) {//update 2015.07.16
                        
                        [_pics addObject:imgUrl];
                    }
                }
            }else{//发图片
                if (fileData) {
                    imgUrl = originalImagePath;
                }else if (fileData2){
                    imgUrl = thumbImagePath;
                }
                
                pic = [UIImage imageWithContentsOfFile:imgUrl];
                
                if (pic) {
                    [_pics addObject:imgUrl];
                }
            }
            
            
        }
    }
    
    NSInteger pos = 0;
    
    for (int i = 0; i<[_pics count]; i++) {
        NSString *tempUrl = [_pics objectAtIndex:i];
        
        if ([fileUrl isEqualToString:tempUrl]) {
            pos = i;
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = pos;
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_pics count]];
    
    for (int i = 0; i<[_pics count]; i++) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSString *pic_url = [_pics objectAtIndex:i];
        NSLog(@"%@", pic_url);
        
        NSString *isHttp = [pic_url substringToIndex:4];
        
        if ([isHttp isEqualToString:@"http"]) {
            photo.url = [NSURL URLWithString:pic_url];
        }else{
            photo.url = nil;
            UIImage *a = [UIImage imageWithContentsOfFile:pic_url];
            photo.image = a;
        }
        
        photo.save = NO;
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    if ([photos count] > 0) {
        browser.photos = photos;
        [browser show];
    }
    
}

- (void)showUserInfo:(NSNotification *)notification
{
    if (![Utilities connectedToNetwork]) {
        [Utilities showAlert:@"错误" message:NetworkNotConnected cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    isReGetChatDetailData = YES;//2015.08.13
    
    MixChatDetailObject *groupDetailO = (MixChatDetailObject*)[notification object];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = [NSString stringWithFormat:@"%lld", groupDetailO.user_id];
    if (![G_SCHOOL_ID isEqualToString:[NSString stringWithFormat:@"%lli", groupDetailO.schoolID]]) {
        friendProfileViewCtrl.fsid = [NSString stringWithFormat:@"%lli",groupDetailO.schoolID];
    }
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//2015.09.09
    
}

-(void)changeUserNumer:(NSNotification*)notify{
    
    _userNumber = [notify object];
    [self changeTitle];
    
}

// 修改群聊名字
-(void)changeTitleName:(NSNotification*)notify{
    
    _titleName = [notify object];
    
}

// 修改从UIImagePickerController 返回后statusbar消失问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/%" withString:@"%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/&" withString:@"&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/_" withString:@"_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/(" withString:@"("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/)" withString:@")"];
    
    return keyWord;
}

//@某人之后收到的通知
-(void)getAtNames:(NSNotification*)notify{
    
    // name uid
    
    NSDictionary *dic = [notify object];
    if (dic) {
        [atArray addObject:dic];
        
        NSString *name = [dic objectForKey:@"name"];
        inputTextView.text = [inputTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",name]];
    }else{
        
        NSLog(@"inputTextView.text:%@",inputTextView.text);
        //inputTextView.text = [inputTextView.text stringByAppendingString:@"@"];
    }
    
    if (![inputTextView isFirstResponder]) {
        [inputTextView becomeFirstResponder];
    }
    
}

//长按头像@某人
-(void)atSomebody:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    //    NSString *notifyUid = [dic objectForKey:@"uid"];
    //    BOOL isAdd = YES;
    //    for (int i=0; i< [atArray count]; i++) {
    //
    //        NSDictionary *tempDic = [atArray objectAtIndex:i];
    //        NSString *tempUid = [tempDic objectForKey:@"uid"];
    //        if ([notifyUid isEqualToString:tempUid]) {
    //            isAdd = NO;
    //        }
    //    }
    
    if (gid > 0) {
        
        [atArray addObject:dic];
        NSString *name = [dic objectForKey:@"name"];
        inputTextView.text = [inputTextView.text stringByAppendingString:[NSString stringWithFormat:@"@%@ ",name]];
        
        if (audioButn.hidden == NO) {
            audioButn.hidden = YES;
            
        }
        
        [inputTextView resignFirstResponder];
        [self changeToKeyboardText];
        [inputTextView becomeFirstResponder];
    }
    
}

//删除at某人的整个名字
- (BOOL)backAt{
    
    NSString *inputString;
    
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    //CGPoint cursorPosition = [inputTextView caretRectForPosition:[inputTextView selectedRange].start].origin;
    //NSLog(@"x==%f,y==%f",cursorPosition.x,cursorPosition.y);
    
    //删除逻辑：获取当前坐标的location 将整个字符串分成两个部分 光标之前的 光标之后的 判断光标前的字符串是否以@字符串名字结尾 是则替换成空字符串 不是正常截取 最后将两部分字符串拼接成新的字符串 赋值给inputTextview
    NSString *secondPatStr = [inputString substringFromIndex:[inputTextView selectedRange].location];//光标之后的
    NSString *subStr = [inputString substringToIndex:[inputTextView selectedRange].location];//光标之前的
    NSInteger deli = -1;;
    
    for (int i=0; i<[atArray count]; i++) {
        
        NSString *atName = [[atArray objectAtIndex:i] objectForKey:@"name"];
        atName = [atName stringByAppendingString:@" "];
        
        if ([subStr hasSuffix:atName]) {
            deli = i;
            subStr = [subStr stringByReplacingOccurrencesOfString:atName withString:@""];
            
            if ([subStr hasSuffix:@"@"]) {
                subStr = [subStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
            }
            
            break;
            
        }
        
    }
    
    if (deli!=-1) {
        
        [atArray removeObjectAtIndex:deli];
        NSString *lastStr = [NSString stringWithFormat:@"%@%@",subStr,secondPatStr];
        
        self.inputTextView.text = lastStr;
        
        if ([secondPatStr length] > 0) {
            self.inputTextView.selectedRange = NSMakeRange(subStr.length, 0);
        }
        
        return NO;
    }else{
        //subStr = [subStr substringToIndex:[subStr length]];
        return YES;
    }
    
}

//如果在聊天详情页接收语音后刷新单条数据
-(void)refreshSingleCell:(NSNotification*)notify{
    
    MixChatDetailObject *mixChat = [notify object];
    
    for (int i=0; i<[self.chatDetailArray count]; i++) {
        
        MixChatDetailObject *chatD = [self.chatDetailArray objectAtIndex:i];
        if (mixChat.msg_id == chatD.msg_id) {
            
            chatD.audio_r_status = 1;
            [self.chatDetailArray replaceObjectAtIndex:i withObject:chatD];
            
            isDownloaded = YES;
            
            //刷新该条数据
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        
    }
    
    
}

@end

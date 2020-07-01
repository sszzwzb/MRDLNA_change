//
//  MsgDetailsViewController.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgDetailsViewController.h"
#import "StringUtil.h"
#import "PublicConstant.h"
#import "DBDao.h"
#import "Utilities.h"
#import "MsgZoomImageViewController.h"
//#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageResourceLoader.h"
#import "FRNetPoolUtils.h"
//#import "SalesmenViewController.h"
//#import "MobClick.h"
#import "TranspondViewController.h"
#import "SubUINavigationController.h"// add 2015.05.06
#import "SingleWebViewController.h"// add 2015.05.15

@interface MsgDetailsViewController ()

- (float)getCellHeight:(ChatDetailObject *)entity;

// TableView 滚动到底部显示最后的聊天消息
- (void)scrollTableViewToBottom;

// 判断是否需要加载更多聊天数据
//- (void)needShowMoreByRowID:(NSInteger)rowID;
- (void)needShowMoreByRowID;//2015.08.26

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

// 接收到离线消息
- (void)didReceiveMsg:(NSNotification *)notification;

//发送消息
- (void)sendTextMsg;

// 消息重发
- (void)resendMessageConfirm;

// 输入栏左边的发送图片功能按钮
- (void)selectPicConfirm;

@end

@implementation MsgDetailsViewController

@synthesize user;
@synthesize chatDetailArray;
@synthesize currentShowTime;
@synthesize inputBar;
@synthesize inputTextView;

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
        
        waitForLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        waitForLoadMore.frame = CGRectMake(150.0f, 5.0f, 20.0f, 20.0f);
        
        self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        
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
        waitForLoadMore.frame = CGRectMake(150.0f, 5.0f, 20.0f, 20.0f);
        
        //self.view.backgroundColor = COMMON_BACKGROUND_COLOR;
         self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        
        [self createChatSelectTool];
        
        [self initImagePicker];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // NSLog(@"msgDetailTag:%d",self.view.tag);
    
    timeFirst = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFirst"];
    if ([timeFirst length] == 0) {
        
        long long time = [[NSDate date] timeIntervalSince1970];
        NSString *timeFirstStr = [NSString stringWithFormat:@"%lld",time];
        [[NSUserDefaults standardUserDefaults]setObject:timeFirstStr forKey:@"timeFirst"];
 
    }
    
    //获取窗口大小
    winSize = [[UIScreen mainScreen] bounds].size;
    
    [super setCustomizeLeftButton];
    //self.navigationItem.backBarButtonItem = [CommonUtil customerBackItem:@"聊天"];
    
    // 初始化tableview
    CGRect tableFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR);
    chatTableview = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    chatTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
	chatTableview.backgroundColor = [UIColor clearColor];
    chatTableview.scrollsToTop = YES;
    chatTableview.clipsToBounds = NO;
    chatTableview.contentSize = CGSizeMake(winSize.width, 1000);
    chatTableview.delegate = self;
    chatTableview.dataSource = self;
    [self.view addSubview:chatTableview];
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [chatTableview addGestureRecognizer:singleTouch];
    //[singleTouch release];
    
    //NSLog(@"fromeName:%@",_fromName);
    
    
    if ([_fromName isEqualToString:@"feedback"]) {
        [self getFeedbackData];
        [self showFeedbackInputBar];
    }else{
        //--------------------------------------------
        // 显示输入框
        [self showInputBar];
        
        [ReportObject event:ID_OPEN_MESSAGE];//2015.06.24
    }
    
    isScrollToBottom = YES;//2015.08.27
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatDetailData)
                                                 name:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadMoreChatsListData:)
//                                                 name:NOTIFICATION_DB_GET_MORECHATINFODATA
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showZoomPic:)
                                                 name:NOTIFICATION_UI_TOUCH_IMAGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playAudio:)
                                                 name:NOTIFICATION_UI_TOUCH_PLAY_AUDIO
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUserInfo:)
                                                 name:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSelfInfo:)
                                                 name:NOTIFICATION_UI_TOUCH_SELF_HEAD_IMAGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUser:)
                                                 name:NOTIFICATION_UI_CHANGE_USER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMsg:)
                                                 name:NOTIFICATION_UI_DELETE_MSG
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transpondMsg:)
                                                 name:NOTIFICATION_UI_TANSPOND_MSG
                                               object:nil];
    // 聊天页超链接从webView打开 2015.05.15
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoWebView:)
                                                name:@"OpenUrlByWebView" object:nil];
    
    // 监听键盘的显示和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //--- add by kate 键盘下落消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard)
												 name:@"keyBoardDrop" object:nil];
    
    heightArray = [[NSMutableArray alloc] init];//cell高度数组 2015.07.25
    
    
    
}

// 聊天页超链接从webView打开 2015.05.15
-(void)gotoWebView:(NSNotification*)notification{
    
    NSURL *url = [notification object];
#if 0
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    //fileViewer.requestURL = shareUrl;
    fileViewer.fromName = @"message";
    fileViewer.url = url;
    fileViewer.currentHeadImgUrl = nil;
#endif
    
    // 2015.09.23
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    fileViewer.currentHeadImgUrl = nil;
    
    [self.navigationController pushViewController:fileViewer animated:YES];
    
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    //done:每次进入聊天详情页请求接口，发送已读的最后一条msgid 2015.11.19---------------------------------------------------
    // tellServerLastMsgId
    ChatDetailObject *entity = [chatDetailArray lastObject];
    if (entity) {
        [self tellServerLastMsgId:[NSString stringWithFormat:@"%lld",user.user_id] last:[NSString stringWithFormat:@"%lld",entity.msg_id]];
    }
    //-----------------------------------------------------------------------------------------------------------------

    [self.navigationController popViewControllerAnimated:YES];
    
}

//-------------------------------------------------------------------------------
// 自动重发
-(void)sendTextMsgAgain:(ChatDetailObject*)resendMSG{
    
    // 重发消息
    resendMSG.msg_state = MSG_SENDING;
    resendMSG.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    [resendMSG updateToDB];
    
    // 及时更新消息的显示时间
    //resendMsg.dtLabelText = [UT_Date timeIntervalToDate:resendMsg.timestamp timeType:3 compareWithToday:YES];
    //[self setChatDetailObjectTimeLabel:resendMsg];
    
    // 更新聊天数据后刷新画面
    /* NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", resendMSG.msg_id]];
     if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
     [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
     [chatDetailArray addObject:resendMSG];
     // 更新msgid对应数组的索引字典
     [self reloadMsgIndexDictionaryAndMsgLabel];
     [chatTableview reloadData];
     }*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sendFlag = [FRNetPoolUtils sendMsg:resendMSG];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[sendFlag substringToIndex:3] isEqualToString:@"YES"]) {
                // 发送成功
                resendMSG.msg_state = MSG_SEND_SUCCESS;
                resendMSG.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                
                if (resendMSG.msg_type == MSG_TYPE_TEXT) {
                    //[MobClick event:Report_SendTextMessage];
                } else if (resendMSG.msg_type == MSG_TYPE_PIC) {
                   // [MobClick event:Report_SendPictureMessage];
                }
            } else {
                // 发送失败
                resendMSG.msg_state = MSG_SEND_FAIL;
                
                if (![sendFlag isEqualToString:@"NO"]) { // 发送失败，被乘客端屏蔽
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                        message:@"消息发送失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil,nil];
                    [alertView show];
                    //[alertView release];
                }
            }
            [resendMSG updateToDB];
            [self saveMsgToChatList:resendMSG];
            
            // 更新msgid对应数组的索引字典
            [self reloadMsgIndexDictionaryAndMsgLabel];
            [chatTableview reloadData];
            [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
        });
    });
}
//--------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    numOfCellAudioPlaying = -1;
    
//    UIBarButtonItem *left = nil;
//    if ([self.frontName isEqualToString:@"user"]) {
//        left = [CommonUtil customerLeftItem:@"顾问详情" target:self action:@selector(back:)];
//    } else if ([self.frontName isEqualToString:@"list"]) {
//        left = [CommonUtil customerLeftItem:@"消息" target:self action:@selector(back:)];
//    } else {
//        left = [CommonUtil customerLeftItem:@"主页" target:self action:@selector(back:)];
//    }
//    if (left) {
//        self.navigationItem.leftBarButtonItem = left;
//    }
    
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    if ([OSVersionString doubleValue] < 7.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_pink44.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_pink.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //[MyTabBarController setTabBarHidden:YES];
    
    //为了刷新聊天界面中修改自己头像不刷新问题
    [chatTableview reloadData];
    
    if ([_fromName isEqualToString:@"feedback"]) {
        [super setCustomizeTitle:@"意见反馈"];
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"MsgDetailsView" forKey:@"viewName"];
        [userDefaults synchronize];
         NSString *viewName = [userDefaults objectForKey:@"viewName"];
         NSLog(@"viewName:%@",viewName);
        
        isMoreDataLoading = NO;
        isActionStart = NO;
        isScrollToBottom = YES;
        
        self.user = [UserObject getUserInfoWithID:user.user_id];
        if ([user.name length] > 0) {
            //self.title = user.name;
            [super setCustomizeTitle:user.name];
        } else {
            //self.title = NO_NAME_USER;
            [super setCustomizeTitle:NO_NAME_USER];
        }
        
        //[MobClick beginLogPageView:@"聊天页"];
        
        //-----add by kate----------------------------
        // 进入此页面上一次没发送成功的消息自动重发
        if ([chatDetailArray count] > 0) {
            for (int i=0; i<[chatDetailArray count]; i++) {
                ChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
                if (MSG_SEND_FAIL == entity.msg_state || MSG_SENDING == entity.msg_state) {
                    //[self sendTextMsgAgain:entity];
                }
                
            }
            
        }
        
        //done:每次进入聊天详情页请求接口，发送已读的最后一条msgid 2015.11.19-------------------------
        // tellServerLastMsgId
        ChatDetailObject *entity = [chatDetailArray lastObject];
        if (entity) {
            [self tellServerLastMsgId:[NSString stringWithFormat:@"%lld",user.user_id] last:[NSString stringWithFormat:@"%lld",entity.msg_id]];
        }
        
        //--------------------------------------------------------------------------------------
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissKeyboard];
    
    // update by kate 2014.11.03
    if ([_fromName isEqualToString:@"feedback"]) {
        
    }else{
        
        NSString *updateDetailsSql =[NSString stringWithFormat: @"update msgInfo_%lli set msg_state = %d where is_recieved = %d and msg_state != %d", user.user_id, MSG_READ_FLG_READ, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        [[DBDao getDaoInstance] executeSql:updateDetailsSql];
        
        NSString *updateListSql =[NSString stringWithFormat: @"update msgList set msg_state = %d where is_recieved = %d and msg_state != %d and user_id = %lli", MSG_READ_FLG_READ, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ, user.user_id];
        [[DBDao getDaoInstance] executeSql:updateListSql];
        
        //[MobClick endLogPageView:@"聊天页"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    }
    
}

/*- (void)dealloc
{
    if(user){
        //[user release];
        user = nil;
    }
    
    if (chatTableview) {
        [chatTableview removeFromSuperview];
        //[chatTableview release];
        chatTableview = nil;
    }
    
    if(chatDetailArray){
        [chatDetailArray removeAllObjects];
        //[chatDetailArray release];
        chatDetailArray = nil;
    }
    
    self.currentShowTime = nil;
    
    if(waitForLoadMore){
        [waitForLoadMore stopAnimating];
        //[waitForLoadMore release];
        waitForLoadMore = nil;
    }
    
    if(inputBar){
        //[inputBar release];
        inputBar = nil;
    }
    
    if(inputTextView){
        //[inputTextView release];
        inputTextView = nil;
    }
    
    if(entryImageView){
        //[entryImageView release];
        entryImageView = nil;
    }
    
    if(imagePicker){
        //[imagePicker release];
        imagePicker = nil;
    }
    
    //[msgIndexDic release];
    msgIndexDic = nil;
    
//    [takePhotoWaitView release];
//    takePhotoWaitView = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //[super dealloc];
}*/

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
    ChatDetailObject *entity = [chatDetailArray objectAtIndex:indexPath.row];
    cellheight = cellheight + [self getCellHeight:entity];
    // ＋10防止最后一条消息的泡泡显示不出来
	return cellheight + 10;*/
    
    CGFloat cellheight = TIME_HEIGHT;//预留的时间label
    cellheight = cellheight + [[heightArray objectAtIndex:indexPath.row] floatValue];
    return cellheight+10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatDetailObject *entity;
    if (indexPath.row >= [chatDetailArray count]) {
        entity = [chatDetailArray lastObject];
    } else {
        entity = [chatDetailArray objectAtIndex:indexPath.row];
    }
    
    entity.size = [MsgTextView heightForEmojiText:entity.msg_content];

    
#if 0
    if (![@""  isEqual: entity.msg_file]) {
        if (0 == [_pics count]) {
            [_pics addObject:entity.msg_file];
        }else {
            NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:entity.msg_file];
            
            if (-1 == pos) {
                [_pics addObject:entity.msg_file];
            }

            
            
            
#if 0
            int a = 0;
            for (int i=0; i<[_pics count]; i++) {
                NSString *arrStr = [_pics objectAtIndex:i];
                if (![arrStr isEqual:entity.msg_file]) {
                    [_pics addObject:entity.msg_file];
                    a = 1;
                }
            }
#endif

        }
    }
#endif
    
    
    NSString *CellIdentifier = @"ChatDetailCellId";
    
    MsgDetailCell *cell = (MsgDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[MsgDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    //cell.customDelegate = self;
    cell.index = [NSString stringWithFormat:@"%d",indexPath.row];
    
    if ([@"feedback" isEqualToString:_fromName]) {
        cell.fromName = @"feedback";
    }
    //NSLog(@"msgContent:%@",entity.msg_content);
    [self updateCellWithEntity:cell entity:entity updateState:NO];
    
//        if (indexPath.row%2 == 0) {
//            cell.contentView.backgroundColor = [UIColor greenColor];
//        }else{
//            cell.contentView.backgroundColor = [UIColor redColor];
//        }
    
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

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try {
        [self dismissViewControllerAnimated:YES completion:nil];
        
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
    
//    if(growingTextView.text.length == 0){
//        
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
//    }else{
//        
//        AudioBtn.frame = CGRectMake(320-33-5-5, AudioBtn.frame.origin.y, 47, 33);
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
//    }
    
    if(growingTextView.text.length == 0){
        
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    }else{
        
        AudioBtn.frame = CGRectMake(WIDTH-40-2, AudioBtn.frame.origin.y, 40, 33);
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_p.png"] forState:UIControlStateHighlighted];
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
       
//        if(growingTextView.text.length == 1){
//            
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
//        }
        return YES;
        
    }
    
//    NSLog(@"textLength:%d",text.length);
//    NSLog(@"textViewText:%d",growingTextView.text.length);
    
     if (growingTextView.text.length + text.length > MAX_TEXTLENGTH) { // 50000 2015.07.21
        //达到输入的上线
        return NO;
    }
    return YES;
}

//// 打开了此方法的注释 因为意见与反馈功能 update by kate 2014.11.3
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//    if ([_fromName isEqualToString:@"feedback"]) {
//         [self sendTextMsg];
//         return NO;
//    }
//    
//    return NO;
//    
//}


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
                        ChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
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
                            ChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
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
                
                if (resendMsg.msg_type == MSG_TYPE_PIC || resendMsg.msg_type == MSG_TYPE_Audio){
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSString *sendFlag = [FRNetPoolUtils sendMsg:resendMsg];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([sendFlag isEqualToString:@"NO"]){
                                
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
                    
                }else if (resendMsg.msg_type == MSG_TYPE_TEXT){
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          @"Message",@"ac",
                                          @"send", @"op",
                                          [NSString stringWithFormat:@"%lli",resendMsg.user_id], @"fuid",
                                          [NSString stringWithFormat:@"%lli",resendMsg.msg_id],@"msgid",
                                          [NSString stringWithFormat:@"%li",(long)resendMsg.msg_type],@"type",
                                          resendMsg.msg_content,@"message",
                                          nil];
                    
                    
                    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                        
                        NSDictionary *respDic = (NSDictionary*)responseObject;
                        NSString *result = [respDic objectForKey:@"result"];
                        
                        //NSLog(@"respDic:%@",respDic);
                        
                        if ([result integerValue] == 1) {
                            
                            // 发送成功
                            NSDictionary *dic = [respDic objectForKey:@"message"];
                            
                            resendMsg.msg_state = MSG_SEND_SUCCESS;
                            resendMsg.timestamp  = [[dic objectForKey:@"timestamp"] longLongValue]*1000;
                            
                            
                        }else{
                            
                            // 发送失败
                            resendMsg.msg_state = MSG_SEND_FAIL;
                            
                        }
                        
                        // 更新msgid对应数组的索引字典
                        [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序update 2015.08.12
                        [chatTableview reloadData];
                        
                        [resendMsg updateToDB];
                        [self saveMsgToChatList:resendMsg];
                        
                        //                    // 更新msgid对应数组的索引字典
                        //                    [self reloadMsgIndexDictionaryAndMsgLabel];
                        //                    [chatTableview reloadData];
                        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                        isScrollToBottom = YES;//add 2015.09.01
                        
                        
                    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                        
                        [Utilities doHandleTSNetworkingErr:error descView:self.view];
                        resendMsg.msg_state = MSG_SEND_FAIL;
                        resendMsg.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                        // 更新msgid对应数组的索引字典
                        [self reloadMsgIndexDictionaryAndMsgLabel];//更改语句顺序 update 2015.08.12
                        [chatTableview reloadData];
                        [resendMsg updateToDB];
                        [self saveMsgToChatList:resendMsg];
                        //                    // 更新msgid对应数组的索引字典
                        //                    [self reloadMsgIndexDictionaryAndMsgLabel];
                        //                    [chatTableview reloadData];
                        [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
                        
                    }];
                    
                }
                
            } else if (1 == buttonIndex) {
                // 删除消息
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                                [chatTableview reloadData];
                                [self deleteChatFile:resendMsg];
                                ChatDetailObject *lastObject = [chatDetailArray lastObject];
                                [self saveMsgToChatList:lastObject];
                            }
                        } else {
                            // 删除失败提示
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除消息失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil ];
                            [alert show];
                            //[alert release];
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

//删除
-(void)deleteMsg:(NSNotification *)notification{
    
    ChatDetailObject *deleteMsg = notification.object;
    NSLog(@"lastObjecttimestamp:%lld",deleteMsg.timestamp);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BOOL bDeleteMsg = [self deleteChatMessage:deleteMsg.msg_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bDeleteMsg) {
                // 更新聊天数据后刷新画面
                NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", deleteMsg.msg_id]];
                if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
                    
                    [chatDetailArray removeObjectAtIndex:[indexOfMsg intValue]];
                    [heightArray removeObjectAtIndex:[indexOfMsg intValue]];
                    // 更新msgid对应数组的索引字典
                    [self reloadMsgIndexDictionaryAndMsgLabel];
                    [chatTableview reloadData];
                    [self deleteChatFile:deleteMsg];
                    
                    if ([chatDetailArray count] == 0) {
                        
                         ChatListObject *chatList = [[ChatListObject alloc] init];
                         chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", user.user_id];
                         chatList.user_id = user.user_id;
                         chatList.last_msg = @"";
                         chatList.timestamp = deleteMsg.timestamp;
                         [chatList updateToDB];
                         
                    }else{
                        ChatDetailObject *lastObject = [chatDetailArray lastObject];
                        [self saveMsgToChatList:lastObject];
                    }
                   
                }
            } else {
                // 删除失败提示
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除消息失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil ];
                [alert show];
                //[alert release];
            }
        });
    });
    
}

// 转发
-(void)transpondMsg:(NSNotification*)notification{
    
    ChatDetailObject *entity = (ChatDetailObject*)[notification object];//这条聊天消息包含的详细信息
    TranspondViewController *transV = [[TranspondViewController alloc]init];
    transV.entity = entity;
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:transV];
    SubUINavigationController *nav = [[SubUINavigationController alloc]initWithRootViewController:transV];
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - Private methods

- (void)back:sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取聊天消息列表 update 2015.09.08
- (void)getChatDetailData
{
    inputBar.hidden = NO;
    
//    if (!isMoreDataLoading && isScrollToBottom) {
//        // 清除数据
//         if ([chatDetailArray count] > 0) {
//         [chatDetailArray removeAllObjects];
//         }
//         
//         if ([msgIndexDic count] > 0) {
//         [msgIndexDic removeAllObjects];
//         }
//         self.currentShowTime = nil;
//    }
   
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfo_%lli", user.user_id];
    
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        
        // TODO 还没实现分页显示
        // 查询SQL文 分页sql文 2015.08.26
        NSString *getDataSql = [NSString stringWithFormat:@"select * from  msgInfo_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", user.user_id, 0, TABLE_SHOWING_COUNT];
        //NSString *getDataSql = [NSString stringWithFormat:@"select * from  msgInfo_%lli ORDER BY timestamp DESC", user.user_id];
        //执行SQL
        NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
        
        //NSLog(@"retDictionary:%@",retDictionary);
        
        //NSLog(@"chatArrayCount1:%d",[chatDetailArray count]);
        
        [self updataChatDetailArray:retDictionary];
        
        //NSLog(@"chatArrayCount:%d",[chatDetailArray count]);
        
        [chatTableview reloadData];//2015.07.07
        
    }
    
    if (!isMoreDataLoading && isScrollToBottom) {// 2015.08.26
        [self scrollTableViewToBottom];
    }else{
        
    }
    
//2015.07.09
#if 0
    
    for (int i=0; i<[chatDetailArray count]; i++) {
        ChatDetailObject *entity;
        entity = [chatDetailArray objectAtIndex:i];
        
//        NSString *originalImageDir = [Utilities getChatPicOriginalDir:entity.user_id];
//        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];// update by kate 2015.03.27
        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];

        if (![@""  isEqual: thumbImagePath]) {
            
            if(entity.msg_type == MSG_TYPE_PIC){
                if (0 == [_pics count]) {
                    [_pics addObject:thumbImagePath];
                }else {
                    NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:thumbImagePath];
                    
                    if (-1 == pos) {
                        [_pics addObject:thumbImagePath];
                    }
                }
            }
            
        }
    }
#endif

}

// 获取意见与反馈消息列表
-(void)getFeedbackData{
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    inputBar.hidden = NO;
    
    // 清除数据
    if ([chatDetailArray count] > 0) {
        [chatDetailArray removeAllObjects];
    }
    
    if ([msgIndexDic count] > 0) {
        [msgIndexDic removeAllObjects];
    }
    self.currentShowTime = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *listArray = [FRNetPoolUtils getFeedbackMessageList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];//2015.05.12

            if (listArray == nil) {
                // 接收失败
                [Utilities showAlert:@"错误" message:NetworkNotConnected cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }else {
                // 接收成功
                
                [self updateFeedbackChatDetailArray:listArray];
                //pmid
                
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSString *lastId = [NSString stringWithFormat:@"%@",[[listArray lastObject] objectForKey:@"pmid"]];
                
                [userdefaults setObject:lastId forKey:@"lastIDForFeedback"];
                [userdefaults synchronize];
                
            }
            
            [chatTableview reloadData];
            [self scrollTableViewToBottom];
        });
    });
    
}

// 根据ChatDetailObject更新cell
- (void)updateCellWithEntity:(MsgDetailCell *)cell entity:(ChatDetailObject *)entity updateState:(BOOL)updateState
{
    cell.msgType = CELL_TYPE_TEXT;

    if (entity.msg_type == MSG_TYPE_PIC) {
        cell.msgType = CELL_TYPE_PIC;
    }else if (entity.msg_type == MSG_TYPE_Audio){
        cell.msgType = CELL_TYPE_AUDIO;
        
        if([cell.index integerValue] == numOfCellAudioPlaying){//add 2015.10.15
        
            cell.audioView.isStart = YES;
             NSLog(@"YES:%@",cell.index);
        }else{
            
            cell.audioView.isStart = NO;
            NSLog(@"NO:%@",cell.index);

        }
    }

    [cell updataCell:entity updateState:updateState];
    
    GlobalSingletonUserInfo* userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;;
    NSDictionary *message_info = [userInfo getUserDetailInfo];
    //NSString* userid = [message_info objectForKey:@"uid"];
    NSString *myHeadUrl = [message_info objectForKey:@"avatar"];
    //[cell setSelfHeadImage:myUserID];
   
    if ([_fromName isEqualToString:@"feedback"]) {
       
        [cell setSelfHeadImage:myHeadUrl];
        [cell setAdminHeadImage];
        
    }else{
        
        [cell setUserHeadImage:user.headimgurl];
        [cell setSelfHeadImage:myHeadUrl];
        
    }
   
    //[cell setUserHeadImage:user uid:user.user_id];
    
    long long timestamp = entity.timestamp;
    timestamp = timestamp/1000.0;
    
    cell.timeLabel.text = [Utilities timeIntervalToDate:timestamp timeType:1 compareWithToday:YES];
    if (entity.showTimeLabel) {
        cell.timeLabel.alpha = 1;
    } else {
        cell.timeLabel.alpha = 0;
    }

}


- (float)getCellHeight:(ChatDetailObject*)entity
{
    float cellHeight = 0;
    if (entity.msg_type == MSG_TYPE_PIC) {
        cellHeight = [self getPicMessageHeight:entity];
    }

    if (cellHeight == 0){
        cellHeight = [self getTextMessageHeight:entity]; 
    }
    
    //头像的高度是47，所以cell的高度必须满足大于等于47
    if(cellHeight < 47){
        cellHeight = 47; 
    }
    
    return cellHeight;
}

// 获取图片信息高度
- (float)getPicMessageHeight:(ChatDetailObject*)entity
{
    float height = 0;
    
     NSString *imagePath = @"";
    // 此路径保存缩略图
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:user.user_id];
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
    //大图路径
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:user.user_id];
    NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
      
        imagePath = thumbImagePath;
    }else{
      
        imagePath = originalImagePath;
        
        if (![UIImage imageWithContentsOfFile:imagePath]) {
            imagePath = thumbImagePath;
        }

    }
    
    UIImage *showImage = [UIImage imageWithContentsOfFile:imagePath];

    if(!showImage){
        showImage = [UIImage imageNamed:@"reciveNoMsgImg.png"];//update 2015.07.16
        
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
    height = imageSize.height + 14;
    
    return height;
}

// 获取文本信息高度
- (float)getTextMessageHeight:(ChatDetailObject*)entity
{
    float height = 0;
//    2015.08.07
//    MsgTextView *textView = [[MsgTextView alloc] init];
//    height = [textView getTextHeight:entity] + 20;
    height = [MsgTextView heightForEmojiText:entity.msg_content].height+5.0f*2;
    
    return height;
}

- (void)setChatDetailObjectTimeLabel:(ChatDetailObject *)entity
{
    //    if ((entity.msg_state == MSG_SENDING) || (entity.msg_state == MSG_RECEIVING)) {
    //        entity.showTimeLabel = NO;
    //        return;
    //    }
    
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
    }}

// TableView 滚动到底部显示最后的聊天消息
- (void)scrollTableViewToBottom
{
    NSInteger sections = [chatTableview numberOfSections];  
    if (sections < 1) return;  
    NSInteger rows = [chatTableview numberOfRowsInSection:sections - 1];  
    if (rows < 1) return; 
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows - 1 inSection:sections - 1];
    [chatTableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    NSLog(@"chatTableview.contentOffset.y:%f",chatTableview.contentOffset.y);
    tableOffset = chatTableview.contentOffset.y;
    isScrollToBottom = YES;
    
}

- (void)needShowMoreByRowID
{
    //long long uuid = chatTargetQuter.uuid;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfo_%lli", user.user_id];
    
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
                
               // NSLog(@"3chatTableview.contentOffset.y:%f",chatTableview.contentOffset.y);
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

-(void)getMoreChatInfofrom:(NSInteger)chatArrayCount{
    
    NSString *getDataSql = [NSString stringWithFormat:@"select * from  msgInfo_%lli ORDER BY timestamp DESC, msg_id DESC limit %d, %d", user.user_id, chatArrayCount, TABLE_SHOWING_COUNT];
    
    //执行SQL
    NSMutableDictionary *dictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
    
    if ([dictionary.allKeys count] < 20) {
        earliestRowID = [dictionary.allKeys count];
    }
    
    for (int listCnt = 0; listCnt < [dictionary.allKeys count]; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        ChatDetailObject *ChatDetail = [[ChatDetailObject alloc] init];
        
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
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];
        // 更新聊天数据后刷新画面
        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
        if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
            [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
            
        } else {
            [chatDetailArray insertObject:ChatDetail atIndex:0];
            [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
        }
        [self setChatDetailObjectTimeLabel:ChatDetail];
        
        //---add 2015.07.25----------------------------------------------
        float height = [self getCellHeight:ChatDetail];
        [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
        //-----------------------------------------------------------------
        
    }
    
}

-(void)reload{
    
    [chatTableview reloadData];
}

//加载聊天列表数据
/*- (void)loadMoreChatsListData:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification object];
    earliestRowID = [dictionary.allKeys count];
    if(earliestRowID == 0){
        return;     
    }
    for (int listCnt = 0; listCnt < [dictionary.allKeys count]; listCnt++) {
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        ChatDetailObject *ChatDetail = [[ChatDetailObject alloc] init];
        
        ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"]intValue];
        ChatDetail.msg_id = [[chatObjectDict objectForKey:@"msg_id"]longLongValue];
        ChatDetail.msg_type = [[chatObjectDict objectForKey:@"msg_type"]intValue];
        ChatDetail.is_recieved = [[chatObjectDict objectForKey:@"msg_io_type"]intValue];
        ChatDetail.msg_state = [[chatObjectDict objectForKey:@"msg_state"]intValue];
        ChatDetail.msg_content = [chatObjectDict objectForKey:@"msg_content"];
        ChatDetail.msg_file = [chatObjectDict objectForKey:@"msg_file"];
        ChatDetail.pic_url_thumb = [chatObjectDict objectForKey:@"pic_url_thumb"];
        ChatDetail.pic_url_original = [chatObjectDict objectForKey:@"pic_url_original"];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"timestamp"]longLongValue];
        [chatDetailArray insertObject:ChatDetail atIndex:0];
        //[ChatDetail release];
    }
    
    [self reloadMsgIndexDictionaryAndMsgLabel];
    
    [chatTableview reloadData];
    // 滚动到之前的位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:earliestRowID -1 inSection:0];
    CGRect showRect = [chatTableview rectForRowAtIndexPath:indexPath];
    showRect.origin.y = showRect.origin.y + 325;
    [chatTableview scrollRectToVisible:showRect animated:NO];
    
    [waitForLoadMore stopAnimating];
    [waitForLoadMore removeFromSuperview];
    chatTableview.tableHeaderView = nil;
    isMoreDataLoading = NO;
    earliestRowID = 0;
}*/

- (void)createChatSelectTool
{
    //聊天方式选择工具条
    if (!selectTool) {
        selectTool = [[MsgTypeSelectTool alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 216) withController:self];
    }
}

/*- (void)showInputBar
{
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR, [[UIScreen mainScreen] bounds].size.width, HEIGHT_INPUT_BAR)];
    // 输入框
    //inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(54, 8, 216, 36)];
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(33+5+5+33+3, 8, winSize.width - 54 - 5 - 50-10, 36)];
    inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
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
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    //entryImageView.frame = CGRectMake(53, 5, 214, HEIGHT_INPUT_BAR_BUTTON);
    //entryImageView.frame = CGRectMake(53, 5, winSize.width - 54 - 5 - 3, HEIGHT_INPUT_BAR_BUTTON);
    entryImageView.frame = CGRectMake(33+5+5+33+3, 5, winSize.width - 54 - 5 - 3 -50-10, 42);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)];
    singleTouch.delegate = self;
    [inputTextView addGestureRecognizer:singleTouch];
    //[singleTouch release];
    
    UIImage *rawBackground = [UIImage imageNamed:@"friend/bg_message_entry.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImageView *entryBackgroundImageView = [[UIImageView alloc] initWithImage:background];
    entryBackgroundImageView.frame = CGRectMake(0, 0, inputBar.frame.size.width, inputBar.frame.size.height);
    entryBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryBackgroundImageView.userInteractionEnabled = YES;
    [inputBar addSubview:entryBackgroundImageView];
    [inputBar addSubview:entryImageView];
    [inputBar addSubview:inputTextView];
    //[entryBackgroundImageView release];
    
    // 图片按钮
    UIButton *actionBtnText = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtnText.frame = CGRectMake(33+5+5, 12-3, 33, 33);
    actionBtnText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [actionBtnText addTarget:self action:@selector(changeToKeyboardTool) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/addImage_normal.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/addImage_press.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:actionBtnText];
    
//  语音图标小按钮
    AudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioBtn.frame = CGRectMake(320-33-5, 12-3, 33, 33);
    AudioBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [AudioBtn addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
    [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:AudioBtn];
    
    // 表情按钮
    keyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardBtn.frame = CGRectMake(5, 12-3, 33, 33);
    keyboardBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [keyboardBtn addTarget:self action:@selector(changeKeyboardType) forControlEvents:UIControlEventTouchUpInside];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji_press.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:keyboardBtn];
    
    // 初始化audio lib
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    //点击录制语音
    audioButn = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButn.frame = CGRectMake(3, 5.0, 320-44, 42);
    audioButn.tag = 126;
    [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioButn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"]
                         forState:UIControlStateNormal];
    [audioButn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"]
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
        faceBoard.inputTextView = inputTextView;
    }
    
    keyboardButtonType = BTN_KEYBOARD;
    
    [self.view addSubview:inputBar];
    [self.view bringSubviewToFront:inputBar];
}*/

- (void)showInputBar
{
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR, [[UIScreen mainScreen] bounds].size.width, HEIGHT_INPUT_BAR)];
    inputBar.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1];
    // 输入框
    //inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(54, 8, 216, 36)];
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(33+5+5+33+1, 8, winSize.width - 54 - 5 - 50-10, 36)];
    inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
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
    entryImageView.frame = CGRectMake(33+5+5+33+1, 5, winSize.width - 54 - 5 - 3 -50-10, 42);
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
    actionBtnText.frame = CGRectMake(33+5+5, (52-33)/2.0, 33, 33);
    actionBtnText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [actionBtnText addTarget:self action:@selector(changeToKeyboardTool) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:actionBtnText];
    
    //  语音图标小按钮
    AudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioBtn.frame = CGRectMake(WIDTH-33-5-3, (52-33)/2.0, 33, 33);
    AudioBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [AudioBtn addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
    [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    [inputBar addSubview:AudioBtn];
    
    // 表情按钮
    keyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardBtn.frame = CGRectMake(5, (52-33)/2.0, 33, 33);
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
    audioButn.frame = CGRectMake(3, 5.0, WIDTH-44, 33.0);
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

// 意见与反馈输入框
-(void)showFeedbackInputBar{
    
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_INPUT_BAR, [[UIScreen mainScreen] bounds].size.width, HEIGHT_INPUT_BAR)];
    // 输入框
    //inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(54, 8, 216, 36)];
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 5, winSize.width - 66, HEIGHT_INPUT_BAR-14.0)];
    inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
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
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    //entryImageView.frame = CGRectMake(53, 5, 214, HEIGHT_INPUT_BAR_BUTTON);
    //entryImageView.frame = CGRectMake(53, 5, winSize.width - 54 - 5 - 3, HEIGHT_INPUT_BAR_BUTTON);
    entryImageView.frame = CGRectMake(10, 5, winSize.width - 66 , HEIGHT_INPUT_BAR-10.0);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)];
    singleTouch.delegate = self;
    [inputTextView addGestureRecognizer:singleTouch];
    
    
    UIImage *rawBackground = [UIImage imageNamed:@"friend/bg_message_entry.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImageView *entryBackgroundImageView = [[UIImageView alloc] initWithImage:background];
    entryBackgroundImageView.frame = CGRectMake(0, 0, inputBar.frame.size.width, inputBar.frame.size.height);
    entryBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryBackgroundImageView.userInteractionEnabled = YES;
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 33 -10-7, (HEIGHT_INPUT_BAR - 33.0)/2.0, 43.0, 33.0);
    sendButton.tag = 124;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_common_2-p.png"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendTextMsg) forControlEvents:UIControlEventTouchUpInside];
    
    [inputBar addSubview:entryBackgroundImageView];
    [inputBar addSubview:entryImageView];
    [inputBar addSubview:inputTextView];
    [inputBar addSubview:sendButton];
    
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
        
        NSLog(@"recordStart");
    }
}


/*
 * 松开手录音结束并发送
 */
-(void)recordEnd:(id)sender{
    
    NSLog(@"recordEnd");
    if (isRecording) {
        
        [audioButn setTitle:@"按住说话" forState:UIControlStateNormal];
        [audioButn setTitle:@"手指松开取消录音" forState:UIControlStateHighlighted];
        
        isRecording = NO;
        [countDownTimer invalidate];
        
        NSURL *url = [recordAudio stopRecord];
        
        endRecordTime = [NSDate timeIntervalSinceReferenceDate];
        endRecordTime -= startRecordTime;
        
        //NSLog(@"cha:%lf",endRecordTime);
        
        recordSec = endRecordTime;//录制时长 经测试 秒数没有做特殊处理 去掉了小数点后边的数字 例：2.6 -> 2
        
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
    
	if(secondsCountDown == 0){//60秒停止
        
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
        case ChatSelectTool_Pic:
            [self actionOpenPhotoLibrary];
            break;
        case ChatSelectTool_Camera:
            //[self actionUseCamera];
            [Utilities takePhotoFromViewController:self];//update by kate 2015.04.17
            break;  
        default:
            break;
    } 
}

// 点击语音按钮
-(void)AudioClick:(id)sender{

//    UIImage *image = [UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"];
////    if (AudioBtn.imageView.image == image) {
//    if ([Utilities image:AudioBtn.imageView.image equalsTo:image]) {
//        audioButn.hidden = NO;
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/board_system.png"] forState:UIControlStateNormal];
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/board_system_press.png"] forState:UIControlStateHighlighted];
//        keyboardButtonType = BTN_KEYBOARD;
//        
//        [inputTextView resignFirstResponder];
//        
//
//    }else{
//        
//        audioButn.hidden = YES;
//
//        UIImage *image = [UIImage imageNamed:@"faceImages/faceBoard/board_system_press.png"];
////        if (AudioBtn.imageView.image == image) {
//        if ([Utilities image:AudioBtn.imageView.image equalsTo:image]) {
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
//            [inputTextView becomeFirstResponder];
//        }else{
//            NSLog(@"");
//            [self sendTextMsg];
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
//            [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
//            [inputTextView resignFirstResponder];
//        }
//        
//    }
    
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
            NSLog(@"");
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
//    inputTextView.alpha = 1;
//    entryImageView.alpha = 1;
//    
//    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_system.png"] forState:UIControlStateNormal];
//    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_system_press.png"] forState:UIControlStateHighlighted];
//    inputTextView.internalTextView.inputView = faceBoard;
//    showSelectTool = YES;
    
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
//    inputTextView.alpha = 1;
//    entryImageView.alpha = 1;
//    
//    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji.png"] forState:UIControlStateNormal];
//    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji_press.png"] forState:UIControlStateHighlighted];
//    inputTextView.internalTextView.inputView = normalKeyboard;
//    showSelectTool = NO;
    
    inputTextView.alpha = 1;
    entryImageView.alpha = 1;
    
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_d.png"] forState:UIControlStateNormal];
    [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bq_p.png"] forState:UIControlStateHighlighted];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_d.png"] forState:UIControlStateNormal];
    [actionBtnText setBackgroundImage:[UIImage imageNamed:@"btn_tj_p.png"] forState:UIControlStateHighlighted];
    inputTextView.internalTextView.inputView = normalKeyboard;
    showSelectTool = NO;
}

/*//变成工具输入模式
- (void)changeToKeyboardTool
{
    if (isActionStart) { //打开相机，相册，录制语音中不响应点击消息事件
        return;
    }  
    
    [inputTextView resignFirstResponder];
    
    //[self selectPicConfirm];
    
    if (showSelectTool) {
        showSelectTool = NO;
        //[self changeToKeyboardText];
    }
    //else {
        inputTextView.text = @"";
        inputTextView.alpha = 1;
        entryImageView.alpha = 1;
       [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji.png"] forState:UIControlStateNormal];
       [keyboardBtn setBackgroundImage:[UIImage imageNamed:@"faceImages/faceBoard/board_emoji_press.png"] forState:UIControlStateHighlighted];
        keyboardButtonType = BTN_KEYBOARD;
        AudioBtn.frame = CGRectMake(320-33-5,AudioBtn.frame.origin.y, 33, 33);;
        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];

        inputTextView.internalTextView.inputView = selectTool;
        showSelectTool = YES;
        [inputTextView becomeFirstResponder];
    //}
}*/

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
    
//    if ([_textView.text length] > 0) {
//        
//        AudioBtn.frame = CGRectMake(320-33-5-5, AudioBtn.frame.origin.y, 47, 33);
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"] forState:UIControlStateNormal];
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"] forState:UIControlStateHighlighted];
//    }else{
//        
//        AudioBtn.frame = CGRectMake(320-33-5, AudioBtn.frame.origin.y, 33, 33);;
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
//        [AudioBtn setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
//    }
    
    if ([_textView.text length] > 0) {
        
        AudioBtn.frame = CGRectMake(WIDTH-40-2, AudioBtn.frame.origin.y, 40, 33);
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"byn_fs_p.png"] forState:UIControlStateHighlighted];
    }else{
        
        AudioBtn.frame = CGRectMake(WIDTH-33-5, AudioBtn.frame.origin.y, 33, 33);;
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_d.png"] forState:UIControlStateNormal];
        [AudioBtn setImage:[UIImage imageNamed:@"btn_yy_p.png"] forState:UIControlStateHighlighted];
    }
    
    /*CGSize size = textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
  
    }*/
}

- (void)didReceiveMsg:(NSNotification *)notification
{
    ChatDetailObject *msgObject = (ChatDetailObject *)[notification object];
    if (!msgObject) {
        return;
    }
    
//    BOOL recivce = NO;
//    if ((chatTargetQuter)&&(msgObject.from_uuid == chatTargetQuter.uuid)&&(msgObject.groupId == 0)) {
//        recivce = YES;
//    }
//    
//    if (recivce) {
//        NSInteger lastRow;
//        // 更新聊天数据后刷新画面
//        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", msgObject.msg_id]];
//        if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
//            [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:msgObject];
//            lastRow = [chatDetailArray count] - 1;
//            if([chatDetailArray count] == 1){
//                //                    msgObject.showTimeLabel = YES;
//            }
//        } else {
//            lastRow = [chatDetailArray count] - 1;
//            [chatDetailArray addObject:msgObject];
//            [self setChatDetailObjectTimeLabel:msgObject];
//            [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", msgObject.msg_id]];
//        }
//        
//        NSArray *visibleRows = [chatTableview visibleCells];
//        UITableViewCell *lastVisibleCell = [visibleRows lastObject];
//        NSIndexPath *path = [chatTableview indexPathForCell:lastVisibleCell];
//        if (path.row == lastRow) {
//            //已经滚动到底部，继续滚
//            [chatTableview reloadData];
//            [self performSelector:@selector(scrollTableViewToBottom) withObject:nil afterDelay:0.3];
//        } else {
//            [chatTableview reloadData];
//        }
//    } else {
//        if(((chatTargetQuter)||(chatTargetGroup))&&(msgObject.msg_state == MSG_RECEIVED_SUCCESS)){
//            //聊天界面中收到了 聊天对象以外人发来的消息，需要响叮咚
//            [[EnvironmentCenter GetInstance] onReceiveNewMessage];
//        }
//    }
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
//       [heightArray removeAllObjects];
//    }
    
     earliestRowID = [dictionary.allKeys count];
    
    for (int listCnt = [dictionary.allKeys count] - 1; listCnt >= 0; listCnt--) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        ChatDetailObject *ChatDetail = [[ChatDetailObject alloc] init];
        
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
        ChatDetail.audioSecond = [[Utilities replaceNull:[chatObjectDict objectForKey:@"audioSecond"]] intValue];//add 2015.07.07

        ChatDetail.msg_content = [self sqliteEscape:ChatDetail.msg_content];
        //NSLog(@"msg_content:%@",ChatDetail.msg_content);
        
        // 更新聊天数据后刷新画面
        NSNumber *indexOfMsg = [msgIndexDic objectForKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
        if (indexOfMsg && ([chatDetailArray count] > [indexOfMsg intValue])) {
            
            [chatDetailArray replaceObjectAtIndex:[indexOfMsg intValue] withObject:ChatDetail];
            [self setChatDetailObjectTimeLabel:ChatDetail];
            
        } else {
            
            [chatDetailArray addObject:ChatDetail];
            [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", ChatDetail.msg_id]];
            [self setChatDetailObjectTimeLabel:ChatDetail];
            
            //---add 2015.07.25----------------------------------------------
            float height = [self getCellHeight:ChatDetail];
            [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
            //-----------------------------------------------------------------
            
        }
        
        //NSLog(@"original:%@",ChatDetail.pic_url_original);
    }
}

// update by kate 2014.11.03 11:53
- (void)updateFeedbackChatDetailArray:(NSMutableArray*)array
{

    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];
    
    [heightArray removeAllObjects];
    
    for (int i=0; i < [array count]; i++) {
        
        NSMutableDictionary *chatObjectDict = [array objectAtIndex:i];
        
        ChatDetailObject *ChatDetail = [[ChatDetailObject alloc] init];
        //ChatDetail.msginfo_id = [[chatObjectDict objectForKey:@"msginfo_id"] intValue];
        long long fromId = [[chatObjectDict objectForKey:@"msgfromid"] longLongValue];
        if (fromId == [uid longLongValue]) {
            ChatDetail.is_recieved = 0;
        }else{
            ChatDetail.is_recieved = 1;
        }
        
        ChatDetail.msg_type = MSG_TYPE_TEXT;
        ChatDetail.msg_content = [Utilities replaceNull:[chatObjectDict objectForKey:@"message"]];
        ChatDetail.timestamp = [[chatObjectDict objectForKey:@"dateline"] longLongValue]*1000;
        //NSLog(@"getTimestam:%lli",ChatDetail.timestamp);
        [chatDetailArray addObject:ChatDetail];
        [self setChatDetailObjectTimeLabel:ChatDetail];
        
        //---add 2015.07.25----------------------------------------------
        float height = [self getCellHeight:ChatDetail];
        [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
        //-----------------------------------------------------------------
        
    }
    
    // 插入固定行
    if ([timeFirst length] == 0) {
        timeFirst = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFirst"];
    }
    
    
    ChatDetailObject *ChatDetail0 = [[ChatDetailObject alloc] init];
    ChatDetail0.is_recieved = 1;
    ChatDetail0.msg_type = MSG_TYPE_TEXT;
    ChatDetail0.msg_content = @"您可以将您的疑问或建议发给我们，我们会尽快回复您。";
    ChatDetail0.timestamp = [timeFirst longLongValue]*1000;
    //NSLog(@"getTimestam:%lli",ChatDetail0.timestamp);
    [chatDetailArray insertObject:ChatDetail0 atIndex:0];
    [self setChatDetailObjectTimeLabel:ChatDetail0];
    
    //---add 2015.07.25----------------------------------------------
    float height = [self getCellHeight:ChatDetail0];
    [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
    //-----------------------------------------------------------------

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

- (BOOL)deleteChatMessage:(long long)msgid
{
    NSString *tableName = [[NSString alloc] initWithFormat:@"msgInfo_%lli", user.user_id];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from  %@  where msg_id = %lli", tableName, msgid];
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    //[tableName release];
    //[sql release];
    return ret;
}

//删除资源文件
- (void)deleteChatFile:(ChatDetailObject*)object
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
            
            ChatDetailObject *entityForAudio = object;
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
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重发", @"删除", nil];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
	sheet.tag = TAG_ACTIONSHEET_RESEND;
    sheet.destructiveButtonIndex = 1;
	[sheet showInView:self.view];
	//[sheet release];
}

// 输入栏左边的发送图片功能按钮
- (void)selectPicConfirm
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
	sheet.tag = TAG_ACTIONSHEET_PHOTO;
	[sheet showInView:self.view];
	//[sheet release];
}

// update by kate 2014.11.03
- (void)createTextMessage:(NSString *)msgContent
{
   
    ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];//msgId本地算出
    chatDetail.user_id = user.user_id;
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
    [self clearCacheCheck];
    
    
    if ([_fromName isEqualToString:@"feedback"]) {
        
        [chatDetailArray addObject:chatDetail];
        [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
        float height = [self getCellHeight:chatDetail];
        [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
        [self setChatDetailObjectTimeLabel:chatDetail];
        [chatTableview reloadData];
        [self scrollTableViewToBottom];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *msgError = [FRNetPoolUtils sendFeedback:msgContent];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (msgError == nil) {
                    // 发送成功
                    chatDetail.msg_state = MSG_SEND_SUCCESS;
                    [ReportObject event:ID_SEND_FEEDBACK];//2015.06.25
                    
                } else {
                    // 发送失败
                    chatDetail.msg_state = MSG_SEND_FAIL;
                    
                }
               
                [chatTableview reloadData];
            });
        });
        
    }else{
        
        [ReportObject event:ID_SEND_MESSAGE];// 2015.06.24
        
        //[chatDetail updateToDB];// update 2015.08.12
        
         ChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
        [chatDetailArray addObject:chatDetail];
        [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];

        float height = [self getCellHeight:chatDetail];
        [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
        
        [self setChatDetailObjectTimeLabel:chatDetail];
        [chatTableview reloadData];
        [self scrollTableViewToBottom];
        
    
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Message",@"ac",
                              @"send", @"op",
                              [NSString stringWithFormat:@"%lli",chatDetail.user_id], @"fuid",
                              [NSString stringWithFormat:@"%lli",chatDetail.msg_id],@"msgid",
                              [NSString stringWithFormat:@"%li",(long)chatDetail.msg_type],@"type",
                              chatDetail.msg_content,@"message",
                              nil];
        
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            //NSLog(@"respDic:%@",respDic);
            
            if ([result integerValue] == 1) {
                
                // 发送成功
                NSDictionary *dic = [respDic objectForKey:@"message"];
                
                chatDetail.msg_state = MSG_SEND_SUCCESS;
                chatDetail.timestamp  = [[dic objectForKey:@"timestamp"] longLongValue]*1000;
                [chatTableview reloadData];// update 2015.08.12
                [chatDetail updateToDB];
                
                isScrollToBottom = YES;
                
            }else{
                
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                [chatTableview reloadData];// update 2015.08.12
                [chatDetail updateToDB];
            
            }
            
            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            [chatList updateToDB];
            //[chatTableview reloadData];
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
            chatDetail.msg_state = MSG_SEND_FAIL;
            chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
            [chatTableview reloadData];// update 2015.08.12
            [chatDetail updateToDB];
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            [chatList updateToDB];
            //[chatTableview reloadData];

        }];
        
    }
  
}

- (void)createPicMessage:(NSData*)imageData
{
    ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    chatDetail.user_id = user.user_id;
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_SEND;
    //消息类型-图片
    chatDetail.msg_type = MSG_TYPE_PIC;
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_SENDING;
    // 消息内容
    chatDetail.msg_content = @"[图片]";
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = [self savePicToLocal:chatDetail.msg_id imageData:imageData];
    // 原始图片文件的HTTP-URL地址
    chatDetail.pic_url_thumb = @"";
    chatDetail.pic_url_original = @"";
    // 时间戳
    chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    [self clearCacheCheck];
    
    [chatDetail updateToDB];
    
    [ReportObject event:ID_SEND_MESSAGE];// 2015.06.24
    
    ChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    //表示要不要显示时间戳
//    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[chatDetailArray count] - 1 inSection:0]; 
//    MsgDetailCell *cell = (MsgDetailCell *)[chatTableview cellForRowAtIndexPath:lastIndexPath];
//    [self setChatDetailObjectTimeLabel:chatDetail];
//    if (chatDetail.showTimeLabel) {
//        cell.timeLabel.alpha = 1;
//    } else{
//        cell.timeLabel.alpha = 0;
//    }
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *sendFlag = [FRNetPoolUtils sendMsg:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
          if ([sendFlag isEqualToString:@"NO"]) {
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                
                [chatDetail updateToDB];
                //[(ChatDetailObject *)[chatDetailArray lastObject] setMsg_state:MSG_SEND_FAIL];
                
                //if (![sendFlag isEqualToString:@"NO"]) { // 发送失败，被乘客端屏蔽
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                        message:@"消息发送失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil,nil];
                    [alertView show];
                    //[alertView release];
                //}
            }else{
                
                    // 发送成功
                    // 发送消息成功，gps上报
                    DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                    [dr dataReportGPStype:@"DataReport_Act_PhoneBook_SendMsg"];
                    
                    chatDetail.msg_state = MSG_SEND_SUCCESS;
                    chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                    
                    [chatDetail updateToDB];
                    
                    //[MobClick event:Report_SendPictureMessage];
                    //[ReportObject event:Report_Event_NO_SendPictureMessage];
                
                isScrollToBottom = YES;
                
            }
            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            
            [chatList updateToDB];
            
            [chatTableview reloadData];
        });
    });
    
//2015.07.09
#if 0
    for (int i=0; i<[chatDetailArray count]; i++) {
        
        ChatDetailObject *entity;
        entity = [chatDetailArray objectAtIndex:i];

        NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];// update by kate 2015.03.27
        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
        
        if (![@""  isEqual: thumbImagePath]) {
            
            if(entity.msg_type == MSG_TYPE_PIC){
                if (0 == [_pics count]) {
                    [_pics addObject:thumbImagePath];
                }else {
                    NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:thumbImagePath];
                    
                    if (-1 == pos) {
                        [_pics addObject:thumbImagePath];
                    }
                }
                
            }
          
        }

        
    }
    
#endif
  
}

- (void)createAudioMessage:(NSData*)audioData
{
    /*done: 语音文件前边加上秒数显示
     
    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
    NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
    
    NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
    
    NSString *dur = [NSString stringWithFormat:@"%ld″", (long)[recordAudio dataDuration:fileData]];*/
    
    ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    chatDetail.user_id = user.user_id;
    // 消息的发送(0)接收(1)区分
    chatDetail.is_recieved = MSG_IO_FLG_SEND;
    //消息类型-图片
    chatDetail.msg_type = MSG_TYPE_Audio;
    // 消息状态：发送，已读，未读，失败等
    chatDetail.msg_state = MSG_SENDING;
    // 消息内容
    chatDetail.msg_content = @"[语音]";
    // 文件名（语音，图片，涂鸦）
    chatDetail.msg_file = [self saveAudioToLocal:chatDetail.msg_id audioData:audioData];
    // 原始图片文件的HTTP-URL地址
    chatDetail.pic_url_thumb = @"";
    chatDetail.pic_url_original = @"";
    // 时间戳
    chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    // 语音秒数
    if (recordSec > 60) {//2015.11.13
        recordSec = 60;
    }
    
    chatDetail.audioSecond = recordSec;//add 2015.11.03 2.9.1新需求
    
    [self clearCacheCheck];
    
    [chatDetail updateToDB];
    
    [ReportObject event:ID_SEND_MESSAGE];// 2015.06.24
    
    ChatListObject *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    //表示要不要显示时间戳
    //    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[chatDetailArray count] - 1 inSection:0];
    //    MsgDetailCell *cell = (MsgDetailCell *)[chatTableview cellForRowAtIndexPath:lastIndexPath];
    //    [self setChatDetailObjectTimeLabel:chatDetail];
    //    if (chatDetail.showTimeLabel) {
    //        cell.timeLabel.alpha = 1;
    //    } else{
    //        cell.timeLabel.alpha = 0;
    //    }
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *sendFlag = [FRNetPoolUtils sendMsg:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ([sendFlag isEqualToString:@"NO"]) {
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                
                [chatDetail updateToDB];
                //[(ChatDetailObject *)[chatDetailArray lastObject] setMsg_state:MSG_SEND_FAIL];
                
                //if (![sendFlag isEqualToString:@"NO"]) { // 发送失败，被乘客端屏蔽
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                        message:@"消息发送失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil,nil];
                    [alertView show];
                    //[alertView release];
                //}
            }else{
                
                    // 发送成功
                    // 发送消息成功，gps上报
                    DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                    [dr dataReportGPStype:@"DataReport_Act_PhoneBook_SendMsg"];
                    
                    chatDetail.msg_state = MSG_SEND_SUCCESS;
                    chatDetail.timestamp = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                    [chatDetail updateToDB];
                
                    chatDetail.audioSecond = recordSec;//add 2015.07.07
                    [chatDetail updateAudio];//add 2015.07.07
                
                    //[MobClick event:Report_SendPictureMessage];
                    //[ReportObject event:Report_Event_NO_SendPictureMessage];
                
                    isScrollToBottom = YES;
                
            }
            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            
            [chatList updateToDB];
            
            [chatTableview reloadData];
        });
    });
    
   // [chatDetail release];
}

/*- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData
{
    
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:user.user_id];
    NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
    NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
    //NSString *imagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, msgid, FILE_JPG_EXTENSION];
    
    //    NSString *originalImageDir = [Utilities getChatPicOriginalDir:user.user_id];
    //    NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
    //    NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
    //
    //    UIImage *originalImage = [UIImage imageWithData:fileData];
    
    // 创建聊天缩略图片，并写入本地
    if ([fileData writeToFile:thumbImagePath atomically:YES]) {
        NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
    }
    
    //    //创建源图片，并写入本地成功
    //    if ([fileData writeToFile:originalImagePath atomically:YES]) {
    //        NSLog(@"writeToFile:%@", originalImagePath);
    //    }
    //
    //    //保存缩略图
    //    if (originalImage.size.width > 120) {
    //        float newWidth = 120;
    //        float newHeight = 120/originalImage.size.width*originalImage.size.height;
    //        originalImage = [ImageResourceLoader resizeImage:originalImage toSize:CGSizeMake(newWidth, newHeight)];
    //    }
    //
    //    if ([UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:thumbImagePath atomically:YES]) {
    //        NSLog(@"writeToFile:%@", thumbImagePath);
    //    }
    //return originalImagePath;
    return thumbImagePath;//update by kate 2015.03.27
}*/

// 发送图片存储大图 2015.07.09
- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData
{
        // 取得msgID
        NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:user.user_id];
        NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
        NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
    
        //UIImage *originalImage = [UIImage imageWithData:fileData];
    
        //创建源图片，并写入本地成功
        if ([fileData writeToFile:originalImagePath atomically:YES]) {
            NSLog(@"writeToFile:%@", originalImagePath);
        }

        return originalImagePath;
    
}

- (NSString *)saveAudioToLocal:(long long)msgid audioData:(NSData*)fileData
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    
    NSString *originalImageDir = [Utilities getChatAudioDir:user.user_id];
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
        ChatDetailObject *entity = nil;
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

- (ChatListObject *)saveMsgToChatList:(ChatDetailObject *)chatDetail
{
    
    ChatListObject *chatList = [[ChatListObject alloc] init];
    chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", user.user_id];
    chatList.is_recieved = MSG_IO_FLG_SEND;
    //最后一条消息ID
    chatList.last_msg_id= chatDetail.msg_id;
    // 聊天的最后一条消息的类型
    chatList.last_msg_type= chatDetail.msg_type;
    // 聊天的最后一条消息内容
    chatList.last_msg = chatDetail.msg_content;
    //该条消息是否已经读取
//    if (chatDetail.is_recieved == MSG_IO_FLG_SEND) {
//        chatList.msg_state = MSG_SEND_SUCCESS;
//    } else {
//        chatList.msg_state = MSG_RECEIVED_SUCCESS;
//    }
    chatList.msg_state = chatDetail.msg_state;
    chatList.user_id = user.user_id;
    if ([user.name length] > 0) {
        chatList.title = user.name;
    } else {
        chatList.title = NO_NAME_USER;
    }
    //时间戳
    chatList.timestamp = chatDetail.timestamp;
    [chatList updateToDB];
    
    return chatList;
}

- (void)showKeyBoard
{

}

//发送拍照的图片
- (void)sendTakePhotoMsg:(id)object
{
    UIImage *selectedImage =  (UIImage *)object;
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, JPG_COMPRESSION_QUALITY);
    [self createPicMessage:imageData];
}

- (void)clearCacheCheck {
    // update by kate 2014.11.19
//    if ([chatDetailArray count] > TABLE_SHOWING_COUNT ){
//        NSRange delRange = NSMakeRange(0, ([chatDetailArray count] - TABLE_SHOWING_COUNT)-1);
//        [chatDetailArray removeObjectsInRange:delRange];
//        [self reloadMsgIndexDictionaryAndMsgLabel];
//        isMoreDataLoading = NO;
//    }
}

- (void)reloadChatTableView
{
    [chatTableview reloadData];
    
    [self scrollTableViewToBottom];
}

// 播放语音
-(void)playAudio:(NSNotification*)notification{

    for (int i=0; i<[chatDetailArray count]; i++) {
        
        NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
        //---update by kate 2015.08.31 减少cellForRowAtIndexPath调用的次数优化性能-------------------------
//        MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
//        if (cellAll.msgType == CELL_TYPE_AUDIO) {
        ChatDetailObject *chatDetailForAudio = [chatDetailArray objectAtIndex:i];
        if (chatDetailForAudio.msg_type == MSG_TYPE_Audio) {
            MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
            [cellAll.audioView.animationImageView stopAnimating];
            cellAll.audioView.playImageViewSubject.hidden = NO;
        }
        //-----------------------------------------------------------------------------------------------------
    }

    
    NSMutableArray *objArray = [notification object];
    numOfCellAudioPlaying = [[objArray objectAtIndex:0] integerValue];
    
//    for (int i=0; i<[chatDetailArray count]; i++) {
//        
//        NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
//        //---update by kate 2015.08.31 减少cellForRowAtIndexPath调用的次数优化性能-------------------------
//        //        MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
//        //        if (cellAll.msgType == CELL_TYPE_AUDIO) {
//        ChatDetailObject *chatDetailForAudio = [chatDetailArray objectAtIndex:i];
//        if (chatDetailForAudio.msg_type == MSG_TYPE_Audio) {
//            MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
//            
//            if ([cellAll.index integerValue] == numOfCellAudioPlaying) {
//                NSLog(@"cellAll.index:%@",cellAll.index);
//                [cellAll.audioView.animationImageView startAnimating];
//                cellAll.audioView.playImageViewSubject.hidden = YES;
//
//            }else{
//                [cellAll.audioView.animationImageView stopAnimating];
//                cellAll.audioView.playImageViewSubject.hidden = NO;
//  
//            }
//            
//        }
//        //-----------------------------------------------------------------------------------------------------
//    }
//
    
    ChatDetailObject *entityForAudio = [objArray objectAtIndex:1];
    NSString *audioDir = [Utilities getChatAudioDir:entityForAudio.user_id];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
   
    
    NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
    
    if (fileData == nil) {
        
        [Utilities showFailedHud:@"没有语音文件" descView:self.view];
        //----add 2015.11.03-------------------------------------
        entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
        [entityForAudio updateAudioState];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //--------------------------------------------------------
        
    }else{
        
        if(fileData.length>0){
            
            if (entityForAudio.audioSecond == 0) {
                entityForAudio.audioSecond = [recordAudio dataDuration:fileData];
                [entityForAudio updateAudio];
                entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
                [entityForAudio updateAudioState];
                //---update 2015.08.31 更新单条语音-----------------------------------------------------------
                //[self getChatDetailData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                //---------------------------------------------------------------------------------------------
            }else{
                //----add 2015.11.03-------------------------------------
                entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
                [entityForAudio updateAudioState];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                //--------------------------------------------------------
 
            }
        
            [recordAudio handleNotification:YES];//2015.11.16
            [recordAudio play:fileData];
            
        }
    }
}

// 播放状态回调方法
-(void)RecordStatus:(int)status
{
    // 0-播放中 1-播放完成 2-播放错误
    if (status == 0) {
        
        NSLog(@"status == 0");
        
       NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        MsgDetailCell *cell = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPath];
        
        // 开始点击cell的播放效果
        [cell.audioView.animationImageView startAnimating];
        cell.audioView.playImageViewSubject.hidden = YES;
        

    }else if (status == 1){
        
        NSLog(@"status == 1");
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        MsgDetailCell *cell = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPath];
        
        [cell.audioView.animationImageView stopAnimating];
        cell.audioView.playImageViewSubject.hidden = NO;
        
        numOfCellAudioPlaying = -1;//add 2015.10.19 以上代码 语音那行cell滚出屏幕时并没有stop，加上此句代码
        
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"audioDone"
//                                                            object:nil];
        
    }else if (status == 2){
        
        NSLog(@"status == 2");
        
    }
    
}

- (void)showZoomPic:(NSNotification *)notification
{
    [ReportObject event:ID_SHOW_ZOOM_PIC];//点击查看大图
    
    [inputTextView resignFirstResponder];
    
    ChatDetailObject *entityForpic = [notification object];
    
    if ([[self.navigationController topViewController] isKindOfClass:[MsgZoomImageViewController class]]) {
        return;
    }
    
    
    NSString *fileUrl = @"";
    // 此路径保存大图
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:entityForpic.user_id];
    NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entityForpic.msg_id, FILE_JPG_EXTENSION];
    
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entityForpic.user_id];
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entityForpic.msg_id,FILE_JPG_EXTENSION];
    
    NSData *fileData = [NSData dataWithContentsOfFile:originalImagePath];
    NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容老版本已经存在手机里的图片

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
    
    if ([fileUrl length] == 0) {//update 2015.07.16
        return;
    }
    
     // add 2015.07.20 当缩略图没有下载成功，点击时再下载一次
    if (entityForpic.is_recieved == MSG_IO_FLG_RECEIVE) {
        if (!fileData2) {
            
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
        
        ChatDetailObject *entity;
        entity = [chatDetailArray objectAtIndex:i];
        
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:entity.user_id];
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        
        NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];
        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
        
        if (entity.msg_type == MSG_TYPE_PIC) {
            
            NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
            NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容老版本已经存在手机里的图片
            
            NSString *imgUrl = @"";
            
            if ([entity.pic_url_original length] > 0) {//收图片
                if (fileData) {
                    imgUrl = originalImagePath;
                }else{
                    imgUrl = entity.pic_url_original;
                }
            }else{//发图片
                if (fileData) {
                    imgUrl = originalImagePath;
                }else if (fileData2){
                    imgUrl = thumbImagePath;
                }
            }
            
            if ([imgUrl length] > 0) {//update 2015.07.16
               [_pics addObject:imgUrl];
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
        //NSLog(@"%@", pic_url);
        
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
    
    browser.photos = photos;
    [browser show];
    
#if 0
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entityForpic.user_id];// update by kate 2015.03.27
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entityForpic.msg_id,FILE_JPG_EXTENSION];
    
    //NSLog(@"%@", entityForpic.msg_file);
   // NSLog(@"%@", originalImagePath);


    
    //NSInteger isReceiveFlag = entityForpic.is_recieved;
    
    //NSString *imgUrl = entityForpic.pic_url_thumb;
    //NSString *aaa = entityForpic.msg_file;

    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    }
    
    NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:thumbImagePath];
    
    if (-1 != pos) {
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = pos;
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_pics count]];
        
        for (int i = 0; i<[_pics count]; i++) {
            NSString *pic_url = [_pics objectAtIndex:i];
//            NSLog(@"%@", pic_url);
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.save = NO;
//            photo.url = [NSURL URLWithString:pic_url];
            UIImage *a = [UIImage imageWithContentsOfFile:pic_url];
            photo.image = a;
            photo.srcImageView = imageView;
            [photos addObject:photo];
        }
        
        browser.photos = photos;
        [browser show];
    }

#endif

    
}

- (void)showUserInfo:(NSNotification *)notification
{
    if (![Utilities connectedToNetwork]) {
        [Utilities showAlert:@"错误" message:NetworkNotConnected cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = [NSString stringWithFormat:@"%lld", user.user_id];
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];

//    if ([self.frontName isEqualToString:@"user"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        SalesmenViewController *salesmenDeatilsController = [[SalesmenViewController alloc] init];
//        salesmenDeatilsController.user = user;
//        salesmenDeatilsController.frontName = @"chat";
//        [self.navigationController pushViewController:salesmenDeatilsController animated:YES];
//        [salesmenDeatilsController release];
//    }
}

- (void)showSelfInfo:(NSNotification *)notification
{
//    IndividualCenterViewController *selfDeatilsController = [[IndividualCenterViewController alloc] init];
//    selfDeatilsController.frontName = @"chat";
//    [self.navigationController pushViewController:selfDeatilsController animated:YES];
//    [selfDeatilsController release];
}

- (void)changeUser:(NSNotification *)notification
{
    UserObject *chatUser = (UserObject *)[notification object];
    self.user = chatUser;
    if ([user.name length] > 0) {
        self.title = user.name;
    } else {
        self.title = NO_NAME_USER;
    }
    [self getChatDetailData];
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

/**
 * 更新与朋友的最后聊天信息ID
 * v=1, ac=Message, op=update, sid=, uid=, friend=, last=消息ID
 * 2011.11.19
 */
-(void)tellServerLastMsgId:(NSString*)friend last:(NSString*)msgId{
    
//    NSLog(@"friend:%@",friend);
//    NSLog(@"msgId:%@",msgId);
    
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Message",@"ac",
                          @"1",@"v",
                          @"update", @"op",
                          friend, @"friend",
                          msgId,@"last",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"11111");
        }else{
            NSLog(@"00000");
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}

@end

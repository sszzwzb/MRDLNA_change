//
//  GroupChatDetailViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/28.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatDetailViewController.h"
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

@interface GroupChatDetailViewController ()

- (float)getCellHeight:(GroupChatDetailObject *)entity;

// TableView 滚动到底部显示最后的聊天消息
- (void)scrollTableViewToBottom;

// 判断是否需要加载更多聊天数据
- (void)needShowMoreByRowID:(NSInteger)rowID;

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

@implementation GroupChatDetailViewController

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
        waitForLoadMore.frame = CGRectMake(150.0f, 5.0f, 20.0f, 20.0f);
        
        self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        
        uid = [[userInfo objectForKey:@"uid"] longLongValue];
        
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

////    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(getChatData:)
//                                                 name:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatDetailData)
                                                 name:NOTIFICATION_DB_GET_CHAT_DETAIL_DATA_GROUP
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadMoreChatsListData:)
//                                                 name:NOTIFICATION_DB_GET_MORECHATINFODATA
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showZoomPic:)
                                                 name:NOTIFICATION_UI_TOUCH_IMAGE_GROUP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playAudio:)
                                                 name:NOTIFICATION_UI_TOUCH_PLAY_AUDIO_GROUP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUserInfo:)
                                                 name:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_GROUP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMsg:)
                                                 name:NOTIFICATION_UI_DELETE_MSG_GROUP
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(transpondMsg:)
//                                                 name:NOTIFICATION_UI_TANSPOND_MSG
//                                               object:nil];
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    numOfCellAudioPlaying = -1;
    
    if (isReGetChatDetailData) {//update 2015.08.13
        
        [self changeTitle];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"GroupChatDetailView" forKey:@"viewName"];
        [userDefaults synchronize];
        NSString *viewName = [userDefaults objectForKey:@"viewName"];
        NSLog(@"viewName:%@",viewName);
        
        isMoreDataLoading = NO;
        isScrollToBottom = YES;
        
        [self checkGroupMember];
        
        [self getChatDetailData];
    }
    
    
}

-(void)changeTitle{
    
    //To do: 检查DB中这条群聊对应的聊天详情的bother标实是什么。以此来决定navigation的title是否显示免打扰图片
    
    NSString *sql =  [NSString stringWithFormat:@"select bother from msgListForGroup_%lli where gid = %lli",_cid,gid];
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
    
    NSString *updateDetailsSql =[NSString stringWithFormat: @"update msgInfoForGroup_%lli set msg_state = %d where is_recieved = %d and msg_state != %d", gid, MSG_READ_FLG_READ, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
    [[DBDao getDaoInstance] executeSql:updateDetailsSql];
    
    NSString *updateListSql =[NSString stringWithFormat: @"update msgListForGroup_%lli set msg_state = %d where is_recieved = %d and msg_state != %d and gid = %lli", _cid,MSG_READ_FLG_READ, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ, gid];
    [[DBDao getDaoInstance] executeSql:updateListSql];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    isReGetChatDetailData = YES;//add 2015.08.13

    GroupChatSettingViewController *groupChatSet = [[GroupChatSettingViewController alloc]init];
    groupChatSet.gid = [NSString stringWithFormat:@"%lld", gid];
    groupChatSet.groupChatList = _groupChatList;
    [self.navigationController pushViewController:groupChatSet animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//2015.09.09
    
}

// 聊天页超链接从webView打开
-(void)gotoWebView:(NSNotification*)notification{
    
    isReGetChatDetailData = YES;// add 2015.08.13
    
    NSURL *url = [notification object];
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
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
    
    NSLog(@"2heightArrayCount:%lu",(unsigned long)[heightArray count]);
    
    GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:indexPath.row];
    
    CGFloat cellheight = TIME_HEIGHT;//预留的时间label
    cellheight = cellheight + [[heightArray objectAtIndex:indexPath.row] floatValue];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        cellheight += 10.0;
    }
    
    NSLog(@"%ld-height:%f",(long)indexPath.row,[[heightArray objectAtIndex:indexPath.row] floatValue]);
    
    return cellheight+10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    GroupChatDetailObject *entity;
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
    
    //NSLog(@"scrollView.contentOffset:%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    /*newContentOffsetY = scrollView.contentOffset.y;
    
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
        
        //NSLog(@"up");
        scrollFlag =2;
        
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
        
        //NSLog(@"down");
        scrollFlag =1;
        
    } else {
        //NSLog(@"dragging");
        scrollFlag = 0;
        
    }*/
    
    if (!isMoreDataLoading && scrollView.contentOffset.y < 0) {
        //        isMoreDataLoading = YES;
        NSLog(@"earliestRowID:%d",earliestRowID);
        [self needShowMoreByRowID];
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    contentOffsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    // NSLog(@"scrollViewDidEndDragging");
    
    oldContentOffsetY = scrollView.contentOffset.y;
    
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
        
        return YES;
        
    }
    
    if (growingTextView.text.length + text.length > MAX_TEXTLENGTH) {// 50000 这样写是为了避免输入法联想字数超出上限 2015.07.21
        //达到输入的上线
        return NO;
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
                        GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
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
                            GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:[indexOfMsg intValue]];
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
                        NSString *sendFlag = [FRNetPoolUtils sendMsgForGroup:resendMsg];
                        
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
                            @"GroupChat",@"ac",
                            @"2",@"v",
                            @"send", @"op",
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
                            
                            NSDictionary *tempDic = [respDic objectForKey:@"message"];
                            NSDictionary *dic = [tempDic objectForKey:@"message"];
                            
                            // 发送成功
                            resendMsg.msg_state = MSG_SEND_SUCCESS;
                            resendMsg.timestamp  = [[dic objectForKey:@"dateline"] longLongValue]*1000;
                            
                            
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
                                    
                                    GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
                                    entity.reflashFlag = @"0";
                                    [chatDetailArray replaceObjectAtIndex:i withObject:entity];
                                }
                                
                                [chatTableview reloadData];
                                
                                [self deleteChatFile:resendMsg];
                                GroupChatDetailObject *chatDetail = [chatDetailArray lastObject];
                                _groupChatList.last_msg = chatDetail.msg_content;
                                [_groupChatList updateToDB];
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


// 删除的回调方法
-(void)deleteMsg:(NSNotification *)notification{
    
    GroupChatDetailObject *deleteMsg = notification.object;
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
                        
                        GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
                        entity.reflashFlag = @"0";
                        [chatDetailArray replaceObjectAtIndex:i withObject:entity];
                    }
                    
                    [chatTableview reloadData];
                   
                    [self deleteChatFile:deleteMsg];
                    
                    if ([chatDetailArray count] == 0) {
                        
                        _groupChatList.timestamp = deleteMsg.timestamp;
                        _groupChatList.last_msg = @"";
                        [_groupChatList updateToDB];
                        
                    }else{
                        
                        GroupChatDetailObject *chatDetail = [chatDetailArray lastObject];
                        _groupChatList.last_msg = chatDetail.msg_content;
                        [_groupChatList updateToDB];
                        
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

// 收消息通知
-(void)getChatData:(NSNotification*)notify{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isReload = NO;
        
        NSMutableArray *tempArray = (NSMutableArray*)[notify object];
        if ([tempArray count] > 0) {
            
            for (int i =0; i<[tempArray count]; i++) {
                
                GroupChatDetailObject *chatDetail = [tempArray objectAtIndex:i];
                
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
// 2015.09.09
//    if (!isMoreDataLoading && isScrollToBottom) {
//        // 清除数据
//        if ([chatDetailArray count] > 0) {
//            [chatDetailArray removeAllObjects];
//        }
//        
//        if ([msgIndexDic count] > 0) {
//            [msgIndexDic removeAllObjects];
//        }
//        self.currentShowTime = nil;
//    }
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli", gid];
    
    NSInteger iCnt = [[DBDao getDaoInstance] getResultsToInt:sql];
    if (iCnt > 0) {
        
        // 分页显示sql文
        NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC limit %d, %d", gid, 0, TABLE_SHOWING_COUNT];
        // 查询SQL文
//        NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC", gid];
        //执行SQL
        NSMutableDictionary *retDictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
        [self updataChatDetailArray:retDictionary];
        
        [chatTableview reloadData];// update 2015.07.07
    }

    if (!isMoreDataLoading && isScrollToBottom) {//2015.08.27
        [self scrollTableViewToBottom];
    }
    
}

- (void)updateCellWithEntity:(MsgDetailCell *)cell entity:(GroupChatDetailObject *)entity updateState:(BOOL)updateState
{
    cell.msgType = CELL_TYPE_TEXT;
    
    if (entity.msg_type == MSG_TYPE_PIC) {
        cell.msgType = CELL_TYPE_PIC;
    }else if (entity.msg_type == MSG_TYPE_Audio){
        cell.msgType = CELL_TYPE_AUDIO;
        
        if([cell.index integerValue] == numOfCellAudioPlaying){//add 2015.10.15
            
            cell.audioView.isStart = YES;
            
        }else{
            
            cell.audioView.isStart = NO;
            
        }
        
    }else if (entity.msg_type == 3){
        cell.msgType = CELL_TYPE_System;
    }else if (entity.msg_type == 4){
        cell.msgType = CELL_TYPE_Remove;
    }else if (entity.msg_type == 5){
        cell.msgType = CELL_TYPE_Leave;
    }
    
    [cell updataCellForGroup:entity updateState:updateState];
    
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
        
        cell.nameLabel.text = entity.userName;
        cell.nameLabel.alpha = 1;
    }else{
        cell.nameLabel.alpha = 0;
    }
    
}

- (float)getCellHeight:(GroupChatDetailObject*)entity
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
- (float)getPicMessageHeight:(GroupChatDetailObject*)entity
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
- (float)getTextMessageHeight:(GroupChatDetailObject*)entity
{
    float height = 0;
// update 2015.08.01
//    MsgTextView *textView = [[MsgTextView alloc] init];
//    height = [textView getTextHeightForGroup:entity] + 20;
    
    height = [MsgTextView heightForEmojiText:entity.msg_content].height+5.0f*2;
    
    return height;
}

// 获取文本信息高度
- (float)getSystemMessageHeight:(GroupChatDetailObject*)entity
{
    float height = 0;
    
    height = [MsgSystemView getHeightForGroup:entity];
    
    return height;
}

- (void)setChatDetailObjectTimeLabel:(GroupChatDetailObject *)entity
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
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from msgInfoForGroup_%lli", gid];
    
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
    
    // 分页显示sql文
    NSString *getDataSql = [NSString stringWithFormat:@"select * from msgInfoForGroup_%lli ORDER BY timestamp DESC limit %d, %d", gid, chatArrayCount, TABLE_SHOWING_COUNT];
    
    //执行SQL
    NSMutableDictionary *dictionary = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:getDataSql];
    
    if ([dictionary.allKeys count] < 20) {
        earliestRowID = [dictionary.allKeys count];
    }
    
    for (int listCnt = 0; listCnt < [dictionary.allKeys count]; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [dictionary objectForKey:[NSNumber numberWithInt:listCnt]];
        
        GroupChatDetailObject *ChatDetail = [[GroupChatDetailObject alloc] init];
        ChatDetail.groupid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
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
        
        if (ChatDetail.msg_type == MSG_TYPE_TEXT) {
            ChatDetail.size = [MsgTextView heightForEmojiText:[Utilities replaceNull:[chatObjectDict objectForKey:@"msg_content"]]];
        }
        
        ChatDetail.userName = [Utilities replaceNull:[chatObjectDict objectForKey:@"userName"]];
        
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
//        [self setChatDetailObjectTimeLabel:ChatDetail];
//        
//        float height = [self getCellHeight:ChatDetail];
//        [heightArray insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
        
    }
    
    // 将之前的数据reflashFlag置为0
    for (int i = 0; i<[chatDetailArray count]; i++) {
        
        GroupChatDetailObject *entity = [chatDetailArray objectAtIndex:i];
        entity.reflashFlag = @"0";
        [chatDetailArray replaceObjectAtIndex:i withObject:entity];
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
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField.png"];
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
        
        GroupChatDetailObject *ChatDetail = [[GroupChatDetailObject alloc] init];
        ChatDetail.groupid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
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
        
        // update 2015.09.08
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

- (BOOL)deleteChatMessage:(long long)msgid
{
    NSString *tableName = [[NSString alloc] initWithFormat:@"msgInfoForGroup_%lli", gid];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from  %@  where msg_id = %lli", tableName, msgid];
    BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
    return ret;
}

//删除资源文件
- (void)deleteChatFile:(GroupChatDetailObject*)object
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
            
            GroupChatDetailObject *entityForAudio = object;
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
   
}

- (void)createTextMessage:(NSString *)msgContent
{
    GroupChatDetailObject *chatDetail = [[GroupChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];//msgId本地算出
    chatDetail.user_id = uid;
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
    chatDetail.cid = _cid;
    chatDetail.userName = @"";
    //[self clearCacheCheck];
    
    chatDetail.reflashFlag = @"0";

    chatDetail.size = [MsgTextView heightForEmojiText:msgContent];

//    AudioBtn.userInteractionEnabled = NO;//不让多次点击，避免多次点击卡顿 2015.07.28
    
        //[chatDetail updateToDB];//update 2015.08.12
        
        GroupChatList *chatList = [self saveMsgToChatList:chatDetail];
    
        [chatDetailArray addObject:chatDetail];
        [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
        float height = [self getCellHeight:chatDetail];
        [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
    
        [self setChatDetailObjectTimeLabel:chatDetail];
        [chatTableview reloadData];
        [self scrollTableViewToBottom];
    
        //Done:发送消息新接口
       /*
       * 发送聊天消息
       * @author luke
       * @date    2015.05.26
       * @args
       *  op=send, sid=, uid=, gid=, msgid=, type=, message=, png0=图片, arm0=语音
       */
   
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"send", @"op",
                          [NSString stringWithFormat:@"%lli,",chatDetail.groupid], @"gid",
                          [NSString stringWithFormat:@"%lli,",chatDetail.msg_id],@"msgid",
                          [NSString stringWithFormat:@"%li,",(long)chatDetail.msg_type],@"type",
                          msgContent,@"message",
                          nil];
    
    /*
     if (chatDetail.msg_type == MSG_TYPE_PIC || chatDetail.msg_type == MSG_TYPE_Audio) {
       [requestForm setFile:chatDetail.msg_file forKey:@"file"];
     }
     */
    
    
#if 9

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        AudioBtn.userInteractionEnabled = YES;// 2015.07.28
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        

        if ([result integerValue] == 1) {
            
            NSDictionary *tempDic = [respDic objectForKey:@"message"];
            NSDictionary *dic = [tempDic objectForKey:@"message"];
            
            // 发送成功
            chatDetail.msg_state = MSG_SEND_SUCCESS;
            chatDetail.timestamp  = [[dic objectForKey:@"dateline"] longLongValue]*1000;
            [chatTableview reloadData];//update 2015.08.12
            [chatDetail updateToDB];
            
            [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
            
            isScrollToBottom = YES;
            
        }else{
            
            // 发送失败
            chatDetail.msg_state = MSG_SEND_FAIL;
            chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
            [chatTableview reloadData];//update 2015.08.12
            [chatDetail updateToDB];


        }
        
        chatList.msg_state = chatDetail.msg_state;
        chatList.timestamp = chatDetail.timestamp;
        [chatList updateToDB];

        
        
//        [chatTableview reloadData];//2015.08.12
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
         AudioBtn.userInteractionEnabled = YES;// 2015.07.28
        
         [Utilities doHandleTSNetworkingErr:error descView:self.view];
         chatDetail.msg_state = MSG_SEND_FAIL;
         chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
        [chatTableview reloadData];//2015.08.12
         [chatDetail updateToDB];
         chatList.msg_state = chatDetail.msg_state;
         chatList.timestamp = chatDetail.timestamp;
         [chatList updateToDB];
         //[chatTableview reloadData];
        
    }];
    
#endif

    chatList.msg_state = chatDetail.msg_state;
    chatList.timestamp = chatDetail.timestamp;
    [chatList updateToDB];

}

- (void)createPicMessage:(NSData*)imageData
{
    GroupChatDetailObject *chatDetail = [[GroupChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    chatDetail.user_id = uid;
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
    chatDetail.groupid = gid;
    chatDetail.cid = _cid;
    chatDetail.userName = @"";
    
    chatDetail.reflashFlag = @"0";

    //[self clearCacheCheck];
    
    [chatDetail updateToDB];
    
    GroupChatList *chatList = [self saveMsgToChatList:chatDetail];
    
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
        NSString *sendFlag = [FRNetPoolUtils sendMsgForGroup:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([sendFlag isEqualToString:@"NO"]) {
               
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                [chatDetail updateToDB];
                
            }else{
               
                // 发送成功
                chatDetail.msg_state = MSG_SEND_SUCCESS;
                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                [chatDetail updateToDB];
                
                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
                
                isScrollToBottom = YES;

            }
            
//            if ([[sendFlag substringToIndex:3] isEqualToString:@"YES"]) {
//                // 发送成功
//                chatDetail.msg_state = MSG_SEND_SUCCESS;
//                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
//                [chatDetail updateToDB];
//                
//                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
//              
//            } else {
//                // 发送失败
//                chatDetail.msg_state = MSG_SEND_FAIL;
//                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
//                [chatDetail updateToDB];
//              
//            }
            
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
    GroupChatDetailObject *chatDetail = [[GroupChatDetailObject alloc] init];
    
    // 消息的msgID
    chatDetail.msg_id = [Utilities GetMsgId];
    chatDetail.user_id = uid;
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
    
    [chatDetail updateToDB];
    
//    NSLog(@"gid:%lld",gid);
//    NSLog(@"cid:%lld",_cid);
    
    GroupChatList *chatList = [self saveMsgToChatList:chatDetail];
    
    [chatDetailArray addObject:chatDetail];
    [msgIndexDic setObject:[NSNumber numberWithInt:[chatDetailArray count] - 1] forKey:[NSString stringWithFormat:@"%lli", chatDetail.msg_id]];
    
    float height = [self getCellHeight:chatDetail];
    [heightArray addObject:[NSString stringWithFormat:@"%f",height]];
   
    [self setChatDetailObjectTimeLabel:chatDetail];
    [chatTableview reloadData];
    [self scrollTableViewToBottom];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *sendFlag = [FRNetPoolUtils sendMsgForGroup:chatDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([sendFlag isEqualToString:@"NO"]) {
                // 发送失败
                chatDetail.msg_state = MSG_SEND_FAIL;
                chatDetail.timestamp  = [[NSDate date] timeIntervalSince1970]*1000;
                [chatDetail updateToDB];
                
            }else {
                // 发送成功
                chatDetail.msg_state = MSG_SEND_SUCCESS;
                chatDetail.timestamp  = [[sendFlag substringFromIndex:3] longLongValue]*1000;
                [chatDetail updateToDB];
                
                chatDetail.audioSecond = recordSec;//add 2015.07.07
                [chatDetail updateAudio];//add 2015.07.07
                
                [ReportObject event:ID_GROUP_CHAT_SEND_TEXT_MESSAGE_INFO];//2015.06.25
                
                isScrollToBottom = YES;

                
            }
            
            chatList.msg_state = chatDetail.msg_state;
            chatList.timestamp = chatDetail.timestamp;
            
            [chatList updateToDB];
            
            [chatTableview reloadData];
        });
    });

    
    
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
- (NSString *)savePicToLocal:(long long)msgid imageData:(NSData*)fileData
{
    // 取得msgID
    NSString *msgIDKey = [[NSNumber numberWithLongLong:msgid] stringValue];
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:uid];
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
    
    NSString *originalImageDir = [Utilities getChatAudioDir:uid];
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
        GroupChatDetailObject *entity = nil;
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

- (GroupChatList *)saveMsgToChatList:(GroupChatDetailObject *)chatDetail
{
    
    GroupChatList *chatList = [[GroupChatList alloc] init];
    //chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", user.user_id];
    chatList.gid = chatDetail.groupid;
    chatList.cid = chatDetail.cid;
    chatList.is_recieved = MSG_IO_FLG_SEND;
    //最后一条消息ID
    chatList.last_msg_id= chatDetail.msg_id;
    // 聊天的最后一条消息的类型
    chatList.last_msg_type= chatDetail.msg_type;
    // 聊天的最后一条消息内容
    chatList.last_msg = chatDetail.msg_content;
    chatList.msg_state = chatDetail.msg_state;
    chatList.user_id = chatDetail.user_id;
    //时间戳
    chatList.timestamp = chatDetail.timestamp;
    chatList.title = _titleName;
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
    
    for (int i=0; i<[chatDetailArray count]; i++) {
        
        NSIndexPath *indexPathAll=[NSIndexPath indexPathForRow:i inSection:0];
       //---update by kate 2015.08.31 减少cellForRowAtIndexPath调用的次数优化性能--------------------------------
       // MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
       // if (cellAll.msgType == CELL_TYPE_AUDIO) {
        GroupChatDetailObject *groupChatForAudio = [chatDetailArray objectAtIndex:i];
        if (groupChatForAudio.msg_type == MSG_TYPE_Audio) {
            
            MsgDetailCell *cellAll = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPathAll];
            [cellAll.audioView.animationImageView stopAnimating];
            cellAll.audioView.playImageViewSubject.hidden = NO;
        }
        //------------------------------------------------------------------------------------------------
    }
    
    
    NSMutableArray *objArray = [notification object];
    numOfCellAudioPlaying = [[objArray objectAtIndex:0] integerValue];
    
    GroupChatDetailObject *entityForAudio = [objArray objectAtIndex:1];
    NSString *audioDir = [Utilities getChatAudioDir:entityForAudio.user_id];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, entityForAudio.msg_id, FILE_AMR_EXTENSION];
    entityForAudio.groupid = gid;
    
    NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
    
    if (fileData == nil) {
        
        [Utilities showFailedHud:@"没有语音文件" descView:self.view];
        entityForAudio.msg_state_audio = MSG_READ_FLG_READ_AUDIO;//更新已读状态
        [entityForAudio updateAudioState];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //--------------------------------------------------------
        
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
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
                [chatTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                //------------------------------------------------------------------------------------

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
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:numOfCellAudioPlaying inSection:0];
        MsgDetailCell *cell = (MsgDetailCell*)[chatTableview cellForRowAtIndexPath:indexPath];
        
        // 开始点击cell的播放效果
        [cell.audioView.animationImageView startAnimating];
        cell.audioView.playImageViewSubject.hidden = YES;
        
        
    }else if (status == 1){
        
        NSLog(@"1");
        
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
    
    GroupChatDetailObject *entityForpic = [notification object];
    
   // NSLog(@"state:%ld",(long)entityForpic.msg_state);
    
    if ([[self.navigationController topViewController] isKindOfClass:[MsgZoomImageViewController class]]) {
        return;
    }
    
    NSString *fileUrl = @"";
    // 此路径保存大图
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:entityForpic.user_id];
    NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entityForpic.msg_id, FILE_JPG_EXTENSION];
    
    
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entityForpic.user_id];
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
        
        GroupChatDetailObject *entity;
        entity = [chatDetailArray objectAtIndex:i];
        
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:entity.user_id];
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        
        NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];
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
    
    browser.photos = photos;
    [browser show];
    
// 2015.07.09
#if 0
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entityForpic.user_id];// update by kate 2015.03.27
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entityForpic.msg_id,FILE_JPG_EXTENSION];
    
    
    //NSLog(@"%@", entityForpic.msg_file);
    // NSLog(@"%@", originalImagePath);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    }
    
    NSInteger pos = [Utilities findStringPositionInArray:_pics andStr:thumbImagePath];
    
    if (-1 != pos) {
        
        [inputTextView resignFirstResponder];
        
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
            //            photo.image = [UIImage imageNamed:@"icon_tontacts_jz.png"];
            
            photo.srcImageView = imageView;
            [photos addObject:photo];
        }
        
        browser.photos = photos;
        [browser show];
    }
    
#endif
    
#if 0
    // 1.封装图片数据
    //设置所有的图片。photos是一个包含所有图片的数组。
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.save = NO;
    photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
    photo.srcImageView = imageView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
#endif
    
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

@end

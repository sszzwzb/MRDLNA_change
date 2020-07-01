//
//  MsgListMixViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/1/18.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MsgListMixViewController.h"
#import "MsgZoomImageViewController.h"
#import "PublicConstant.h"
#import "DBDao.h"
#import "Utilities.h"
#import "ImageResourceLoader.h"
#import "FRNetPoolUtils.h"
#import "MixChatListObject.h"
#import "GroupChatListHeadObject.h"
#import "ContactsViewController.h"
#import "MsgDetailsMixViewController.h"

@interface MsgListMixViewController ()

@property (nonatomic,strong) NSMutableArray *positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray *positionFor9ModeImage;

- (void)createChatsListTableView;

// 加载聊天列表数据
- (void)loadChatListData:(NSNotification *)notification;

// 接收到离线消息
//- (void)didReceiveMsg:(NSNotification *)notification;

@end


@implementation MsgListMixViewController

@synthesize chatListArray, chatsListTableView;
//@synthesize chatDeatilController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tag = 211;
    
    //获取窗口大小
    winSize = [[UIScreen mainScreen] bounds].size;
    self.view.backgroundColor = COMMON_BACKGROUND_COLOR;
    self.title = @"消息";
    //self.navigationItem.backBarButtonItem = [CommonUtil customerBackItem:@"消息"];
    
    //UIBarButtonItem *left = [CommonUtil customerLeftItem:@"主页" target:self action:@selector(back:)];
    //if (left) {
    //    self.navigationItem.leftBarButtonItem = left;
    //}
    
    [super setCustomizeLeftButton];
    [super setCustomizeTitle:@"消息"];
    
    //-----2015.11.19----------------------------------------------------
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"MsgListMixView" forKey:@"viewName"];
    [userDefaults synchronize];
    //--------------------------------------------------------------------
    
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    headDiction = [[NSMutableDictionary alloc] init];
    chatListArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatListData)
                                                 name:NOTIFICATION_DB_GET_CHAT_LIST_DATA
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickDeleteMsg)
                                                 name:@"clickDeleteMsg"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteGroupListCell:)
                                                 name:@"deleteGroupListCell"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactsGoToGroupChatDetailChatList:)
                                                 name:@"contactsGoToGroupChatDetailChatList"
                                               object:nil];

    [self createChatsListTableView];
    
    [self createNoDataView];
    
    //---kate 测试代码 2016.01.14------------------------------------------------------------------------------------------
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, winSize.height- 64.0 - 40.0, self.view.frame.size.width, 40.0)];
    
    _baseView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_baseView];
    _baseView.hidden = YES;
    
    deleteArr = [[NSMutableArray alloc] init];
    
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.backgroundColor = [UIColor clearColor];
    //[_deleteBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.frame = CGRectMake(winSize.width - 60.0, 0, 60.0, 40.0);
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.userInteractionEnabled = NO;
    
    selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.backgroundColor = [UIColor clearColor];
    [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateSelected|UIControlStateHighlighted];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.frame = CGRectMake(0, 0, 60.0, 40.0);
    [selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseView addSubview:selectAllBtn];
    [_baseView addSubview:_deleteBtn];
    //-----------------------------------------------------------------------------------------------------------------
    
}

// 2016.01.15
- (void)clickDeleteMsg{
    if (0 != [self.chatListArray count]) {
        self.chatsListTableView.allowsMultipleSelectionDuringEditing = YES;
        
        self.chatsListTableView.editing = !self.chatsListTableView.editing;
        
        if (self.chatsListTableView.editing) {
            
            self.chatsListTableView.frame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0 - _baseView.frame.size.height);
            
            _baseView.hidden = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setRightBarItem" object:@"1"];
            
        }else{//点击右上角完成按钮
            
            CGRect tableFrame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
            
            self.chatsListTableView.frame = tableFrame;
            _baseView.hidden = YES;
            
            //[button setTitle:@"删除" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItem = nil;
            
            //---------2016.07.11-------------------------------------------------------------------------------------------
            [deleteArr removeAllObjects];
            
            if ([deleteArr count] == [self.chatListArray count]) {//已经是全选状态
                
                selectAllBtn.selected = YES;
                
                [selectAllBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
                
            }else{
                
                selectAllBtn.selected = NO;
                [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
                
            }
            if ([deleteArr count] == 0) {
                
                [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
                _deleteBtn.userInteractionEnabled = NO;
                
            }
            //------------------------------------------------------------------------------------------------------------------
            
        }
    }
}

// 全选
-(void)selectAll:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if ([deleteArr count] == [self.chatListArray count]) {//已经是全选状态
        
        btn.selected = NO;
        [btn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        
    }else{
        
        btn.selected = YES;
        [btn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    }
    
    if (btn.selected) {
        
        [deleteArr removeObjectsInArray:self.chatListArray];

        for (int i = 0; i < chatListArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
           [self.chatsListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
      }
        [deleteArr addObjectsFromArray:self.chatListArray];
        
        [_deleteBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = YES;
        
    }else{
        
        for (int i = 0; i < chatListArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.chatsListTableView deselectRowAtIndexPath:indexPath animated:YES];
        
            
        }
        
        [deleteArr removeObjectsInArray:self.chatListArray];
        
        [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = NO;
        
    }
    
}

// 删除
-(void)deleteClick:(id)sender{
    
    if (self.chatsListTableView.editing) {
//        self.chatsListTableView.editing = !self.chatsListTableView.editing;

        //删除
        
        //1.将数组中数据删除
        [self.chatListArray removeObjectsInArray:deleteArr];
        
        //2.将数据库中的数据删除
        BOOL bDeleteMsg = NO;
        
        for (int i = 0; i<[deleteArr count]; i++) {
        
            MixChatListObject *chatListObject = [deleteArr objectAtIndex:i];
            bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.user_id gid:chatListObject.gid];
            
        }
        
        [deleteArr removeAllObjects];
        
        if (bDeleteMsg) {
            
            if ([self.chatListArray count] == 0) {
                self.chatsListTableView.editing = !self.chatsListTableView.editing;

                 _baseView.hidden = YES;
                
                 self.chatsListTableView.frame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
                
                [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
                
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"noChatListLeft", @"info",
                                      nil];

//                [[NSNotificationCenter defaultCenter] postNotificationName:@"setRightBarItem" object:@"noChatListLeft"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setRightBarItem" object:self userInfo:data];

            }else{
                
                //[noDataView removeFromSuperview];
                [Utilities dismissNodataView:self.view];
            }
            
            //3. refresh
            [self.chatsListTableView reloadData];
           
        }
        
        if ([deleteArr count] == 0) {
            
            [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
            _deleteBtn.userInteractionEnabled = NO;
            
            [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
            
        }
        
    }
    
    else return;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  [MyTabBarController setTabBarHidden:YES];
    
    //[self getChatListData];
    
    // [MobClick beginLogPageView:@"消息中心"];
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    // NSLog(@"viewName:%@",viewName);
    //点击聊天列表页单行发送通知之后做完聊天详情页的viewWillAppear之后又走了一遍聊天记录列表页的viewWillAppear，将defaults中存的viewName的值覆盖了,所以加入此判断
    if ([viewName isEqualToString:@"MsgDetailsMixView"]) {//update by kate 2015.03.02
        
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"MsgListMixView" forKey:@"viewName"];
        [userDefaults synchronize];
    }
    
    [self getChatListData];// 2015.11.19 换下顺序
    
    [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];

    
}

-(void)selectLeftAction:(id)sender{
    
    [Utilities dismissProcessingHud:self.view];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];//update by kate 2015.02.28
    //[MobClick endLogPageView:@"消息中心"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    
    self.chatsListTableView = nil;
    self.chatListArray = nil;
    //    self.chatDeatilController = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.chatsListTableView = nil;
    self.chatListArray = nil;
    //    self.chatDeatilController = nil;
    
   // [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.chatListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgListCell";
    
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else//想办法把以前的cell的内容置空。避免数据重复
    {
        //while ([cell.contentView.subviews lastObject] != nil) {
        
        //[(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        [cell setName:@""];
        
        if ([cell.contentView viewWithTag:223]) {
            
            UILabel *label = (UILabel*)[cell.contentView viewWithTag:223];
            [label removeFromSuperview];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67+10, 5, 170-10, 35)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:16+1];
            nameLabel.tag = 223;
            [cell.contentView addSubview:nameLabel];
        }
    }
    
    if ([self.chatListArray count] == 0) {
    
        return cell;
    }
        
    // Configure the cell...
    MixChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    cell.mixChatListObject = chatListObject;
    //cell.nameLabel.text = chatListObject.title;
    //cell.detailLabel.text = chatListObject.last_msg;
    cell.headImageViewForGroup.image = [UIImage imageNamed:@"loading_gray.png"];
    
    if (chatListObject.bother == 0) {
        
        cell.botherImgV.image = nil;
        cell.botherImgV.hidden = YES;
        
    }else{
        
        cell.botherImgV.image = [UIImage imageNamed:@"icon_mdr.png"];
        cell.botherImgV.hidden = NO;
    }
    
    if (chatListObject.msg_state == MSG_SEND_FAIL) {
        cell.sendFailed.hidden = NO;
        cell.detailLabel.frame = CGRectMake(80, 34, 237, 26);
    } else {
        cell.sendFailed.hidden = YES;
        cell.detailLabel.frame = CGRectMake(67+8, 34, [[UIScreen mainScreen] bounds].size.width - 67 - 8, 26);
    }
    
    if (chatListObject.at_state == 0) {
        cell.isAtLabel.hidden = YES;
    }else{
        cell.isAtLabel.hidden = NO;
    }
    
    [cell setDetail:chatListObject.last_msg];
    
//---2017.02.28---------------
    if (chatListObject.isStick) {
        cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    }else{
        cell.backgroundColor  = [UIColor whiteColor];
    }
//----------------------------------
    if (chatListObject.gid == 0) {//单聊头像
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag: 223];
        cell.headImageView.hidden = NO;
        cell.headImageViewForGroup.hidden = YES;
        
        if (![[NSString stringWithFormat:@"%@",chatListObject.schoolName] isEqualToString:@""] && (chatListObject.schoolID!= [G_SCHOOL_ID longLongValue])) {
            
            NSString *tempStr = [NSString stringWithFormat:@"%@[%@]",chatListObject.title,chatListObject.schoolName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempStr];
            [str addAttribute:NSForegroundColorAttributeName value:TS_COLOR_FONT_SUBTITLE_RGB102 range:NSMakeRange([chatListObject.title length],[chatListObject.schoolName length]+2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange([chatListObject.title length],[chatListObject.schoolName length]+2)];
            
            nameLabel.attributedText = str;
            
        }else{
            nameLabel.text = chatListObject.title;
        }
        //UserObject *localUser = [UserObject getUserInfoWithID:chatListObject.user_id];
          UserObject *localUser = [UserObject getUserInfoWithID:chatListObject.user_id sid:chatListObject.schoolID];
        if (localUser && [localUser.headimgurl length] > 0) {
            // 从服务器拉取头像
            NSString *imageName = [localUser.headimgurl lastPathComponent];
            NSString *imagePath = [Utilities getHeadImagePath:chatListObject.user_id imageName:imageName];
            if ([imagePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                if (image) {
                    cell.headImageView.image = image;
                }
            }
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //UserObject *serverUser = [FRNetPoolUtils getSalesmenWithID:chatListObject.user_id];
              UserObject *serverUser = [FRNetPoolUtils getSalesmenWithID:chatListObject.user_id sid:chatListObject.schoolID];
            if (serverUser && serverUser.user_id > 0) {
                if ([serverUser.headimgurl length] > 0) {
                    // 从服务器拉取头像
                    NSString *imageName = [serverUser.headimgurl lastPathComponent];
                    NSString *imagePath = [Utilities getHeadImagePath:chatListObject.user_id imageName:imageName];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                        NSString *userHeadUrl = [[NSString alloc] initWithFormat:@"%@", serverUser.headimgurl];
                        [FRNetPoolUtils getPicWithUrl:userHeadUrl picType:PIC_TYPE_HEAD userid:chatListObject.user_id msgid:0];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 从服务器拉取头像
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                            if (image) {
                                cell.headImageView.image = image;
                            }
                        }
                    });
                }
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if ([serverUser.name length] > 0) {
//                        cell.nameLabel.text = serverUser.name;
//                    }
//                });
            }
        });
        
    }else{//群聊头像
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag: 223];
        nameLabel.text = chatListObject.title;
        cell.headImageViewForGroup.hidden = NO;
        //cell.headImageViewForGroup.image = [UIImage imageNamed:@"loading_gray.png"];
        cell.headImageView.hidden = YES;
        //---------------------------------------------------------
        /*Done:获取群头像数组，排列组合，设置cell.headImageView*/
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
            
            UIImage *image = [headDiction objectForKey:[NSString stringWithFormat:@"%lld",cell.mixChatListObject.gid]];
            
            if (image!=nil) {
                
                cell.headImageViewForGroup.image = image;
                
            }else{
                
                [self initImageposition];
                NSLog(@"returnArrayCount:%lu",(unsigned long)[returnArray count]);
                UIImage *image = [self makeGroupAvatar:returnArray];
                if (image) {
                    
                    
                    [headDiction setObject:image forKey:[NSString stringWithFormat:@"%lld",cell.mixChatListObject.gid]];
                    
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
        
    }
    
    // 时间标签,转换时间形式
    long long timestamp = chatListObject.timestamp;
    timestamp = timestamp/1000.0;
    
    NSString *dateString = [Utilities timeIntervalToDate:timestamp timeType:0 compareWithToday:YES];
    [cell setTime:dateString];
    
    if (chatListObject.gid == 0) {
        if ([cell.contentView viewWithTag:223]) {
            
            UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:223];
            if ([dateString length] > 5) {
                nameLabel.frame = CGRectMake(67+10, 5, [Utilities getScreenSize].width - 67.0 - 85.0, 35);
            }else{
                nameLabel.frame = CGRectMake(67+10, 5, [Utilities getScreenSize].width - 67.0 - 45.0, 35);
            }
            
        }
    }
    if (tableView.editing == YES) {
        cell.timeLabel.hidden = YES;
        //        cell.unReadBadgeView.hidden = YES;
        //        cell.unReadLabel.hidden = YES;
    } else {
        cell.timeLabel.hidden = NO;
        cell.unReadBadgeView.hidden = YES;
        cell.unReadLabel.hidden = YES;
        cell.unReadLabel.text = @"";
        
        // Done:消息未读数量要做漫游，所以以下从数据库取出的未读数量逻辑要修改，改成从server拉取未读数量
        // 将从server获取到的未读数量添加到一个字典里，key是cell.chatListObject.user_id，value是未读数量
        // unReadMsgDic存储未读数量的字典
        
        //if (unReadMsgDic) {//update 2015.11.18
            
            //if ([unReadMsgDic count] > 0) {
                
                //int cnt = [[unReadMsgDic objectForKey:[NSString stringWithFormat:@"%lld",cell.chatListObject.user_id]] intValue];
        // 2.9.3再改回从数据库读取未读数量
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoMix_%lli_%lli where is_recieved = %d and msg_state != %d", cell.mixChatListObject.gid,cell.mixChatListObject.user_id, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        if (chatListObject.gid == 0) {
            
            sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoMix_%lli_%lli where is_recieved = %d and msg_state != %d and schoolID = %lli", cell.mixChatListObject.gid,cell.mixChatListObject.user_id, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ,cell.mixChatListObject.schoolID];
            
        }
        NSLog(@"cell sql:%@",sql);
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
                
                if (cnt > 0) {
                    cell.unReadBadgeView.hidden = NO;
                    cell.unReadLabel.hidden = NO;
                    cell.unReadBadgeView.frame = CGRectMake(cell.headImageView.frame.origin.x + WIDTH_HEAD_CELL_IMAGE - 10, cell.headImageView.frame.origin.y - 2, 19, 19);
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
                }else{
                    
                    cell.unReadBadgeView.hidden = YES;
                    cell.unReadLabel.hidden = YES;
                }
            //}
        //}
        
        
    }
    
    if (tableView.editing == YES){
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
 
    }else{
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = COMMON_TABLEVIEWCELL_SELECTED_COLOR;
    }
   
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 进入编辑状态后不显示时间和未读消息数
    MsgListCell *cell =  (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.editing == YES) {
        cell.timeLabel.hidden = YES;
        //        cell.unReadBadgeView.hidden = YES;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        
    } else {
        cell.timeLabel.hidden = NO;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
        //            cell.unReadBadgeView.hidden = NO;
        //        } else {
        //            cell.unReadBadgeView.hidden = YES;
        //        }
        
    }
    
    
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        MixChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.user_id gid:chatListObject.gid];
        if (bDeleteMsg) {
            
            NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoMix_%lli_%lli",chatListObject.gid,chatListObject.user_id];
            [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
            
            [self.chatListArray removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];

            // 左划直接删除聊天消息，不查看 使聊天tab的未读消息动态变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:nil];
            
        } else {
            // 删除失败提示
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Failed to delete chat!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
            [alert show];
            
        }
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MixChatListObject *chatListObject = [self.chatListArray objectAtIndex:indexPath.row];
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"%@", action);
        
        // 参考QQ 删除与置顶不给出提示
        if ([@"删除" isEqualToString:action.title]){
            
            //TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
            
            BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:chatListObject.user_id gid:chatListObject.gid];
            
            if (bDeleteMsg) {
                
                    NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoMix_%lli_%lli where schoolID = %lli",chatListObject.gid,chatListObject.user_id,chatListObject.schoolID];
                    [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
                
                
                [self.chatListArray removeObjectAtIndex:indexPath.row];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
                
                // 左划直接删除聊天消息，不查看 使聊天tab的未读消息动态变化
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:nil];
                
                
            } else {
                // 删除失败提示
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Failed to delete chat!",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil,nil ];
                [alert show];
                
            }
            //};
            
            //            NSArray *itemsArr =
            //            @[TSItemMake(@"删除", TSItemTypeNormal, handlerTest)];
            //            [Utilities showPopupView:@"确认删除？" items:itemsArr];
            
            
        }else if ([@"置顶" isEqualToString:action.title]){
            
            long long timestamp = [[NSDate date] timeIntervalSince1970]*1000;
            //TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
            [self stick:timestamp chatList:chatListObject];
            //};
            
            //            NSArray *itemsArr =
            //            @[TSItemMake(@"置顶", TSItemTypeNormal, handlerTest)];
            //            [Utilities showPopupView:@"确认置顶？" items:itemsArr];
        }else if ([@"取消置顶" isEqualToString:action.title]){
            [self stick:0 chatList:chatListObject];
        }
        
        //tableView.editing = NO;
    };
    
    // 需要查询数据库 判断 这条消息是否被置顶 切换文言
    NSString *stickStr = @"置顶";
    if([chatListObject isStick]){
        stickStr = @"取消置顶";
    }
    
    UITableViewRowAction *actionStick = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:stickStr handler:rowActionHandler];
    actionStick.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    actionDelete.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:87.0/255.0 blue:76.0/255.0 alpha:1.0];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [arr addObject:actionDelete];
    [arr addObject:actionStick];
    
    return arr;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleRows = [tableView visibleCells];
    if([visibleRows count] > 0){
        for (MsgListCell *cell in visibleRows) {
            cell.timeLabel.hidden = NO;
            //        if (cell.chatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.chatListObject.msg_state != MSG_READ_FLG_READ) {
            //            cell.unReadBadgeView.hidden = NO;
            //        } else {
            //            cell.unReadBadgeView.hidden = YES;
            //        }
        }
    }
    
    [self performSelector:@selector(showNoDataView) withObject:nil afterDelay:1];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        
        [_deleteBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = YES;
        
        //选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
        [deleteArr addObject:[self.chatListArray objectAtIndex:indexPath.row]];
        if ([deleteArr count] == [self.chatListArray count]) {//已经是全选状态
            
            selectAllBtn.selected = YES;
           
            [selectAllBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
            
        }else{
            
            selectAllBtn.selected = NO;
            [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
            
        }
        
        
    }else{
        
         MixChatListObject *mixChatListObject = [self.chatListArray objectAtIndex:indexPath.row];
        
        if (mixChatListObject.gid == 0) {
        
              [[DBDao getDaoInstance] createMsgInfoMixTable:mixChatListObject.gid userId:mixChatListObject.user_id];
            
        }else{
             [[DBDao getDaoInstance] createMsgInfoMixTable:mixChatListObject.gid userId:0];
        }
        
        MsgListCell *cell = (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.mixChatListObject.is_recieved == MSG_IO_FLG_RECEIVE && cell.mixChatListObject.msg_state != MSG_READ_FLG_READ) {
            cell.mixChatListObject.msg_state = MSG_READ_FLG_READ;
            [cell.mixChatListObject updateToDB];
        }
        cell.unReadBadgeView.hidden = YES;
        cell.botherImgV.image = nil;
        cell.botherImgV.hidden = YES;

        UserObject *chatUser;
        if (cell.mixChatListObject.gid == 0) {
            
                //chatUser = [UserObject getUserInfoWithID:cell.mixChatListObject.user_id];
                chatUser = [UserObject getUserInfoWithID:cell.mixChatListObject.user_id sid:cell.mixChatListObject.schoolID];
            if (chatUser == nil) {
                    //chatUser = [FRNetPoolUtils getSalesmenWithID:cell.mixChatListObject.user_id];
                    chatUser = [FRNetPoolUtils getSalesmenWithID:cell.mixChatListObject.user_id sid:cell.mixChatListObject.schoolID];
                if (chatUser == nil) {
                    chatUser = [[UserObject alloc] init];
                    chatUser.user_id = cell.mixChatListObject.user_id;
                    [chatUser updateToDB];
                    
                    if ([chatUser.name length] > 0) {
                        cell.mixChatListObject.title = chatUser.name;
                    } else {
                        cell.mixChatListObject.title = NO_NAME_USER;
                    }
                    [cell.mixChatListObject updateToDB];
                } else {
                    if (chatUser.user_id == 0) {
                        chatUser = [[UserObject alloc] init];
                        chatUser.user_id = cell.mixChatListObject.user_id;
                        [chatUser updateToDB];
                    }
                }
            }
        }else{
            
            [self getGroupHead:cell.mixChatListObject];
        }
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             mixChatListObject,@"mixChatListObject",
                             @"list",@"frontName",
                             chatUser, @"user",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailsMixView" object:self userInfo:dic];
[mixChatListObject updateAtState];//更新at
    }
    
}

// 调用群头像接口
-(void)getGroupHead:(MixChatListObject*)chatList{
    
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

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [deleteArr removeObject:[self.chatListArray objectAtIndex:indexPath.row]];
    
     selectAllBtn.selected = NO;
     [selectAllBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    if ([deleteArr count] == 0) {
        
        [_deleteBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = NO;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CHATLIST_CELL;
}


#pragma mark - Private function
-(void)reload{
    
    [self.chatsListTableView reloadData];
}

- (void)createChatsListTableView
{
    // 初始化tableview
#if 0 // 2015.01.15
    CGRect tableFrame = CGRectMake(0, 49.0, winSize.width, winSize.height - 20 - 44 - 49);
#endif
    
    CGRect tableFrame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
    
    self.chatsListTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    //self.chatsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatsListTableView.scrollsToTop = YES;
    self.chatsListTableView.delegate = self;
    self.chatsListTableView.dataSource = self;
    self.chatsListTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.chatsListTableView];
}

// 获取Chat list
- (void)getChatListData
{
    [NSThread detachNewThreadSelector:@selector(getChatListDataNewThread) toTarget:self withObject:nil];
}

- (void)getChatListDataNewThread
{
    @autoreleasepool{
    
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
#if 0
    NSString *sql = [NSString stringWithFormat:@"select * from msgListMix where uid = %lli ORDER BY timestamp DESC",[uid longLongValue]];
#endif
        
    NSString *sql = [NSString stringWithFormat:@"select * from msgListMix where uid = %lli ORDER BY stick DESC,timestamp DESC",[uid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    NSMutableArray *chatListArr = [[NSMutableArray alloc] init];
    NSInteger cnt = [chatsListDict.allKeys count];
    //int count = 0;
    for (int listCnt = 0; listCnt < cnt; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        NSLog(@"chatObjectDict:%@",chatObjectDict);
        
        MixChatListObject *chatList = [[MixChatListObject alloc] init];
        chatList.msglist_id = [[chatObjectDict objectForKey:@"msglist_id"] longLongValue];
        chatList.is_recieved = [[chatObjectDict objectForKey:@"is_recieved"] intValue];
        chatList.last_msg_id = [[chatObjectDict objectForKey:@"last_msg_id"] longLongValue];
        chatList.last_msg_type = [[chatObjectDict objectForKey:@"last_msg_type"] intValue];
        chatList.last_msg = [Utilities replaceNull:[chatObjectDict objectForKey:@"last_msg"]];
        chatList.msg_state = [[chatObjectDict objectForKey:@"msg_state"] intValue];
        chatList.title = [Utilities replaceNull:[chatObjectDict objectForKey:@"title"]];
        chatList.user_id = [[chatObjectDict objectForKey:@"user_id"] longLongValue];
        chatList.timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue];
        chatList.gid = [[chatObjectDict objectForKey:@"gid"] longLongValue];
        chatList.bother = [[chatObjectDict objectForKey:@"bother"] integerValue];
        
        if ([[Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"at_state"]]] length] == 0) {
            
            chatList.at_state = 0;
        }else{
            chatList.at_state =  [[Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"at_state"]]]integerValue];
        }
    
        //NSLog(@"last_msg:%@",chatList.last_msg);
        
        chatList.last_msg = [self sqliteEscape:chatList.last_msg];
        chatList.last_msg = [chatList.last_msg stringByReplacingOccurrencesOfString:@"http:////" withString:@"http://"];
        
        chatList.stick = [[chatObjectDict objectForKey:@"stick"] longLongValue];
        if (chatList.gid == 0) {
            
            chatList.schoolName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[chatObjectDict objectForKey:@"schoolName"]]];
            chatList.schoolID = [[chatObjectDict objectForKey:@"schoolID"]longLongValue];
            
        }
        
        [chatListArr addObject:chatList];
        
    }
    //
    //    if (count >0) {
    //
    //        NSString *c = [NSString stringWithFormat:@"%d",count];
    //        // 红点推送
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:c];
    //    }
    
#if 0 //2015.11.18
    //------add 2015.01.25--------------------------------
    
    NSString *sql2 = [NSString stringWithFormat:@"select * from msgList"];
    
    NSMutableDictionary *idListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql2];
    int userCount = [idListDict.allKeys count];
    int count = 0;
    for (int i=0; i<userCount; i++) {
        
        NSMutableDictionary *objectDict = [idListDict objectForKey:[NSNumber numberWithInt:i]];
        NSLog(@"objectDict:%@",objectDict);
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfo_%lli where is_recieved = %d and msg_state != %d", [[objectDict objectForKey:@"user_id"] longLongValue], MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        count = count+cnt;
    }
    
    if(count > 0){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:nil];
    }
    //----------------------------------------------------
#endif
    
    
    //--add 2015.01.25----------------------------------------------
    NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
    NSString *moudleName = @"";
    for (int i=0; i<[dynamicArr count]; i++) {
        
        NSDictionary *dic = [dynamicArr objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        
        if ([type intValue] == 10) {
            
            moudleName = name;
        }
    }
    
    if (cnt > 0) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:0]];
        
        long long timestamp = [[chatObjectDict objectForKey:@"timestamp"] longLongValue]/1000;
        
        NSString *newsId = [NSString stringWithFormat:@"%lli",timestamp];
        
        if ([moudleName length]>0) {
            
            if (newsId!=nil) {
                [[NSUserDefaults standardUserDefaults]setObject:newsId forKey:moudleName];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }
        
    }
    
    //-----------------------------------------------------------------
    
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
        
        //noDataView.hidden = YES;
        [Utilities dismissNodataView:self.view];
        self.chatsListTableView.hidden = NO;
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
 
    }else {
        //noDataView.hidden = NO;
         [Utilities showNodataView:@"找啊~找啊~找朋友~" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
        self.chatsListTableView.hidden = YES;
    }
    
}

- (BOOL)deleteChatsListDataWithUserID:(long long)user_id gid:(long long)gid
{
    BOOL deleteResult = NO;
    
    NSString *deleteChatListSql = [[NSString alloc] initWithFormat:@"delete from msgListMix where gid = %lli and user_id = %lli",gid,user_id];
    deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatListSql];
    
    return deleteResult;
}

- (void)back:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"viewName"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNoDataView
{
    /*noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    noDataView.backgroundColor = [UIColor clearColor];
    noDataView.hidden = YES;
    
    UIImageView *noDataLogo = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width- 124)/2.0, 100.0, 120, 120)];
    noDataLogo.image = [UIImage imageNamed:@"noMsg.png"];
    
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width/2.0))/2.0, noDataLogo.frame.origin.y+noDataLogo.frame.size.height+10, [UIScreen mainScreen].bounds.size.width/2.0, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"新来的吧";
    
    
    //label.backgroundColor = [UIColor grayColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width/2.0))/2.0, label.frame.origin.y+label.frame.size.height, [UIScreen mainScreen].bounds.size.width/2.0, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"快找同学老师聊聊看";
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
    */
//    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
//     noDataView = [Utilities showNodataView:@"找啊~找啊~找朋友~" msg2:@"" andRect:rect imgName:@"noMsg.png"];
    
     [Utilities showNodataView:@"找啊~找啊~找朋友~" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
    
}

-(void)showNoDataView{
    
    if ([self.chatListArray count] == 0) {
        
//        noDataView.hidden = NO;

        NSLog(@"nodataview.frame:%f",noDataView.frame.size.height);
//        [self.view addSubview:noDataView];
        [Utilities showNodataView:@"找啊~找啊~找朋友~" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
        
    }else {
        
//        [noDataView removeFromSuperview];
        [Utilities dismissNodataView:self.view];
        CGRect tableFrame = CGRectMake(0, 0, winSize.width, winSize.height - 44 - 20.0);
        self.chatsListTableView.frame = tableFrame;

    }
    
}

/**
 * 获取与朋友聊天的未读消息数量
 * v=1, ac=Message, op=count, sid=, uid=
 * 2015.11.18
 */
/*-(void)addNewCount{
    
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
            
            NSArray *messageArray = [respDic objectForKey:@"message"];
            //NSLog(@"messageArray:%@",messageArray);
            
            if (!unReadMsgDic) {
                unReadMsgDic = [[NSMutableDictionary alloc]init];
            }else{
                [unReadMsgDic removeAllObjects];
            }
            
            
            NSInteger totalMsgCount = 0;
            
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
                    [unReadMsgDic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:[NSString stringWithFormat:@"%lld",fuid]];
                    
                }
                
            }
            
            //totalMsgCount = 25;//测试代码
            
            if(totalMsgCount > 0){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCount" object:[NSString stringWithFormat:@"%ld",(long)totalMsgCount]];
                [chatsListTableView reloadData];
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNew" object:nil];
                [chatsListTableView reloadData];
                
            }
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
}*/

// 自己删除并退出群
-(void)deleteGroupListCell:(NSNotification*)notification{
    
    long long gid = [[notification object] longLongValue];
    
    BOOL bDeleteMsg = [self deleteChatsListDataWithUserID:gid];
    
    BOOL deleteResult = NO;
    
    if (bDeleteMsg) {
        
        NSString *deleteChatDetailSql = [[NSString alloc] initWithFormat:@"delete from msgInfoMix_%lli_%i",gid,0];
        deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatDetailSql];
        
    }
    
    if (deleteResult) {
        [self getChatListData];// 重新获取最新群聊列表数据显示
    }
    
}

- (BOOL)deleteChatsListDataWithUserID:(long long)gid
{
    BOOL deleteResult = NO;
    NSString *uid = [Utilities getUniqueUidWithoutQuit];
    NSString *deleteChatListSql = [[NSString alloc] initWithFormat:@"delete from msgListMix where uid = %lli and gid = %lli",[uid longLongValue],gid];
    deleteResult = [[DBDao getDaoInstance] executeSql:deleteChatListSql];
    
    return deleteResult;
}

//---组合头像逻辑-----------------------------------------------------------------------
- (UIImage *)makeGroupAvatar: (NSMutableArray *)imageArray {
    //数组为空，退出函数
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,193,193)];
    groupAvatarView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
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
    float width = 110.0;
    float height = 110.0;
    if (iPhone6p) {
        width = 55.0*3.0;
        height = 55.0*3.0;
    }
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(width, height)];
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
    
    [headDiction removeAllObjects];
}
//-----------------------------------------------------------------------------------------------------

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

// 去群聊详细页
-(void)contactsGoToGroupChatDetailChatList:(NSNotification*)notification{
    
    // To do:生成群成功接收消息走此方法 刷新群聊列表 跳转至聊天详细页
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
    //[self getChatListData];// 获取最新群聊列表数据显示
    
    MixChatListObject *groupChatListNotification = (MixChatListObject*)[notification object];
    //    _cid = [NSString stringWithFormat:@"%lli",groupChatList.cid];
    
    MsgDetailsMixViewController *groupDetailV = [[MsgDetailsMixViewController alloc]init];
    groupDetailV.fromName = @"createGroup";
    groupDetailV.titleName = groupChatListNotification.title;
    groupDetailV.gid = groupChatListNotification.gid;
    groupDetailV.cid = groupChatListNotification.cid;
    groupDetailV.isViewGroupMember = 1;
    groupDetailV.groupChatList = groupChatListNotification;
    [self.navigationController pushViewController:groupDetailV animated:YES];
    
}

-(void)stick:(long long)stick chatList:(MixChatListObject*)chatListObject{
    
    MixChatListObject *chatListObj = chatListObject;
    chatListObj.stick = stick;
    [chatListObj updateStick];
    
    [self getChatListData];
    
}
@end

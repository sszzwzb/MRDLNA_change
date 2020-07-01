//
//  ContactsViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 16/1/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ContactsViewController.h"

#import "RADataObject.h"
#import "RATreeView.h"
#import "RATableViewCell.h"

@interface ContactsViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect tree;
    float y = 0;//seachbar的y坐标
    
    if ([@"chatMemberSelect"  isEqual: _viewType]) {
        
        headDiction = [[NSMutableDictionary alloc] init];
        _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        [self.view addSubview:_headScrollView];
        
        y = 45;
#if 0
        tree = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+45, self.view.bounds.size.width, [UIScreen mainScreen].applicationFrame.size.height-45);
#endif
        
        //因为加了搜索栏 所以坐标下移40
        tree = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+45+40.0, self.view.bounds.size.width, [UIScreen mainScreen].applicationFrame.size.height-45-20.0);
        
        if (nil != _settingMembersArray) {
            [super setCustomizeTitle:@"添加成员"];
            [self setCustomizeRightButtonWithName:@"确定" color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];
            
            [self setCustomizeLeftButton];

        }else {
            [super setCustomizeTitle:@"发起群聊"];
            [self setCustomizeRightButtonWithName:@"创建" color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];
            
            [super setCustomizeLeftButtonWithName:@"取消"];
            
        }
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        tree = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        
        [self setCustomizeLeftButton];
    }

    _selectedMembersStr = @"";
    _selectedMembersArray = [[NSMutableArray alloc] init];
    _headViewArray = [[NSMutableArray alloc] init];
    
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashContactsListView:) name:@"reflashContactsListView" object:nil];

    _data = [[NSMutableArray alloc] init];
    
    [self doGetContacts];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, y, [Utilities getScreenSize].width, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
    mySearchBar.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    mySearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:mySearchBar.bounds.size];
    
    // 层级显示的树
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:tree];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    if (![@"chatMemberSelect" isEqualToString:_viewType]) {
        treeView.treeHeaderView = mySearchBar;
    }
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.rowsExpandingAnimation = UITableViewRowAnimationNone;
    treeView.rowsCollapsingAnimation = UITableViewRowAnimationNone;

//    [RATreeView setAnimationsEnabled:NO];

    // 不需要刷新
#if 0
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    [treeView.scrollView addSubview:refreshControl];
#endif
    
//    [treeView reloadData];

    self.treeView = treeView;
//    self.treeView.frame = self.view.bounds;
    self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[self.view insertSubview:treeView atIndex:0];
      [self.view addSubview:treeView];
    
    
    //---搜索 2016.08.02-----------------------------------------------------------------------
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if ([@"chatMemberSelect" isEqualToString:_viewType]) {
        
        mySearchDisplayController = [[MySearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
        mySearchDisplayController.active = NO;
        mySearchDisplayController.searchResultsDataSource = self;
        mySearchDisplayController.searchResultsDelegate = self;
        mySearchDisplayController.displaysSearchBarInNavigationBar = NO;
        mySearchDisplayController.delegate = self;
        [self.view addSubview:mySearchBar];
        
    }else{
        
        searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
        searchDisplayController.active = NO;
        searchDisplayController.searchResultsDataSource = self;
        searchDisplayController.searchResultsDelegate = self;
        searchDisplayController.displaysSearchBarInNavigationBar = NO;
        searchDisplayController.delegate = self;
        
    }
    
    searchResults = [[NSMutableArray alloc]init];
    //-------------------------------------------------------------------------------------------
    
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
//    [self updateNavigationItemButton];
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];

    [self showHead];

    // 看看是否需要进来就把所有人员list展开，默认为不展开吧。
#if 0
    for (id item in [_treeView itemsForRowsInRect:_treeView.frame]) {
        [_treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
    }
#endif
#if 1
    _selectedSidArray = [NSMutableArray array];
#endif
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    for (UIView *view in mySearchBar.subviews) {
        
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            
            if ([@"chatMemberSelect" isEqualToString:_viewType]) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];//去掉原本的背景色
            }
            
            NSLog(@"%@",[view subviews]);
            
            UITextField *searchField = [view.subviews lastObject];
            searchField.layer.masksToBounds = YES;
            searchField.layer.cornerRadius = 15;
            
            
            break;
        }
        
        
        
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectRightAction:(id)sender
{
    if (nil != _settingMembersArray) {
        if (0 < [_selectedMembersArray count]) {
            if (nil != _settingMembersArray) {
                
                if ([@"1" isEqualToString:_addToGroupChat]) {
                    //                    _selectedMembersStr = [_selectedMembersArray componentsJoinedByString:@","];
                    
                    
                    // 单聊转群聊时候需要单聊时候的那个人的uid带进去
                    NSMutableArray *memberArray = [NSMutableArray arrayWithArray:_selectedMembersArray];
                    [memberArray addObjectsFromArray:_settingMembersArray];
#if 1
                    NSMutableArray *sidArray = [NSMutableArray arrayWithArray:_selectedSidArray];
                    [sidArray addObjectsFromArray:_settingSidArray];
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSInteger i = 0; i < memberArray.count; i++) {
                        NSString *tempStr = [NSString stringWithFormat:@"%@:%@",  sidArray[i], memberArray[i]];
                        [tempArr addObject:tempStr];
                    }
                    _selectedMembersStr = [tempArr componentsJoinedByString:@","];
#else
                    _selectedMembersStr = [memberArray componentsJoinedByString:@","];
#endif
                    [self createGroup];
                }else {

                    // 群聊设置中添加成员
                    NSMutableArray *infoList = [[NSMutableArray alloc] init];
                    NSMutableArray *subArray = [[NSMutableArray alloc] init];
                    
                    for (int i=0; i<[_selectedMembersArray count]; i++) {
                        RADataObject *info = [self getInfoFormData:[NSString stringWithFormat:@"%ld", [[_selectedMembersArray objectAtIndex:i] integerValue] + [[_selectedSidArray objectAtIndex:i] integerValue] * 1000000] fromPic:1];
                        
                        NSString *uid = info.idNumber;
                        NSString *name = info.name;
                        NSString *head_url = info.avatar;
#if 1
                        NSString *sid = info.sid;
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar",sid, @"sid", nil];
#else
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar", nil];
#endif
                        
                        [subArray addObject:dic];
                    }
                    
                    [infoList addObject:subArray];
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         infoList, @"uidList",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_ADDMEMBER object:self userInfo:dic];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else {
                // 创建群聊
#if 1
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSInteger i = 0; i < _selectedSidArray.count; i++) {
                    NSString *tempStr = [NSString stringWithFormat:@"%@:%@", _selectedSidArray[i], _selectedMembersArray[i]];
                    [tempArr addObject:tempStr];
                }
                _selectedMembersStr = [tempArr componentsJoinedByString:@","];
#else
                _selectedMembersStr = [_selectedMembersArray componentsJoinedByString:@","];
#endif

                
//                _selectedMembersStr = [_selectedMembersArray componentsJoinedByString:@","];
                [self createGroup];
            }
        }
    }else {
        if (1 < [_selectedMembersArray count]) {
            //Chenth 3.2 此处分支应该不会走 备注一下
            if (nil != _settingMembersArray) {
                // 群聊设置中添加成员
                NSMutableArray *infoList = [[NSMutableArray alloc] init];
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                
                for (int i=0; i<[_selectedMembersArray count]; i++) {
                    RADataObject *info = [self getInfoFormData:[_selectedMembersArray objectAtIndex:i] fromPic:0];
                    
                    NSString *uid = info.idNumber;
                    NSString *name = info.name;
                    NSString *head_url = info.avatar;
#if 1
                    NSString *sid = info.sid;
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar",sid, @"sid", nil];
#else
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",uid,@"uid",name,@"name",@"0", @"nail",head_url,@"avatar", nil];
                    
#endif
                    
                    [subArray addObject:dic];
                }
                
                [infoList addObject:subArray];
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     infoList, @"uidList",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_ADDMEMBER object:self userInfo:dic];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                // 创建群聊
#if 1
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSInteger i = 0; i < _selectedSidArray.count; i++) {
                    NSString *tempStr = [NSString stringWithFormat:@"%@:%@", _selectedSidArray[i], _selectedMembersArray[i]];
                    [tempArr addObject:tempStr];
                }
                _selectedMembersStr = [tempArr componentsJoinedByString:@","];
#else
                _selectedMembersStr = [_selectedMembersArray componentsJoinedByString:@","];
#endif
//                _selectedMembersStr = [_selectedMembersArray componentsJoinedByString:@","];
                [self createGroup];
            }
        }
    }
}

-(void)selectLeftAction:(id)sender
{
    [UIView setAnimationsEnabled:YES];
    
    if ([@"chatMemberSelect"  isEqual: _viewType]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)reflashContactsListView:(NSDictionary *)notifyDic
{
    [_data removeAllObjects];
    
    [self doGetContacts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int systemVersion = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue];
    if (systemVersion >= 7 && systemVersion < 8) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.scrollView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.scrollView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    
//    self.treeView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView setAnimationsEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (![@"contactsList"  isEqual: _viewType]) {
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma mark - Actions

#if 0
- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}

- (void)editButtonTapped:(id)sender
{
    [self.treeView setEditing:!self.treeView.isEditing animated:YES];
    [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton
{
//    UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
//    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = self.editButton;
}
#endif

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    
    if (cell.canExpand) {
        // 可以展开
        NSLog(@"can expand");
        
        [self performSelector:@selector(expand:) withObject:item afterDelay:0.1];
//        [self performSelector:@selector(getPicForPath:) withObject:imagePath afterDelay:1];

//        [treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];

    }else {
        // 不可展开
        if ([@"contactsList"  isEqual: _viewType]) {
            // 通讯录列表页面，选择好友 跳转至聊天页
            RADataObject *dataObject = item;

            if (nil != dataObject.idNumber) {
                if ([@"person"  isEqual: dataObject.node]) {
                    // 单聊
                    UserObject *user = [[UserObject alloc] init];
                    
                    user.user_id = dataObject.idNumber.longLongValue;
                    user.name = dataObject.name;
                    user.headimgurl = dataObject.avatar;
#if 1
                    user.schoolName = G_SCHOOL_NAME;
                    user.schoolID = [dataObject.sid longLongValue];
#endif
                    [user updateToDB];
                    
                    // 更改聊天列表的title
                    NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and uid = %lli and schoolID = %lli", user.name, user.user_id, [Utilities getUniqueUid].longLongValue, [dataObject.sid longLongValue]];
                    [[DBDao getDaoInstance] executeSql:updateListSql];
                    
#pragma forKate
                    MixChatListObject *chatListObject = [[MixChatListObject alloc] init];
                    chatListObject.user_id = dataObject.idNumber.longLongValue;
                    chatListObject.title = dataObject.name;
                    chatListObject.gid = 0;
                    chatListObject.schoolID = [dataObject.sid longLongValue];
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0",@"gid",
                                         @"user",@"frontName",
                                         user, @"user",
#pragma forKate
                                         chatListObject, @"mixChatListObject",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailMixView" object:self userInfo:dic];

                    [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];

                }else if ([@"group"  isEqual: dataObject.node]) {
                    // 群聊
                    MixChatListObject *chatListObject = [[MixChatListObject alloc] init];
                    
                    chatListObject.user_id = 0;
                    chatListObject.title = dataObject.name;
                    chatListObject.gid = dataObject.idNumber.longLongValue;
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"user",@"frontName",
                                         chatListObject, @"mixChatListObject",
                                         dataObject.member,@"userNumber",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailMixView" object:self userInfo:dic];
                    
                    [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
        }else {
            [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
            
            RADataObject *dataObject = item;
            
            // 该节点没有child，直接对其设置isSelect即可
            dataObject.isSelected = !dataObject.isSelected;
            [treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
            
            // 将uid添加到uid列表当中
            [self addOrDeleteToSelectedMemberArray:dataObject status:dataObject.isSelected];
            
            // 还需要判断父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parent = [self.treeView parentForItem:item];
            if (nil != parent) {
                // 如果有父节点
                if (0 != parent.isSelected) {
                    // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                    parent.isSelected = 0;
                    [treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                    BOOL isAllSelect = YES;
                    
                    NSArray *childrenData = parent.children;
                    for (int i=0; i<[childrenData count]; i++) {
                        RADataObject *childrenObj = [childrenData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelect = NO;
                        }
                    }
                    
                    parent.isSelected = isAllSelect;
                    [treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
            
            // 还需要判断父节点的父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parentParent = [self.treeView parentForItem:parent];
            if (nil != parentParent) {
                // 如果有父节点的父节点
                if (0 != parentParent.isSelected) {
                    // 如果父节点的父节点的isSelect状态是设置的，则需要把其状态设为0
                    parentParent.isSelected = 0;
                    [treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的父节点isSelect状态为未设置，则需要判断这个父节点下的的父节点所有子节点是否为已选状态
                    BOOL isAllSelectParent = YES;
                    
                    NSArray *childrenParentData = parentParent.children;
                    for (int i=0; i<[childrenParentData count]; i++) {
                        RADataObject *childrenObj = [childrenParentData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelectParent = NO;
                        }
                    }
                    
                    parentParent.isSelected = isAllSelectParent;
                    [treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }

            [self showHead];

            // 判断已选择的uid列表是否为空，来设置右button的状态。
            NSString *rightButtonName = @"";
            if (nil != _settingMembersArray) {
                rightButtonName = @"确定";
            }else {
                rightButtonName = @"创建";
            }
            
            NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
            
            if ([@"确定"  isEqual: rightButtonName]) {
                if (0 < [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                }else {
                    if (1 == [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                    }else {
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                        //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                        [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    }
                }
            }else {
                if (1 < [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                }else {
                    if (1 == [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                        //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                        
                        //
                        
                    }else {
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                        //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                        [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                        
                        //
                        
                    }
                }
            }

            
            
            
        }
    }
}

- (void)expand:(id)item
{
    [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];

    if (cell.canExpand) {
        // 可以展开
        NSLog(@"can expand");
        [self performSelector:@selector(expand:) withObject:item afterDelay:0.1];

//        [treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];

    }else {
        // 不可展开
        NSLog(@"cannot expand");
        
            // 不可展开
            if ([@"contactsList"  isEqual: _viewType]) {
                // 通讯录列表页面，选择好友 跳转至聊天页
                RADataObject *dataObject = item;
                
                if (nil != dataObject.idNumber) {
                    if ([@"person"  isEqual: dataObject.node]) {
                        // 单聊
                        UserObject *user = [[UserObject alloc] init];
                        
                        user.user_id = dataObject.idNumber.longLongValue;
                        user.name = dataObject.name;
                        user.headimgurl = dataObject.avatar;
#if 1
                        user.schoolName = G_SCHOOL_NAME;
                        user.schoolID = [dataObject.sid longLongValue];
#endif
                        [user updateToDB];
                        
                        // 更改聊天列表的title
                        NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and uid = %lli and schoolID = %lli", user.name, user.user_id, [Utilities getUniqueUid].longLongValue, [dataObject.sid longLongValue]];
                        [[DBDao getDaoInstance] executeSql:updateListSql];
                        
#pragma forKate
                        MixChatListObject *chatListObject = [[MixChatListObject alloc] init];
                        chatListObject.user_id = dataObject.idNumber.longLongValue;
                        chatListObject.title = dataObject.name;
                        chatListObject.gid = 0;
                        chatListObject.schoolID = [dataObject.sid longLongValue];
                        
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"0",@"gid",
                                             @"user",@"frontName",
                                             user, @"user",
#pragma forKate
                                             chatListObject, @"mixChatListObject",
                                             nil];
                        
                        // 点击一条去单聊页
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailMixView" object:self userInfo:dic];
                        
                        [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
                        
                    }else if ([@"group"  isEqual: dataObject.node]) {
                        // 群聊
                        MixChatListObject *chatListObject = [[MixChatListObject alloc] init];
                        
                        chatListObject.user_id = 0;
                        chatListObject.title = dataObject.name;
                        chatListObject.gid = dataObject.idNumber.longLongValue;
#if 1
                        chatListObject.schoolID = [dataObject.sid longLongValue];
#endif
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"user",@"frontName",
                                             chatListObject, @"mixChatListObject",
                                             dataObject.member,@"userNumber",
                                             nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailMixView" object:self userInfo:dic];
                        
                        [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
            }else {
                [self.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
                
                
                
                
                
                RADataObject *dataObject = item;
                
                // 该节点没有child，直接对其设置isSelect即可
                dataObject.isSelected = !dataObject.isSelected;
                [treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
                
                // 将uid添加到uid列表当中 选中一条
                [self addOrDeleteToSelectedMemberArray:dataObject status:dataObject.isSelected];
                
                // 还需要判断父节点的状态，看结果设置isSelect是否已选的状态
                RADataObject * parent = [self.treeView parentForItem:item];
                if (nil != parent) {
                    // 如果有父节点
                    if (0 != parent.isSelected) {
                        // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                        parent.isSelected = 0;
                        [treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                    }else {
                        // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                        BOOL isAllSelect = YES;
                        
                        NSArray *childrenData = parent.children;
                        for (int i=0; i<[childrenData count]; i++) {
                            RADataObject *childrenObj = [childrenData objectAtIndex:i];
                            
                            if (!childrenObj.isSelected) {
                                isAllSelect = NO;
                            }
                        }
                        
                        parent.isSelected = isAllSelect;
                        [treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                // 还需要判断父节点的父节点的状态，看结果设置isSelect是否已选的状态
                RADataObject * parentParent = [self.treeView parentForItem:parent];
                if (nil != parentParent) {
                    // 如果有父节点的父节点
                    if (0 != parentParent.isSelected) {
                        // 如果父节点的父节点的isSelect状态是设置的，则需要把其状态设为0
                        parentParent.isSelected = 0;
                        [treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                    }else {
                        // 如果父节点的父节点isSelect状态为未设置，则需要判断这个父节点下的的父节点所有子节点是否为已选状态
                        BOOL isAllSelectParent = YES;
                        
                        NSArray *childrenParentData = parentParent.children;
                        for (int i=0; i<[childrenParentData count]; i++) {
                            RADataObject *childrenObj = [childrenParentData objectAtIndex:i];
                            
                            if (!childrenObj.isSelected) {
                                isAllSelectParent = NO;
                            }
                        }
                        
                        parentParent.isSelected = isAllSelectParent;
                        [treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                [self showHead];

                // 判断已选择的uid列表是否为空，来设置右button的状态。
                NSString *rightButtonName = @"";
                if (nil != _settingMembersArray) {
                    rightButtonName = @"确定";
                }else {
                    rightButtonName = @"创建";
                }
                
                NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
                
                if ([@"确定"  isEqual: rightButtonName]) {
                    if (0 < [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                    }else {
                        if (1 == [_selectedMembersArray count]) {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                        }else {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                        }
                    }
                }else {
                    if (1 < [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                    }else {
                        if (1 == [_selectedMembersArray count]) {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                            
                            //
                            
                        }else {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                            
                            //
                            
                        }
                    }
                }

                
            }
    }
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.treeView parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];

    NSInteger t = 0;
    NSArray *a = dataObject.children;
    for (int i=0; i<[a count]; i++) {
        RADataObject *dataObjecta = [a objectAtIndex:i];
        
        if ([@"leaf"  isEqual: dataObjecta.node]) {
            // 如果子节点还有子节点的话话，需要把子节点的的所有子节点的数量累加，显示总和
            t = t + [dataObjecta.children count];
        }else {
            t = [dataObject.children count];
        }
    }

    numberOfChildren = t;
    
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded hasChildren:numberOfChildren isPerson:dataObject.node];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if ((![@"person"  isEqual: dataObject.node]) && (![@"group"  isEqual: dataObject.node])) {
        cell.canExpand = YES;
    }else {
        cell.canExpand = NO;
    }
    
    if ((![@"person"  isEqual: dataObject.node]) && (![@"group"  isEqual: dataObject.node])) {
        // 父节点，需要显示成员个数
        cell.label_number.hidden = NO;
        
        // 这里最多支持10000个，有时间可以写成动态的
        if ([@"chatMemberSelect"  isEqual: _viewType]) {
            cell.label_number.frame = CGRectMake(240, (44-20)/2, 45, 20);
        }else {
            cell.label_number.frame = CGRectMake(260, (44-20)/2, 45, 20);
        }
        
        cell.label_number.text = [NSString stringWithFormat:@"%ld", (long)numberOfChildren];
        
        // 还要显示小箭头
        cell.imageView_arrow.hidden = NO;
        
        if (expanded) {
            cell.imageView_arrow.image = [UIImage imageNamed:@"CommonIconsAndPics/contactsArrowDown.png"];
        }else {
            cell.imageView_arrow.image = [UIImage imageNamed:@"CommonIconsAndPics/contactsArrowRight.png"];
        }

        cell.imageView_head.hidden = YES;
    }else {
        cell.label_number.hidden = YES;
        cell.imageView_arrow.hidden = YES;
        cell.imageView_head.hidden = NO;

        if ([@"group"  isEqual: dataObject.node]) {
            
            //---add by kate---------------------------------------------
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *returnArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempArray = [self getHeadArray:[dataObject.idNumber longLongValue]];
            
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
                
                UIImage *image = [headDiction objectForKey:[NSString stringWithFormat:@"%lld",[dataObject.idNumber longLongValue]]];
                
                if (image!=nil) {
                    
                    cell.imageView_head.image = image;
                    
                }else{
                    
                    [self initImageposition];
                    NSLog(@"returnArrayCount:%lu",(unsigned long)[returnArray count]);
                    UIImage *image = [self makeGroupAvatar:returnArray];
                    if (image) {
                        
                        
                        [headDiction setObject:image forKey:[NSString stringWithFormat:@"%lld",[dataObject.idNumber longLongValue]]];
                        
                    }else{
                        NSLog(@"nil");
                    }
                    
                    cell.imageView_head.image = image;
                    
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
                                
                                cell.imageView_head.image = image;
                                
                            }
                        });
                        
                    });
                    
                }
                
            }
 
            
            //------------------------------------------------------------
            
            //[cell.imageView_head sd_setImageWithURL:[NSURL URLWithString:dataObject.avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

        }else if ([@"person"  isEqual: dataObject.node]) {
            [cell.imageView_head sd_setImageWithURL:[NSURL URLWithString:dataObject.avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
    }

    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
#if 0
        // 这里可以删除
        [((RADataObject *)[_data objectAtIndex:0]).children removeObjectAtIndex:0];

        ((RADataObject *)[_data objectAtIndex:0]).isSelected = YES;
        
        ((RADataObject *)[((RADataObject *)[_data objectAtIndex:1]).children objectAtIndex:3]).isSelected = YES;

        [weakSelf.treeView reloadData];
#endif
        
        NSArray *children = dataObject.children;

        if (0 == [children count]) {
            // 该节点没有child，直接对其设置isSelect即可
            dataObject.isSelected = !dataObject.isSelected;
            [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
            
            // 将uid添加到uid列表当中
            [self addOrDeleteToSelectedMemberArray:dataObject status:dataObject.isSelected];

            // 还需要判断父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parent = [self.treeView parentForItem:item];
            if (nil != parent) {
                // 如果有父节点
                if (0 != parent.isSelected) {
                    // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                    parent.isSelected = 0;
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                    BOOL isAllSelect = YES;
                    
                    NSArray *childrenData = parent.children;
                    for (int i=0; i<[childrenData count]; i++) {
                        RADataObject *childrenObj = [childrenData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelect = NO;
                        }
                    }
                    
                    parent.isSelected = isAllSelect;
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }

            // 还需要判断父节点的父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parentParent = [self.treeView parentForItem:parent];
            if (nil != parentParent) {
                // 如果有父节点的父节点
                if (0 != parentParent.isSelected) {
                    // 如果父节点的父节点的isSelect状态是设置的，则需要把其状态设为0
                    parentParent.isSelected = 0;
                    [weakSelf.treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的父节点isSelect状态为未设置，则需要判断这个父节点下的的父节点所有子节点是否为已选状态
                    BOOL isAllSelectParent = YES;
                    
                    NSArray *childrenParentData = parentParent.children;
                    for (int i=0; i<[childrenParentData count]; i++) {
                        RADataObject *childrenObj = [childrenParentData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelectParent = NO;
                        }
                    }
                    
                    parentParent.isSelected = isAllSelectParent;
                    [weakSelf.treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
            
            [self showHead];
        }else {
            // 该节点有child, 需要一起设置该父节点下的所有子节点状态
            dataObject.isSelected = !dataObject.isSelected;
            
            NSMutableArray *childrenData = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[children count]; i++) {
                // 如果选择的cell带子节点，则去遍历子节点，并且都给设置为和parent同样的状态
                RADataObject * data = [children objectAtIndex:i];
                
                if (data.editable) {
                    // 可编辑状态下才设置
                    data.isSelected = dataObject.isSelected;
                    
                    // 将uid添加到uid列表当中
                    [self addOrDeleteToSelectedMemberArray:data status:data.isSelected];
                }
                
                [childrenData addObject:data];
                
                if ([self.treeView isCellForItemExpanded:item]) {
                    [weakSelf.treeView reloadRowsForItems:@[data] withRowAnimation:RATreeViewRowAnimationNone];
                }
                
                // 如果子节点还带一层子节点，还是去遍历以及设置状态
                NSArray *childrenChildren = data.children;
                
                NSMutableArray *childrenChildrenData = [[NSMutableArray alloc] init];
                for (int j=0; j<[childrenChildren count]; j++) {
                    RADataObject *dataChildren = [childrenChildren objectAtIndex:j];
                    if (dataChildren.editable) {
                        // 可编辑状态下才设置
                        dataChildren.isSelected = dataObject.isSelected;
                        
                        // 将uid添加到uid列表当中
                        [self addOrDeleteToSelectedMemberArray:dataChildren status:dataChildren.isSelected];
                    }

                    [childrenChildrenData addObject:dataChildren];
                    
                    if ([self.treeView isCellForItemExpanded:data]) {
                        [weakSelf.treeView reloadRowsForItems:@[dataChildren] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                data.children = childrenChildrenData;
            }
            dataObject.children = childrenData;
            
            [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
            
            [self showHead];

            // 该节点也有父节点
            RADataObject * parent = [self.treeView parentForItem:dataObject];
            
            if (nil != parent) {
                // 如果有父节点
                if (0 != parent.isSelected) {
                    // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                    parent.isSelected = 0;
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                    BOOL isAllSelect = YES;
                    
                    NSArray *childrenData = parent.children;
                    for (int i=0; i<[childrenData count]; i++) {
                        RADataObject *childrenObj = [childrenData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelect = NO;
                        }
                    }
                    
                    parent.isSelected = isAllSelect;
                    
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
        }
        
        // 判断已选择的uid列表是否为空，来设置右button的状态。
        NSString *rightButtonName = @"";
        if (nil != _settingMembersArray) {
            rightButtonName = @"确定";
        }else {
            rightButtonName = @"创建";
        }
        
        NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
        
        if ([@"确定"  isEqual: rightButtonName]) {
            if (0 < [_selectedMembersArray count]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
            }else {
                if (1 == [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                }else {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                    [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    }
            }
        }else {
            if (1 < [_selectedMembersArray count]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
            }else {
                if (1 == [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                     [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    
                    //
                    
                }else {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                    [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    
                    //
                    
                }
            }
        }
    };
    
    cell.additionButtonHidden = YES;
    
    if ([@"chatMemberSelect"  isEqual: _viewType]) {
        [cell setAdditionButtonHidden:NO animated:YES];

        // 先查看是否是从setting页面跳转过来的
        if (nil != _settingMembersArray) {
            if (dataObject.editable) {
                if (dataObject.isSelected) {
                    [cell.additionButton setImage:[UIImage imageNamed:@"checkImg_press.png"] forState:UIControlStateNormal];
                    cell.isSelected = YES;
                    cell.additionButton.enabled = YES;
                }else {
                    [cell.additionButton setImage:[UIImage imageNamed:@"checkImg_normal.png"] forState:UIControlStateNormal];
                    cell.isSelected = NO;
                    cell.additionButton.enabled = YES;
                }
            }else {
                //Chenth 2.22
#if 1
                if (dataObject.children.count == 0 && [dataObject.idNumber integerValue] <= 0) {
                    [cell.additionButton setImage:[UIImage imageNamed:@"checkImg_normal.png"] forState:UIControlStateNormal];
                }else{
                [cell.additionButton setImage:[UIImage imageNamed:@"CommonIconsAndPics/defaultSelected"] forState:UIControlStateNormal];
                }
#else
                
                [cell.additionButton setImage:[UIImage imageNamed:@"CommonIconsAndPics/defaultSelected"] forState:UIControlStateNormal];
#endif
                cell.additionButton.enabled = NO;
            }
        }else {
            if (dataObject.isSelected) {
                [cell.additionButton setImage:[UIImage imageNamed:@"checkImg_press.png"] forState:UIControlStateNormal];
                cell.isSelected = YES;
            }else {
                [cell.additionButton setImage:[UIImage imageNamed:@"checkImg_normal.png"] forState:UIControlStateNormal];
                cell.isSelected = NO;
            }
        }
        
    }

    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

- (void)doGetContacts {
    /**
     * 通讯录联系人列表
     * @author luke
     * @date 2016.01.14
     * @args
     *  v=2, ac=Contact, op=contacts, sid=, cid=, uid=
     */
    
    /**
     * 群聊联系人列表，去除了群聊的分支
     * @author luke
     * @date 2016.01.20
     * @args
     *  v=2, ac=Contact, op=groupContacts, sid=, cid=, uid=
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSString *op = @"";
    if ([@"chatMemberSelect"  isEqual: _viewType]) {
        op = @"groupContacts";
    }else if ([@"contactsList"  isEqual: _viewType]) {
        op = @"contacts";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Contact",@"ac",
                          @"2",@"v",
                          op, @"op",
                          _cid, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            NSArray *list = [respDic objectForKey:@"message"];
            
            for (int i=0; i<[list count]; i++) {
                NSDictionary *dic = [list objectAtIndex:i];
                
                NSMutableArray *rootData = [NSMutableArray arrayWithArray:[dic objectForKey:@"data"]];
                
                RADataObject *dataObj;
                if (0 != [rootData count]) {
                    // 带子节点的时候
                    NSMutableArray *childrenArr = [[NSMutableArray alloc] init];
                    
                    for (int j=0; j<[rootData count]; j++) {
                        // 遍历子节点，并且把子节点增加到parent上
                        NSMutableDictionary *dicChildren = [NSMutableDictionary dictionaryWithDictionary:[rootData objectAtIndex:j]];
                        
                        //Chenth 3.1
                        if(![[dicChildren allKeys] containsObject:@"sid"]){
                            [dicChildren setValue:G_SCHOOL_ID forKey:@"sid"];
                        }
                        NSMutableArray *childrenData = [NSMutableArray arrayWithArray:[dicChildren objectForKey:@"data"]];

                        NSString *uidChild = [dicChildren objectForKey:@"id"];
                        
                        for (id item in _settingMembersArray) {
                            NSString *uid = (NSString *)item;
                            
                            // 先查看是否是从setting页面跳转过来的
                            if (nil != _settingMembersArray) {
#if 1
                               if ([uid isEqualToString:uidChild] && [_settingSidArray containsObject:[dicChildren objectForKey:@"sid"]]) {
#else
                                
                                if ([uid isEqualToString:uidChild]) {
#endif
                                    [dicChildren setObject:@"1" forKey:@"isSelected"];
                                    [dicChildren setObject:@"0" forKey:@"editable"];
                                    break;
                                }else {
                                }
                            }
                        }
                        
                        RADataObject *dataObjChildren;
                        if (0 != [childrenData count]) {
                            NSMutableArray *childrenChildrenArr = [[NSMutableArray alloc] init];
                            
                            for (int k=0; k<[childrenData count]; k++) {
                                // 遍历子节点的子节点，并且把子节点的子节点都增加到parent上
                                NSMutableDictionary *dicChildrenChildren = [NSMutableDictionary dictionaryWithDictionary:[childrenData objectAtIndex:k]];

                                //Chenth 3.1
                                if(![[dicChildrenChildren allKeys] containsObject:@"sid"]){
                                    [dicChildrenChildren setValue:G_SCHOOL_ID forKey:@"sid"];
                                }
                                NSMutableArray *childrenChildrenData = [NSMutableArray arrayWithArray:[dicChildrenChildren objectForKey:@"data"]];
                                
                                NSString *uidChildChild = [dicChildrenChildren objectForKey:@"id"];
                                
                                for (id item in _settingMembersArray) {
                                    NSString *uid = (NSString *)item;
                                    
                                    // 先查看是否是从setting页面跳转过来的
                                    if (nil != _settingMembersArray) {
                                        
#if 1
                                        if ([uid isEqualToString:uidChildChild] && [_settingSidArray containsObject:[dicChildrenChildren objectForKey:@"sid"]]) {
#else
                                        
                                        if ([uid isEqualToString:uidChildChild]) {
#endif
                                            [dicChildrenChildren setObject:@"1" forKey:@"isSelected"];
                                            [dicChildrenChildren setObject:@"0" forKey:@"editable"];
                                            break;
                                        }else {
                                        }
                                    }
                                }

                                RADataObject *dataObjChildrenChildren;
                                if (0 != [childrenChildrenData count]) {
                                    // 如果还有第四级菜单的时候写在这里，目前需求是三层的
                                }else {
                                    dataObjChildrenChildren = [RADataObject dataObjectWithDic:dicChildrenChildren children:nil];
                                }
                                [childrenChildrenArr addObject:dataObjChildrenChildren];
                            }
                            
                            dataObjChildren = [RADataObject dataObjectWithDic:dicChildren children:childrenChildrenArr];
                            
                        }else {
                            // 没有子节点的子节点的时候
                            dataObjChildren = [RADataObject dataObjectWithDic:dicChildren children:nil];
                        }
                        
                        [childrenArr addObject:dataObjChildren];
                    }
 
                    dataObj = [RADataObject dataObjectWithDic:dic children:childrenArr];

                }else {
                    // 没有子节点的时候
                    dataObj = [RADataObject dataObjectWithDic:dic children:nil];
                }
                
                [_data addObject:dataObj];
            }
            
            // 先查看是否是从setting页面跳转过来的，如果是则需要判断子节点是否被全选了，
            // 如果被全选了，则需要把父节点置为不可点击状态。
            if (nil != _settingMembersArray) {
                for (int i=0; i<[_data count]; i++) {
                    RADataObject *dataObjRoot = [_data objectAtIndex:i];
                    
                    BOOL isAllEditableChild = NO;

                    if (nil != dataObjRoot.children) {
                        // 如果该父节点有子节点的话
                        NSArray *arrChildren = dataObjRoot.children;
                        
                        for (int j=0; j<[arrChildren count]; j++) {
                            // 遍历子节点的数据
                            RADataObject *dataObjRootChild = [arrChildren objectAtIndex:j];

                            // 如果子节点还有子节点
                            BOOL isAllEditableChildChild = NO;
                            
                            if (nil != dataObjRootChild.children) {
                                NSArray *arrChildrenChildren = dataObjRootChild.children;
                                
                                for (int k=0; k<[arrChildrenChildren count]; k++) {
                                    // 遍历子节点的数据
                                    RADataObject *dataObjRootChildChild = [arrChildrenChildren objectAtIndex:k];
                                    
                                    if (dataObjRootChildChild.editable) {
                                        // 只要有一个是可以编辑的，所有的就都是可以编辑的
                                        isAllEditableChildChild = YES;
                                        isAllEditableChild = YES;
                                    }
                                }
                                
                                if (0 != [arrChildrenChildren count]) {
                                    if (isAllEditableChildChild) {
                                        ((RADataObject *)[((RADataObject *)[_data objectAtIndex:i]).children objectAtIndex:j]).editable = YES;
                                    }else {
                                        ((RADataObject *)[((RADataObject *)[_data objectAtIndex:i]).children objectAtIndex:j]).editable = NO;
                                    }
                                }
                            }
                            
                            if (dataObjRootChild.editable) {
                                isAllEditableChild = YES;
                            }
                        }
                    }else{
                        isAllEditableChild = NO;
                    }
                    
                    if (isAllEditableChild) {
                        ((RADataObject *)[_data objectAtIndex:i]).editable = YES;
                    }else {
                        ((RADataObject *)[_data objectAtIndex:i]).editable = NO;
                    }
                }
            }

            
            [self.treeView reloadData];
        } else {
            [Utilities showTextHud:@"获取信息错误，请稍候再试" descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

// 创建群
-(void)createGroup {
    
    /**
     * 发起群聊天：创建群
     * 1. 教师
     * @author luke
     * @date    2015.05.26
     * @args
     *  op=setup, sid=, cid=, uid=, members=uid,...
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"setup", @"op",
                          _selectedMembersStr,@"members",
                          _cid,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        /*
         respDic:{
         message =     {
         gid = 143;
         message =         {
         avatar = "http://test.5xiaoyuan.cn/ucenter/avatar.php?uid=63255&size=big&type=&timestamp=1427860027";
         cid = 6089;
         dateline = 1432815046;
         gid = 143;
         message = "\U7fa4\U521b\U5efa\U6210\U529f";
         mid = 6392;
         msgid = 1432878301;
         name = "\U4e1b\U5343\U91cc";
         type = 10;
         uid = 63255;
         url = "";
         };
         uid = 63255;
         name = "\U7fa4\U804a";
         };
         protocol = "GroupChatAction.setup";
         result = 1;
         }
         */
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSDictionary *subDic = [dic objectForKey:@"message"];
            // 群id
            NSString *gid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"gid"]]];
            // 发送方uid
//            NSString *sendUid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]]];
            // 群名字
            NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
            // 班级id
//            NSString *cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"cid"]]];
            // 发送方头像
            //NSString *avatar = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"avatar"]]];
            // 时间戳
            NSString *timestamp =[Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"dateline"]]];
            // 接收的消息
            NSString *msg_content = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"message"]]];
            // 消息类型
            // NSString *type = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"type"]]];
            // 服务器返回的最后一条消息id
            NSString *mid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"type"]]];
            // 消息id
            NSString *msgid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[subDic objectForKey:@"msgid"]]];
            
            //To do:更新数据库
            MixChatDetailObject *groupChatDetailObject = [[MixChatDetailObject alloc] init];
            groupChatDetailObject.groupid = [gid longLongValue];
            groupChatDetailObject.msg_content = msg_content;
            groupChatDetailObject.msg_type = 3;//创建群
            groupChatDetailObject.msg_id = [msgid longLongValue];
            groupChatDetailObject.is_recieved = MSG_IO_FLG_RECEIVE;
            groupChatDetailObject.msg_state = MSG_RECEIVED_SUCCESS;
            groupChatDetailObject.timestamp = [timestamp longLongValue]*1000;
            
            // 用群聊返回的uid
            groupChatDetailObject.user_id = [[dic objectForKey:@"uid"] integerValue];
            
            NSLog(@"content:%@",groupChatDetailObject.msg_content);
            [groupChatDetailObject updateToDB];
            
            MixChatListObject *groupChatListObject = [[MixChatListObject alloc] init];
            groupChatListObject.bother = 0;
            groupChatListObject.gid = [gid longLongValue];
            groupChatListObject.user_id = 0;
            groupChatListObject.is_recieved = MSG_IO_FLG_RECEIVE;
            //最后一条消息ID
            groupChatListObject.last_msg_id= groupChatDetailObject.msg_id;
            // 聊天的最后一条消息的类型
            groupChatListObject.last_msg_type= groupChatDetailObject.msg_type;
            // 聊天的最后一条消息内容
            groupChatListObject.last_msg = groupChatDetailObject.msg_content;
            //该条消息状态
            groupChatListObject.msg_state = MSG_RECEIVED_SUCCESS;
            groupChatListObject.mid = mid;
            groupChatListObject.title = name;// 群名字
            groupChatListObject.timestamp = groupChatDetailObject.timestamp;
            BOOL isExist = [groupChatListObject updateToDB];
            [groupChatListObject updateGroupName];
            
            // 获取群头像url存在一个数据表中，判断chatList中是否有gid了，如果没有就拉取群头像，有就不拉
            if (!isExist) {//不存在
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"GroupChat",@"ac",
                                      @"2",@"v",
                                      @"getGroupAvatar", @"op",
                                      [NSString stringWithFormat:@"%lli",groupChatListObject.gid],@"gid",
                                      nil];
                
                [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                    
                    NSDictionary *respDic = (NSDictionary*)responseObject;
                    NSString *result = [respDic objectForKey:@"result"];
                    
                    if(true == [result intValue]) {
                        
                        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
                        
                        //群聊数量
                        NSString *memberNum = [[[respDic objectForKey:@"message"] objectForKey:@"profile"] objectForKey:@"member"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserNumer" object:memberNum];
                        
                        
                        GroupChatListHeadObject *headObject = [[GroupChatListHeadObject alloc] init];
                        headObject.gid = groupChatListObject.gid;
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
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DB_GET_CHAT_LIST_DATA object:nil];//update by kate
                        
                    }
                    
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                    
                }];
                
            }


            if (nil != _addToGroupChat) {
                // 单聊转群聊
                [[NSNotificationCenter defaultCenter] postNotificationName:@"settingChatToGroupChat" object:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsGoToGroupChatDetail" object:groupChatListObject];
            [self dismissViewControllerAnimated:YES completion:nil];

        } else {
            [Utilities showTextHud:[NSString stringWithFormat:@"%@", [respDic objectForKey:@"message"]] descView:self.view];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)test
{
    // 刷新ContactsListView
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashContactsListView" object:nil];
}

- (void)addOrDeleteToSelectedMemberArray:(RADataObject *)dataObj status:(BOOL)status
{
    if (nil != dataObj.idNumber) {
        BOOL ifAddedThisTag = NO;
#if 1
        NSUInteger pos;

        NSMutableArray *tempSameUidArray = [NSMutableArray array];
        if([_selectedMembersArray containsObject:dataObj.idNumber]){
            for(NSInteger i = 0; i < _selectedMembersArray.count; i++){
                if([_selectedMembersArray[i] isEqualToString:dataObj.idNumber]){
                    [tempSameUidArray addObject:[NSString stringWithFormat:@"%ld", i]];
                }
            }
        }

        NSMutableArray *tempSameUidsSidArray = [NSMutableArray array];
        if([_selectedSidArray containsObject:dataObj.sid]){
            for(NSInteger i = 0; i < _selectedMembersArray.count; i++){
                if([_selectedSidArray[i] isEqualToString:dataObj.sid]){
                    [tempSameUidsSidArray addObject:[NSString stringWithFormat:@"%ld", i]];
                }
            }
        }
        
        for(NSInteger i = 0; i < tempSameUidArray.count; i++){
            if([tempSameUidsSidArray containsObject:tempSameUidArray[i]]){
                ifAddedThisTag = YES;
                pos = [tempSameUidArray[i] integerValue];
            }
        }
        
#else
        NSUInteger pos = [_selectedMembersArray indexOfObject:dataObj.idNumber];
        pos = [_selectedMembersArray indexOfObject:dataObj.idNumber];
        NSMutableArray *tempSameUidsSidArray = [NSMutableArray array];
        
#endif
        if (status) {
            // 选择状态
#if 1
            if (!ifAddedThisTag) {
#else
            
            if (NSNotFound == pos) {
#endif
                // 没有选择过，则添加。
                [_selectedMembersArray addObject:dataObj.idNumber];
#if 1
                if([dataObj.sid integerValue] > 1){
                    [_selectedSidArray addObject:dataObj.sid];
                }else{
                    [_selectedSidArray addObject:G_SCHOOL_ID];
                }
#endif
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10.0*_selectedCount + 35.0*_selectedCount +10, 5.0, 35.0, 35.0)];
                [imgV sd_setImageWithURL:[NSURL URLWithString:dataObj.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
                imgV.layer.masksToBounds = YES;
                imgV.layer.cornerRadius = imgV.frame.size.height/2.0;
#if 1
                imgV.tag = [dataObj.idNumber integerValue]  + [dataObj.sid integerValue] * 1000000;
#else
                
                imgV.tag = [dataObj.idNumber integerValue];
#endif
                
                imgV.userInteractionEnabled = YES;
                
                UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.0, 35.0)];
#if 1
                headBtn.tag = ([dataObj.idNumber integerValue]+5000) + [dataObj.sid integerValue] * 1000000;
#else
                
                headBtn.tag = ([dataObj.idNumber integerValue]+5000);
#endif
                
                headBtn.backgroundColor = [UIColor clearColor];
                [headBtn addTarget:self action:@selector(deleteHeadBtnFromScrollView:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:headBtn];
                
                if (![_headScrollView viewWithTag:imgV.tag]) {
                    [_headScrollView addSubview:imgV];
                    [_headViewArray addObject:imgV];
                }
            }else {
                if (!status) {
                    [_selectedMembersArray removeObjectAtIndex:pos];
#if 1
                    [_selectedSidArray removeObjectAtIndex:pos];
                    UIImageView *imgV = (UIImageView*)[_headScrollView viewWithTag:[dataObj.idNumber integerValue] + [dataObj.sid integerValue] * 1000000];
#else
                     UIImageView *imgV = (UIImageView*)[_headScrollView viewWithTag:[dataObj.idNumber integerValue]];
#endif
                    if (imgV){
                        [imgV removeFromSuperview];
                        [_headViewArray removeObject:imgV];
                    }
                }
            }
        }else {
            // 删除状态
            BOOL isExist = [_selectedMembersArray containsObject:dataObj.idNumber];
            if (isExist) {
                [_selectedMembersArray removeObjectAtIndex:pos];
#if 1
                [_selectedSidArray removeObjectAtIndex:pos];
#endif
            }
#if 1
            UIImageView *imgV = (UIImageView*)[_headScrollView viewWithTag:[dataObj.sid integerValue] * 1000000 + [dataObj.idNumber integerValue]];
#else
            UIImageView *imgV = (UIImageView*)[_headScrollView viewWithTag:[dataObj.idNumber integerValue]];
#endif
            if (imgV){
                [imgV removeFromSuperview];
                [_headViewArray removeObject:imgV];
            }
        }
    }
    
    _selectedCount = [_selectedMembersArray count];
    
    // 按照已选择头像的数量设置scrollView的contentSize
    _headScrollView.contentSize = CGSizeMake(35.0*(_selectedCount+1) + 10*(_selectedCount+1) + 10, 0.0);

//    [self showHead];
}

// 删除头像从scrollView
-(void)deleteHeadBtnFromScrollView:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger tag = btn.tag;
    
    NSInteger imgTag = tag - 5000;// 同时是uid
    
    UIImageView *headV = (UIImageView*)[_headScrollView viewWithTag:imgTag];
    
    if (headV) {
        //To do: 删除scroview上的头像，同时删除checkListArray对应的值
        [headV removeFromSuperview];
        [_headViewArray removeObject:headV];
        
        RADataObject *objInfo = [self getInfoFormData:[NSString stringWithFormat:@"%ld", (long)imgTag] fromPic:1];
        
//        objInfo.isSelected = NO;
        
//        RATableViewCell *cell = (RATableViewCell *)[_treeView cellForItem:objInfo];
//        if (nil != cell) {
//            [self.treeView reloadRowsForItems:@[cell] withRowAnimation:RATreeViewRowAnimationNone];
//        }

        [self addOrDeleteToSelectedMemberArray:objInfo status:objInfo.isSelected];

        
        
        
#if 0
        // 这里可以删除
        [((RADataObject *)[_data objectAtIndex:0]).children removeObjectAtIndex:0];
        
        ((RADataObject *)[_data objectAtIndex:0]).isSelected = YES;
        
        ((RADataObject *)[((RADataObject *)[_data objectAtIndex:1]).children objectAtIndex:3]).isSelected = YES;
        
        [weakSelf.treeView reloadData];
#endif
        __weak typeof(self) weakSelf = self;

        NSArray *children = objInfo.children;
        
        if (0 == [children count]) {
            // 该节点没有child，直接对其设置isSelect即可
            objInfo.isSelected = !objInfo.isSelected;
            
            RATableViewCell *cell = (RATableViewCell *)[_treeView cellForItem:objInfo];
            if (nil != cell) {
                NSArray *a = [weakSelf.treeView visibleCells];
                BOOL b = [a containsObject:cell];
            
                if (b) {
                    [weakSelf.treeView reloadRowsForItems:@[objInfo] withRowAnimation:RATreeViewRowAnimationNone];

                }
            }

//            BOOL isExpand = [weakSelf.treeView isCellForItemExpanded:objInfo];
//            
//            if (isExpand) {
//            }
            
            // 将uid添加到uid列表当中
            [self addOrDeleteToSelectedMemberArray:objInfo status:objInfo.isSelected];
            
            // 还需要判断父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parent = [self.treeView parentForItem:objInfo];
            if (nil != parent) {
                // 如果有父节点
                if (0 != parent.isSelected) {
                    // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                    parent.isSelected = 0;
                    
                    RATableViewCell *cell = (RATableViewCell *)[_treeView cellForItem:parent];
                    if (nil != cell) {
                        NSArray *a = [weakSelf.treeView visibleCells];
                        BOOL b = [a containsObject:cell];
                        
                        if (b) {
                            [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                            
                        }
                    }

//                    BOOL isExpand = [weakSelf.treeView isCellForItemExpanded:parent];
//                    
//                    if (isExpand) {
//                        [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
//                    }
                }else {
                    // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                    BOOL isAllSelect = YES;
                    
                    NSArray *childrenData = parent.children;
                    for (int i=0; i<[childrenData count]; i++) {
                        RADataObject *childrenObj = [childrenData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelect = NO;
                        }
                    }
                    
                    parent.isSelected = isAllSelect;
                    
                    RATableViewCell *cell = (RATableViewCell *)[_treeView cellForItem:parent];
                    if (nil != cell) {
                        NSArray *a = [weakSelf.treeView visibleCells];
                        BOOL b = [a containsObject:cell];
                        
                        if (b) {
                            [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                            
                        }
                    }

//                    BOOL isExpand = [weakSelf.treeView isCellForItemExpanded:parent];
//                    
//                    if (isExpand) {
//                        [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
//                    }
                }
            }
            
            // 还需要判断父节点的父节点的状态，看结果设置isSelect是否已选的状态
            RADataObject * parentParent = [self.treeView parentForItem:parent];
            if (nil != parentParent) {
                // 如果有父节点的父节点
                if (0 != parentParent.isSelected) {
                    // 如果父节点的父节点的isSelect状态是设置的，则需要把其状态设为0
                    parentParent.isSelected = 0;
                    
                    BOOL isExpand = [weakSelf.treeView isCellForItemExpanded:parentParent];
                    
                    if (isExpand) {
                        [weakSelf.treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }else {
                    // 如果父节点的父节点isSelect状态为未设置，则需要判断这个父节点下的的父节点所有子节点是否为已选状态
                    BOOL isAllSelectParent = YES;
                    
                    NSArray *childrenParentData = parentParent.children;
                    for (int i=0; i<[childrenParentData count]; i++) {
                        RADataObject *childrenObj = [childrenParentData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelectParent = NO;
                        }
                    }
                    
                    parentParent.isSelected = isAllSelectParent;
                    
                    RATableViewCell *cell = (RATableViewCell *)[_treeView cellForItem:parentParent];
                    if (nil != cell) {
                        NSArray *a = [weakSelf.treeView visibleCells];
                        BOOL b = [a containsObject:cell];
                        
                        if (b) {
                            [weakSelf.treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                            
                        }
                    }

//                    BOOL isExpand = [weakSelf.treeView isCellForItemExpanded:parentParent];
//                    
//                    if (isExpand) {
//                        [weakSelf.treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
//                    }
                }
            }
        }else {
            // 该节点有child, 需要一起设置该父节点下的所有子节点状态
            objInfo.isSelected = !objInfo.isSelected;
            
            NSMutableArray *childrenData = [[NSMutableArray alloc] init];
            for (int i=0; i<[children count]; i++) {
                // 如果选择的cell带子节点，则去遍历子节点，并且都给设置为和parent同样的状态
                RADataObject * data = [children objectAtIndex:i];
                
                if (data.editable) {
                    // 可编辑状态下才设置
                    data.isSelected = objInfo.isSelected;
                    
                    // 将uid添加到uid列表当中
                    [self addOrDeleteToSelectedMemberArray:data status:data.isSelected];
                }
                
                [childrenData addObject:data];
                
                if ([self.treeView isCellForItemExpanded:objInfo]) {
                    [weakSelf.treeView reloadRowsForItems:@[data] withRowAnimation:RATreeViewRowAnimationNone];
                }
                
                // 如果子节点还带一层子节点，还是去遍历以及设置状态
                NSArray *childrenChildren = data.children;
                
                NSMutableArray *childrenChildrenData = [[NSMutableArray alloc] init];
                for (int j=0; j<[childrenChildren count]; j++) {
                    RADataObject *dataChildren = [childrenChildren objectAtIndex:j];
                    if (dataChildren.editable) {
                        // 可编辑状态下才设置
                        dataChildren.isSelected = objInfo.isSelected;
                        
                        // 将uid添加到uid列表当中
                        [self addOrDeleteToSelectedMemberArray:dataChildren status:dataChildren.isSelected];
                    }
                    
                    [childrenChildrenData addObject:dataChildren];
                    
                    if ([self.treeView isCellForItemExpanded:data]) {
                        [weakSelf.treeView reloadRowsForItems:@[dataChildren] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                data.children = childrenChildrenData;
            }
            objInfo.children = childrenData;
            
            [weakSelf.treeView reloadRowsForItems:@[objInfo] withRowAnimation:RATreeViewRowAnimationNone];
            
            // 该节点也有父节点
            RADataObject * parent = [self.treeView parentForItem:objInfo];
            
            if (nil != parent) {
                // 如果有父节点
                if (0 != parent.isSelected) {
                    // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                    parent.isSelected = 0;
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }else {
                    // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                    BOOL isAllSelect = YES;
                    
                    NSArray *childrenData = parent.children;
                    for (int i=0; i<[childrenData count]; i++) {
                        RADataObject *childrenObj = [childrenData objectAtIndex:i];
                        
                        if (!childrenObj.isSelected) {
                            isAllSelect = NO;
                        }
                    }
                    
                    parent.isSelected = isAllSelect;
                    
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
        }
        
        NSString *rightButtonName = @"";
        if (nil != _settingMembersArray) {
            rightButtonName = @"确定";
        }else {
            rightButtonName = @"创建";
        }

        NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
        
        if ([@"确定"  isEqual: rightButtonName]) {
            if (0 < [_selectedMembersArray count]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
            }else {
                if (1 == [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                }else {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                      [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                }
            }
        }else {
            if (1 < [_selectedMembersArray count]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
            }else {
                if (1 == [_selectedMembersArray count]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                     [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    
                }else {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                    [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:174/255.0f green:221/255.0f blue:215/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                    
                }
            }
        }
        

//        // 判断已选择的uid列表是否为空，来设置右button的状态。
//        NSString *rightButtonName = @"";
//        if (nil != _settingMembersArray) {
//            rightButtonName = @"确定";
//        }else {
//            rightButtonName = @"创建";
//        }
//        
//        NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
//        
//        if (1 < [_selectedMembersArray count]) {
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//            [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
//        }else {
//            if (1 == [_selectedMembersArray count]) {
//                self.navigationItem.rightBarButtonItem.enabled = NO;
//                [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
//            }else {
//                self.navigationItem.rightBarButtonItem.enabled = NO;
//                [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
//            }
//        }

        
    }
    
    [self showHead];
    
    
//    __weak typeof(self) weakSelf = self;
//    [weakSelf.treeView reloadData];
}

// 显示底部头像
-(void)showHead{
    
    for (int i=0; i<[_headViewArray count]; i++) {
        
        UIImageView *imgV = [_headViewArray objectAtIndex:i];
        [imgV removeFromSuperview];
        
        imgV.frame = CGRectMake(10.0*i + 35.0*i +10, 5.0, 35.0, 35.0);
        [_headScrollView addSubview:imgV];
        
        _headScrollView.contentSize = CGSizeMake(35.0*(i+1) + 10*(i+1) + 10, 0.0);
    }
}

- (RADataObject *)getInfoFormData:(NSString *)uid fromPic:(BOOL)isFromPic
{
    // 遍历树，把该uid的RADataObject取出来
    for (id item in _data) {
        RADataObject *root = (RADataObject *)item;
        
        if (nil != root.children) {
            for (id item in root.children) {
                RADataObject *child = (RADataObject *)item;
#if 1
                if(isFromPic){
                    if ([child.idNumber integerValue] + [child.sid integerValue] * 1000000 == [uid integerValue]) {
                        return child;
                    }
                }else{
                    if ([child.idNumber isEqualToString:uid]) {
                        return child;
                    }
                }
                
#else
                if ([child.idNumber isEqualToString:uid]) {
                    return child;
                }
#endif
                
                if (nil != child.children) {
                    for (id item in child.children) {
                        RADataObject *childChild = (RADataObject *)item;
                        
                        if(isFromPic){
                            if ([childChild.idNumber integerValue] + [childChild.sid integerValue] * 1000000 == [uid integerValue]) {
                                return childChild;
                            }
                        }else{
                            if ([childChild.idNumber isEqualToString:uid]) {
                                return childChild;
                            }
                        }

                    }
                }
            }
        }
    }
    
    return nil;
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
    
    [headDiction removeAllObjects];
}
//-----------------------------------------------------------------------------------------------------

#pragma UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"click search");
    
    //setNavigationBarHidden
    if ([@"contactsList" isEqualToString:_viewType]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setNavigationBarHidden" object:@"1" userInfo:nil];
    }
    
    searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = mySearchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tintColor = [UIColor grayColor];
    }
    
}

#pragma UISearchDisplayDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    if (mySearchDisplayController) {
        NSLog(@"%@,%@",self.searchDisplayController.searchResultsTableView,self.searchDisplayController.searchResultsTableView.superview);
        [self performSelector:@selector(resetFrame) withObject:nil afterDelay:0.1];
    }
    
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0){
    
    mySearchBar.text = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNavigationBarHidden" object:@"0" userInfo:nil];
}

- (void)resetFrame{
    
    self.searchDisplayController.searchResultsTableView.superview.bounds =CGRectMake(0,20+44+40+45+40+50.0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64.0 - 45 - 40 - 49.0);
    
    for(UIView * v in self.searchDisplayController.searchResultsTableView.superview.subviews)    {
        NSLog(@"%@",[v class]);
        if([v isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])        {
            v.frame = CGRectMake(0,20+44+40+45+40+50.0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64.0 - 45 - 40 - 49.0);
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
    
    if (mySearchDisplayController){
        tableView.frame =CGRectMake(0, 20+44+40+45+40+50.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0 -44-40);
        
    }
    
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"2");
    mySearchBar.text = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNavigationBarHidden" object:@"0" userInfo:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [searchResults removeAllObjects];
    
    NSLog(@"0000000000000");
    
    if (mySearchBar.text.length>0&&![Utilities isIncludeChineseInString:mySearchBar.text]) {
        
        NSLog(@"11111111111");
        
        for (int i=0; i<[_data count]; i++) {
            
            RADataObject *listDic = [_data objectAtIndex:i];
            
            if (![listDic.node isEqualToString:@"leaf"]) {
                
                NSMutableArray *subList = listDic.children;
                
                for (int j= 0; j<[subList count]; j++) {
                    
                    RADataObject *subdic = [subList objectAtIndex:j];
                    NSMutableArray *subChildren = subdic.children;
                    
                    for (int k  = 0; k<[subChildren count]; k++) {
                        
                        RADataObject *subChildDic = [subChildren objectAtIndex:k];
                        
                        if ([@"person"  isEqual: subChildDic.node]) {
                            
                            NSLog(@"3333333333333333");
                            NSLog(@"mySearchBar.text:%@",mySearchBar.text);
                            
                            if ([Utilities isIncludeChineseInString:subChildDic.name]) {
                                
                                NSLog(@"5555555555555555555555");
                                
                                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:subChildDic.name];
                                NSRange titleResult = [tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                                
                                if (titleResult.length>0) {
                                    
                                    if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                        [searchResults addObject:subChildDic];
                                    }else{//发起群聊
                                        // to do :需要特殊处理 过滤掉已经选过的人
                                        [searchResults addObject:subChildDic];
                                    }
                                    
                                }
                                
                            }else{
                                
                                //NSLog(@"666666666666666666");
                                
                                NSRange titleResult= [subChildDic.name rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                                if (titleResult.length>0) {
                                    if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                        [searchResults addObject:subChildDic];
                                    }else{//发起群聊
                                        
                                        [searchResults addObject:subChildDic];
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
                NSMutableArray *list  = listDic.children;
                
                for (int j =0; j<[list count]; j++) {
                    
                    RADataObject *dic = [list objectAtIndex:j];
                    
                    if ([@"person"  isEqual: dic.node]) {
                        
                        NSLog(@"3333333333333333");
                        NSLog(@"mySearchBar.text:%@",mySearchBar.text);
                        
                        if ([Utilities isIncludeChineseInString:dic.name]) {
                            
                            NSLog(@"5555555555555555555555");
                            
                            NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dic.name];
                            NSRange titleResult = [tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                            
                            if (titleResult.length>0) {
                                
                                if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                    [searchResults addObject:dic];
                                }else{//发起群聊
                                    // to do :需要特殊处理 过滤掉已经选过的人
                                    [searchResults addObject:dic];
                                }
                                
                            }
                            
                        }else{
                            
                            //NSLog(@"666666666666666666");
                            
                            NSRange titleResult= [dic.name rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                            if (titleResult.length>0) {
                                if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                    [searchResults addObject:dic];
                                }else{//发起群聊
                                    
                                    [searchResults addObject:dic];
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        NSLog(@"searchResults count:%d",[searchResults count]);
        
    } else if (mySearchBar.text.length>0&&[Utilities isIncludeChineseInString:mySearchBar.text]) {
        
        NSLog(@"22222222222222222");
        
        for (int i= 0; i<[_data count]; i++) {
            
            RADataObject *listDic = [_data objectAtIndex:i];
            
            if (![listDic.node isEqualToString:@"leaf"]) {
                
                NSMutableArray *subList = listDic.children;
                
                for (int j= 0; j<[subList count]; j++) {
                    
                    RADataObject *subdic = [subList objectAtIndex:j];
                    NSMutableArray *subChildren = subdic.children;
                    
                    for (int k  = 0; k<[subChildren count]; k++) {
                        
                        RADataObject *subChildDic = [subChildren objectAtIndex:k];
                        
                        if ([@"person"  isEqual: subChildDic.node]) {
                            
                            NSLog(@"3333333333333333");
                            NSLog(@"mySearchBar.text:%@",mySearchBar.text);
                            
                            
                            
                            NSString *tempStr = subChildDic.name;
                            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                            
                            if (titleResult.length>0) {
                                if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                    [searchResults addObject:subChildDic];
                                }else{//发起群聊
                                    
                                    [searchResults addObject:subChildDic];
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
                
                NSMutableArray *list  = listDic.children;
                
                for (int j =0; j<[list count]; j++) {
                    
                    RADataObject *dic = [list objectAtIndex:j];
                    
                    if ([@"person"  isEqual: dic.node]){
                        
                        NSLog(@"444444444444444444");
                        
                        NSString *tempStr = dic.name;
                        NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length>0) {
                            if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
                                [searchResults addObject:dic];
                            }else{//发起群聊
                                [searchResults addObject:dic];
                            }
                        }
                        
                    }
                    
                    
                }
            }
            
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [searchResults count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    //return 45.0;
    return [Utilities transformationHeight:44.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"RATableViewCell";
    
    RATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"RATableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,12,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,12,0,0)];
    }
    
    RADataObject *dataObject = [searchResults objectAtIndex:indexPath.row];
    
    CGRect headFrame = cell.imageView_head.frame;
    cell.imageView_head.frame = headFrame;
    
    CGRect titleFrame = cell.customTitleLabel.frame;
    titleFrame.origin.x = headFrame.origin.x + headFrame.size.width;
    cell.customTitleLabel.frame = titleFrame;
    
    cell.customTitleLabel.text = dataObject.name;
    
    [cell.imageView_head sd_setImageWithURL:[NSURL URLWithString:dataObject.avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    RADataObject *dataObject = [searchResults objectAtIndex:indexPath.row];
    
    if ([@"contactsList" isEqualToString:_viewType]) {//通讯录
        //to do:如果是通讯里 去群聊天
        // 单聊
        UserObject *user = [[UserObject alloc] init];
        
        user.user_id = dataObject.idNumber.longLongValue;
        user.name = dataObject.name;
        user.headimgurl = dataObject.avatar;
#if 1
        user.schoolName = G_SCHOOL_NAME;
        user.schoolID = [dataObject.sid longLongValue];
#endif
        [user updateToDB];
        
#pragma forKate
        MixChatListObject *chatListObject = [[MixChatListObject alloc] init];
        chatListObject.user_id = dataObject.idNumber.longLongValue;
        chatListObject.title = dataObject.name;
        chatListObject.gid = 0;
        chatListObject.schoolID = [dataObject.sid longLongValue];
        // 更改聊天列表的title
        NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and uid = %lli and schoolID = %lli", user.name, user.user_id, [Utilities getUniqueUid].longLongValue, [dataObject.sid longLongValue]];
        [[DBDao getDaoInstance] executeSql:updateListSql];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"0",@"gid",
                             @"user",@"frontName",
                             user, @"user",
#pragma forKate
                             chatListObject, @"mixChatListObject",
                             nil];
        
        // 点击一条去单聊页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setNavigationBarHidden" object:@"0" userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_goToMsgDetailMixView" object:self userInfo:dic];
        
        [self.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
        
    }else{//发起群聊
        
        if (NO == dataObject.isSelected) {
            
            
            // to do :如果是发起群聊点击操作之后需要做两个动作 1.在顶部添加头像 2.使选中的人那行置为选中状态
            BOOL isSame = NO;
            
            if ([_selectedMembersArray count] > 0) {
                // done :需要特殊处理 过滤掉已经选过的人
                for (int i=0; i<[_selectedMembersArray count]; i++) {
                    
                    NSString *selectIdNumber = [_selectedMembersArray objectAtIndex:i];
#if 1
                    if ([selectIdNumber isEqualToString:dataObject.idNumber] && [[_selectedSidArray objectAtIndex:i] isEqualToString:dataObject.sid]) {
#else
                    if ([selectIdNumber isEqualToString:dataObject.idNumber]) {
#endif
                        isSame = YES;
                        break;
                    }
                    
                }
            }
            
            if (!isSame) {//没有选中过的
                
                //1.在顶部添加头像
                dataObject.isSelected = !dataObject.isSelected;
                // 将uid添加到uid列表当中 选中一条
                [self addOrDeleteToSelectedMemberArray:dataObject status:dataObject.isSelected];
                
                //2.使选中的人那行置为选中状态
                // 还需要判断父节点的状态，看结果设置isSelect是否已选的状态
                RADataObject * parent = [self.treeView parentForItem:dataObject];
                if (nil != parent) {
                    // 如果有父节点
                    if (0 != parent.isSelected) {
                        // 如果父节点的isSelect状态是设置的，则需要把其状态设为0
                        parent.isSelected = 0;
                        [_treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                    }else {
                        // 如果父节点的isSelect状态为未设置，则需要判断这个父节点下的所有子节点是否为已选状态
                        BOOL isAllSelect = YES;
                        
                        NSArray *childrenData = parent.children;
                        for (int i=0; i<[childrenData count]; i++) {
                            RADataObject *childrenObj = [childrenData objectAtIndex:i];
                            
                            if (!childrenObj.isSelected) {
                                isAllSelect = NO;
                            }
                        }
                        
                        parent.isSelected = isAllSelect;
                        [_treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                // 还需要判断父节点的父节点的状态，看结果设置isSelect是否已选的状态
                RADataObject * parentParent = [self.treeView parentForItem:parent];
                if (nil != parentParent) {
                    // 如果有父节点的父节点
                    if (0 != parentParent.isSelected) {
                        // 如果父节点的父节点的isSelect状态是设置的，则需要把其状态设为0
                        parentParent.isSelected = 0;
                        [_treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                    }else {
                        // 如果父节点的父节点isSelect状态为未设置，则需要判断这个父节点下的的父节点所有子节点是否为已选状态
                        BOOL isAllSelectParent = YES;
                        
                        NSArray *childrenParentData = parentParent.children;
                        for (int i=0; i<[childrenParentData count]; i++) {
                            RADataObject *childrenObj = [childrenParentData objectAtIndex:i];
                            
                            if (!childrenObj.isSelected) {
                                isAllSelectParent = NO;
                            }
                        }
                        
                        parentParent.isSelected = isAllSelectParent;
                        [_treeView reloadRowsForItems:@[parentParent] withRowAnimation:RATreeViewRowAnimationNone];
                    }
                }
                
                // 判断已选择的uid列表是否为空，来设置右button的状态。
                NSString *rightButtonName = @"";
                if (nil != _settingMembersArray) {
                    rightButtonName = @"确定";
                }else {
                    rightButtonName = @"创建";
                }
                
                NSString *selectedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)[_selectedMembersArray count]];
                
                if ([@"确定"  isEqual: rightButtonName]) {
                    if (0 < [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                    }else {
                        if (1 == [_selectedMembersArray count]) {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                        }else {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                        }
                    }
                }else {
                    if (1 < [_selectedMembersArray count]) {
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber]  color:[UIColor whiteColor]];
                    }else {
                        if (1 == [_selectedMembersArray count]) {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeLongRightButtonWithName:[NSString stringWithFormat:@"%@(%@)", rightButtonName, selectedNumber] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                            
                            //
                            
                        }else {
                            self.navigationItem.rightBarButtonItem.enabled = NO;
                            //[self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
                            [self setCustomizeRightButtonWithName:[NSString stringWithFormat:@"%@", rightButtonName] color:[[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];//modify by kate 2016.06.21 bug 3249
                            
                            //
                            
                        }
                    }
                }
                
            }
            
        }
        
        
    }
    
}


@end

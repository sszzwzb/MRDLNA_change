//
//  MomentsViewController.m
//  MicroSchool
//
//  Created by jojo on 14/12/15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MomentsViewController.h"
#import "PublishMomentsViewController.h"// add by kate
#import "NewListViewController.h"// add by kate
#import "LikerListViewController.h"// add by kate
#import "MyTabBarController.h"
#import "MicroSchoolAppDelegate.h"
#import "SingleWebViewController.h"

#import "SetPersonalViewController.h"
#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "Utilities.h"
//Chenth
#import "DropDownListView.h"
#import "DropDownChooseProtocol.h"
#import "advertisingTableViewCell.h"
#import "MyInfoWebViewController.h"
@interface MomentsViewController ()<DropDownChooseDelegate, DropDownChooseDataSource, UIGestureRecognizerDelegate>{
    DropDownListView *dropDownView;
    UIView *titleView;
    UILabel *nameLabel;
    NSString *listClassname;
    UIButton *downListButton;
    NSMutableArray *chooseArr;
    UIImageView *listView;
    UIButton *nullButton;
    UITableView *tb;
    BOOL isTeacherAll;
    NSMutableArray *dataArr;
    NSMutableArray *dicArr;
    NSMutableArray *newArray;
    
    //
    NSInteger currentDateLine;
    NSMutableArray *advertisingHeightArr;
    NSInteger didAddCount;
    NSMutableArray *numberArr;
    BOOL haveAdvertising;
}
@property (nonatomic, strong)NSMutableArray *advertisingArr;

@end

extern UIImageView *newIconImg;
extern UIImageView *newIconImgForTeacher;

@implementation MomentsViewController


#define MOMENTS_LIST_TEXT_WIDTH		(300)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    numberArr = [NSMutableArray array];
    isTeacherAll = YES;
    //
    [super setCustomizeTitle:_titleName];
    [self buildTitleView];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    currentDateLine = [timeString integerValue];
    
    self.advertisingArr = [NSMutableArray array];
    advertisingHeightArr = [NSMutableArray array];
    didAddCount = 0;
    isTeacherAll = YES;
    haveAdvertising = 1;
    //-------------------------------------------------
    /*NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"tabTitles"];
    
    if([tempArray count] > 0){
        [self setCustomizeTitle:[tempArray objectAtIndex:2]];
    }*/
    //----------------------------------------------------------
    

    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    _userType = usertype;
    
//    if (([@"0"  isEqual: _userType]) || ([@"6"  isEqual: _userType])) {
    if (0) {

        // 获取成长空间状态，确认是否可以添加到我的足迹
        [self doGetGrowingPathStatus];
        
        textParser = [[MarkupParser alloc] init];
        
        [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
        //    [self createHeaderView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 44) style:UITableViewStylePlain];// update by kate
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 隐藏tableview分割线
        [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.view addSubview:_tableView];
        
        //----update by kate---------------------------------------
        if ([_fromName isEqualToString:@"school"]) {
            _tableView.frame = CGRectMake(0, 0, WIDTH,HEIGHT - 44);// update by kate
        }else{
            [super setCustomizeLeftButton];
        }
        
        //---add by kate------------------------------------------------------
        if ([_fromName isEqualToString:@"class"] || [_fromName isEqualToString:@"school"]) {//班级动态
            [self setCustomizeRightButton:@"icon_edit_forums.png"];
        }else if ([_fromName isEqualToString:@"other"]){
            // 个人动态
        }else if ([_fromName isEqualToString:@"mine"]){
            // 我的动态
            [self setCustomizeRightButton:@"moments/icon_xx.png"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gotoLikerList:)
                                                     name:@"Weixiao_momentsToLikerList"
                                                   object:nil];
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 430;
        
        myNoticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 16, 7, 10, 10)];//update by kate 2014.01.06
        myNoticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doGetGrowingPathStatus)
                                                     name:@"reLoadGrowingPathStatus"
                                                   object:nil];//add by kate 2016.01.06
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        //reLoadSchoolMomentsView
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadOfShoolMoments)
                                                     name:@"reLoadSchoolMomentsView"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadOfShoolMoments1)
                                                     name:@"reLoadSchoolMomentsView1"
                                                   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPath:) name:@"Weixiao_momentsClickAddToPath" object:nil];

    
        [self showCustomKeyBoard];
        
        if(!(([@"mine"  isEqual: _fromName]) || ([@"other"  isEqual: _fromName]))) {
            // 手势识别
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
            singleTouch.delegate = self;
            [self.view addGestureRecognizer:singleTouch];
        }
        
        //------------------------------------------------------------------------
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"30";
        
        startNumR = @"0";
        endNumR = @"30";

        //    textParser = [[MarkupParser alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        cellHeightArray = [[NSMutableArray alloc] init];
        cellMessageHeightArray = [[NSMutableArray alloc] init];
        
        headerDic = [[NSMutableDictionary alloc] init];
        
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
        _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
        
        likePosY = 0;
        
        reflashFlag = 1;
        _isFirstClickReply = false;
        
        _btn_msg = [UIButton buttonWithType:UIButtonTypeCustom];
        _img_msg =[[UIImageView alloc]initWithFrame:CGRectZero];
        
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        if(IS_IPHONE_5){
            imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
        }else{
            imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
        }
        
        //    if([_fromName isEqualToString:@"fromFriendProfile"]){
        //        [MyTabBarController setTabBarHidden:YES];
        //    }
        
        DB_Dic = [[NSDictionary alloc] init];
    }else {
        
        if (([@"0"  isEqual: _userType]) || ([@"6"  isEqual: _userType])) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(doGetGrowingPathStatus)
                                                         name:@"reLoadGrowingPathStatus"
                                                       object:nil];//add by kate 2016.01.06
            
            // 获取成长空间状态，确认是否可以添加到我的足迹
            [self doGetGrowingPathStatus];
            
        }
        
#if BUREAU_OF_EDUCATION
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"我的部门",nil];
#else
       NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"我的班级",nil];
#endif
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
        bgView.backgroundColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.view addSubview:bgView];

        //初始化UISegmentedControl
        _segmentControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        _segmentControl.frame = CGRectMake(10.0, 8.0, 302.0, 29.0);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
        _segmentControl.momentary = NO;
//        _segmentControl.tintColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        _segmentControl.tintColor = [UIColor whiteColor];
//        _segmentControl.backgroundColor =  [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        
//        _segmentControl.layer.cornerRadius = CGRectGetHeight(_segmentControl.frame) / 2.0f;
//        _segmentControl.layer.borderWidth = 1.0f;
        _segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;

        [_segmentControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
        
//        [bgView addSubview:_segmentControl];

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
        
        
        textParser = [[MarkupParser alloc] init];
        
        [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
        //    [self createHeaderView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 隐藏tableview分割线
        [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.view addSubview:_tableView];
        
        _tableViewR = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44-45) style:UITableViewStylePlain];
        
        _tableViewR.delegate = self;
        _tableViewR.dataSource = self;
        _tableViewR.hidden = YES;
        // 隐藏tableview分割线
        [self->_tableViewR setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
//        [self.view addSubview:_tableViewR];

        //----update by kate---------------------------------------
        if ([_fromName isEqualToString:@"school"]) {
            _tableView.frame = CGRectMake(0, 45, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44-45);
            _tableViewR.frame = CGRectMake(0, 45, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44-45);
        }else if ([_fromName isEqualToString:@"mine"]) {
            _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
        }else{
            [super setCustomizeLeftButton];
        }
        
        //---add by kate------------------------------------------------------
        if ([_fromName isEqualToString:@"class"] || [_fromName isEqualToString:@"school"]) {//班级动态
            [self setCustomizeRightButton:@"ClassKin/icon_sendPhoto"];

        }else if ([_fromName isEqualToString:@"other"]){
            // 个人动态
        }else if ([_fromName isEqualToString:@"mine"]){
            // 我的动态
            [self setCustomizeRightButton:@"moments/icon_xx.png"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gotoLikerList:)
                                                     name:@"Weixiao_momentsToLikerList"
                                                   object:nil];
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 430;
        
        myNoticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 16, 7, 10, 10)];//update by kate 2014.01.06
        myNoticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doGetGrowingPathStatus)
                                                     name:@"reLoadGrowingPathStatus"
                                                   object:nil];//add by kate 2016.01.06

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        //reLoadSchoolMomentsView
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadOfShoolMoments)
                                                     name:@"reLoadSchoolMomentsView"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadOfShoolMoments1)
                                                     name:@"reLoadSchoolMomentsView1"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPath:) name:@"Weixiao_momentsClickAddToPath" object:nil];
        
        
        [self showCustomKeyBoard];
        
        if(!(([@"mine"  isEqual: _fromName]) || ([@"other"  isEqual: _fromName]))) {
            // 手势识别
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
            singleTouch.delegate = self;
            [self.view addGestureRecognizer:singleTouch];
        }
        
        //------------------------------------------------------------------------
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        startNum = @"0";
        endNum = @"30";
        
        startNumR = @"0";
        endNumR = @"30";

        //    textParser = [[MarkupParser alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        cellHeightArray = [[NSMutableArray alloc] init];
        cellMessageHeightArray = [[NSMutableArray alloc] init];
        
        dataArrayR = [[NSMutableArray alloc] init];
        cellHeightArrayR = [[NSMutableArray alloc] init];
        cellMessageHeightArrayR = [[NSMutableArray alloc] init];

        headerDic = [[NSMutableDictionary alloc] init];
        
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
        _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
        
        likePosY = 0;
        
        reflashFlag = 1;
        _isFirstClickReply = false;
        
        _btn_msg = [UIButton buttonWithType:UIButtonTypeCustom];
        _img_msg =[[UIImageView alloc]initWithFrame:CGRectZero];
        
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        if(IS_IPHONE_5){
            imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
        }else{
            imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
        }
        
        //    if([_fromName isEqualToString:@"fromFriendProfile"]){
        //        [MyTabBarController setTabBarHidden:YES];
        //    }
        
        DB_Dic = [[NSDictionary alloc] init];
        
        
        
        
        if (_refreshHeaderViewR && [_refreshHeaderViewR superview]) {
            [_refreshHeaderViewR removeFromSuperview];
        }
        
        _refreshHeaderViewR = [[EGORefreshTableHeaderView alloc] initWithFrame:
                               CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                          self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderViewR.delegate = self;
        
        [self->_tableViewR addSubview:_refreshHeaderViewR];
        
        [_refreshHeaderViewR refreshLastUpdatedDate];
        
        // 因为在viewwillappare里面调用了 所以这里不调用
        // 发出两次请求会有问题
        NSDictionary *data;
        
        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
        
        if ([@"0"  isEqual: _userType]) {
            // 学生
            if ([msgLastId length] == 0) {
                msgLastId = _lastMsgId;
            }
            
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleStudent",@"ac",
                                @"3",@"v",
                                @"streams", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        }else if ([@"6"  isEqual: _userType]) {
            
            if ([msgLastId length] == 0) {
                msgLastId = _lastMsgId;
            }
            
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleParent",@"ac",
                                @"3",@"v",
                                @"streams", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        }else {
            // 班级动态列表
            if ([msgLastId length] == 0) {
                msgLastId = _lastMsgId;
            }
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"CircleTeacher",@"ac",
                    @"3",@"v",
                    @"classes", @"op",
                    startNumR, @"page",
                    endNumR, @"size",
                    msgLastId,@"last",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        }

        
        
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
        _blankView = [Utilities showNodataView:@"还木有好友动态，来当第一个吧" msg2:nil andRect:rect imgName:@"BlankViewImage/幼标@3_03.png"];
        _blankView.hidden = YES;
        [_tableView addSubview:_blankView];
        
        _blankViewR = [Utilities showNodataView:@"还木有好友动态，来当第一个吧" msg2:nil andRect:rect imgName:@"BlankViewImage/幼标@3_03.png"];
        _blankViewR.hidden = YES;
        [_tableViewR addSubview:_blankViewR];

        
        
        
//        _blankView = [Utilities showNodataView:@"暂无信息" msg2:@"" andRect:rect];
//        [_tableView addSubview:_blankView];
//        _blankView.hidden = YES;
//        
//        _blankViewR = [Utilities showNodataView:@"暂无信息" msg2:@"" andRect:rect];
//        [_tableViewR addSubview:_blankViewR];
//        _blankViewR.hidden = YES;

    }
}
- (void)getAdvertising
{
    NSString *uid = [Utilities getUniqueUid];
    NSString *app = [Utilities getAppVersion];
    _classCid = [Utilities replaceNull:_classCid];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Ad",@"ac",
                          @"3",@"v",
                          @"mine", @"op",
                          _classCid, @"cid",
                          uid, @"uid",
                          app, @"app",
                          nil];
    
    
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities dismissProcessingHud:self.view];
            _advertisingArr = [respDic objectForKey:@"message"];
            for (NSDictionary *tempDic in _advertisingArr) {
                NSInteger tempIntg = [[tempDic objectForKey:@"position"] integerValue] - 1;
                [numberArr addObject:[NSString stringWithFormat:@"%ld", tempIntg]];
            }
            [self calcCellHeighti];
            //            [self getAdvertisingHeight];
            //NSLog(@"dic:%@",dic);
            [_tableView reloadData];
            
        } else {
            //            [Utilities showTextHud:@"获取信息错误，请稍后再试" descView:self.view];
            haveAdvertising = NO;
            [self calcCellHeighti];
            [self reloadData];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"snm");
        haveAdvertising = NO;
        [self calcCellHeighti];
        [self reloadData];
    }];
    
}

- (void)getAdvertisingHeight{
    [advertisingHeightArr removeAllObjects];
    UILabel *tempLabel = [[UILabel alloc] init];
    //    tempLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width - 75, 20);
    tempLabel.font = [UIFont systemFontOfSize:14];
    for (NSDictionary *tempDic in _advertisingArr) {
        NSString *tempStr = [tempDic objectForKey:@"note"];
        tempLabel.text = tempStr;
        tempLabel.numberOfLines = 0;
        CGSize tempSize = [Utilities getLabelHeight:tempLabel size:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 75, MAXFLOAT)];
        CGFloat tempHeight = tempSize.height;
        CGFloat totalHeight = tempHeight + 246 + 25;
        [advertisingHeightArr addObject:[NSString stringWithFormat:@"%f", totalHeight]];
    }
}

- (void)buildTitleView
{
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    nameLabel = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.center = titleView.center;
    if (listClassname == nil) {
        
        nameLabel.text = @"全校";
         _cid = @"0";
    }
    else {
        nameLabel.text = listClassname;
    }
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = [UIColor whiteColor];
    CGSize tempSize = [Utilities getLabelHeight:nameLabel size:CGSizeMake(MAXFLOAT, 40)];
    CGFloat tempWith = tempSize.width;
    if (tempSize.width > (200 - 25)) {
        nameLabel.frame = CGRectMake(0, 0, 200 - 25, 40);
        tempWith = 200 - 25;
    }
    nameLabel.frame = CGRectMake((200 - tempWith - 25) / 2, 0, tempWith, 40);
    [titleView addSubview:nameLabel];
    
    if ((![_fromName isEqualToString:@"other"]) && (![_fromName isEqualToString:@"mine"])) {
        // 个人动态不显示筛选
        downListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downListButton.frame = CGRectMake((200 - tempWith - 25) / 2 , 8, 25 + tempWith, 25);
        [downListButton setImage:[UIImage imageNamed:@"arrowDown@2x"] forState:UIControlStateNormal];
        [downListButton setImage:[UIImage imageNamed:@"arrowUp@2x"] forState:UIControlStateSelected];
        downListButton.imageEdgeInsets = UIEdgeInsetsMake(0, tempWith, 0, 0);
        [downListButton addTarget:self action:@selector(downListButton:) forControlEvents:UIControlEventTouchUpInside];
        downListButton.backgroundColor = [UIColor clearColor];
        [titleView addSubview:downListButton];
        chooseArr = [NSMutableArray array];
        [self.navigationItem setTitleView:titleView];
        
    }
    
}
- (void)dismissDownList
{
    [nullButton removeFromSuperview];
    [self downListButton:downListButton];
    
}

- (void)downListButton:(UIButton *)button
{
    button.selected = !button.selected;
    //    dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44) dataSource:self delegate:self];
    //    dropDownView.mSuperView = self.view;
    //    [self.view addSubview:dropDownView];
    if (button.selected) {
        
        nullButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nullButton.backgroundColor = [UIColor clearColor];
        nullButton.frame = _tableView.frame;
        [nullButton addTarget:self action:@selector(dismissDownList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nullButton];
        
        _tableView.scrollEnabled = NO;
        
        [self dataHandler];
        listView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - [Utilities convertPixsH:200]) / 2, 0, [Utilities convertPixsH:200], [Utilities convertPixsH:300])];
//        listView.backgroundColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
//        listView.backgroundColor = [UIColor blackColor];
        listView.image = [UIImage imageNamed:@"bg_ssqHaveTextGreen.png"];
        listView.userInteractionEnabled = YES;
        [nullButton addSubview:listView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"全校" forState:UIControlStateNormal];
        button.frame = CGRectMake([Utilities convertPixsW:15], [Utilities convertPixsH:20], [Utilities convertPixsW:200] - [Utilities convertPixsW:15], [Utilities convertPixsH:30]);
        button.backgroundColor = [UIColor clearColor];
        button.tintColor = [UIColor clearColor];
        //        [button setTitleEdgeInsets:[UIFont systemFontOfSize:17]];
        button.titleLabel.font = [UIFont systemFontOfSize:[Utilities convertPixsH:17]];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
        [listView addSubview:button];
        
//        UILabel *textLabel = [[UILabel alloc] init];
//        textLabel.text = @"--我的班级---------------";
//        textLabel.frame = CGRectMake([Utilities convertPixsW:0], [Utilities convertPixsH:50], listView.bounds.size.width, [Utilities convertPixsH:30]);
//        textLabel.textColor = [UIColor whiteColor];
//        textLabel.backgroundColor = [UIColor clearColor];
//        textLabel.tintColor = [UIColor clearColor];
//        textLabel.font = [UIFont systemFontOfSize:13];
//        //        [button setTitleEdgeInsets:[UIFont systemFontOfSize:17]];
////        textLabel.font = [UIFont systemFontOfSize:[Utilities convertPixsH:17]];
////        textLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [listView addSubview:textLabel];
        
        tb = [[UITableView alloc] initWithFrame:CGRectMake(0, [Utilities convertPixsH:80], [Utilities convertPixsH:200], [Utilities convertPixsH:220]) style:UITableViewStylePlain];
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        tb.backgroundColor = [UIColor colorWithRed:38.0 / 255 green:38.0 / 255 blue:38.0 / 255 alpha:1];
        tb.backgroundColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        tb.delegate = self;
        tb.dataSource = self;
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
        //    [person dataHandler];
        //    [self dataHandlerWithArr:arr];
        [listView addSubview:tb];
        //        listView.tb.dataSource = self;
        //        listView.tb.delegate = self;
        //        button.selected = !button.selected;
    }else if (!button.selected)
    {
        [listView removeFromSuperview];
        _tableView.scrollEnabled = YES;
        [nullButton removeFromSuperview];
        //        button.selected = !button.selected;
    }
       }
- (void)dataHandler
{
    dataArr = [NSMutableArray array];
    dicArr = [NSMutableArray array];
    
    //    dataArr = [NSMutableArray arrayWithArray:@[@"三年级一班", @"二年级八班", @"七年级十六班", @"四十二年级九十六班", @"九年级零班", @"2016届精英班", @"2015届青铜班"]];
    //    [Utilities showProcessingHud:self.view];
    //    self.dataArr = [NSMutableArray array];
    //    NSLog(@"%@", );
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"3", @"v",
                          @"Circle", @"ac",
                          @"classes", @"op",
                          _cid, @"cid",
                          [Utilities getAppVersion], @"app",
                          @"", @"exclude",
                          //                          REQ_URL, @"url",
                          //                          @"News", @"ac",
                          //                          @"2", @"v",
                          //                          @"newsList", @"op",
                          //                          @"公告", @"smid",
                          //                          @"1", @"page",
                          //                          @"10", @"size",
                          nil];
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        newArray = [NSMutableArray array];
        if(true == [result intValue]) {
            NSArray *message = [NSArray arrayWithArray:[respDic objectForKey:@"message"]];
            //            NSDictionary* message_info = [respDic objectForKey:@"message"];
            //            NSArray *temp = [message_info objectForKey:@"list"];
            for (NSDictionary *dic in message)
            {
                //                NSMutableDictionary *listDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
                NSString *name = [dic objectForKey:@"name"];
                //                [newArray addObject:listDic];
                [dicArr addObject:dic];
                [dataArr addObject:name];
                
            }
            
            
            
            NSLog(@"%@", newArray);
        }
        //        for (NSDictionary *dic in _newsArray) {
        //            News2Model *new2 = [[News2Model alloc] init];
        //            [new2 setValuesForKeysWithDictionary: dic];
        //            [_dataArr addObject:new2];
        //        }
        [tb reloadData];
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];
    
}

- (void)all
{
    //    NSLog(@"sbbbbbbbbbbbbb");
    [_tableView removeFromSuperview];
    [self downListButton:downListButton];
    [self.view addSubview:_tableView];
    
    [self reloadMomentsContent:nil];
}
- (void)reloadMomentsContent:(NSDictionary *)classInfo {
    if (nil == classInfo) {
        // 如果cid为0，认为选择的是全校
        
        isTeacherAll = YES;
        listClassname = nil;
        nameLabel.text= _titleName;
        [self buildTitleView];
        [Utilities showProcessingHud:self.view];
//        [self refreshView];
        
        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
        
        // 学校动态列表
        if ([msgLastId length] == 0) {
            msgLastId = _lastMsgId;
        }
        
        startNum = @"0";
        endNum = @"30";
        
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                @"CircleTeacher",@"ac",
                @"3",@"v",
                @"school", @"op",
                startNum, @"page",
                endNum, @"size",
                msgLastId,@"last",
                nil];
        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        
    }else {
        isTeacherAll = NO;
        
        _cid = [classInfo objectForKey:@"cid"];
        
        listClassname = [NSString stringWithFormat:@"%@", [classInfo objectForKey:@"name"]];
        //        nameLabel.text= name;
        
        nameLabel.text= listClassname;
        
        [Utilities showProcessingHud:self.view];
        [self refreshViewWithCid];
        
    }
}
-(void)refreshViewWithCid
{
    if (reflashFlag == 1) {
        
        startNum = @"0";
        endNum = @"30";
        
        startNumR = @"0";
        endNumR = @"30";
        
        NSDictionary *data;
        
        //        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        //        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
        
        if([@"school"  isEqual: _fromName]) {
            // 学校动态列表
            if ([msgLastId length] == 0) {
                msgLastId = _lastMsgId;
            }
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"CircleTeacher",@"ac",
                    @"3",@"v",
                    @"class4select", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    _cid,@"cid",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        }else if([@"mine"  isEqual: _fromName]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"Circle",@"ac",
                    @"2",@"v",
                    @"mine", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            
        }else if([@"other"  isEqual: _fromName]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"Circle",@"ac",
                    @"2",@"v",
                    @"other", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    _fuid,@"other",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
        }else if([@"class"  isEqual: _fromName]) {
            if ([@"0"  isEqual: _userType]) {
                // 学生
                if ([msgLastId length] == 0) {
                    msgLastId = _lastMsgId;
                }
                
                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"CircleStudent",@"ac",
                        @"3",@"v",
                        @"class4select", @"op",
                        _cid,@"cid",
                        startNum, @"page",
                        endNum, @"size",
                        msgLastId,@"last",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            }else if ([@"6"  isEqual: _userType]) {
                // 家长
                if ([msgLastId length] == 0) {
                    msgLastId = _lastMsgId;
                }
                
                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"CircleParent",@"ac",
                        @"3",@"v",
                        @"class4select", @"op",
                        _cid,@"cid",
                        startNum, @"page",
                        endNum, @"size",
                        msgLastId,@"last",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            }else{

                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"CircleTeacher",@"ac",
                        @"3",@"v",
                        @"class4select", @"op",
                        startNum, @"page",
                        endNum, @"size",
                        msgLastId,@"last",
                        _cid,@"cid",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            }
        }
        
        //NSLog(@"data:%@",data);
        //        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
    }
}



- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            //            [self selectmyView1];
            _tableViewR.hidden = YES;
            _tableView.hidden = NO;

            break;
        case 1:
            _tableView.hidden = YES;
            _tableViewR.hidden = NO;

            if (0 == [dataArrayR count]) {

//                [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
            }

            [self performSelector:@selector(testFinishedLoadDataR) withObject:nil afterDelay:0.2];

            [_tableViewR reloadData];
            
            break;
        default:
            break;
    }
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
}

//------add by kate-----------------------------------------------------
// 发现tab的红点
-(void)checkSelfMomentsNew{
    
    //[self reloadOfShoolMoments];

    [noticeImgVForMsg removeFromSuperview];
    newIconImg.hidden  = YES;// add by kate 2015.02.03

   /*MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
    [button addSubview:noticeImgVForMsg];*/
    
    startNum = @"0";
    endNum = @"30";
    
    startNumR = @"0";
    endNumR = @"30";

    NSDictionary *data;
    
    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
    
    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
            @"Circle",@"ac",
            @"2",@"v",
            @"threads", @"op",
            startNum, @"page",
            endNum, @"size",
            msgLastId,@"last",
            nil];
    
    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
}

-(void)checkSelfMomentsNew1{
    
    newIconImg.hidden = YES;//add by kate 2015.02.03
#if 1
    newIconImgForTeacher.hidden = YES;
#endif
    [noticeImgVForMsg removeFromSuperview];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
    UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
    [imgV removeFromSuperview];
    UIImageView *imgV2 = (UIImageView*)[button viewWithTag:431];
    [imgV2 removeFromSuperview];
    
#if 1
    [button addSubview:noticeImgVForMsg];
#endif
    
    newIconImg.hidden = NO;//add by kate 2015.02.03
#if 1
    newIconImgForTeacher.hidden = NO;
#endif
    
}

-(void)selectRightAction:(id)sender{
#if 9
    if([_fromName isEqualToString:@"school"]) {// 发布动态
       
        //---------update by kate 2015.04.20-------------------------------------------------
        //PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
        //[self.navigationController pushViewController:publish animated:YES];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"发布动态", @"分享链接",@"小视频",nil];
        actionSheet.tag = 330;
        [actionSheet showInView:self.view];
        //---------------------------------------------------------------------------------
        
    }else if ([_fromName isEqualToString:@"class"]){
        
        //----------update by kate 2015.04.20----------------------------------------------
//        PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
//        publish.fromName = @"class";
//        publish.cid = _cid;
//        publish.cName = _cName;
//        [self.navigationController pushViewController:publish animated:YES];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"发布动态", @"分享链接",@"小视频",nil];
        actionSheet.tag = 331;
        [actionSheet showInView:self.view];
        //-----------------------------------------------------------------------------------
        
    }else{// 去个人动态消息列表
        
        [myNoticeImgVForMsg removeFromSuperview];
        NewListViewController *newList = [[NewListViewController alloc]init];
        newList.newsDic = _newsDic;
        newList.mid = _mid;
        newList.cid = _cid;
        [self.navigationController pushViewController:newList animated:YES];
        
    }
    if([_fromName isEqualToString:@"school"]){
        [MyTabBarController setTabBarHidden:YES];
    }
#else
    
    TestTableViewController *a = [[TestTableViewController alloc] init];
    [self.navigationController pushViewController:a animated:YES];
#endif
}

// 去赞的人列表
-(void)gotoLikerList:(NSNotification*)notify{
    if (_segmentControl.selectedSegmentIndex == 0) {
        NSString *row = [[notify userInfo] objectForKey:@"cellNum"];
        NSDictionary *dic = [dataArray objectAtIndex:[row intValue]];
        //NSLog(@"dic:%@",dic);
        NSString *tid = [dic objectForKey:@"id"];
        LikerListViewController *likeList = [[LikerListViewController alloc]init];
        likeList.tid = tid;
        [self.navigationController pushViewController:likeList animated:YES];
        if([_fromName isEqualToString:@"school"]){
            [MyTabBarController setTabBarHidden:YES];
        }
    }else {
        NSString *row = [[notify userInfo] objectForKey:@"cellNum"];
        NSDictionary *dic = [dataArrayR objectAtIndex:[row intValue]];
        //NSLog(@"dic:%@",dic);
        NSString *tid = [dic objectForKey:@"id"];
        LikerListViewController *likeList = [[LikerListViewController alloc]init];
        likeList.tid = tid;
        [self.navigationController pushViewController:likeList animated:YES];
        if([_fromName isEqualToString:@"school"]){
            [MyTabBarController setTabBarHidden:YES];
        }
    }
}
//---------------------------------------------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    
    float sysVer =[[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer>= 6.0f)
        
    {
        
        if ([self.view window] == nil)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    if([_fromName isEqualToString:@"school"]){
//        [MyTabBarController setTabBarHidden:NO];//updat by kate 2015.02.03
        [MyTabBarController setTabBarHidden:YES];
    }else if([_fromName isEqualToString:@"other"]){//从个人资料页来
        [MyTabBarController setTabBarHidden:YES];

    }else if([_fromName isEqualToString:@"mine"]){//从个人资料页来
        [MyTabBarController setTabBarHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSelfMomentsNew)
                                                 name:@"checkSelfMomentsNew"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMore:) name:@"Weixiao_momentsMore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProfile:) name:@"Weixiao_fromMoments2ProfileView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLike:) name:@"Weixiao_momentsLike" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickComment:) name:@"Weixiao_momentsComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetail:) name:@"Weixiao_momentsDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showName1:) name:@"Weixiao_momentsClickName1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRemovePost:) name:@"Weixiao_momentsClickRemovePost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRemoveComment:) name:@"Weixiao_momentsClickRemoveComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickImgList:) name:@"Weixiao_momentsClickImgList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBlock:) name:NOTIFICATION_UI_MOMENTS_CLICKBLOCK object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSharedLink:) name:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickWebLink:) name:NOTIFICATION_UI_MOMENTS_CLICKWEBLINK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCopy:) name:NOTIFICATION_UI_MOMENTS_CLICKCOPY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDelete:) name:NOTIFICATION_UI_MOMENTS_CLICKDELETE object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [textView resignFirstResponder];

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];

    [myNoticeImgVForMsg removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkSelfMomentsNew" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsMore" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_fromMoments2ProfileView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsLike" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsDetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickName1" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickRemovePost" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickRemoveComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickImgList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKBLOCK object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKWEBLINK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKCOPY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKDELETE object:nil];

}

-(void)clickSharedLink:(NSNotification *)notification
{
    NSDictionary *notifyDic = [notification userInfo];
    NSString *cellNum = [notifyDic objectForKey:@"cellNum"];
    
    NSDictionary *dic;

    if (_segmentControl.selectedSegmentIndex == 0) {
        dic = [dataArray objectAtIndex:cellNum.integerValue];
    }else {
        dic = [dataArrayR objectAtIndex:cellNum.integerValue];
    }

    NSString *shareUrl = [dic objectForKey:@"shareUrl"];
    NSString *shareSnapshot = [dic objectForKey:@"shareSnapshot"];
    NSString *shareContent = [dic objectForKey:@"shareContent"];
    
    //2015.09.23
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.requestURL = shareUrl;
    fileViewer.currentHeadImgUrl = shareSnapshot;
    fileViewer.titleName = shareContent;
    
    [self.navigationController pushViewController:fileViewer animated:YES];
}

-(void)reloadOfShoolMoments1{
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
}

-(void)doGetGrowingPathStatus
{
    /**
     * 成长空间模块状态，学校是否有成长空间，班级是否有血迹，个人是否缴费
     * @author luke
     * @date 2015.12.29
     * @args
     *   v=3, ac=GrowingPath, op=module, sid=, cid=, uid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"module", @"op",
                          _cid, @"cid",
                          nil];
    
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            //NSLog(@"dic:%@",dic);
            _growingPathStatusSchool = [NSString stringWithFormat:@"%@", [dic objectForKey:@"school"]];
            _growingPathStatusSpace = [NSString stringWithFormat:@"%@", [dic objectForKey:@"space"]];
            _growingPathStatusNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"number"]];
            _growingPathStatusUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"url"]];//点我了解什么是成长空间
            _trial = [NSString stringWithFormat:@"%@", [dic objectForKey:@"trial"]];
            
            _growingPathStatusDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            
        } else {
            _growingPathStatusSchool = nil;
            _growingPathStatusSpace = nil;
            _growingPathStatusNumber = nil;
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
    }];
}

- (void)doAddToPath:(NSDictionary *)notifyDic
{
    NSString *cellNum = [notifyDic objectForKey:@"cellNum"];
    
    NSDictionary *dic;
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        dic = [dataArray objectAtIndex:cellNum.integerValue];
    }else {
        dic = [dataArrayR objectAtIndex:cellNum.integerValue];
    }
    
    /**
     * 学生家长将XX加入我的足迹
     * @author luke
     * @date 2015.12.20
     * @args
     *   v=3, ac=GrowingPath, op=import, sid=, cid=, uid=, number=,
     *   circle=动态ID
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"import", @"op",
                          _cid, @"cid",
                          [dic objectForKey:@"id"], @"circle",
                          nil];
    
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
            
            if (_segmentControl.selectedSegmentIndex == 0) {
                [[[dataArray objectAtIndex:[cellNum integerValue]] objectForKey:@"growpath"] setObject:@"1" forKey:@"save"];
                [_tableView reloadData];

            }else {
                [[[dataArrayR objectAtIndex:[cellNum integerValue]] objectForKey:@"growpath"] setObject:@"1" forKey:@"save"];
                [_tableViewR reloadData];

            }

            
        } else {
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

-(void)addToPath:(NSNotification *)notification
{
    NSDictionary *notifyDic = [notification userInfo];

    if (nil != _growingPathStatusNumber) {
        if ([@"0"  isEqual: _growingPathStatusNumber]) {
            // 学生并没有绑定成长空间，点击添加至个人成长弹出弹窗提示“绑定身份信息后方可添加至成长足迹”
            TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"绑定身份信息后方可添加至成长足迹"];
            
            [alert addBtnTitle:@"取消" action:^{
                // nothing to do
            }];
            [alert addBtnTitle:@"绑定" action:^{
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
                
                SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
                setPVC.viewType = @"growthSpace";
                setPVC.publish = 1;
                setPVC.cId = _cid;
                setPVC.iden = iden;
                setPVC.growingPathStatusUrl = _growingPathStatusUrl;
                [self.navigationController pushViewController:setPVC animated:YES];
            }];
            
            [alert showAlertWithSender:self];
        }else {
            // 学生绑定了成长空间
            // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
            if ([@"0"  isEqual: _growingPathStatusSpace]) {
                // 未开通
                TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"成长空间处于有效期内方可将动态添加至成长足迹。"];
                
                [alert addBtnTitle:@"取消" action:^{
                    // nothing to do
                    
                }];
                [alert addBtnTitle:@"去开通" action:^{
                    
                    if ([_growingPathStatusSpace integerValue] == 0 && [_trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
                        
                        PayViewController *pvc = [[PayViewController alloc] init];
                        pvc.fromName = @"publish";
                        pvc.cId = _cid;
                        pvc.spaceStatus = _growingPathStatusSpace;
                        pvc.isTrial = _trial;
                        [self.navigationController pushViewController:pvc animated:YES];
                        
                    }else{
                    
                    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
                    growVC.fromName = @"publish";
                    growVC.cId = _cid;
                    growVC.urlStr = _growingPathStatusUrl;
                    growVC.spaceStatus = _growingPathStatusSpace;
                    growVC.isBind = _growingPathStatusNumber;
                    //growVC.isTrial = trial;
                        [self.navigationController pushViewController:growVC animated:YES];
                    }
                }];
                
                [alert showAlertWithSender:self];
                
            }else if (([@"3"  isEqual: _growingPathStatusSpace]) || ([@"4"  isEqual: _growingPathStatusSpace])) {
                // 到期欠费了
                TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"成长空间处于有效期内方可将动态添加至成长足迹。"];
                
                [alert addBtnTitle:@"取消" action:^{
                    // nothing to do
                }];
                [alert addBtnTitle:@"立即续费" action:^{
                    
                    PayViewController *pvc = [[PayViewController alloc] init];
                    pvc.fromName = @"publish";
                    pvc.cId = _cid;
                    [self.navigationController pushViewController:pvc animated:YES];
                    
                }];
                
                [alert showAlertWithSender:self];
                
            }else {
                [self doAddToPath:notifyDic];
            }
        }
    }else {
        // 重新获取开通成长空间状态
        [self doGetGrowingPathStatus];
        
        // 延迟0.2秒后去设置
        [self performSelector:@selector(doAddToPath:) withObject:notifyDic afterDelay:0.2];
    }


    
#if 0
    if (nil != _growingPathStatusSpace) {
        if ([@"1"  isEqual: _growingPathStatusSpace]) {
            [self doAddToPath:notifyDic];
        }else {
            // 提示需要去绑定页面
            
        }
    }else {
        // 重新获取开通成长空间状态
        [self doGetGrowingPathStatus];
        
        // 延迟0.2秒后去设置
        [self performSelector:@selector(doAddToPath:) withObject:notifyDic afterDelay:0.2];
    }
#endif
}

-(void)clickDelete:(NSNotification *)notification
{
    NSDictionary *notifyDic = [notification userInfo];
    NSString *cellNum = [notifyDic objectForKey:@"pid"];
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                          @"Circle",@"ac",
                          @"2",@"v",
                          @"removeComment", @"op",
                          cellNum,@"pid",
                          nil];
    
    [network sendHttpReq:HttpReq_MomentsRemoveComment andData:data];
    
}

-(void)clickCopy:(NSNotification *)notification
{
    NSDictionary *notifyDic = [notification userInfo];
    NSString *cellNum = [notifyDic objectForKey:@"cellNum"];
    
    NSDictionary *dic = [dataArray objectAtIndex:cellNum.integerValue];
}

-(void)clickWebLink:(NSNotification *)notification
{
    NSDictionary *notifyDic = [notification userInfo];
    NSString *cellNum = [notifyDic objectForKey:@"cellNum"];
    
    NSDictionary *dic;
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        dic = [dataArray objectAtIndex:cellNum.integerValue];
    }else {
        dic = [dataArrayR objectAtIndex:cellNum.integerValue];
    }

    NSString *url = [dic objectForKey:@"message"];
    NSURL *webUrl = [NSURL URLWithString:url];
    
    isCommentComment = NO;
    
    _replyTo = [NSString stringWithFormat:@"回复%@: ", [dic objectForKey:@"name"]];
//    _isFirstClickReply = true;
    
    textView.text = @"";
    
    _replyToLabel.text = _replyTo;
    [_replyToLabel setHidden:NO];

    NSString *tid = [dic objectForKey:@"id"];
    _commentTid = tid;

    if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {
        
        // Safari打开
        //[[UIApplication sharedApplication]openURL:activeLink.URL];
        
        //内部WebView打开 2015.05.15

        // 2015.09.23
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.webType = SWLoadURl;
        fileViewer.url = webUrl;
        fileViewer.currentHeadImgUrl = nil;
        
        [self.navigationController pushViewController:fileViewer animated:YES];
    }
}

-(void)clickBlock:(NSNotification *)notification
{
    NSLog(@"clickBlock");
    NSDictionary *dic = [notification userInfo];
    _deleteTid = [dic objectForKey:@"tid"];
    _deleteCellNum = [dic objectForKey:@"cellNum"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"屏蔽这条动态？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"屏蔽",nil];
    alert.tag = 276;
    [alert show];
}

// 分享新鲜事
-(void)clickSubmitMoments:(NSNotification *)notification
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"发布动态", @"分享链接",@"小视频",nil];
    actionSheet.tag = 330;
    [actionSheet showInView:self.view];
    
//    PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
//    [self.navigationController pushViewController:publish animated:YES];
    
    
}

-(void)clickImgList:(NSNotification *)notification
{
    NSLog(@"clickImgList");
    [self dismissKeyboard];
    
    NSDictionary *dic = [notification userInfo];
    NSString *tag = [dic objectForKey:@"tag"];
    NSString *cellNum = [dic objectForKey:@"cellNum"];
    
    NSArray *dataArr;
        if (_segmentControl.selectedSegmentIndex == 0) {
            dataArr = dataArray;
        }else {
            dataArr = dataArrayR;
        }

    NSArray *picAry = [[dataArr objectAtIndex:[cellNum integerValue]] objectForKey:@"pics"];
    //    NSDictionary *b = [a objectAtIndex:btn.tag];
    //    NSString *imgUrl = [[[dataDic objectForKey:@"pics"] objectAtIndex:btn.tag] objectForKey:@"pic"];
    
    NSString *type = [NSString stringWithFormat:@"%@",[[picAry objectAtIndex:0] objectForKey:@"type"]];
    NSString *picStr = [NSString stringWithFormat:@"%@",[[picAry objectAtIndex:0] objectForKey:@"pic"]];
    
    if (([picAry count] == 1) && ([type integerValue] == 1)) {
        
        SightPlayerViewController *vc = [[SightPlayerViewController alloc]init];
        vc.videoURL = [NSURL URLWithString:picStr];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
    
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        // 弹出相册时显示的第一张图片是点击的图片
        browser.currentPhotoIndex = [tag integerValue];
        // 设置所有的图片。photos是一个包含所有图片的数组。
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[picAry count]];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[cellNum integerValue] inSection:0];
        
        MomentsTableViewCell *detailCell = (MomentsTableViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        
        //    [[detailCell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(pos.x +(5+picWidth)*i,
        //                                                             pos.y+5,
        //                                                             picWidth, picWidth)];
        
        
        
        
        for (int i = 0; i<[picAry count]; i++) {
            // 拼字符串，去服务器获取原图
            NSString *pic_url = [NSString stringWithFormat:REQ_PIC_URL, @"WIFI", [[[[dataArr objectAtIndex:[cellNum integerValue]] objectForKey:@"pics"] objectAtIndex:i] objectForKey:@"pid"]];
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.save = NO;
            photo.url = [NSURL URLWithString:pic_url]; // 图片路径
            photo.srcImageView = imageView; // 来源于哪个UIImageView
            
            //        UIImageView *a = [detailCell.ary_imgThumb objectAtIndex:[tag integerValue]];
            
            //        photo.srcImageView = a; // 来源于哪个UIImageView
            
            [photos addObject:photo];
        }
        
        browser.photos = photos;
        [browser show];
        
        
    }
    
}

-(void)clickRemoveComment:(NSNotification *)notification
{
    NSLog(@"clickRemovePost");
    NSDictionary *dic = [notification userInfo];
    _deletePid = [dic objectForKey:@"pid"];
    NSString *tUid = [dic objectForKey:@"uid"];
    _deletePidPos = [dic objectForKey:@"msgPos"];
    _deleteCellNum = [dic objectForKey:@"cellNum"];
    _deleteTid = [dic objectForKey:@"tid"];
    likeCellNum = [dic objectForKey:@"cellNum"];

    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];

    if ([tUid isEqual: uid]) {
        isCommentComment = NO;
        [textView resignFirstResponder];

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"删除这条评论？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"删除",nil];
        alert.tag = 274;
        [alert show];
    }else {
        // 如果是别人发的，评论别人的评论
        NSDictionary *dic;

            if (_segmentControl.selectedSegmentIndex == 0) {
                dic = [dataArray objectAtIndex:_deleteCellNum.integerValue];
            }else {
                dic = [dataArrayR objectAtIndex:_deleteCellNum.integerValue];
            }

        NSDictionary *commentsDic = [dic objectForKey:@"comments"];
        NSArray *commentsList = [commentsDic objectForKey:@"list"];

        NSDictionary *cmt = [commentsList objectAtIndex:_deletePidPos.integerValue];
        
        _replyTo = [NSString stringWithFormat:@"回复%@: ", [cmt objectForKey:@"name"]];
        _isFirstClickReply = true;

        textView.text = @"";
        
        _replyToLabel.text = _replyTo;
        [_replyToLabel setHidden:NO];

//        textView.text = [NSString stringWithFormat:@"回复%@:", [cmt objectForKey:@"name"]];
//        _isFirstClickReply = true;

        [textView becomeFirstResponder];
        
        isCommentComment = YES;
    }
}

-(void)clickRemovePost:(NSNotification *)notification
{
    NSLog(@"clickRemovePost");
    NSDictionary *dic = [notification userInfo];
    _deleteTid = [dic objectForKey:@"tid"];
    _deleteCellNum = [dic objectForKey:@"cellNum"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"删除这条动态？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"删除",nil];
    alert.tag = 275;
    [alert show];
}

-(void)showName1:(NSNotification *)notification
{
    NSLog(@"showDetail");
    NSDictionary *dic = [notification userInfo];
    
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
    fpvc.fuid = [dic objectForKey:@"uid"];
    [self.navigationController pushViewController:fpvc animated:YES];
    
    [MyTabBarController setTabBarHidden:YES];
}

-(void)showDetail:(NSNotification *)notification
{
    NSLog(@"showDetail");
    NSDictionary *dic = [notification userInfo];

    MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
    momentsDetailViewCtrl.tid = [dic objectForKey:@"tid"];
    [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];

    [MyTabBarController setTabBarHidden:YES];
}

-(void)clickComment:(NSNotification *)notification
{
    NSLog(@"clickComment");
    NSDictionary *dic = [notification userInfo];
    NSString *tid = [dic objectForKey:@"cellTid"];
    
    _commentTid = tid;
    likeCellNum = [dic objectForKey:@"cellNum"];
    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    
    isCommentComment = NO;
    textView.text = @"";
    _replyTo = @"";
    _replyToLabel.hidden = YES;
    
    [self clickTextView:nil];
    
    
}
//-----add by kate--------------------------------------------------
-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolBar.hidden = YES;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    //textView.returnKeyType = UIReturnKeyDone;
    
    //---update 2015.07.23-----------------------------------------------
//    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
//    singleTouch.delegate = self;
//    [textView addGestureRecognizer:singleTouch];

    //---------------------------------------------------------------------

    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    _replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _replyToLabel.enabled = NO;
    _replyToLabel.text = @"";
    _replyToLabel.font =  [UIFont systemFontOfSize:13];
    _replyToLabel.textColor = [UIColor grayColor];
    [textView addSubview:_replyToLabel];

    [toolBar addSubview:entryImageView];
    [toolBar addSubview:textView];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    clickFlag = 0;

    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(284.0 - 9, 5.0, 40.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    
    [self.view addSubview:toolBar];
}

// 自定义输入框发表按钮,发送评论
-(void)AudioClick:(id)sender{
    if ([@""  isEqual: textView.text]) {
        //[MBProgressHUD showError:@"请输入回复内容。" toView:textView.inputView];
        [Utilities showFailedHud:@"请输入回复内容" descView:textView.inputView];//2015.05.12
    }else {
        if (isCommentComment) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"comment", @"op",
                                  _deleteTid, @"tid",
                                  _deletePid, @"pid",
                                  textView.text, @"message",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsComment andData:data];
            
            isCommentComment = NO;
        }else {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"comment", @"op",
                                  _commentTid, @"tid",
                                  textView.text, @"message",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsComment andData:data];
        }
        
        
        
        //--------------------------------------------------
        //键盘下落
        isButtonClicked = NO;
        textView.inputView = nil;
        isSystemBoardShow = NO;
        textView.text = @"";
        textView.frame = CGRectMake(43.0, 5.0, 205-15+40.0, 33);
        clickFlag = 0;
        [textView resignFirstResponder];
        toolBar.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44);
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }
}

// 自定义输入框点击输入框事件
-(void)clickTextView:(id)sender{
    
    if (textView.inputView!=nil) {
        isButtonClicked = YES;
        textView.inputView = nil;
        isSystemBoardShow = YES;
        clickFlag = 0;
        [textView resignFirstResponder];
    }else{
        [textView becomeFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
//        if ( range.length > 1 ) {
//            
//            return YES;
//        }
//        else {
//            
//            [faceBoard backFace];
//            
//            return NO;
//        }
        return YES;
    }
    else {
        if (range.location >= 500) {// 校友圈回帖 500 2015.07.21
            return NO;
        }else {
            if (_isFirstClickReply) {
                self->textView.text = @"";
                _isFirstClickReply = false;
            }

            return YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    _replyToLabel.text = _replyTo;
    
    if ([_textView.text length] == 0) {
        [_replyToLabel setHidden:NO];
    }else{
        [_replyToLabel setHidden:YES];
    }

    CGSize size = textView.contentSize;
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
       
    }
}

-(void)faceBoardClick:(id)sender{
    
    if (_isFirstClickReply) {
        self->textView.text = @"";
        _isFirstClickReply = false;
    }

    clickFlag = 1;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [textView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            textView.inputView = faceBoard;
        }
        
        [textView becomeFirstResponder];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // 键盘弹出时，清空输入框，之后可以优化为为每一条记录之前输入的内容，类似微信。
//    textView.text = @"";
    
    toolBar.hidden = NO;
    
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         _tableView.frame = frame;
                         
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        switch (clickFlag) {
            case 1:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                
                break;
            default:
                break;
        }
        
    }
    else {
        
        switch (clickFlag) {
            case 1:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
            default:
                break;
        }
    }
    
//    if ( discussArray.count ) {
//        
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:discussArray.count - 1
//                                                              inSection:0]
//                          atScrollPosition:UITableViewScrollPositionBottom
//                                  animated:NO];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    toolBar.hidden = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         _tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
//    isCommentComment = NO;
    //textView.text = @"";
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        //        if ( ![textView.inputView isEqual:faceBoard] ) {
        //
        //            isSystemBoardShow = NO;
        //
        //            textView.inputView = faceBoard;
        //
        //        }
        //        else {
        //
        //            isSystemBoardShow = YES;
        //
        //            textView.inputView = nil;
        //        }
        
        
        
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [textView.inputView isEqual:faceBoard]) {
                    
                    isSystemBoardShow = YES;
                    textView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        textView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        textView.inputView = faceBoard;
                        
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    textView.inputView = faceBoard;
                    
                }
            }
                
                break;
            default:
                break;
        }
        
        [textView becomeFirstResponder];
    }
}

-(void)dismissKeyboard{
    
    
    [textView resignFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];

}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if(([touch.view isMemberOfClass:[TSTouchLabel class]]) ||
//       ([touch.view isMemberOfClass:[TSAttributedLabel class]]) ||
//       ([touch.view isMemberOfClass:[UIButton class]]) ||
//       ([touch.view isMemberOfClass:[UITableViewCell class]])) {
//        //放过以上事件的点击拦截
//        
//        return NO;
//    }else{
//        
//        UIView* v=[touch.view superview];
//        
//        // 特殊放过tableViewCell的点击事件
////        if([v isMemberOfClass:[Test1TableViewCell class]]) {
////            return NO;
////        }
//        
//        return YES;
//    }
//}


//-----------------------------------------------------------------------

-(void)clickLike:(NSNotification *)notification
{
    NSLog(@"clickLike");
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *dic = [notification userInfo];
    NSString *tid = [dic objectForKey:@"tid"];

    likeCellNum = [dic objectForKey:@"cellNum"];
    NSString *love = [dic objectForKey:@"cellLove"];
    NSString *op = @"love";
    
    if ([@"1"  isEqual: love]) {
        op = @"hate";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                          @"Circle",@"ac",
                          @"2",@"v",
                          op, @"op",
                          tid,@"tid",
                          nil];
    
    [network sendHttpReq:HttpReq_MomentsLike andData:data];
}

-(void)showProfile:(NSNotification *)notification
{
    NSLog(@"showProfile");
    NSDictionary *dic = [notification userInfo];
    NSString *uid = [dic objectForKey:@"uid"];
    
    [MyTabBarController setTabBarHidden:YES];

    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
    fpvc.fuid = uid;
    [self.navigationController pushViewController:fpvc animated:YES];
}

-(void)showMore:(NSNotification *)notification
{
    NSLog(@"showMore");
    
        if (_segmentControl.selectedSegmentIndex == 0) {
            NSDictionary *dic = [notification userInfo];
            NSUInteger cellNum = [[dic objectForKey:@"cellNum"] integerValue];
            
            NSUInteger cellHeight = [[cellHeightArray objectAtIndex:cellNum] integerValue];
            NSUInteger cellMsgHeight = [[[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"height"] integerValue];
            NSUInteger cellMoreFlag = [[[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"more"] integerValue];
            NSUInteger cellCommentHeight1 = [[[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"commentHeight1"] integerValue];
            NSUInteger cellCommentHeight2 = [[[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"commentHeight2"] integerValue];
            NSUInteger cellCommentHeight3 = [[[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"commentHeight3"] integerValue];
            
            NSMutableArray *commentHeightArr = [[cellMessageHeightArray objectAtIndex:cellNum] objectForKey:@"commentHeightArr"];
            
            if (0 == cellMoreFlag) {
                // 如果为未展开状态，增加高度，并把flag设置为1
                [cellHeightArray replaceObjectAtIndex:cellNum withObject:[NSString stringWithFormat:@"%lu",(cellHeight + cellMsgHeight - 60)]];
                
                NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellMsgHeight],@"height",
                                                         @"1",@"more",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight1],@"commentHeight1",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight2],@"commentHeight2",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight3],@"commentHeight3",
                                                         commentHeightArr, @"commentHeightArr",
                                                         nil];
                
                [cellMessageHeightArray replaceObjectAtIndex:cellNum withObject:cellMsgHeightDic];
                
                [_tableView reloadData];
                
            }else {
                // 如果为展开状态，减少高度，并把flag设置为0
                [cellHeightArray replaceObjectAtIndex:cellNum withObject:[NSString stringWithFormat:@"%lu",(cellHeight - cellMsgHeight + 60)]];
                
                NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellMsgHeight],@"height",
                                                         @"0",@"more",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight1],@"commentHeight1",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight2],@"commentHeight2",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight3],@"commentHeight3",
                                                         commentHeightArr, @"commentHeightArr",
                                                         nil];
                [cellMessageHeightArray replaceObjectAtIndex:cellNum withObject:cellMsgHeightDic];
                
                [_tableView reloadData];
                
                //---2015.09.06--------------------------------------------------------------
                // 滚动到之前的位置 内容非常长的时候点击“收起”不在当前cell，以下代码修正此问题
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellNum -1 inSection:0];
                CGRect showRect = [_tableView rectForRowAtIndexPath:indexPath];
                showRect.origin.y = showRect.origin.y + 325;
                [_tableView scrollRectToVisible:showRect animated:NO];
                //---------------------------------------------------------------------------
                
            }
            
            //[_tableView reloadData];
            
            [self setFooterView];

        }else {
            NSDictionary *dic = [notification userInfo];
            NSUInteger cellNum = [[dic objectForKey:@"cellNum"] integerValue];
            
            NSUInteger cellHeight = [[cellHeightArrayR objectAtIndex:cellNum] integerValue];
            NSUInteger cellMsgHeight = [[[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"height"] integerValue];
            NSUInteger cellMoreFlag = [[[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"more"] integerValue];
            NSUInteger cellCommentHeight1 = [[[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"commentHeight1"] integerValue];
            NSUInteger cellCommentHeight2 = [[[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"commentHeight2"] integerValue];
            NSUInteger cellCommentHeight3 = [[[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"commentHeight3"] integerValue];
            
            NSMutableArray *commentHeightArr = [[cellMessageHeightArrayR objectAtIndex:cellNum] objectForKey:@"commentHeightArr"];
            
            if (0 == cellMoreFlag) {
                // 如果为未展开状态，增加高度，并把flag设置为1
                [cellHeightArrayR replaceObjectAtIndex:cellNum withObject:[NSString stringWithFormat:@"%lu",(cellHeight + cellMsgHeight - 60)]];
                
                NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellMsgHeight],@"height",
                                                         @"1",@"more",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight1],@"commentHeight1",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight2],@"commentHeight2",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight3],@"commentHeight3",
                                                         commentHeightArr, @"commentHeightArr",
                                                         nil];
                
                [cellMessageHeightArrayR replaceObjectAtIndex:cellNum withObject:cellMsgHeightDic];
                
                [_tableViewR reloadData];
                
            }else {
                // 如果为展开状态，减少高度，并把flag设置为0
                [cellHeightArrayR replaceObjectAtIndex:cellNum withObject:[NSString stringWithFormat:@"%lu",(cellHeight - cellMsgHeight + 60)]];
                
                NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellMsgHeight],@"height",
                                                         @"0",@"more",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight1],@"commentHeight1",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight2],@"commentHeight2",
                                                         [NSString stringWithFormat:@"%lu",(unsigned long)cellCommentHeight3],@"commentHeight3",
                                                         commentHeightArr, @"commentHeightArr",
                                                         nil];
                [cellMessageHeightArrayR replaceObjectAtIndex:cellNum withObject:cellMsgHeightDic];
                
                [_tableViewR reloadData];
                
                //---2015.09.06--------------------------------------------------------------
                // 滚动到之前的位置 内容非常长的时候点击“收起”不在当前cell，以下代码修正此问题
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellNum -1 inSection:0];
                CGRect showRect = [_tableViewR rectForRowAtIndexPath:indexPath];
                showRect.origin.y = showRect.origin.y + 325;
                [_tableViewR scrollRectToVisible:showRect animated:NO];
                //---------------------------------------------------------------------------
                
            }
            
            //[_tableView reloadData];
            
            [self setFooterView];

        }

    
    
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];

    // 因为在viewwillappare里面调用了 所以这里不调用
    // 发出两次请求会有问题
    NSDictionary *data;

    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
    
    //----离线缓存2015.05.14--------------------------
    BOOL isConnect = [Utilities connectedToNetwork];
    page = 0;
    
    if (isConnect) {
        [Utilities showProcessingHud:self.view];// 2015.05.12
    }
    //-----------------------------------------------

    
    // 学校动态列表
    if ([msgLastId length] == 0) {
        msgLastId = _lastMsgId;
    }
    NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                          @"CircleTeacher",@"ac",
                          @"3",@"v",
                          @"school", @"op",
                          startNum, @"page",
                          endNum, @"size",
                          msgLastId,@"last",
                          nil];
    [network sendHttpReq:HttpReq_MomentsClassroom andData:data1];
    
    
    
//    if([@"school"  isEqual: _fromName]) {
//        
//        /**
//         * 校友圈列表::教师学校入口
//         * @author luke
//         * @date 2015.12.20
//         * @args
//         *  v=3, ac=CircleTeacher, op=school, sid=, cid=, uid=, page=, size=, $last=
//         */
//
//        /**
//         * 校友圈列表::教师班级入口
//         * @author luke
//         * @date 2015.12.20
//         * @args
//         *  v=3, ac=CircleTeacher, op=classes, sid=, cid=, uid=, page=, size=, $last=
//         */
//
//        if (isConnect) {
//            // 需要判断
//            // 校园动态，改版之后这里只处理老师的动态
//            if (_segmentControl.selectedSegmentIndex == 0) {
//                // 学校动态列表
//                if ([msgLastId length] == 0) {
//                    msgLastId = _lastMsgId;
//                }
//                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                        @"CircleTeacher",@"ac",
//                        @"3",@"v",
//                        @"school", @"op",
//                        startNum, @"page",
//                        endNum, @"size",
//                        msgLastId,@"last",
//                        nil];
//
//                
//                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//            }else if (_segmentControl.selectedSegmentIndex == 1) {
//                // 班级动态列表
//                if ([msgLastId length] == 0) {
//                    msgLastId = _lastMsgId;
//                }
//                
//                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                        @"CircleTeacher",@"ac",
//                        @"3",@"v",
//                        @"classes", @"op",
//                        startNumR, @"page",
//                        endNumR, @"size",
//                        msgLastId,@"last",
//                        nil];
//                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//            }
//
//        }else{// 离线缓存 2015.05.14
//            
//            [self getDataFromDB:@"school"];
//        }
//        
//    }else if([@"mine"  isEqual: _fromName]) {
//       
//        if (isConnect) {
//        
//           data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                @"Circle",@"ac",
//                @"2",@"v",
//                @"mine", @"op",
//                startNum, @"page",
//                endNum, @"size",
//                msgLastId,@"last",
//                nil];
//            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//            
//        }else{// 离线缓存 2015.05.14
//            
//            [self getDataFromDB:@"mine"];
//        }
//        
//        [ReportObject event:ID_CIRCLE_SEE_IN_ME];//2015.06.25
//            
//    }else if([@"other"  isEqual: _fromName]) {
//        
//        if (![Utilities isConnected]) {//2015.06.30
//            
//            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
//            [self.view addSubview:noNetworkV];
//            return;
//            
//        }
//        
//        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                @"Circle",@"ac",
//                @"2",@"v",
//                @"other", @"op",
//                startNum, @"page",
//                endNum, @"size",
//                msgLastId,@"last",
//                _fuid,@"other",
//                nil];
//        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//        
//        [ReportObject event:ID_CIRCLE_SEE_IN_USER];//2015.06.25
//        
//        
//    }else if([@"class"  isEqual: _fromName]) {
//        // 班级动态，改版之后这里只处理学生和家长的动态
//        // 老师的都转移到首页了
//        if (![Utilities isConnected]) {//2015.06.30
//            
//            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
//            [self.view addSubview:noNetworkV];
//            return;
//            
//        }
//        
//        /**
//         * 校友圈列表::学生入口
//         * @author luke
//         * @date 2015.12.20
//         * @args
//         *  v=3, ac=CircleStudent, op=streams, sid=, cid=, uid=, page=, size=, $last=
//         */
//        
//        /**
//         * 校友圈列表::家长入口
//         * @author luke
//         * @date 2015.12.20
//         * @args
//         *  v=3, ac=CircleParent, op=streams, sid=, cid=, uid=, page=, size=, $last=
//         */
//
//        /**
//         * 校友圈列表::学校入口
//         * @author luke
//         * @date 2015.12.20
//         * @args
//         *  v=3, ac=CircleTeacher|CircleStudent|CircleParent op=school, sid=, cid=, uid=, page=, size=, $last=
//         */
//        
//        
//        if ([@"0"  isEqual: _userType]) {
//            // 学生
//            if ([msgLastId length] == 0) {
//                msgLastId = _lastMsgId;
//            }
//            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                    @"CircleStudent",@"ac",
//                    @"3",@"v",
//                    @"school", @"op",
//                    _cid,@"cid",
//                    startNum, @"page",
//                    endNum, @"size",
//                    msgLastId,@"last",
//                    nil];
//
////            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
////                    @"CircleStudent",@"ac",
////                    @"3",@"v",
////                    @"streams", @"op",
////                    _cid,@"cid",
////                    startNum, @"page",
////                    endNum, @"size",
////                    msgLastId,@"last",
////                    nil];
//            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//        }else if ([@"6"  isEqual: _userType]) {
//            
//            if ([msgLastId length] == 0) {
//                msgLastId = _lastMsgId;
//            }
//            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                    @"CircleParent",@"ac",
//                    @"3",@"v",
//                    @"school", @"op",
//                    _cid,@"cid",
//                    startNum, @"page",
//                    endNum, @"size",
//                    msgLastId,@"last",
//                    nil];
//
////            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
////                    @"CircleParent",@"ac",
////                    @"3",@"v",
////                    @"streams", @"op",
////                    _cid,@"cid",
////                    startNum, @"page",
////                    endNum, @"size",
////                    msgLastId,@"last",
////                    nil];
//            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//        }else {
//            // 学校动态列表
//            if ([msgLastId length] == 0) {
//                msgLastId = _lastMsgId;
//            }
//            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                    @"CircleTeacher",@"ac",
//                    @"3",@"v",
//                    @"school", @"op",
//                    startNum, @"page",
//                    endNum, @"size",
//                    msgLastId,@"last",
//                    nil];
//            
//            
//            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//
//        }
//        
//        [ReportObject event:ID_CIRCLE_SEE_IN_CLASS];//2015.06.25
//    }
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

-(void)testFinishedLoadDataR{
    
    [self finishReloadingDataR];
    [self setFooterViewR];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (_refreshHeaderView) {
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
            }
            
            if (_refreshFooterView) {
                [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
                [self setFooterView];
            }
        }else {
            if (_refreshHeaderViewR) {
                [_refreshHeaderViewR egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableViewR];
            }
            
            if (_refreshFooterViewR) {
                [_refreshFooterViewR egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableViewR];
                [self setFooterView];
            }
        }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)finishReloadingDataR{
    
    //  model should call this when its done loading
    _reloading = NO;
    
            if (_refreshHeaderViewR) {
                [_refreshHeaderViewR egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableViewR];
            }
            
            if (_refreshFooterViewR) {
                [_refreshFooterViewR egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableViewR];
                [self setFooterViewR];
            }
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
        if (_segmentControl.selectedSegmentIndex == 0) {
            CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
            if (_refreshFooterView && [_refreshFooterView superview])
            {
                // reset position
                _refreshFooterView.frame = CGRectMake(0.0f,
                                                      height,
                                                      self->_tableView.frame.size.width,
                                                      self.view.bounds.size.height);
            }else
            {
                // create the footerView
                _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                      CGRectMake(0.0f, height,
                                                 self.view.frame.size.width, self->_tableView.bounds.size.height)];
                _refreshFooterView.delegate = self;
                [self->_tableView addSubview:_refreshFooterView];
            }
            
            if (_refreshFooterView)
            {
                [_refreshFooterView refreshLastUpdatedDate];
            }
        }else {
            CGFloat height = MAX(self->_tableViewR.bounds.size.height, self->_tableViewR.contentSize.height);
            if (_refreshFooterViewR && [_refreshFooterViewR superview])
            {
                // reset position
                _refreshFooterViewR.frame = CGRectMake(0.0f,
                                                      height,
                                                      self->_tableViewR.frame.size.width,
                                                      self.view.bounds.size.height);
            }else
            {
                // create the footerView
                _refreshFooterViewR = [[EGORefreshTableFooterView alloc] initWithFrame:
                                      CGRectMake(0.0f, height,
                                                 self.view.frame.size.width, self->_tableViewR.bounds.size.height)];
                _refreshFooterViewR.delegate = self;
                [self->_tableViewR addSubview:_refreshFooterViewR];
            }
            
            if (_refreshFooterViewR)
            {
                [_refreshFooterViewR refreshLastUpdatedDate];
            }
        }
}

-(void)setFooterViewR{
            CGFloat height = MAX(self->_tableViewR.bounds.size.height, self->_tableViewR.contentSize.height);
            if (_refreshFooterViewR && [_refreshFooterViewR superview])
            {
                // reset position
                _refreshFooterViewR.frame = CGRectMake(0.0f,
                                                       height,
                                                       self->_tableViewR.frame.size.width,
                                                       self.view.bounds.size.height);
            }else
            {
                // create the footerView
                _refreshFooterViewR = [[EGORefreshTableFooterView alloc] initWithFrame:
                                       CGRectMake(0.0f, height,
                                                  self.view.frame.size.width, self->_tableViewR.bounds.size.height)];
                _refreshFooterViewR.delegate = self;
                [self->_tableViewR addSubview:_refreshFooterViewR];
            }
            
            if (_refreshFooterViewR)
            {
                [_refreshFooterViewR refreshLastUpdatedDate];
            }
}

-(void)removeFooterView
{
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (_refreshFooterView && [_refreshFooterView superview])
            {
                [_refreshFooterView removeFromSuperview];
            }
            _refreshFooterView = nil;
        }else {
            if (_refreshFooterViewR && [_refreshFooterViewR superview])
            {
                [_refreshFooterViewR removeFromSuperview];
            }
            _refreshFooterViewR = nil;
        }

}

-(void)removeFooterViewR
{
            if (_refreshFooterViewR && [_refreshFooterViewR superview])
            {
                [_refreshFooterViewR removeFromSuperview];
            }
            _refreshFooterViewR = nil;
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
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//---add by kate------------------------------
// 刷新发现列表
-(void)reloadOfShoolMoments{
    
    startNum = @"0";
    endNum = @"30";
    
    startNumR = @"0";
    endNumR = @"30";

    NSDictionary *data;
    
    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
    
   if([@"mine"  isEqual: _fromName]) {
        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                @"Circle",@"ac",
                @"2",@"v",
                @"mine", @"op",
                startNum, @"page",
                endNum, @"size",
                msgLastId,@"last",
                nil];
        
        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
   }else{
       if (_segmentControl.selectedSegmentIndex == 0) {
           // 学校动态列表
           if ([msgLastId length] == 0) {
               msgLastId = _lastMsgId;
           }
           
           data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                   @"CircleTeacher",@"ac",
                   @"3",@"v",
                   @"school", @"op",
                   startNum, @"page",
                   endNum, @"size",
                   msgLastId,@"last",
                   nil];
           [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
       }else if (_segmentControl.selectedSegmentIndex == 1) {
           // 班级动态列表
           if ([msgLastId length] == 0) {
               msgLastId = _lastMsgId;
           }
           data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                   @"CircleTeacher",@"ac",
                   @"3",@"v",
                   @"classes", @"op",
                   startNumR, @"page",
                   endNumR, @"size",
                   msgLastId,@"last",
                   nil];
           [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
       }
   }
}
//--------------------------------------------

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"30";
        
        startNumR = @"0";
        endNumR = @"30";

        NSDictionary *data;
        
//        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
//        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];

        if([@"school"  isEqual: _fromName]) {
            if (_segmentControl.selectedSegmentIndex == 0) {
                // 学校动态列表
                if ([msgLastId length] == 0) {
                    msgLastId = _lastMsgId;
                }
                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"CircleTeacher",@"ac",
                        @"3",@"v",
                        @"school", @"op",
                        startNum, @"page",
                        endNum, @"size",
                        msgLastId,@"last",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            }else if (_segmentControl.selectedSegmentIndex == 1) {
                // 班级动态列表
                if ([msgLastId length] == 0) {
                    msgLastId = _lastMsgId;
                }

                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"CircleTeacher",@"ac",
                        @"3",@"v",
                        @"classes", @"op",
                        startNumR, @"page",
                        endNumR, @"size",
                        msgLastId,@"last",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
            }
        }else if([@"mine"  isEqual: _fromName]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"Circle",@"ac",
                    @"2",@"v",
                    @"mine", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];

        }else if([@"other"  isEqual: _fromName]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"Circle",@"ac",
                    @"2",@"v",
                    @"other", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    _fuid,@"other",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];

        }else if([@"class"  isEqual: _fromName]) {
            if (_segmentControl.selectedSegmentIndex == 0) {
                if ([@"0"  isEqual: _userType]) {
                    // 学生
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleStudent",@"ac",
                            @"3",@"v",
                            @"school", @"op",
                            _cid,@"cid",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }else if ([@"6"  isEqual: _userType]) {
                    // 家长
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleParent",@"ac",
                            @"3",@"v",
                            @"school", @"op",
                            _cid,@"cid",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }else {
                    // 学校动态列表
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleTeacher",@"ac",
                            @"3",@"v",
                            @"school", @"op",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    
                    
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                    
                }
            }else if (_segmentControl.selectedSegmentIndex == 1) {
                if ([@"0"  isEqual: _userType]) {
                    // 学生
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleStudent",@"ac",
                            @"3",@"v",
                            @"streams", @"op",
                            _cid,@"cid",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }else if ([@"6"  isEqual: _userType]) {
                    // 家长
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleParent",@"ac",
                            @"3",@"v",
                            @"streams", @"op",
                            _cid,@"cid",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }else {
                    // 班级动态列表
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleTeacher",@"ac",
                            @"3",@"v",
                            @"classes", @"op",
                            startNumR, @"page",
                            endNumR, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }

            }


        }

        //NSLog(@"data:%@",data);
//        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
    }
}
//加载调用的方法
-(void)getNextPageView
{
    if (reflashFlag == 1) {
        NSDictionary *data;
        
        NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
        NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];

        //----离线缓存2015.05.14--------------------------
        BOOL isConnect = [Utilities connectedToNetwork];
        //----------------------------------------------
        
        if([@"school"  isEqual: _fromName]) {
            
            if (isConnect) {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    // 学校动态列表
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleTeacher",@"ac",
                            @"3",@"v",
                            @"school", @"op",
                            startNum, @"page",
                            endNum, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }else if (_segmentControl.selectedSegmentIndex == 1) {
                    // 班级动态列表
                    if ([msgLastId length] == 0) {
                        msgLastId = _lastMsgId;
                    }
                    data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                            @"CircleTeacher",@"ac",
                            @"3",@"v",
                            @"classes", @"op",
                            startNumR, @"page",
                            endNumR, @"size",
                            msgLastId,@"last",
                            nil];
                    [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                }
            }else{
                
                 page++;
                [self getDataFromDB:@"school"];
            }
        }else if([@"mine"  isEqual: _fromName]) {
            
            if (isConnect) {
                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                        @"Circle",@"ac",
                        @"2",@"v",
                        @"mine", @"op",
                        startNum, @"page",
                        endNum, @"size",
                        msgLastId,@"last",
                        nil];
                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];

            }else{
                
                 page++;
                [self getDataFromDB:@"mine"];
            }
            
        }else if([@"other"  isEqual: _fromName]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                    @"Circle",@"ac",
                    @"2",@"v",
                    @"other", @"op",
                    startNum, @"page",
                    endNum, @"size",
                    msgLastId,@"last",
                    _fuid,@"other",
                    nil];
            [network sendHttpReq:HttpReq_MomentsClassroom andData:data];

        }else if([@"class"  isEqual: _fromName]) {
            {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    if ([@"0"  isEqual: _userType]) {
                        // 学生
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleStudent",@"ac",
                                @"3",@"v",
                                @"school", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                    }else if ([@"6"  isEqual: _userType]) {
                        // 家长
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleParent",@"ac",
                                @"3",@"v",
                                @"school", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                    }else {
                        // 学校动态列表
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleTeacher",@"ac",
                                @"3",@"v",
                                @"school", @"op",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        
                        
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                        
                    }
                }else if (_segmentControl.selectedSegmentIndex == 1) {
                    if ([@"0"  isEqual: _userType]) {
                        // 学生
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleStudent",@"ac",
                                @"3",@"v",
                                @"streams", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                    }else if ([@"6"  isEqual: _userType]) {
                        // 家长
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleParent",@"ac",
                                @"3",@"v",
                                @"streams", @"op",
                                _cid,@"cid",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                    }else {
                        // 学校动态列表
                        if ([msgLastId length] == 0) {
                            msgLastId = _lastMsgId;
                        }
                        data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                @"CircleTeacher",@"ac",
                                @"3",@"v",
                                @"classes", @"op",
                                startNum, @"page",
                                endNum, @"size",
                                msgLastId,@"last",
                                nil];
                        
                        
                        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
                        
                    }
                }
                
                
            }
            
            
//            if ([@"0"  isEqual: _userType]) {
//                // 学生
//                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                        @"CircleStudent",@"ac",
//                        @"3",@"v",
//                        @"streams", @"op",
//                        _cid,@"cid",
//                        startNum, @"page",
//                        endNum, @"size",
//                        msgLastId,@"last",
//                        nil];
//                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//            }else if ([@"6"  isEqual: _userType]) {
//                // 家长
//                data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
//                        @"CircleParent",@"ac",
//                        @"3",@"v",
//                        @"streams", @"op",
//                        _cid,@"cid",
//                        startNum, @"page",
//                        endNum, @"size",
//                        msgLastId,@"last",
//                        nil];
//                [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
//            }
        }

        //NSLog(@"data:%@",data);
//        [network sendHttpReq:HttpReq_MomentsClassroom andData:data];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (_reloading == NO) {
                if (_refreshHeaderView)
                {
                    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
                }
                
                if (_refreshFooterView)
                {
                    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
                }
            }
        }else {
            if (_reloading == NO) {
                if (_refreshHeaderViewR)
                {
                    [_refreshHeaderViewR egoRefreshScrollViewDidScroll:scrollView];
                }
                
                if (_refreshFooterViewR)
                {
                    [_refreshFooterViewR egoRefreshScrollViewDidScroll:scrollView];
                }
            }
        }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (_reloading == NO) {
                if (_refreshHeaderView)
                {
                    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
                }
                
                if (_refreshFooterView)
                {
                    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
                }
            }
        }else {
            if (_reloading == NO) {
                if (_refreshHeaderViewR)
                {
                    [_refreshHeaderViewR egoRefreshScrollViewDidEndDragging:scrollView];
                }
                
                if (_refreshFooterViewR)
                {
                    [_refreshFooterViewR egoRefreshScrollViewDidEndDragging:scrollView];
                }
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

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tb]) {
        return dataArr.count;
    }
    else{
        // 其他身份有俩
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (tableView == _tableView) {
                return [dataArray count];
            }else {
                return 0;
            }

        }else {
            if (tableView == _tableViewR) {
                return [dataArrayR count];
            }else {
                return 0;
            }

        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tb]) {
        return 40;
    }else{
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (tableView == _tableView) {
                return [[cellHeightArray objectAtIndex:[indexPath row]] integerValue];
            }else {
                return 0;
            }
        }else {
            if (tableView == _tableViewR) {
                return [[cellHeightArrayR objectAtIndex:[indexPath row]] integerValue];
            }else {
                return 0;
            }

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:tb]) {
        
        static NSString *CellIdentifier = @"listCell";
        //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (dataArr.count != 0) {
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            else{
                if (indexPath.row < dataArr.count) {
                    
                    
                    cell.textLabel.text = dataArr[indexPath.row];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
                    cell.textLabel.font = [UIFont systemFontOfSize:[Utilities convertPixsH:17]];
                }
                else{
                    
                }
            }
            return cell;
        }
        else{
            return cell;
        }
        
    }else{
        if ([numberArr containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
            
            static NSString *CellTableIdentifier = @"advertisingIdentifier";
            advertisingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
            if(cell == nil) {
                cell = [[advertisingTableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellTableIdentifier];
            }
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.accessoryType = UITableViewCellAccessoryNone;
            NSDictionary *tempDic = [[NSDictionary alloc] init];
            for (int i = 0; i < _advertisingArr.count; i++) {
                if ([[NSString stringWithFormat:@"%ld", [[_advertisingArr[i] objectForKey:@"position"] integerValue] - 1] isEqualToString:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
                    tempDic = _advertisingArr[i];
                }
                
            }
            if (_advertisingArr.count > 0) {
                
                //                NSInteger startLine = [[[tempDic objectForKey:@"plan"] objectForKey:@"start"] integerValue];
                //                NSInteger endLine = [[[tempDic objectForKey:@"plan"]objectForKey:@"end"] integerValue];
                //                if (currentDateLine > startLine && currentDateLine < endLine) {
                cell.nameLabel.text = [tempDic objectForKey:@"title"];
                cell.describeLabel.text = [tempDic objectForKey:@"note"];
                [cell.headImv sd_setImageWithURL:[tempDic objectForKey:@"avatar"]];
                [cell.bigImv sd_setImageWithURL:[tempDic objectForKey:@"pic"]];
                //                }
                CGSize tempSize = [Utilities getLabelHeight:cell.describeLabel size:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 75, MAXFLOAT)];
                CGFloat tempHeight = tempSize.height;
                [cell.describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.headImv.mas_left).with.offset(0);
                    make.top.equalTo(cell.headImv.mas_bottom).with.offset(9);
                    make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 20, tempHeight));
                }];
                
                UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
                touchButton.backgroundColor = [UIColor clearColor];
                touchButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [[cellHeightArray objectAtIndex:[indexPath row]] integerValue]);
                touchButton.tag = indexPath.row;
                [cell.contentView addSubview:touchButton];
                [touchButton addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }else{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";

    NSUInteger row = [indexPath row];
    
    MomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MomentsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(([@"mine"  isEqual: _fromName]) || ([@"other"  isEqual: _fromName])) {
        NSDictionary *dic = [dataArray objectAtIndex:row];

        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        cell.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
        
        Utilities *util = [Utilities alloc];
        
        cell.cellUid = [dic objectForKey:@"uid"];
        cell.cellTid = [dic objectForKey:@"id"];
        
        cell.label_dateline.text = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@月%@日 %@:%@" andType:DateFormat_MDHM];
        cell.tsLabel_delete.hidden = YES;

        // 头像
        cell.btn_thumb.hidden = YES;

        cell.ohAttLabel_comment1.hidden = YES;
        cell.ohAttLabel_comment2.hidden = YES;
        cell.ohAttLabel_comment3.hidden = YES;

        cell.btn_detail.hidden = YES;
        cell.imgView_detail.hidden = YES;
        cell.label_username.userInteractionEnabled = NO;

        if (row == 0) {
            cell.img_cell0Img.hidden = NO;
            cell.img_cell0Img.frame = CGRectMake(50, 10, 40, 40);
            
            // 日期
            cell.label_dateline.frame = CGRectMake(5, 50, 55, 40);
            cell.label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.label_dateline setTextAlignment:NSTextAlignmentCenter];
            cell.label_dateline.numberOfLines = 0;
            
            // 圆点
            cell.imgView_leftlittilPoint.frame = CGRectMake(60, 50, 34, 34);
            
            // 左边竖线
            [cell.imgView_leftLine setFrame:CGRectMake(70,
                                                       80,
                                                       2,
                                                       [[cellHeightArray objectAtIndex:[indexPath row]] integerValue]-80)];
            
            likePosY = 60;
            yOffset = 60;
            offset.y = 60;
            offset.x = 100;
        }else {
            cell.img_cell0Img.hidden = YES;
            cell.img_cell0Img.frame = CGRectZero;
            
            // 日期
            cell.label_dateline.frame = CGRectMake(5, 0, 55, 40);
            cell.label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.label_dateline setTextAlignment:NSTextAlignmentCenter];
            cell.label_dateline.numberOfLines = 0;
            
            // 圆点
            cell.imgView_leftlittilPoint.frame = CGRectMake(60, 0, 34, 34);
            
            // 左边竖线
            [cell.imgView_leftLine setFrame:CGRectMake(70,
                                                       30,
                                                       2,
                                                       [[cellHeightArray objectAtIndex:[indexPath row]] integerValue]-30)];
            
            likePosY = 10;
            yOffset = 10;
            offset.y = 10;
            offset.x = 100;
        }
        
        [cell setMLLabelText:[dic objectForKey:@"message"]];
        
        if ([@""  isEqual: [dic objectForKey:@"message"]]) {
            cell.ohAttributeLabel.userInteractionEnabled = NO;
        }else {
            cell.ohAttributeLabel.userInteractionEnabled = YES;
        }

        cell.ohAttributeLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.ohAttributeLabel.numberOfLines = 0;
        cell.ohAttributeLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        // 如果文字超过三行的62高度，只显示三行内容，并且显示查看更多button
        BOOL isShowMore = NO;
        NSUInteger ohAttributeLabelHeight = [[[cellMessageHeightArray objectAtIndex:row] objectForKey:@"height"] integerValue];
        NSUInteger moreFlag = [[[cellMessageHeightArray objectAtIndex:row] objectForKey:@"more"] integerValue];
        
        if (ohAttributeLabelHeight > 62) {
            ohAttributeLabelHeight = 65;
            
            isShowMore = YES;
        }
        
        
        
        
        
        
        
//        BOOL isShowMore = NO;
//        NSUInteger ohAttributeLabelHeight = 0;
//        NSUInteger moreFlag = 0;
//        
//        ohAttributeLabelHeight = [[[cellMessageHeightArr objectAtIndex:row] objectForKey:@"height"] integerValue];
//        moreFlag = [[[cellMessageHeightArr objectAtIndex:row] objectForKey:@"more"] integerValue];
//        
//        if (ohAttributeLabelHeight > 62) {
//            ohAttributeLabelHeight = 62;
//            
//            isShowMore = YES;
//        }
//        
//        cell.ohAttributeLabel.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
//                                                 cell.btn_thumb.frame.origin.y + cell.btn_thumb.frame.size.height + 10,
//                                                 WIDTH-20,
//                                                 ohAttributeLabelHeight);

        
        
        
        
        
        
        
        cell.ohAttributeLabel.userInteractionEnabled = NO;
        cell.ohAttributeLabel.frame = CGRectMake(100,
                                                 likePosY,
                                                 WIDTH-115,
                                                 ohAttributeLabelHeight+5);
        
        if (isShowMore) {
            cell.btn_more.hidden = NO;
            
            if (1 == moreFlag) {
                ohAttributeLabelHeight = [[[cellMessageHeightArray objectAtIndex:row] objectForKey:@"height"] integerValue];
                
                cell.ohAttributeLabel.frame = CGRectMake(100,
                                                         likePosY,
                                                         WIDTH-115,
                                                         ohAttributeLabelHeight+5);
                [cell.btn_more setTitle:@"收起" forState:UIControlStateNormal];
                [cell.btn_more setTitle:@"收起" forState:UIControlStateHighlighted];
            }else {
                ohAttributeLabelHeight = 60;
                
                cell.ohAttributeLabel.frame = CGRectMake(100,
                                                         likePosY,
                                                         WIDTH-115,
                                                         ohAttributeLabelHeight+5);
                
                [cell.btn_more setTitle:@"全文" forState:UIControlStateNormal];
                [cell.btn_more setTitle:@"全文" forState:UIControlStateHighlighted];
            }
            
            cell.btn_more.frame = CGRectMake(cell.ohAttributeLabel.frame.origin.x,
                                             cell.ohAttributeLabel.frame.origin.y + cell.ohAttributeLabel.frame.size.height,
                                             30, 20);
            
            int yPos = cell.btn_more.frame.origin.y + cell.btn_more.frame.size.height;
            likePosY = yPos;
            yOffset = yPos;
            offset.y = yPos;
        }else {
            cell.btn_more.hidden = YES;
            
            int yPos = cell.ohAttributeLabel.frame.origin.y + cell.ohAttributeLabel.frame.size.height;
            likePosY = yPos;
            yOffset = yPos;
            offset.y = yPos;
        }
        
        if ([@""  isEqual: [dic objectForKey:@"message"]]) {
            if (row == 0) {
                offset.y = 60;
            }else {
                offset.y = 10;
            }
        }
        
        // 按照y加上sharedlink
        NSString *shareUrl = [dic objectForKey:@"shareUrl"];
        NSString *shareContent = [dic objectForKey:@"shareContent"];
        NSString *shareSnapshot = [dic objectForKey:@"shareSnapshot"];
        
        if (![@""  isEqual: shareUrl]) {
            cell.sharedLink.frame = CGRectMake(cell.ohAttributeLabel.frame.origin.x, offset.y  + 10, WIDTH-115, 40);
            cell.sharedLink.hidden = NO;
            cell.sharedLink.shareContent = shareContent;
            cell.sharedLink.shareUrl = shareUrl;
            cell.sharedLink.shareSnapshot = shareSnapshot;
            cell.sharedLink.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            
            [cell.sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link"]];
            cell.sharedLink.label_content.text = shareContent;
            cell.sharedLink.label_content.frame = CGRectMake(
                                                             40,
                                                             2,
                                                             200-35,
                                                             36);
            cell.sharedLink.img_default.frame = CGRectMake(0, 0, WIDTH-115, 40);
            
            offset.y = offset.y + 60;
        }else {
            cell.sharedLink.hidden = YES;
        }

        // 图片
        NSArray *pics = [dic objectForKey:@"pics"];
        //        [self showCellMinePics:cell andPics:pics andYPos:likePosY];
        [self showCellPics:cell andPics:pics andPoint:offset];
        
        if ([pics count] > 0) {
            
            cell.videoMarkImgV.image = [UIImage imageNamed:@"videoMark.png"];
            
            NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:0] objectForKey:@"type"]];
            
            if ([type integerValue] == 1) {
                
                cell.videoMarkImgV.frame = CGRectMake(cell.tsTouchImg_img1.frame.origin.x+5.0, cell.tsTouchImg_img1.frame.origin.y+cell.tsTouchImg_img1.frame.size.height-13.0-5.0, 13.0, 13.0);
                
                cell.videoMarkImgV.hidden = NO;
            }else{
                
                cell.videoMarkImgV.hidden = YES;
            }
        }else{
            
            cell.videoMarkImgV.hidden = YES;
        }
        
        cell.btn_comment.hidden = YES;
        cell.btn_commentIcon.hidden = YES;
        cell.btn_like.hidden = YES;
        cell.btn_likeIcon.hidden = YES;

        
        // 下方横线
        cell.imgView_line.frame = CGRectMake(
                                             0,
                                             [[cellHeightArray objectAtIndex:[indexPath row]] integerValue] - 1,
                                             WIDTH,
                                             1);
        
        // 我的动态里面，如果消息被屏蔽了后，不显示赞和评论
        if (true == [[dic objectForKey:@"blocked"] integerValue]) {
            cell.btn_like.hidden = YES;
            cell.btn_likeIcon.hidden = YES;
            cell.btn_comment.hidden = YES;
            cell.btn_commentIcon.hidden = YES;
            cell.sharedLink.hidden = YES;
        }else {
            cell.btn_like.hidden = NO;
            cell.btn_likeIcon.hidden = NO;
            cell.btn_comment.hidden = NO;
            cell.btn_commentIcon.hidden = NO;
//            cell.sharedLink.hidden = NO;
        }
    }else {
            if (_segmentControl.selectedSegmentIndex == 0) {
                if (tableView == _tableView) {
                    [self showTableViewCellContent:NO indexPath:indexPath cell:cell];
                }
            }else {
                if (tableView == _tableViewR) {
                    [self showTableViewCellContent:YES indexPath:indexPath cell:cell];
                }
            }
        }
    
    return cell;
    }
    }
}
- (void)touchUp:(UIButton*)button{
    NSLog(@"sbbbbbb");
    for (int i = 0; i < _advertisingArr.count; i++) {
        if ([[NSString stringWithFormat:@"%ld", [[_advertisingArr[i] objectForKey:@"position"] integerValue] - 1] isEqualToString:[NSString stringWithFormat:@"%ld", button.tag]]) {
            MyInfoWebViewController *vc = [[MyInfoWebViewController alloc] init];
            vc.ifShowNavi = YES;
            vc.ifShowCurrentWebViewTitle = YES;
            //            vc.titleName = [_advertisingArr[i] objectForKey:@"title"];
            vc.url = [_advertisingArr[i] objectForKey:@"url"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
}
- (void)showTableViewCellContent:(BOOL)isRight indexPath:(NSIndexPath *)indexPath cell:(MomentsTableViewCell *)cell {
    NSDictionary *dic;
    NSArray *cellHeightArr;
    NSArray *cellMessageHeightArr;
    unsigned long row = [indexPath row];
    
    if (isRight) {
        dic = [dataArrayR objectAtIndex:row];
        
        cellHeightArr = cellHeightArrayR;
        cellMessageHeightArr = cellMessageHeightArrayR;

    }else {
        dic = [dataArray objectAtIndex:row];
        
        cellHeightArr = cellHeightArray;
        cellMessageHeightArr = cellMessageHeightArray;
    }
    
    cell.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
    
    Utilities *util = [Utilities alloc];
    
    cell.cellUid = [dic objectForKey:@"uid"];
    cell.cellTid = [dic objectForKey:@"id"];
    cell.cellLove = [NSString stringWithFormat:@"%@", [dic objectForKey:@"loved"]];
    
    // 计算名字的真实长度，然后重新设置到tsLabel中去，这样点击时候阴影就是正好的
    CGSize msgSize = [Utilities getStringHeight:[Utilities replaceNull:[dic objectForKey:@"name"]] andFont:[UIFont systemFontOfSize:15]  andSize:CGSizeMake(0, 15)];
    cell.label_username.text = [Utilities replaceNull:[dic objectForKey:@"name"]];
    cell.label_username.uid = [dic objectForKey:@"uid"];
    cell.label_username.touchType = @"touchMomentsNameToProfile";
    CGRect a = cell.label_username.frame;
    a.size = msgSize;
    cell.label_username.frame = a;
    
    //------------- Chenth 2016-4-20
    //    cell.label_dateline.text = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    //    NSString *tempString = [NSString string];
    //    tempString = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    cell.label_dateline.text = [Utilities changeDate:[dic objectForKey:@"dateline"]];
    
    //---------------
    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    // 头像
    NSString *head_url = [dic objectForKey:@"avatar"];
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    // 标签
    NSArray *tagsArr = [dic objectForKey:@"tags"];
    
    if (0 != [tagsArr count]) {
        
        if (true == [[dic objectForKey:@"blocked"] integerValue]){
            cell.tagImageView.hidden = YES;
        }else{
            
            NSDictionary *tagDic = [tagsArr objectAtIndex:0];
            cell.tagImageView.hidden = NO;
            
            [cell.tagImageView sd_setImageWithURL:[NSURL URLWithString:[tagDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
        
        
    }else {
        
        
        cell.tagImageView.hidden = YES;
    }
    
    cell.label_message.text = [dic objectForKey:@"message"];
    
    // 自定义label
    [cell.textParser.images removeAllObjects];
    
    likePosY = 0;
    
    [cell setMLLabelText:[dic objectForKey:@"message"]];
    
    if ([@""  isEqual: [dic objectForKey:@"message"]]) {
        cell.ohAttributeLabel.userInteractionEnabled = NO;
    }else {
        cell.ohAttributeLabel.userInteractionEnabled = YES;
    }
    
    cell.ohAttributeLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.ohAttributeLabel.numberOfLines = 0;
    cell.ohAttributeLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 增加对url链接的点击
    //        cell.ohAttributeLabel.isShowShadow = @"no";
    
    // 如果文字超过三行的62高度，只显示三行内容，并且显示查看更多button
    BOOL isShowMore = NO;
    NSUInteger ohAttributeLabelHeight = 0;
    NSUInteger moreFlag = 0;
    
    ohAttributeLabelHeight = [[[cellMessageHeightArr objectAtIndex:row] objectForKey:@"height"] integerValue];
    moreFlag = [[[cellMessageHeightArr objectAtIndex:row] objectForKey:@"more"] integerValue];
    
    if (ohAttributeLabelHeight > 62) {
        ohAttributeLabelHeight = 62;
        
        isShowMore = YES;
    }
    
    cell.ohAttributeLabel.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                             cell.btn_thumb.frame.origin.y + cell.btn_thumb.frame.size.height + 10,
                                             WIDTH-20,
                                             ohAttributeLabelHeight);
    //     [cell.ohAttributeLabel.layer display];// add by kate bug fix 在此页不调用这句话表情第一次画不出来，只有黑框，聊天页就没有这种情况
    
    if (isShowMore) {
        cell.btn_more.hidden = NO;
        
        if (1 == moreFlag) {
            ohAttributeLabelHeight = [[[cellMessageHeightArr objectAtIndex:row] objectForKey:@"height"] integerValue];
            
            cell.ohAttributeLabel.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                                     cell.btn_thumb.frame.origin.y + cell.btn_thumb.frame.size.height + 10,
                                                     WIDTH-20,
                                                     ohAttributeLabelHeight);
            [cell.btn_more setTitle:@"收起" forState:UIControlStateNormal];
            [cell.btn_more setTitle:@"收起" forState:UIControlStateHighlighted];
        }else {
            ohAttributeLabelHeight = 52;
            
            cell.ohAttributeLabel.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                                     cell.btn_thumb.frame.origin.y + cell.btn_thumb.frame.size.height + 10,
                                                     WIDTH-20,
                                                     ohAttributeLabelHeight);
            
            [cell.btn_more setTitle:@"全文" forState:UIControlStateNormal];
            [cell.btn_more setTitle:@"全文" forState:UIControlStateHighlighted];
        }
        
        cell.btn_more.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                         cell.ohAttributeLabel.frame.origin.y + cell.ohAttributeLabel.frame.size.height +5,
                                         30, 20);
        
        int yPos = cell.btn_more.frame.origin.y + cell.btn_more.frame.size.height;
        likePosY = yPos;
        
        // 按照y加上sharedlink
        NSString *shareUrl = [dic objectForKey:@"shareUrl"];
        NSString *shareContent = [dic objectForKey:@"shareContent"];
        NSString *shareSnapshot = [dic objectForKey:@"shareSnapshot"];
        
        if (![@""  isEqual: shareUrl]) {
            cell.sharedLink.frame = CGRectMake(cell.ohAttributeLabel.frame.origin.x, yPos + 10, WIDTH-70, 40);
            cell.sharedLink.hidden = NO;
            cell.sharedLink.shareContent = shareContent;
            cell.sharedLink.shareUrl = shareUrl;
            cell.sharedLink.shareSnapshot = shareSnapshot;
            cell.sharedLink.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            
            [cell.sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link"]];
            cell.sharedLink.label_content.text = shareContent;
            cell.sharedLink.img_default.frame = CGRectMake(0, 0, WIDTH-70, 40);
            
            likePosY = likePosY + 60;
            yPos = yPos + 60;
        }else {
            cell.sharedLink.hidden = YES;
        }
        
        // 图片
        NSArray *pics = [dic objectForKey:@"pics"];
        [self showCellPics:cell andPics:pics andYPos:yPos];
        
        if ([pics count] > 0) {
            
            NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:0] objectForKey:@"type"]];
            
            if ([type integerValue] == 1) {
                
                cell.videoMarkImgV.frame = CGRectMake(([Utilities convertPixsH:240.0] - 60.0)/2.0+cell.tsTouchImg_img1.frame.origin.x, ([Utilities convertPixsH:180.0]-60.0)/2.0+cell.tsTouchImg_img1.frame.origin.y, 60.0, 60.0);
                
                cell.videoMarkImgV.hidden = NO;
            }else{
                
                cell.videoMarkImgV.hidden = YES;
            }
        }else{
            
            cell.videoMarkImgV.hidden = YES;
        }
        
        
    }else {
        cell.btn_more.hidden = YES;
        
        int yPos = 0;
        
        if ([@"" isEqualToString:[dic objectForKey:@"message"]]) {
            yPos = cell.btn_thumb.frame.origin.y + cell.btn_thumb.frame.size.height + 10;
            likePosY = yPos;
        }else {
            yPos = cell.ohAttributeLabel.frame.origin.y + cell.ohAttributeLabel.frame.size.height;
            likePosY = yPos+10;
        }
        
        // 按照y加上sharedlink
        NSString *shareUrl = [dic objectForKey:@"shareUrl"];
        NSString *shareContent = [dic objectForKey:@"shareContent"];
        NSString *shareSnapshot = [dic objectForKey:@"shareSnapshot"];
        
        if (![@""  isEqual: shareUrl]) {
            cell.sharedLink.frame = CGRectMake(cell.ohAttributeLabel.frame.origin.x, yPos + 10, WIDTH-20, 40);
            cell.sharedLink.hidden = NO;
            cell.sharedLink.shareContent = shareContent;
            cell.sharedLink.shareUrl = shareUrl;
            cell.sharedLink.shareSnapshot = shareSnapshot;
            cell.sharedLink.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            
            [cell.sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link"]];
            cell.sharedLink.label_content.text = shareContent;
            cell.sharedLink.img_default.frame = CGRectMake(0, 0, WIDTH-20, 40);
            
            likePosY = likePosY + 60;
            yPos = yPos + 60;
        }else {
            cell.sharedLink.hidden = YES;
        }
        
        // 图片
        NSArray *pics = [dic objectForKey:@"pics"];
        [self showCellPics:cell andPics:pics andYPos:yPos];
       
        
        if ([pics count] > 0) {
            
            NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:0] objectForKey:@"type"]];
            
            if ([type integerValue] == 1) {
                
                cell.videoMarkImgV.frame = CGRectMake(([Utilities convertPixsH:240.0] - 60.0)/2.0+cell.tsTouchImg_img1.frame.origin.x, ([Utilities convertPixsH:180.0]-60.0)/2.0+cell.tsTouchImg_img1.frame.origin.y, 60.0, 60.0);
                cell.videoMarkImgV.hidden = NO;
            }else{
                
                cell.videoMarkImgV.hidden = YES;
            }
        }else{
            
            cell.videoMarkImgV.hidden = YES;
        }
        
    }
    
    // 赞文字数量
    CGSize likeTextSize;
    NSString *strLike = @"赞";
    
    NSUInteger loved = [[dic objectForKey:@"loved"] integerValue];
    if (loved) {
//        [cell.btn_like setTitle:strLike forState:UIControlStateNormal];
//        [cell.btn_like setTitle:strLike forState:UIControlStateHighlighted];
        [cell.btn_like setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateNormal];
        [cell.btn_like setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        
        cell.btn_like.enabled = YES;
        
        [cell.btn_like setBackgroundImage:[UIImage imageNamed:@"moments/momentsLike_s"] forState:UIControlStateNormal] ;

        
//        [cell.btn_likeIcon setImage:[UIImage imageNamed:@"moments/momentsLike_d"]];
        
        
        likeTextSize = [Utilities getStringHeight:strLike andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    }else {
//        [cell.btn_like setTitle:strLike forState:UIControlStateNormal];
//        [cell.btn_like setTitle:strLike forState:UIControlStateHighlighted];
        [cell.btn_like setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.btn_like setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [cell.btn_like setBackgroundImage:[UIImage imageNamed:@"moments/momentsLike_d"] forState:UIControlStateNormal] ;

        cell.btn_like.enabled = YES;
//        [cell.btn_likeIcon setImage:[UIImage imageNamed:@"moments/momentsLike_s"]];
        
        likeTextSize = [Utilities getStringHeight:strLike andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    }
    
    // 评论文字数量
    CGSize commentTextSize;
    //        NSString *str = [NSString stringWithFormat:@"评论%@",[[dic objectForKey:@"comments"] objectForKey:@"count"]];
    NSString *str = @"评论";
    
//    [cell.btn_comment setTitle:str forState:UIControlStateNormal];
//    [cell.btn_comment setTitle:str forState:UIControlStateHighlighted];
    
    [cell.btn_comment setBackgroundImage:[UIImage imageNamed:@"moments/momentsComment_d"] forState:UIControlStateNormal] ;

    commentTextSize = [Utilities getStringHeight:str andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    
    // 按照评论数和赞的数量的长度来进行从右至左描画
    cell.btn_comment.frame = CGRectMake(WIDTH-commentTextSize.width - 35,
                                        likePosY,
                                        50,
                                        24);
//    cell.btn_commentIcon.frame = CGRectMake(cell.btn_comment.frame.origin.x - 16,
//                                            likePosY+3,
//                                            15, 15);
    
    cell.btn_like.frame = CGRectMake(cell.btn_comment.frame.origin.x - 10 - cell.btn_comment.frame.size.width,
                                     likePosY,
                                     50,
                                     24);
//    cell.btn_likeIcon.frame = CGRectMake(cell.btn_like.frame.origin.x - 15,
//                                         likePosY+3,
//                                         15, 15);
//    
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    
    // 判断是否是学生或者家长，如果是需要显示添加到我的足迹
    if (([@"0"  isEqual: usertype]) || ([@"6"  isEqual: usertype])) {
        if ([@"1"  isEqual: [NSString stringWithFormat:@"%@",[_growingPathStatusDic objectForKey:@"classes"]]]) {
            // 先要判断该学校是否开通了成长空间，如没开通，则不显示
            if ([@"1"  isEqual: _growingPathStatusSchool]) {
                // 学校开通了成长空间
                NSDictionary *pathDic = [dic objectForKey:@"growpath"];
                
                if (1 ==[[pathDic objectForKey:@"save"] intValue]) {
                    // 已经添加到我的足迹
                    [cell.btn_addToPath setBackgroundImage:[UIImage imageNamed:@"moments/momentsAddToPath_s"] forState:UIControlStateNormal] ;
                    
                    //                [cell.btn_pathIcon setImage:[UIImage imageNamed:@"moments/moments_addToPathAdded.png"]];
                    //
                    //                [cell.btn_addToPath setTitle:@"已添加" forState:UIControlStateNormal];
                    //                [cell.btn_addToPath setTitle:@"已添加" forState:UIControlStateHighlighted];
                    //
                    //                [cell.btn_addToPath setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateNormal];
                    //                [cell.btn_addToPath setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateHighlighted];
                    
                    cell.btn_addToPath.userInteractionEnabled = NO;
                }else {
                    // 未被添加
                    
                    [cell.btn_addToPath setBackgroundImage:[UIImage imageNamed:@"moments/momentsAddToPath_d"] forState:UIControlStateNormal] ;
                    
                    //                [cell.btn_pathIcon setImage:[UIImage imageNamed:@"moments/moments_addToPath.png"]];
                    //
                    //                [cell.btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateNormal];
                    //                [cell.btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateHighlighted];
                    //
                    //                [cell.btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    //                [cell.btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                    
                    cell.btn_addToPath.userInteractionEnabled = YES;
                }
                
                cell.btn_pathIcon.hidden = NO;
                cell.btn_addToPath.hidden = NO;
                
                cell.btn_pathIcon.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                                     likePosY+3,
                                                     15, 15);
                
                cell.btn_addToPath.frame = CGRectMake(cell.btn_thumb.frame.origin.x, likePosY, 50, 24);
            }else {
                // 学校没有开通成长空间
                cell.btn_pathIcon.hidden = YES;
                cell.btn_addToPath.hidden = YES;
            }
        }else {
            cell.btn_pathIcon.hidden = YES;
            cell.btn_addToPath.hidden = YES;
        }
    }
    
    int bgGrayYstart = 0;
    cell.bgGrayView.backgroundColor = [[UIColor alloc] initWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0];

    int lovesHeight = 0;
    // 喜欢的人背景框和上面的头像
    if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
        // 喜欢的人
        cell.lovesStrLabel.hidden = NO;
        
        NSString *lovesStr = @"";
        for (int i=0; i<[(NSArray *)[dic objectForKey:@"loves"] count]; i++) {
            NSDictionary *dicLoves = [[dic objectForKey:@"loves"] objectAtIndex:i];

            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
        }
        
        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
        
        likePosY = likePosY + 30;
        bgGrayYstart = likePosY;
        
        cell.lovesStrLabel.text = [NSString stringWithFormat:@"     %@", lovesStr];
        
        CGSize a = [cell.lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
        lovesHeight = a.height;

        cell.lovesStrLabel.frame =  CGRectMake(
                                               cell.btn_thumb.frame.origin.x+4,
                                               likePosY+2.5,
                                               WIDTH - cell.btn_thumb.frame.origin.x - 15,
                                               a.height);
        
        cell.lovesStrImageView.hidden = NO;
        cell.lovesStrImageView.frame =  CGRectMake(
                                               cell.btn_thumb.frame.origin.x+5,
                                               likePosY+4,
                                               13,
                                               13);
        
        likePosY = likePosY + lovesHeight;
    }else {
        cell.lovesStrLabel.hidden = YES;

        likePosY = likePosY + 30;
        bgGrayYstart = likePosY;

        cell.imgView_likeBg.hidden = YES;
        cell.btn_likeNum.hidden = YES;
        cell.lovesStrImageView.hidden = YES;

        cell.imgView_headImg1.hidden = YES;
        cell.imgView_headImg2.hidden = YES;
        cell.imgView_headImg3.hidden = YES;
        cell.imgView_headImg4.hidden = YES;
        cell.imgView_headImg5.hidden = YES;
        
        cell.label_likeCount.hidden = YES;
    }
    
    // 评论的人列表
    NSDictionary *commentsDic = [dic objectForKey:@"comments"];
    NSArray *commentsList = [commentsDic objectForKey:@"list"];
    
    
    cell.ohAttLabel_comment1.hidden = YES;
    cell.ohAttLabel_comment2.hidden = YES;
    cell.ohAttLabel_comment3.hidden = YES;
    cell.imgView_commentLine1.hidden = YES;
    cell.imgView_commentLine2.hidden = YES;
    
    // 这里的评论都用tableview代替显示
    
    int commentHeight = 0;
    NSArray *commentsArr = [[dic objectForKey:@"comments"] objectForKey:@"list"];
    for (id obj in commentsArr) {
        NSDictionary *dic = (NSDictionary *)obj;
        
        CGSize size = [self getCommentAttrHeight:dic];
        int height = size.height;
        
        commentHeight = commentHeight + height;
    }
    
    
    NSMutableArray *commentHeightArraaa = [[cellMessageHeightArr objectAtIndex:indexPath.row] objectForKey:@"commentHeightArr"];
    
    long long int h = 0;
    for (int i=0; i<[commentHeightArraaa count]; i++) {
        h = h + [[commentHeightArraaa objectAtIndex:i] longLongValue];
    }
    if (0 != h) {
        h = h;
    }
    
    
    if (0 == commentHeight) {
        cell.tableView.hidden = YES;
    }else {
        cell.tableView.hidden = NO;
        if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
            // 由于tableview显示的cell内容前带一小段空格，这里减去16像素的位置，与正文等对齐
            cell.tableView.frame = CGRectMake(cell.btn_thumb.frame.origin.x-16,
                                              likePosY,
                                              310,
                                              h +10);
            
        }else {
            // 由于tableview显示的cell内容前带一小段空格，这里减去16像素的位置，与正文等对齐
            cell.tableView.frame = CGRectMake(cell.btn_thumb.frame.origin.x-16,
                                              likePosY-7,
                                              310,
                                              h +10);

        }
        
    }
    
    if ((0 == commentHeight) && (0 == lovesHeight)) {
        cell.bgGrayView.hidden = YES;
    }else {
        cell.bgGrayView.hidden = NO;
    }
    
    if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
        if (0 == commentHeight) {
            cell.bgGrayView.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                               bgGrayYstart,
                                               300,
                                               h + lovesHeight+4);
        }else {
            cell.bgGrayView.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                               bgGrayYstart,
                                               300,
                                               h + lovesHeight+12);
        }
    }else {
        cell.bgGrayView.frame = CGRectMake(cell.btn_thumb.frame.origin.x,
                                           bgGrayYstart,
                                           300,
                                           h + lovesHeight+4);
    }

    if ((0 != commentHeight) && (0 != lovesHeight)) {
        cell.imgView_loves.hidden = NO;
        cell.imgView_loves.frame = CGRectMake(
                                              cell.bgGrayView.frame.origin.x,
                                              likePosY + 6,
                                              cell.bgGrayView.frame.size.width,
                                              1);
    }else {
        cell.imgView_loves.hidden = YES;
    }

    
    
    
    cell.arrInCell = [[dic objectForKey:@"comments"] objectForKey:@"list"];
    
    NSMutableArray *commentHeightArr;
    
    commentHeightArr = [[cellMessageHeightArr objectAtIndex:indexPath.row] objectForKey:@"commentHeightArr"];
    
    cell.arrInCellHeight = commentHeightArr;
    
    [cell test];
    
    
    // 查看详情
    cell.btn_detail.frame = CGRectMake(
                                       [UIScreen mainScreen].applicationFrame.size.width - 80,
                                       [[cellHeightArr objectAtIndex:[indexPath row]] integerValue] - 24,
                                       60,
                                       20);
    
    // 查看详情img
    cell.imgView_detail.frame = CGRectMake(
                                           cell.btn_detail.frame.origin.x - 23,
                                           cell.btn_detail.frame.origin.y + 3,
                                           20,
                                           14);
    
    // 下方横线
    cell.imgView_line.frame = CGRectMake(
                                         0,
                                         [[cellHeightArr objectAtIndex:[indexPath row]] integerValue] - 1,
                                         WIDTH,
                                         1);
    
    
    // 这里通过判断该动态的状态，来确定某些btn是否显示，以及显示内容。
    cell.tsLabel_delete.tid = [dic objectForKey:@"id"];
    cell.tsLabel_delete.cellNum = [NSString stringWithFormat:@"%lu", (unsigned long)row];
    
    // 只有自己的动态才显示删除
    // 校园管理员在这里可以屏蔽所有人的动态
    if (true == [[dic objectForKey:@"blocked"] integerValue]) {
        // 如果是已经被屏蔽的内容，不显示btn
        cell.btn_detail.hidden = YES;
        cell.imgView_detail.hidden = YES;
        
        cell.btn_like.hidden = YES;
        cell.btn_likeIcon.hidden = YES;
        cell.btn_comment.hidden = YES;
        cell.btn_commentIcon.hidden = YES;
        cell.btn_addToPath.hidden = YES;
        cell.btn_pathIcon.hidden = YES;
        
        cell.sharedLink.hidden = YES;
        
        cell.lovesStrLabel.hidden = YES;
        
        likePosY = likePosY + 30;
        bgGrayYstart = likePosY;
        
        cell.btn_likeNum.hidden = YES;
        cell.lovesStrImageView.hidden = YES;
        cell.bgGrayView.hidden = YES;

        cell.imgView_likeBg.hidden = YES;
        cell.imgView_headImg1.hidden = YES;
        cell.imgView_headImg2.hidden = YES;
        cell.imgView_headImg3.hidden = YES;
        cell.imgView_headImg4.hidden = YES;
        cell.imgView_headImg5.hidden = YES;
        cell.label_likeCount.hidden = YES;
        cell.videoMarkImgV.hidden = YES;
        
        if ([[dic objectForKey:@"uid"] isEqual:uid] ) {
            cell.tsLabel_delete.hidden = NO;
            cell.tsLabel_delete.text = @"删除";
            cell.tsLabel_delete.touchType = @"touchMomentsListDelete";
        }else {
            cell.tsLabel_delete.hidden = YES;
        }
        
        for (id obj in cell.ary_imgThumb) {
            TSTouchImageView *img = (TSTouchImageView *)obj;
            img.hidden = YES;
        }
        
        
        //            cell.btn_more.hidden = YES;
        //            cell..hidden = YES;
        
    }else {
        cell.btn_detail.hidden = NO;
        cell.imgView_detail.hidden = NO;
        
        cell.btn_like.hidden = NO;
        cell.btn_likeIcon.hidden = YES;
        cell.btn_comment.hidden = NO;
        cell.btn_commentIcon.hidden = YES;
        cell.btn_addToPath.hidden = NO;
        cell.btn_pathIcon.hidden = YES;
//        cell.videoMarkImgV.hidden = NO;

        if ([usertype intValue] == 9) {
            if ([[dic objectForKey:@"uid"] isEqual:uid] ) {
                cell.tsLabel_delete.hidden = NO;
                cell.tsLabel_delete.text = @"删除";
                cell.tsLabel_delete.touchType = @"touchMomentsListDelete";
            }else {
                cell.tsLabel_delete.hidden = NO;
                cell.tsLabel_delete.text = @"屏蔽";
                cell.tsLabel_delete.touchType = @"touchMomentsListBlock";
            }
        }else{
            if ([[dic objectForKey:@"uid"] isEqual:uid] ) {
                cell.tsLabel_delete.hidden = NO;
                cell.tsLabel_delete.text = @"删除";
                cell.tsLabel_delete.touchType = @"touchMomentsListDelete";
            }else {
                cell.tsLabel_delete.hidden = YES;
            }
        }
    }
    
    cell.btn_detail.hidden = YES;
    cell.imgView_detail.hidden = YES;
    
    cell.imgView_leftLine.hidden = YES;
    cell.imgView_leftlittilPoint.hidden = YES;
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(([touch.view isMemberOfClass:[TSTouchLabel class]]) ||
       ([touch.view isMemberOfClass:[TSAttributedLabel class]]) ||
       ([touch.view isMemberOfClass:[UIButton class]]) ||
       ([touch.view isMemberOfClass:[UITableViewCell class]]) ||
       (([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])))  {
        
        if (downListButton.isSelected) {
            //            return YES;
            return NO;
            
        }else {
            //            return NO;
            
            if(([touch.view isMemberOfClass:[TSTouchLabel class]]) ||
               ([touch.view isMemberOfClass:[TSAttributedLabel class]]) ||
               ([touch.view isMemberOfClass:[UIButton class]]) ||
               ([touch.view isMemberOfClass:[UITableViewCell class]])) {
                if ([touch.view isMemberOfClass:[advertisingTableViewCell class]]) {
                    return YES;
                }else{
                    return NO;
                }
            }else {
                return YES;
            }
            
        }
        
        //        if (([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])) {
        //            return YES;
        //        }else {
        //        }
        //
        //        sadfsadfasdf
        
        //放过以上事件的点击拦截
        
        //        return NO;
    }else{
        
        //        UIView* v=[touch.view superview];
        
        // 特殊放过tableViewCell的点击事件
        //        if([v isMemberOfClass:[Test1TableViewCell class]]) {
        //            return NO;
        //        }
        
        return YES;
    }
}


//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tb]) {
        [self downListButton:downListButton];
        [tb removeFromSuperview];
        NSLog(@"fukkkkkkkkkkkk");
        
        NSDictionary *classDic = [dicArr objectAtIndex:indexPath.row];
        //        NSString *cid = [classDic objectForKey:@"cid"];
        //        [self dataHandler];
        [self reloadMomentsContent:classDic];
        [self buildTitleView];
    }
    else{
        if ([numberArr containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else{
            if(([@"mine"  isEqual: _fromName]) || ([@"other"  isEqual: _fromName])) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
                
                MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
                momentsDetailViewCtrl.tid = [[dataArray objectAtIndex:[indexPath row]] objectForKey:@"id"];
                [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
            }
        }
    }
}

// 图片走这个
-(void)showCellPics:(MomentsTableViewCell *)cell andPics:(NSArray *)pics andYPos:(int)pos
{
    NSUInteger picCount = [pics count];
    
    int picWidth = ([Utilities getScreenSizeWithoutBar].width-40)/3;
    
    
    //---add by kate-----------------------------------------------------------------------------------
    if (picCount == 1) {
        
        NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:0] objectForKey:@"type"]];
        
        if ([type integerValue] == 1) {
            
            picWidth = [Utilities convertPixsH:180.0];//小视频高度
            
            }
        
    }
    //--------------------------------------------------------------------------------------------------
    
    // 按照cell中图片的个数算出图片的位置
    for (int i=0; i<picCount; i++) {
        if (i<3) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:i] objectForKey:@"type"]];
            
            if ([type integerValue] == 1) {//小视频
            
                [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(cell.ohAttributeLabel.frame.origin.x +(5+picWidth)*i,
                                                                         pos+5,
                                                                         [Utilities convertPixsH:240.0], picWidth)];
              
                
            }else{
                
                
                [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(cell.ohAttributeLabel.frame.origin.x +(5+picWidth)*i,
                                                                         pos+5,
                                                                         picWidth, picWidth)];
                
                
            }
          
            //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
        }else if ((i>=3) && (i<6)) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(cell.ohAttributeLabel.frame.origin.x +(5+picWidth)*(i-3),
                                                                     pos +10 + picWidth,
                                                                     picWidth, picWidth)];
            //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            
        }else if ((i>=6) && (i<9)) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(cell.ohAttributeLabel.frame.origin.x +(5+picWidth)*(i-6),
                                                                     pos +15 + picWidth + picWidth,
                                                                     picWidth,
                                                                     picWidth)];
            //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
        }
        
        [[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    }
    
    // 按照图片的个数计算高度偏移量
    if ((picCount<=3) && (picCount != 0)) {
        likePosY = likePosY + picWidth+15;
    }else if ((picCount>3) && (picCount<=6)) {
        likePosY = likePosY + (picWidth*2 + 20);
    }else if ((picCount>6) && (picCount<=9)) {
        likePosY = likePosY + (picWidth*3 + 10) + 20;
    }
    
    // 把最大个数图片以后的图片设置为hidden
    for (NSUInteger i=[pics count]; i<9; i++) {
        ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = YES;
    }
}

-(void)showCellPics:(MomentsTableViewCell *)cell andPics:(NSArray *)pics andPoint:(CGPoint)pos
{
    int picWidth = 60;
    NSUInteger picCount = [pics count];

    
    // 按照cell中图片的个数算出图片的位置
    for (int i=0; i<picCount; i++) {
        if (i<3) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
                [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(pos.x +(5+picWidth)*i,
                                                                         pos.y+5,
                                                                         picWidth, picWidth)];
        
                //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            
        }else if ((i>=3) && (i<6)) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(pos.x +(5+picWidth)*(i-3),
                                                                     pos.y +5 + picWidth + 5,
                                                                     picWidth, picWidth)];
            //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }else if ((i>=6) && (i<9)) {
            ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [[cell.ary_imgThumb objectAtIndex:i] setFrame:CGRectMake(pos.x +(5+picWidth)*(i-6),
                                                                     pos.y +5 + picWidth + picWidth + 10,
                                                                     picWidth,
                                                                     picWidth)];
            //[[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
        
        [[cell.ary_imgThumb objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    }
    
    // 按照图片的个数计算高度偏移量
    //Chenth 将下面六个80的70改为80
    if ((picCount<=3) && (picCount != 0)) {
        likePosY = likePosY + 80;
        offset.y = offset.y + 80;
    }else if ((picCount>3) && (picCount<=6)) {
        likePosY = likePosY + 80*2;
        offset.y = offset.y + 80*2;

    }else if ((picCount>6) && (picCount<=9)) {
        likePosY = likePosY + 80*3;
        offset.y = offset.y + 80*3;

    }
    
    // 把最大个数图片以后的图片设置为hidden
    for (NSUInteger i=[pics count]; i<9; i++) {
        ((MomentsTableViewCell *)[cell.ary_imgThumb objectAtIndex:i]).hidden = YES;
    }
}

-(void)doShowClassroomHeaderViewMine
{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH,
                                                         210)];
    
    // 背景图片
    _tsTouchImg_momentsBg =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_momentsBg.frame = CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,180);
    _tsTouchImg_momentsBg.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_momentsBg.clipsToBounds = YES;
    _tsTouchImg_momentsBg.isShowBgImg = NO;
    
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBgImgAction:)];
    [_tsTouchImg_momentsBg addGestureRecognizer:myTapGesture];
    
    [_tsTouchImg_momentsBg sd_setImageWithURL:[headerDic objectForKey:@"background"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    _tsTouchImg_momentsBg.userInteractionEnabled = YES;
    [headerView addSubview:_tsTouchImg_momentsBg];
    
    // 头像背景
    imgView_headBg =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                 [UIScreen mainScreen].applicationFrame.size.width -70 -20-2,
                                                                 _tsTouchImg_momentsBg.frame.size.height -50-2,
                                                                 70+4,
                                                                 70+4)];
    
#if 0
    if (![@"class"  isEqual: _fromName]) {
        // 只有班级动态时头像是方的
        // 其他动态是圆的。。。
        imgView_headBg.layer.masksToBounds = YES;
        imgView_headBg.layer.cornerRadius = imgView_headBg.frame.size.width/2;
    }
#endif
    
    imgView_headBg.contentMode = UIViewContentModeScaleToFill;
    imgView_headBg.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:imgView_headBg];
    
    // 头像图片
    btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_thumb.frame = CGRectMake(
                                 imgView_headBg.frame.origin.x + 2,
                                 imgView_headBg.frame.origin.y + 2,
                                 70,
                                 70);
    [btn_thumb addTarget:self action:@selector(touchHeadImgAction) forControlEvents:UIControlEventTouchUpInside];
    btn_thumb.contentMode = UIViewContentModeScaleToFill;
    
    defaultImg = [UIImage imageNamed:@"loading_gray.png"];
    if ([@"class"  isEqual: _fromName]) {
        // 班级动态时候默认头像是知校
        defaultImg = [UIImage imageNamed:@"icon_class_avatar_defalt.png"];
    }else {
        //        btn_thumb.layer.masksToBounds = YES;
        //        btn_thumb.layer.cornerRadius = btn_thumb.frame.size.width/2;
    }
    
    [btn_thumb sd_setBackgroundImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:defaultImg];
    [btn_thumb sd_setBackgroundImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:defaultImg];
    [headerView addSubview:btn_thumb];
    
    // 姓名
    label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           0,
                                                           btn_thumb.frame.origin.y +25,
                                                           [UIScreen mainScreen].applicationFrame.size.width -70-25-10,
                                                           20)];
    label_name.textColor = [UIColor whiteColor];
    label_name.backgroundColor = [UIColor clearColor];
    label_name.font = [UIFont boldSystemFontOfSize:16.0f];
    label_name.text = [Utilities replaceNull:[headerDic objectForKey:@"name"]];
    label_name.textAlignment = NSTextAlignmentRight;
    [label_name setShadowColor:[UIColor blackColor]];
    [label_name setShadowOffset:CGSizeMake(1, 1)];
    [headerView addSubview:label_name];
    
    if ([@"mine"  isEqual: _fromName]) {
        if (0 != [[headerDic objectForKey:@"messageCount"] integerValue]) {
            //----add by kate------------------------------------------
            //我的动态右上角加红点
            [self.navigationController.navigationBar addSubview:myNoticeImgVForMsg];
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.tabBarController.selectedIndex != 3) {
                
                [myNoticeImgVForMsg removeFromSuperview];
                
            }
            //---------------------------------------------------------
        }
        
        headerView.frame = CGRectMake(0, 0, WIDTH, 260);
        
        btn_submitMoments = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_submitMoments.frame = CGRectMake(
                                             90,
                                             200,
                                             130,
                                             40);
        [btn_submitMoments addTarget:self action:@selector(clickSubmitMoments:) forControlEvents: UIControlEventTouchUpInside];
        //        [btn_submitMoments setImage:[UIImage imageNamed:@"moments/fx.png"] forState:UIControlStateNormal];
        //        [btn_submitMoments setImage:[UIImage imageNamed:@"moments/fx.png"] forState:UIControlStateHighlighted];
        
        btn_submitMoments.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn_submitMoments.contentEdgeInsets = UIEdgeInsetsMake(0,30, 0, 0);
        [btn_submitMoments setTitleColor:[[UIColor alloc] initWithRed:165/255.0f green:213/255.0f blue:85/255.0f alpha:1.0] forState:UIControlStateNormal];
        [btn_submitMoments setTitleColor:[[UIColor alloc] initWithRed:165/255.0f green:213/255.0f blue:85/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        btn_submitMoments.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [btn_submitMoments setTitle:@"分享新鲜事" forState:UIControlStateNormal];
        [btn_submitMoments setTitle:@"分享新鲜事" forState:UIControlStateHighlighted];
        
        [headerView addSubview:btn_submitMoments];
        
        
        _imgView_submitMoments =[[UIImageView alloc]initWithFrame:CGRectMake(90, 200, 40, 40)];
        _imgView_submitMoments.image=[UIImage imageNamed:@"moments/fx.png"];
        [headerView addSubview:_imgView_submitMoments];
        
        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(10, 259, 300, 1)];
        _imgView_line.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [headerView addSubview:_imgView_line];
    }else if ([@"other"  isEqual: _fromName]) {
        headerView.frame = CGRectMake(0, 0, WIDTH, 210);
        
        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(10, 209, 300, 1)];
        _imgView_line.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [headerView addSubview:_imgView_line];
    }else {
        if (0 != [[headerDic objectForKey:@"messageCount"] integerValue]) {
           
            // 新消息提示btn
            //[self checkSelfMomentsNew1];//2016.01.27
            
            _btn_msg.hidden = NO;
            _img_msg.hidden = NO;
            
            _btn_msg.frame = CGRectMake(
                                        ([UIScreen mainScreen].applicationFrame.size.width - 140)/2,
                                        200 + 10,
                                        130,
                                        25);
            [_btn_msg addTarget:self action:@selector(touchMsgAction) forControlEvents:UIControlEventTouchUpInside];
            _btn_msg.contentMode = UIViewContentModeScaleToFill;
            
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateNormal];
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateHighlighted];
            
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateNormal];
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateHighlighted];
            
            _btn_msg.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            _btn_msg.contentEdgeInsets = UIEdgeInsetsMake(0,40, 0, 0);
            
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            [headerView addSubview:_btn_msg];
            
            _img_msg.frame = CGRectMake(20, 2.5, 20, 20);
            _img_msg.contentMode = UIViewContentModeScaleToFill;
            _img_msg.layer.masksToBounds = YES;
            _img_msg.layer.cornerRadius = 20/2;
            
            [_img_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"messageAvatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            [_btn_msg addSubview:_img_msg];
            
            headerView.frame = CGRectMake(0, 0, WIDTH, 250);
        }else {
            _btn_msg.hidden = YES;
            _img_msg.hidden = YES;
            
            // 因为某些未知原因，有时候红点没有remove，这里先remove两次，之后需要查查原因。
            [noticeImgVForMsg removeFromSuperview];
            [noticeImgVForMsg removeFromSuperview];
            newIconImg.hidden = YES;//add by kate 2015.02.03
        }
    }
    
    _tableView.tableHeaderView = headerView;
}

-(void)doShowClassroomHeaderView
{
    //if ((![@"0"  isEqual: _userType]) && (![@"6"  isEqual: _userType])) {
        // 不是家长也不是学生身份才显示未读消息数
        if (0 != [[headerDic objectForKey:@"messageCount"] integerValue]) {
            headerView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 WIDTH,
                                                                 210)];
#if 0
            if ([@"school" isEqualToString:_fromName]) {
                //2.9.4 不是家长也不是学生发现中有师生圈
                if ((![@"0"  isEqual: _userType]) && (![@"6"  isEqual: _userType])){
                    // 新消息提示btn 红点
                    [self checkSelfMomentsNew1];
                }
            }
#endif
            _btn_msg.hidden = NO;
            _img_msg.hidden = NO;
            
            _btn_msg.frame = CGRectMake(
                                        ([UIScreen mainScreen].applicationFrame.size.width - 140)/2,
                                        10,
                                        130,
                                        25);
            [_btn_msg addTarget:self action:@selector(touchMsgAction) forControlEvents:UIControlEventTouchUpInside];
            _btn_msg.contentMode = UIViewContentModeScaleToFill;
            
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateNormal];
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateHighlighted];
            
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateNormal];
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateHighlighted];
            
            _btn_msg.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            _btn_msg.contentEdgeInsets = UIEdgeInsetsMake(0,40, 0, 0);
            
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            [headerView addSubview:_btn_msg];
            
            _img_msg.frame = CGRectMake(20, 2.5, 20, 20);
            _img_msg.contentMode = UIViewContentModeScaleToFill;
            _img_msg.layer.masksToBounds = YES;
            _img_msg.layer.cornerRadius = 20/2;
            
            [_img_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"messageAvatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            [_btn_msg addSubview:_img_msg];
            
            headerView.frame = CGRectMake(0, 0, WIDTH, 50);
            _tableView.tableHeaderView = headerView;

        }else {
            _btn_msg.hidden = YES;
            _img_msg.hidden = YES;
            
            // 因为某些未知原因，有时候红点没有remove，这里先remove两次，之后需要查查原因。
            [noticeImgVForMsg removeFromSuperview];
            [noticeImgVForMsg removeFromSuperview];
            newIconImg.hidden = YES;//add by kate 2015.02.03
            
            _tableView.tableHeaderView = nil;

        }
    //}
}

-(void)doShowClassroomHeaderViewR
{
    headerViewR = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH,
                                                         210)];
    
    // 背景图片
    _tsTouchImg_momentsBgR =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_momentsBgR.frame = CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,180);
    _tsTouchImg_momentsBgR.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_momentsBgR.clipsToBounds = YES;
    _tsTouchImg_momentsBgR.isShowBgImg = NO;
    
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBgImgAction:)];
    [_tsTouchImg_momentsBgR addGestureRecognizer:myTapGesture];
    
    [_tsTouchImg_momentsBgR sd_setImageWithURL:[headerDic objectForKey:@"background"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    _tsTouchImg_momentsBgR.userInteractionEnabled = YES;
    [headerViewR addSubview:_tsTouchImg_momentsBgR];
    
    // 头像背景
    imgView_headBgR =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                 [UIScreen mainScreen].applicationFrame.size.width -70 -20-2,
                                                                 _tsTouchImg_momentsBg.frame.size.height -50-2,
                                                                 70+4,
                                                                 70+4)];
    
#if 0
    if (![@"class"  isEqual: _fromName]) {
        // 只有班级动态时头像是方的
        // 其他动态是圆的。。。
        imgView_headBg.layer.masksToBounds = YES;
        imgView_headBg.layer.cornerRadius = imgView_headBg.frame.size.width/2;
    }
#endif
    
    imgView_headBgR.contentMode = UIViewContentModeScaleToFill;
    imgView_headBgR.backgroundColor = [UIColor whiteColor];
    [headerViewR addSubview:imgView_headBgR];
    
    // 头像图片
    btn_thumbR = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_thumbR.frame = CGRectMake(
                                 imgView_headBgR.frame.origin.x + 2,
                                 imgView_headBgR.frame.origin.y + 2,
                                 70,
                                 70);
    [btn_thumbR addTarget:self action:@selector(touchHeadImgAction) forControlEvents:UIControlEventTouchUpInside];
    btn_thumbR.contentMode = UIViewContentModeScaleToFill;
    
    defaultImgR = [UIImage imageNamed:@"loading_gray.png"];
    if ([@"class"  isEqual: _fromName]) {
        // 班级动态时候默认头像是知校
        defaultImgR = [UIImage imageNamed:@"icon_class_avatar_defalt.png"];
    }else {
        //        btn_thumb.layer.masksToBounds = YES;
        //        btn_thumb.layer.cornerRadius = btn_thumb.frame.size.width/2;
    }
    
    [btn_thumbR sd_setBackgroundImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:defaultImgR];
    [btn_thumbR sd_setBackgroundImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:defaultImgR];
    [headerViewR addSubview:btn_thumbR];
    
    // 姓名
    label_nameR = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           0,
                                                           btn_thumb.frame.origin.y +25,
                                                           [UIScreen mainScreen].applicationFrame.size.width -70-25-10,
                                                           20)];
    label_nameR.textColor = [UIColor whiteColor];
    label_nameR.backgroundColor = [UIColor clearColor];
    label_nameR.font = [UIFont boldSystemFontOfSize:16.0f];
    label_nameR.text = [Utilities replaceNull:[headerDic objectForKey:@"name"]];
    label_nameR.textAlignment = NSTextAlignmentRight;
    [label_nameR setShadowColor:[UIColor blackColor]];
    [label_nameR setShadowOffset:CGSizeMake(1, 1)];
    [headerViewR addSubview:label_nameR];
    
    if ([@"mine"  isEqual: _fromName]) {
        if (0 != [[headerDic objectForKey:@"messageCount"] integerValue]) {
            //----add by kate------------------------------------------
            //我的动态右上角加红点
            [self.navigationController.navigationBar addSubview:myNoticeImgVForMsg];
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.tabBarController.selectedIndex != 3) {
                
                [myNoticeImgVForMsg removeFromSuperview];
                
            }
            //---------------------------------------------------------
        }
        
        headerViewR.frame = CGRectMake(0, 0, WIDTH, 260);
        
        btn_submitMomentsR = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_submitMomentsR.frame = CGRectMake(
                                             90,
                                             200,
                                             130,
                                             40);
        [btn_submitMomentsR addTarget:self action:@selector(clickSubmitMoments:) forControlEvents: UIControlEventTouchUpInside];
        //        [btn_submitMoments setImage:[UIImage imageNamed:@"moments/fx.png"] forState:UIControlStateNormal];
        //        [btn_submitMoments setImage:[UIImage imageNamed:@"moments/fx.png"] forState:UIControlStateHighlighted];
        
        btn_submitMomentsR.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn_submitMomentsR.contentEdgeInsets = UIEdgeInsetsMake(0,30, 0, 0);
        [btn_submitMomentsR setTitleColor:[[UIColor alloc] initWithRed:165/255.0f green:213/255.0f blue:85/255.0f alpha:1.0] forState:UIControlStateNormal];
        [btn_submitMomentsR setTitleColor:[[UIColor alloc] initWithRed:165/255.0f green:213/255.0f blue:85/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        btn_submitMomentsR.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [btn_submitMomentsR setTitle:@"分享新鲜事" forState:UIControlStateNormal];
        [btn_submitMomentsR setTitle:@"分享新鲜事" forState:UIControlStateHighlighted];
        
        [headerViewR addSubview:btn_submitMomentsR];
        
        
        _imgView_submitMomentsR =[[UIImageView alloc]initWithFrame:CGRectMake(90, 200, 40, 40)];
        _imgView_submitMomentsR.image=[UIImage imageNamed:@"moments/fx.png"];
        [headerViewR addSubview:_imgView_submitMomentsR];
        
        _imgView_lineR =[[UIImageView alloc]initWithFrame:CGRectMake(10, 259, 300, 1)];
        _imgView_lineR.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [headerViewR addSubview:_imgView_lineR];
    }else if ([@"other"  isEqual: _fromName]) {
        headerViewR.frame = CGRectMake(0, 0, WIDTH, 210);
        
        _imgView_lineR =[[UIImageView alloc]initWithFrame:CGRectMake(10, 209, 300, 1)];
        _imgView_lineR.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [headerViewR addSubview:_imgView_lineR];
    }else {
        if (0 != [[headerDic objectForKey:@"messageCount"] integerValue]) {
            // 新消息提示btn
            [self checkSelfMomentsNew1];
            
            _btn_msg.hidden = NO;
            _img_msg.hidden = NO;
            
            _btn_msg.frame = CGRectMake(
                                        ([UIScreen mainScreen].applicationFrame.size.width - 140)/2,
                                        200 + 10,
                                        130,
                                        25);
            [_btn_msg addTarget:self action:@selector(touchMsgAction) forControlEvents:UIControlEventTouchUpInside];
            _btn_msg.contentMode = UIViewContentModeScaleToFill;
            
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateNormal];
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"moments/bg_gray.png"] forState:UIControlStateHighlighted];
            
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateNormal];
            [_btn_msg setTitle:[NSString stringWithFormat:@"%@条新消息",[headerDic objectForKey:@"messageCount"] ] forState:UIControlStateHighlighted];
            
            _btn_msg.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            _btn_msg.contentEdgeInsets = UIEdgeInsetsMake(0,40, 0, 0);
            
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            //        [btn_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            [headerViewR addSubview:_btn_msg];
            
            _img_msg.frame = CGRectMake(20, 2.5, 20, 20);
            _img_msg.contentMode = UIViewContentModeScaleToFill;
            _img_msg.layer.masksToBounds = YES;
            _img_msg.layer.cornerRadius = 20/2;
            
            [_img_msg sd_setImageWithURL:[NSURL URLWithString:[headerDic objectForKey:@"messageAvatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            [_btn_msg addSubview:_img_msg];
            
            headerViewR.frame = CGRectMake(0, 0, WIDTH, 250);
        }else {
            _btn_msg.hidden = YES;
            _img_msg.hidden = YES;
            
            // 因为某些未知原因，有时候红点没有remove，这里先remove两次，之后需要查查原因。
            [noticeImgVForMsg removeFromSuperview];
            [noticeImgVForMsg removeFromSuperview];
            newIconImg.hidden = YES;//add by kate 2015.02.03
        }
    }
    
    _tableViewR.tableHeaderView = headerViewR;
}

-(void)touchBgImgAction:(UIGestureRecognizer *)gnizer
{
    if ([@"class"  isEqual: _fromName]) {
        if (_isAdmin) {
            // 班级动态时只有管理员才能修改背景图片
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
            [myActionSheet showInView:self.view];
        }
    }else if([@"other"  isEqual: _fromName]) {
        NSString *uid = [Utilities getUniqueUidWithoutQuit];

        // 个人动态只有为自己时候才能够修改
        if ([_fuid isEqual: uid]) {
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
            [myActionSheet showInView:self.view];
        }
    }else {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"从相册选择", @"拍照",nil];
        [myActionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 330) {
        
        if (buttonIndex == 0) {
            
             PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
             publish.flag = 0;
             [self.navigationController pushViewController:publish animated:YES];
            
        }else if (buttonIndex == 1){
            
            PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
            publish.flag = 1;
            [self.navigationController pushViewController:publish animated:YES];
            
//-----------------------------测试代码 测试webview--------------------------------------
//            SingleWebViewController *singleWebV = [[SingleWebViewController alloc]init];
//            singleWebV.requestURL = @"http://www.baidu.com";
//            singleWebV.fromName = @"moments";
//            [self.navigationController pushViewController:singleWebV animated:YES];
            
            //---测试代码 测试分享链接
//            PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
//            publish.flag = 2;
//            publish.shareUrl = @"http://www.baidu.com";
//            publish.shareTitle = @"百度一下";
//            [self.navigationController pushViewController:publish animated:YES];

//---------------------------------------------------------------------------------------
            
            
        }else if (buttonIndex == 2){//小视频
            
            SightRecordViewController *vc = [[SightRecordViewController alloc]init];
            vc.fromName = @"myMoment";
            vc.cid = @"";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if (actionSheet.tag == 331){
        
        if (buttonIndex == 0) {
            
            PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
            publish.fromName = @"class";
            publish.flag = 0;
            publish.cid = _cid;
            publish.cName = _cName;
            [self.navigationController pushViewController:publish animated:YES];
            
        }else if (buttonIndex == 1){
         
            PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
            publish.fromName = @"class";
            publish.flag = 1;
            publish.cid = _cid;
            publish.cName = _cName;
            [self.navigationController pushViewController:publish animated:YES];
        }else if (buttonIndex == 2){//小视频
            
            SightRecordViewController *vc = [[SightRecordViewController alloc]init];
            vc.cid = _cid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else{
        switch (buttonIndex) {
            case 0:
                // 从相册选择
                [self LocalPhoto];
                break;
            case 1:
                // 拍照
                //[self takePhoto];
                [Utilities takePhotoFromViewController:self];//update by kate 2014.04.17
                break;
            default:
                break;
        }
    }
    
    
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

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    // 设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    // 资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    // 判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        // 资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
// 图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    // 当图片不为空时显示图片并保存图片
    if (image != nil) {
        _img_bgImg = image;
        
        // 获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        // 指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        // 创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        // 保存图片的路径
        _imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        
        // 以下是保存文件到沙盒路径下
        // 把图片转成NSData类型的数据来保存文件
        NSData *data;
        
        data = UIImageJPEGRepresentation(image, 0.3);

        // 保存
        [[NSFileManager defaultManager] createFileAtPath:_imagePath contents:data attributes:nil];
        
        [self doUpdateBgImg];
    }
    // 关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)doUpdateBgImg
{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    if ([@"class"  isEqual: _fromName]) {
        
     
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"Circle",@"ac",
                              @"2",@"v",
                              @"setClassBackground", @"op",
                              _cid, @"cid",
                              _imagePath, @"png0",
                              nil];
        
        [network sendHttpReq:HttpReq_MomentsSetUserBackground andData:data];
    }else {
#if 0
        
        NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 _imagePath, @"png0",
                                 nil];
        NSArray *fileArray = [NSArray arrayWithObjects:fileDic, nil];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"Circle",@"ac",
                              @"2",@"v",
                              @"setUserBackground", @"op",
                              @"png", @"fileType",
                              fileArray, @"files",
                              nil];

        [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                NSString* message_info = [respDic objectForKey:@"message"];
                
            } else {
                NSString* message_info = [respDic objectForKey:@"message"];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:message_info
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
#else
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"Circle",@"ac",
                              @"2",@"v",
                              @"setUserBackground", @"op",
                              _imagePath, @"png0",
                              nil];
        
        [network sendHttpReq:HttpReq_MomentsSetUserBackground andData:data];
#endif
    }
}

-(void)touchHeadImgAction
{
    NSLog(@"HeadImg touch");
    if([_fromName isEqualToString:@"school"]) {
        // 学校动态时点击头像进入我的动态
        MomentsViewController *momentsV = [[MomentsViewController alloc]init];
        momentsV.titleName = @"我的动态";
        momentsV.fromName = @"mine";
        momentsV.preView = @"school";
        [self.navigationController pushViewController:momentsV animated:YES];
    }
}

-(void)touchMsgAction
{
    NSLog(@"touchMsgAction");
    
    newIconImg.hidden = YES;// add by kate 2015.02.03
    [noticeImgVForMsg removeFromSuperview];// add by kate
    [noticeImgVForMsg removeFromSuperview];// add by kate
    [myNoticeImgVForMsg removeFromSuperview];// add by kate
    _btn_msg.hidden = YES;
    _img_msg.hidden = YES;

    headerView.frame = CGRectMake(0,
                                 0,
                                 WIDTH,
                                  210);
    _tableView.tableHeaderView = headerView;

    [MyTabBarController setTabBarHidden:YES];

    NewListViewController *newList = [[NewListViewController alloc]init];
    newList.newsDic = _newsDic;
    newList.mid = _mid;
    newList.cid = _cid;
    [self.navigationController pushViewController:newList animated:YES];
}

-(void)calcCellHeighti
{
    //    NSDictionary *deleteDic;
    NSMutableArray *deleteArr = [NSMutableArray array];
    //    if (advertisingHeightArr.count > 0) {
    //
    //        if([startNum integerValue] < [advertisingHeightArr[0] integerValue] + 30){
    //            startNum = [NSString stringWithFormat:@"%ld", [startNum integerValue] + didAddCount];
    //        }
    //    }
    NSMutableArray *deleteIdArr = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *tempDic in dataArray) {
        if ([tempDic objectForKey:@"position"] > 0) {
            [deleteArr addObject:tempDic];
            [deleteIdArr insertObject:[NSString stringWithFormat:@"%ld", i] atIndex:0];
        }
        i++;
    }
    
    for (NSDictionary *tempDic in deleteArr) {
        if ([dataArray containsObject:tempDic]) {
            [dataArray removeObject:tempDic];
        }
    }
    
    for (NSString *tempI in deleteIdArr) {
        [cellMessageHeightArray removeObjectAtIndex:[tempI integerValue]];
        [cellHeightArray removeObjectAtIndex:[tempI integerValue]];
    }
    if ([@"0"  isEqual: startNum]) {
        [cellHeightArray removeAllObjects];
        [cellMessageHeightArray removeAllObjects];
    }
    
    //    for (NSDictionary *tempDIc in _advertisingArr) {
    //        if ([dataArray containsObject:tempDIc]) {
    //            [deleteArr addObject:tempDIc];
    //        }
    //    }
    //    for (NSDictionary *tempDic in deleteArr) {
    //        if ([dataArray containsObject:tempDic]) {
    //            [dataArray removeObject:tempDic];
    //        }
    //    }
    NSUInteger start = [startNum integerValue];
    NSUInteger end  = [dataArray count];
//    if (start == 0) {
        didAddCount = 0;
    
    // 根据cell内容，提前计算好每个cell的高度
    for (NSUInteger i=start; i<end ; i++) {
        int height = 0;
        NSDictionary *dic = [dataArray objectAtIndex:i];
        
        NSMutableArray *commentHeightArr = [[NSMutableArray alloc] init];
        
        if (true == [[dic objectForKey:@"blocked"] integerValue]) {
            // 如果该动态是被block的，则固定高度。
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     @"40",@"height",
                                                     @"0",@"more",
                                                     @"0",@"commentHeight1",
                                                     @"0",@"commentHeight2",
                                                     @"0",@"commentHeight3",
                                                     commentHeightArr, @"commentHeightArr",
                                                     nil];
            
            [cellMessageHeightArray addObject:cellMsgHeightDic];
            [cellHeightArray addObject:[NSString stringWithFormat:@"%d",100]];
        }else {
            
            int theight = 55 + 5;
            
            
            
            
            
            int picsHeight = 0;
            // 图片
            if ([(NSArray *)[dic objectForKey:@"pics"] count] != 0) {
                int picWidth = 100;
                
                //--------add by kate -----------------------------------------------------------------------------
                if ([(NSArray *)[dic objectForKey:@"pics"] count] == 1) {
                    
                    NSString *type = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"pics"] objectAtIndex:0] objectForKey:@"type"]];
                    
                    if ([type integerValue] == 1) {
                        picWidth = [Utilities transformationHeight:180.0 + 10];
                    }
                    
                }
                //--------------------------------------------------------------------------------------------------
                
                if ([(NSArray *)[dic objectForKey:@"pics"] count] <=3) {
                    picsHeight = picWidth+5;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 3) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 6)) {
                    picsHeight = picWidth*2 + 5*2;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 6) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 9)) {
                    picsHeight = picWidth*3 + 5*3;
                }
            }
            
            // 加和
            theight = picsHeight + theight;
            
            
            // 加上评论的那行
            theight = theight + 22 + 8;
            
            
            // 赞的人
            int lovesHeight = 0;
            if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
                NSString *lovesStr = @"";
                //                for (int i=0; i<[(NSArray *)[dic objectForKey:@"loves"] count]; i++) {
                //                    NSDictionary *dicLoves = [[dic objectForKey:@"loves"] objectAtIndex:i];
                //
                //                    NSString *name = [dicLoves objectForKey:@"name"];
                //                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", name]];
                //                }
                
                
                //                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                NSArray *aaaaa = [dic objectForKey:@"loves"];
                
                NSUInteger lovesCnt = [aaaaa count];
                
                if (lovesCnt > 10) {
                    // 如果大于10人，就显示等多少多少人
                    lovesCnt = 10;
                }
                
                for (int i=0; i<lovesCnt; i++) {
                    NSDictionary *dicLoves = [[dic objectForKey:@"loves"] objectAtIndex:i];
                    
                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                }
                
                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                if ([aaaaa count] > 10) {
                    lovesStr = [NSString stringWithFormat:@"%@等%lu人喜欢 ",lovesStr, (unsigned long)[(NSArray *)[dic objectForKey:@"loves"] count]];
                }
                
                lovesStr = [NSString stringWithFormat:@"%@%@", @"     ", lovesStr];
                
                
                UILabel *_lovesStrLabel = [[UILabel alloc] init];
                _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                _lovesStrLabel.numberOfLines = 0;
                _lovesStrLabel.textColor = [UIColor grayColor];
                _lovesStrLabel.backgroundColor = [UIColor clearColor];
                _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                _lovesStrLabel.text = lovesStr;
                
                CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake([Utilities getScreenSizeWithoutBar].width-64-7-7-10, 0)];
                
                lovesHeight = a.height+15;
            }
            
            // 加和
            theight = lovesHeight + theight;
            
            
            
            // 评论列表的总高度
            int commentHeight = 0;
            NSArray *commentsArr = [[dic objectForKey:@"comments"] objectForKey:@"list"];
            for (id obj in commentsArr) {
                NSDictionary *dic = (NSDictionary *)obj;
                
                CGSize size = [self getCommentAttrHeight:dic];
                
                // 由于还有上下的留白部分，给每个评论cell的高度增加14
                int height = size.height+5;
                
                [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                commentHeight = commentHeight + height;
            }
            
            if (0 != [commentsArr count]) {
                commentHeight = commentHeight + 10;
            }else {
                commentHeight = commentHeight + 5;
            }
            
            // 加和
            theight = commentHeight + theight+5;
            
            
            int contentHeight = 0;
            // 文字部分
            MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
            
            NSAttributedString *expressionText = [[dic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];
            
            TSAttributedLabel *label = kProtypeLabel();
            label.attributedText = expressionText;
            label.font = [UIFont systemFontOfSize:14.0f];
            
            CGSize msgSize = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 64-10];//update 2015.08.12
            
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSString stringWithFormat:@"%f",msgSize.height],@"height",
                                                     @"0",@"more",
                                                     @"0",@"commentHeight1",
                                                     @"0",@"commentHeight2",
                                                     @"0",@"commentHeight3",
                                                     commentHeightArr,@"commentHeightArr",
                                                     nil];
            [cellMessageHeightArray addObject:cellMsgHeightDic];
            
            // 如果超过三行，即高度62，则只显示三行的内容，并且需要显示查看更多
            // 但是cellMessageHeightArray中仍然记录真实的高度
            if (msgSize.height > 62) {
                contentHeight = contentHeight + 65 + 30;
            }else {
                if (![@"" isEqualToString:[dic objectForKey:@"message"]]) {
                    contentHeight = contentHeight + msgSize.height;
                }
            }
            
            // 加和
            theight = contentHeight + theight;
            
            
            
            
            // 加上sharedLink的高度
            NSString *shareUrl = [dic objectForKey:@"shareUrl"];
            NSDictionary *mistakeDic = [dic objectForKey:@"mistakes"];
            
            if (![@""  isEqual: shareUrl]) {
                theight = theight + 60;
            }else if ([mistakeDic count] > 0){
                
                NSString *title = [NSString stringWithFormat:@"%@",[mistakeDic objectForKey:@"title"]];
                if ([title length] > 0) {
                    
                    theight = theight + 55.0;
                }else{
                    
                    theight = theight + 45.0;
                }
                
            }
            
            [cellHeightArray addObject:[NSString stringWithFormat:@"%d",theight]];
            
            
            
            
            
#if 0
            int loves = 0;
            if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
                NSString *lovesStr = @"";
                for (int i=0; i<[(NSArray *)[dic objectForKey:@"loves"] count]; i++) {
                    NSDictionary *dicLoves = [[dic objectForKey:@"loves"] objectAtIndex:i];
                    
                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                }
                
                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                UILabel *_lovesStrLabel = [[UILabel alloc] init];
                _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                _lovesStrLabel.numberOfLines = 0;
                _lovesStrLabel.textColor = [UIColor grayColor];
                _lovesStrLabel.backgroundColor = [UIColor clearColor];
                _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                
                
                CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake([Utilities getScreenSizeWithoutBar].width-64-7-7-10, 0)];
                
                loves = a.height+25;
            }
            
            height = height + 90 + loves;
            //                      喜欢
            
            if ([(NSArray *)[dic objectForKey:@"pics"] count] != 0) {
                int picWidth = 79;
                
                //--------add by kate -----------------------------------------------------------------------------
                if ([(NSArray *)[dic objectForKey:@"pics"] count] == 1) {
                    
                    NSString *type = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"pics"] objectAtIndex:0] objectForKey:@"type"]];
                    
                    if ([type integerValue] == 1) {
                        picWidth = [Utilities transformationHeight:180.0];
                    }
                    
                }
                //--------------------------------------------------------------------------------------------------
                
                if ([(NSArray *)[dic objectForKey:@"pics"] count] <=3) {
                    height = height + picWidth;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 3) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 6)) {
                    height = height + picWidth*2 + 5;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 6) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 9)) {
                    height = height + picWidth*3 + 5*2;
                }
            }
            
            
            // 评论高度列表
            
            // 评论列表的总高度
            int commentHeight = 0;
            NSArray *commentsArr = [[dic objectForKey:@"comments"] objectForKey:@"list"];
            for (id obj in commentsArr) {
                NSDictionary *dic = (NSDictionary *)obj;
                
                CGSize size = [self getCommentAttrHeight:dic];
                
                // 由于还有上下的留白部分，给每个评论cell的高度增加14
                int height = size.height+5;
                
                [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                commentHeight = commentHeight + height;
            }
            
            if (0 != [commentsArr count]) {
                commentHeight = commentHeight + 10;
            }else {
                commentHeight = commentHeight + 5;
            }
            
            // 评论内容计算高度
            //            NSUInteger commentsCount = [(NSArray *)[[dic objectForKey:@"comments"] objectForKey:@"list"] count];
            int commentHeight1 = 0;
            int commentHeight2 = 0;
            int commentHeight3 = 0;
            
            MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
            
            NSAttributedString *expressionText = [[dic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];
            
            TSAttributedLabel *label = kProtypeLabel();
            label.attributedText = expressionText;
            label.font = [UIFont systemFontOfSize:14.0f];
            
            CGSize msgSize = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 64-10];//update 2015.08.12
            
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSString stringWithFormat:@"%f",msgSize.height],@"height",
                                                     @"0",@"more",
                                                     [NSString stringWithFormat:@"%d",commentHeight1+5],@"commentHeight1",
                                                     [NSString stringWithFormat:@"%d",commentHeight2+5],@"commentHeight2",
                                                     [NSString stringWithFormat:@"%d",commentHeight3+5],@"commentHeight3",
                                                     commentHeightArr,@"commentHeightArr",
                                                     nil];
            [cellMessageHeightArray addObject:cellMsgHeightDic];
            
            // 如果超过三行，即高度62，则只显示三行的内容，并且需要显示查看更多
            // 但是cellMessageHeightArray中仍然记录真实的高度
            if (msgSize.height > 62) {
                height = height + 65 + 30;
            }else {
                if (![@"" isEqualToString:[dic objectForKey:@"message"]]) {
                    height = height + msgSize.height;
                }
            }
            
#if 0
            // 把3条评论的高度加上
            height = height + commentHeight1 + commentHeight2 + commentHeight3 + 5;
#else
            // 把所有评论的高度都加上
            height = commentHeight + height + 4;
#endif
            // 加上sharedLink的高度
            NSString *shareUrl = [dic objectForKey:@"shareUrl"];
            NSDictionary *mistakeDic = [dic objectForKey:@"mistakes"];
            
            if (![@""  isEqual: shareUrl]) {
                height = height + 60;
            }else if ([mistakeDic count] > 0){
                
                NSString *title = [NSString stringWithFormat:@"%@",[mistakeDic objectForKey:@"title"]];
                if ([title length] > 0) {
                    
                    height = height + 70.0 - 30.0;
                }else{
                    
                    height = height + 60.0 - 30.0;
                }
                
            }
            
            [cellHeightArray addObject:[NSString stringWithFormat:@"%d",height]];
#endif
        }
    }
    //    [dataArray addObjectsFromArray:deleteArr];
    
    startNum = [NSString stringWithFormat:@"%lu", [dataArray count]];
    
    if (haveAdvertising) {
        NSDictionary *tempDic = [[NSDictionary alloc] init];
        for (int i = 0; i < _advertisingArr.count; i++) {
            if ( [[_advertisingArr[i] objectForKey:@"position"] integerValue] - 1 < end) {
                tempDic = _advertisingArr[i];
                
                if (![dataArray containsObject:tempDic]) {
                    [self insertAdvertisingIntoDataWithI:[[tempDic objectForKey:@"position"] integerValue] - 1 WithAdvertisingNum:i];
                    didAddCount ++;
                    
                    [self getAdvertisingHeight];
                    NSDictionary *dic = @{@"commentHeight1":@"0",@"commentHeight2":@"0",@"commentHeight3":@"0",@"commentHeightArr":@[],@"height":@"0.00000",@"more":@"0"};
                    if (didAddCount  <= advertisingHeightArr.count) {
                        
                        [cellMessageHeightArray insertObject:dic atIndex:[[tempDic objectForKey:@"position"] integerValue] - 1];
                        [cellHeightArray insertObject:advertisingHeightArr[i] atIndex:[[tempDic objectForKey:@"position"] integerValue] - 1];
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
}
- (void)insertAdvertisingIntoDataWithI:(NSInteger )i WithAdvertisingNum:(NSInteger)j
{
    
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (NSDictionary *tempDic in dataArray) {
        if ([[tempDic objectForKey:@"position"] integerValue] > 0) {
            [deleteArr addObject:tempDic];
        }
    }
    //    for (NSDictionary *tempDic in deleteArr) {
    //        if ([dataArray containsObject:tempDic]) {
    //            [dataArray removeObject:tempDic];
    //        }
    //    }
    if (_advertisingArr.count > 0) {
        if (dataArray.count > 0 && ![dataArray containsObject:_advertisingArr[j]]) {
            [dataArray insertObject:_advertisingArr[j] atIndex:i];
            
        }else{
            
        }
    }
    
    
}

-(void)calcCellHeightiR
{
    if ([@"0"  isEqual: startNumR]) {
        [cellHeightArrayR removeAllObjects];
        [cellMessageHeightArrayR removeAllObjects];
    }
    
    NSUInteger start = [startNumR integerValue];
    NSUInteger end  = [dataArrayR count];
    
    // 根据cell内容，提前计算好每个cell的高度
    for (NSUInteger i=start; i<end; i++) {
        int height = 0;
        NSDictionary *dic = [dataArrayR objectAtIndex:i];
        
        NSMutableArray *commentHeightArr = [[NSMutableArray alloc] init];
        
        if (true == [[dic objectForKey:@"blocked"] integerValue]) {
            // 如果该动态是被block的，则固定高度。
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     @"40",@"height",
                                                     @"0",@"more",
                                                     @"0",@"commentHeight1",
                                                     @"0",@"commentHeight2",
                                                     @"0",@"commentHeight3",
                                                     commentHeightArr, @"commentHeightArr",
                                                     nil];
            
            [cellMessageHeightArrayR addObject:cellMsgHeightDic];
            [cellHeightArrayR addObject:[NSString stringWithFormat:@"%d",135]];
        }else {
            int loves = 0;
            if (0 != [(NSArray *)[dic objectForKey:@"loves"] count]) {
                NSString *lovesStr = @"";
                for (int i=0; i<[(NSArray *)[dic objectForKey:@"loves"] count]; i++) {
                    NSDictionary *dicLoves = [[dic objectForKey:@"loves"] objectAtIndex:i];
                    
                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                }
                
                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                UILabel *_lovesStrLabel = [[UILabel alloc] init];
                _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                _lovesStrLabel.numberOfLines = 0;
                _lovesStrLabel.textColor = [UIColor grayColor];
                _lovesStrLabel.backgroundColor = [UIColor clearColor];
                _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                
                
                CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                
                loves = a.height + 25;
            }
            
            height = height + 60 + 30 + loves;
            //                      赞     喜欢
            // 如果有图片，则按照图片的个数进行增加高度
            if ([(NSArray *)[dic objectForKey:@"pics"] count] != 0) {
                int picWidth = ([Utilities getScreenSizeWithoutBar].width-40)/3;
                
                //--------add by kate -----------------------------------------------------------------------------
                if ([(NSArray *)[dic objectForKey:@"pics"] count] == 1) {
                    
                    NSString *type = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"pics"] objectAtIndex:0] objectForKey:@"type"]];
                    
                    if ([type integerValue] == 1) {
                        picWidth = [Utilities convertPixsH:180.0] + 10;
                    }
                    
                }
                //--------------------------------------------------------------------------------------------------
                
                if ([(NSArray *)[dic objectForKey:@"pics"] count] <=3) {
                    height = height + picWidth + 5;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 3) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 6)) {
                    height = height + picWidth*2 + 5*2 + 5;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 6) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 9)) {
                    height = height + picWidth*3 + 5*3 + 5;
                }
            }
            
            // 评论高度列表
            
            // 评论列表的总高度
            int commentHeight = 0;
            NSArray *commentsArr = [[dic objectForKey:@"comments"] objectForKey:@"list"];
            for (id obj in commentsArr) {
                NSDictionary *dic = (NSDictionary *)obj;
                
                CGSize size = [self getCommentAttrHeight:dic];
                
                // 由于还有上下的留白部分，给每个评论cell的高度增加4
                int height = size.height  + 4;
                
                [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                commentHeight = commentHeight + height;
            }
            
            if (0 != [commentsArr count]) {
                height = height + 10;
            }else {
                height = height - 5;
            }
            
            // 评论内容计算高度
            NSUInteger commentsCount = [(NSArray *)[[dic objectForKey:@"comments"] objectForKey:@"list"] count];
            int commentHeight1 = 0;
            int commentHeight2 = 0;
            int commentHeight3 = 0;
            
            MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
            
            NSAttributedString *expressionText = [[dic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];
            
            TSAttributedLabel *label = kProtypeLabel();
            label.attributedText = expressionText;
            label.font = [UIFont systemFontOfSize:14.0f];
            
            CGSize msgSize = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 20.0];//update 2015.08.12
            
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSString stringWithFormat:@"%f",msgSize.height],@"height",
                                                     @"0",@"more",
                                                     [NSString stringWithFormat:@"%d",commentHeight1+5],@"commentHeight1",
                                                     [NSString stringWithFormat:@"%d",commentHeight2+5],@"commentHeight2",
                                                     [NSString stringWithFormat:@"%d",commentHeight3+5],@"commentHeight3",
                                                     commentHeightArr,@"commentHeightArr",
                                                     nil];
            [cellMessageHeightArrayR addObject:cellMsgHeightDic];
            
            // 如果超过三行，即高度62，则只显示三行的内容，并且需要显示查看更多
            // 但是cellMessageHeightArray中仍然记录真实的高度
            if (msgSize.height > 62) {
                height = height + 62 + 12;
            }else {
                if (![@"" isEqualToString:[dic objectForKey:@"message"]]) {
                    height = height + msgSize.height+8;
                }
            }
            
#if 0
            // 把3条评论的高度加上
            height = height + commentHeight1 + commentHeight2 + commentHeight3 + 5;
#else
            // 把所有评论的高度都加上
            height = commentHeight + height + 4;
#endif
            // 加上sharedLink的高度
            NSString *shareUrl = [dic objectForKey:@"shareUrl"];
            if (![@""  isEqual: shareUrl]) {
                height = height + 60;
            }
            
            [cellHeightArrayR addObject:[NSString stringWithFormat:@"%d",height]];
        }
    }
}


-(CGSize)getCommentAttrHeight:(NSDictionary *)dic
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改

    NSString *msg = [self transComment2TSAttLabel:dic];
    NSAttributedString *expressionText = [msg expressionAttributedStringWithExpression:exp];
    
    TSAttributedLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    label.font = [UIFont systemFontOfSize:13.0f];
    
    return [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 30.0];
}

- (float)getTextHeight:(NSString *)str andFont:(UIFont *)font andSize:(CGSize)size
{
    /*// 普通的txt
     //    CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
     //    NSLog(@"msgId:%lld,Height:%f",entity.msg_id,self.frame.size.height);
     
     NSString *newString = [self textFromEmoji:entity.msg_content];
     //CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
     CGSize size = [Utilities getStringHeight:newString andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(200, CGFLOAT_MAX)];
     CGFloat contentHeight = size.height;
     NSLog(@"newString:%@",newString);
     NSLog(@"contentHeight:%f",contentHeight);
     return contentHeight;*/
    
    // 普通的txt 文字数非常多的时候，用上面的方法计算高度是有问题的，改用以下方法 2015.07.24
    NSString * inputText = nil;
    inputText = str;
    
    NSString *displayStr = [self transformString:inputText];
    NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:font];
    
    currentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    currentLabel.backgroundColor = [UIColor clearColor];

    [currentLabel setAttString:attString withImages:textParser.images];
    
    CGRect labelRect = currentLabel.frame;
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)].height;
    
    return labelRect.size.height;
    
}

-(NSString *)transComment2String:(NSDictionary *)dic
{
    NSString *cmtMsg = [dic objectForKey:@"message"];
    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
    NSString *commentToName = [dic objectForKey:@"toName"];
    
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, cmtMsg];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, cmtMsg];
    }
    
    NSString *retStr = [self textFromEmoji:cmt];
    
    return retStr;
}

-(NSString *)transComment2TSAttLabel:(NSDictionary *)dic
{
    NSString *cmtMsg = [dic objectForKey:@"message"];
    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
    NSString *commentToName = [dic objectForKey:@"toName"];
    
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, cmtMsg];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, cmtMsg];
    }
    
    return cmt;
}

-(void)calcCellHeightMine
{
    if ([@"0"  isEqual: startNum]) {
        [cellHeightArray removeAllObjects];
        [cellMessageHeightArray removeAllObjects];
    }
    
    NSUInteger start = [startNum integerValue];
    NSUInteger end  = [dataArray count];
    
    // 根据cell内容，提前计算好每个cell的高度
    for (NSUInteger i=start; i<end; i++) {
        int height = 0;
        NSDictionary *dic = [dataArray objectAtIndex:i];

        if (true == [[dic objectForKey:@"blocked"] integerValue]) {
            // 如果该动态是被block的，则固定高度。
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     @"40",@"height",
                                                     @"0",@"more",
                                                     @"0",@"commentHeight1",
                                                     @"0",@"commentHeight2",
                                                     @"0",@"commentHeight3",
                                                     arr, @"commentHeightArr",
                                                     nil];
            
            [cellMessageHeightArray addObject:cellMsgHeightDic];
            [cellHeightArray addObject:[NSString stringWithFormat:@"%d",50]];
            
            // 只有当第一次获取成功时才把第一个cell的高度增加50
            // 也就是说只有第一个cell是需要增加高度来显示一个额外的img
            if (0 == i) {
                NSUInteger cell0Height = [[cellHeightArray objectAtIndex:0] integerValue];
                [cellHeightArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%lu", cell0Height + 50]];
            }
        }else {
            height = height + 13 + 30 - 20;
            //                     赞
            // 如果有图片，则按照图片的个数进行增加高度
            if ([(NSArray *)[dic objectForKey:@"pics"] count] != 0) {
                if ([(NSArray *)[dic objectForKey:@"pics"] count] <=3) {
                    height = height + 60;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 3) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 6)) {
                    height = height + 60*2 + 5*2;
                }else if (([(NSArray *)[dic objectForKey:@"pics"] count] > 6) && ([(NSArray *)[dic objectForKey:@"pics"] count] <= 9)) {
                    height = height + 60*3 + 5*4;
                }
            }
            
            // 动态内容计算高度
            NSString *msg = [self textFromEmoji:[dic objectForKey:@"message"]];

            int msgHeight = 0;
            if (![@""  isEqual: msg]) {
//                NSString *newString = [self textFromEmoji:msg];
//                CGSize msgSize = [Utilities getStringHeight:msg andFont:[UIFont systemFontOfSize:16]  andSize:CGSizeMake(320-115, 0)];
//                
//                msgHeight = [self getTextHeight:msg andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(320-115, 0)];
//                CGSize msgSize = [DiscussDetailCell heightForEmojiText:[dic objectForKey:@"message"]];
//
//                msgHeight = msgSize.height;
//                msgHeight = msgSize.height;
                
                MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
                
                NSAttributedString *expressionText = [[dic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];

                TSAttributedLabel *label = kProtypeLabel();
                label.attributedText = expressionText;
                label.font = [UIFont systemFontOfSize:14.0f];
                
                CGSize msgSize = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 115.0];//update 2015.08.12
                
                msgHeight = msgSize.height;

            }
            
            NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSString stringWithFormat:@"%d",msgHeight+5],@"height",
                                                     @"0",@"more",
                                                     [NSString stringWithFormat:@"%d",0],@"commentHeight1",
                                                     [NSString stringWithFormat:@"%d",0],@"commentHeight2",
                                                     [NSString stringWithFormat:@"%d",0],@"commentHeight3",
                                                     nil];
            [cellMessageHeightArray addObject:cellMsgHeightDic];
            
            // 如果超过三行，即高度57，则只显示三行的内容，并且需要显示查看更多
            // 但是cellMessageHeightArray中仍然记录真实的高度
            if (msgHeight > 62) {
                height = height + 65 + 30;
            }else {
                height = height + msgHeight;
                if ((0 != msgHeight) && ([(NSArray *)[dic objectForKey:@"pics"] count] != 0)) {
                    height = height + 10;
                }
            }
            
            // 加上sharedLink的高度
            NSString *shareUrl = [dic objectForKey:@"shareUrl"];
            if (![@""  isEqual: shareUrl]) {
                height = height + 60;
            }

            [cellHeightArray addObject:[NSString stringWithFormat:@"%d",height]];
            
            // 只有当第一次获取成功时才把第一个cell的高度增加50
            // 也就是说只有第一个cell是需要增加高度来显示一个额外的img
            if (0 == i) {
                NSUInteger cell0Height = [[cellHeightArray objectAtIndex:0] integerValue];
                [cellHeightArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%lu", cell0Height + 50]];
            }
        }
    }
}

- (NSString *)transformString:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

// 解决发送聊天时内容带表情cell的高度不准确的问题，因为一个表情字符里面带多个字符，统一替换成一个字符
- (NSString *)textFromEmoji:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"怒"];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    // 学生家长的全部
//    @"CircleStudent",@"ac",
//    @"3",@"v",
//    @"school", @"op",

    // 学生家长的班级
//    @"CircleStudent",@"ac",
//    @"3",@"v",
//    @"streams", @"op",

    
    if (([@"CircleAction.classroom"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleAction.threads"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleTeacherAction.school"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleStudentAction.school"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleParentAction.school"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleTeacherAction.class4select"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
        ([@"CircleParentAction.class4select"  isEqual: [resultJSON objectForKey:@"protocol"]])) {

        if(true == [result intValue])
        {
            if ([@"0"  isEqual: startNum]) {
                [dataArray removeAllObjects];
                [cellHeightArray removeAllObjects];
                [cellMessageHeightArray removeAllObjects];
                
                likePosY = 0;
            }

            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSLog(@"message_info:%@",message_info);
            
//            //--------2015.05.14-----------------------------------------------------------
            if ([@"CircleAction.threads"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                
                if ([@"0" isEqualToString:startNum]) {
                    [[MomentsListDBDao getDaoInstance] deleteAllData:@"school"];// 删除所有数据
                }
               
                NSString *size = [message_info objectForKey:@"size"];
                int pageNum = [startNum intValue]/[size intValue];
                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // 获取数据，直接更新数据库即可
                MomentsListObject *momentsList = [[MomentsListObject alloc] init];
                momentsList.momentType = @"school";
                momentsList.jsonStr = jsonStr;
                momentsList.momentId = @"";
                momentsList.page = [NSString stringWithFormat:@"%d",pageNum];
                [momentsList updateToDB];
            }else{
                
                // 校友圈
                
                //schoolCircleLastId
                
                
            }
            //-------------------------------------------------------------------------------
            
            
            headerDic = [message_info objectForKey:@"profile"];
 
            NSArray *oriArray = [message_info objectForKey:@"list"];
            
            //---add by kate-----------------------------------------
            
            if ([_fromName isEqualToString:@"class"]) {
                // 班级动态最后一条id存储
                if (oriArray!=nil) {
                    if ([oriArray count] > 0) {
                        
                        NSLog(@"cid:%@",_cid);
                        
                        NSString *lastIdStr = [[oriArray objectAtIndex:0] objectForKey:@"id"];

                        // To do:2.9.2红点逻辑修改
                        //2015.11.13
                        //[Utilities updateClassRedPoints:_cid last:lastIdStr mid:_mid];
                        
                    }
                }
            }
            
            //-------------------------------------------------------

            for (int i=0; i<[oriArray count]; i++) {
                NSMutableDictionary *dic_temp = [NSMutableDictionary dictionary];
                
                // 将评论内容转化为动态数组
                NSDictionary *commentsDic = [[oriArray objectAtIndex:i] objectForKey:@"comments"];
                NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
                
                [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
                [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
                [comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];
                
                NSArray *comment_temp = [commentsDic objectForKey:@"list"];
                NSMutableArray *arrComments = [NSMutableArray array];

                for (NSObject *object in comment_temp) {
                    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                    NSDictionary *dic = (NSDictionary *)object;
                    
                    [dic1 addEntriesFromDictionary:dic];
                    [arrComments addObject:dic1];
                }
                [comments_tempDic setObject:arrComments forKey:@"list"];

                // 将喜欢的人转换为动态数组
                NSArray *oriArrLoves = [[oriArray objectAtIndex:i] objectForKey:@"loves"];
                NSMutableArray *arrLoves = [NSMutableArray array];
                
                for (NSObject *object in oriArrLoves) {
                    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                    NSDictionary *dic = (NSDictionary *)object;
                    
                    [dic1 addEntriesFromDictionary:dic];
                    [arrLoves addObject:dic1];
                }

                [dic_temp setObject:arrLoves forKey:@"loves"];
                [dic_temp setObject:comments_tempDic forKey:@"comments"];

                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"pics"] forKey:@"pics"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"uid"] forKey:@"uid"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"avatar"] forKey:@"avatar"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"message"] forKey:@"message"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"dateline"] forKey:@"dateline"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"like"] forKey:@"like"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"loved"] forKey:@"loved"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"blocked"] forKey:@"blocked"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"tags"] forKey:@"tags"];
                
                NSMutableDictionary *comments_PathDic = [NSMutableDictionary dictionary];
                
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"save"] forKey:@"save"];
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"id"] forKey:@"id"];
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"type"] forKey:@"type"];

                [dic_temp setObject:comments_PathDic forKey:@"growpath"];

                // shared links
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareContent"]] forKey:@"shareContent"];

                [dataArray addObject:dic_temp];
            }

            [self doShowClassroomHeaderView];
            [self calcCellHeighti];
            
            startNum = [NSString stringWithFormat:@"%lu",(startNum.integerValue + [oriArray count])];
            
            if (0 == [dataArray count]) {
                _blankView.hidden = NO;
            }else {
                _blankView.hidden = YES;
            }

            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            //广告数据
            [self getAdvertising];
            [_tableView reloadData];
        }else {
            //[MBProgressHUD showError:[resultJSON objectForKey:@"message"] toView:nil];
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12
        }
    }else if (([@"CircleTeacherAction.classes"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
              ([@"CircleParentAction.streams"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
              ([@"CircleStudentAction.streams"  isEqual: [resultJSON objectForKey:@"protocol"]]) ) {
        if(true == [result intValue])
        {
            if ([@"0"  isEqual: startNumR]) {
                [dataArrayR removeAllObjects];
                [cellHeightArrayR removeAllObjects];
                [cellMessageHeightArrayR removeAllObjects];
                
                likePosY = 0;
            }
            
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSLog(@"message_info:%@",message_info);
            
            //            //--------2015.05.14-----------------------------------------------------------
            if ([@"CircleAction.threads"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                
                if ([@"0" isEqualToString:startNumR]) {
                    [[MomentsListDBDao getDaoInstance] deleteAllData:@"school"];// 删除所有数据
                }
                
                NSString *size = [message_info objectForKey:@"size"];
                int pageNum = [startNum intValue]/[size intValue];
                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // 获取数据，直接更新数据库即可
                MomentsListObject *momentsList = [[MomentsListObject alloc] init];
                momentsList.momentType = @"school";
                momentsList.jsonStr = jsonStr;
                momentsList.momentId = @"";
                momentsList.page = [NSString stringWithFormat:@"%d",pageNum];
                [momentsList updateToDB];
            }else{
                
                // 校友圈
                
                //schoolCircleLastId
                
                
            }
            //-------------------------------------------------------------------------------
            
            
            headerDic = [message_info objectForKey:@"profile"];
            
            NSArray *oriArray = [message_info objectForKey:@"list"];
            
            //---add by kate-----------------------------------------
            
            if ([_fromName isEqualToString:@"class"]) {
                // 班级动态最后一条id存储
                if (oriArray!=nil) {
                    if ([oriArray count] > 0) {
                        
                        NSLog(@"cid:%@",_cid);
                        
                        NSString *lastIdStr = [[oriArray objectAtIndex:0] objectForKey:@"id"];
                        
                        // To do:2.9.2红点逻辑修改
                        //2015.11.13
                        //[Utilities updateClassRedPoints:_cid last:lastIdStr mid:_mid];
                        
                    }
                }
            }
            
            //-------------------------------------------------------
            
            for (int i=0; i<[oriArray count]; i++) {
                NSMutableDictionary *dic_temp = [NSMutableDictionary dictionary];
                
                // 将评论内容转化为动态数组
                NSDictionary *commentsDic = [[oriArray objectAtIndex:i] objectForKey:@"comments"];
                NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
                
                [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
                [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
                [comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];
                
                NSArray *comment_temp = [commentsDic objectForKey:@"list"];
                NSMutableArray *arrComments = [NSMutableArray array];
                
                for (NSObject *object in comment_temp) {
                    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                    NSDictionary *dic = (NSDictionary *)object;
                    
                    [dic1 addEntriesFromDictionary:dic];
                    [arrComments addObject:dic1];
                }
                [comments_tempDic setObject:arrComments forKey:@"list"];
                
                // 将喜欢的人转换为动态数组
                NSArray *oriArrLoves = [[oriArray objectAtIndex:i] objectForKey:@"loves"];
                NSMutableArray *arrLoves = [NSMutableArray array];
                
                for (NSObject *object in oriArrLoves) {
                    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                    NSDictionary *dic = (NSDictionary *)object;
                    
                    [dic1 addEntriesFromDictionary:dic];
                    [arrLoves addObject:dic1];
                }
                
                [dic_temp setObject:arrLoves forKey:@"loves"];
                [dic_temp setObject:comments_tempDic forKey:@"comments"];
                
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"pics"] forKey:@"pics"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"uid"] forKey:@"uid"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"avatar"] forKey:@"avatar"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"message"] forKey:@"message"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"dateline"] forKey:@"dateline"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"like"] forKey:@"like"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"loved"] forKey:@"loved"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"blocked"] forKey:@"blocked"];
                [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"tags"] forKey:@"tags"];
                
                NSMutableDictionary *comments_PathDic = [NSMutableDictionary dictionary];
                
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"save"] forKey:@"save"];
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"id"] forKey:@"id"];
                [comments_PathDic setObject:[[[oriArray objectAtIndex:i] objectForKey:@"growpath"] objectForKey:@"type"] forKey:@"type"];
                
                [dic_temp setObject:comments_PathDic forKey:@"growpath"];

                // shared links
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
                [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareContent"]] forKey:@"shareContent"];
                
                [dataArrayR addObject:dic_temp];
            }
            
//            [self doShowClassroomHeaderViewR];
            [self calcCellHeightiR];
            
            startNumR = [NSString stringWithFormat:@"%lu",(startNumR.integerValue + [oriArray count])];
            
            [self performSelector:@selector(testFinishedLoadDataR) withObject:nil afterDelay:0.2];
            
            [_tableViewR reloadData];
            
            if (0 == [dataArrayR count]) {
                _blankViewR.hidden = NO;
            }else {
                _blankViewR.hidden = YES;
            }
            
        }else {
            //[MBProgressHUD showError:[resultJSON objectForKey:@"message"] toView:nil];
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12
        }
    }else if ([@"CircleAction.love"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        // 赞
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    NSUInteger heightBefore = 0;
                    if (0 != [(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        heightBefore = a.height;
                    }

                    NSUInteger num = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"like"] integerValue];
                    
                    // 设置已赞
                    [[dataArray objectAtIndex:[likeCellNum integerValue]] setObject:@"1" forKey:@"loved"];
                    // 已赞数目+1
                    [[dataArray objectAtIndex:[likeCellNum integerValue]] setObject:[NSString stringWithFormat:@"%lu",num +1] forKey:@"like"];
                    
                    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
                    NSString *avatar = [[g_userInfo getUserDetailInfo]  objectForKey:@"avatar"];
                    NSString *name = [[g_userInfo getUserDetailInfo]  objectForKey:@"name"];

                    // 赞列表的人
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",avatar,@"avatar", name,@"name",nil];
                    
                    [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] addObject:dictionary];
                    
                    if (0 != [(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        NSUInteger height = [[cellHeightArray objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore + a.height;
                        
                        if (0 == heightBefore) {
                            // 增加高度
                            [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height+8]];
                        }else {
                            // 增加高度
                            [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height]];
                        }

                    }

                    [_tableView reloadData];
                    
                    [ReportObject event:ID_CIRCLE_LOVE];//2015.06.25
                }else {
                    NSUInteger heightBefore = 0;
                    if (0 != [(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;

                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        heightBefore = a.height;
                    }

                    NSUInteger num = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"like"] integerValue];
                    
                    // 设置已赞
                    [[dataArrayR objectAtIndex:[likeCellNum integerValue]] setObject:@"1" forKey:@"loved"];
                    // 已赞数目+1
                    [[dataArrayR objectAtIndex:[likeCellNum integerValue]] setObject:[NSString stringWithFormat:@"%lu",num +1] forKey:@"like"];
                    
                    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
                    NSString *avatar = [[g_userInfo getUserDetailInfo]  objectForKey:@"avatar"];
                    NSString *name = [[g_userInfo getUserDetailInfo]  objectForKey:@"name"];
                    
                    // 赞列表的人
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",avatar,@"avatar", name,@"name",nil];
                    
                    [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] addObject:dictionary];
                    
                    if (0 != [(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        NSUInteger height = [[cellHeightArrayR objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore + a.height;
                        
                        if (0 == heightBefore) {
                            // 增加高度
                            [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height+8]];
                        }else {
                            // 增加高度
                            [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height]];
                        }
                        
                    }

                    [_tableViewR reloadData];
                    
                    [ReportObject event:ID_CIRCLE_LOVE];//2015.06.25
                }
        }else{
            [Utilities showFailedHud:@"点赞失败" descView:self.view];//2015.05.12
        }
    }else if ([@"CircleAction.hate"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        // 取消赞
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    NSUInteger heightBefore = 0;
                    if (0 != [(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        heightBefore = a.height;
                    }

                    NSUInteger num = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"like"] integerValue];
                    
                    // 取消已赞
                    [[dataArray objectAtIndex:[likeCellNum integerValue]] setObject:@"0" forKey:@"loved"];
                    // 已赞数目+1
                    [[dataArray objectAtIndex:[likeCellNum integerValue]] setObject:[NSString stringWithFormat:@"%lu",num -1] forKey:@"like"];
                    
                    NSString *uid = [Utilities getUniqueUid];
                    NSMutableArray *arrLove = [[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"];
                    
                    int pos = -1;
                    for (int i=0; i<[arrLove count]; i++) {
                        NSDictionary *dicLove = [arrLove objectAtIndex:i];
                        NSString *uidLove = [dicLove objectForKey:@"uid"];
                        
                        if ([uidLove isEqual:uid]) {
                            pos = i;
                            break;
                        }
                    }
                    
                    [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] removeObjectAtIndex:pos];

                    if (0 != [(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        NSUInteger height = [[cellHeightArray objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore + a.height;
                        
                        if (0 == heightBefore) {
                            // 增加高度
                            [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height-8]];
                        }else {
                            // 增加高度
                            [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height]];
                        }

                        
                    }else {
                        NSUInteger height = [[cellHeightArray objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore;
                        
                        // 增加高度
                        [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height-8]];

                    }

                    
                    
                    
                    
                    
                    
                    [_tableView reloadData];
                    
                    [ReportObject event:ID_CIRCLE_LOVE];//2015.06.25
                }else {
                    
                    NSUInteger heightBefore = 0;
                    if (0 != [(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        heightBefore = a.height;
                    }

                    NSUInteger num = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"like"] integerValue];
                    
                    // 取消已赞
                    [[dataArrayR objectAtIndex:[likeCellNum integerValue]] setObject:@"0" forKey:@"loved"];
                    // 已赞数目+1
                    [[dataArrayR objectAtIndex:[likeCellNum integerValue]] setObject:[NSString stringWithFormat:@"%lu",num -1] forKey:@"like"];
                    

                    
                    NSString *uid = [Utilities getUniqueUid];
                    NSMutableArray *arrLove = [[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"];
                    
                    int pos = -1;
                    for (int i=0; i<[arrLove count]; i++) {
                        NSDictionary *dicLove = [arrLove objectAtIndex:i];
                        NSString *uidLove = [dicLove objectForKey:@"uid"];
                        
                        if ([uidLove isEqual:uid]) {
                            pos = i;
                            break;
                        }
                    }
                    
                    [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] removeObjectAtIndex:pos];
                    
                    if (0 != [(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]) {
                        NSString *lovesStr = @"";
                        for (int i=0; i<[(NSArray *)[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] count]; i++) {
                            NSDictionary *dicLoves = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"loves"] objectAtIndex:i];
                            
                            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                        }
                        
                        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                        
                        UILabel *_lovesStrLabel = [[UILabel alloc] init];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                        _lovesStrLabel.numberOfLines = 0;
                        _lovesStrLabel.textColor = [UIColor grayColor];
                        _lovesStrLabel.backgroundColor = [UIColor clearColor];
                        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        _lovesStrLabel.text = lovesStr;
                        
                        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                        
                        NSUInteger height = [[cellHeightArrayR objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore + a.height;
                        
                        if (0 == heightBefore) {
                            // 增加高度
                            [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height-8]];
                        }else {
                            // 增加高度
                            [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height]];
                        }
                    }else {
                        NSUInteger height = [[cellHeightArrayR objectAtIndex:[likeCellNum integerValue]] integerValue] -heightBefore;
                        
                        // 增加高度
                        [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height-8]];
                        
                    }

                    
                    [_tableViewR reloadData];
                    
                    [ReportObject event:ID_CIRCLE_LOVE];//2015.06.25
                }
        }else{
            [Utilities showFailedHud:@"取消赞失败" descView:self.view];//2015.05.12
        }
    }else if(([@"CircleAction.mine"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
             ([@"CircleAction.other"  isEqual: [resultJSON objectForKey:@"protocol"]])) {
        // 我的动态列表
        if ([@"0"  isEqual: startNum]) {
            [dataArray removeAllObjects];
            [cellHeightArray removeAllObjects];
            [cellMessageHeightArray removeAllObjects];
            
            likePosY = 0;
        }
        
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        NSLog(@"message_info:%@",message_info);
        
        
        //--------2015.05.14-----------------------------------------------------------
        if ([@"CircleAction.mine"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
            
            if ([@"0" isEqualToString:startNum]) {
                [[MomentsListDBDao getDaoInstance] deleteAllData:@"mine"];// 删除所有数据
            }
            
            NSString *size = [message_info objectForKey:@"size"];
            int pageNum = [startNum intValue]/[size intValue];
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // 获取数据，直接更新数据库即可
            MomentsListObject *momentsList = [[MomentsListObject alloc] init];
            momentsList.momentType = @"mine";
            momentsList.jsonStr = jsonStr;
            momentsList.momentId = @"";
            momentsList.page = [NSString stringWithFormat:@"%d",pageNum];
            [momentsList updateToDB];
        }
        //-------------------------------------------------------------------------------
        
        
        headerDic = [message_info objectForKey:@"profile"];
        NSArray *oriArray = [message_info objectForKey:@"list"];
        
        for (int i=0; i<[oriArray count]; i++) {
            NSMutableDictionary *dic_temp = [NSMutableDictionary dictionary];
            
            // 将评论内容转化为动态数组
            NSDictionary *commentsDic = [[oriArray objectAtIndex:i] objectForKey:@"comments"];
            NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
            
            [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
            [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
            [comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];
            
            [dic_temp setObject:comments_tempDic forKey:@"comments"];
            
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"pics"] forKey:@"pics"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"uid"] forKey:@"uid"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"avatar"] forKey:@"avatar"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"message"] forKey:@"message"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"dateline"] forKey:@"dateline"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"like"] forKey:@"like"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"loved"] forKey:@"loved"];
            [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"blocked"] forKey:@"blocked"];
            
            // shared links
            [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
            [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
            [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareContent"]] forKey:@"shareContent"];

            [dataArray addObject:dic_temp];
        }
        
        [self doShowClassroomHeaderViewMine];
        [self calcCellHeightMine];
        
        startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 30)];
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }else if (([@"CircleAction.setUserBackground"  isEqual: [resultJSON objectForKey:@"protocol"]]) ||
              ([@"CircleAction.setClassBackground"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // 设置背景图片
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    if (_img_bgImg) {
                        //[MBProgressHUD showSuccess:@"设置成功" toView:nil];
                        [Utilities showSuccessedHud:@"设置成功" descView:self.view];// 2015.05.12
                        [_tsTouchImg_momentsBg setImage:_img_bgImg];
                        
                        if ([@"CircleAction.setUserBackground"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                            [ReportObject event:ID_CIRCLE_SET_USER_BG];//2015.06.25
                        }else{
                            [ReportObject event:ID_CIRCLE_SET_CLASS_BG];//2015.06.25
                        }
                        
                    }
                }else {
                    if (_img_bgImg) {
                        //[MBProgressHUD showSuccess:@"设置成功" toView:nil];
                        [Utilities showSuccessedHud:@"设置成功" descView:self.view];// 2015.05.12
                        [_tsTouchImg_momentsBgR setImage:_img_bgImg];
                        
                        if ([@"CircleAction.setUserBackground"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                            [ReportObject event:ID_CIRCLE_SET_USER_BG];//2015.06.25
                        }else{
                            [ReportObject event:ID_CIRCLE_SET_CLASS_BG];//2015.06.25
                        }
                        
                    }
                }

        }else{
            
            //[MBProgressHUD showError:[resultJSON objectForKey:@"message"] toView:nil];
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12
        }
    }else if (([@"CircleAction.removePost"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // CircleAction.removeComment
        // 删除自己发的动态
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    [dataArray removeObjectAtIndex:[_deleteCellNum integerValue]];
                    [cellHeightArray removeObjectAtIndex:[_deleteCellNum integerValue]];
                    [cellMessageHeightArray removeObjectAtIndex:[_deleteCellNum integerValue]];
                    
                    startNum = [NSString stringWithFormat:@"%ld", [startNum integerValue] - 1];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    //[MBProgressHUD showSuccess:@"删除成功" toView:nil];
                    [Utilities showSuccessedHud:@"删除成功" descView:self.view];// 2015.05.12
                }else {
                    [dataArrayR removeObjectAtIndex:[_deleteCellNum integerValue]];
                    [cellHeightArrayR removeObjectAtIndex:[_deleteCellNum integerValue]];
                    [cellMessageHeightArrayR removeObjectAtIndex:[_deleteCellNum integerValue]];
                    
                    startNumR = [NSString stringWithFormat:@"%ld", [startNumR integerValue] - 1];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    //[MBProgressHUD showSuccess:@"删除成功" toView:nil];
                    [Utilities showSuccessedHud:@"删除成功" descView:self.view];// 2015.05.12
                }
        }else{
            
            //[MBProgressHUD showError:[resultJSON objectForKey:@"message"] toView:nil];
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12
            
        }
    }else if (([@"CircleAction.removeComment"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // 删除自己发的评论
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    // 删除评论高度数组里面对应的高度
                    NSMutableArray *commentHeightArr = [[cellMessageHeightArray objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"commentHeightArr"];
                    NSString *deleteHeight = [commentHeightArr objectAtIndex:[_deletePidPos integerValue]];
                    [commentHeightArr removeObjectAtIndex:[_deletePidPos integerValue]];
                    [[[dataArray objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] setObject:commentHeightArr forKey:@"commentHeightArr"];
                    
                    // 减少总高度
                    int height = [[cellHeightArray objectAtIndex:[_deleteCellNum integerValue]] integerValue] - [deleteHeight floatValue];
                    [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%d", height]];
                    
                    // 去dataArray里删除相应的评论
                    [[[[dataArray objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] removeObjectAtIndex:[_deletePidPos integerValue]];
                    
                    // 更新数量
                    NSString *commentCount = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"count"];
                    commentCount = [NSString stringWithFormat:@"%ld", [commentCount integerValue] - 1];
                    
                    [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentCount forKey:@"count"];
                    
//                    if (_segmentControl.selectedSegmentIndex == 0) {
//                        [_tableView reloadData];
//                    }else {
//                        [_tableViewR reloadData];
//                    }
                    
//                    [self performSelector:@selector(reload) withObject:nil afterDelay:0.3];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
                    //    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];

                    [Utilities showSuccessedHud:@"删除成功" descView:self.view];// 2015.05.12
                }else {
                    // 删除评论高度数组里面对应的高度
                    NSMutableArray *commentHeightArr = [[cellMessageHeightArrayR objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"commentHeightArr"];
                    NSString *deleteHeight = [commentHeightArr objectAtIndex:[_deletePidPos integerValue]];
                    [commentHeightArr removeObjectAtIndex:[_deletePidPos integerValue]];
                    [[[dataArrayR objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] setObject:commentHeightArr forKey:@"commentHeightArr"];
                    
                    // 减少总高度
                    int height = [[cellHeightArrayR objectAtIndex:[_deleteCellNum integerValue]] integerValue] - [deleteHeight floatValue];
                    [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%d", height]];
                    
                    // 去dataArray里删除相应的评论
                    [[[[dataArrayR objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] removeObjectAtIndex:[_deletePidPos integerValue]];
                    
                    // 更新数量
                    NSString *commentCount = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"count"];
                    commentCount = [NSString stringWithFormat:@"%ld", [commentCount integerValue] - 1];
                    
                    [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentCount forKey:@"count"];
                    
//                                [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                    [Utilities showSuccessedHud:@"删除成功" descView:self.view];// 2015.05.12
                }

        }else{
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12

        }
    }else if (([@"CircleAction.comment"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // 评论一条动态
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    NSDictionary *msg = [resultJSON objectForKey:@"message"];
                    
                    NSArray *commentAry = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"];
                    
                    int add = 0;
                    if (0 == [commentAry count]) {
                        add = 14;
                    }else {
                        add = 8;
                    }

                    [[[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] addObject:msg];
                    
                    
                    // 增加总高度
                    CGSize msgSize = [self getCommentAttrHeight:msg];//update 2015.08.12
                    
                    int height = 0;
                    height = [[cellHeightArray objectAtIndex:[likeCellNum integerValue]] integerValue] + msgSize.height + add;

                    // 增加cell高度
                    [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%d", height]];
                    
                    // 把新增的评论高度更新到heightArr里面
                    NSMutableArray *commentHeightArr = [[cellMessageHeightArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"commentHeightArr"];
                    
                    [commentHeightArr addObject:[NSString stringWithFormat:@"%d", (int)msgSize.height + 4]];
                    
                    [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentHeightArr forKey:@"commentHeightArr"];
                    
                    // 更新数量
                    NSString *commentCount = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"count"];
                    commentCount = [NSString stringWithFormat:@"%ld", [commentCount integerValue] + 1];
                    
                    [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentCount forKey:@"count"];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    [Utilities showSuccessedHud:@"评论成功" descView:self.view];// 2015.05.12
                    [ReportObject event:ID_CIRCLE_REPLY];//2015.06.25
                }else {
                    NSDictionary *msg = [resultJSON objectForKey:@"message"];
                    
                    [[[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] addObject:msg];
                    
                    // 增加总高度
                    CGSize msgSize = [self getCommentAttrHeight:msg];//update 2015.08.12
                    int height = [[cellHeightArrayR objectAtIndex:[likeCellNum integerValue]] integerValue] + msgSize.height+4;
                    
                    // 增加cell高度
                    [cellHeightArrayR replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%d", height]];
                    
                    // 把新增的评论高度更新到heightArr里面
                    NSMutableArray *commentHeightArr = [[cellMessageHeightArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"commentHeightArr"];
                    
                    [commentHeightArr addObject:[NSString stringWithFormat:@"%f", msgSize.height + 4]];
                    
                    [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentHeightArr forKey:@"commentHeightArr"];
                    
                    // 更新数量
                    NSString *commentCount = [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"count"];
                    commentCount = [NSString stringWithFormat:@"%ld", [commentCount integerValue] + 1];
                    
                    [[[dataArrayR objectAtIndex:[likeCellNum integerValue]] objectForKey:@"comments"] setObject:commentCount forKey:@"count"];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    [Utilities showSuccessedHud:@"评论成功" descView:self.view];// 2015.05.12
                    [ReportObject event:ID_CIRCLE_REPLY];//2015.06.25
                }
        }else {
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];//2015.05.12
        }
    }else if ([@"CircleAction.block"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        // 管理员屏蔽动态
        if(true == [result intValue])
        {
                if (_segmentControl.selectedSegmentIndex == 0) {
                    // 改变array里面的值，重新描画
                    [[dataArray objectAtIndex:[_deleteCellNum integerValue]] setObject:@"1" forKey:@"blocked"];
                    [[dataArray objectAtIndex:[_deleteCellNum integerValue]] setObject:[resultJSON objectForKey:@"message"] forKey:@"message"];
                    
                    // 更改高度
                    // 如果该动态是被block的，则固定高度。
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    
                    NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             @"40",@"height",
                                                             @"0",@"more",
                                                             @"0",@"commentHeight1",
                                                             @"0",@"commentHeight2",
                                                             @"0",@"commentHeight3",
                                                             arr,@"commentHeightArr",
                                                             nil];
                    
                    [cellMessageHeightArray replaceObjectAtIndex:[_deleteCellNum integerValue] withObject:cellMsgHeightDic];
                    [cellHeightArray replaceObjectAtIndex:[_deleteCellNum integerValue] withObject:[NSString stringWithFormat:@"%d",135]];
                    
                    [[[[dataArray objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] removeAllObjects];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    [ReportObject event:ID_CIRCLE_BLOCK];//2015.06.25
                }else {
                    // 改变array里面的值，重新描画
                    [[dataArrayR objectAtIndex:[_deleteCellNum integerValue]] setObject:@"1" forKey:@"blocked"];
                    [[dataArrayR objectAtIndex:[_deleteCellNum integerValue]] setObject:[resultJSON objectForKey:@"message"] forKey:@"message"];
                    
                    // 更改高度
                    // 如果该动态是被block的，则固定高度。
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    
                    NSMutableDictionary *cellMsgHeightDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             @"40",@"height",
                                                             @"0",@"more",
                                                             @"0",@"commentHeight1",
                                                             @"0",@"commentHeight2",
                                                             @"0",@"commentHeight3",
                                                             arr,@"commentHeightArr",
                                                             nil];
                    
                    [cellMessageHeightArrayR replaceObjectAtIndex:[_deleteCellNum integerValue] withObject:cellMsgHeightDic];
                    [cellHeightArrayR replaceObjectAtIndex:[_deleteCellNum integerValue] withObject:[NSString stringWithFormat:@"%d",135]];
                    
                    [[[[dataArrayR objectAtIndex:[_deleteCellNum integerValue]] objectForKey:@"comments"] objectForKey:@"list"] removeAllObjects];
                    
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                    
                    [ReportObject event:ID_CIRCLE_BLOCK];//2015.06.25
                }
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)reload {
        if (_segmentControl.selectedSegmentIndex == 0) {
            [_tableView reloadData];
        }else {
            [_tableViewR reloadData];
        }
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 275) {
        // 删除自己发的动态
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"removePost", @"op",
                                  _deleteTid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsRemovePost andData:data];
        }
    }else if (alertView.tag == 274) {
        // 删除自己发的评论
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"removeComment", @"op",
                                  _deletePid,@"pid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsRemoveComment andData:data];
        }
    }else if (alertView.tag == 276) {
        // 管理员屏蔽动态
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"block", @"op",
                                  _deleteTid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsBlockPost andData:data];
        }
    }
}

-(void)reloadData
{
        if (_segmentControl.selectedSegmentIndex == 0) {
            [_tableView reloadData];
        }else {
            [_tableViewR reloadData];
        }

    [self setFooterView];
}

// 离线缓存 2015.05.14
-(void)getDataFromDB:(NSString*)type{
    
    if (page == 0) {
        
        [dataArray removeAllObjects];
        [cellHeightArray removeAllObjects];
        [cellMessageHeightArray removeAllObjects];
        
    }
    
    DB_Dic = [[MomentsListDBDao getDaoInstance] getData:type page:[NSString stringWithFormat:@"%ld",(long)page]];
    //NSLog(@"DB_Dic:%@",DB_Dic);
    
    if (![Utilities isConnected]) {
        if ([DB_Dic count] == 0) {
            
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            return;
            
        }
    }
    
    NSDictionary* message_info = [DB_Dic objectForKey:@"message"];
    headerDic = [message_info objectForKey:@"profile"];
    NSArray *oriArray = [message_info objectForKey:@"list"];
    
    for (int i=0; i<[oriArray count]; i++) {
        NSMutableDictionary *dic_temp = [NSMutableDictionary dictionary];
        
        // 将评论内容转化为动态数组
        NSDictionary *commentsDic = [[oriArray objectAtIndex:i] objectForKey:@"comments"];
        NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
        
        [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
        [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
        [comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];
        
        NSArray *comment_temp = [commentsDic objectForKey:@"list"];
        NSMutableArray *arrComments = [NSMutableArray array];
        
        for (NSObject *object in comment_temp) {
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSDictionary *dic = (NSDictionary *)object;
            
            [dic1 addEntriesFromDictionary:dic];
            [arrComments addObject:dic1];
        }
        [comments_tempDic setObject:arrComments forKey:@"list"];
        
        // 将喜欢的人转换为动态数组
        NSArray *oriArrLoves = [[oriArray objectAtIndex:i] objectForKey:@"loves"];
        NSMutableArray *arrLoves = [NSMutableArray array];
        
        for (NSObject *object in oriArrLoves) {
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSDictionary *dic = (NSDictionary *)object;
            
            [dic1 addEntriesFromDictionary:dic];
            [arrLoves addObject:dic1];
        }
        
        [dic_temp setObject:arrLoves forKey:@"loves"];
        [dic_temp setObject:comments_tempDic forKey:@"comments"];
        
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"pics"] forKey:@"pics"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"uid"] forKey:@"uid"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"avatar"] forKey:@"avatar"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"message"] forKey:@"message"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"dateline"] forKey:@"dateline"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"like"] forKey:@"like"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"loved"] forKey:@"loved"];
        [dic_temp setObject:[[oriArray objectAtIndex:i] objectForKey:@"blocked"] forKey:@"blocked"];
        
        // shared links
        [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
        [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
        [dic_temp setObject:[Utilities replaceNull:[[oriArray objectAtIndex:i] objectForKey:@"shareContent"]] forKey:@"shareContent"];
        
        [dataArray addObject:dic_temp];
    }
    
    NSLog(@"dataArrayCount:%lu",(unsigned long)[dataArray count]);
    [self doShowClassroomHeaderView];
    [self calcCellHeighti];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    [_tableView reloadData];
    
}

#pragma mark - 正则匹配电话号码，网址链接，Email地址
- (NSMutableArray *)addHttpArr:(NSString *)text
{
    //匹配网址链接
    NSString *regex_http = @"(https?|ftp|file)+://[^\\s]*";
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    NSMutableArray *httpArr = [NSMutableArray arrayWithArray:array_http];
    return httpArr;
}

#pragma mark - height
static TSAttributedLabel * kProtypeLabel() {
    
    static TSAttributedLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [TSAttributedLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
    });
    return _protypeLabel;
}

@end

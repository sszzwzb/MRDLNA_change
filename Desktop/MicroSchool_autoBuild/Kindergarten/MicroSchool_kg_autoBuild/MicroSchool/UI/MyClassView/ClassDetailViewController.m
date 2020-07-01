//
//  ClassDetailViewController.m
//  MicroSchool
//
//  Created by Kate on 14-12-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "FRNetPoolUtils.h"
#import "ClassDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ClassDiscussViewController.h"
//#import "HomeworkViewController.h"
#import "HomewWorkHomeViewController.h"
#import "HomeworkForTeacherViewController.h"
#import "DiscussViewController.h"
#import "PhonebookViewController.h"
#import "SetAdminMemberListViewController.h"
#import "EditClassInfoViewController.h"
#import "MemberListViewController.h"
#import "MomentsViewController.h"
#import "MyTabBarController.h"
#import "MicroSchoolAppDelegate.h"
#import "MyClassListViewController.h"
#import "MyGroupMsgListViewController.h"
#import "GrowthNotValidateViewController.h"
#import "SetPersonalViewController.h"
#import "PayViewController.h"


@interface ClassDetailViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *classInfo;
@property (strong, nonatomic) IBOutlet UILabel *classNameLab;
//@property (strong, nonatomic) IBOutlet UIView *subjectTableView;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel0;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel1;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel2;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel3;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel4;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel5;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel6;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel7;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel8;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel9;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImgV;

@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIView *unbindBar;


- (IBAction)closeUnbindBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)gotoBindView:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *unbindBarBtn;
@property (strong, nonatomic) IBOutlet UIView *openSpaceBar;
@property (strong, nonatomic) IBOutlet UILabel *unbindBarTitleLab;

@end

@implementation ClassDetailViewController

//2015.11.13
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkNewsIcon:)
                                                     name:@"reLoadClassDetailNews"
                                                   object:nil];//2015.11.12
        
        noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
        noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
        noticeImgVForMsg.tag = 456;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomizeLeftButtonWithImage:@""];
    // Do any additional setup after loading the view from its nib.
    winSize = [[UIScreen mainScreen] bounds].size;
    _backgroundImgV.image = [UIImage imageNamed:@"moments/bg_photo1.png"];
    if([_fromName isEqualToString:@"tab"]){
        
    }else{
        [super setCustomizeLeftButton];
    }
    [self setCustomizeTitle:_titleName];
    iconNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(38, 2, 9, 9)];
    iconNoticeImgV.image = [UIImage imageNamed:@"icon_notice"];
    
    iconHNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(38, 2, 9, 9)];
    iconHNoticeImgV.image = [UIImage imageNamed:@"icon_notice"];
    
    iconDNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(38, 2, 9, 9)];
    iconDNoticeImgV.image = [UIImage imageNamed:@"icon_notice"];
    
//    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
//    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
    
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMyclassInfo)
                                                 name:@"reLoadClassDetail"
                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkNewsIcon)
//                                                 name:@"reLoadClassDetailNews"
//                                               object:nil];//2015.11.12
    
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    displayArray =[[NSMutableArray alloc] init];
    
    [g_userInfo setUserCid:_cId];
    
    //NSLog(@"cid:%@",_cId);
    
    _classInfo.textColor = [UIColor grayColor];
    
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
    
     schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
     lastMsgId = @"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replaceRedImgArray)
                                                 name:@"refreshClassDetailNew"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnectedForClassDetail"
                                               object:nil];//2015.06.25
    
    redPointDic = [[NSMutableDictionary alloc] init];

}

// 课程表数据
-(void)showSubjectTabel:(NSArray*)array{
    
    
    _subjectLabel0.text = [Utilities replaceNull:[array objectAtIndex:0]];
    _subjectLabel1.text = [Utilities replaceNull:[array objectAtIndex:1]];
    _subjectLabel2.text = [Utilities replaceNull:[array objectAtIndex:2]];
    _subjectLabel3.text = [Utilities replaceNull:[array objectAtIndex:3]];
    _subjectLabel4.text = [Utilities replaceNull:[array objectAtIndex:4]];
    _subjectLabel5.text = [Utilities replaceNull:[array objectAtIndex:5]];
    _subjectLabel6.text = [Utilities replaceNull:[array objectAtIndex:6]];
    _subjectLabel7.text = [Utilities replaceNull:[array objectAtIndex:7]];
    _subjectLabel8.text = [Utilities replaceNull:[array objectAtIndex:8]];
    _subjectLabel9.text = [Utilities replaceNull:[array objectAtIndex:9]];

//    _subjectTableView.frame = CGRectMake(74.0, 35.0, _subjectTableView.frame.size.width, _subjectTableView.frame.size.height);
    
}

-(void)loadClassInfo{
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        listDic = [FRNetPoolUtils getMyclassDetail:_cId];
        
        NSLog(@"listDic:%@",listDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (listDic != nil) {
                
                if([_fromName isEqualToString:@"ClassList"]){
                    
                }else{
                    [self setCustomizeRightButton:@"icon_more.png"];
                }
                
                NSString *admin = [listDic objectForKey:@"admin"];
                NSString *isQuit = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"quit"]];//是否退出了班级
                
                if ([isQuit integerValue] == 1) {//退出了 add 2015.10.21
                    //if ([@"6" isEqualToString:usertype] || [@"0" isEqualToString:usertype]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
                    // }
                    //-----add by kate for beck----------------------------------
                    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                    [userDetail setObject:@"0" forKey:@"role_cid"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //-----------------------------------------------------------
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];

                    if([_fromName isEqualToString:@"tab"]){
                        
                        MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
                        myClass.hidesBottomBarWhenPushed = YES;
                        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
                        
                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                        NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                        [array replaceObjectAtIndex:1 withObject:customizationNavi];
                        [appDelegate.tabBarController setViewControllers:array];
                        
                        
                    }else{
                        
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                        
#if BUREAU_OF_EDUCATION
                        UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已退出部门" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alerV.tag = 345;
                        [alerV show];
#else
                        UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已退出班级" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alerV.tag = 345;
                        [alerV show];
#endif
                        
                        
                        
                    }
                    
                }else{//没退出
                    
                    if([admin intValue] == 1){
                        
                        _isAdmin = YES;
                    }else{
                        _isAdmin = NO;
                    }
                    
                    NSDictionary *class = [listDic objectForKey:@"profile"];
                    if (class!=nil) {
                        if ([class count]!=0) {
                            
                            spaceForClass = [NSString stringWithFormat:@"%@",[class objectForKey:@"space"]];//班级是否有学籍
                            unbindIntroduceUrl = [NSString stringWithFormat:@"%@",[class objectForKey:@"space_url"]];//老师身份班级未绑定学籍介绍页url
                            isNumber = [NSString stringWithFormat:@"%@",[class objectForKey:@"number"]];//是否绑定
                            NSString *headImagUrl = [Utilities replaceNull:[class objectForKey:@"pic"]];
                            //_headImgView.layer.masksToBounds = YES;
                            //_headImgView.layer.cornerRadius = _headImgView.frame.size.height/2.0;
                            
                            [_headImgView sd_setImageWithURL:[NSURL URLWithString:headImagUrl] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
                            _classInfo.text = [Utilities replaceNull:[class objectForKey:@"intro"]];
                            joinperm = [Utilities replaceNull:[class objectForKey:@"joinperm"]];
                            NSString *clasStr = [Utilities replaceNull:[class objectForKey:@"tagname"]];
                            _classNameLab.text = clasStr;
                            
                            // bug fix 2015.01.16 beck start
                            // 刷新view的时候如果需要重新set title，不能直接调用父类的方法，需要直接设置，不然会闪一下
#if 0
                            [self setCustomizeTitle:clasStr];
#endif
                            ((UILabel *)self.navigationItem.titleView).text = clasStr;
                            // bug fix 2015.01.16 beck end
                            
                            displayArray = [listDic objectForKey:@"modules"];
                            NSLog(@"displayArray:%@",displayArray);
                            
                            statusForSpace = nil;
                            
                            for (int i =0; i<[displayArray count]; i++) {
                                
                                int type  = [[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] intValue];
                                
                                if (type == 29) {
                                    [self isNeedShowMasking];
                                }
                                
                                if (type == 26) {
                                    
                                    spaceUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[[[displayArray objectAtIndex:i] objectForKey:@"space"] objectForKey:@"url"] objectForKey:@"help"]]];
                                    spaceIndex = i;
                                    statusForSpace =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:spaceIndex] objectForKey:@"space"] objectForKey:@"status"]];
                                    
                                }
                                
                                if (type == 7) {
                                    
                                    NSArray *subjectArray = [[displayArray objectAtIndex:i] objectForKey:@"list"];
                                    [self showSubjectTabel:subjectArray];
                                    break;
                                }
                                
                            }
                            
                            //if(!flag){
                            
                            //[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                            _tableView.tableHeaderView = _headView;
                            _tableView.hidden = NO;
                            
                            
#if BUREAU_OF_EDUCATION
                            
#else
                            
                            //教师端提示添加学籍信息
                            if ([spaceForClass integerValue] == 1) {
                                
                                [self closeUnbindBar:_closeBtn];
                                
                                _unbindBarTitleLab.frame = CGRectMake(15.0, 11.0, 265.0, 21.0);
                                _unbindBarTitleLab.text = @"          完善学籍信息，享受完整服务。";
                                _closeBtn.hidden = NO;
                                
                                if([_fromName isEqualToString:@"tab"]){
                                    
                                    if ([isNumber integerValue] == 0) {
                                        
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        BOOL isShowPopViewForClass = [userDefaults boolForKey:@"isShowPopViewForClass"];
                                        if (isShowPopViewForClass) {
                                            //弹出提示框 取消 绑定
                                            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未绑定学籍信息，无法使用成长空间" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"暂不绑定", nil];
                                            alertV.tag = 126;
                                            [alertV show];
                                        }
                                        
                                        [self addUnbindBar];
                                        
                                    }else{
                                        
                                        [self closeUnbindBar:_closeBtn];
                                        if (statusForSpace!=nil && [statusForSpace integerValue] == 0) {
                                            [self addOpenSpaceBar];
                                        }else{
                                            
                                            [self closeSpaceBar];
                                        }
                                    }
                                }
                                
                            }else{
                                
                                _closeBtn.hidden = YES;
                                _unbindBarTitleLab.frame = CGRectMake(0, 0, _unbindBar.frame.size.width, _unbindBar.frame.size.height);
                                _unbindBarTitleLab.text = @"您的班级还没添加学籍信息，点击查看。";
                                [self addUnbindBar];
                                
                            }
#endif
                    
                            [self buildRedArray:displayArray];
                            
                               if (_newsDic) {
                                    [self updateRedPoint:_newsDic];// 检查new标记
                                }else{
                                    [self checkNewsIcon];// 检查new标记
                                }
                       
                            // [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];//update by kate 2014.12.09
                            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                            [_tableView reloadData];
                            [Utilities dismissProcessingHud:self.view];
                            
                            if([_fromName isEqualToString:@"tab"]){
                                
                                _tableView.frame = CGRectMake(0, 0, winSize.width, winSize.height - 49 - 64);
                            }
                        }else{
                            
                            [Utilities dismissProcessingHud:self.view];
                            
                        }
                    }else{
                        
                        [Utilities dismissProcessingHud:self.view];
                    }
                }
                
            }else{
                
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                [Utilities dismissProcessingHud:self.view];
//--------------------update 2015.06.25--------------------------------------------------------
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"网络异常，请稍后再试"
//                                                              delegate:self
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
                //2015.06.30
                NSDictionary *user = [g_userInfo getUserDetailInfo];
                NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                
                if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype]){
                    
                    if ([displayArray count] == 0) {
                        if (![Utilities isConnected]) {//2015.06.30
                            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
                            [self.view addSubview:noNetworkV];
                            
                        }
                    }
                    
                   
                }else{
                     [self isConnected];
                }
                
            }
            
        });
    });

}

// 添加绑定引导黄条
-(void)addUnbindBar{
    
//    _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
//    _headView.frame = _baseView.frame;
//    
//    if (![_headView viewWithTag:222]) {
//        [_headView addSubview:_unbindBar];
//    }
    _baseView.frame = CGRectMake(0.0, 0.0, _baseView.frame.size.width, 104);

    if ([Utilities isConnected]) {
        
        if (_baseView.frame.origin.y > 40) {
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y -40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
        }else{
            
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            
        }
        
        _headView.frame = _baseView.frame;
        
        if (![_headView viewWithTag:222]) {
            [_headView addSubview:_unbindBar];
        }
       
    }else{
        
        if(_headView.frame.size.height < 180){
            
            _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width,
                                        _headView.frame.size.height +40.0);
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+80.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            
            if (![_headView viewWithTag:222]) {
                [_headView addSubview:_unbindBar];
            }
            
        }else{
            
            if (_baseView.frame.origin.y > 40){
                
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y-40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
                
            }else{
                
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+80.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            }
            
            //_headView.frame = _baseView.frame;
            
            if (![_headView viewWithTag:222]) {
                [_headView addSubview:_unbindBar];
            }
            
            NSLog(@"head y:%f",_headView.frame.origin.y);
            NSLog(@"head height:%f",_headView.frame.size.height);
            
            NSLog(@"baseview y:%f",_baseView.frame.origin.y);
            NSLog(@"baseview height:%f",_baseView.frame.size.height);
        }
       
    }
    _tableView.tableHeaderView = _headView;
    
}

// 添加绑定引导黄条
-(void)addOpenSpaceBar{
    
    _baseView.frame = CGRectMake(0.0, 0.0, _baseView.frame.size.width, 104);
    
    if ([Utilities isConnected]) {
        
        if (_baseView.frame.origin.y > 40) {
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y -40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
        }else{
            
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            
        }
        
        _headView.frame = _baseView.frame;
        
        if (![_headView viewWithTag:223]) {
            [_headView addSubview:_openSpaceBar];
        }
        
    }else{
        
        if(_headView.frame.size.height < 180){
            
            _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width,
                                        _headView.frame.size.height +40.0);
            _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+80.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            
            if (![_headView viewWithTag:223]) {
                [_headView addSubview:_openSpaceBar];
            }
            
        }else{
            
            if (_baseView.frame.origin.y > 40){
                
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y-40.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
                
            }else{
                
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+80.0, _baseView.frame.size.width, _baseView.frame.size.height+40);
            }
            
            //_headView.frame = _baseView.frame;
            
            if (![_headView viewWithTag:223]) {
                [_headView addSubview:_openSpaceBar];
            }
            
            NSLog(@"head y:%f",_headView.frame.origin.y);
            NSLog(@"head height:%f",_headView.frame.size.height);
            
            NSLog(@"baseview y:%f",_baseView.frame.origin.y);
            NSLog(@"baseview height:%f",_baseView.frame.size.height);
        }
        
    }
    _tableView.tableHeaderView = _headView;
    
}

// 获取班级信息
-(void)getMyclassInfo{
    
    [Utilities showProcessingHud:self.view];

    [self loadClassInfo];
    
}

-(void)updateUI{
    
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize size = CGSizeMake(286.0, 200000.0f);
    size = [_classInfo.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    float height =  _classInfo.frame.size.height;
    if (size.height > 57) {
        [_classInfo setFrame:CGRectMake(20, 133, size.width, size.height+30)];
        height =  _classInfo.frame.size.height;
        [_headView setFrame:CGRectMake(0, 0, WIDTH, _headView.frame.size.height+height)];
        
    }
    
     _tableView.tableHeaderView = _headView;
     _tableView.hidden = NO;
    [_tableView reloadData];
    //NSLog(@"displayArrayCount:%d",[displayArray count]);
    //_tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, winSize.width, 80*[displayArray count]+_headView.frame.size.height);
    
}
//班级tab红点
-(void)checkSelfMomentsNew{
    
    [noticeImgVForMsg removeFromSuperview];
    [noticeImgVForMsg removeFromSuperview];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
    UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
    UIImageView *listImg = (UIImageView*)[button viewWithTag:123];

    [detailImg removeFromSuperview];
    [listImg removeFromSuperview];
    
    [button addSubview:noticeImgVForMsg];
    
}

#if 0
//自定义模块红点共通 根据list的顺序找cell的index显示红点
-(BOOL)checkNewsIcon{
    
    NSString *moudles = nil;
    for (int i =0 ; i<[displayArray count]; i++) {
        
        flag = YES;
        
        NSString *type  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] ;
       NSString *lastId = @"";

        
        switch([type intValue]){
                
            case 13:// 班级讨论区
            {
               // 班级讨论区最后一条id
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastClassDisIdDic"]];
                lastId = [Utilities replaceNull:[tempDic objectForKey:_cId]];
//                if([lastId length] == 0){
//                    lastId = @"0";
//                }
            }
                break;
                
            case 14:// 班级公告
            {
                // 最新公告最后一条id
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastDisIdDic"]];
                lastId = [Utilities replaceNull:[tempDic objectForKey:_cId]];
//                if([lastId length] == 0){
//                    lastId = @"0";
//                }
                
            }
                break;
            case 19:// 班级动态
            {
                // 最新动态最后一条id
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelfNewIdDic"]];
                lastId = [Utilities replaceNull:[tempDic objectForKey:_cId]];
                
            }
                break;
                
            case 17:// 同步课堂
                lastId = @"";
                break;
                
            case 18:// 班级成员
                lastId = @"";
                break;
                
            case 7:// 课程表
                lastId = @"";
                break;
                
            case 8:// 作业
            {
                // 最新作业最后一条id
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastHomeIdDic"]];
                lastId = [Utilities replaceNull:[dic objectForKey:_cId]];
//                if([lastId length] == 0){
//                    lastId = @"0";
//                }
            }
                
                break;
         case 22://群聊
            {
                //-----检查是否有未读消息,存入字典-------------------------------------------------
                lastId = @"0";
                NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[_cId longLongValue]];
                NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
                
                int cnt = [chatsListDict.allKeys count];
                
                for (int listCnt = 0; listCnt < cnt; listCnt++) {
                    
                    NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
                    long long gid =[[chatObjectDict objectForKey:@"gid"] longLongValue];
                    
                    NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", gid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
                    int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
                    if (cnt > 0) {
                        
                        lastId = @"1";
                    }
                }
                
                
                //---------------------------------------------------------------------------------

                
            }
                break;
                
            case 26://成长空间
            {
                //---最新成绩id
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastScoreIdDic"]];
                lastId = [Utilities replaceNull:[dic objectForKey:_cId]];
                
                // 测试代码
                //lastId = @"1";

            }
                break;
                
                
        }
        
        NSString *item = [NSString stringWithFormat:@"%@:%@",type,lastId];
        if (i == 0) {
            moudles = item;
        }else{
            moudles = [NSString stringWithFormat:@"%@,%@",moudles,item];
            
        }
        
    }
    
//    //------------------------------------------------------------------
//    // 个人消息列表最后一条id
//    //10000:msgLastId
//    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
//    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:g_uid]];
//    NSString *specialMoudel = [NSString stringWithFormat:@"%@:%@",@"10000",msgLastId];
//    moudles = [NSString stringWithFormat:@"%@,%@",moudles,specialMoudel];
//    //---------------------------------------------------------------------
    
    NSLog(@"moudles:%@",moudles);
//    NSLog(@"cid:%@",_cId);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        newListArray = [FRNetPoolUtils checkNewForClass:_cId moudles:moudles];
        
        NSLog(@"newListArray:%@",newListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [noticeImgVForMsg removeFromSuperview];
            
            if (newListArray!=nil) {
                
                int count  = [newListArray count];

                if (count > 0) {
                    
                     if([_fromName isEqualToString:@"tab"]){
                    
                         [self checkSelfMomentsNew];
                     }
                    
                    redImgArray = [[NSMutableArray alloc] init];
                    
                    for (int i =0 ; i< [newListArray count]; i++) {
                        
//                        UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(410+i)];
//                        [newView removeFromSuperview];
                        
                        
                        NSString *newCount =[[newListArray objectAtIndex:i] objectForKey:@"count"];
                        
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                       // ClassDetailTableViewCell *cell = (ClassDetailTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
                        NSLog(@"row:%ld",(long)indexPath.row);
                       
                        
                        if ([newCount intValue] > 0) {
                            
//                            UIImageView *iconRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44+5, _headView.frame.size.height+15+(i*80), 10, 10)];
//                            iconRedImgV.tag = 410 + i;
//                            iconRedImgV.image = [UIImage imageNamed:@"icon_new.png"];
//                            
//                            [_tableView addSubview:iconRedImgV];
                             //cell.redImg.image = [UIImage imageNamed:@"icon_new.png"];
                            [redImgArray addObject:@"1"];
                            
                        }else{
                           
                             //cell.redImg.image = nil;
                            [redImgArray addObject:@"0"];
                            
                        }
                        
                    }
                    
                    [_tableView reloadData];
                    
                }else{
                    
                    [noticeImgVForMsg removeFromSuperview];
//                    for (int i=0; i<[displayArray count]; i++) {
//                        
//                        UIImageView *newView = (UIImageView*)[_tableView viewWithTag:(410+i)];
//                        [newView removeFromSuperview];
//                        
//                    }
                    
                        for (int i=0; i<[displayArray count]; i++) {
                    
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                            ClassDetailTableViewCell *cell = (ClassDetailTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
                            cell.redImg.image = nil;

                         }
                    
                    redImgArray = nil;
                }
            }
        });
        
    });
    
    return flag;
}
#endif

#if 0
// 更新页面红点 2015.11.12
-(void)updateRedPoint:(NSDictionary*)dic{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
    
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"classes"];//new
        NSArray *filteredArray = [allLastIdDic objectForKey:@"classes"];//old
        
        if ([filteredArray count] > 0) {
            
            [noticeImgVForMsg removeFromSuperview];
           
            for (int i=0; i<[array count]; i++){
                
                NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                
                if (i <= [filteredArray count]-1) {//防止新拉回来的数据 与本地数据Count不一致 导致crash
                    
                    NSString *cidFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"cid"]];
                    NSString *midFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *lastFiltered = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"last"]];
                    
                    if ([cid integerValue] == [_cId integerValue]) {
                        
                        NSString *type = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:i] objectForKey:@"type"]];
                        if ([type integerValue] == 19) {
                            lastMsgId = lastFiltered;//动态消息id
                        }
                        
                        if ([type integerValue] == 30) {
                            lastLeaveId = last;//点击请假模块用此id更新
                        }
                        
                        if(!redImgArray){
                            
                            redImgArray = [[NSMutableArray alloc] init];
                            
                            if ([redImgArray count] == 0) {
                                
                                for (int i=0; i<[displayArray count]; i++) {
                                    
                                    [redImgArray addObject:@"0"];
                                    
                                }
                            }
                        }
                       
                    
                        if ([cid integerValue] == [cidFiltered integerValue]) {//如果cid相同
                            
                            if ([mid integerValue] == [midFiltered integerValue]) {//如果班级内模块id相同
                                
                                if ([last integerValue] > [lastFiltered integerValue]) {//新的last比本地的last大
                                    
                                    if ([displayArray count] >0) {
                                        
                                        for (int i=0; i<[displayArray count]; i++) {
                                            
                                            NSString *moudleId = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"id"]];
                                             NSString *type = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]];
                                            
                                            // 班级公告 成长空间 群聊 作业 班级动态 显示 红点 2015.11.9志伟邮件
                                            NSDictionary *user = [g_userInfo getUserDetailInfo];
                                            NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                                            if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                                                //学生家长
                                                if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8) {
                                                    if ([moudleId integerValue] == [mid integerValue]) {
                                                        [redImgArray replaceObjectAtIndex:i withObject:@"1"];
                                                    }
                                                }
                                                
                                            }else{//老师 班级公告 成长空间 群聊 作业 显示 红点 2015.12.31
                                                if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8 || [type integerValue]== 30) {
                                                    if ([moudleId integerValue] == [mid integerValue]) {
                                                        [redImgArray replaceObjectAtIndex:i withObject:@"1"];
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        if([_fromName isEqualToString:@"tab"]){
                                            
                                            [self checkSelfMomentsNew];
                                            
                                            if ([self addNewCountForGroupMsg:cid]) {
                                                
                                                [self replaceRedImgArray];//群聊红点
                                                [self checkSelfMomentsNew];
                                            }
                                            
                                        }
                                        
                                    }else{
                                        
                                        if([_fromName isEqualToString:@"tab"]){
                                            
                                            if ([self addNewCountForGroupMsg:cid]) {
                                                
                                                [self checkSelfMomentsNew];
                                            }
                                        }
                                        
                                    }
                  
                                }else{
                                    
                                    for (int i=0; i<[displayArray count]; i++) {
                                        
                                        NSString *moudleId = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"id"]];
                                        
                                        if ([moudleId integerValue] == [mid integerValue]) {
                                            [redImgArray replaceObjectAtIndex:i withObject:@"0"];
                                        }
                                        
                                    }
                                    
                                    if([_fromName isEqualToString:@"tab"]){
                                        
                                        if ([self addNewCountForGroupMsg:cid]) {
                                            
                                            [self replaceRedImgArray];//群聊红点
                                            [self checkSelfMomentsNew];
                                        }else{
                                            
                                            if (groupChatIndex) {
                                                
                                                if ( groupChatIndex < [redImgArray count]) {//2015.09.23
                                                    
                                                    [redImgArray replaceObjectAtIndex:groupChatIndex withObject:@"0"];
                                                }
                                               
                                            }
                                        }
                                        
                                    }else{
                                        
                                        if ([self addNewCountForGroupMsg:cid]) {
                                            
                                            [self replaceRedImgArray];//群聊红点
                                            [self checkSelfMomentsNew];
                                        }else{
                                            
                                            if (groupChatIndex) {
                                                
                                                if ( groupChatIndex < [redImgArray count]) {//2015.09.23
                                                    
                                                    [redImgArray replaceObjectAtIndex:groupChatIndex withObject:@"0"];
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                    
                    }
                    
                        
                    }
                    
                }
            
            if ([displayArray count] >0){
                
                //NSLog(@"redImgArray:%@",redImgArray);
                [self addNewCountForSpaces:dic];
                [_tableView reloadData];

            }
        }
        
    }
}
#endif

//-------------------------------------------------------------------------------
// 更新页面红点 2015.02.18
-(void)updateRedPoint:(NSDictionary*)dic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dic) {
        
        NSArray *array = [dic objectForKey:@"classes"];//new
        NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
        NSMutableDictionary *classLastDicDefault = [allLastIdDic objectForKey:@"classLastDicDefault"];//old
        
        if ([classLastDicDefault count] > 0) {
            
            [noticeImgVForMsg removeFromSuperview];
            
            //[self buildRedArray:displayArray];//构造红点数组
            
            for (int i=0; i<[array count]; i++){
                
                NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                
                NSString *lastFiltered = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[classLastDicDefault objectForKey:keyStr]]];
                
                if ([cid integerValue] == [_cId integerValue]) {
                    
                    NSString *type = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"type"]];
                    
                    if ([type integerValue] == 19) {
                        lastMsgId = lastFiltered;//动态消息id
                    }
                    
                    if ([type integerValue] == 30) {
                        lastLeaveId = last;//点击请假模块用此id更新
                    }
                    
                    if ([type integerValue] == 26) {//如果成长空间开启了
                        
                        //if ([displayArray count] >0){
                        int index = -1;
                        for (int i =0 ; i<[displayArray count]; i++) {
                            
                            NSString *type  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] ;
                            if ([type integerValue] == 26) {
                                index = i;
                            }
                            
                        }
                        
                        BOOL isNewSpace = [self addNewCountForSpaces:dic];
                        if (isNewSpace) {
                            
                            if (index!= -1){
                                // 成长空间红点结构单独拿出来
                                [redImgArray replaceObjectAtIndex:index withObject:@"1"];
                            }
                            
                            if([_fromName isEqualToString:@"tab"]){
                                [self checkSelfMomentsNew];
                            }
                            
                        }else{
                           
                            if (index!= -1){
                                // 成长空间红点结构单独拿出来
                                [redImgArray replaceObjectAtIndex:index withObject:@"0"];
                            }
                            
                        }
                        //}
                        
                    }else if ([type integerValue] == 22){//如果群聊开启了
                        
                        if ([self addNewCountForGroupMsg:cid]) {
                            
                            
                            for (int i =0 ; i<[displayArray count]; i++) {
                                
                                NSString *type  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] ;
                                if ([type integerValue] == 22) {
                                    groupChatIndex = i;
                                }
                                
                            }
                            
                            [self replaceRedImgArray];//群聊红点
                            
                            if([_fromName isEqualToString:@"tab"]){
                                [self checkSelfMomentsNew];
                            }
                        
                        }else{
                            
                            if (groupChatIndex) {
                                [redImgArray replaceObjectAtIndex:groupChatIndex withObject:@"0"];
 
                            }
                            
                        }
                        
                    }else{//其他
                        
                        if ([last integerValue] > [lastFiltered integerValue]) {//新的last比本地的last大
                            
                            if ([displayArray count] >0) {
                                
                                for (int i=0; i<[displayArray count]; i++) {
                                    
                                    NSString *moudleId = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"id"]];
                                    NSString *type = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]];
                                    
                                    // 班级公告 成长空间 群聊 作业 班级动态 显示 红点 2015.11.9志伟邮件
                                    NSDictionary *user = [g_userInfo getUserDetailInfo];
                                    NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                                        //学生家长 班级公告 成长空间 群聊 作业 显示红点
                                        if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8) {
                                            if ([moudleId integerValue] == [mid integerValue]) {
                                                [redImgArray replaceObjectAtIndex:i withObject:@"1"];
                                                if([_fromName isEqualToString:@"tab"]){
                                                    [self checkSelfMomentsNew];
                                                }
                                         
                                            }
                                        }
                                        
                                    }else{//老师 班级公告 成长空间 群聊 作业 请假 显示红点 2015.12.31
                                        if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8 || [type integerValue]== 30) {
                                            if ([moudleId integerValue] == [mid integerValue]) {
                                                [redImgArray replaceObjectAtIndex:i withObject:@"1"];
                                                if([_fromName isEqualToString:@"tab"]){
                                                     [self checkSelfMomentsNew];
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                }
                                
                                
                            }else{
                                
                                if([_fromName isEqualToString:@"tab"]){
                                    [self checkSelfMomentsNew];
                                }
                            }
                            
                        }else{
                            
                                for (int i=0; i<[displayArray count]; i++) {
                                    
                                    NSString *moudleId = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"id"]];
                                    NSString *type = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]];
                                    
                                    // 班级公告 成长空间 群聊 作业 班级动态 显示 红点 2015.11.9志伟邮件
                                    NSDictionary *user = [g_userInfo getUserDetailInfo];
                                    NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                                        //学生家长 班级公告 成长空间 群聊 作业 显示红点
                                        if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8) {
                                            if ([moudleId integerValue] == [mid integerValue]) {
                                                [redImgArray replaceObjectAtIndex:i withObject:@"0"];
                                            }
                                        }
                                        
                                    }else{//老师 班级公告 成长空间 群聊 作业 请假 显示红点 2015.12.31
                                        if ([type integerValue] == 14 || [type integerValue] == 19 || [type integerValue] == 22 || [type integerValue] == 8 || [type integerValue]== 30) {
                                            if ([moudleId integerValue] == [mid integerValue]) {
                                                [redImgArray replaceObjectAtIndex:i withObject:@"0"];
                                            }
                                        }
                                    }
                                    
                                }
                  
                        }
                        
                    }
                    
                    
                }
                
            }
            
            [_tableView reloadData];
            
        }
        
    }
    

}


// 构造红点数组
-(void)buildRedArray:(NSMutableArray*)array{
    
    if(!redImgArray){//add 2016.02.18
        
        redImgArray = [[NSMutableArray alloc] init];
        
        if ([redImgArray count] == 0) {
            
            for (int i=0; i<[array count]; i++) {
                
                [redImgArray addObject:@"0"];
                
            }
        }
    }else if ([redImgArray count] == 0){
        
        for (int i=0; i<[array count]; i++) {
            
            [redImgArray addObject:@"0"];
            
        }
        
    }
//    else{
//        
//        for (int i=0; i<[redImgArray count]; i++) {
//            
//            [redImgArray replaceObjectAtIndex:i withObject:@"0"];
//            
//        }
//    }
}
//---------------------------------------------------------------------------------

// check群聊红点
-(BOOL)addNewCountForGroupMsg:(NSString*)cid{
    
    //-----检查是否有未读消息-------------------------------------------------
    
    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[cid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    
    NSInteger count = [chatsListDict.allKeys count];
    
    for (int listCnt = 0; listCnt < count; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        long long gid =[[chatObjectDict objectForKey:@"gid"] longLongValue];
        
        NSString *sql = [NSString stringWithFormat:@"select count(msg_id) from msgInfoForGroup_%lli where is_recieved = %d and msg_state != %d", gid, MSG_IO_FLG_RECEIVE, MSG_READ_FLG_READ];
        int cnt = [[DBDao getDaoInstance] getResultsToInt:sql];
        if (cnt > 0) {
            
            return YES;
        }
    }
    //---------------------------------------------------------------------------------
    return NO;
}

// 成长空间红点 单独拿出来检查 2015.12.17
-(BOOL)addNewCountForSpaces:(NSDictionary*)dic{
    
//    int index = -1;
//    for (int i =0 ; i<[displayArray count]; i++) {
//        
//        NSString *type  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] ;
//        if ([type integerValue] == 26) {
//            index = i;
//        }
//    
//    }
    
    //if (index!= -1) {//说明有成长空间模块 更新成长空间红点
    
    BOOL newForSpace = NO;
    
        if (dic) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *allLastIdDic = [userDefaults objectForKey:@"allLastIdDic"];
            NSMutableDictionary *spaceLastDicDefault = [allLastIdDic objectForKey:@"spaceLastDicDefault"];//old
            
            NSArray *array = [dic objectForKey:@"spaces"];
            
            if ([spaceLastDicDefault count] > 0) {
                
                for (int i=0; i<[array count]; i++) {
                    
                    NSString *cid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"cid"]];
                    NSString *mid = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"mid"]];
                    NSString *last = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"last"]];
                    
                    NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                    NSString *lastFiltered = [NSString stringWithFormat:@"%@",[spaceLastDicDefault objectForKey:keyStr]];
                    
                    if ([cid integerValue] == [_cId integerValue]) {
                        
                        if ([last integerValue] > [lastFiltered integerValue]) {
                            
                            [redPointDic setObject:last forKey:mid];
                            
                            newForSpace = YES;
//                            if (index!= -1){
//                                // 成长空间红点结构单独拿出来
//                                [redImgArray replaceObjectAtIndex:index withObject:@"1"];
//                            }
//                            
//                            if([_fromName isEqualToString:@"tab"]){
//                                [self checkSelfMomentsNew];
//                            }
//                            [redPointDic setObject:@"1" forKey:mid];
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
    //}
    return newForSpace;
}


-(void)checkNewsIcon:(NSNotification*)notify{
    
    NSDictionary *dic = [notify object];
    if (dic) {
        [self updateRedPoint:dic];
    }else{
        [self checkNewsIcon];
    }
    
}

-(void)checkNewsIcon{

    NSString *app = [Utilities getAppVersion];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Module",@"ac",
                          @"3",@"v",
                          @"check", @"op",
                          app,@"app",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
            NSLog(@"新红点check接口返回:%@",dic);
            
            if (dic) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"alwaysNewsDic"];
                [userDefaults synchronize];//存贮实时的最新的last
                
                [Utilities updateLocalData:dic];
                [self updateRedPoint:dic];
            }
            
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];

}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"ClassDetailTableViewCell";
    
    ClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"ClassDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.delegate = self;
    cell.row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSArray *subjectArray = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"list"];
    
    // 以下数据等后台接口写好后需要修改
    int type  = [[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"type"]] intValue];

    
    NSString *iconImgUrl = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"icon"];
    NSString *title = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSMutableArray *noteArray = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"note"];
    NSMutableArray *extraArray = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"extra"];
    
    NSString *detailStr = [self getCompleteStr:noteArray];
    NSString *descriptionStr = [self getCompleteStr:extraArray];
    
    NSMutableAttributedString *detail;
    
    //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
        
        if ([spaceForClass integerValue] == 1) {//班级绑定了学籍
            
            if ([isNumber integerValue] == 0 || isNumber == nil) {
                
                if (type == 8 || type == 26 || type == 30) {
                    
                    cell.titleLab.textColor = [UIColor grayColor];
                    detail = [[NSMutableAttributedString alloc] initWithString:detailStr];
                    
                }else{
                    
                    detail = [self getAttributedStr:noteArray completeStr:detailStr];
                    cell.titleLab.textColor = [UIColor blackColor];
                }
                
            }else{
                
                detail = [self getAttributedStr:noteArray completeStr:detailStr];
                cell.titleLab.textColor = [UIColor blackColor];
                
            }
            
        }else{
            
            if (type == 26 || type == 30) {
                
                cell.titleLab.textColor = [UIColor grayColor];
                detail = [[NSMutableAttributedString alloc] initWithString:detailStr];
                
            }else{
                
                detail = [self getAttributedStr:noteArray completeStr:detailStr];
                cell.titleLab.textColor = [UIColor blackColor];
            }
        }
        
        
    }else{
        
        detail = [self getAttributedStr:noteArray completeStr:detailStr];
        cell.titleLab.textColor = [UIColor blackColor];
        
    }
    
    //-------------------------------------
    
    NSMutableAttributedString *description = [self getAttributedStr:extraArray completeStr:descriptionStr];
    
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:iconImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
    cell.detailLab.textColor = [UIColor grayColor];
    cell.descriptionLab.textColor = [UIColor grayColor];
    cell.noteLabel.textColor = [UIColor grayColor];
    
    // 作业改版，隐藏作业时间
    if (8 == type) {
        cell.descriptionLab.hidden = YES;
    }
    
    if (redImgArray) {
        
        if ([redImgArray count]>0) {
            
            if ([[redImgArray objectAtIndex:indexPath.row] integerValue] == 1) {
                cell.redImg.image = [UIImage imageNamed:@"icon_new.png"];
            }else{
                cell.redImg.image = nil;
            }
            
        }
        
    }else{
        cell.redImg.image = nil;
    }
    
    if ([extraArray count] == 1) {
        
        NSString *labelStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[extraArray objectAtIndex:0] objectForKey:@"label"]]];
        
        if([labelStr isEqualToString:@""]){
            cell.titleLab.text = title;
            cell.detailLab.text = @"";
            cell.descriptionLab.text = @"";
            cell.noteLabel.attributedText = detail;
        }else{
            
            cell.titleLab.text = title;
            cell.detailLab.attributedText = detail;
            if (type == 14) {//班级公告
                cell.detailLab.textColor = [UIColor colorWithRed:26.0/255.0 green:127.0/255.0 blue:207.0/255.0 alpha:1];
            }else{
                cell.detailLab.textColor = [UIColor lightGrayColor];
            }
            cell.descriptionLab.attributedText = description;
            cell.noteLabel.text = @"";

        }
        
    }else{
        
        cell.titleLab.text = title;
        if (type == 14) {//班级公告
            cell.detailLab.textColor = [UIColor colorWithRed:26.0/255.0 green:127.0/255.0 blue:207.0/255.0 alpha:1];
        }else{
            cell.detailLab.textColor = [UIColor lightGrayColor];
        }
        cell.detailLab.attributedText = detail;
        cell.descriptionLab.attributedText = description;
        cell.noteLabel.text = @"";
        
    }
    

#if 0
    //2015.11.02 2.9.1新需求 不要表格形式
    if (type == 7) {
        
        cell.subjectTableView.hidden = NO;
        
        if ([subjectArray count]>0) {
            
            cell.subjectLabel0.text = [Utilities replaceNull:[subjectArray objectAtIndex:0]];
            cell.subjectLabel1.text = [Utilities replaceNull:[subjectArray objectAtIndex:1]];
            cell.subjectLabel2.text = [Utilities replaceNull:[subjectArray objectAtIndex:2]];
            cell.subjectLabel3.text = [Utilities replaceNull:[subjectArray objectAtIndex:3]];
            cell.subjectLabel4.text = [Utilities replaceNull:[subjectArray objectAtIndex:4]];
            cell.subjectLabel5.text = [Utilities replaceNull:[subjectArray objectAtIndex:5]];
            cell.subjectLabel6.text = [Utilities replaceNull:[subjectArray objectAtIndex:6]];
            cell.subjectLabel7.text = [Utilities replaceNull:[subjectArray objectAtIndex:7]];
            cell.subjectLabel8.text = [Utilities replaceNull:[subjectArray objectAtIndex:8]];
            cell.subjectLabel9.text = [Utilities replaceNull:[subjectArray objectAtIndex:9]];
        }
       
        cell.noteLabel.text = @"";
        
    }else{
        cell.subjectTableView.hidden = YES;

    }
#endif
    
    cell.subjectTableView.hidden = YES;//2015.11.02 2.9.1新需求 不要表格形式
    
 #if 0 //2015.11.02 班级公告不显示评论 2.9.1新需求
    if (type == 14) {
        
        float height = 0.0;
        NSMutableArray *array = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"announcements"];
        if ([array count] == 0) {
            cell.commentsV.hidden = YES;
        }else{
        

            cell.commentsV.hidden = NO;
            if ([array count] == 1){
                height = 26.0;
                cell.commentLabel1.text = [[array objectAtIndex:0] objectForKey:@"subject"];
                cell.dateLabel1.text =  [[array objectAtIndex:0] objectForKey:@"dateline"];
                cell.dateLabel2.hidden = YES;
                cell.dateLabel3.hidden = YES;
                cell.commentLabel2.hidden = YES;
                cell.commentLabel3.hidden = YES;
                cell.commnetBtn2.hidden = YES;
                cell.commnetBtn3.hidden = YES;
                cell.lineV1.hidden = YES;
                cell.lineV2.hidden = YES;
                
            }else if ([array count] == 2){
                height = 26.0*2+1;
                cell.commentLabel1.text = [[array objectAtIndex:0] objectForKey:@"subject"];
                cell.commentLabel2.text = [[array objectAtIndex:1] objectForKey:@"subject"];
                cell.dateLabel1.text =  [[array objectAtIndex:0] objectForKey:@"dateline"];
                cell.dateLabel2.text =  [[array objectAtIndex:1] objectForKey:@"dateline"];
                cell.dateLabel2.hidden = NO;
                cell.commentLabel2.hidden = NO;
                cell.commnetBtn2.hidden = NO;
                cell.commentLabel3.hidden = YES;
                cell.dateLabel3.hidden = YES;
                cell.commnetBtn3.hidden = YES;
                cell.lineV2.hidden = YES;
                cell.lineV1.hidden = NO;
                
            }else{
                height = 80.0;
                cell.commentLabel1.text = [[array objectAtIndex:0] objectForKey:@"subject"];
                cell.commentLabel2.text = [[array objectAtIndex:1] objectForKey:@"subject"];
                cell.commentLabel3.text = [[array objectAtIndex:2] objectForKey:@"subject"];
                cell.dateLabel1.text =  [[array objectAtIndex:0] objectForKey:@"dateline"];
                cell.dateLabel2.text =  [[array objectAtIndex:1] objectForKey:@"dateline"];
                cell.dateLabel3.text =  [[array objectAtIndex:2] objectForKey:@"dateline"];
                cell.dateLabel2.hidden = NO;
                cell.dateLabel3.hidden = NO;
                cell.commentLabel2.hidden = NO;
                cell.commentLabel3.hidden = NO;
                cell.commnetBtn2.hidden = NO;
                cell.commnetBtn3.hidden = NO;
                cell.lineV2.hidden = NO;
                cell.lineV1.hidden = NO;
                
            }

            cell.commentsV.frame = CGRectMake(0, 80.0, [UIScreen mainScreen].bounds.size.width, height);
        }
        
    }else{
        
         cell.commentsV.hidden = YES;
    }
#endif
    
    cell.commentsV.frame = CGRectMake(0, 80.0, [UIScreen mainScreen].bounds.size.width, 0.0);
    cell.commentsV.hidden = YES;//2015.11.02 班级公告不显示评论 2.9.1新需求
    
    if (type == 22) {// 群聊
        
        groupChatIndex = indexPath.row;
        
        /*去掉new标实
         NSString *isNewForGroupChat = [[NSUserDefaults standardUserDefaults]objectForKey:@"isNewForGroupChat"];
        
        if (!isNewForGroupChat) {
            
            cell.imgViewNew.hidden = NO;
            
            if ([title length]*16 > cell.titleLab.frame.size.width) {
                 cell.imgViewNew.frame = CGRectMake(cell.titleLab.frame.size.width+73 -10, cell.titleLab.frame.origin.y, 32, 20);
            }else{
                 cell.imgViewNew.frame = CGRectMake([title length]*16+73, cell.titleLab.frame.origin.y, 32, 20);
            }
            
            cell.imgViewNew.image = [UIImage imageNamed:@"icon_forNew.png"];
           
        }else{
            
            cell.imgViewNew.hidden = YES;
        }*/
        
    }else{
        //cell.imgViewNew.hidden = YES;
    }
    
    if (type == 26) {//成长空间
        
        cell.isFreeBtn.hidden = NO;
        
         NSString *spaceStatus =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"status"]];
        
        //开通状态：未开通、试用、正常、欠费，试用期结束
        // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
        
        if ([spaceStatus integerValue] == 0) {//未开通
            
            [cell.isFreeBtn setTitle:@"未开通" forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateHighlighted];
            
        }else if ([spaceStatus integerValue] == 2){//试用
            
            [cell.isFreeBtn setTitle:@"试用" forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
            
        }else if ([spaceStatus integerValue] == 3 || [spaceStatus integerValue] == 4){//续费
            
            [cell.isFreeBtn setTitle:@"待续费" forState:UIControlStateNormal];
            cell.isFreeBtn.layer.masksToBounds = YES;
            cell.isFreeBtn.layer.cornerRadius = 3.0;
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateHighlighted];
        }else{
            
            [cell.isFreeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.isFreeBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
            [cell.isFreeBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
    }else{
        cell.isFreeBtn.hidden = YES;
    }
    
    if ([spaceForClass integerValue] == 1) {
        
        if (type == 30) {
            
            //请假new标实
            NSString *isNewForLeave = [[NSUserDefaults standardUserDefaults]objectForKey:@"isNewForLeave"];
            
            if (!isNewForLeave) {
                
                cell.imgViewNew.hidden = NO;
                
                CGSize strSize = [Utilities getStringHeight:cell.titleLab.text andFont:[UIFont systemFontOfSize:16.0] andSize:CGSizeMake(0, 21.0)];
                
                if ([title length]*16 > cell.titleLab.frame.size.width) {
                    cell.imgViewNew.frame = CGRectMake(cell.titleLab.frame.size.width+73 -10, cell.titleLab.frame.origin.y, 32, 20);
                    
                }else{
                    cell.imgViewNew.frame = CGRectMake(strSize.width+73, cell.titleLab.frame.origin.y, 32, 20);
                }
                
                cell.imgViewNew.image = [UIImage imageNamed:@"icon_forNew.png"];
                
            }else{
                
                cell.imgViewNew.hidden = YES;
            }
            
        }else if (type == 8){
            
            //作业new标实
            NSString *isNewForHome = [[NSUserDefaults standardUserDefaults]objectForKey:@"isNewForHome"];
            
            if (!isNewForHome) {
                
                cell.imgViewNew.hidden = NO;
                
                CGSize strSize = [Utilities getStringHeight:cell.titleLab.text andFont:[UIFont systemFontOfSize:16.0] andSize:CGSizeMake(0, 21.0)];
                
                if ([title length]*16 > cell.titleLab.frame.size.width) {
                    cell.imgViewNew.frame = CGRectMake(cell.titleLab.frame.size.width+73 -10, cell.titleLab.frame.origin.y, 32, 20);
                    
                }else{
                    cell.imgViewNew.frame = CGRectMake(strSize.width+73, cell.titleLab.frame.origin.y, 32, 20);
                }
                
                cell.imgViewNew.image = [UIImage imageNamed:@"icon_forNew.png"];
                
            }else{
                
                cell.imgViewNew.hidden = YES;
            }
            
        }else if (type == 26){
            
            //作业new标实
            NSString *isNewForHome = [[NSUserDefaults standardUserDefaults]objectForKey:@"isNewForSpace"];
            
            if (!isNewForHome) {
                
                cell.imgViewNew.hidden = NO;
                
                CGSize strSize = [Utilities getStringHeight:cell.titleLab.text andFont:[UIFont systemFontOfSize:16.0] andSize:CGSizeMake(0, 21.0)];
                
                if ([title length]*16 > cell.titleLab.frame.size.width) {
                    cell.imgViewNew.frame = CGRectMake(cell.titleLab.frame.size.width+73 -10, cell.titleLab.frame.origin.y, 32, 20);
                    
                }else{
                    cell.imgViewNew.frame = CGRectMake(strSize.width+73, cell.titleLab.frame.origin.y, 32, 20);
                }
                
                cell.imgViewNew.image = [UIImage imageNamed:@"icon_forNew.png"];
                
            }else{
                
                cell.imgViewNew.hidden = YES;
            }
            
        }else{
            
            cell.imgViewNew.hidden = YES;
        }
    }else{
        
        cell.imgViewNew.hidden = YES;
    }
    
    
    //NSLog(@"groupChatIndex:%d",groupChatIndex);
    return cell;
    
}


//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    int type  = [[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"type"]] intValue];
    
    NSString *titleName  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString *mid  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"id"]];

    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    switch(type){
            case 30: //请假
            {
                [ReportObject event:ID_OPEN_CLASS_LEAVE];

                NSDictionary *user = [g_userInfo getUserDetailInfo];
                NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                
                if ([usertype integerValue] == 0 || [usertype integerValue] == 6){

                    // 请假
                    //                    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithDictionary:[displayArray objectAtIndex:indexPath.row]];
                    
                    if ([spaceForClass integerValue] == 1) {
                    
                        //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
                        if ([isNumber integerValue] == 0 || isNumber == nil) {
                            
                        }else{
                            
                            NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"url"]]]];
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
                            
                            NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@&uid=%@&sid=%@&cid=%@&grade=%@",tempUrl, api, love, key, uid, G_SCHOOL_ID, _cId, usertype];
                            
                            //                        NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", newUrl, _cId, usertype];
                            
                            
                            //                        NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", url, _cId, usertype];
                            
                            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                            fileViewer.requestURL = newUrl;
                            fileViewer.titleName = @"";
                            fileViewer.isShowSubmenu = @"0";
                            fileViewer.isRotate = @"1";
                            [self.navigationController pushViewController:fileViewer animated:YES];
                         
                                //isNewForLeave
                                [userDefault setObject:@"1" forKey:@"isNewForLeave"];
                            
                        }

                        
                    }
                    
                }else{
                    
                    NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"url"]]]];
                    NSString *url = [Utilities appendUrlParams:tempUrl];
                    
                    NSString *reqUrl = [NSString stringWithFormat:@"%@&cid=%@&grade=%@", url, _cId, usertype];
                    
                    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                    fileViewer.requestURL = reqUrl;
                    fileViewer.titleName = @"";
                    fileViewer.isShowSubmenu = @"0";
                    fileViewer.isRotate = @"1";
                    [self.navigationController pushViewController:fileViewer animated:YES];
                    
                     if ([spaceForClass integerValue] == 1) {
                    //isNewForLeave
                         [userDefault setObject:@"1" forKey:@"isNewForLeave"];
                     }
                    
                   [Utilities updateClassRedPoints:_cId last:lastLeaveId mid:mid];//更新请假红点 只有老师有红点 tony确认
                }
            }
            break;
            case 29:
                // 成长空间管理
                // 这里限制了除了学生与家长外可以看
                if ((0 != [usertype integerValue]) && (6 != [usertype integerValue])) {
                    [ReportObject event:ID_OPEN_SPACE_LIST];

                    StudentsStatusListViewController *vc = [[StudentsStatusListViewController alloc]init];
                    vc.cid = _cId;
                    vc.titleName = titleName;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 13:// 班级讨论区
               [self gotoClassDiscussViewList:titleName];
            break;
            
            case 14:// 班级公告
              [self goToPublic:titleName mid:mid];
            break;
            
            case 17:// 同步课堂
               [self.view makeToast:@"敬请期待"
                        duration:0.5
                        position:@"center"
                           title:nil];
            break;
            
            case 18:// 班级成员
               [self gotoClassmate:titleName];
            break;
            
            case 19:// 班级动态
             [self gotoClassNews:titleName mid:mid];
            break;
            
            case 7:// 课程表
               [self gotoSchedule:titleName];
            break;
            
            case 8:// 作业
        {
            if ([usertype integerValue] == 0 || [usertype integerValue] == 6){
                //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
                
                if ([spaceForClass integerValue] == 1) {
                    
                    if ([isNumber integerValue] == 0 || isNumber == nil) {
                        
                    }else{
                        [self gotoHomework:titleName mid:mid];
                        if ([spaceForClass integerValue] == 1){
                            //isNewForHome
                            [userDefault setObject:@"1" forKey:@"isNewForHome"];
                        }
                       
                    }
                    
                }else{
                    
                    [self gotoHomework:titleName mid:mid];
                    
                }
              
            }else{
                
                [self gotoHomework:titleName mid:mid];
                if ([spaceForClass integerValue] == 1){
                
                    //isNewForHome
                    [userDefault setObject:@"1" forKey:@"isNewForHome"];
                }

            }
            
        }
            break;
            
            case 22:// 我的群聊模块 type值需要变更 add by kate 2015.05.27
           {
               
               NSArray *array = [_tableView visibleCells];
               for (ClassDetailTableViewCell *cell in array) {
                     cell.imgViewNew.image = nil;
               }
               
               [self gotoMyGroupChat:titleName];
            }
            break;
            
        case 26:{//成长空间
            
            if ([spaceForClass integerValue] == 1) {
               
                //---2.9.4迭代3需求 未绑定学籍 作业与成长空间 title 和 subTitle字体变灰 不可点击
                if ([isNumber integerValue] == 0 || isNumber == nil) {
                    
                }else{
                    
                    if ([usertype integerValue] == 0  || [usertype integerValue] == 6) {
                        // 用于判断老用户是否绑定
                        NSString *number =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"number"]];
                        if ([number integerValue] == 0) {//未绑定
                            //弹出提示框 取消 绑定
                            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未绑定学籍信息，无法使用成长空间" delegate:self cancelButtonTitle:@"立即绑定" otherButtonTitles:@"暂不绑定", nil];
                            alertV.tag = 126;
                            [alertV show];
                            
                        }else{
                            
                            NSString *url = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"url"] objectForKey:@"help"]]];
                            
                            NSString *spaceStatus =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"status"]];
                            NSString *trial = [NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"trial"]];//2015.12.21
                            NSString *growthInfo = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"trial"]]];
                            NSLog(@"growthInfo:%@",growthInfo);
                            
                            if ([spaceStatus integerValue] == 0 && [trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
                                [self gotoPayView:url status:spaceStatus trial:trial];
                                
                                [userDefault setObject:@"1" forKey:@"isNewForSpace"];
                            }else{
                                [self gotoGrowthSpace:url status:spaceStatus mid:mid trial:trial growthInfo:growthInfo];
                                [userDefault setObject:@"1" forKey:@"isNewForSpace"];
                            }
                            
                            
                        }
                    }else{
                        
                        [self.view makeToast:@"敬请期待"
                                    duration:0.5
                                    position:@"center"
                                       title:nil];
                    }
                }
                
            }
            
        }
            break;
            
        
    }
    
    if([_fromName isEqualToString:@"tab"]){
        
        if (type == 13 || type == 14 || type == 18 || type == 19 || type == 7 || type == 8 || type == 22 || type == 26) {
            
            if (type == 26 || type == 8) {
                
                if ([usertype integerValue] == 0  || [usertype integerValue] == 6){
//                    NSString *number =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:indexPath.row] objectForKey:@"space"] objectForKey:@"number"]];
                    
                    if ([isNumber integerValue] == 0) {//未绑定
                        
                    }else{
                        [MyTabBarController setTabBarHidden:YES];
                    }
                }else{
                    
                    if ([isNumber integerValue] == 0) {//未绑定
                        
                    }else{
                        [MyTabBarController setTabBarHidden:YES];
                    }
                }
                
            }else{
                [MyTabBarController setTabBarHidden:YES];
            }
            
        }else{
           
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height = 80.0;
    
#if 0 //2015.11.02 班级公告不显示评论 2.9.1新需求
    int type  = [[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:indexPath.row] objectForKey:@"type"]] intValue];
    
    if (type == 14) {
        
        NSMutableArray *array = [[displayArray objectAtIndex:indexPath.row] objectForKey:@"announcements"];
        if ([array count] == 0) {
            height = 80.0;
        }else if ([array count] == 1){
            height = 80.0+26.0;
        }else if ([array count] == 2){
            height = 80.0+26.0*2+1;
        }else{
            height = 80.0+80.0;
        }
        
    }else{
        
        height = 80.0;
    }
#endif
    return height;
}

// 去班级动态
-(IBAction)gotoClassNews:(NSString*)titleName mid:(NSString*)mid{
    
    MomentsViewController *momentsViewCtrl = [[MomentsViewController alloc] init];
    momentsViewCtrl.titleName = titleName;
    momentsViewCtrl.fromName = @"class";
    momentsViewCtrl.cid = _cId;
    momentsViewCtrl.classCid = _cId;
    momentsViewCtrl.cName = _classNameLab.text;
    momentsViewCtrl.isAdmin = _isAdmin;
    momentsViewCtrl.mid = mid;
    momentsViewCtrl.lastMsgId = lastMsgId;
    [self.navigationController pushViewController:momentsViewCtrl animated:YES];

}

// 去班级公告
- (IBAction)goToPublic:(NSString*)titleName mid:(NSString*)mid{
    
    //_publicBtn.backgroundColor = [UIColor lightGrayColor];
    //_publicBtn.alpha = 0.4;
    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
    cladddisV.titleName = titleName;
    cladddisV.cId = _cId;
    cladddisV.mid  = mid;
    [self.navigationController pushViewController:cladddisV animated:YES];
    
    [ReportObject event:ID_OPEN_CLASS_NEWS_LIST];//2015.06.24
}

// 去作业
- (IBAction)gotoHomework:(NSString*)titleName mid:(NSString*)mid{
    
    //_homeworkBtn.backgroundColor = [UIColor lightGrayColor];
    //_homeworkBtn.alpha = 0.4;
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 判断当前用户类别，1为老师，0为学生，2为家长
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
    //NSString *class = [user objectForKey:@"class"];
    
    // 管理员和老师可以发作业 其他身份都不可以发作业 志伟春晖确认 2015.11.24
    if([@"7"  isEqual: usertype])
    {
        NSString *checked = [user objectForKey:@"checked"];
        
        if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
            [self.view makeToast:@"您还未获得教师身份，请递交申请."
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
        else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
            [self.view makeToast:@"请耐心等待审批."
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
        else
        {
            //            if ([@""  isEqual: class]) {
            //                [self.view makeToast:@"还未加入任何班级，无法查看作业."
            //                            duration:0.5
            //                            position:@"center"
            //                               title:nil];
            //} else {
            //                HomeWorkClassSelectViewController *homeworkSelViewCtrl = [[HomeWorkClassSelectViewController alloc] init];
            //                [self.navigationController pushViewController:homeworkSelViewCtrl animated:YES];
            //------update 2015.11.24-------------------------------------------------------
            //HomeworkViewController *homeworkViewCtrl = [[HomeworkViewController alloc] init];
            HomeworkForTeacherViewController *homeworkViewCtrl = [[HomeworkForTeacherViewController alloc]init];
            homeworkViewCtrl.titleName = titleName;
            homeworkViewCtrl.cid = _cId;
            homeworkViewCtrl.mid = mid;
            homeworkViewCtrl.spaceForClass = spaceForClass;//2016.03.07
            [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
            //--------------------------------------------------------------------------------
                        //}
        }
    }else if ([@"9"  isEqual: usertype]){
        
        HomeworkForTeacherViewController *homeworkViewCtrl = [[HomeworkForTeacherViewController alloc]init];
        homeworkViewCtrl.titleName = titleName;
        homeworkViewCtrl.cid = _cId;
        homeworkViewCtrl.mid = mid;
        homeworkViewCtrl.spaceForClass = spaceForClass;//2016.03.07
        [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
        
    }
    else
    {
        //        if ([@""  isEqual: class]) {
        //            [self.view makeToast:@"还未加入任何班级，无法查看作业."
        //                        duration:0.5
        //                        position:@"center"
        //                           title:nil];
        //        } else {
        //------------update 2015.11.24----------------------------------------------------
        //HomeworkViewController *homeworkViewCtrl = [[HomeworkViewController alloc] init];
        HomewWorkHomeViewController *homeworkViewCtrl = [[HomewWorkHomeViewController alloc]init];
        homeworkViewCtrl.titleName = titleName;
        homeworkViewCtrl.cid = _cId;
        homeworkViewCtrl.mid = mid;
        homeworkViewCtrl.spaceForClass = spaceForClass;//2016.03.07
        [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
        //-------------------------------------------------------------------------------
        //        }
    }
}

// 去课程表
- (IBAction)gotoSchedule:(NSString*)titleName {
    
    //_scheduleBtn.backgroundColor = [UIColor lightGrayColor];
    //_scheduleBtn.alpha = 0.4;
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    // 课表
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 判断当前用户类别，7为老师，0为学生，2为家长
    
    // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
    
    NSString *checked = [user objectForKey:@"checked"];
    //    NSString *class = [user objectForKey:@"class"];
    //    NSString *cid = nil;
    
    
    if([@"7"  isEqual: usertype])
    {
        if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
            [self.view makeToast:@"您还未获得教师身份，请递交申请."
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
        else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", checked]])
        {
            [self.view makeToast:@"请耐心等待审批."
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
        else
        {
            
            ScheduleDetailViewController *scheduleViewCtrl = [[ScheduleDetailViewController alloc] init];
            scheduleViewCtrl.classid = _cId;
            scheduleViewCtrl.titleName = titleName;
            [self.navigationController pushViewController:scheduleViewCtrl animated:YES];
            
        }
    }
    else
    {
        
        ScheduleDetailViewController *scheduleViewCtrl = [[ScheduleDetailViewController alloc] init];
        scheduleViewCtrl.classid = _cId;
         scheduleViewCtrl.titleName = titleName;
        [self.navigationController pushViewController:scheduleViewCtrl animated:YES];
        
    }
    
}
// 去通讯录
- (IBAction)gotoClassmate:(NSString*)titleName
{
    /*PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
    friendViewCtrl.classid = _cId;
    friendViewCtrl.titleName = titleName;
    [self.navigationController pushViewController:friendViewCtrl animated:YES];
    */
    
    MemberListViewController *memberList = [[MemberListViewController alloc]init];
    memberList.titleName = titleName;
    memberList.cId = _cId;
    [self.navigationController pushViewController:memberList animated:YES];
    
}

// 去班级讨论区列表
- (IBAction)gotoClassDiscussViewList:(NSString*)titleName {
    
    /*DiscussViewController *discussViewCtrl = [[DiscussViewController alloc] init];
    discussViewCtrl.fromName = @"classDiscuss";
    discussViewCtrl.titleName = titleName;
    discussViewCtrl.cId = _cId;
    [self.navigationController pushViewController:discussViewCtrl animated:YES];*/
    
    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
    cladddisV.fromName = @"classDiscuss";
    cladddisV.cId = _cId;
    cladddisV.titleName = titleName;
    [self.navigationController pushViewController:cladddisV animated:YES];
    
    [ReportObject event:ID_OPEN_CLASS_THREAD_LIST];// 2015.06.24
}

// 去我的群聊模块
-(void)gotoMyGroupChat:(NSString*)titleName{
    
    /*去掉new标实
     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isNewForGroupChat"];
    [[NSUserDefaults standardUserDefaults]synchronize];*/
    
    MyGroupMsgListViewController *mgmlv = [[MyGroupMsgListViewController alloc]init];
    mgmlv.titleName = titleName;
    mgmlv.cid = _cId;
    [self.navigationController pushViewController:mgmlv animated:YES];
    
}

// 去成长空间
-(void)gotoGrowthSpace:(NSString*)urlStr status:(NSString*)status mid:(NSString*)mid trial:(NSString*)trial growthInfo:(NSString*)growthInfo{
    
    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
    growVC.cId = _cId;
    growVC.urlStr = urlStr;
    growVC.spaceStatus = status;
    growVC.mid = mid;
    growVC.redPointDic = redPointDic;
    growVC.isTrial = trial;
    growVC.growthInfo = growthInfo;
    [self.navigationController pushViewController:growVC animated:YES];
    
}

// 去成长空间支付状态页 2015.12.21
-(void)gotoPayView:(NSString*)urlStr status:(NSString*)status trial:(NSString*)trial{
    
    PayViewController *growVC = [[PayViewController alloc] init];
    growVC.fromName = @"class";
    growVC.cId = _cId;
    growVC.urlStr = urlStr;
    growVC.spaceStatus = status;
    growVC.redPointDic = redPointDic;
    growVC.isTrial = trial;
    [self.navigationController pushViewController:growVC animated:YES];
    
}

-(void)selectRightAction:(id)sender
{
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    // 课表
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        //UIView * mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        //mask.backgroundColor =[UIColor clearColor];
        //mask.opaque = NO;
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        //NSLog(@"%hhd",_isAdmin);
        
        if(_isAdmin){
            // 选项菜单
            if([usertype intValue] == 9){
                
                imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                  [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                                  5,
                                                                                  128,
                                                                                  40*4)];
                imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
                
            }else{
                imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                  [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                                  5,
                                                                                  128,
                                                                                  40*3)];
                imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
            }
            
            
            [imageView_rightMenu setImage:[UIImage imageNamed:@"friend/bg_contacts_more.png"]];
        }else{
            
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                              5,
                                                                              128,
                                                                              45)];
            imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
            [imageView_rightMenu setImage:[UIImage imageNamed:@"bg_contacts_single.png"]];
        }
        
        
        
        // 搜索button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x,
                                         imageView_rightMenu.frame.origin.y + 18,
                                         108,
                                         32);
        
        UIImage *buttonImg_d;
        UIImage *buttonImg_p;
        
        //CGSize tagSize = CGSizeMake(20, 20);
        
        buttonImg_d = [UIImage imageNamed:@"icon_bjzl_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_bjzl_p.png"];
        
        [button_search setImage:buttonImg_d forState:UIControlStateNormal];
        [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_search setTitle:@"编辑资料" forState:UIControlStateNormal];
        [button_search setTitle:@"编辑资料" forState:UIControlStateHighlighted];
        
        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_search setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_search addTarget:self action:@selector(gotoEdit) forControlEvents: UIControlEventTouchUpInside];
        
        // 管理成员button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x,
                                            button_search.frame.origin.y + button_search.frame.size.height,
                                            108,
                                            32);
        
        buttonImg_d = [UIImage imageNamed:@"icon_glcy_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_glcy_p.png"];
        
        [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_multiSend setTitle:@"管理成员" forState:UIControlStateNormal];
        [button_multiSend setTitle:@"管理成员" forState:UIControlStateHighlighted];
        
        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_multiSend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_multiSend addTarget:self action:@selector(gotoMemberList) forControlEvents: UIControlEventTouchUpInside];
        
        // 管理员设置button
        button_setAdmin = [UIButton buttonWithType:UIButtonTypeCustom];
        button_setAdmin.frame = CGRectMake(
                                           button_multiSend.frame.origin.x,
                                           button_multiSend.frame.origin.y + button_multiSend.frame.size.height,
                                           120,
                                           32);
        
        buttonImg_d = [UIImage imageNamed:@"icon_szgly_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_szgly_p.png"];
        
        [button_setAdmin setImage:buttonImg_d forState:UIControlStateNormal];
        [button_setAdmin setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_setAdmin setTitle:@"管理员设置" forState:UIControlStateNormal];
        [button_setAdmin setTitle:@"管理员设置" forState:UIControlStateHighlighted];
        
        button_setAdmin.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_setAdmin setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_setAdmin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_setAdmin setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_setAdmin.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_setAdmin addTarget:self action:@selector(gotoSetAdminMemberList) forControlEvents: UIControlEventTouchUpInside];
        
        // 添加朋友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(_isAdmin){
            
            if([usertype intValue] == 9){
                
                button_addFriend.frame = CGRectMake(
                                                    button_setAdmin.frame.origin.x,
                                                    button_setAdmin.frame.origin.y + button_setAdmin.frame.size.height,
                                                    108,
                                                    32);
                
            }else{
                
                button_addFriend.frame = CGRectMake(
                                                    button_multiSend.frame.origin.x,
                                                    button_multiSend.frame.origin.y + button_multiSend.frame.size.height,
                                                    108,
                                                    32);
            }
            
            
            
        }else{
            
            button_addFriend.frame = CGRectMake(
                                                imageView_rightMenu.frame.origin.x,
                                                imageView_rightMenu.frame.origin.y + 10,
                                                108,
                                                32);
        }
        
        buttonImg_d = [UIImage imageNamed:@"icon_tcbj_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_tcbj_p.png"];
        
        [button_addFriend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        if ([@"bureau" isEqualToString:schoolType]) {
            [button_addFriend setTitle:@"退出部门" forState:UIControlStateNormal];
            [button_addFriend setTitle:@"退出部门" forState:UIControlStateHighlighted];
        }else{
            [button_addFriend setTitle:@"退出班级" forState:UIControlStateNormal];
            [button_addFriend setTitle:@"退出班级" forState:UIControlStateHighlighted];
        }
        
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_addFriend addTarget:self action:@selector(quitFromClass) forControlEvents: UIControlEventTouchUpInside];
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        if(_isAdmin){
            
            if([usertype intValue] == 9){
                
                [imageView_bgMask addSubview:button_search];
                [imageView_bgMask addSubview:button_multiSend];
                [imageView_bgMask addSubview:button_setAdmin];
                [imageView_bgMask addSubview:button_addFriend];
                
            }else{
                
                [imageView_bgMask addSubview:button_search];
                [imageView_bgMask addSubview:button_multiSend];
                [imageView_bgMask addSubview:button_addFriend];
                
            }
            
        }else{
            
            [imageView_bgMask addSubview:button_addFriend];
        }
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
}

-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

// 去管理员设置页
-(void)gotoSetAdminMemberList{
    
    SetAdminMemberListViewController *setAdminLV = [[SetAdminMemberListViewController alloc]init];
    setAdminLV.cId= _cId;
    [self.navigationController pushViewController:setAdminLV animated:YES];
}

// 去资料编辑
-(void)gotoEdit{
    
    EditClassInfoViewController *editV = [[EditClassInfoViewController alloc] init];
    editV.cId = _cId;
    [self.navigationController pushViewController:editV animated:YES];
}

// 去成员列表
-(void)gotoMemberList{
    
    MemberListViewController *memberV = [[MemberListViewController alloc]init];
    memberV.cId = _cId;
    memberV.titleName = @"成员管理";
    [self.navigationController pushViewController:memberV animated:YES];
    
}

// 退出班级
-(void)quitFromClass{
    
    [self dismissKeyboard:nil];
    NSString *msg = @"您确定要退出该班级？";
    if ([@"bureau" isEqualToString:schoolType]) {
        msg = @"您确定要退出该部门？";
    }
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:msg
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消",nil];
    alert.tag = 122;
    [alert show];
    
    
}

-(void)quit{
    
    // 调用退出班级接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils quitFromClass:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSDictionary *user = [g_userInfo getUserDetailInfo];
                NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                //if ([@"6" isEqualToString:usertype] || [@"0" isEqualToString:usertype]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
               // }
                //-----add by kate for beck----------------------------------
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                [userDetail setObject:@"0" forKey:@"role_cid"];
                
                [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //-----------------------------------------------------------
                 if([_fromName isEqualToString:@"tab"]){
                
                   MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
                   
                   UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
                     
                   MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                   NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
                  [array replaceObjectAtIndex:1 withObject:customizationNavi];
                     [appDelegate.tabBarController setViewControllers:array];
                     
                     //---2016.02.26----------------------------------------------------------------
                     [noticeImgVForMsg removeFromSuperview];
                     [noticeImgVForMsg removeFromSuperview];
                     
                     UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:1];
                     UIImageView *detailImg = (UIImageView*)[button viewWithTag:456];
                     UIImageView *listImg = (UIImageView*)[button viewWithTag:123];
                     
                     [detailImg removeFromSuperview];
                     [listImg removeFromSuperview];
                     //-------------------------------------------------------------------------------
                     
                 }else{
                     
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }
                
                //--退出班级将原来班级详情页/班级列表页现有未读红点全部清空 赵经纬 李昌明 张昊天 确认 kate被迫修改 2016.02.26-----------
                
                [self deleteTableForGroupMsg:_cId];//清空群聊红点消息
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *alwaysNewsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"alwaysNewsDic"]];
                NSArray *classArray = [alwaysNewsDic objectForKey:@"classes"];
                
                NSMutableDictionary *defaultsDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"allLastIdDic"]];
                NSMutableDictionary *classLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"classLastDicDefault"]];
                
                for (int i = 0 ; i<[classArray count]; i++) {
                    
                        NSString *mid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"mid"]];
                        NSString *cid = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"cid"]];
                        NSString *last = [NSString stringWithFormat:@"%@",[[classArray objectAtIndex:i] objectForKey:@"last"]];
                        
                        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                        [classLastDicDefault setObject:last forKey:keyStr];
                        
                    
                    
                }
                
                
                [defaultsDic setObject:classLastDicDefault forKey:@"classLastDicDefault"];//转化成字典数据
                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                [userDefaults synchronize];
                
                NSArray *spacesArray = [alwaysNewsDic objectForKey:@"spaces"];
                NSMutableDictionary *spaceLastDicDefault = [[NSMutableDictionary alloc] initWithDictionary:[defaultsDic objectForKey:@"spaceLastDicDefault"]];
                
                for (int i = 0 ; i<[spacesArray count]; i++) {
                    
                        NSString *mid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"mid"]];
                        NSString *cid = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"cid"]];
                        NSString *last = [NSString stringWithFormat:@"%@",[[spacesArray objectAtIndex:i] objectForKey:@"last"]];
                        
                        NSString *keyStr = [NSString stringWithFormat:@"%@_%@",cid,mid];
                        [spaceLastDicDefault setObject:last forKey:keyStr];
                    
                    
                }
                
                [defaultsDic setObject:spaceLastDicDefault forKey:@"spaceLastDicDefault"];//转化成字典数据
                [userDefaults setObject:defaultsDic forKey:@"allLastIdDic"];
                [userDefaults synchronize];
                
                
                //-------------------------------------------------------------------------------------------------------
                
            }
        });
    });
    
}

// 退出班级清空群聊红点 不管已读未读都删除群聊相关表 2016.02.26
-(void)deleteTableForGroupMsg:(NSString*)cid{
    
    NSString *sql =  [NSString stringWithFormat:@"select * from msgListForGroup_%lli ORDER BY timestamp DESC",[cid longLongValue]];
    NSMutableDictionary *chatsListDict = [[DBDao getDaoInstance] getDictionaryResultsByColumnName:sql];
    
    NSInteger count = [chatsListDict.allKeys count];
    
    for (int listCnt = 0; listCnt < count; listCnt++) {
        
        NSMutableDictionary *chatObjectDict = [chatsListDict objectForKey:[NSNumber numberWithInt:listCnt]];
        long long gid =[[chatObjectDict objectForKey:@"gid"] longLongValue];
        
        NSString *sql = [NSString stringWithFormat:@"delete from msgInfoForGroup_%lli ", gid];
        BOOL ret = [[DBDao getDaoInstance] executeSql:sql];
        
    }
    
    NSString *deleteListsql =  [NSString stringWithFormat:@"delete from msgListForGroup_%lli",[cid longLongValue]];
    BOOL retList = [[DBDao getDaoInstance] executeSql:deleteListsql];
    
}

#pragma ClassDetailTableViewCellDelegate
-(void)clickComment:(NSString*)indexInArray row:(NSString*)row{
    
    NSMutableArray *array  = [[displayArray objectAtIndex:[row intValue]] objectForKey:@"announcements"];
    NSString *tid = [[array objectAtIndex:[indexInArray intValue] - 100] objectForKey:@"tid"];
     NSString *titleName  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:[row intValue]] objectForKey:@"name"]];
    
    DiscussDetailViewController *disscussDetailViewCtrl = [[DiscussDetailViewController alloc] init];
    disscussDetailViewCtrl.tid = tid;
    disscussDetailViewCtrl.disTitle = titleName;
   [disscussDetailViewCtrl setFlag:2];
    [self.navigationController pushViewController:disscussDetailViewCtrl animated:YES];
    
    NSString *lastIdStr = [[array objectAtIndex:0] objectForKey:@"tid"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastDisIdDic"]];
    [tempDic setObject:lastIdStr forKey:_cId];
    [userDefaults setObject:tempDic forKey:@"lastDisIdDic"];
    [userDefaults synchronize];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 122) {
        
        if (buttonIndex == 0) {
            
            [self quit];
            [ReportObject event:ID_QUIT_CLASS];//2015.06.24
            
        }else{
            
        }
    }else if (alertView.tag == 126){
        
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
        
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (buttonIndex == 0) {
        
            [MyTabBarController setTabBarHidden:YES];

            SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
            setPVC.viewType = @"classDetail";
            setPVC.cId = _cId;
            setPVC.iden = iden;
            [self.navigationController pushViewController:setPVC animated:YES];
        
        }
        
        [userDefaults setBool:NO forKey:@"isShowPopViewForClass"];
        
    }else if (alertView.tag == 345){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"ClassDetail" forKey:@"viewName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if([_fromName isEqualToString:@"tab"]){
        [MyTabBarController setTabBarHidden:NO];
    }else{
        
    }
    
    if ([listDic count] > 0) {//2015.12.29
        [self loadClassInfo];
    }else{
         [self getMyclassInfo];
    }
   
//    [self checkNewsIcon];// 检查new标记
 //   [super hideLeftAndRightLine];
     reflashFlag = 1;
    
      [ReportObject event:ID_OPEN_MY_CLASS];// 2015.06.24
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"iosbar.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self dismissKeyboard:nil];
}


-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassListNews" object:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 字符串某一部分变色方法
-(NSMutableAttributedString*)colorString:(NSString*)string startIndex:(int)startIndex length:(int)length{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,length)];
    
    return str;
    
}

// 获取整条字符串
-(NSString*)getCompleteStr:(NSMutableArray*)array{
    
    NSString *str = @"";
    
    for(int i = 0;i<[array count];i++){
        
        str = [NSString stringWithFormat:@"%@%@",str,[[array objectAtIndex:i] objectForKey:@"label"]];
    }
    
    return str;
}

// 获取最终的变色+不变色的字符串
-(NSMutableAttributedString*)getAttributedStr:(NSMutableArray*)array completeStr:(NSString*)str{
    
    NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    int start = 0;
    int rangeLength = 0;
    
    for (int i=0; i<[array count]; i++) {
        
        start = start + rangeLength;
        NSString *str = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"label"]];
        
        rangeLength = [str length];
        
        if([@"red" isEqualToString:[[array objectAtIndex:i] objectForKey:@"color"]] ){
            
            [returnStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(start,rangeLength)];//颜色
            [returnStr addAttribute:(NSString *)kCTFontAttributeName
                                value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:14].fontName,
                                                               14,
                                                               NULL))
                                range:NSMakeRange(start,rangeLength)];//字体
//            [returnStr addAttribute:(NSString *)kCTUnderlineStyleAttributeName
//                                value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble]
//                                range:NSMakeRange(start,rangeLength)];//下划线
            
        }
       
    }
    
    return returnStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        [self loadClassInfo];
        
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

// 收notify通知替换红点数组
-(void)replaceRedImgArray{
    
    if (redImgArray == nil) {
        
        redImgArray = [[NSMutableArray alloc]init];
        
        if (displayArray) {
            
            if ([displayArray count] > 0) {
                for (int i = 0; i<[displayArray count]; i++) {
                    [redImgArray addObject:@"0"];
                }
            }
        }
        
    }else if([redImgArray count] == 0){
        
        if (displayArray) {
            
            if ([displayArray count] > 0) {
                for (int i = 0; i<[displayArray count]; i++) {
                    [redImgArray addObject:@"0"];
                }
            }
        }
        
    }
    
    if (groupChatIndex) {
        
        if ( groupChatIndex < [redImgArray count]) {//2015.09.23
            
             [redImgArray replaceObjectAtIndex:groupChatIndex withObject:@"1"];
        }
        
        [_tableView reloadData];
        
    }
    
}

/*-(void)addMaskView{
    
    [imgV removeFromSuperview];
    
   //add 2015.06.15
        NSString *isFirstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpenForClass"];
        if (isFirstOpen) {
            
        }else{
            
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
            imgV.image = [UIImage imageNamed:@"maskForClass.png"];
            imgV.userInteractionEnabled = YES;
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            
            [appDelegate.tabBarController.view addSubview:imgV];
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImgView)];
            singleTouch.delegate = self;
            [imgV addGestureRecognizer:singleTouch];
        }
        
}

// 蒙版消失
-(void)dismissImgView{
    
    [imgV removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOpenForClass"];
    
}*/

//----add by  kate 2015.06.26---------------
-(void)isConnected{
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        status = @"0";
        
        if (!networkVC) {
            
            networkVC = [[networkBar alloc] init];
            topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
            topBar = networkVC.view;
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
            singleTouch.delegate = self;
            [topBar addGestureRecognizer:singleTouch];
            
            
            if (_tableView.tableHeaderView) {
                
                _headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _headView.frame.size.height+40.0);
                [_headView addSubview:topBar];
                
                if ([isNumber integerValue] == 0){
                    _unbindBar.frame = CGRectMake(_unbindBar.frame.origin.x, _unbindBar.frame.origin.y+topBar.frame.size.height, _unbindBar.frame.size.width, _unbindBar.frame.size.height);
                    
                }else{
                     _openSpaceBar.frame = CGRectMake(_openSpaceBar.frame.origin.x, _openSpaceBar.frame.origin.y+topBar.frame.size.height, _openSpaceBar.frame.size.width, _openSpaceBar.frame.size.height);
                    NSLog(@"y:%f",_openSpaceBar.frame.origin.y);
                }
               
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y+40.0, _baseView.frame.size.width, _baseView.frame.size.height);
                
                _tableView.tableHeaderView = _headView;//1
                
            }else{
                
                _tableView.hidden = NO;
                _tableView.tableHeaderView = topBar;
            }
            
        }else{
            
            if ([_fromName isEqualToString:@"tab"]) {
                
                //if (_tableView.tableHeaderView){
                    
                    if ([isNumber integerValue] == 0) {
                       [self addUnbindBar];
                    }else{
                        [self addOpenSpaceBar];
                    }
                    
                //}else{
                    
                //    int a=1;
                //}
            }
            
        }
        
    }else{
        
        networkVC = nil;
       [topBar removeFromSuperview];
        
        if ([status isEqualToString:@"0"]) {
            
            status = @"1";
            
            if (_tableView.tableHeaderView == topBar) {
                [self getMyclassInfo];
            }else{
                _headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _headView.frame.size.height-40.0);
                
                if ([isNumber integerValue] == 0){
                    
                     _unbindBar.frame = CGRectMake(_unbindBar.frame.origin.x, _unbindBar.frame.origin.y-topBar.frame.size.height, _unbindBar.frame.size.width, _unbindBar.frame.size.height);
                    
                }else{
                    _openSpaceBar.frame = CGRectMake(_openSpaceBar.frame.origin.x, _openSpaceBar.frame.origin.y-topBar.frame.size.height, _openSpaceBar.frame.size.width, _openSpaceBar.frame.size.height);
                }
                
                _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y -40.0, _baseView.frame.size.width, _baseView.frame.size.height);
                if (_baseView.frame.origin.y > 40) {
                   _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y -40.0, _baseView.frame.size.width, _baseView.frame.size.height); 
                }
                _tableView.tableHeaderView = _headView;//2
                
            }
        }
        
    }
    
}
//去网络设置引导页
-(void)gotoNetworkGuide{
    
    NetworkGuideViewController *networkGVC = [[NetworkGuideViewController alloc]init];
    [self.navigationController pushViewController:networkGVC animated:YES];
}

- (IBAction)closeUnbindBar:(id)sender {
    
    NSLog(@"y:%f",_baseView.frame.origin.y);
    NSLog(@"frame:%f",_baseView.frame.size.height);
    
    if (_baseView.frame.origin.y > 0 &&  _baseView.frame.size.height > 104.0) {
        _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y-40.0, _baseView.frame.size.width, _baseView.frame.size.height-40.0);
    }
    
    [_unbindBar removeFromSuperview];
    
    NSLog(@"head y:%f",_headView.frame.origin.y);
    NSLog(@"head frame:%f",_headView.frame.size.height);
    
    if ([Utilities isConnected]) {
        _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, _baseView.frame.size.height);
        _tableView.tableHeaderView = _headView;

    }else{
        
        _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, _headView.frame.size.height -40.0);
        _tableView.tableHeaderView = _headView;

        
    }
    
}

- (void)closeSpaceBar{
    
    NSLog(@"y:%f",_baseView.frame.origin.y);
    NSLog(@"frame:%f",_baseView.frame.size.height);
    
    if (_baseView.frame.origin.y > 0 &&  _baseView.frame.size.height > 104.0) {
        _baseView.frame = CGRectMake(0.0, _baseView.frame.origin.y-40.0, _baseView.frame.size.width, _baseView.frame.size.height-40.0);
    }
    
    [_openSpaceBar removeFromSuperview];
    
    NSLog(@"head y:%f",_headView.frame.origin.y);
    NSLog(@"head frame:%f",_headView.frame.size.height);
    
    if ([Utilities isConnected]) {
        _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, _baseView.frame.size.height);
        _tableView.tableHeaderView = _headView;
        
    }else{
        
        _headView.frame =CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, _headView.frame.size.height -40.0);
        _tableView.tableHeaderView = _headView;
        
        
    }
    
}

// 点击未绑定学籍黄条去绑定页
- (IBAction)gotoBindView:(id)sender {
    
    if ([spaceForClass integerValue] == 1) {
        
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
        
        
        [MyTabBarController setTabBarHidden:YES];
        
        SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
        setPVC.viewType = @"classDetail";
        setPVC.cId = _cId;
        setPVC.iden = iden;
        [self.navigationController pushViewController:setPVC animated:YES];

    }else{
        
        
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        
        NSURL *url = [NSURL URLWithString:unbindIntroduceUrl];
        fileViewer.webType = SWLoadURl;
        fileViewer.url = url;
        fileViewer.isShowSubmenu = @"0";
        [self.navigationController pushViewController:fileViewer animated:YES];
        
    }
 
}

// 点击黄条进入成长空间
- (IBAction)gotoSpace:(id)sender {

    NSString *mid  = [NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:spaceIndex] objectForKey:@"id"]];
    NSString *spaceStatus =[NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:spaceIndex] objectForKey:@"space"] objectForKey:@"status"]];
    NSString *trial = [NSString stringWithFormat:@"%@",[[[displayArray objectAtIndex:spaceIndex] objectForKey:@"space"] objectForKey:@"trial"]];//2015.12.21
    NSString *growthInfo = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:spaceIndex] objectForKey:@"trial"]]];
    NSLog(@"growthInfo:%@",growthInfo);
    
    if ([spaceStatus integerValue] == 0 && [trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
        [self gotoPayView:spaceUrl status:spaceStatus trial:trial];
    }else{
        [self gotoGrowthSpace:spaceUrl status:spaceStatus mid:mid trial:trial growthInfo:growthInfo];
    }
    
     [MyTabBarController setTabBarHidden:YES];

}

// 点击问号进入了解什么事成长空间
- (IBAction)gotoIntroduce:(id)sender {
    
    [ReportObject event:ID_OPEN_SPACE_INTRO];
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:spaceUrl];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    fileViewer.isShowSubmenu = @"0";
    [self.navigationController pushViewController:fileViewer animated:YES];
    
    
}

- (void)isNeedShowMasking{
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"growthTeacherLisrMasking"];
    
    if (nil == mask) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"growthTeacherLisrMasking"];
        [[NSUserDefaults standardUserDefaults]synchronize];
       
        if ([spaceForClass integerValue] == 1) {
            
            if (iPhone4) {
                [self showMaskingView:CGRectMake(110.0, 394.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/growthTeacherLisrFor4"] isSpaceForClass:spaceForClass];
            }else {
                [self showMaskingView:CGRectMake(110.0, 394.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/growthTeacherLisr"] isSpaceForClass:spaceForClass];
            }
        }else{
            
            if (iPhone4) {
                [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/growthTeacherLisrFor4Unbind"] isSpaceForClass:spaceForClass];
            }else {
                [self showMaskingView:CGRectMake(110.0, 394.0-40.0-20.0, 100.90, 40.0) image:[UIImage imageNamed:@"Masking/growthTeacherLisrUnbind"] isSpaceForClass:spaceForClass];
            }
        }
       
    }
}

- (void)showMaskingView:(CGRect )rect image:(UIImage *)img isSpaceForClass:(NSString*)spaceForClass{
    
        _viewMasking = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIImageView *imageViewMasking = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [imageViewMasking setImage:img];
        [_viewMasking addSubview:imageViewMasking];
        
        UIButton *buttonMasking = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMasking.frame = rect;
        //buttonMasking.backgroundColor = [UIColor redColor];
        [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
        [_viewMasking addSubview:buttonMasking];
        
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewMasking];
}

- (IBAction)dismissMaskingView:(id)sender {
    _viewMasking.hidden = YES;
}

@end

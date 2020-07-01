//
//  ClassMainViewController.m
//  MicroSchool
//
//  Created by kate on 3/11/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "ClassMainViewController.h"
#import "HomeWorkClassSelectViewController.h"
#import "ScheduleDetailViewController.h"
#import "ScheduleViewController.h"
#import "NewsViewController.h"
#import "FRNetPoolUtils.h"
#import "ClassDiscussViewController.h"
#import "ApplyAddClassViewController.h"
#import "EditClassInfoViewController.h"
#import "MemberListViewController.h"
#import "SetAdminMemberListViewController.h"

@interface ClassMainViewController ()
- (IBAction)PressColorBtn:(id)sender;
- (IBAction)goToPublic:(id)sender;
- (IBAction)gotoHomework:(id)sender;
- (IBAction)gotoSchedule:(id)sender;
- (IBAction)gotoClassmate:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *publicBtn;
@property (retain, nonatomic) IBOutlet UIButton *homeworkBtn;
@property (retain, nonatomic) IBOutlet UIButton *scheduleBtn;
@property (retain, nonatomic) IBOutlet UILabel *classInfo;
@property (retain, nonatomic) IBOutlet UIImageView *publicImgView;
@property (retain, nonatomic) IBOutlet UIImageView *homeworkImgView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UILabel *introLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headImgView;
@property (retain, nonatomic) IBOutlet UILabel *firstLesson;
@property (retain, nonatomic) IBOutlet UILabel *secondeLesson;
@property (retain, nonatomic) IBOutlet UILabel *thirdLesson;
@property (retain, nonatomic) IBOutlet UILabel *fourthLesson;
@property (retain, nonatomic) IBOutlet UILabel *fifthLesson;
@property (retain, nonatomic) IBOutlet UILabel *sixthLesson;
@property (retain, nonatomic) IBOutlet UILabel *seventhLesson;
@property (retain, nonatomic) IBOutlet UILabel *eighthLesson;
@property (retain, nonatomic) IBOutlet UILabel *nighthLesson;
@property (retain, nonatomic) IBOutlet UILabel *TenthLesson;
@property (retain, nonatomic) IBOutlet UILabel *classMateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *firstHead;
@property (retain, nonatomic) IBOutlet UIImageView *secondHead;
@property (retain, nonatomic) IBOutlet UIImageView *thirdHead;
@property (retain, nonatomic) IBOutlet UIImageView *fourthHead;
@property (retain, nonatomic) IBOutlet UILabel *dateLine;
@property (retain, nonatomic) IBOutlet UILabel *weekIndexLab;
@property (retain, nonatomic) IBOutlet UIView *BottemView;
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *homworkTitle;
@property (retain, nonatomic) IBOutlet UILabel *homeworkDetail;
@property (retain, nonatomic) IBOutlet UILabel *homeWorkTimes;
@property (retain, nonatomic) IBOutlet UILabel *homeworkCountT;
@property (retain, nonatomic) IBOutlet UILabel *classNameLab;

@end

@implementation ClassMainViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomizeTitle:_titleName];
    iconNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(38, 2, 9, 9)];
    iconNoticeImgV.image = [UIImage imageNamed:@"icon_notice"];
    
    iconHNoticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(38, 2, 9, 9)];
    iconHNoticeImgV.image = [UIImage imageNamed:@"icon_notice"];

    //network = [NetworkUtility alloc];
    //network.delegate = self;
    [super setCustomizeLeftButton];
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    mask = [LoadingMask alloc];
    maskView = [mask initLoadingMask];
    [self.view addSubview:maskView];
    
    [self getMyclassInfo];
    //[self performSelectorInBackground:@selector(getMyclassmateInfo) withObject:nil];
    
    _BottemView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    

    [self setCustomizeRightButton:@"icon_more.png"];
        
    [g_userInfo setUserCid:_cId];

}

-(void)selectRightAction:(id)sender
{
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    // 课表
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height)];
        //UIView * mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        //mask.backgroundColor =[UIColor clearColor];
        //mask.opaque = NO;
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
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
        [button_search setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
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
        [button_multiSend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
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
        [button_setAdmin setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
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
        
        [button_addFriend setTitle:@"退出班级" forState:UIControlStateNormal];
        [button_addFriend setTitle:@"退出班级" forState:UIControlStateHighlighted];
        
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
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
    [self.navigationController pushViewController:memberV animated:YES];
    
}

// 退出班级
-(void)quitFromClass{
    
    [self dismissKeyboard:nil];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"您确定要退出该班级？"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消",nil];
    alert.tag = 122;
    [alert show];
    
    
}

-(void)quit{
    
    // 调用退出班级接口
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils quitFromClass:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            
            if (msg != nil) {
                
                [Utilities showAlert:nil message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                //-----add by kate for beck----------------------------------
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                [userDetail setObject:@"0" forKey:@"role_cid"];
                
                //-----------------------------------------------------------

                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 122) {
        
        if (buttonIndex == 0) {
            
            [self quit];
            
        }else{
            
        }
    }
    
}

-(void)updateUI{
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size = CGSizeMake(286.0, 200000.0f);
    size = [_classInfo.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    float height =  _classInfo.frame.size.height;
    if (size.height > 57) {
        [_classInfo setFrame:CGRectMake(20, 133, size.width, size.height+30)];
        height =  _classInfo.frame.size.height;
        [_headView setFrame:CGRectMake(0, 0, 320.0, _headView.frame.size.height+height)];
        [_BottemView setFrame:CGRectMake(0, 133+height, 320.0,_BottemView.frame.size.height)];
        
    }
    
    if (IS_IPHONE_5) {
        CGSize size = CGSizeMake(320, _scrollView.frame.size.height+height-85.0+30);
        if (size.height > 373.0) {
            _scrollView.contentSize = size;
        }
    } else {
        CGSize size = CGSizeMake(320, _scrollView.frame.size.height+68+height+30);
        _scrollView.contentSize = size;
    }
}

-(void)dealloc{
    
    [_classInfo release];
    [_publicImgView release];
    [_homeworkImgView release];
    [_timeLabel release];
    [_countLabel release];
    [_introLabel release];
    [_headImgView release];
    [_firstLesson release];
    [_secondeLesson release];
    [_thirdLesson release];
    [_fourthLesson release];
    [_fifthLesson release];
    [_sixthLesson release];
    [_seventhLesson release];
    [_eighthLesson release];
    [_nighthLesson release];
    [_TenthLesson release];
    [_classMateLabel release];
    [_firstHead release];
    [_secondHead release];
    [_thirdHead release];
    [_fourthHead release];
    [_dateLine release];
    [_weekIndexLab release];
    [iconNoticeImgV release];
    [iconHNoticeImgV release];
    //[super dealloc];
}

-(void)checkNewInfo{
    
   // [self.view addSubview:maskView];
    NSString *homeMoudel = [[NSUserDefaults standardUserDefaults]objectForKey:@"homeworkName"];
    NSString *classMoudel = [[NSUserDefaults standardUserDefaults]objectForKey:@"classPublic"];
    
//    [self performSelectorInBackground:@selector(checkPublic:) withObject:classMoudel];
//    [self performSelectorInBackground:@selector(checkHomework:) withObject:homeMoudel];
    
    [self checkPublic:classMoudel];
    [self checkHomework:homeMoudel];
    
}
-(void)checkPublic:(NSString*)moduleStr{
    
    NSString *lastId_news = nil;
   
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    /*NSString *cid = nil;
    
    // 获取当前用户的cid
       NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
    
        if([@"1"  isEqual: usertype])
        {
            cid = [g_userInfo getUserCid];
        }
        else
        {
            cid = [userDetailInfo objectForKey:@"cid"];
        }
    
    cid = [NSString stringWithFormat:@"%@",cid];*/
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastDisIdDic"]];
    lastId_news = [tempDic objectForKey:_cId];
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int count = [FRNetPoolUtils checkClassNews:@"module" sid:G_SCHOOL_ID cid:_cId module:moduleStr lastId:lastId_news];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        //[maskView removeFromSuperview];
        if (count > 0) {
            
            [_publicImgView addSubview:iconNoticeImgV];
        }else{
            [iconNoticeImgV removeFromSuperview];
        }
        
        });
    });
    
}

-(void)checkHomework:(NSString*)moduleStr{
    
    NSString *lastId_news = nil;
   
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    /*NSString *cid = nil;
    
    // 获取当前用户的cid
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
    
    if([@"1"  isEqual: usertype])
    {
        cid = [g_userInfo getUserCid];
    }
    else
    {
        cid = [userDetailInfo objectForKey:@"cid"];
    }
    
    cid = [NSString stringWithFormat:@"%@",cid];*/
    
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastHomeIdDic"];
    lastId_news = [dic objectForKey:_cId];
    
    if ([lastId_news length] == 0) {
        lastId_news = @"0";
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       int count = [FRNetPoolUtils checkHomework:@"module" sid:G_SCHOOL_ID cid:_cId module:moduleStr lastId:lastId_news];
    //[maskView removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
        if (count > 0) {
            if([_homworkTitle.text isEqualToString:@"今日暂时还没有作业" ]){
                
            }else{
                 [_homeworkImgView addSubview:iconHNoticeImgV];
            }
           
        }else{
            [iconHNoticeImgV removeFromSuperview];
        }
        });
    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkNewInfo];// 检查new标记
    //[self updateUI];
    [self setNewsAndHomework];
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self dismissKeyboard:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    _scheduleBtn.backgroundColor = [UIColor clearColor];
    _homeworkBtn.backgroundColor = [UIColor clearColor];
    _publicBtn.backgroundColor = [UIColor clearColor];
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*-(void)getMyclassmateInfo{
    
    //getMyClassInfo
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *uid= [user objectForKey:@"uid"];
    NSString *cid = nil;
    
    // 获取当前用户的cid
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
    
    if([@"1"  isEqual: usertype])
    {
        cid = [g_userInfo getUserCid];
    }
    else
    {
        cid = [userDetailInfo objectForKey:@"cid"];
    }

    NSDictionary *classmateDic = [FRNetPoolUtils getMyClassmateInfo:G_SCHOOL_ID cid:cid uid:uid];
    UIImage *firstImg = nil;
    UIImage *secondImg =nil;
    UIImage *thirdImg =nil;
    UIImage *fourthImg =nil;
    if (classmateDic!=nil) {
        
    NSArray *listArray = [classmateDic objectForKey:@"list"];
    NSString *count = [NSString stringWithFormat:@"%@",[classmateDic objectForKey:@"count"]];
    _classMateLabel.text = [NSString stringWithFormat:@"共有%@位成员",count];
    
        if ([listArray count] > 0) {
            
            NSString *head2Url = @"",*head3Url = @"",*head4Url = @"";
            
            NSDictionary *firstDic = [listArray objectAtIndex:0];
            NSString *headUrl = [firstDic objectForKey:@"avatar"];
            
            if ([listArray count] > 1) {
                NSDictionary *secondDic = [listArray objectAtIndex:1];
                head2Url = [secondDic objectForKey:@"avatar"];
                
            }
            if ([listArray count] > 2) {
                
                NSDictionary *thirdDic = [listArray objectAtIndex:2];
                head3Url = [thirdDic objectForKey:@"avatar"];
                
            }
            
            if ([listArray count] > 3) {
                NSDictionary *fourthDic = [listArray objectAtIndex:3];
                head4Url = [fourthDic objectForKey:@"avatar"];
                
            }
            
            firstImg = [FRNetPoolUtils getClassmatePic:headUrl];
            secondImg =[FRNetPoolUtils getClassmatePic:head2Url];
            thirdImg =[FRNetPoolUtils getClassmatePic:head3Url];
            fourthImg =[FRNetPoolUtils getClassmatePic:head4Url];
            
        }
        
    }
    
    firstImg = [self setDefaultImg:firstImg];
    secondImg = [self setDefaultImg:secondImg];
    thirdImg = [self setDefaultImg:thirdImg];
    fourthImg = [self setDefaultImg:fourthImg];
    
     [maskView removeFromSuperview];
    
    [self circleImage:_firstHead];
    [self circleImage:_secondHead];
    [self circleImage:_thirdHead];
    [self circleImage:_fourthHead];
    
    _firstHead.image = firstImg;
    _secondHead.image = secondImg;
    _thirdHead.image = thirdImg;
    _fourthHead.image = fourthImg;
}*/

-(UIImage*)setDefaultImg:(UIImage*)img{
    
    UIImage *image = nil;
    if (img!=nil) {
        image = img;
    }else{
        image = [UIImage imageNamed:@"bg_Cphoto.png"];
        
    }
    return image;
}

// 圆形头像
-(void)circleImage:(UIImageView*)imageV{
    
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = imageV.frame.size.height/2.0;
    
}

// 获取班级信息
-(void)getMyclassInfo{
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *uid= [user objectForKey:@"uid"];
    /*NSString *cid = nil;
    
    // 获取当前用户的cid
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
    
    if([@"1"  isEqual: usertype])
    {
        cid = [g_userInfo getUserCid];
    }
    else
    {
        cid = [userDetailInfo objectForKey:@"cid"];
    }*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    listDic = [[FRNetPoolUtils getMyClassInfo:G_SCHOOL_ID cid:_cId uid:uid] retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
    if (listDic != nil) {
        
        _weekIndexLab.text = [self getWeekIndex];
        NSDictionary *class = [listDic objectForKey:@"class"];
        _classInfo.text = [class objectForKey:@"intro"];
        joinperm = [class objectForKey:@"joinperm"];
        NSString *yeargrade = [class objectForKey:@"yeargrade"];
        NSString *name = [class objectForKey:@"tagname"];
        NSString *clasStr = [NSString stringWithFormat:@"%@级%@班", yeargrade, name];
        _classNameLab.text = clasStr;
        NSDictionary *homework = [listDic objectForKey:@"homework"];
        NSDictionary *news = [listDic objectForKey:@"news"];
        NSString *dateline = [news objectForKey:@"dateline"];
        dateline = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        _dateLine.text = dateline;
        NSDictionary *classTabel = [listDic objectForKey:@"classtable"];
            if (classTabel!=nil) {
                
                if([classTabel count] > 0){
                    
                    for (int i =1; i<10; i++) {
                        NSString *str = [NSString stringWithFormat:@"%d",i];
                        NSDictionary *lessonDic = [classTabel objectForKey:str];
                        
                        if (lessonDic!=nil) {
                            if (i == 1) {
                                _firstLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 2){
                                _secondeLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }
                            else if(i == 3){
                                _thirdLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 4){
                                _fourthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 5){
                                _fifthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 6){
                                _sixthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 7){
                                _seventhLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 8){
                                _eighthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 9){
                                _nighthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }else if(i == 10){
                                _TenthLesson.text = [lessonDic objectForKey:@"subjectname"];
                            }
                        }
                        
                    }
     
                }
            }
        
    //        NSString *introStr = [NSString stringWithFormat:@"%@", [news objectForKey:@"subject"]];
    //        if ([introStr length] == 0 || [introStr isEqualToString:@"(null)"]) {
    //            _introLabel.text = @"暂无公告";
    //            [iconNoticeImgV removeFromSuperview];
    //        }else{
    //            _introLabel.text = introStr;
    //        }
            
            if([news count] == 0){
                
                _introLabel.text = @"暂无公告";
                [iconNoticeImgV removeFromSuperview];
                _dateLine.text = @"";
                
            }else{
                
                NSString *introStr = [NSString stringWithFormat:@"%@", [news objectForKey:@"subject"]];
                _introLabel.text = introStr;
                
            }
            
            NSString *count = [NSString stringWithFormat:@"%@",[homework objectForKey:@"count"]];
            if ([count length] == 0 || [count isEqualToString:@"0"]) {
                _timeLabel.text = @"";
                _countLabel.text = @"";
                _homeworkDetail.text = @"";
                _homeWorkTimes.text = @"";
                _homworkTitle.text = @"今日暂时还没有作业";
                _homeworkCountT.text = @"";
                [iconHNoticeImgV removeFromSuperview];
            }else{
                _homworkTitle.text = @"今日预计完成时间";
                _homeworkDetail.text = @"今日共有";
                _homeworkCountT.text = @"个作业";
                 _homeWorkTimes.text = @"分钟";
                _timeLabel.text = [NSString stringWithFormat:@"%@",[homework objectForKey:@"expectedtime"]];
                _countLabel.text = [NSString stringWithFormat:@"%@",[homework objectForKey:@"count"]];
     
            }
            
        //[self performSelectorInBackground:@selector(getHeadImagePath:) withObject:cid];
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
        [self getHeadImg:_cId];
            
            // 成员信息 update by kate 2014.9.19
            NSDictionary *classmateDic = [listDic objectForKey:@"member"];;
            //        UIImage *firstImg = nil;
            //        UIImage *secondImg =nil;
            //        UIImage *thirdImg =nil;
            //        UIImage *fourthImg =nil;
            NSString *head2Url = @"";
            NSString *head3Url = @"";
            NSString *head4Url = @"";
            NSString *headUrl = @"";
            if (classmateDic!=nil) {
                
                NSArray *listArray = [classmateDic objectForKey:@"list"];
                NSString *count = [NSString stringWithFormat:@"%@",[classmateDic objectForKey:@"count"]];
                _classMateLabel.text = [NSString stringWithFormat:@"%@",count];
                
                if ([listArray count] > 0) {
                    
                    headUrl = [listArray objectAtIndex:0];
                    [_firstHead sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"bg_Cphoto.png"]];
                    
                    if ([listArray count] > 1) {
                        
                        head2Url = [listArray objectAtIndex:1];
                        [_secondHead sd_setImageWithURL:[NSURL URLWithString:head2Url] placeholderImage:[UIImage imageNamed:@"bg_Cphoto.png"]];
                        
                    }
                    if ([listArray count] > 2) {
                        
                        
                        head3Url = [listArray objectAtIndex:2];
                        [_thirdHead sd_setImageWithURL:[NSURL URLWithString:head3Url] placeholderImage:[UIImage imageNamed:@"bg_Cphoto.png"]];
                        
                    }
                    
                    if ([listArray count] > 3) {
                        
                        head4Url = [listArray objectAtIndex:3];
                        [_fourthHead sd_setImageWithURL:[NSURL URLWithString:head4Url] placeholderImage:[UIImage imageNamed:@"bg_Cphoto.png"]];
                        
                        
                    }
                    
                    //                firstImg = [FRNetPoolUtils getClassmatePic:headUrl];
                    //                secondImg =[FRNetPoolUtils getClassmatePic:head2Url];
                    //                thirdImg =[FRNetPoolUtils getClassmatePic:head3Url];
                    //                fourthImg =[FRNetPoolUtils getClassmatePic:head4Url];
                    //                
                    
                }
                
            }
            
            //        firstImg = [self setDefaultImg:firstImg];
            //        secondImg = [self setDefaultImg:secondImg];
            //        thirdImg = [self setDefaultImg:thirdImg];
            //        fourthImg = [self setDefaultImg:fourthImg];
            
            [maskView removeFromSuperview];
            
            [self circleImage:_firstHead];
            [self circleImage:_secondHead];
            [self circleImage:_thirdHead];
            [self circleImage:_fourthHead];
            
           
            
            //        _firstHead.image = firstImg;
            //        _secondHead.image = secondImg;
            //        _thirdHead.image = thirdImg;
            //        _fourthHead.image = fourthImg;

            
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"网络异常，请稍后再试"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];

        }
        });
    });
}

-(void)setNewsAndHomework{
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *uid= [user objectForKey:@"uid"];
    
    /*NSString *cid = nil;
    
    // 获取当前用户的cid
    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userDetailInfo objectForKey:@"usertype"]];
    
    if([@"1"  isEqual: usertype])
    {
        cid = [g_userInfo getUserCid];
    }
    else
    {
        cid = [userDetailInfo objectForKey:@"cid"];
    }*/
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        listDic = [[FRNetPoolUtils getMyClassInfo:G_SCHOOL_ID cid:_cId uid:uid] retain];
        
         dispatch_async(dispatch_get_main_queue(), ^{
             
            if (listDic != nil) {
                
                if([listDic count] > 0){
                    
                    NSDictionary *homework = [listDic objectForKey:@"homework"];
                    NSDictionary *news = [listDic objectForKey:@"news"];
                    
                    if([news count] == 0){
                        
                        _introLabel.text = @"暂无公告";
                        [iconNoticeImgV removeFromSuperview];
                        
                    }else{
                       
                        NSString *introStr = [NSString stringWithFormat:@"%@", [news objectForKey:@"subject"]];
                        _introLabel.text = introStr;
                        
                    }
                  
                    NSString *count = [NSString stringWithFormat:@"%@",[homework objectForKey:@"count"]];
                    if ([count length] == 0 || [count isEqualToString:@"0"]) {
                        _timeLabel.text = @"";
                        _countLabel.text = @"";
                        _homeworkDetail.text = @"";
                        _homeWorkTimes.text = @"";
                        _homworkTitle.text = @"今日暂时还没有作业";
                        _homeworkCountT.text = @"";
                        [iconHNoticeImgV removeFromSuperview];
                    }else{
                        _homworkTitle.text = @"今日预计完成时间";
                        _homeworkDetail.text = @"今日共有";
                        _homeworkCountT.text = @"个作业";
                        _homeWorkTimes.text = @"分钟";
                        _timeLabel.text = [NSString stringWithFormat:@"%@",[homework objectForKey:@"expectedtime"]];
                        _countLabel.text = [NSString stringWithFormat:@"%@",[homework objectForKey:@"count"]];
                        
                    }
         
                }
                
                
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"网络异常，请稍后再试"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
         });
     });
}


// update by kate 2014.9.20
-(void)getHeadImg:(NSString*)cid{
    
    NSDictionary *class = [listDic objectForKey:@"class"];
    if (class!=nil) {
        NSString *headImagUrl = [class objectForKey:@"pic"];
        //if ([headImagUrl length] > 0) {
            
            _headImgView.layer.masksToBounds = YES;
            _headImgView.layer.cornerRadius = _headImgView.frame.size.height/2.0;

            [_headImgView setImageWithURL:[NSURL URLWithString:headImagUrl] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
            
            //            NSString *tempUrl = [headImagUrl substringFromIndex:[headImagUrl length]-4];
            //            tempUrl = [tempUrl substringToIndex:1];
            //            if ([tempUrl isEqualToString:@"."]) {
            //                [FRNetPoolUtils getPicWithUrl:headImagUrl picType:0 userid:[cid longLongValue] msgid:0];
            //
            //                NSString *myImagePath = [Utilities getHeadImagePath:[cid longLongValue]];
            //                if ([[NSFileManager defaultManager] fileExistsAtPath:myImagePath]) {
            //                    UIImage *myHeadImage = [UIImage imageWithContentsOfFile:myImagePath];
            //
            //                    [self circleImage:_headImgView];
            //                    if (myHeadImage) {
            //
            //                        _headImgView.image = myHeadImage;
            //                    }
            //
            //                }else{
            //                    _headImgView.image = [UIImage imageNamed:@"bg_Cphoto.png"];
            //                }
            //                
            //            }
            
       // }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PressColorBtn:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    button.backgroundColor = [UIColor lightGrayColor];
    button.alpha = 0.4;
}

- (IBAction)goToPublic:(id)sender {
    
    //_publicBtn.backgroundColor = [UIColor lightGrayColor];
    //_publicBtn.alpha = 0.4;
    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
    self.cId = _cId;
    [self.navigationController pushViewController:cladddisV animated:YES];
    cladddisV.title = @"班级公告";
    
}

- (IBAction)gotoHomework:(id)sender {
    
    //_homeworkBtn.backgroundColor = [UIColor lightGrayColor];
    //_homeworkBtn.alpha = 0.4;
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    // 判断当前用户类别，1为老师，0为学生，2为家长
   
    //NSString *class = [user objectForKey:@"class"];
    
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
                HomeworkViewController *homeworkViewCtrl = [[HomeworkViewController alloc] init];
                [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
                homeworkViewCtrl.title = @"作业";
            //}
        }
    }
    else
    {
//        if ([@""  isEqual: class]) {
//            [self.view makeToast:@"还未加入任何班级，无法查看作业."
//                        duration:0.5
//                        position:@"center"
//                           title:nil];
//        } else {
            HomeworkViewController *homeworkViewCtrl = [[HomeworkViewController alloc] init];
            [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
            homeworkViewCtrl.title = @"作业";
//        }
    }
}

- (IBAction)gotoSchedule:(id)sender {
    
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
                
                [self.navigationController pushViewController:scheduleViewCtrl animated:YES];
           
        }
    }
    else
    {

            ScheduleDetailViewController *scheduleViewCtrl = [[ScheduleDetailViewController alloc] init];
            scheduleViewCtrl.classid = _cId;
            
            [self.navigationController pushViewController:scheduleViewCtrl animated:YES];
            scheduleViewCtrl.title = @"课表详细";
       
    }
    
}

- (IBAction)gotoClassmate:(id)sender
{
    // 通讯录
    // 获取当前用户的uid
    //NSDictionary *userD = [g_userInfo getUserDetailInfo];
    //NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"usertype"]];
    
//    NSString *cid;
//    if([@"1"  isEqual: usertype])
//    {
//        cid = [g_userInfo getUserCid];
//    }
//    else
//    {
//        cid = [userD objectForKey:@"cid"];
//    }
    
    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
    friendViewCtrl.classid = _cId;
    
    [self.navigationController pushViewController:friendViewCtrl animated:YES];
}


-(NSString*)getWeekIndex{
    
    NSDate*date = [NSDate date];
    NSString *weekStr = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
       
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
             weekStr = @"星期一";
            break;
        case 3:
             weekStr = @"星期二";
            break;
        case 4:
             weekStr = @"星期三";
            break;
        case 5:
             weekStr = @"星期四";
            break;
        case 6:
             weekStr = @"星期五";
            break;
        case 7:
             weekStr = @"星期六";
            break;
        default:
            break;
    }
   
    return weekStr;
}

@end

//
//  ClassMainViewController.m
//  MicroSchool
//
//  Created by kate on 3/11/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "ClassMainViewController2.h"
#import "HomeWorkClassSelectViewController.h"
#import "ScheduleDetailViewController.h"
#import "NewsViewController.h"
#import "FRNetPoolUtils.h"
#import "ClassDiscussViewController.h"
#import "ApplyAddClassViewController.h"
#import "EditClassInfoViewController.h"
#import "MemberListViewController.h"
#import "SetAdminMemberListViewController.h"
#import "ClassDetailViewController.h"
#import "MicroSchoolAppDelegate.h"

#import "SetPersonalViewController.h"

@interface ClassMainViewController2 ()
@property (strong, nonatomic) IBOutlet UIView *lineVFir;
@property (strong, nonatomic) IBOutlet UIView *lineVSec;

@property (strong, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addClass:(id)sender;

//- (IBAction)gotoClassmate:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *publicBtn;
@property (strong, nonatomic) IBOutlet UIButton *memberBtn;
@property (retain, nonatomic) IBOutlet UILabel *classInfo;
@property (retain, nonatomic) IBOutlet UIImageView *publicImgView;



@property (retain, nonatomic) IBOutlet UILabel *introLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headImgView;

@property (retain, nonatomic) IBOutlet UILabel *classMateLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLine;

@property (retain, nonatomic) IBOutlet UIView *BottemView;
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UILabel *classNameLab;

@property (strong, nonatomic) IBOutlet UIImageView *iconImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;//用于三行显示的note
@property (strong, nonatomic) IBOutlet UILabel *descriptionLab;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;//用于两行显示的note


@property (strong, nonatomic) IBOutlet UIImageView *iconImgVForMate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabForMate;
@property (strong, nonatomic) IBOutlet UILabel *detailLabForMate;//用于三行显示的note
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabForMate;
@property (strong, nonatomic) IBOutlet UILabel *noteLabelForMate;//用于两行显示的note
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImgV;

@end

@implementation ClassMainViewController2

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
    
    isRightButtonClicked = false;
    
    _backgroundImgV.image = [UIImage imageNamed:@"moments/bg_photo1.png"];
    
    [self getMyclassInfo];
   
    [g_userInfo setUserCid:_cId];
    
    displayArray = [[NSMutableArray alloc]init];
    
    _classInfo.textColor = [UIColor grayColor];
    _detailLabForMate.textColor = [UIColor grayColor];//用于三行显示的note
    _descriptionLabForMate.textColor = [UIColor grayColor];
    _noteLabelForMate.textColor = [UIColor grayColor];//用于两行显示的note
    _detailLab.textColor = [UIColor grayColor];//用于三行显示的note
    _descriptionLab.textColor = [UIColor grayColor];
    _noteLabel.textColor = [UIColor grayColor];//用于两行显示的note
    
    //-----add 2015.05.05----------------------------------------------------------------------
    schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    if ([@"primary" isEqualToString:schoolType] || [@"junior" isEqualToString:schoolType] || [@"technical" isEqualToString:schoolType] || [@"senior" isEqualToString:schoolType] || [@"university" isEqualToString:schoolType] || [@"kindergarten" isEqualToString:schoolType]) {
         [_addBtn setTitle:@"班级列表" forState:UIControlStateNormal];
    }else{
        [_addBtn setTitle:@"加入" forState:UIControlStateNormal];
    }
    _lineVFir.hidden = YES;
    _lineVSec.hidden = YES;
    //-----------------------------------------------------------------------------------------

    [ReportObject event:ID_OPEN_CLASS_DETAIL];// 2015.06.24
    
    if ([@"1"  isEqual: [NSString stringWithFormat:@"%@", _applied]]) {
        _addBtn.hidden = YES;
    }
}

//****************************************************************************************


-(void)updateUI{
    
//    UIFont *font = [UIFont systemFontOfSize:15.0];
//    CGSize size = CGSizeMake(286.0, 200000.0f);
//    size = [_classInfo.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    float height =  _classInfo.frame.size.height;
//    if (size.height > 57) {
//        [_classInfo setFrame:CGRectMake(20, 133, size.width, size.height+30)];
//        height =  _classInfo.frame.size.height;
//        [_headView setFrame:CGRectMake(0, 0, 320.0, _headView.frame.size.height+height)];
//        [_BottemView setFrame:CGRectMake(0, 133+height, 320.0,_BottemView.frame.size.height)];
//        
//    }
    
    if (IS_IPHONE_5) {
        CGSize size = CGSizeMake(WIDTH, _scrollView.frame.size.height+height-85.0+30);
        if (size.height > 373.0) {
            _scrollView.contentSize = size;
        }
    } else {
        
        CGSize size = CGSizeMake(WIDTH, _scrollView.frame.size.height+68+height+30);
        _scrollView.contentSize = size;
        _addBtn.frame = CGRectMake(10,127+50, 300, 40);
        
    }
    
    for (int i =0; i<[displayArray count]; i++) {
        
        NSString *iconImgUrl = [[displayArray objectAtIndex:i] objectForKey:@"icon"];
        NSString *title = [[displayArray objectAtIndex:i] objectForKey:@"name"];
        NSString *detail = [[[[displayArray objectAtIndex:i] objectForKey:@"note"] objectAtIndex:0] objectForKey:@"label"];
        NSString *description = [[[[displayArray objectAtIndex:i] objectForKey:@"extra"] objectAtIndex:0] objectForKey:@"label"];
        int type  = [[NSString stringWithFormat:@"%@",[[displayArray objectAtIndex:i] objectForKey:@"type"]] intValue];
        
        if (i == 0) {
            
            [_iconImgV sd_setImageWithURL:[NSURL URLWithString:iconImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
            
            if ([description length] == 0) {
                _titleLab.text = title;
                _detailLab.text = @"";
                _descriptionLab.text = @"";
                _noteLabel.text = detail;
            }else{
                _titleLab.text = title;
                _detailLab.text = detail;
                if (type == 14) {//班级公告
                    _detailLab.textColor = [UIColor colorWithRed:26.0/255.0 green:127.0/255.0 blue:207.0/255.0 alpha:1];
                }else{
                    _detailLab.textColor = [UIColor lightGrayColor];
                }
                _descriptionLab.text = description;
                _noteLabel.text = @"";
            }
            
        }else{
            
            [_iconImgVForMate sd_setImageWithURL:[NSURL URLWithString:iconImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
            if ([description length] == 0) {
                _titleLabForMate.text = title;
                _detailLabForMate.text = @"";
                _descriptionLabForMate.text = @"";
                _noteLabelForMate.text = detail;
            }else{
                _titleLabForMate.text = title;
                _detailLabForMate.text = detail;
                if (type == 14) {//班级公告
                    _detailLabForMate.textColor = [UIColor colorWithRed:26.0/255.0 green:127.0/255.0 blue:207.0/255.0 alpha:1];
                }else{
                    _detailLabForMate.textColor = [UIColor lightGrayColor];
                }
                _descriptionLabForMate.text = description;
                _noteLabelForMate.text = @"";
            }
            
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
   
    _publicBtn.backgroundColor = [UIColor clearColor];
    
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取班级信息
-(void)getMyclassInfo{
    
    [Utilities showProcessingHud:self.view];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        listDic = [FRNetPoolUtils getMyclassDetail:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];;
            
            if (listDic != nil) {
                
                NSDictionary *class = [listDic objectForKey:@"profile"];
                if (class!=nil) {
                    if ([class count]!=0) {
                        
                        NSString *headImagUrl = [class objectForKey:@"pic"];
//                        _headImgView.layer.masksToBounds = YES;
//                        _headImgView.layer.cornerRadius = _headImgView.frame.size.height/2.0;
                        
                        [_headImgView sd_setImageWithURL:[NSURL URLWithString:headImagUrl] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
                        _classInfo.text = [class objectForKey:@"intro"];
                        joinperm = [class objectForKey:@"joinperm"];
                        NSString *clasStr = [class objectForKey:@"tagname"];
                        _classNameLab.text = clasStr;
                        NSMutableArray *tempArray = [listDic objectForKey:@"modules"];
                        
                        
                       
                        for (int i=0; i<[tempArray count]; i++) {
                            
                            NSString *type = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"type"]]];
                            
                            if ([type intValue] == 14) {
                                [displayArray addObject:[tempArray objectAtIndex:i]];
                            }else if ([type intValue] == 18){
                                [displayArray addObject:[tempArray objectAtIndex:i]];
                            }
                            
                        }
                        //--- add by kate 2-15.05.06----------------
                        if ([displayArray count] > 0) {
                            _lineVFir.hidden = NO;
                            if ([displayArray count] > 1) {
                                _lineVSec.hidden = NO;
                            }
                        }
                        //-------------------------------------------
                        
                        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
                        
                        
                    }
                }
                
            }else{
                
                [Utilities dismissProcessingHud:self.view];
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

//- (IBAction)goToPublic:(id)sender {
//    
//    //_publicBtn.backgroundColor = [UIColor lightGrayColor];
//    //_publicBtn.alpha = 0.4;
//    ClassDiscussViewController *cladddisV = [[ClassDiscussViewController alloc]init];
//    [self.navigationController pushViewController:cladddisV animated:YES];
//    cladddisV.title = @"班级公告";
//    
//}

//- (IBAction)gotoClassmate:(id)sender 
//{
//    // 通讯录
//    // 获取当前用户的uid
//    /*NSDictionary *userD = [g_userInfo getUserDetailInfo];
//     NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"usertype"]];
//    
//     NSString *cid;
//    if([@"1"  isEqual: usertype])
//    {
//        cid = [g_userInfo getUserCid];
//    }
//    else
//    {
//        cid = [userD objectForKey:@"cid"];
//    }*/
//    
//    PhonebookViewController *friendViewCtrl = [[PhonebookViewController alloc] init];
//    //friendViewCtrl.classid = cid;// 修改cid update by kate 2014.09.18
//    friendViewCtrl.classid = _cId;
//    [self.navigationController pushViewController:friendViewCtrl animated:YES];
//    
//}

// 加入班级接口
-(void)joinClass{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //NSString *result = [FRNetPoolUtils applyAddClass:_cId reason:@""];
        NSDictionary *result = [FRNetPoolUtils addClass:_cId reason:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (result) {
                
                NSDictionary *messageInfo = [result objectForKey:@"message"];
                
                if([[result objectForKey:@"result"] integerValue]==1 ){
                    
                    if ([[messageInfo objectForKey:@"cid"] integerValue] == 0) {
                        
                    }else{
                        [self refreshMyClass];
                    }
                    
                }else{
                    
                    resultCid = [messageInfo objectForKey:@"cid"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:[messageInfo objectForKey:@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    alert.tag = 230;
                    [alert show];
                    
                }
            }else{
                [Utilities showAlert:@"提示" message:@"网络连接错误，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        });
        
    });

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 230) {
        if ([resultCid integerValue]!=0) {
            _cId = resultCid;
            [self refreshMyClass];
        }
    }
}

// 加入班级
- (IBAction)addClass:(id)sender {

        NSDictionary *userInfo = [g_userInfo getUserDetailInfo];
        NSString *usertype = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];
        // 原来接口 1为老师，0为学生，2为家长
        
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
        
        if ([usertype intValue] == 9 || [usertype intValue] == 2) {
            
            //调用加入班级接口 加入成功刷新该页
            [self joinClass];
            
        }else{//将老师变为同学生老师一样的权限 2015.05.05
            if ([joinperm intValue] == 0) {// 0 允许任何人加入
                
                //调用加入班级接口 加入成功刷新该页
                [self joinClass];
                
            }else if ([joinperm intValue] == 1){// 1 需消息验证
                
                

#if 9
                ApplyAddClassViewController *addClassV = [[ApplyAddClassViewController alloc]init];
                addClassV.cId = _cId;
                addClassV.className = _titleName;
                [self.navigationController pushViewController:addClassV animated:YES];
#endif
            }else if([joinperm intValue] == 2){// 2 只可邀请加入
                
                if ([@"bureau" isEqualToString:schoolType]){
                    [Utilities showAlert:@"错误" message:@"本部门限制加入，请联系部门管理员" cancelButtonTitle:@"确定" otherButtonTitle:nil];// update 2015.05.11
                }else{
                    [Utilities showAlert:@"错误" message:@"本班限制加入，请联系班级管理员" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }
                
                
                
            }
            
        }
    //}
    
   
}

// 刷新我的班级
-(void)refreshMyClass{
    
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
    NSLog(@"userType:%@",userType);
    if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                              animated:YES];
    }else
    {
        [userDetail setObject:_classNameLab.text forKey:@"role_classname"];
        [userDetail setObject:_cId forKey:@"role_cid"];
        
        [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                              animated:YES];
        ClassDetailViewController  *myClass = [[ClassDetailViewController alloc]init];
        myClass.fromName = @"tab";
        myClass.cId = _cId;
        myClass.hidesBottomBarWhenPushed = YES;
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
        [array replaceObjectAtIndex:1 withObject:customizationNavi];
        [appDelegate.tabBarController setViewControllers:array];
        
        
    }

}

@end
